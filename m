Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:41018 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab1DLQX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 12:23:27 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH] ath9k: introduce ATH9K_{PCI,AHB} config options
Date: Tue, 12 Apr 2011 18:23:16 +0200
Message-Id: <1302625396-20325-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently ath9k only available in menuconfig if PCI bus
support is enabled. However the driver is required for
the built-in wireless MACs of the Atheros AR9130/AR9132
SoCs. These SoCs have no PCI controller, the wireless
MAC is connected to the AHB bus on them.

Introduce separated config options for the supported
buses, in order to allow building of ath9h without PCI
bus support.

As a bonus, this patch removes the cross-reference of
the ATHEROS_AR71XX option which is not present in the
kernel.

Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/Kconfig  |   21 ++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/Makefile |    4 ++--
 drivers/net/wireless/ath/ath9k/ath9k.h  |    4 ++--
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index ad57a6d..21502f4 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -5,7 +5,7 @@ config ATH9K_COMMON
 
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
-	depends on PCI && MAC80211
+	depends on MAC80211
 	select ATH9K_HW
 	select MAC80211_LEDS
 	select LEDS_CLASS
@@ -23,6 +23,25 @@ config ATH9K
 
 	  If you choose to build a module, it'll be called ath9k.
 
+config ATH9K_PCI
+	bool "Atheros ath9k PCI/PCIe bus support"
+	depends on ATH9K && PCI
+	default PCI
+	---help---
+	  This option enables the PCI bus support in ath9k.
+
+	  Say Y, if you have a compatible PCI/PCIe wireless card.
+
+config ATH9K_AHB
+	bool "Atheros ath9k AHB bus support"
+	depends on ATH9K
+	default n
+	---help---
+	  This option enables the AHB bus support in ath9k. 
+
+	  Say Y, if you have a SoC with a compatible built-in
+	  wireless MAC. Say N if unsure.
+
 config ATH9K_DEBUGFS
 	bool "Atheros ath9k debugging"
 	depends on ATH9K && DEBUG_FS
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 4d66ca8..ca4c436 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -6,8 +6,8 @@ ath9k-y +=	beacon.o \
 		xmit.o \
 
 ath9k-$(CONFIG_ATH9K_RATE_CONTROL) += rc.o
-ath9k-$(CONFIG_PCI) += pci.o
-ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
+ath9k-$(CONFIG_ATH9K_PCI) += pci.o
+ath9k-$(CONFIG_ATH9K_AHB) += ahb.o
 ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
 
 obj-$(CONFIG_ATH9K) += ath9k.o
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 38835bc..77ad407 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -665,7 +665,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw);
 bool ath9k_setpower(struct ath_softc *sc, enum ath9k_power_mode mode);
 bool ath9k_uses_beacons(int type);
 
-#ifdef CONFIG_PCI
+#ifdef CONFIG_ATH9K_PCI
 int ath_pci_init(void);
 void ath_pci_exit(void);
 #else
@@ -673,7 +673,7 @@ static inline int ath_pci_init(void) { return 0; };
 static inline void ath_pci_exit(void) {};
 #endif
 
-#ifdef CONFIG_ATHEROS_AR71XX
+#ifdef CONFIG_ATH9K_AHB
 int ath_ahb_init(void);
 void ath_ahb_exit(void);
 #else
-- 
1.7.2.1

