Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39465 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2GXOrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 10:47:40 -0400
Message-ID: <1343141251.4415.39.camel@jlt3.sipsolutions.net> (sfid-20120724_164743_840219_CE4708EA)
Subject: Re: [PATCH v4] mac80211: Remove control.sta from struct
 ieee80211_tx_info and restructure tx-path
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org,
	ilw@linux.intel.com, users@rt2x00.serialmonkey.com,
	b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	chunkeey@googlemail.com, buytenh@wantstofly.org, dsd@gentoo.org,
	coelho@ti.com, nbd@openwrt.org
Date: Tue, 24 Jul 2012 16:47:31 +0200
In-Reply-To: <1343072022-1383-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120723_213356_862232_300A4FC5)
References: <1343072022-1383-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 (sfid-20120723_213356_862232_300A4FC5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-23 at 21:33 +0200, Thomas Huehn wrote:

> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -196,6 +196,8 @@ struct ieee80211_tx_data {
>  	struct ieee80211_channel *channel;
>  
>  	unsigned int flags;
> +
> +	struct ieee80211_tx_control control;

Why is this needed/useful?

>  		info->control.vif = vif;
> -		info->control.sta = sta;
> +		control->sta = sta;
>  
>  		__skb_unlink(skb, skbs);
> -		drv_tx(local, skb);
> +		drv_tx(local, control, skb);

You're assigning to it right before, and I don't see you using it any
time before, so why not just have the control struct on the stack of
this function?

That would save all this passing around:

> @@ -1253,6 +1254,7 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
>   * Returns false if the frame couldn't be transmitted but was queued instead.
>   */
>  static bool __ieee80211_tx(struct ieee80211_local *local,
> +			   struct ieee80211_tx_control *control,
>  			   struct sk_buff_head *skbs, int led_len,
>  			   struct sta_info *sta, bool txpending)
>  {
> @@ -1301,7 +1303,7 @@ static bool __ieee80211_tx(struct ieee80211_local *local,
>  		break;
>  	}
>  
> -	result = ieee80211_tx_frags(local, vif, pubsta, skbs,
> +	result = ieee80211_tx_frags(local, vif, pubsta, control, skbs,
>  				    txpending);
>  
>  	ieee80211_tpt_led_trig_tx(local, fc, led_len);
> @@ -1409,7 +1411,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
>  			sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
>  
>  	if (!invoke_tx_handlers(&tx))
> -		result = __ieee80211_tx(local, &tx.skbs, led_len,
> +		result = __ieee80211_tx(local, &tx.control, &tx.skbs, led_len,
>  					tx.sta, txpending);
>   out:
>  	rcu_read_unlock();
> @@ -2154,6 +2156,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
>  	struct ieee80211_sub_if_data *sdata;
>  	struct sta_info *sta;
>  	struct ieee80211_hdr *hdr;
> +	struct ieee80211_tx_control control;
>  	bool result;
>  
>  	sdata = vif_to_sdata(info->control.vif);
> @@ -2169,7 +2172,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
>  		hdr = (struct ieee80211_hdr *)skb->data;
>  		sta = sta_info_get(sdata, hdr->addr1);
>  
> -		result = __ieee80211_tx(local, &skbs, skb->len, sta, true);
> +		result = __ieee80211_tx(local, &control, &skbs, skb->len, sta, true);
>  	}
>  
>  	return result;


johannes

