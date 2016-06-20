Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33190 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbcFTUzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 16:55:46 -0400
Subject: Re: [PATCH v2 01/21] ath10k: Fix crash related to printing features.
To: ath10k@lists.infradead.org
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
 <1462986153-16318-2-git-send-email-greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <576856E6.2030003@candelatech.com> (sfid-20160620_225550_256592_9D7760FD)
Date: Mon, 20 Jun 2016 13:49:42 -0700
MIME-Version: 1.0
In-Reply-To: <1462986153-16318-2-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2016 10:02 AM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> This looks like a regression from
> c4cdf753 (move fw_features to struct ath10k_fw_file)

Just FYI, this patch does not appear to be in 4.7-rc4 as of today, and so kernel crashes on
startup when loading ath10k, at least when DBG_BOOT logging is enabled....

Thanks,
Ben

>
> Signed-off-by:  Ben Greear <greearb@candelatech.com>
> ---
>   drivers/net/wireless/ath/ath10k/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index e94cb87..b7318b8 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -1078,7 +1078,7 @@ int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
>   			}
>
>   			ath10k_dbg_dump(ar, ATH10K_DBG_BOOT, "features", "",
> -					ar->running_fw->fw_file.fw_features,
> +					fw_file->fw_features,
>   					sizeof(fw_file->fw_features));
>   			break;
>   		case ATH10K_FW_IE_FW_IMAGE:
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

