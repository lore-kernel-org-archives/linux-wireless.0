Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59657 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab1ASLIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 06:08:09 -0500
Received: by qwa26 with SMTP id 26so696481qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 03:08:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110119092047.19628.99228.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
	<20110119092047.19628.99228.stgit@localhost6.localdomain6>
Date: Wed, 19 Jan 2011 06:08:08 -0500
Message-ID: <AANLkTi=aFnRvX1vdoB9egVAas6zMgkyQVwpzfH0N=4+2@mail.gmail.com>
Subject: Re: [PATCH 3/8] ath5k: Rename ath5k_copy_channels
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 19, 2011 at 4:20 AM, Bruno Randolf <br1@einfach.org> wrote:
> Rename ath5k_copy_channels() to ath5k_setup_channels() - nothing is copied
> here.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 0387acb..9e8b1f4 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -256,7 +256,7 @@ static bool ath5k_is_standard_channel(short chan)
>  }
>
>  static unsigned int
> -ath5k_copy_channels(struct ath5k_hw *ah,
> +ath5k_setup_channels(struct ath5k_hw *ah,
>                struct ieee80211_channel *channels,
>                unsigned int mode,
>                unsigned int max)
> @@ -356,7 +356,7 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
>                sband->n_bitrates = 12;
>
>                sband->channels = sc->channels;
> -               sband->n_channels = ath5k_copy_channels(ah, sband->channels,
> +               sband->n_channels = ath5k_setup_channels(ah, sband->channels,
>                                        AR5K_MODE_11G, max_c);
>
>                hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
> @@ -382,7 +382,7 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
>                }
>
>                sband->channels = sc->channels;
> -               sband->n_channels = ath5k_copy_channels(ah, sband->channels,
> +               sband->n_channels = ath5k_setup_channels(ah, sband->channels,
>                                        AR5K_MODE_11B, max_c);
>
>                hw->wiphy->bands[IEEE80211_BAND_2GHZ] = sband;
> @@ -402,7 +402,7 @@ ath5k_setup_bands(struct ieee80211_hw *hw)
>                sband->n_bitrates = 8;
>
>                sband->channels = &sc->channels[count_c];
> -               sband->n_channels = ath5k_copy_channels(ah, sband->channels,
> +               sband->n_channels = ath5k_setup_channels(ah, sband->channels,
>                                        AR5K_MODE_11A, max_c);
>
>                hw->wiphy->bands[IEEE80211_BAND_5GHZ] = sband;
>

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com
