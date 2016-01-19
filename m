Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:27212 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbcASMqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 07:46:32 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
	by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u0JBW2OC015977
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2016 11:32:03 GMT
Date: Tue, 19 Jan 2016 14:30:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 3/3] staging: wilc1000: use int type for counter variable
Message-ID: <20160119113043.GA6370@mwanda> (sfid-20160119_134637_541627_9C5307FB)
References: <1453199177-21085-1-git-send-email-chaehyun.lim@gmail.com>
 <1453199177-21085-3-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453199177-21085-3-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 19, 2016 at 07:26:17PM +0900, Chaehyun Lim wrote:
> counter is used as for-loop control variable and indicating index of
> struct wid array so that it is better to use int type.
> There is no need to set to 0 when it is declared at the top of this
> function. counter is initialized as 0 in for-loop statement.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index 86dfe77..7e8e423 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -591,7 +591,7 @@ s32 wilc_dealloc_assoc_resp_info(tstrConnectRespInfo *pstrConnectRespInfo)
>  int wilc_send_config_pkt(struct wilc *wilc, u8 mode, struct wid *wids,
>  			 u32 count, u32 drv)
>  {
> -	s32 counter = 0;
> +	int counter;

rename it to "i" as well.  "int i;"

regards,
dan carpenter

