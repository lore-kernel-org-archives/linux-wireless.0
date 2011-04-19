Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42013 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab1DSOLG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 10:11:06 -0400
Received: by pwi15 with SMTP id 15so2766679pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 07:11:05 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19885.39048.530052.347984@gargle.gargle.HOWL>
Date: Tue, 19 Apr 2011 19:43:28 +0530
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH V2 04/22] ath9k_hw: Configure pll control register accordingly for AR9340
In-Reply-To: <1303221560-25139-5-git-send-email-vasanth@atheros.com>
References: <1303221560-25139-1-git-send-email-vasanth@atheros.com>
	<1303221560-25139-5-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan wrote:
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/hw.c  |   52 ++++++++++++++++++++++++++++++++--
>  drivers/net/wireless/ath/ath9k/hw.h  |    2 +-
>  drivers/net/wireless/ath/ath9k/phy.h |    3 ++
>  drivers/net/wireless/ath/ath9k/reg.h |    4 ++-
>  4 files changed, 56 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index 8c0364f..013ffba 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -714,15 +714,48 @@ static void ath9k_hw_init_pll(struct ath_hw *ah,
>  			      AR_CH0_BB_DPLL2_PLL_PWD, 0x0);
>  		udelay(1000);
>  
> -		REG_RMW_FIELD(ah, AR_CH0_BB_DPLL3,
> -			      AR_CH0_DPLL3_PHASE_SHIFT, DPLL3_PHASE_SHIFT_VAL);

Should this be removed ?

Sujith
