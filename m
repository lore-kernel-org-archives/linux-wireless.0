Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48524 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbXKTRTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 12:19:11 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] mac80211: hardware scan rework (V2)
Date: Tue, 20 Nov 2007 09:17:47 -0800
Message-ID: <33E1C72C74DBE747B7B59C1740F74437027F30D4@orsmsx417.amr.corp.intel.com> (sfid-20071120_171917_007376_E50B0EFE)
In-Reply-To: <1195566632.10920.39.camel@johannes.berg>
References: <119553601948-git-send-email-yi.zhu@intel.com> <1195566632.10920.39.camel@johannes.berg>
From: "Abbas, Mohamed" <mohamed.abbas@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu, Yi" <yi.zhu@intel.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes
The firmware will go back to the old setting, the ones before scan, once
done scanning by it self. The calls by mac80211 after scan complete to
set channel will be ignored by the iwl driver if we still tuned to the
same channel, iwl wont call firmware on the same setting, it has to be a
change to call down to firmware. I need to check what happen if user
change channel during scan, this call might be necessary in this case.
Mohamed

-----Original Message-----
From: Johannes Berg [mailto:johannes@sipsolutions.net] 
Sent: Tuesday, November 20, 2007 5:51 AM
To: Zhu, Yi
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; Abbas,
Mohamed; Cahill, Ben M
Subject: Re: [PATCH] mac80211: hardware scan rework (V2)

Hi,

Thanks!

> 1. fix a hw scan bug in ieee80211_rx_bss_info() for setting beacon
>    supported rates
> 2. let control frames pass in ieee80211_sta_rx_scan() during hw scan
> 3. set local->sta_{hw|sw}_scanning type to bool
> 4. avoid channel setting during hw scan

Why this? I was confused at first and I'm sorry if I confused you, but
since we're now fully unaware of hardware scan thanks to your item 5, I
think we need to allow setting channel during hardware scan so the
firmware will change to the right channel once it finished scanning.

> 5. rework ieee80211_scan_completed() to make it symmetric for hw scan


> diff --git a/net/mac80211/ieee80211_sta.c
b/net/mac80211/ieee80211_sta.c
> index 015b3f8..26f404a 100644
> --- a/net/mac80211/ieee80211_sta.c
> +++ b/net/mac80211/ieee80211_sta.c
> @@ -1487,8 +1487,18 @@ static void ieee80211_rx_bss_info(struct
net_device *dev,
>  		u32 supp_rates, prev_rates;
>  		int i, j;
>  
> -		mode = local->sta_scanning ?
> +		mode = local->sta_sw_scanning ?
>  		       local->scan_hw_mode : local->oper_hw_mode;
> +
> +		if (local->sta_hw_scanning) {
> +			/* search for the correct mode matches the
beacon */
> +			list_for_each_entry(mode, &local->modes_list,
list)
> +				if (mode->mode == rx_status->phymode)
> +					break;
> +
> +			if (mode == NULL)
> +				mode = local->oper_hw_mode;
> +		}

Good catch.

> @@ -1985,7 +2003,7 @@ void ieee80211_sta_work(struct work_struct
*work)
>  	if (!netif_running(dev))
>  		return;
>  
> -	if (local->sta_scanning)
> +	if (local->sta_sw_scanning || local->sta_hw_scanning)
>  		return;

Shouldn't the sta work be able to run normally while hw scan is in
progress?
 
> -	if (unlikely(local->sta_scanning != 0)) {
> -		ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status);
> +	if (unlikely(local->sta_hw_scanning))
> +		return ieee80211_sta_rx_scan(rx->dev, skb,
rx->u.rx.status);
> +
> +	if (unlikely(local->sta_sw_scanning)) {
> +		/* drop all the other packets during a software scan
anyway */
> +		if (ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status)
> +		    != TXRX_QUEUED)
> +			dev_kfree_skb(skb);

Not entirely sure why we do this, but nothing we should change with this
patch.

Other than the ioctl thing it looks good to me.

johannes
