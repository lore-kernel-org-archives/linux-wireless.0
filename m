Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27477 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2JOHjP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 03:39:15 -0400
Date: Mon, 15 Oct 2012 12:52:20 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath9k: Set appropriate bit for AR9565 in btc control
 register
Message-ID: <20121015072219.GA15591@hemis.qca.qualcomm.com> (sfid-20121015_093918_543363_50C55080)
References: <1350282513-3869-1-git-send-email-bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1350282513-3869-1-git-send-email-bkamatch@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 15, 2012 at 11:58:33AM +0530, Bala Shanmugam wrote:
> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_mci.c |   30 ++++++++++++++++++--------
>  1 files changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> index 44c202c..841f2b9 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
> @@ -843,15 +843,27 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
>  	* MCI mode will be enabled later, right before reset the MCI TX and RX.
>  	*/
>  
> -	regval = SM(1, AR_BTCOEX_CTRL_AR9462_MODE) |
> -		 SM(1, AR_BTCOEX_CTRL_WBTIMER_EN) |
> -		 SM(1, AR_BTCOEX_CTRL_PA_SHARED) |
> -		 SM(1, AR_BTCOEX_CTRL_LNA_SHARED) |
> -		 SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
> -		 SM(3, AR_BTCOEX_CTRL_RX_CHAIN_MASK) |
> -		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_ACK) |
> -		 SM(0, AR_BTCOEX_CTRL_1_CHAIN_BCN) |
> -		 SM(0, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
> +	if (AR_SREV_9565(ah)) {
> +		regval = SM(1, AR_BTCOEX_CTRL_AR9462_MODE) |
> +			 SM(1, AR_BTCOEX_CTRL_WBTIMER_EN) |
> +			 SM(0, AR_BTCOEX_CTRL_PA_SHARED) |
> +			 SM(0, AR_BTCOEX_CTRL_LNA_SHARED) |
> +			 SM(2, AR_BTCOEX_CTRL_NUM_ANTENNAS) |
> +			 SM(1, AR_BTCOEX_CTRL_RX_CHAIN_MASK) |
> +			 SM(0, AR_BTCOEX_CTRL_1_CHAIN_ACK) |
> +			 SM(0, AR_BTCOEX_CTRL_1_CHAIN_BCN) |
> +			 SM(0, AR_BTCOEX_CTRL_ONE_STEP_LOOK_AHEAD_EN);
NACK. AR9565 uses ANT-1 sharing architecture. These settings are applicable to ANT-2
arch which we don't support. I'll send updated change along with btcoex patch series.

-Rajkumar
