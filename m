Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.187]:38996 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbYBJVx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Feb 2008 16:53:56 -0500
Received: by fk-out-0910.google.com with SMTP id z23so4239380fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2008 13:53:56 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 12/14] rt2x00: Cleanup Makefile
Date: Sun, 10 Feb 2008 22:52:10 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802102246.04515.IvDoorn@gmail.com>
In-Reply-To: <200802102246.04515.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802102252.10152.IvDoorn@gmail.com> (sfid-20080210_215359_002593_8CADB8F4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify the way rt2x00 assigns new objects to the
rt2x00lib module. This saves a few if statements
and overall does this looks much nicer.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Makefile |   41 +++++++++++++--------------------
 1 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Makefile b/drivers/net/wireless/rt2x00/Makefile
index 757bbc0..1087dbc 100644
--- a/drivers/net/wireless/rt2x00/Makefile
+++ b/drivers/net/wireless/rt2x00/Makefile
@@ -1,26 +1,17 @@
-rt2x00lib-objs := rt2x00dev.o rt2x00mac.o rt2x00config.o rt2x00queue.o
+rt2x00lib-y				+= rt2x00dev.o
+rt2x00lib-y				+= rt2x00mac.o
+rt2x00lib-y				+= rt2x00config.o
+rt2x00lib-y				+= rt2x00queue.o
+rt2x00lib-$(CONFIG_RT2X00_LIB_DEBUGFS)	+= rt2x00debug.o
+rt2x00lib-$(CONFIG_RT2X00_LIB_RFKILL)	+= rt2x00rfkill.o
+rt2x00lib-$(CONFIG_RT2X00_LIB_FIRMWARE)	+= rt2x00firmware.o
+rt2x00lib-$(CONFIG_RT2X00_LIB_LEDS)	+= rt2x00leds.o
 
-ifeq ($(CONFIG_RT2X00_LIB_DEBUGFS),y)
-	rt2x00lib-objs += rt2x00debug.o
-endif
-
-ifeq ($(CONFIG_RT2X00_LIB_RFKILL),y)
-	rt2x00lib-objs += rt2x00rfkill.o
-endif
-
-ifeq ($(CONFIG_RT2X00_LIB_FIRMWARE),y)
-	rt2x00lib-objs += rt2x00firmware.o
-endif
-
-ifeq ($(CONFIG_RT2X00_LIB_LEDS),y)
-	rt2x00lib-objs += rt2x00leds.o
-endif
-
-obj-$(CONFIG_RT2X00_LIB)	+= rt2x00lib.o
-obj-$(CONFIG_RT2X00_LIB_PCI)	+= rt2x00pci.o
-obj-$(CONFIG_RT2X00_LIB_USB)	+= rt2x00usb.o
-obj-$(CONFIG_RT2400PCI)		+= rt2400pci.o
-obj-$(CONFIG_RT2500PCI)		+= rt2500pci.o
-obj-$(CONFIG_RT61PCI)		+= rt61pci.o
-obj-$(CONFIG_RT2500USB)		+= rt2500usb.o
-obj-$(CONFIG_RT73USB)		+= rt73usb.o
+obj-$(CONFIG_RT2X00_LIB)		+= rt2x00lib.o
+obj-$(CONFIG_RT2X00_LIB_PCI)		+= rt2x00pci.o
+obj-$(CONFIG_RT2X00_LIB_USB)		+= rt2x00usb.o
+obj-$(CONFIG_RT2400PCI)			+= rt2400pci.o
+obj-$(CONFIG_RT2500PCI)			+= rt2500pci.o
+obj-$(CONFIG_RT61PCI)			+= rt61pci.o
+obj-$(CONFIG_RT2500USB)			+= rt2500usb.o
+obj-$(CONFIG_RT73USB)			+= rt73usb.o
-- 
1.5.4

