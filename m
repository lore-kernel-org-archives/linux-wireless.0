Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52349 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab1IMRp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 13:45:27 -0400
Date: Tue, 13 Sep 2011 13:32:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] ath9k_hw: Fix magnitude/phase coeff correction
Message-ID: <20110913173226.GF11772@tuxdriver.com> (sfid-20110913_194532_226122_4FEF85F8)
References: <1315320530-2733-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1315320530-2733-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 06, 2011 at 08:18:50PM +0530, Rajkumar Manoharan wrote:
> Do the magnitude/phase coeff correction only if the outlier
> is detected.
> 
> Cc: stable@kernel.org
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar9003_calib.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> index fa35a02..ee3a8a2 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
> @@ -643,8 +643,9 @@ static void ar9003_hw_detect_outlier(int *mp_coeff, int nmeasurement,
>  			outlier_idx = max_idx;
>  		else
>  			outlier_idx = min_idx;
> +
> +		mp_coeff[outlier_idx] = mp_avg;
>  	}
> -	mp_coeff[outlier_idx] = mp_avg;
>  }
>  
>  static void ar9003_hw_tx_iqcal_load_avg_2_passes(struct ath_hw *ah,

What is the effect of the bug being fixed here?  Is this fix intended for 3.1?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
