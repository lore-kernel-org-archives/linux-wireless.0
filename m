Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50621 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1H3JyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 05:54:23 -0400
Message-ID: <4E5CB2B9.1090606@qca.qualcomm.com> (sfid-20110830_115427_632214_606C7AE8)
Date: Tue, 30 Aug 2011 15:21:53 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <kvalo@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 08/20] ath6kl: Request P2P capabilities during target
 init
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com> <1314620641-24257-9-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1314620641-24257-9-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 August 2011 05:53 PM, Jouni Malinen wrote:
> Signed-off-by: Jouni Malinen<jouni@qca.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath6kl/init.c |    9 +++++++++
>   1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
> index ad9716c..aa7440d 100644
> --- a/drivers/net/wireless/ath/ath6kl/init.c
> +++ b/drivers/net/wireless/ath/ath6kl/init.c
> @@ -417,6 +417,7 @@ void ath6kl_target_failure(struct ath6kl *ar)
>   static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
>   {
>   	int status = 0;
> +	int ret;
>
>   	/*
>   	 * Configure the device for rx dot11 header rules. "0,0" are the
> @@ -461,6 +462,14 @@ static int ath6kl_target_config_wlan_params(struct ath6kl *ar)
>   			status = -EIO;
>   		}
>
> +	ret = ath6kl_wmi_info_req_cmd(ar->wmi, P2P_FLAG_CAPABILITIES_REQ |
> +				      P2P_FLAG_MACADDR_REQ |
> +				      P2P_FLAG_HMODEL_REQ);
> +	if (ret) {
> +		printk(KERN_DEBUG "ath6l: Failed to request P2P capabilities "
> +		       "(%d) - assuming P2P not supported\n", ret);

Is it possible to use ath6kl_dbg() instead of printk here ?
Should it be ath6kl_err() ?

Another question is , Don't you have to assign error code (may be -EIO) 
to 'status' variable in case of error ? not sure whether error code 
assignment needed here or not..

> +	}
> +
>   	return status;
>   }
>
