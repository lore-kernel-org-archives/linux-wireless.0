Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:42036 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab2KMUuG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 15:50:06 -0500
Received: by mail-da0-f46.google.com with SMTP id n41so3362779dak.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 12:50:06 -0800 (PST)
Date: Tue, 13 Nov 2012 12:50:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 08/14] staging: vt6656: 64 bit fixes : correct all type
 sizes
Message-ID: <20121113205002.GA27716@kroah.com> (sfid-20121113_215011_442051_0AAA6C8B)
References: <1352648485.6460.16.camel@canaries32-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1352648485.6460.16.camel@canaries32-MCP7A>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 11, 2012 at 03:41:25PM +0000, Malcolm Priestley wrote:
> 
> After this patch all BYTE/WORD/DWORD types can be replaced with the appropriate u sizes.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>  drivers/staging/vt6656/ttype.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/vt6656/ttype.h b/drivers/staging/vt6656/ttype.h
> index 0f70562c..dfbf747 100644
> --- a/drivers/staging/vt6656/ttype.h
> +++ b/drivers/staging/vt6656/ttype.h
> @@ -44,9 +44,9 @@ typedef int             BOOL;
>  
>  /****** Simple typedefs  ***************************************************/
>  
> -typedef unsigned char   BYTE;           //  8-bit
> -typedef unsigned short  WORD;           // 16-bit
> -typedef unsigned long   DWORD;          // 32-bit
> +typedef u8 BYTE;
> +typedef u16 WORD;
> +typedef u32 DWORD;

That's good, but in the end, we want to get rid of BYTE, WORD, and DWORD
usages in this driver, can you just start replacing them with the proper
types?

thanks,

greg k-h
