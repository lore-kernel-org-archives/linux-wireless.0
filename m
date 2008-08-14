Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:38321 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbYHNRlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 13:41:11 -0400
Received: by fg-out-1718.google.com with SMTP id 19so461794fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 10:41:11 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net, dcbw@redhat.com
From: Luis Carlos Cobo <luisca@cozybit.com>
Subject: [PATCHv2 6/6] libertas_tf: config and makefile
Date: Thu, 14 Aug 2008 10:41:10 -0700 (PDT)
Message-ID: <48a46e36.1438560a.295d.ffff8e22@mx.google.com> (sfid-20080814_194115_243602_0FD587A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 drivers/net/wireless/Kconfig              |   13 +++++++++++++
 drivers/net/wireless/Makefile             |    2 ++
 drivers/net/wireless/libertas_tf/Makefile |    6 ++++++
 3 files changed, 21 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/libertas_tf/Makefile

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index fcbd2cf..2405c54 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -300,6 +300,19 @@ config LIBERTAS_DEBUG
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
index 4a53d1d..ac3faa8 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -50,6 +50,8 @@ obj-$(CONFIG_USB_NET_RNDIS_WLAN)	+= rndis_wlan.o
 obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
 obj-$(CONFIG_LIBERTAS)		+= libertas/
 
+obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
+
 rtl8180-objs		:= rtl8180_dev.o rtl8180_rtl8225.o rtl8180_sa2400.o rtl8180_max2820.o rtl8180_grf5101.o
 rtl8187-objs		:= rtl8187_dev.o rtl8187_rtl8225.o
 
diff --git a/drivers/net/wireless/libertas_tf/Makefile b/drivers/net/wireless/libertas_tf/Makefile
new file mode 100644
index 0000000..ff5544d
--- /dev/null
+++ b/drivers/net/wireless/libertas_tf/Makefile
@@ -0,0 +1,6 @@
+libertas_tf-objs := main.o cmd.o
+
+libertas_tf_usb-objs += if_usb.o
+
+obj-$(CONFIG_LIBERTAS_THINFIRM) += libertas_tf.o
+obj-$(CONFIG_LIBERTAS_THINFIRM_USB) += libertas_tf_usb.o
-- 
1.5.4.3



