Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43545 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab1ASPzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 10:55:07 -0500
Received: by pwj3 with SMTP id 3so179397pwj.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 07:55:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110119092057.19628.9296.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
	<20110119092057.19628.9296.stgit@localhost6.localdomain6>
Date: Wed, 19 Jan 2011 17:55:06 +0200
Message-ID: <AANLkTinevrF_1H-L++3o20VnHo2PQXPktQY+VPa76Nvp@mail.gmail.com>
Subject: Re: [PATCH 5/8] ath5k: Add 802.11j 4.9GHz channels to allowed channels
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/19 Bruno Randolf <br1@einfach.org>:
> Add the 802.11j (20MHz channel width) channels to the allowed channels. This
> still does not enable 802.11j in ath5k since these frequencies are out of the
> configured range. A later patch will deal with that.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |   19 +++++++++++++------
>  1 files changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index a28ad58..6900543 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -244,15 +244,21 @@ static int ath5k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *re
>  /*
>  * Returns true for the channel numbers used without all_channels modparam.
>  */
> -static bool ath5k_is_standard_channel(short chan)
> +static bool ath5k_is_standard_channel(short chan, enum ieee80211_band band)
>  {
> -       return ((chan <= 14) ||
> -               /* UNII 1,2 */
> -               ((chan & 3) == 0 && chan >= 36 && chan <= 64) ||
> +       if (band == IEEE80211_BAND_2GHZ && chan <= 14)
> +               return true;
> +
> +       return  /* UNII 1,2 */
> +               (((chan & 3) == 0 && chan >= 36 && chan <= 64) ||
>                /* midband */
>                ((chan & 3) == 0 && chan >= 100 && chan <= 140) ||
>                /* UNII-3 */
> -               ((chan & 3) == 1 && chan >= 149 && chan <= 165));
> +               ((chan & 3) == 1 && chan >= 149 && chan <= 165) ||
> +               /* 802.11j 5.030-5.080 GHz (20MHz) */
> +               (chan == 8 || chan == 12 || chan == 16) ||
> +               /* 802.11j 4.9GHz (20MHz) */
> +               (chan == 184 || chan == 188 || chan == 192 || chan == 196));
>  }
>
>  static unsigned int
> @@ -291,7 +297,8 @@ ath5k_setup_channels(struct ath5k_hw *ah, struct ieee80211_channel *channels,
>                if (!ath5k_channel_ok(ah, freq, chfreq))
>                        continue;
>
> -               if (!modparam_all_channels && !ath5k_is_standard_channel(ch))
> +               if (!modparam_all_channels &&
> +                   !ath5k_is_standard_channel(ch, band))
>                        continue;
>
>                /* Write channel info and increment counter */
>


Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
