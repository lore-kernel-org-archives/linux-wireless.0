Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12752 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab1JLHXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 03:23:49 -0400
Message-ID: <4E953FDB.9090709@qca.qualcomm.com> (sfid-20111012_092352_695399_15AA3A2E)
Date: Wed, 12 Oct 2011 10:20:59 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: fix firmware start address for ar6003 hw2.0
References: <1317906725-31130-1-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1317906725-31130-1-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/06/2011 04:12 PM, Sangwook Lee wrote:
> From: Kalle Valo <kvalo@qca.qualcomm.com>
> 
> Sangwook found out that commit 639d0b89 ("ath6kl: read firmware start
> address from hardware") broke firmware boot on ar6003 hw2.0 as it seems
> it's not posible to automatically query the address from hardware. So
> we need to hardcode the address for hw2.0.
> 
> Reported-by: Sangwook Lee <sangwook.lee@linaro.org>
> Tested-by: Sangwook Lee <sangwook.lee@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
> Kalle:
> I slightly changed again. without running ath6kl_bmi_read() before,
> ath6kl_bmi_execute() failed with hw2.0 board, but I am not clear about this reason.

Hmm, that's strange. I didn't find any reason why this is needed.

> @@ -1201,25 +1202,28 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
>  	}
>  
>  	/* read firmware start address */
> -	ret = ath6kl_bmi_read(ar,
> -			      ath6kl_get_hi_item_addr(ar,
> -						      HI_ITEM(hi_app_start)),
> -			      (u8 *) &address, sizeof(address));
> +	ret = ath6kl_bmi_read(ar, ath6kl_get_hi_item_addr(ar,
> +		HI_ITEM(hi_app_start)), (u8 *) &address, sizeof(address));

You just change indentation here, right? So this part can be dropped.

I have applied to ath6kl.git now. Thank you very much for your help!

Kalle
