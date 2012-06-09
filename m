Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53439 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761343Ab2FIAGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 20:06:12 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20434.37672.972394.142644@gargle.gargle.HOWL> (sfid-20120609_020617_279536_13E9C48A)
Date: Sat, 9 Jun 2012 05:34:56 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 7/9] ath9k_hw: process MCI interrupts only when btcoex is enabled
In-Reply-To: <1339177148-21672-7-git-send-email-rmanohar@qca.qualcomm.com>
References: <1339177148-21672-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1339177148-21672-7-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> let us process MCI interrupts only when BTCOEX is enabled to avoid
> processing bogus interrupts.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_mac.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> index d9e0824..1c0621d 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
> @@ -302,7 +302,8 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
>  			ar9003_hw_bb_watchdog_read(ah);
>  	}
>  
> -	if (async_cause & AR_INTR_ASYNC_MASK_MCI)
> +	if ((async_cause & AR_INTR_ASYNC_MASK_MCI) &&
> +	    ath9k_hw_mci_is_enabled(ah))
>  		ar9003_mci_get_isr(ah, masked);

I don't see how AR_INTR_ASYNC_MASK_MCI would be generated when
MCI is disabled ? So the check needs to be one level up.

Sujith
