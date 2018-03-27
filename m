Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:60272 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbeC0MxH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 08:53:07 -0400
Message-ID: <1522155185.3050.7.camel@sipsolutions.net> (sfid-20180327_145311_288382_EE3C1655)
Subject: Re: [RFC 1/4] mac80211: Add NoAck policy functionality offload
 infrastructure
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Mar 2018 14:53:05 +0200
In-Reply-To: <1522140171-10926-2-git-send-email-vthiagar@codeaurora.org>
References: <1522140171-10926-1-git-send-email-vthiagar@codeaurora.org>
         <1522140171-10926-2-git-send-email-vthiagar@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-03-27 at 14:12 +0530, Vasanthakumar Thiagarajan wrote:
> 
> + * @IEEE80211_HW_SUPPORTS_NOACK_POLICY: Hardware (or driver) manages noack
> + *	policy handling. Hardware (or driver) takes care of setting
> + *	noack policy in the qos header and does not wait for the ack based
> + *	on the noack TID map. Driver advertising this support must implement
> + *	callback @set_noack_tid_bitmap to receive the user configured noack TID
> + *	bitmap.

Do you really need the ops method and the flag?

> +	int (*set_noack_tid_bitmap)(struct ieee80211_hw *hw,
> +				    struct ieee80211_vif *vif, u8 noack_map);

You'd safe some effort by reordering the nl80211 patch first, so you can
immediately introduce it with per-peer capability here.

> +++ b/net/mac80211/cfg.c
> @@ -347,9 +347,15 @@ static int ieee80211_set_noack_map(struct wiphy *wiphy,
>  
>  	sdata->noack_map = noack_map;
>  
> -	ieee80211_check_fast_xmit_iface(sdata);
> +	if (!ieee80211_hw_check(&sdata->local->hw, SUPPORTS_NOACK_POLICY)) {
> +		ieee80211_check_fast_xmit_iface(sdata);
> +		return 0;
> +	}
>  
> -	return 0;
> +	if (!ieee80211_sdata_running(sdata))
> +		return 0;
> +
> +	return drv_set_noack_tid_bitmap(sdata->local, sdata, noack_map);

This doesn't seem right - you should do the fast xmit checks even if
calling the driver, no? And in fact, fast xmit should be permitted when
the noack is offloaded, so you shouldn't set sdata->noack_map in the
offloaded case at all.

> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -631,6 +631,10 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
>  				ieee80211_vif_type_p2p(&sdata->vif));
>  			if (res)
>  				goto err_del_interface;
> +
> +			if (sdata->noack_map)
> +				drv_set_noack_tid_bitmap(local, sdata,
> +							 sdata->noack_map);

Or maybe you do need to store it for this reason, but need to ignore it
for the purposes of fast-xmit if SUPPORTS_NOACK_POLICY is set.

> +++ b/net/mac80211/tx.c
> @@ -2817,7 +2817,8 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
>  	    test_sta_flag(sta, WLAN_STA_CLEAR_PS_FILT))
>  		goto out;
>  
> -	if (sdata->noack_map)
> +	if (sdata->noack_map &&
> +	    !ieee80211_hw_check(&local->hw, SUPPORTS_NOACK_POLICY))
>  		goto out;

Ah, and you do :-)

And then maybe you're indeed right and don't need to call the fast xmit
check in that place since it wouldn't have any effect either way.
 
johannes
