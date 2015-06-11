Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40329 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbbFKODx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 10:03:53 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Liu CF/TW <cfliu.tw@gmail.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: add 'cryptmode' param to support raw tx injection and software crypto
References: <1433812382-10287-1-git-send-email-cfliu.tw@gmail.com>
Date: Thu, 11 Jun 2015 17:03:40 +0300
In-Reply-To: <1433812382-10287-1-git-send-email-cfliu.tw@gmail.com> (Liu CF's
	message of "Mon, 8 Jun 2015 18:13:02 -0700")
Message-ID: <87r3pibav7.fsf@kamboji.qca.qualcomm.com> (sfid-20150611_160357_184035_4018E7FA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Liu CF/TW <cfliu.tw@gmail.com> writes:

> This change supports hardware crypto engine bypass by enabling raw
> Rx/Tx encap mode. This enables use cases such as software crypto and raw
> tx injection. This change introduces a new module param 'cryptmode'.

[...]

> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -124,7 +124,7 @@ EXPORT_SYMBOL(ath10k_info);
>  
>  void ath10k_print_driver_info(struct ath10k *ar)
>  {
> -	ath10k_info(ar, "%s (0x%08x, 0x%08x%s%s%s) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d\n",
> +	ath10k_info(ar, "%s (0x%08x, 0x%08x%s%s%s) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d flags 0x%lu\n",
>  		    ar->hw_params.name,
>  		    ar->target_version,
>  		    ar->chip_id,
> @@ -138,7 +138,8 @@ void ath10k_print_driver_info(struct ath10k *ar)
>  		    ar->htt.target_version_minor,
>  		    ar->wmi.op_version,
>  		    ath10k_cal_mode_str(ar->cal_mode),
> -		    ar->max_num_stations);
> +		    ar->max_num_stations,
> +		    ar->dev_flags);

What's the goal here? Printing a bitmap in hex is just gibberish, people
would always have to count the bits etc to get anything useful
information out from that print.

I would prefer the messages in more readable format. For example, if
idea is to show if cryptmode is enabled or not can't we just directly
print that like with format "cryptmode %d"?

-- 
Kalle Valo
