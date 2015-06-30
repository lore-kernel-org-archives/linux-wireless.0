Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbbF3QmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 12:42:05 -0400
Date: Tue, 30 Jun 2015 09:42:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dean Lee <dean.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	rachel.kim@atmel.com, chris.park@atmel.com,
	nicolas.ferre@atmel.com, johnny.kim@atmel.com
Subject: Re: [PATCH 4/6] staging: wilc1000: rework address value.
Message-ID: <20150630164204.GA32144@kroah.com> (sfid-20150630_184210_259687_A2DD7667)
References: <1435653278-5168-1-git-send-email-dean.lee@atmel.com>
 <1435653278-5168-4-git-send-email-dean.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1435653278-5168-4-git-send-email-dean.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2015 at 05:34:36PM +0900, Dean Lee wrote:
> change type to pointer.

that describes _what_ you did, which is obvious from the patch, but not
_why_ you did it.  You need to describe this much better before I can
take it.

One comment on the code:

> Signed-off-by: Dean Lee <dean.lee@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 22 +++++++++-------------
>  drivers/staging/wilc1000/host_interface.h |  4 ++--
>  2 files changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 1d59f41..1e40dca 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -640,26 +640,24 @@ static s32 Handle_SetChannel(void *drvHandler, tstrHostIFSetChan *pstrHostIFSetC
>   *  @date
>   *  @version	1.0
>   */
> -static s32 Handle_SetWfiDrvHandler(tstrHostIfSetDrvHandler *pstrHostIfSetDrvHandler)
> +static s32 Handle_SetWfiDrvHandler(void *drvHandler, tstrHostIfSetDrvHandler *pstrHostIfSetDrvHandler)

A void pointer?  No, you have full control over your driver, and the
structures involved, use a pointer to the real structure, and don't use
CamelCase variables for new variables, as you will have to go back and
change it again in the future.

thanks,

greg k-h
