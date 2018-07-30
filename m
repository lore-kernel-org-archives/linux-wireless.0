Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43460 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731288AbeG3Tnk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 15:43:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 3/9] ath9k: force rx_clear when disabling rx
References: <20180723160300.58024-1-nbd@nbd.name>
        <20180723160300.58024-3-nbd@nbd.name>
Date: Mon, 30 Jul 2018 21:07:24 +0300
In-Reply-To: <20180723160300.58024-3-nbd@nbd.name> (Felix Fietkau's message of
        "Mon, 23 Jul 2018 18:02:54 +0200")
Message-ID: <87y3dsk36r.fsf@purkki.adurom.net> (sfid-20180730_200732_416623_191B1D49)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> From: Felix Fietkau <nbd@openwrt.org>
>
> This makes stopping Rx more reliable and should reduce the frequency of
> Rx related DMA stop warnings. Don't use rx_clear in TX99 mode.
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
>  drivers/net/wireless/ath/ath9k/mac.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
> index 58d02c19b6d0..c9d2bf3fa135 100644
> --- a/drivers/net/wireless/ath/ath9k/mac.c
> +++ b/drivers/net/wireless/ath/ath9k/mac.c
> @@ -678,13 +678,18 @@ void ath9k_hw_startpcureceive(struct ath_hw *ah, bool is_scanning)
>  
>  	ath9k_ani_reset(ah, is_scanning);
>  
> -	REG_CLR_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
> +	REG_CLR_BIT(ah, AR_DIAG_SW,
> +		    AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT | AR_DIAG_FORCE_RX_CLEAR);
>  }
>  EXPORT_SYMBOL(ath9k_hw_startpcureceive);
>  
>  void ath9k_hw_abortpcurecv(struct ath_hw *ah)
>  {
> -	REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_RX_ABORT | AR_DIAG_RX_DIS);
> +	u32 reg = AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT;
> +
> +	if (!IS_ENABLED(CPTCFG_ATH9K_TX99))
> +		reg |= AR_DIAG_FORCE_RX_CLEAR;
> +	REG_SET_BIT(ah, AR_DIAG_SW, reg);

CPTCFG_ prefix is obviously wrong, so I'll drop this patch.

But I also wonder if IS_ENABLED() is really correct? Why would enabling
a Kconfig option change "normal mode" (= not tx99 mode) functionality,
even when nobody accesses the tx99 debugfs file? I would have thought
there's some kind of runtime check to see if tx99 mode is enabled or
something like that.

-- 
Kalle Valo
