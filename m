Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36566 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab1AYM0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 07:26:07 -0500
Received: by pva4 with SMTP id 4so851630pva.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 04:26:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295929904-11806-2-git-send-email-me@bobcopeland.com>
References: <1295929904-11806-1-git-send-email-me@bobcopeland.com>
	<1295929904-11806-2-git-send-email-me@bobcopeland.com>
Date: Tue, 25 Jan 2011 14:26:06 +0200
Message-ID: <AANLkTin5=Ngpf8LvKHO3OeYDyEC6V+Bi0Ptdey62LMur@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath5k: correct endianness of frame duration
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Bruno Randolf <br1@einfach.org>, jirislaby@gmail.com,
	lrodriguez@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/25 Bob Copeland <me@bobcopeland.com>:
> The ath5k version of ieee80211_generic_frame_duration() returns
> an __le16 for standard modes but a cpu-endian int for turbo/half/
> quarter rates.  Make it always return cpu-endian values.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath/ath5k/pcu.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
> index e5f2b96..a702817 100644
> --- a/drivers/net/wireless/ath/ath5k/pcu.c
> +++ b/drivers/net/wireless/ath/ath5k/pcu.c
> @@ -86,7 +86,7 @@ int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
>        if (!ah->ah_bwmode) {
>                dur = ieee80211_generic_frame_duration(sc->hw,
>                                                NULL, len, rate);
> -               return dur;
> +               return le16_to_cpu(dur);
>        }
>
>        bitrate = rate->bitrate;
> @@ -265,8 +265,6 @@ static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah)
>                 * what rate we should choose to TX ACKs. */
>                tx_time = ath5k_hw_get_frame_duration(ah, 10, rate);
>
> -               tx_time = le16_to_cpu(tx_time);
> -
>                ath5k_hw_reg_write(ah, tx_time, reg);
>
>                if (!(rate->flags & IEEE80211_RATE_SHORT_PREAMBLE))
> --
> 1.7.1.1

Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
