Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:60215 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062Ab2LGK2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 05:28:17 -0500
Date: Fri, 7 Dec 2012 15:58:27 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/8] ath9k_hw: Fix PAPRD training
Message-ID: <20121207102826.GB3145@hemis.qca.qualcomm.com> (sfid-20121207_112825_940350_BBD8DAC6)
References: <1354874521-4138-1-git-send-email-sujith@msujith.org>
 <1354874521-4138-3-git-send-email-sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1354874521-4138-3-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 07, 2012 at 03:31:55PM +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> The PAPRD training control registers have to be
> programmed with values that depend on the chip. This patch
> ensures that the correct values are chosen for the chip
> in use.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_paprd.c | 36 +++++++++++++++++++++------
>  1 file changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
> index 0ed3846..2cd23e5 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
> @@ -204,7 +204,20 @@ static int ar9003_paprd_setup_single_table(struct ath_hw *ah)
>  		      AR_PHY_PAPRD_TRAINER_CNTL1_CF_PAPRD_AGC2_SETTLING, 28);
>  	REG_RMW_FIELD(ah, AR_PHY_PAPRD_TRAINER_CNTL1,
>  		      AR_PHY_PAPRD_TRAINER_CNTL1_CF_CF_PAPRD_TRAIN_ENABLE, 1);
> -	val = AR_SREV_9462(ah) ? 0x91 : 147;
> +
> +	if (AR_SREV_9485(ah)) {
> +		val = 148;
> +	} else {
> +		if (IS_CHAN_2GHZ(ah->curchan)) {
> +			if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
> +				val = 0x91;
Please change the hex to decimal for the sake of uniformity

> +			else
> +				val = 147;
> +		} else {
> +			val = 137;
> +		}
> +	}

-Rajkumar
