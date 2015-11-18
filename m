Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34889 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933224AbbKROqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2015 09:46:43 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/27] mwl8k: move under marvell vendor directory
Date: Wed, 18 Nov 2015 16:45:53 +0200
Message-Id: <1447857966-19560-15-git-send-email-kvalo@codeaurora.org> (sfid-20151118_155327_920856_B059FA15)
In-Reply-To: <1447857966-19560-1-git-send-email-kvalo@codeaurora.org>
References: <1447857966-19560-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Part of reorganising wireless drivers directory and Kconfig.

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 MAINTAINERS                                |    2 +-
 drivers/net/wireless/Kconfig               |    9 ---------
 drivers/net/wireless/Makefile              |    2 --
 drivers/net/wireless/marvell/Kconfig       |    9 +++++++++
 drivers/net/wireless/marvell/Makefile      |    2 ++
 drivers/net/wireless/{ => marvell}/mwl8k.c |    0
 6 files changed, 12 insertions(+), 12 deletions(-)
 rename drivers/net/wireless/{ => marvell}/mwl8k.c (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b889f6972c0..e622877aaab4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6734,7 +6734,7 @@ MARVELL MWL8K WIRELESS DRIVER
 M:	Lennert Buytenhek <buytenh@wantstofly.org>
 L:	linux-wireless@vger.kernel.org
 S:	Odd Fixes
-F:	drivers/net/wireless/mwl8k.c
+F:	drivers/net/wireless/marvell/mwl8k.c
 
 MARVELL SOC MMC/SD/SDIO CONTROLLER DRIVER
 M:	Nicolas Pitre <nico@fluxnic.net>
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 465665237308..315982a5ee73 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -133,15 +133,6 @@ config MAC80211_HWSIM
 	  To compile this driver as a module, choose M here: the module will be
 	  called mac80211_hwsim.  If unsure, say N.
 
-config MWL8K
-	tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
-	depends on MAC80211 && PCI
-	---help---
-	  This driver supports Marvell TOPDOG 802.11 wireless cards.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called mwl8k.  If unsure, say N.
-
 source "drivers/net/wireless/ath/Kconfig"
 source "drivers/net/wireless/hostap/Kconfig"
 source "drivers/net/wireless/orinoco/Kconfig"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 7a95b58a5c76..9498753f596b 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -26,8 +26,6 @@ obj-$(CONFIG_USB_NET_RNDIS_WLAN)	+= rndis_wlan.o
 
 obj-$(CONFIG_USB_ZD1201)	+= zd1201.o
 
-obj-$(CONFIG_MWL8K)	+= mwl8k.o
-
 obj-$(CONFIG_RT2X00)	+= rt2x00/
 
 obj-$(CONFIG_WL_MEDIATEK)	+= mediatek/
diff --git a/drivers/net/wireless/marvell/Kconfig b/drivers/net/wireless/marvell/Kconfig
index bbdbac9a2a45..4938c7ec0009 100644
--- a/drivers/net/wireless/marvell/Kconfig
+++ b/drivers/net/wireless/marvell/Kconfig
@@ -15,4 +15,13 @@ source "drivers/net/wireless/marvell/libertas/Kconfig"
 source "drivers/net/wireless/marvell/libertas_tf/Kconfig"
 source "drivers/net/wireless/marvell/mwifiex/Kconfig"
 
+config MWL8K
+	tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
+	depends on MAC80211 && PCI
+	---help---
+	  This driver supports Marvell TOPDOG 802.11 wireless cards.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called mwl8k.  If unsure, say N.
+
 endif # WLAN_VENDOR_MARVELL
diff --git a/drivers/net/wireless/marvell/Makefile b/drivers/net/wireless/marvell/Makefile
index f4ab48aaff3c..1b0a7d2bc8e6 100644
--- a/drivers/net/wireless/marvell/Makefile
+++ b/drivers/net/wireless/marvell/Makefile
@@ -2,3 +2,5 @@ obj-$(CONFIG_LIBERTAS)		+= libertas/
 
 obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
 obj-$(CONFIG_MWIFIEX)	+= mwifiex/
+
+obj-$(CONFIG_MWL8K)	+= mwl8k.o
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
similarity index 100%
rename from drivers/net/wireless/mwl8k.c
rename to drivers/net/wireless/marvell/mwl8k.c
-- 
1.7.9.5

