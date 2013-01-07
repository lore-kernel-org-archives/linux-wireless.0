Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34104 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab3AGTHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 14:07:10 -0500
Received: by mail-pa0-f44.google.com with SMTP id hz11so10875711pad.31
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2013 11:07:09 -0800 (PST)
Date: Mon, 7 Jan 2013 11:07:05 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: vt6656: Remove ULONG_PTR/DWORD_PTR from
 driver.
Message-ID: <20130107190705.GA11344@kroah.com> (sfid-20130107_200717_827654_D93D0F5E)
References: <1354137348.2633.3.camel@user64-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1354137348.2633.3.camel@user64-MCP7A>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 28, 2012 at 09:15:48PM +0000, Malcolm Priestley wrote:
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/staging/vt6656/bssdb.c |   89 +++++++++++++++++++---------------------
>  drivers/staging/vt6656/ttype.h |    3 --
>  2 files changed, 42 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/staging/vt6656/bssdb.c b/drivers/staging/vt6656/bssdb.c
> index 539bc1d..d27469e 100644
> --- a/drivers/staging/vt6656/bssdb.c
> +++ b/drivers/staging/vt6656/bssdb.c
> @@ -355,13 +355,13 @@ BOOL BSSbInsertToBSSList(void *hDeviceContext,
>  			 PBYTE pbyIEs,
>  			 void *pRxPacketContext)
>  {
> -
> -    PSDevice     pDevice = (PSDevice)hDeviceContext;
> -    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
> -    PSRxMgmtPacket  pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
> -    PKnownBSS       pBSSList = NULL;
> -    unsigned int            ii;
> -    BOOL            bParsingQuiet = FALSE;
> +	PSDevice pDevice = (PSDevice)hDeviceContext;
> +	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
> +	PSRxMgmtPacket pRxPacket = (PSRxMgmtPacket)pRxPacketContext;
> +	PKnownBSS pBSSList = NULL;
> +	unsigned int ii;
> +	int bParsingQuiet = FALSE;
> +	u32 uLen;

This patch also adjusts formatting, making it hard to see that you
really changed the BOOL variable here, which is not what you said the
patch was doing :(

Please redo this patch, and _only_ make the changes you say you are
making.

thanks,

greg k-h
