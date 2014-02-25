Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:52939 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBYHt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 02:49:27 -0500
Received: by mail-bk0-f45.google.com with SMTP id mz13so105933bkb.18
        for <linux-wireless@vger.kernel.org>; Mon, 24 Feb 2014 23:49:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393275270-7255-5-git-send-email-luca@coelho.fi>
References: <1393275270-7255-1-git-send-email-luca@coelho.fi>
	<1393275270-7255-5-git-send-email-luca@coelho.fi>
Date: Tue, 25 Feb 2014 08:49:25 +0100
Message-ID: <CA+BoTQkJ4A25jMaT1335URu36eNzFTjT+N0sxZaw9Pph8qT=5w@mail.gmail.com> (sfid-20140225_084930_602421_4E101B3A)
Subject: Re: [PATCH v4 4/4] cfg80211/mac80211: move combination check to
 mac80211 for ibss
From: Michal Kazior <michal.kazior@tieto.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de, Bing Zhao <bzhao@marvell.com>,
	arend@broadcom.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 February 2014 21:54, Luciano Coelho <luca@coelho.fi> wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
>
> Now that mac80211 can check the interface combinations itself, move
> the combinations check from cfg80211 to mac80211 when joining an IBSS.
>
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---
> In v2:
>
>    * lock the chanctx mutex in ieee80211_ibss_join() before calling
>      ieee80211_check_combinations(). (Thanks Michal);
>
>    * pass the mode argument instead of IEEE80211_CHANCTX_SHARED to
>      ieee80211_check_combinations() in ieee80211_vif_use_channel();
>
> In v3:
>
>    * moved the second change from v2 (pass the mode argument...) to
>      the previous patch, where it should be;
>
> In v4:
>
>    * rebased on top of slightly modified applied patches
> ---
>  net/mac80211/ibss.c | 30 +++++++++++++++++++++++++++---
>  net/wireless/ibss.c | 28 ----------------------------
>  2 files changed, 27 insertions(+), 31 deletions(-)
>
> diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
> index bca7d09..745b445 100644
> --- a/net/mac80211/ibss.c
> +++ b/net/mac80211/ibss.c
> @@ -1643,7 +1643,31 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
>         u32 changed = 0;
>         u32 rate_flags;
>         struct ieee80211_supported_band *sband;
> +       enum ieee80211_chanctx_mode chanmode;
> +       struct ieee80211_local *local = sdata->local;
> +       int radar_detect_width;
>         int i;
> +       int ret;
> +
> +       radar_detect_width = cfg80211_chandef_dfs_required(local->hw.wiphy,
> +                                                          &params->chandef,
> +                                                          sdata->vif.type);
> +       if (radar_detect_width < 0)
> +               return radar_detect_width;
> +
> +       if (radar_detect_width > 0 && !params->userspace_handles_dfs)
> +               return -EINVAL;
> +
> +       chanmode = (params->channel_fixed && !radar_detect_width) ?
> +               IEEE80211_CHANCTX_SHARED : IEEE80211_CHANCTX_EXCLUSIVE;
> +
> +       mutex_lock(&local->chanctx_mtx);
> +       ret = ieee80211_check_combinations(local->hw.wiphy, &sdata->wdev,
> +                                          &params->chandef, chanmode,
> +                                          radar_detect_width);

I think you forgot to update this call - you should be passing `local`
and `sdata` here, no?


Michał
