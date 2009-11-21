Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:6218 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbZKUJBO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Nov 2009 04:01:14 -0500
Received: by ey-out-2122.google.com with SMTP id 4so605790eyf.19
        for <linux-wireless@vger.kernel.org>; Sat, 21 Nov 2009 01:01:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911192302.05229.8an@praha12.net>
References: <200911192302.05229.8an@praha12.net>
Date: Sat, 21 Nov 2009 11:01:19 +0200
Message-ID: <40f31dec0911210101i7c141a61jd4e66f43a2bbade9@mail.gmail.com>
Subject: Re: [PATCH] ath5k: Fix I/Q calibration
From: Nick Kossifidis <mickflemm@gmail.com>
To: 8an@praha12.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/11/20 Lukáš Turek <8an@praha12.net>:
> The sign of correction coefficients was lost in the calculations, which
> caused high packetloss in 802.11a mode after the results were applied.
> Fixed by removing unneccesary and broken AND with a bit mask.
>
> Signed-off-by: Lukas Turek <8an@praha12.net>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
> index 8959907..6af0a73 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1399,7 +1399,7 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
>        if (i_coffd == 0 || q_coffd == 0)
>                goto done;
>
> -       i_coff = ((-iq_corr) / i_coffd) & 0x3f;
> +       i_coff = ((-iq_corr) / i_coffd);
>
>        /* Boundary check */
>        if (i_coff > 31)
> @@ -1407,7 +1407,7 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
>        if (i_coff < -32)
>                i_coff = -32;
>
> -       q_coff = (((s32)i_pwr / q_coffd) - 128) & 0x1f;
> +       q_coff = (((s32)i_pwr / q_coffd) - 128);
>
>        /* Boundary check */
>        if (q_coff > 15)
> --
> 1.6.4.4


Acked-by: Nick Kossifidis <mickflemm@gmail.com>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
