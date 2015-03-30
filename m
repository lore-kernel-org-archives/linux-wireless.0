Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45682 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbbC3I5M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:57:12 -0400
Message-ID: <1427705830.26117.18.camel@sipsolutions.net> (sfid-20150330_105722_865644_081700AC)
Subject: Re: [PATCH] mac80211: filter multicast data packets on AP_VLAN
 interfaces w/o sta
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Mon, 30 Mar 2015 10:57:10 +0200
In-Reply-To: <1426620635-868-1-git-send-email-michael-dev@fami-braun.de>
References: <1426620635-868-1-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-17 at 20:30 +0100, Michael Braun wrote:
> Currently, multicast data packets are dropped on AP interfaces if
> there are no authorized stations connected. This avoids superflous

typo: superfluous

> data packets to be transmitted on air.
> 
> But when using AP_VLAN, this does not happen, as the current check does
> not apply to AP_VLAN interfaces. Though, there can easily be more AP_VLAN
> interfaces on an AP resulting in more multicast data frames. This is
> especially true since hostapd does not remove no-longer-used AP_VLAN
> interfaces and bridges.
> 
> In order to filter on AP_VLAN interfaces, a per AP_VLAN interface
> counter is required (in constrast to the counter on the AP interface

typo: contrast

> +		if (sta->sta_state == IEEE80211_STA_AUTHORIZED &&
> +		    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
> +		    !sta->sdata->u.vlan.sta &&
> +		    sta->sdata != vlansdata)
> +			atomic_dec(&sta->sdata->u.vlan.num_mcast_sta);
> +
> +		if (sta->sta_state == IEEE80211_STA_AUTHORIZED &&
> +		    vlansdata->vif.type == NL80211_IFTYPE_AP_VLAN &&

Hmm. Can this ever be false?

> +++ b/net/mac80211/sta_info.c
> @@ -143,6 +143,17 @@ static void __cleanup_single_sta(struct sta_info *sta)
>  		ieee80211_purge_tx_queue(&local->hw, &tid_tx->pending);
>  		kfree(tid_tx);
>  	}
> +
> +	if (test_sta_flag(sta, WLAN_STA_AUTHORIZED)) {
> +		if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
> +		    (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
> +		     !sta->sdata->u.vlan.sta))
> +			atomic_dec(&sta->sdata->bss->num_mcast_sta);
> +		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
> +		     !sta->sdata->u.vlan.sta)
> +			atomic_dec(&sta->sdata->u.vlan.num_mcast_sta);
> +		clear_sta_flag(sta, WLAN_STA_AUTHORIZED);
> +	}
>  }

The new clear_sta_flag() here seems rather wrong to me?

> @@ -1694,6 +1705,9 @@ int sta_info_move_state(struct sta_info *sta,
>  			    (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
>  			     !sta->sdata->u.vlan.sta))
>  				atomic_dec(&sta->sdata->bss->num_mcast_sta);
> +			if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
> +			     !sta->sdata->u.vlan.sta)
> +				atomic_dec(&sta->sdata->u.vlan.num_mcast_sta);
>  			clear_bit(WLAN_STA_AUTHORIZED, &sta->_flags);

> @@ -1703,6 +1717,9 @@ int sta_info_move_state(struct sta_info *sta,
>  			    (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
>  			     !sta->sdata->u.vlan.sta))
>  				atomic_inc(&sta->sdata->bss->num_mcast_sta);
> +			if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
> +			     !sta->sdata->u.vlan.sta)
> +				atomic_inc(&sta->sdata->u.vlan.num_mcast_sta);

It seems to me that perhaps we should split this into two new
subfunctions or so to be able to refactor this code? After all, you have
exactly the same conditions here ...

johannes

