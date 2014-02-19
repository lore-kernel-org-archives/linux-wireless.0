Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:40068 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaBSLvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 06:51:07 -0500
Received: by mail-bk0-f47.google.com with SMTP id d7so169493bkh.34
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 03:51:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392804045-11258-7-git-send-email-luca@coelho.fi>
References: <1392804045-11258-1-git-send-email-luca@coelho.fi>
	<1392804045-11258-7-git-send-email-luca@coelho.fi>
Date: Wed, 19 Feb 2014 12:51:05 +0100
Message-ID: <CA+BoTQ=ZAgOd0suPiTy_6SP6OzGsMcicv_f+foqBUCrL91NU5g@mail.gmail.com> (sfid-20140219_125111_333565_B4576A76)
Subject: Re: [PATCH 6/7] cfg80211/mac80211: move interface counting for
 combination check to mac80211
From: Michal Kazior <michal.kazior@tieto.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de, Bing Zhao <bzhao@marvell.com>,
	arend@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 February 2014 11:00, Luciano Coelho <luca@coelho.fi> wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
>
> Move the counting part of the interface combination check from
> cfg80211 to mac80211.
>
> This is needed to simplify locking when the driver has to perform a
> combination check by itself (eg. with channel-switch).
>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---

[...]

> @@ -520,6 +521,23 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
>         WARN_ON(sdata->dev && netif_carrier_ok(sdata->dev));
>
>         mutex_lock(&local->chanctx_mtx);
> +
> +       radar_detect_width = cfg80211_chandef_dfs_required(local->hw.wiphy,
> +                                                          chandef,
> +                                                          sdata->vif.type);
> +       if (radar_detect_width < 0) {
> +               ret = radar_detect_width;
> +               goto out;
> +       }
> +
> +       sdata->radar_required = !!(radar_detect_width);
> +
> +       ret = ieee80211_check_combinations(local->hw.wiphy, &sdata->wdev,
> +                                          chandef, IEEE80211_CHANCTX_SHARED,
> +                                          radar_detect_width);
> +       if (ret < 0)
> +               goto out;
> +

Shouldn't you be using `mode` function argument instead of
IEEE80211_CHANCTX_SHARED?


Michał
