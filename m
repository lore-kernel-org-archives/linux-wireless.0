Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:17475 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850Ab3AGJD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 04:03:56 -0500
Date: Mon, 7 Jan 2013 14:32:45 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] ath9k_hw: Use helper routines to simplify
 ar9003_hw_init_cal()
Message-ID: <20130107090244.GA1127@hemis.qca.qualcomm.com> (sfid-20130107_100401_867973_3CD41991)
References: <1357547028-22891-1-git-send-email-sujith@msujith.org>
 <1357547028-22891-3-git-send-email-sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1357547028-22891-3-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 07, 2013 at 01:53:48PM +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_calib.c | 92 ++++++++++++++++-----------
>  drivers/net/wireless/ath/ath9k/hw.h           |  1 +
>  2 files changed, 55 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> index 15f9b89..f0e472c 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> @@ -960,22 +960,68 @@ static void ar9003_hw_manual_peak_cal(struct ath_hw *ah, u8 chain, bool is_2g)
>  		      AR_PHY_65NM_RXRF_AGC_AGC_CAL_OVR, 0);
>  }
>  
> +static void ar9003_hw_do_manual_peak_cal(struct ath_hw *ah,
> +					 struct ath9k_channel *chan)
> +{
> +	int i;
> +
> +	if (!AR_SREV_9462(ah) || !AR_SREV_9565(ah))
> +		return;
> +
It should be && not ||

-Rajkumar
