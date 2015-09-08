Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:47428 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751197AbbIHCXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 22:23:07 -0400
Subject: Re: [PATCH 4/5] staging: wilc1000: wilc_msgqueue.c: use kmalloc with
 GFP_ATOMIC
To: Chaehyun Lim <chaehyun.lim@gmail.com>, <gregkh@linuxfoundation.org>
References: <1441640199-1507-1-git-send-email-chaehyun.lim@gmail.com>
 <1441640199-1507-4-git-send-email-chaehyun.lim@gmail.com>
CC: <johnny.kim@atmel.com>, <rachel.kim@atmel.com>,
	<chris.park@atmel.com>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>
From: Tony Cho <tony.cho@atmel.com>
Message-ID: <55EE468B.20803@atmel.com> (sfid-20150908_042329_471575_E71A5431)
Date: Tue, 8 Sep 2015 11:23:07 +0900
MIME-Version: 1.0
In-Reply-To: <1441640199-1507-4-git-send-email-chaehyun.lim@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 09월 08일 00:36, Chaehyun Lim wrote:
> This patch use kmalloc with GFP_ATOMIC instead of WILC_MALLOC.
> It is inside the spin lock region.
>
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>   drivers/staging/wilc1000/wilc_msgqueue.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
> index 76d2e63..41244ce 100644
> --- a/drivers/staging/wilc1000/wilc_msgqueue.c
> +++ b/drivers/staging/wilc1000/wilc_msgqueue.c
> @@ -72,7 +72,7 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
>   	WILC_NULLCHECK(s32RetStatus, pstrMessage);
>   	pstrMessage->u32Length = u32SendBufferSize;
>   	pstrMessage->pstrNext = NULL;
> -	pstrMessage->pvBuffer = WILC_MALLOC(u32SendBufferSize);
> +	pstrMessage->pvBuffer = kmalloc(u32SendBufferSize, GFP_ATOMIC);
>   	WILC_NULLCHECK(s32RetStatus, pstrMessage->pvBuffer);
>   	memcpy(pstrMessage->pvBuffer, pvSendBuffer, u32SendBufferSize);

I want just to let you know this file will be soon changed.
Thanks,
Tony.

>   

