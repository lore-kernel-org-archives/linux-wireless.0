Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53219 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYLQSWu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 13:22:50 -0500
Subject: Re: [RFC] Handle Channel Switch Announcement
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	jouni.malinen@atheros.com
In-Reply-To: <18761.4838.509784.281821@localhost.localdomain> (sfid-20081217_155745_335359_22B180E6)
References: <18761.4838.509784.281821@localhost.localdomain>
	 (sfid-20081217_155745_335359_22B180E6)
Content-Type: text/plain
Date: Wed, 17 Dec 2008 19:07:52 +0100
Message-Id: <1229537272.4268.7.camel@localhost> (sfid-20081217_192253_754908_A8F4FCCC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-17 at 20:25 +0530, Sujith wrote:

> + * @IEEE80211_CHAN_CSA_DISABLED: Disabled because a
> +	Channel Switch Announcement was received on this channel.

I agree with Jouni, this is probably not a good idea, especially since
this flag would be shared between hardware for those drivers that have
the channel structs allocated statically. We should probably just stick
a struct ieee80211_channel *switch_from; pointer somewhere into the
sdata struct or so.

> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -1612,6 +1612,13 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
>  				return RX_DROP_MONITOR;
>  			ieee80211_process_measurement_req(sdata, mgmt, len);
>  			break;
> +		case WLAN_ACTION_SPCT_CHL_SWITCH:
> +			if (len < (IEEE80211_MIN_ACTION_SIZE +
> +				   sizeof(mgmt->u.action.u.chan_switch)))
> +				return RX_DROP_MONITOR;
> +			ieee80211_process_chanswitch(sdata,
> +				     &mgmt->u.action.u.chan_switch.sw_elem);

I think I'd like to have them dropped to monitor for !station here,
instead of silently in the processing function.

> +
> +void ieee80211_chswitch_timer(unsigned long data)
> +{
> +	struct ieee80211_bss *bss;
> +	struct ieee80211_sub_if_data *sdata =
> +		(struct ieee80211_sub_if_data *) data;
> +	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
> +
> +	printk("expire\n");

That should probably be removed or be more specific & protected by some
debug #ifdef.

> +void ieee80211_process_chanswitch(struct ieee80211_sub_if_data *sdata,
> +				  struct ieee80211_channel_sw_ie *sw_elem)


> +	} else {
> +		ieee80211_stop_queues(&sdata->local->hw);

Can you rebase this on top of Kalle's patch that adds the "stop reasons"
for each queue? As it is now, the driver could wake up the queues again
if one was full.

johannes

