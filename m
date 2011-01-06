Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39138 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab1AFVQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 16:16:52 -0500
Received: by iwn9 with SMTP id 9so16666371iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 13:16:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19749.32067.311517.479374@gargle.gargle.HOWL>
References: <19749.32067.311517.479374@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 Jan 2011 13:13:14 -0800
Message-ID: <AANLkTim9iM0rLgg5PoVJvuq7WHBnCuf4=aemKAUt3gb8@mail.gmail.com>
Subject: Re: [RFC v2] cfg80211: Add HT BSS attributes
To: Sujith <m.sujith@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jouni.Malinen@atheros.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 6, 2011 at 12:28 AM, Sujith <m.sujith@gmail.com> wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
>
> Add two new per-BSS attributes to allow configuration of
> HT capabilites and operational parameters by hostapd.
>
> Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> ---
> v2: Initialize values and set the parameters in managed mode also.

Can you split this up into two patches, one for cfg80211 and another
for mac80211?

> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 4bc8a92..f10c92b 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -1172,6 +1172,21 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
>                changed |= BSS_CHANGED_HT;
>        }
>
> +       if (params->ht_capab >= 0) {
> +               struct ieee80211_local *local = wiphy_priv(wiphy);
> +               struct ieee80211_supported_band *sband =
> +                       wiphy->bands[local->oper_channel->band];
> +
> +               sdata->vif.bss_conf.ht_capab =
> +                       (u16) (params->ht_capab & sband->ht_cap.cap);
> +               changed |= BSS_CHANGED_HT;
> +       }
> +
> +       if (params->ht_param >= 0) {
> +               sdata->vif.bss_conf.ht_param = (u8) params->ht_param;
> +               changed |= BSS_CHANGED_HT;
> +       }
> +

Also, if the values do not change why insist on the BSS_CHANGED_HT ?

  Luis
