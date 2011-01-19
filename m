Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61161 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab1ASP5d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 10:57:33 -0500
Received: by pva4 with SMTP id 4so172355pva.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 07:57:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110119092052.19628.61933.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
	<20110119092052.19628.61933.stgit@localhost6.localdomain6>
Date: Wed, 19 Jan 2011 17:57:32 +0200
Message-ID: <AANLkTin9+XB7Oy32j8K=x5rNNgRqSJOFvH-DF1PSGRCF@mail.gmail.com>
Subject: Re: [PATCH 4/8] ath5k: ath5k_setup_channels cleanup and whitespace
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/19 Bruno Randolf <br1@einfach.org>:
> Remove useless test_bit - it's not going to happen because of the way this
> function is called only when that bit is set.
>
> And fix some whitespace.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/base.c |   11 +++--------
>  1 files changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 9e8b1f4..a28ad58 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -256,21 +256,16 @@ static bool ath5k_is_standard_channel(short chan)
>  }
>
>  static unsigned int
> -ath5k_setup_channels(struct ath5k_hw *ah,
> -               struct ieee80211_channel *channels,
> -               unsigned int mode,
> -               unsigned int max)
> +ath5k_setup_channels(struct ath5k_hw *ah, struct ieee80211_channel *channels,
> +               unsigned int mode, unsigned int max)
>  {
>        unsigned int count, size, chfreq, freq, ch;
>        enum ieee80211_band band;
>
> -       if (!test_bit(mode, ah->ah_modes))
> -               return 0;
> -
>        switch (mode) {
>        case AR5K_MODE_11A:
>                /* 1..220, but 2GHz frequencies are filtered by check_channel */
> -               size = 220 ;
> +               size = 220;
>                chfreq = CHANNEL_5GHZ;
>                band = IEEE80211_BAND_5GHZ;
>                break;
>


Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
