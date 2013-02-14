Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:41384 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab3BNWww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2013 17:52:52 -0500
Received: by mail-bk0-f42.google.com with SMTP id jk7so1334486bkc.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2013 14:52:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360881457-30562-1-git-send-email-johannes@sipsolutions.net>
References: <1360881457-30562-1-git-send-email-johannes@sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 14 Feb 2013 14:52:31 -0800
Message-ID: <CAG6hwVP+D0M-ww8-Joym50WPgL=TUwML3ffjgxT=Mx4q1FHZCA@mail.gmail.com> (sfid-20130214_235256_280775_B9502882)
Subject: Re: [PATCH v3] cfg80211: clean up mesh plink station change API
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, j@w1.fi,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 14, 2013 at 2:37 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Make the ability to leave the plink_state unchanged not use a
> magic -1 variable that isn't in the enum, but an explicit change
> flag; reject invalid plink states or actions and move the needed
> constants for plink actions to the right header file. Also
> reject plink_state changes for non-mesh interfaces.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 909053a..8e1a03e 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1261,7 +1261,9 @@ static int sta_apply_parameters(struct ieee80211_local *local,
>         if (ieee80211_vif_is_mesh(&sdata->vif)) {
>  #ifdef CONFIG_MAC80211_MESH
>                 u32 changed = 0;
> -               if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED) {
> +               if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED &&
> +                   (params->sta_modify_mask &
> +                                       STATION_PARAM_APPLY_PLINK_STATE)) {
>                         switch (params->plink_state) {
>                         case NL80211_PLINK_ESTAB:
>                                 if (sta->plink_state != NL80211_PLINK_ESTAB)
> @@ -1292,12 +1294,18 @@ static int sta_apply_parameters(struct ieee80211_local *local,
>                                 /*  nothing  */
>                                 break;
>                         }
> +               } else if (params->sta_modify_mask &
> +                                       STATION_PARAM_APPLY_PLINK_STATE) {
> +                       return -EINVAL;

It would make sense to disallow setting plink_action if MPM is in userspace.

-- 
Thomas
