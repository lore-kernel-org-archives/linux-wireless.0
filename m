Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:35725 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3LPAQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 19:16:45 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21166.17733.484576.337560@gargle.gargle.HOWL> (sfid-20131216_011648_605655_12AB3B67)
Date: Mon, 16 Dec 2013 05:41:49 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Fix interrupt handling for the AR9002 family
In-Reply-To: <52AE0EC1.4050706@openwrt.org>
References: <1387030293-7928-1-git-send-email-sujith@msujith.org>
	<52AE0D63.9090309@openwrt.org>
	<52AE0EC1.4050706@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> This change on top of it should fix the interrupt storms (which were
> observed on AR913x):
> ---
> --- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
> @@ -133,6 +133,11 @@ static bool ar9002_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
>  		*masked |= mask2;
>  	}
>  
> +	if (!(pCap->hw_caps & ATH9K_HW_CAP_RAC_SUPPORTED)) {
> +		REG_WRITE(ah, AR_ISR, isr);
> +		REG_READ(ah, AR_ISR);
> +	}
> +
>  	if (AR_SREV_9100(ah))
>  		return true;

Thanks, I'll send a revised version.

Sujith
