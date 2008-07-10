Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:52968 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbYGJQ2b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 12:28:31 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1795679fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2008 09:28:30 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Thu, 10 Jul 2008 17:32:17 +0200
Subject: [PATCH 6/6] libertastf: config and makefile
Message-ID: <487638a9.25014e0a.34c2.42c4@mx.google.com> (sfid-20080710_182833_274857_EBF773E9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
Tested-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/Kconfig             |   13 +++++++++++++
 drivers/net/wireless/Makefile            |    2 ++
 drivers/net/wireless/libertastf/Makefile |    6 ++++++
 3 files changed, 21 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/libertastf/Makefile

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 5e0eda0..a14728d 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -276,6 +276,19 @@ config LIBERTAS_DEBUG
 	---help---
 	  Debugging support.
 
+config LIBERTAS_THINFIRM
+	tristate "Marvell 8xxx Libertas WLAN driver support with thin firmware"
+	depends on WLAN_80211 && MAC80211
+	select FW_LOADER
+	---help---
+	  A library for Marvell Libertas 8xxx devices using thinfirm.
+
+config LIBERTAS_THINFIRM_USB
+	tristate "Marvell Libertas 8388 USB 802.11b/g cards with thin firmware"
+	depends on LIBERTAS_THINFIRM && USB
+	---help---
+	  A driver for Marvell Libertas 8388 USB devices using thinfirm.
+
 config AIRO
 	tristate "Cisco/Aironet 34X/35X/4500/4800 ISA and PCI cards"
 	depends on ISA_DMA_API && WLAN_80211 && (PCI || BROKEN)
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index c3e45bd..1b08a2f 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -49,6 +49,8 @@ obj-$(CONFIG_USB_NET_RNDIS_WLAN)	+= rndis_wlan.o
 obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
 obj-$(CONFIG_LIBERTAS)		+= libertas/
 
+obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertastf/
+
 rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o rtl8180_sa2400.o rtl8180_max2820.o rtl8180_grf5101.o
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o
 
diff --git a/drivers/net/wireless/libertastf/Makefile b/drivers/net/wireless/libertastf/Makefile
new file mode 100644
index 0000000..7f8896e
--- /dev/null
+++ b/drivers/net/wireless/libertastf/Makefile
@@ -0,0 +1,6 @@
+libertastf-objs := main.o cmd.o
+
+libertastf_usb-objs += if_usb.o
+
+obj-$(CONFIG_LIBERTAS_THINFIRM) += libertastf.o
+obj-$(CONFIG_LIBERTAS_THINFIRM_USB) += libertastf_usb.o
-- 
1.5.4.3



