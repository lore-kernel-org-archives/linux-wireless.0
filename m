Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbbGWVwP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2015 17:52:15 -0400
Date: Thu, 23 Jul 2015 14:52:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com
Subject: Re: [PATCH 1/3] staging: wilc1000: coreconfigurator.c: remove
 WILC_MALLOC
Message-ID: <20150723215214.GA32146@kroah.com> (sfid-20150723_235218_776831_D1D7A1DB)
References: <1437650359-2051-1-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437650359-2051-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2015 at 08:19:17PM +0900, Chaehyun Lim wrote:
> Use kmalloc and kmalloc_array instead of WILC_MALLOC.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
> index b069614..7e2b2ab41 100644
> --- a/drivers/staging/wilc1000/coreconfigurator.c
> +++ b/drivers/staging/wilc1000/coreconfigurator.c
> @@ -674,7 +674,7 @@ s32 CoreConfiguratorInit(void)
>  	sema_init(&SemHandleSendPkt, 1);
>  	sema_init(&SemHandlePktResp, 0);
>  
> -	gps8ConfigPacket = (s8 *)WILC_MALLOC(MAX_PACKET_BUFF_SIZE);
> +	gps8ConfigPacket = kmalloc(MAX_PACKET_BUFF_SIZE, GFP_ATOMIC);

I know this is what WILC_MALLOC() did, but should this really be
GFP_ATOMIC?

>  	if (gps8ConfigPacket == NULL) {
>  		PRINT_ER("failed in gps8ConfigPacket allocation\n");
>  		s32Error = WILC_NO_MEM;
> @@ -811,7 +811,7 @@ s32 ParseNetworkInfo(u8 *pu8MsgBuffer, tstrNetworkInfo **ppstrNetworkInfo)
>  		u32 u32Tsf_Lo;
>  		u32 u32Tsf_Hi;
>  
> -		pstrNetworkInfo = (tstrNetworkInfo *)WILC_MALLOC(sizeof(tstrNetworkInfo));
> +		pstrNetworkInfo = kmalloc(sizeof(tstrNetworkInfo), GFP_ATOMIC);

Same here.  And everywhere else you changed this code, please review and
resend.

thanks,

greg k-h
