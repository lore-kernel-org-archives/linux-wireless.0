Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60985 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954AbaE2NrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2014 09:47:07 -0400
Message-ID: <53873A58.1070209@candelatech.com> (sfid-20140529_154711_701133_23579D6A)
Date: Thu, 29 May 2014 06:47:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Bartosz Markowski <bartosz.markowski@tieto.com>,
	ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: fix vdev map size for 10.x firmware
References: <1401370567-13543-1-git-send-email-bartosz.markowski@tieto.com>
In-Reply-To: <1401370567-13543-1-git-send-email-bartosz.markowski@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/29/2014 06:36 AM, Bartosz Markowski wrote:
> Firmware 10.x supports up to 8 virtual AP interfaces
> (comparing to 7 for main firmware). Previous vdev map
> initialization was missing enough space for 8 + 1 vdevs
> (we may spent one for mac monitor), due to wrong define used.
>
> Use correct one - TARGET_10X_NUM_VDEVS - for 10.x firmware.

You are bumping total vdevs up to 16 with that patch...have you
actually tested that many?  The stock firmware has quite a bit of
deficiencies in the concurrency handling, at least for stations.

For what it's worth, my firmware will only work on stock kernels
because I ignore the request for 16 vdevs in the firmware and knock
it down to 8 to match the kernel driver (before your change below).

Thanks,
Ben


>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
> ---
>   drivers/net/wireless/ath/ath10k/core.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 82017f5..e6c56c5 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -795,7 +795,11 @@ int ath10k_core_start(struct ath10k *ar)
>   	if (status)
>   		goto err_htc_stop;
>
> -	ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
> +	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
> +		ar->free_vdev_map = (1 << TARGET_10X_NUM_VDEVS) - 1;
> +	else
> +		ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
> +
>   	INIT_LIST_HEAD(&ar->arvifs);
>
>   	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
