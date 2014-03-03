Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:59975 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbaCCPRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 10:17:05 -0500
Message-ID: <1393859821.13669.119.camel@dubbel> (sfid-20140303_161730_801669_E6CE6528)
Subject: Re: [PATCH v7 3/5] cfg80211/mac80211: move interface counting for
 combination check to mac80211
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Date: Mon, 03 Mar 2014 17:17:01 +0200
In-Reply-To: <1393492497-29500-4-git-send-email-luca@coelho.fi>
References: <1393492497-29500-1-git-send-email-luca@coelho.fi>
	 <1393492497-29500-4-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-27 at 11:14 +0200, Luca Coelho wrote:
> diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
> index 42c6592..2e537eb 100644
> --- a/net/mac80211/chan.c
> +++ b/net/mac80211/chan.c
> @@ -513,6 +513,7 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
>  {
>  	struct ieee80211_local *local = sdata->local;
>  	struct ieee80211_chanctx *ctx;
> +	u8 radar_detect_width;
>  	int ret;
>  
>  	lockdep_assert_held(&local->mtx);
> @@ -520,6 +521,22 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
>  	WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
>  
>  	mutex_lock(&local->chanctx_mtx);
> +
> +	radar_detect_width = cfg80211_chandef_dfs_required(local->hw.wiphy,
> +							   chandef,
> +							   sdata->vif.type);
> +	if (radar_detect_width < 0) {
> +		ret = radar_detect_width;
> +		goto out;
> +	}
> +
> +	sdata->radar_required = radar_detect_width;
> +
> +	ret = ieee80211_check_combinations(sdata, chandef, mode,
> +					   radar_detect_width);
> +	if (ret < 0)
> +		goto out;

I screwed up here during my interactive rebase to make
cfg80211_chandef_dfs_required() return 0 or 1 again.  I should pass the
chandef's width to ieee80211_check_combinations() if radar detection is
required.

I'll send a v8 later today. *sigh*

--
Luca.

