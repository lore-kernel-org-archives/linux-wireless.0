Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0201.hostedemail.com ([216.40.44.201]:37368 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754390AbbGWRTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 13:19:46 -0400
Message-ID: <1437671981.26573.13.camel@perches.com> (sfid-20150723_192005_166851_5422AAC5)
Subject: Re: [PATCH 2/3] staging: wilc1000: coreconfigurator.c: add kmalloc
 error check
From: Joe Perches <joe@perches.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: gregkh@linuxfoundation.org, johnny.kim@atmel.com,
	rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Date: Thu, 23 Jul 2015 10:19:41 -0700
In-Reply-To: <1437650359-2051-2-git-send-email-chaehyun.lim@gmail.com>
References: <1437650359-2051-1-git-send-email-chaehyun.lim@gmail.com>
	 <1437650359-2051-2-git-send-email-chaehyun.lim@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-07-23 at 20:19 +0900, Chaehyun Lim wrote:
> Add error check if memory allocation is failed.

trivia:

> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
[]
> @@ -812,6 +812,9 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
>  		u32 u32Tsf_Hi;
>  
>  		pstrNetworkInfo = kmalloc(sizeof(tstrNetworkInfo), GFP_ATOMIC);
> +		if (pstrNetworkInfo == NULL)
> +			return -ENOMEM;
> +
>  		WILC_memset((void *)(pstrNetworkInfo), 0, sizeof(tstrNetworkInfo));
>  
>  		pstrNetworkInfo->s8rssi = pu8WidVal[0];
> @@ -863,6 +866,9 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
>  
>  		if (u16IEsLen > 0) {
>  			pstrNetworkInfo->pu8IEs = kmalloc(u16IEsLen, GFP_ATOMIC);
> +			if (pstrNetworkInfo->pu8IEs == NULL)
> +				return -ENOMEM;
> +
>  			WILC_memset((void *)(pstrNetworkInfo->pu8IEs), 0, u16IEsLen);
>  
>  			WILC_memcpy(pstrNetworkInfo->pu8IEs, pu8IEs, u16IEsLen);
> @@ -930,6 +936,9 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
>  	u16 u16IEsLen = 0;
>  
>  	pstrConnectRespInfo = kmalloc(sizeof(tstrConnectRespInfo), GFP_ATOMIC);
> +	if (pstrConnectRespInfo == NULL)
> +		return -ENOMEM;
> +
>  	WILC_memset((void *)(pstrConnectRespInfo), 0, sizeof(tstrConnectRespInfo));
>  
>  	/* u16AssocRespLen = pu8Buffer[0]; */

These could use kzalloc

> @@ -950,6 +959,9 @@ s32 ParseAssocRespInfo(u8 *pu8Buffer, u32 u32BufferLen,
>  		u16IEsLen = u16AssocRespLen - (CAP_INFO_LEN + STATUS_CODE_LEN + AID_LEN);
>  
>  		pstrConnectRespInfo->pu8RespIEs = kmalloc(u16IEsLen, GFP_ATOMIC);
> +		if (pstrConnectRespInfo->pu8RespIEs == NULL)
> +			return -ENOMEM;
> +
>  		WILC_memset((void *)(pstrConnectRespInfo->pu8RespIEs), 0, u16IEsLen);
>  
>  		WILC_memcpy(pstrConnectRespInfo->pu8RespIEs, pu8IEs, u16IEsLen);

And this one could use kmemdup


