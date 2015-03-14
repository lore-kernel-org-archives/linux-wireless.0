Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:33545 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbbCNUSo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 16:18:44 -0400
Received: by lbbzq9 with SMTP id zq9so9481599lbb.0
        for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2015 13:18:43 -0700 (PDT)
Message-ID: <550497A0.5040508@cogentembedded.com> (sfid-20150314_211848_479622_148F0941)
Date: Sat, 14 Mar 2015 23:18:40 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Nicholas Mc Guire <hofrat@osadl.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: core: harmonize error case handling in ath10k_core_start
References: <1426323313-1344-1-git-send-email-hofrat@osadl.org>
In-Reply-To: <1426323313-1344-1-git-send-email-hofrat@osadl.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 03/14/2015 11:55 AM, Nicholas Mc Guire wrote:

> All of the bringup/init functions called in ath10k_core_start return 0 on
> success and != 0 on failure - ath10k_wmi_wait_for_service_ready and
> ath10k_wmi_wait_for_unified_ready were adjusted to fit this model and the
> call sites here fixed up accordingly.

    If you've changed the sense of these function's results, you need to 
adjust the call sites in the same patch, because otherwise one wouldn't be 
able to bisect this...

> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---
>
> Patch was only compile tested with x86_64_defconfig + CONFIG_ATH_CARDS=m,
> CONFIG_ATH10K=m
>
> Patch is against 4.0-rc3 (localversion-next is -next-20150313)
>
>   drivers/net/wireless/ath/ath10k/core.c |    6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index c0e454b..e97069f 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1080,9 +1080,8 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
>
>   	if (mode == ATH10K_FIRMWARE_MODE_NORMAL) {
>   		status = ath10k_wmi_wait_for_service_ready(ar);
> -		if (status <= 0) {

    With the changed result sense, this check would always succeed, right? 
Then this gets check broken after the 1st patch.

> +		if (status) {
>   			ath10k_warn(ar, "wmi service ready event not received");
> -			status = -ETIMEDOUT;
>   			goto err_hif_stop;
>   		}
>   	}
> @@ -1098,9 +1097,8 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
>   	}
>
>   	status = ath10k_wmi_wait_for_unified_ready(ar);
> -	if (status <= 0) {

    Likewise.

> +	if (status) {
>   		ath10k_err(ar, "wmi unified ready event not received\n");
> -		status = -ETIMEDOUT;
>   		goto err_hif_stop;
>   	}

WBR, Sergei

