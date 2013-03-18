Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12007 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab3CRMJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 08:09:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Andrei Epure <epure.andrei@gmail.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath: changed kmalloc to kmemdup
References: <1362919199-16292-1-git-send-email-epure.andrei@gmail.com>
Date: Mon, 18 Mar 2013 14:09:22 +0200
In-Reply-To: <1362919199-16292-1-git-send-email-epure.andrei@gmail.com>
	(Andrei Epure's message of "Sun, 10 Mar 2013 14:39:58 +0200")
Message-ID: <878v5k9afh.fsf@kamboji.qca.qualcomm.com> (sfid-20130318_130948_216457_C8FB187D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrei Epure <epure.andrei@gmail.com> writes:

> Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
> ---
>  drivers/net/wireless/ath/ath6kl/usb.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
> index 5fcd342..ffa1daa 100644
> --- a/drivers/net/wireless/ath/ath6kl/usb.c
> +++ b/drivers/net/wireless/ath/ath6kl/usb.c
> @@ -856,11 +856,9 @@ static int ath6kl_usb_submit_ctrl_out(struct ath6kl_usb *ar_usb,
>  	int ret;
>  
>  	if (size > 0) {
> -		buf = kmalloc(size, GFP_KERNEL);
> +		buf = kmemdup(data, size, GFP_KERNEL);
>  		if (buf == NULL)
>  			return -ENOMEM;
> -
> -		memcpy(buf, data, size);
>  	}

Thanks, applied to ath6kl.git.

-- 
Kalle Valo
