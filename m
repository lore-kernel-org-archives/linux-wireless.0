Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:65183 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3IZIPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 04:15:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 09/13] ath10k: split wmi_cmd_init path
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
	<1380101891-18312-10-git-send-email-bartosz.markowski@tieto.com>
Date: Thu, 26 Sep 2013 11:15:16 +0300
In-Reply-To: <1380101891-18312-10-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Wed, 25 Sep 2013 11:38:07 +0200")
Message-ID: <87siwsrobv.fsf@kamboji.qca.qualcomm.com> (sfid-20130926_101550_786816_888DED21)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> Due to API differences in initialization structures for
> main and 10.x firmwares we need to split the wmi_init_cmd
> and wmi_resource_config  structures.
>
> This will be usefull also when setting the correct TARGET values,
> like: number of peers, vdevs, pdevs etc.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/core.c |    6 +-
>  drivers/net/wireless/ath/ath10k/wmi.c  |   91 +++++++++++++++
>  drivers/net/wireless/ath/ath10k/wmi.h  |  196 ++++++++++++++++++++++++++++++++
>  3 files changed, 292 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 31860a6..3a56715 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -595,7 +595,11 @@ int ath10k_core_start(struct ath10k *ar)
>  
>  	ath10k_info("firmware %s booted\n", ar->hw->wiphy->fw_version);
>  
> -	status = ath10k_wmi_cmd_init(ar);
> +	if (test_bit(ATH10K_FW_FEATURE_10X, ar->fw_features))
> +		status = ath10k_wmi_10x_cmd_init(ar);
> +	else
> +		status = ath10k_wmi_cmd_init(ar);

It's better to hide the feature check inside ath10k_wmi_cmd_init() and
then that function can just call ath10k_wmi_10x_cmd_init() or
ath10k_wmi_main_cmd_init() (or whatever naming would be approriate
here). So we only expose ath10k_wmi_cmd_init() outside of wmi.c.

-- 
Kalle Valo
