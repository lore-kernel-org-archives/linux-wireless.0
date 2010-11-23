Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sdinet.de ([78.47.32.153]:43404 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab0KWUkb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 15:40:31 -0500
Date: Tue, 23 Nov 2010 21:39:06 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: lrodriguez@atheros.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH] compat-wireless: fix activesync devices
Message-ID: <alpine.DEB.2.02.1011232127490.21566@aurora.sdinet.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Compiling support for ActiveSync devices in compat-wireless depends
on USB_NET_CDCETHER to be set in main kernel.

But USB_NET_CDCETHER can also be a module, in which case 
CONFIG_USB_NET_CDCETHER will not be defined inside compat_autoconf.h and 
the compat-wireless cdc_ether.ko will miss the support for it.

So check also for CONFIG_USB_NET_CDCETHER_MODULE in config.mk to be safe 
in both cases.

Signed-off-by: Sven-Haegar Koch <haegar@sdinet.de>
---

I needed to also use an old windows mobile device (Palm Treo 750) 
connected over USB with my laptop which otherwise uses compat-wireless.

But after connecting it I only got:
	usb 2-1: bad CDC descriptors

This happens when in drivers/net/usb/cdc_ether.c 
CONFIG_USB_NET_COMPAT_RNDIS_HOST and 
CONFIG_USB_NET_COMPAT_RNDIS_HOST_MODULE both are not defined, because it 
stubs out the rndis_host support.

Perhaps not the most visually pleasing solution to just include the 
ifdef block in config.mk twice, but everything else would have needed a 
much deeper surgery - and as this is the only usage of ifdef in 
compat.mk where the symbol can also be a module I did not find it to be 
worth the additional complexity.

Tested with compat-wireless-2.6.36-5-spn.tar.bz2, but also happened with
earlier versions and should also apply to newer.

c'ya
sven-haegar

Index: linux/compat-wireless/config.mk
===================================================================
--- compat-wireless.orig/config.mk
+++ compat-wireless/config.mk
@@ -383,6 +383,10 @@ ifdef CONFIG_USB_NET_CDCETHER
 CONFIG_USB_NET_COMPAT_RNDIS_HOST=m
 CONFIG_USB_NET_COMPAT_RNDIS_WLAN=m
 endif #CONFIG_USB_NET_CDCETHER
+ifdef CONFIG_USB_NET_CDCETHER_MODULE
+CONFIG_USB_NET_COMPAT_RNDIS_HOST=m
+CONFIG_USB_NET_COMPAT_RNDIS_WLAN=m
+endif #CONFIG_USB_NET_CDCETHER
 CONFIG_USB_NET_COMPAT_CDCETHER=m
 endif #CONFIG_COMPAT_KERNEL_29
 
