Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44333 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbbGWLbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 07:31:41 -0400
Date: Thu, 23 Jul 2015 14:31:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com
Subject: Re: [PATCH 2/3] staging: wilc1000: coreconfigurator.c: add kmalloc
 error check
Message-ID: <20150723113137.GS5371@mwanda> (sfid-20150723_133144_260317_1785EAB8)
References: <1437650359-2051-1-git-send-email-chaehyun.lim@gmail.com>
 <1437650359-2051-2-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437650359-2051-2-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2015 at 08:19:18PM +0900, Chaehyun Lim wrote:
> Add error check if memory allocation is failed.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index 7e2b2ab41..b51c15f 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -812,6 +812,9 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
>  		u32 u32Tsf_Hi;
>  
>  		pstrNetworkInfo = kmalloc(sizeof(tstrNetworkInfo), GFP_ATOMIC);
> +		if (pstrNetworkInfo == NULL)
> +			return -ENOMEM;

Run your patches through checkpatch.pl --strict.  These days we prefer:

		if (!pstrNetworkInfo)
			return -ENOMEM;

These patches are nice otherwise.

regards,
dan carpenter

