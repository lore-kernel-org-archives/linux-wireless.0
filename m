Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.232]:58072 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584AbXKWLZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 06:25:40 -0500
Received: by wx-out-0506.google.com with SMTP id h31so1538376wxd
        for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2007 03:25:39 -0800 (PST)
Message-ID: <40f31dec0711230325tf751decr1b3a0ce8af95d68d@mail.gmail.com> (sfid-20071123_112542_692564_B024887C)
Date: Fri, 23 Nov 2007 13:25:39 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 2/3] ath5k: noise calibration also for rf511x
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com
In-Reply-To: <1195815123-22375-3-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1195815123-22375-1-git-send-email-bruno@thinktube.com>
	 <1195815123-22375-2-git-send-email-bruno@thinktube.com>
	 <1195815123-22375-3-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/11/23, Bruno Randolf <bruno@thinktube.com>:
> also perform full noise calibration in ath5k_hw_rf511x_calibrate() instead of
> just writing the bit.
>
> Changes-licensed-under: ISC
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> ---
>  drivers/net/wireless/ath5k/phy.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/phy.c b/drivers/net/wireless/ath5k/phy.c
> index 9b91121..f250c2e 100644
> --- a/drivers/net/wireless/ath5k/phy.c
> +++ b/drivers/net/wireless/ath5k/phy.c
> @@ -1702,8 +1702,7 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
>                 ((u32)q_coff) | ((u32)i_coff << AR5K_PHY_IQ_CORR_Q_I_COFF_S));
>
>  done:
> -       /* Start noise floor calibration */
> -       AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL, AR5K_PHY_AGCCTL_NF);
> +       ath5k_hw_noise_floor_calibration(ah, channel->freq);
>
>         /* Request RF gain */
>         if (channel->val & CHANNEL_5GHZ) {
> --
> 1.5.3.4
>
>

Actually just writing the bit enables nf calibration, what this patch
does is that it also reads the value and check if it's ok.

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
