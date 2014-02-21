Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36102 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaBUIs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 03:48:57 -0500
Message-ID: <1392972532.4346.35.camel@jlt4.sipsolutions.net> (sfid-20140221_094900_971033_C24D9B32)
Subject: Re: [PATCH v3 7/7] cfg80211/mac80211: move combination check to
 mac80211 for ibss
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Fri, 21 Feb 2014 09:48:52 +0100
In-Reply-To: <1392906986-12275-8-git-send-email-luca@coelho.fi>
References: <1392906986-12275-1-git-send-email-luca@coelho.fi>
	 <1392906986-12275-8-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 16:36 +0200, Luciano Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Now that mac80211 can check the interface combinations itself, move
> the combinations check from cfg80211 to mac80211 when joining an IBSS.

> +++ b/net/mac80211/ibss.c
> @@ -1646,7 +1646,31 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
>  	u32 changed = 0;
>  	u32 rate_flags;
>  	struct ieee80211_supported_band *sband;
> +	enum ieee80211_chanctx_mode chanmode;
> +	struct ieee80211_local *local = sdata->local;
> +	int radar_detect_width;
>  	int i;
> +	int ret;
> +
> +	radar_detect_width = cfg80211_chandef_dfs_required(local->hw.wiphy,
> +							   &params->chandef,
> +							   sdata->vif.type);
> +	if (radar_detect_width < 0)
> +		return radar_detect_width;
> +
> +	if (radar_detect_width > 0 && !params->userspace_handles_dfs)
> +		return -EINVAL;
> +
> +	chanmode = (params->channel_fixed && !radar_detect_width) ?
> +		IEEE80211_CHANCTX_SHARED : IEEE80211_CHANCTX_EXCLUSIVE;
> +
> +	mutex_lock(&local->chanctx_mtx);
> +	ret = ieee80211_check_combinations(local->hw.wiphy, &sdata->wdev,
> +					   &params->chandef, chanmode,
> +					   radar_detect_width);
> +	mutex_unlock(&local->chanctx_mtx);
> +	if (ret < 0)
> +		return ret;

Hm, that's a lot of new code just for IBSS. Is there anything that could
be shared with other pieces of mac80211?

johannes

