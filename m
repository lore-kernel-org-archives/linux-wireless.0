Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:40012 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab0ETM7D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 08:59:03 -0400
Received: by ewy8 with SMTP id 8so3005371ewy.28
        for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 05:59:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100519013137.22206.45012.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
	 <20100519013137.22206.45012.stgit@tt-desk>
Date: Thu, 20 May 2010 15:59:02 +0300
Message-ID: <AANLkTil8GZbDkVuFcedK5DR0I1fxTtCuyzEFSE89Rpl-@mail.gmail.com>
Subject: Re: [PATCH v2 11/20] ath5k: always calculate ANI listen time
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/19 Bruno Randolf <br1@einfach.org>:
> Calculate 'listen' time also when automatic ANI is off, since this and the
> "busy" time is useful information also in manual mode.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/ani.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
> index f2311ab..987e3d3 100644
> --- a/drivers/net/wireless/ath/ath5k/ani.c
> +++ b/drivers/net/wireless/ath/ath5k/ani.c
> @@ -481,14 +481,15 @@ ath5k_ani_calibration(struct ath5k_hw *ah)
>        struct ath5k_ani_state *as = &ah->ah_sc->ani_state;
>        int listen, ofdm_high, ofdm_low, cck_high, cck_low;
>
> -       if (as->ani_mode != ATH5K_ANI_MODE_AUTO)
> -               return;
> -
>        /* get listen time since last call and add it to the counter because we
> -        * might not have restarted the "ani period" last time */
> +        * might not have restarted the "ani period" last time.
> +        * always do this to calculate the busy time also in manual mode */
>        listen = ath5k_hw_ani_get_listen_time(ah, as);
>        as->listen_time += listen;
>
> +       if (as->ani_mode != ATH5K_ANI_MODE_AUTO)
> +               return;
> +
>        ath5k_ani_save_and_clear_phy_errors(ah, as);
>
>        ofdm_high = as->listen_time * ATH5K_ANI_OFDM_TRIG_HIGH / 1000;
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
