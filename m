Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:51642 "HELO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750713AbZLMDy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 22:54:59 -0500
Date: Sat, 12 Dec 2009 19:54:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linville@tuxdriver.com, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2.6.33] rt2x00: Fix rt2800usb detection in rt2800lib.
Message-Id: <20091212195436.62bb66d8.randy.dunlap@oracle.com>
In-Reply-To: <1260661180-2300-1-git-send-email-gwingerde@gmail.com>
References: <1260661180-2300-1-git-send-email-gwingerde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 13 Dec 2009 00:39:39 +0100 Gertjan van Wingerde wrote:

> rt2800lib incorrectly detected whether RT2800USB was enabled because
> it didn't account for a modularized RT2800USB driver.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
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

The idiom that I am familiar with (and is the common one afaik)
is to use:

#if defined(CONFIG_RT2800USB) || defined(CONFIG_RT2800USB_MODULE)

Besides, it's not nice to muck with kconfig symbols outside of Kconfig files.


>  #include <linux/kernel.h>
>  #include <linux/module.h>


---
~Randy
