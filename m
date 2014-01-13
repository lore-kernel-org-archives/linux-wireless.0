Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaAMXph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 18:45:37 -0500
Date: Mon, 13 Jan 2014 15:46:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/6] staging: vt6656: sparse fixes: aes_ccmp.c missing
 header.
Message-ID: <20140113234614.GA16467@kroah.com> (sfid-20140114_004540_919149_5FCFE1B6)
References: <1389630555.2590.6.camel@canaries32-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389630555.2590.6.camel@canaries32-MCP7A>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 13, 2014 at 04:29:15PM +0000, Malcolm Priestley wrote:
> Add missing aes_ccmp.h header and move device.h to
> aes_ccmp.h

Why move device.h?

That shouldn't be needed to fix this issue.

> sparse warning
> aes_ccmp.c:221:6: warning: symbol 'AESbGenCCMP' was not declared. Should it be static?
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/staging/vt6656/aes_ccmp.c | 2 +-
>  drivers/staging/vt6656/aes_ccmp.h | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/vt6656/aes_ccmp.c b/drivers/staging/vt6656/aes_ccmp.c
> index 61b9f7b..3dbf458 100644
> --- a/drivers/staging/vt6656/aes_ccmp.c
> +++ b/drivers/staging/vt6656/aes_ccmp.c
> @@ -30,7 +30,7 @@
>   * Revision History:
>   */
>  
> -#include "device.h"
> +#include "aes_ccmp.h"
>  #include "80211hdr.h"
>  
>  /*
> diff --git a/drivers/staging/vt6656/aes_ccmp.h b/drivers/staging/vt6656/aes_ccmp.h
> index ed6a9ae..4cac3ec 100644
> --- a/drivers/staging/vt6656/aes_ccmp.h
> +++ b/drivers/staging/vt6656/aes_ccmp.h
> @@ -30,6 +30,8 @@
>  #ifndef __AES_H__
>  #define __AES_H__
>  
> +#include "device.h"

If you can prevent it, keeping .h files from having to include other .h
files is a good thing.

thanks,

greg k-h
