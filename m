Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbbGaUqY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 16:46:24 -0400
Date: Fri, 31 Jul 2015 13:46:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, robin.hwang@atmel.com, jude.lee@atmel.com,
	leo.kim@atmel.com
Subject: Re: [PATCH 01/28] staging: wilc1000: change type of driver handler
 in host interface msg
Message-ID: <20150731204623.GA1572@kroah.com> (sfid-20150731_224630_857592_31F13045)
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
 <1438328316-30197-2-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438328316-30197-2-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2015 at 04:38:09PM +0900, Tony Cho wrote:
> From: glen lee <glen.lee@atmel.com>
> 
> This patch changes void pointer type of drvHandler with WILC_WFIDrvHandle
> type variable since the structure member drvHandler in tstrHostIFmsg is
> explicitly used to pass driver pointer as handler.
> The void pointer as argument is ambiguous for the functions to handle correctly.
> 
> After this patch, ATWILC_WFIDrvHandle type will be used as handler type to
> interface with other functions which does not need to know all about wifi driver
> structre tstrATWILC_WFIDrv.
> As a consequence of this patch, several patches will be followed up to change
> type of parameter which take drvHandler as argument.
> 
> Signed-off-by: glen lee <glen.lee@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 02aaf39..fb4194a 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -467,7 +467,7 @@ typedef union _tuniHostIFmsgBody {
>  typedef struct _tstrHostIFmsg {
>  	u16 u16MsgId;                                           /*!< Message ID */
>  	tuniHostIFmsgBody uniHostIFmsgBody;             /*!< Message body */
> -	void *drvHandler;
> +	WILC_WFIDrvHandle drvHandler;
>  } tstrHostIFmsg;
>  
>  #ifdef CONNECT_DIRECT

This patch adds build warnings to the tree, which isn't ok.  Change the
variable type and then fix up the places it is used in the same patch.
Right now you have a bunch more "warning: assignment from incompatible
pointer type [-Wincompatible-pointer-types]" added, which isn't ok.

Each patch in a series should do one logical thing, and never add more
build warnings to the build.  Please rework this series to do this
correctly.

thanks,

greg k-h
