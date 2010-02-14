Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:35860 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab0BNBPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 20:15:16 -0500
Received: by mail-ew0-f228.google.com with SMTP id 28so3034960ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 13 Feb 2010 17:15:16 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 2/3] rt2x00: Reorganize RT chipset setting for PCI/SOC devices.
Date: Sun, 14 Feb 2010 02:15:14 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1266090949-5468-1-git-send-email-gwingerde@gmail.com> <1266090949-5468-2-git-send-email-gwingerde@gmail.com> <1266090949-5468-3-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1266090949-5468-3-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201002140215.14535.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -40,6 +40,9 @@
>  #if defined(CONFIG_RT2X00_LIB_USB) || defined(CONFIG_RT2X00_LIB_USB_MODULE)
>  #include "rt2x00usb.h"
>  #endif
> +#if defined(CONFIG_RT2X00_LIB_PCI) || defined(CONFIG_RT2X00_LIB_PCI_MODULE)
> +#include "rt2x00pci.h"
> +#endif

this is very ugly, but apparently it is unavoidable to make rt2800lib free from
PCI and USB specific code... :(

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Ivo
