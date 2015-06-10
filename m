Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933814AbbFJTh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 15:37:56 -0400
Date: Wed, 10 Jun 2015 12:37:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Rachel.kim@atmel.com, dean.lee@atmel.com, tony.cho@atmel.com,
	chris.park@atmel.com
Subject: Re: [PATCH 2/4] staging: wilc1000: add syntax for 64-bit machine
Message-ID: <20150610193755.GA13550@kroah.com> (sfid-20150610_213800_532985_B1923E7D)
References: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com>
 <1433923607-20927-3-git-send-email-johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433923607-20927-3-git-send-email-johnny.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2015 at 05:06:45PM +0900, Johnny Kim wrote:
> The driver take pointer value to integer value for message packet.
> So, The driver was fixed to save and load the address
> on 64-bit machine.
> 
> Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 24 ++++++++++++++++++++----
>  drivers/staging/wilc1000/wilc_wlan.c      | 19 +++++++++++++++----
>  drivers/staging/wilc1000/wilc_wlan.h      |  6 +++++-
>  3 files changed, 40 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index cfe3364..4b005fa 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -6918,9 +6918,14 @@ void NetworkInfoReceived(u8 *pu8Buffer, WILC_Uint32 u32Length)
>  {
>  	WILC_Sint32 s32Error = WILC_SUCCESS;
>  	tstrHostIFmsg strHostIFmsg;
> -	size_t drvHandler;
> +	size_t drvHandler = 0;
>  	tstrWILC_WFIDrv *pstrWFIDrv = NULL;
>  
> +#ifdef CONFIG_64BIT
> +	drvHandler = ((pu8Buffer[u32Length - 8]) | (pu8Buffer[u32Length - 7] << 8) | (pu8Buffer[u32Length - 6] << 16) | (pu8Buffer[u32Length - 5] << 24));
> +	drvHandler <<= 32;
> +#endif

Ick, no, you should never have #ifdef lines in your .c files, that shows
you are doing something really wrong.  You will note that other drivers
do not do this.  Please fix this up properly.

thanks,

greg k-h
