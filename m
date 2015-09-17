Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8330 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbbIQJHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 05:07:18 -0400
Subject: Re: [PATCH 1/4] staging: wilc1000: Modify null check routine
To: <leo.kim@atmel.com>
References: <1442479806-10737-1-git-send-email-tony.cho@atmel.com>
CC: Tony Cho <tony.cho@atmel.com>, <gregkh@linuxfoundation.org>,
	<devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <glen.lee@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Message-ID: <55FA8299.5060606@atmel.com> (sfid-20150917_110725_031790_1269C55A)
Date: Thu, 17 Sep 2015 11:06:33 +0200
MIME-Version: 1.0
In-Reply-To: <1442479806-10737-1-git-send-email-tony.cho@atmel.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 17/09/2015 10:50, Tony Cho a écrit :
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch modify null check routine.
> - Null check error non return. (Handle_RcvdGnrlAsyncInfo)

It doesn't parse...

Is it fixing a bug? What were the consequences without the return?

Bye,

> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 6fdf392..a9eaa8f 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -2403,8 +2403,10 @@ static s32 Handle_RcvdGnrlAsyncInfo(tstrWILC_WFIDrv *drvHandler, tstrRcvdGnrlAsy
>  	s32 s32Err = 0;
>  	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *) drvHandler;
>  
> -	if (pstrWFIDrv == NULL)
> +	if (!pstrWFIDrv) {
>  		PRINT_ER("Driver handler is NULL\n");
> +		return -EFAULT;
> +	}
>  	PRINT_D(GENERIC_DBG, "Current State = %d,Received state = %d\n", pstrWFIDrv->enuHostIFstate,
>  		pstrRcvdGnrlAsyncInfo->pu8Buffer[7]);
>  
> 


-- 
Nicolas Ferre
