Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42940 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1CATzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 14:55:10 -0500
Message-ID: <4D6D4F12.4000403@lwfinger.net>
Date: Tue, 01 Mar 2011 13:54:58 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	George <george0505@realtek.com>, linux-next@vger.kernel.org
Subject: Re: [PATCH v2] rtlwifi: usb parts should depend on CONFIG_USB
References: <4D6C1350.6050903@lwfinger.net> <1299005582-7197-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1299005582-7197-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/01/2011 12:53 PM, John W. Linville wrote:
> ERROR: "usb_unanchor_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
> ERROR: "usb_control_msg" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
> ERROR: "usb_submit_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
> ERROR: "usb_get_dev" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
> ERROR: "usb_kill_anchored_urbs" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
> ERROR: "usb_put_dev" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
> ERROR: "usb_free_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
> ERROR: "usb_anchor_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
> ERROR: "usb_alloc_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
> make[2]: *** [__modpost] Error 1
> make[1]: *** [modules] Error 2
> make: *** [sub-make] Error 2
>
> The USB-part of rtlwifi should depend on CONFIG_USB.
>
> Reported-by: Geert Uytterhoeven<geert@linux-m68k.org>
> Signed-off-by: John W. Linville<linville@tuxdriver.com>
> ---
>   drivers/net/wireless/rtlwifi/Makefile |    9 ++++++---
>   1 files changed, 6 insertions(+), 3 deletions(-)
>

John,

If you change the commit message to indicate that you also fixed the case where 
CONFIG_PCI is m, then ACK.

Larry

> diff --git a/drivers/net/wireless/rtlwifi/Makefile b/drivers/net/wireless/rtlwifi/Makefile
> index 9192fd5..ec9393f 100644
> --- a/drivers/net/wireless/rtlwifi/Makefile
> +++ b/drivers/net/wireless/rtlwifi/Makefile
> @@ -7,15 +7,18 @@ rtlwifi-objs	:=		\
>   		efuse.o		\
>   		ps.o		\
>   		rc.o		\
> -		regd.o		\
> -		usb.o
> +		regd.o
>
>   rtl8192c_common-objs +=		\
>
> -ifeq ($(CONFIG_PCI),y)
> +ifneq ($(CONFIG_PCI),)
>   rtlwifi-objs	+= pci.o
>   endif
>
> +ifneq ($(CONFIG_USB),)
> +rtlwifi-objs	+= usb.o
> +endif
> +
>   obj-$(CONFIG_RTL8192C_COMMON)	+= rtl8192c/
>   obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
>   obj-$(CONFIG_RTL8192CU)		+= rtl8192cu/

