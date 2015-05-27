Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45940 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbbE0N6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 09:58:06 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: Bypass PLL setting on target init for QCA9888
References: <1430994663-30006-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Wed, 27 May 2015 16:57:49 +0300
In-Reply-To: <1430994663-30006-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Thu, 7 May 2015 16:01:03 +0530")
Message-ID: <87mw0qyvfm.fsf@kamboji.qca.qualcomm.com> (sfid-20150527_155809_854918_5F375E81)
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
> index bcccae1..cb34619 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1084,6 +1084,16 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
>  	if (status)
>  		goto err;
>  
> +	if ((ar->hw_rev == ATH10K_HW_QCA988X) &&
> +	    (ar->wmi.op_version == ATH10K_FW_WMI_OP_VERSION_10_2_4)) {
> +		status = ath10k_bmi_write32(ar, hi_skip_clock_init, 1);
> +		if (status) {
> +			ath10k_err(ar, "could not write skip_clock_init (%d)\n",
> +				   status);
> +			goto err;
> +		}
> +	}

I think it's better to use enum ath10k_fw_features for this as that
gives more flexibility how to enable this.

-- 
Kalle Valo
