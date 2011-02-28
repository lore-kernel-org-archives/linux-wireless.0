Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37916 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab1B1UAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 15:00:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George <george0505@realtek.com>, linux-next@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rtlwifi: usb parts should depend on CONFIG_USB
Date: Mon, 28 Feb 2011 14:48:20 -0500
Message-Id: <1298922500-21632-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <alpine.DEB.2.00.1102171354200.16788@ayla.of.borg>
References: <alpine.DEB.2.00.1102171354200.16788@ayla.of.borg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ERROR: "usb_unanchor_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_control_msg" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_submit_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_get_dev" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_kill_anchored_urbs" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_put_dev" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_free_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_anchor_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
ERROR: "usb_alloc_urb" [drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
make: *** [sub-make] Error 2

The USB-part of rtlwifi should depend on CONFIG_USB.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/rtlwifi/Makefile |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/Makefile b/drivers/net/wireless/rtlwifi/Makefile
index 9192fd5..27355be 100644
--- a/drivers/net/wireless/rtlwifi/Makefile
+++ b/drivers/net/wireless/rtlwifi/Makefile
@@ -7,8 +7,7 @@ rtlwifi-objs	:=		\
 		efuse.o		\
 		ps.o		\
 		rc.o		\
-		regd.o		\
-		usb.o
+		regd.o
 
 rtl8192c_common-objs +=		\
 
@@ -16,6 +15,10 @@ ifeq ($(CONFIG_PCI),y)
 rtlwifi-objs	+= pci.o
 endif
 
+ifeq ($(CONFIG_USB),y)
+rtlwifi-objs	+= usb.o
+endif
+
 obj-$(CONFIG_RTL8192C_COMMON)	+= rtl8192c/
 obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
 obj-$(CONFIG_RTL8192CU)		+= rtl8192cu/
-- 
1.7.4

