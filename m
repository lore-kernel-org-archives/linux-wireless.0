Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab3FQVzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 17:55:09 -0400
Date: Mon, 17 Jun 2013 14:55:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: mac.c MACvWriteMultiAddr: Remove
 secondary variable byData1
Message-ID: <20130617215508.GA6619@kroah.com> (sfid-20130617_235528_979825_D2BD9CD9)
References: <1371504371.3546.6.camel@canaries64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371504371.3546.6.camel@canaries64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 17, 2013 at 10:26:11PM +0100, Malcolm Priestley wrote:
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/staging/vt6656/mac.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
> index 87c7c8b..5e01be5 100644
> --- a/drivers/staging/vt6656/mac.c
> +++ b/drivers/staging/vt6656/mac.c
> @@ -57,15 +57,13 @@ static int          msglevel                =MSG_LEVEL_INFO;
>   */
>  void MACvWriteMultiAddr(struct vnt_private *pDevice, u32 uByteIdx, u8 byData)
>  {
> -	u8 byData1;
>  
> -    byData1 = byData;
>      CONTROLnsRequestOut(pDevice,
>                          MESSAGE_TYPE_WRITE,
>                          (u16) (MAC_REG_MAR0 + uByteIdx),
>                          MESSAGE_REQUEST_MACREG,
>                          1,
> -                        &byData1);
> +			&byData);

Why are we passing byData in here at all?  What is happening to it that
it needs to be a pointer, and why does this function need it as well?

Something doesn't seem right, care to track this down and fix it up
properly?

thanks,

greg k-h
