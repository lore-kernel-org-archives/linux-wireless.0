Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12767 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab1H2Osd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 10:48:33 -0400
Date: Mon, 29 Aug 2011 20:19:00 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>, <vthiagar@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath9k: fix checks for first subframe delimiter padding
Message-ID: <20110829144859.GA4557@vmraj-lnx.users.atheros.com> (sfid-20110829_164850_752549_001FEB97)
References: <1314616292-11364-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1314616292-11364-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 01:11:32PM +0200, Felix Fietkau wrote:
> The commit "ath9k_hw: Fix exceed transmission burst-time of 5GHz" added
> a padding of 60 delimiters on the first subframe to work around an issue
> on AR9380, but it lacked the checks to prevent it from being applied to
> pre-AR9380, enterprise AR9380 or AR9580+
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/reg.h  |    2 +-
>  drivers/net/wireless/ath/ath9k/xmit.c |    4 +++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
> index a3b8bbc..02363c1 100644
> --- a/drivers/net/wireless/ath/ath9k/reg.h
> +++ b/drivers/net/wireless/ath/ath9k/reg.h
> @@ -1131,7 +1131,7 @@ enum {
>  #define AR_INTR_PRIO_ASYNC_ENABLE (AR_SREV_9340(ah) ? 0x4094 : 0x40d4)
>  #define AR_ENT_OTP		  0x40d8
>  #define AR_ENT_OTP_CHAIN2_DISABLE               0x00020000
> -#define AR_ENT_OTP_MPSD		0x00800000
> +#define AR_ENT_OTP_MIN_PKT_SIZE_DISABLE		0x00800000
>  
>  #define AR_CH0_BB_DPLL1		 0x16180
>  #define AR_CH0_BB_DPLL1_REFDIV	 0xF8000000
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 5e29829..ad3fcd2 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -692,7 +692,9 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
>  	 * Add delimiter when using RTS/CTS with aggregation
>  	 * and non enterprise AR9003 card
>  	 */
> -	if (first_subfrm)
> +	if (first_subfrm && (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) &&
> +	    !AR_SREV_9580_10_OR_LATER(sc->sc_ah) &&
> +	    (sc->sc_ah->ent_mode & AR_ENT_OTP_MIN_PKT_SIZE_DISABLE))
>  		ndelim = max(ndelim, FIRST_DESC_NDELIMS);
Sorry for the regression and thanks for the fix Felix.
The ent_mode is valid only for EDMA chips. hw_cap check in not needed.

--
Rajkumar
