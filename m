Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48458 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754123AbeFLMct (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Jun 2018 08:32:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Tue, 12 Jun 2018 18:02:48 +0530
From: Govind Singh <govinds@codeaurora.org>
To: niklas.cassel@linaro.org, kvalo@codeaurora.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: FW: [PATCH 2/2] ath10k: allow ATH10K_SNOC with COMPILE_TEST
In-Reply-To: <7058492257914633b55fcd423e4c0b59@aphydexm01b.ap.qualcomm.com>
References: <20180612113907.15043-1-niklas.cassel@linaro.org>
 <20180612113907.15043-2-niklas.cassel@linaro.org>
 <7058492257914633b55fcd423e4c0b59@aphydexm01b.ap.qualcomm.com>
Message-ID: <47cf8ec1b11d727ea928a307a431d4a2@codeaurora.org> (sfid-20180612_143304_857529_7B764798)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-12 17:45, Govind Singh wrote:
> -----Original Message-----
> From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Niklas 
> Cassel
> Sent: Tuesday, June 12, 2018 5:09 PM
> To: Kalle Valo <kvalo@codeaurora.org>; David S. Miller 
> <davem@davemloft.net>
> Cc: Niklas Cassel <niklas.cassel@linaro.org>; netdev@vger.kernel.org;
> linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org;
> ath10k@lists.infradead.org
> Subject: [PATCH 2/2] ath10k: allow ATH10K_SNOC with COMPILE_TEST
> 
> ATH10K_SNOC builds just fine with COMPILE_TEST, so make that possible.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
> ---
>  drivers/net/wireless/ath/ath10k/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/Kconfig
> b/drivers/net/wireless/ath/ath10k/Kconfig
> index 54ff5930126c..6572a43590a8 100644
> --- a/drivers/net/wireless/ath/ath10k/Kconfig
> +++ b/drivers/net/wireless/ath/ath10k/Kconfig
> @@ -42,7 +42,8 @@ config ATH10K_USB
> 
>  config ATH10K_SNOC
>  	tristate "Qualcomm ath10k SNOC support (EXPERIMENTAL)"
> -	depends on ATH10K && ARCH_QCOM
> +	depends on ATH10K
> +	depends on ARCH_QCOM || COMPILE_TEST
>  	---help---
>  	  This module adds support for integrated WCN3990 chip connected
>  	  to system NOC(SNOC). Currently work in progress and will not

Thanks Niklas for enabling COMPILE_TEST. With QMI set of 
changes(https://patchwork.kernel.org/patch/10448183/), we need to enable 
COMPILE_TEST for
QCOM_SCM/QMI_HELPERS which seems broken today. Are you planning to fix 
the same.

  config QCOM_SCM
  	bool
-	depends on ARM || ARM64
+	depends on ARM || ARM64 || COMPILE_TEST
  	select RESET_CONTROLLER


  config QCOM_SCM_64
  	def_bool y
-	depends on QCOM_SCM && ARM64
+	depends on QCOM_SCM && ARM64 || COMPILE_TEST

  config QCOM_QMI_HELPERS
  	tristate
-	depends on ARCH_QCOM && NET
+	depends on (ARCH_QCOM || COMPILE_TEST) && NET

-obj-$(CONFIG_ARCH_QCOM)		+= qcom/
+obj-y				+= qcom/

__qcom_scm_init/qcom_scm_call wrapper to support COMPILE_TEST.



BR,
Govind
