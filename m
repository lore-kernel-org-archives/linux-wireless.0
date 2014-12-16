Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:61243 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaLPHtj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2014 02:49:39 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/5] ath10k: add 10.2.4 firmware support
References: <1418620274-3081-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1418620274-3081-2-git-send-email-rmanohar@qti.qualcomm.com>
Date: Tue, 16 Dec 2014 09:49:09 +0200
In-Reply-To: <1418620274-3081-2-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Mon, 15 Dec 2014 10:41:10 +0530")
Message-ID: <877fxst4p6.fsf@kamboji.qca.qualcomm.com> (sfid-20141216_084942_582455_6F058093)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> 10.2.4 firmware uses bitmask in wmi_resource_config to configure
> 10.2 firmware features like airtime fairness and rx batch mode instead
> of maintaining separete bool entry. This allows new features that can be
> configure during init time without breaking backward compatibility.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Few comments. I'll deal with these and send v2.

> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -387,6 +387,11 @@ enum ath10k_fw_features {
>  	 */
>  	ATH10K_FW_FEATURE_WMI_10_2 = 4,
>  
> +	/* Firmware 10.2.4 supports bitmask in resource config to configure
> +	 * Airtime fairness and rx batch mode
> +	 */
> +	ATH10K_FW_FEATURE_WMI_10_2_4 = 5,

When we add new value to enum ath10k_fw_wmi_op_version this flag is not
needed.

>  	/* keep last */
>  	ATH10K_FW_FEATURE_COUNT,
>  };
> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
> index 809c252..892b6f0 100644
> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -72,6 +72,7 @@ enum ath10k_fw_wmi_op_version {
>  	ATH10K_FW_WMI_OP_VERSION_10_1 = 2,
>  	ATH10K_FW_WMI_OP_VERSION_10_2 = 3,
>  	ATH10K_FW_WMI_OP_VERSION_TLV = 4,
> +	ATH10K_FW_WMI_OP_VERSION_10_2_4 = 5,
>  
>  	/* keep last */
>  	ATH10K_FW_WMI_OP_VERSION_MAX,
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index fa486f6..c42382c 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -4748,6 +4748,7 @@ static const struct wmi_ops wmi_10_2_ops = {
>  int ath10k_wmi_attach(struct ath10k *ar)
>  {
>  	switch (ar->wmi.op_version) {
> +	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
>  	case ATH10K_FW_WMI_OP_VERSION_10_2:
>  		ar->wmi.cmd = &wmi_10_2_cmd_map;
>  		ar->wmi.ops = &wmi_10_2_ops;

I think it's better to not share cmd_map/ops and instead create new ones
for 10_2_4.

-- 
Kalle Valo
