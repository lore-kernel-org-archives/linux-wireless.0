Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:59711 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab3LROvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 09:51:44 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix iflist_mtx/mtx locking in radar detection
Date: Wed, 18 Dec 2013 15:51:40 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
References: <1387358026-25741-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1387358026-25741-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201312181551.40786.sw@simonwunderlich.de> (sfid-20131218_155147_420774_661A80FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Johannes Berg <johannes.berg@intel.com>
> 
> The scan code creates an iflist_mtx -> mtx locking dependency,
> and a few other places, notably radar detection, were creating
> the opposite dependency, causing lockdep to complain. As scan
> and radar detection are mutually exclusive, the deadlock can't
> really happen in practice, but it's still bad form.
> 
> A similar issue exists in the monitor mode code, but this is
> only used by channel-context drivers right now and those have
> to have hardware scan, so that also can't happen.
> 
> Still, fix these issues by making some of the channel context
> code require the mtx to be held rather than acquiring it, thus
> allowing the monitor/radar callers to keep the iflist_mtx->mtx
> lock ordering.
> 
> While at it, also fix access to the local->scanning variable
> in the radar code, and document that radar_detect_enabled is
> now properly protected by the mtx.
> 
> Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

There are two little issues (see below). Otherwise this appears to fix the 
problem Kalle reported, at least I can now scan and start hostap (using ath9k) 
without getting this lockdep splat. If you want, add my Tested-by or Acked-by. 

> @@ -1944,8 +1951,10 @@ static int ieee80211_join_mesh(struct wiphy *wiphy,
> struct net_device *dev, sdata->smps_mode = IEEE80211_SMPS_OFF;
>  	sdata->needed_rx_chains = sdata->local->rx_chains;
> 
> +	mutex_lock(&local->mtx);
>  	err = ieee80211_vif_use_channel(sdata, &setup->chandef,
>  					IEEE80211_CHANCTX_SHARED);
> +	mutex_unlock(&local->mtx);
>  	if (err)
>  		return err;

local is not defined in ieee80211_join_mesh().

> 
> @@ -1957,7 +1966,9 @@ static int ieee80211_leave_mesh(struct wiphy *wiphy,
> struct net_device *dev) struct ieee80211_sub_if_data *sdata =
> IEEE80211_DEV_TO_SUB_IF(dev);
> 
>  	ieee80211_stop_mesh(sdata);
> +	mutex_lock(&local->mtx);
>  	ieee80211_vif_release_channel(sdata);
> +	mutex_unlock(&local->mtx);
> 
>  	return 0;
>  }

Same problem here.

Thanks!
    Simon

