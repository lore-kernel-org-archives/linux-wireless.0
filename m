Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27589 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbbF3Jjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 05:39:48 -0400
Date: Tue, 30 Jun 2015 12:39:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dean Lee <dean.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, rachel.kim@atmel.com,
	chris.park@atmel.com, nicolas.ferre@atmel.com, johnny.kim@atmel.com
Subject: Re: [PATCH 5/6] staging: wilc1000: fix initialize warning issue.
Message-ID: <20150630093927.GO28762@mwanda> (sfid-20150630_113955_056584_6C2BF12C)
References: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
 <1435653278-5168-5-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435653278-5168-5-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2015 at 05:34:37PM +0900, Dean Lee wrote:
> modify it
> 
> Signed-off-by: Dean Lee <dean.lee@atmel.com>

This patch description is useless.  What is the warning?

> ---
>  drivers/staging/wilc1000/host_interface.c | 3 ++-
>  drivers/staging/wilc1000/linux_wlan.c     | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 1e40dca..a2e9b6d 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -7162,7 +7162,7 @@ s32 host_int_add_beacon(void *hWFIDrv, u32 u32Interval,
>  	s32 s32Error = WILC_SUCCESS;
>  	tstrWILC_WFIDrv *pstrWFIDrv = (tstrWILC_WFIDrv *)hWFIDrv;
>  	tstrHostIFmsg strHostIFmsg;
> -	tstrHostIFSetBeacon *pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
> +	tstrHostIFSetBeacon *pstrSetBeaconParam = NULL;

The NULL pointer is not going to be used so do not initialize
pstrSetBeaconParam.

>  
>  	if (hWFIDrv == NULL) {
>  		WILC_ERRORREPORT(s32Error, WILC_INVALID_ARGUMENT);
> @@ -7172,6 +7172,7 @@ s32 host_int_add_beacon(void *hWFIDrv, u32 u32Interval,
>  
>  	PRINT_D(HOSTINF_DBG, "Setting adding beacon message queue params\n");
>  
> +	pstrSetBeaconParam = &strHostIFmsg.uniHostIFmsgBody.strHostIFSetBeacon;
>  
>  	/* prepare the WiphyParams Message */
>  	strHostIFmsg.u16MsgId = HOST_IF_MSG_ADD_BEACON;
> diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
> index 659b70a..1b8991a 100644
> --- a/drivers/staging/wilc1000/linux_wlan.c
> +++ b/drivers/staging/wilc1000/linux_wlan.c
> @@ -2463,7 +2463,7 @@ void frmw_to_linux(uint8_t *buff, uint32_t size, uint32_t pkt_offset)
>  			return;
>  		}
>  
> -		skb_reserve(skb, (unsigned int)skb->data & 0x3);
> +		skb_reserve(skb, (uintptr_t)skb->data & 0x3);

Neither the original nor the new code make sense.  skb->data is a
properly aligned pointer so we are doing skb_reserve(skb, 0);

This change is not described in the patch description.

regards,
dan carpenter

