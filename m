Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54910 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787Ab1CATDC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 14:03:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	George <george0505@realtek.com>, linux-next@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] rtlwifi: usb parts should depend on CONFIG_USB
Date: Tue,  1 Mar 2011 13:53:02 -0500
Message-Id: <1299005582-7197-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <4D6C1350.6050903@lwfinger.net>
References: <4D6C1350.6050903@lwfinger.net>
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
 drivers/net/wireless/rtlwifi/Makefile |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/Makefile b/drivers/net/wireless/rtlwifi/Makefile
index 9192fd5..ec9393f 100644
--- a/drivers/net/wireless/rtlwifi/Makefile
+++ b/drivers/net/wireless/rtlwifi/Makefile
@@ -7,15 +7,18 @@ rtlwifi-objs	:=		\
 		efuse.o		\
 		ps.o		\
 		rc.o		\
-		regd.o		\
-		usb.o
+		regd.o
 
 rtl8192c_common-objs +=		\
 
-ifeq ($(CONFIG_PCI),y)
+ifneq ($(CONFIG_PCI),)
 rtlwifi-objs	+= pci.o
 endif
 
+ifneq ($(CONFIG_USB),)
+rtlwifi-objs	+= usb.o
+endif
+
 obj-$(CONFIG_RTL8192C_COMMON)	+= rtl8192c/
 obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
 obj-$(CONFIG_RTL8192CU)		+= rtl8192cu/
-- 
1.7.4

