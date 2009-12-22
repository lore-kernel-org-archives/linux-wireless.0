Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:49621 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755352AbZLVXDs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 18:03:48 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3/5] rt2x00: Let rt2800lib check CONFIG_RT2X00_LIB_USB instead of CONFIG_RT2800USB
Date: Wed, 23 Dec 2009 00:03:23 +0100
Message-Id: <1261523005-5856-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1261523005-5856-3-git-send-email-gwingerde@gmail.com>
References: <1261523005-5856-1-git-send-email-gwingerde@gmail.com>
 <1261523005-5856-2-git-send-email-gwingerde@gmail.com>
 <1261523005-5856-3-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2800lib currently checks whether RT2800USB is enabled in the configuration.
Strictly speaking this is not necessary, it only needs to know whether the
generic rt2x00usb library functions are available. Therefore check for
RT2X00_LIB_USB instead.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 27bf887..a654551 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -37,7 +37,7 @@
 #include <linux/module.h>
 
 #include "rt2x00.h"
-#if defined(CONFIG_RT2800USB) || defined(CONFIG_RT2800USB_MODULE)
+#if defined(CONFIG_RT2X00_LIB_USB) || defined(CONFIG_RT2X00_LIB_USB_MODULE)
 #include "rt2x00usb.h"
 #endif
 #include "rt2800lib.h"
@@ -1121,7 +1121,7 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2x00_intf_is_usb(rt2x00dev)) {
 		rt2800_register_write(rt2x00dev, USB_DMA_CFG, 0x00000000);
-#if defined(CONFIG_RT2800USB) || defined(CONFIG_RT2800USB_MODULE)
+#if defined(CONFIG_RT2X00_LIB_USB) || defined(CONFIG_RT2X00_LIB_USB_MODULE)
 		rt2x00usb_vendor_request_sw(rt2x00dev, USB_DEVICE_MODE, 0,
 					    USB_MODE_RESET, REGISTER_TIMEOUT);
 #endif
-- 
1.6.5.7

