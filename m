Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:15367 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbCEMl0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 07:41:26 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: Bypass PLL setting on target init for QCA9888
References: <1423460814-2767-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Thu, 5 Mar 2015 14:41:16 +0200
In-Reply-To: <1423460814-2767-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Mon, 9 Feb 2015 11:16:53 +0530")
Message-ID: <87wq2v4nwz.fsf@kamboji.qca.qualcomm.com> (sfid-20150305_134129_687525_8E1936C2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Some of of qca988x solutions are having global reset issue
> during target initialization. Bypassing PLL setting before
> downloading firmware and letting the SoC run on REF_CLK is fixing
> the problem. Corresponding firmware change is also needed to set
> the clock source once the target is initialized. Since 10.2.4
> firmware is having this ROM patch, applying skip_clock_init only
> for 10.2.4 firmware versions.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 310e12b..cd20805 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -797,6 +797,16 @@ static int ath10k_download_cal_data(struct ath10k *ar)
>  	ar->cal_mode = ATH10K_CAL_MODE_OTP;
>  
>  done:
> +	if ((ar->hw_rev == ATH10K_HW_QCA988X) &&
> +	    (ar->wmi.op_version == ATH10K_FW_WMI_OP_VERSION_10_2_4)) {
> +		ret = ath10k_bmi_write32(ar, hi_skip_clock_init, 1);
> +		if (ret) {
> +			ath10k_err(ar, "could not write skip_clock_init (%d)\n",
> +				   ret);
> +			return ret;
> +		}
> +	}

Didn't Michal mention that this should be a firmware feature flag?
Checking for firmware versions can easily get too complicated, that's
why we have tried to use feature flags for things like this.

Also I think this should not be hidden inside
ath10k_download_cal_data(). Maybe ath10k_core_start() is a better place
to do this?

I can send v3 for this patch.

-- 
Kalle Valo
