Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:62184 "HELO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751982AbZLMKOx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2009 05:14:53 -0500
Received: by ey-out-2122.google.com with SMTP id d26so638697eyd.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Dec 2009 02:14:51 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 2.6.33] rt2x00: Fix rt2800usb detection in rt2800lib.
Date: Sun, 13 Dec 2009 11:14:48 +0100
Cc: linville@tuxdriver.com, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org
References: <1260661180-2300-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1260661180-2300-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912131114.48894.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 13 December 2009, Gertjan van Wingerde wrote:
> rt2800lib incorrectly detected whether RT2800USB was enabled because
> it didn't account for a modularized RT2800USB driver.

This should be a temporary solution, since rt2800lib shouldn't use the
rt2800usb defines at all (it should be independent of rt2800pci/usb.


> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

But for now:

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> 
> John, this one is a fix for 2.6.33.
> 
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index eb1e1d0..bdc3286 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -33,6 +33,10 @@
>  	Abstract: rt2800 generic device routines.
>   */
>  
> +#ifdef CONFIG_RT2800USB_MODULE
> +#define CONFIG_RT2800USB
> +#endif
> +
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  


