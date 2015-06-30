Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19119 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbbF3J1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 05:27:39 -0400
Date: Tue, 30 Jun 2015 12:27:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dean Lee <dean.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, rachel.kim@atmel.com,
	chris.park@atmel.com, nicolas.ferre@atmel.com, johnny.kim@atmel.com
Subject: Re: [PATCH 3/6] staging: wilc1000: rework driver handler
Message-ID: <20150630092719.GM28762@mwanda> (sfid-20150630_112743_486085_07B892BD)
References: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
 <1435653278-5168-3-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435653278-5168-3-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2015 at 05:34:35PM +0900, Dean Lee wrote:
> argument type change for support 64 bit system.
> 
> Signed-off-by: Dean Lee <dean.lee@atmel.com>


> -u32 gu8FlushedJoinReqDrvHandler;
> +void *gpFlushedJoinReqDrvHandler;

There are a lot of variables renamed.  It makes reviewing this patch
hard.  Also the new names are bad style so just keep the original names
for now and fix the names in a later patch.

> -	if ((pstrHostIfSetOperationMode->u32Mode) == (u32)NULL) {
> +	if (pstrHostIfSetOperationMode == NULL) {

This was not in the patch description.  Do it in a later patch.

> @@ -6838,17 +6838,14 @@ void NetworkInfoReceived(u8 *pu8Buffer, u32 u32Length)
>  {
>  	s32 s32Error = WILC_SUCCESS;
>  	tstrHostIFmsg strHostIFmsg;
> -	u32 drvHandler;
> -	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
> -
> -	drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
> -	pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
> -
> +	uintptr_t drvData;
> +	void *drvHandler = NULL;

More renaming.  Do this in a different patch.

>  static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_nic)
>  {
> -
> +  void *drvHandler = NULL;

Bad indenting.

>  	unsigned char c_val[64];
>  	#ifndef STATIC_MACADDRESS
>  	unsigned char mac_add[] = {0x00, 0x80, 0xC2, 0x5E, 0xa2, 0xff};
> @@ -1102,62 +1102,62 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
>  		goto _fail_;
>  	}
>  
> -	*(int *)c_val = (u32)pstrWFIDrv;
> +	*(int *)c_val = (uintptr_t)pstrWFIDrv;
>  
> -	if (!g_linux_wlan->oup.wlan_cfg_set(1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
> +	if (!g_linux_wlan->oup.wlan_cfg_set(1, WID_SET_DRV_HANDLER, c_val, 4, 0, drvHandler))
>  		goto _fail_;

We are changing from 0 to drvHandler.  That is not described in the
patch description.  Do it in a different patch.

regards,
dan carpenter

