Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43506 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab1BWQOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 11:14:33 -0500
Date: Wed, 23 Feb 2011 10:14:34 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: sfr@canb.auug.org.au, otavio@ossystems.com.br, w@1wt.eu,
	george0505@realtek.com, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2 3/5] rtlwifi: rtl8192cu: Fix for build error if PCI is
 not present
Message-ID: <4d65326a.4BU5NCcHR3noU7KS%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Willy Tarreau <w@1wt.eu>
Date: Sun, 20 Feb 2011 11:43:07 +0100
Subject: rtlwifi: Let rtlwifi build when PCI is not enabled

On systems where PCI does not exist, a build of rtlwifi will fail. 
Apply the same fix in case there are systems with PCI but not USB.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 drivers/net/wireless/rtlwifi/Makefile |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

Index: wireless-testing/drivers/net/wireless/rtlwifi/Makefile
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/Makefile
+++ wireless-testing/drivers/net/wireless/rtlwifi/Makefile
@@ -5,12 +5,15 @@ rtlwifi-objs	:=		\
 		core.o		\
 		debug.o		\
 		efuse.o		\
-		pci.o		\
 		ps.o		\
 		rc.o		\
 		regd.o		\
 		usb.o
 
+ifeq ($(CONFIG_PCI),y)
+rtlwifi-objs	+= pci.o
+endif
+
 obj-$(CONFIG_RTL8192CE)		+= rtl8192ce/
 obj-$(CONFIG_RTL8192CU)		+= rtl8192cu/
 
