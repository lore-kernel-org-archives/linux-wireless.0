Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:48900 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbYBANgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 08:36:09 -0500
Date: Fri, 1 Feb 2008 08:36:06 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	bruno@thinktube.com, jirislaby@gmail.com, mickflemm@gmail.com
Subject: [PATCH 1/3] ath5k: Use our own Kconfig file, we'll be expanding this shortly
Message-ID: <20080201133606.GF28995@ruslug.rutgers.edu> (sfid-20080201_133632_495198_3FD7D311)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use our own Kconfig file, we'll be expanding this shortly.

Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
---
 drivers/net/wireless/Kconfig        |   18 +-----------------
 drivers/net/wireless/ath5k/Kconfig  |   17 +++++++++++++++++
 drivers/net/wireless/ath5k/Makefile |    8 ++++++--
 3 files changed, 24 insertions(+), 19 deletions(-)
 create mode 100644 drivers/net/wireless/ath5k/Kconfig

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 9b1e042..836d862 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -740,23 +740,7 @@ config P54_PCI
 
 	  If you choose to build a module, it'll be called p54pci.
 
-config ATH5K
-	tristate "Atheros 5xxx wireless cards support"
-	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
-	---help---
-	  This module adds support for wireless adapters based on
-	  Atheros 5xxx chipset.
-
-	  Currently the following chip versions are supported:
-
-	  MAC: AR5211 AR5212
-	  PHY: RF5111/2111 RF5112/2112 RF5413/2413
-
-	  This driver uses the kernel's mac80211 subsystem.
-
-	  If you choose to build a module, it'll be called ath5k. Say M if
-	  unsure.
-
+source "drivers/net/wireless/ath5k/Kconfig"
 source "drivers/net/wireless/iwlwifi/Kconfig"
 source "drivers/net/wireless/hostap/Kconfig"
 source "drivers/net/wireless/bcm43xx/Kconfig"
diff --git a/drivers/net/wireless/ath5k/Kconfig b/drivers/net/wireless/ath5k/Kconfig
new file mode 100644
index 0000000..55f0c09
--- /dev/null
+++ b/drivers/net/wireless/ath5k/Kconfig
@@ -0,0 +1,17 @@
+
+config ATH5K
+	tristate "Atheros 5xxx wireless cards support"
+	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+	---help---
+	  This module adds support for wireless adapters based on
+	  Atheros 5xxx chipset.
+
+	  Currently the following chip versions are supported:
+
+	  MAC: AR5211 AR5212
+	  PHY: RF5111/2111 RF5112/2112 RF5413/2413
+
+	  This driver uses the kernel's mac80211 subsystem.
+
+	  If you choose to build a module, it'll be called ath5k. Say M if
+	  unsure.
diff --git a/drivers/net/wireless/ath5k/Makefile b/drivers/net/wireless/ath5k/Makefile
index ada1095..564ecd0 100644
--- a/drivers/net/wireless/ath5k/Makefile
+++ b/drivers/net/wireless/ath5k/Makefile
@@ -1,2 +1,6 @@
-ath5k-objs		= base.o hw.o initvals.o phy.o debug.o
-obj-$(CONFIG_ATH5K)	+= ath5k.o
+ath5k-y				+= base.o
+ath5k-y				+= hw.o
+ath5k-y				+= initvals.o
+ath5k-y				+= phy.o
+ath5k-$(CONFIG_ATH5K_DEBUG)	+= debug.o
+obj-$(CONFIG_ATH5K)		+= ath5k.o
-- 
1.5.3.7

