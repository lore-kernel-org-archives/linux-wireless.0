Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:33995 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab0CIMQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 07:16:05 -0500
Received: by ey-out-2122.google.com with SMTP id 25so379251eya.5
        for <linux-wireless@vger.kernel.org>; Tue, 09 Mar 2010 04:16:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100309075523.30616.63612.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
	 <20100309075523.30616.63612.stgit@void>
Date: Tue, 9 Mar 2010 14:16:03 +0200
Message-ID: <40f31dec1003090416v3c88b371ld88678f83a8b644f@mail.gmail.com>
Subject: Re: [PATCH 02/13] ath5k: use fixed antenna for tx descriptors
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/9 Bruno Randolf <br1@einfach.org>:
> when using a fixed antenna we should use the antenna number in all tx
> descriptors, otherwise the hardware will sometimes send the frame out on the
> other antenna. it seems like the hardware does not always respect the default
> antenna and diversity settings (esp.  AR5K_STA_ID1_DEFAULT_ANTENNA).
>
> also i would like to note that antenna diversity does not always work correctly
> on 5414 (at least) when only one antenna is connected: for example all frames
> might be received on antenna A but still the HW tries to send on antenna B some
> times, causing packet loss.
>
> this is both verified with the antenna statistics output of the previous patch
> and a spectrum analyzer.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 72474c0..ffe253a 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1873,7 +1873,7 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
>                break;
>        case AR5K_ANTMODE_FIXED_A:
>                def_ant = 1;
> -               tx_ant = 0;
> +               tx_ant = 1;
>                use_def_for_tx = true;
>                update_def_on_tx = false;
>                use_def_for_rts = true;
> @@ -1882,7 +1882,7 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
>                break;
>        case AR5K_ANTMODE_FIXED_B:
>                def_ant = 2;
> -               tx_ant = 0;
> +               tx_ant = 2;
>                use_def_for_tx = true;
>                update_def_on_tx = false;
>                use_def_for_rts = true;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
