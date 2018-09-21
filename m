Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:40791 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388826AbeIULwP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 07:52:15 -0400
From: <yhchuang@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <tehuang@realtek.com>
Subject: [PATCH 12/12] rtwlan: Kconfig & Makefile
Date: Fri, 21 Sep 2018 14:04:07 +0800
Message-ID: <1537509847-21087-13-git-send-email-yhchuang@realtek.com> (sfid-20180921_080505_791909_96FA697B)
In-Reply-To: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yan-Hsuan Chuang <yhchuang@realtek.com>

Kconfig & Makefile for Realtek 802.11ac wireless network chips

Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
---
 drivers/net/wireless/realtek/Kconfig         |  1 +
 drivers/net/wireless/realtek/Makefile        |  1 +
 drivers/net/wireless/realtek/rtwlan/Kconfig  | 55 ++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtwlan/Makefile | 21 +++++++++++
 4 files changed, 78 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtwlan/Kconfig
 create mode 100644 drivers/net/wireless/realtek/rtwlan/Makefile

diff --git a/drivers/net/wireless/realtek/Kconfig b/drivers/net/wireless/realtek/Kconfig
index 3db988e..044f807 100644
--- a/drivers/net/wireless/realtek/Kconfig
+++ b/drivers/net/wireless/realtek/Kconfig
@@ -14,5 +14,6 @@ if WLAN_VENDOR_REALTEK
 source "drivers/net/wireless/realtek/rtl818x/Kconfig"
 source "drivers/net/wireless/realtek/rtlwifi/Kconfig"
 source "drivers/net/wireless/realtek/rtl8xxxu/Kconfig"
+source "drivers/net/wireless/realtek/rtwlan/Kconfig"
 
 endif # WLAN_VENDOR_REALTEK
diff --git a/drivers/net/wireless/realtek/Makefile b/drivers/net/wireless/realtek/Makefile
index 9c78deb..d7bd304 100644
--- a/drivers/net/wireless/realtek/Makefile
+++ b/drivers/net/wireless/realtek/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_RTL8180)		+= rtl818x/
 obj-$(CONFIG_RTL8187)		+= rtl818x/
 obj-$(CONFIG_RTLWIFI)		+= rtlwifi/
 obj-$(CONFIG_RTL8XXXU)		+= rtl8xxxu/
+obj-$(CONFIG_RTWLAN)		+= rtwlan/
 
diff --git a/drivers/net/wireless/realtek/rtwlan/Kconfig b/drivers/net/wireless/realtek/rtwlan/Kconfig
new file mode 100644
index 0000000..93cefbf
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtwlan/Kconfig
@@ -0,0 +1,55 @@
+menuconfig RTWLAN
+	tristate "Realtek 802.11ac wireless chips support"
+	depends on MAC80211
+	default y
+	help
+	  This module adds support for mac80211-based wireless drivers that
+	  enables Realtek IEEE 802.11ac wireless chipsets.
+
+	  If you choose to build a module, it'll be called rtwlan.
+
+if RTWLAN
+
+config RTWLAN_CORE
+	tristate
+	depends on RTWLAN
+
+config RTWLAN_PCI
+	tristate
+	depends on RTWLAN_CORE && PCI
+
+config RTWLAN_8822BE
+	bool "Realtek 8822BE PCI wireless network adapter"
+	select RTWLAN_CORE
+	select RTWLAN_PCI
+	help
+	  Select this option will enable support for 8822BE chipset
+
+	  802.11ac PCIe wireless network adapter
+
+config RTWLAN_8822CE
+	bool "Realtek 8822CE PCI wireless network adapter"
+	select RTWLAN_CORE
+	select RTWLAN_PCI
+	help
+	  Select this option will enable support for 8822CE chipset
+
+	  802.11ac PCIe wireless network adapter
+
+config RTWLAN_DEBUG
+	bool "Realtek rtwlan debug support"
+	depends on RTWLAN_CORE
+	help
+	  Enable debug support
+
+	  If unsure, say Y to simplify debug problems
+
+config RTWLAN_DEBUGFS
+	bool "Realtek rtwlan debugfs support"
+	depends on RTWLAN_CORE
+	help
+	  Enable debug support
+
+	  If unsure, say Y to simplify debug problems
+
+endif
diff --git a/drivers/net/wireless/realtek/rtwlan/Makefile b/drivers/net/wireless/realtek/rtwlan/Makefile
new file mode 100644
index 0000000..dc6cd08a
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtwlan/Makefile
@@ -0,0 +1,21 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_RTWLAN_CORE)	+= rtwlan.o
+rtwlan-y += main.o \
+	    mac80211.o \
+	    debug.o \
+	    tx.o \
+	    rx.o \
+	    mac.o \
+	    phy.o \
+	    efuse.o \
+	    fw.o \
+	    ps.o \
+	    sec.o \
+	    regd.o
+
+rtwlan-$(CONFIG_RTWLAN_8822BE)	+= rtw8822b.o rtw8822b_table.o
+rtwlan-$(CONFIG_RTWLAN_8822CE)	+= rtw8822c.o rtw8822c_table.o
+
+obj-$(CONFIG_RTWLAN_PCI)	+= rtwpci.o
+rtwpci-objs			:= pci.o
-- 
2.7.4
