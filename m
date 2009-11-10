Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:58070 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbZKJSe3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 13:34:29 -0500
Received: by mail-ew0-f207.google.com with SMTP id 3so329626ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 10:34:34 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 10/10] rt2x00: Fix building of rt2800lib when rt2x00 driver is built-in.
Date: Tue, 10 Nov 2009 19:34:28 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <1257806315-11089-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1257806315-11089-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911101934.29174.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09 November 2009, Gertjan van Wingerde wrote:
> When enabling rt2800usb as a built-in driver (as opposed to a as a module) the build fails. See
> http://marc.info/?l=linux-wireless&m=125768687711034&w=2 for details.
> 
> Fix it by properly including <linux/usb.h> from rt2x00usb.h
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> 
> John, this is one to merge upstream quickly --> we currently have build failures in next.
> 
> ---
> ---
>  drivers/net/wireless/rt2x00/rt2x00usb.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.h b/drivers/net/wireless/rt2x00/rt2x00usb.h
> index d63e1df..3da6841 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.h
> @@ -26,6 +26,8 @@
>  #ifndef RT2X00USB_H
>  #define RT2X00USB_H
>  
> +#include <linux/usb.h>
> +
>  #define to_usb_device_intf(d) \
>  ({ \
>  	struct usb_interface *intf = to_usb_interface(d); \


