Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21183 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbbJ1Q4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 12:56:19 -0400
Date: Wed, 28 Oct 2015 19:56:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Glen Lee <glen.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 38/80] staging: wilc1000: rename au8Bssid of struct
 ba_session_info
Message-ID: <20151028165606.GB18797@mwanda> (sfid-20151028_175627_342264_329B2E24)
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com>
 <1446015640-29398-38-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446015640-29398-38-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 28, 2015 at 03:59:58PM +0900, Glen Lee wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch renames au8Bssid of struct ba_session_info to bssid
> to avoid CamelCase naming convention.
> And, some debug logs modified because 80 ending line over warnings.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 32 ++++++++++++++++++-------------
>  drivers/staging/wilc1000/host_interface.h |  2 +-
>  2 files changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 9ad98fd..48a232f 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -2715,10 +2715,14 @@ static s32 Handle_AddBASession(struct host_if_drv *hif_drv,
>  	int AddbaTimeout = 100;
>  	char *ptr = NULL;
>  
> -	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with\nBSSID = %.2x:%.2x:%.2x\nTID=%d\nBufferSize == %d\nSessionTimeOut = %d\n",
> -		strHostIfBASessionInfo->au8Bssid[0],
> -		strHostIfBASessionInfo->au8Bssid[1],
> -		strHostIfBASessionInfo->au8Bssid[2],
> +	PRINT_D(HOSTINF_DBG, "Opening Block Ack session with \
> +		\nBSSID = %.2x:%.2x:%.2x \
> +		\nBufferSize == %d \
> +		\nSessionTimeOut = %d \
> +		\nTID=%d\n",
> +		strHostIfBASessionInfo->bssid[0],
> +		strHostIfBASessionInfo->bssid[1],
> +		strHostIfBASessionInfo->bssid[2],
>  		strHostIfBASessionInfo->u16BufferSize,
>  		strHostIfBASessionInfo->u16SessionTimeout,
>  		strHostIfBASessionInfo->u8Ted);

This should be a bunch of printks so that we have the correct debug
level at the start of each line.

regards,
dan carpenter

