Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbaBUIq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:46:57 -0500
Message-ID: <1392972409.4346.34.camel@jlt4.sipsolutions.net> (sfid-20140221_094727_375276_3B9AAFFD)
Subject: Re: [PATCH v3 6/7] cfg80211/mac80211: move interface counting for
 combination check to mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Fri, 21 Feb 2014 09:46:49 +0100
In-Reply-To: <1392906986-12275-7-git-send-email-luca@coelho.fi>
References: <1392906986-12275-1-git-send-email-luca@coelho.fi>
	 <1392906986-12275-7-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 16:36 +0200, Luciano Coelho wrote:

> @@ -2928,13 +2927,17 @@ static int ieee80211_start_radar_detection(struct wiphy *wiphy,
>  	/* whatever, but channel contexts should not complain about that one */
>  	sdata->smps_mode = IEEE80211_SMPS_OFF;
>  	sdata->needed_rx_chains = local->rx_chains;
> -	sdata->radar_required = true;
>  
>  	err = ieee80211_vif_use_channel(sdata, chandef,
>  					IEEE80211_CHANCTX_SHARED);
>  	if (err)
>  		goto out_unlock;
>  
> +	/* Something is wrong if cfg80211 asked us to start radar
> +	 * detection but we don't think we need to.
> +	 */
> +	WARN_ON(!sdata->radar_required);

Might that happen for regdomain changes? Or simply if userspace asks for
radar detection without really needing it?

> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -3949,6 +3949,13 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
>  	u16 auth_alg;
>  	int err;
>  
> +	/* TODO: in cfg80211_mlme_auth() we used to check if the
> +	 * channel can be used *before* this function was called.  Do
> +	 * we still need to do it or can we rely on the combinations
> +	 * check that will happen later, in
> +	 * ieee80211_vif_use_channel()?
> +	 */

We'll do it a few lines down in ieee80211_prep_connection(), so I don't
see why we'd need to do it earlier?

> @@ -4103,6 +4110,13 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
>  	const u8 *ssidie, *ht_ie, *vht_ie;
>  	int i, err;
>  
> +	/* TODO: in cfg80211_mlme_assoc() we used to check if the
> +	 * channel can be used *before* this function was called.  Do
> +	 * we still need to do it or can we rely on the combinations
> +	 * check that will happen later, in
> +	 * ieee80211_vif_use_channel()?
> +	 */

ditto

> +int ieee80211_check_combinations(struct wiphy *wiphy,
> +				 struct wireless_dev *wdev,
> +				 const struct cfg80211_chan_def *chandef,
> +				 enum ieee80211_chanctx_mode chanmode,
> +				 u8 radar_detect)

Why do you pass a wiphy here? In mac80211 we use local or hw except for
API, and this isn't called from cfg80211? Same for 'wdev' vs. 'sdata'?

> +	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +		wdev_iter = &sdata->wdev;
> +		if (wdev_iter == wdev)
> +			continue;
> +		if (wdev_iter->iftype == NL80211_IFTYPE_P2P_DEVICE) {
> +			if (!wdev_iter->p2p_started)
> +				continue;
> +		} else if (wdev_iter->netdev) {
> +			if (!netif_running(wdev_iter->netdev))
> +				continue;

That should probably be combined to sdata_running(), but shouldn't it
also only be done if the interface is actually doing something (e.g. has
joined an IBSS, ...), i.e. has a channel context assigned?

> +++ b/net/wireless/core.h
> @@ -406,6 +406,9 @@ cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
>  			      struct wireless_dev *wdev,
>  			      enum nl80211_iftype iftype)
>  {
> +	/* TODO: For this function, we'll probably need to keep some
> +	 * kind of interface combination check in cfg80211...
> +	 */
>  	return cfg80211_can_use_iftype_chan(rdev, wdev, iftype, NULL,
>  					    CHAN_MODE_UNDEFINED, 0);
>  }

We could always jsut request the change from the driver/mac80211.

> @@ -426,6 +429,10 @@ cfg80211_can_use_chan(struct cfg80211_registered_device *rdev,
>  		      struct ieee80211_channel *chan,
>  		      enum cfg80211_chan_mode chanmode)
>  {
> +	/* TODO: for libertas, we probably need to move the
> +	 * combination check into that driver if we get rid of the
> +	 * cfg80211_can_use_chan() function.
> +	 */
>  	return cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
>  					    chan, chanmode, 0);
>  }

That doesn't even have combinations, I believe?

johannes

