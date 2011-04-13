Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60415 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758376Ab1DMT4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 15:56:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org
Subject: [PATCH 3/5] ath5k: add a new bus op for reading the mac address
Date: Wed, 13 Apr 2011 21:56:44 +0200
Message-Id: <1302724606-10190-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1302724606-10190-2-git-send-email-nbd@openwrt.org>
References: <1302724606-10190-1-git-send-email-nbd@openwrt.org>
 <1302724606-10190-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On AHB, the calibration data usually does not contain a valid MAC address,
the correct MAC address is stored in the board config.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath5k/ahb.c    |   18 +++++++++++++++++
 drivers/net/wireless/ath/ath5k/ath5k.h  |    2 +-
 drivers/net/wireless/ath/ath5k/base.c   |    2 +-
 drivers/net/wireless/ath/ath5k/eeprom.c |   29 ----------------------------
 drivers/net/wireless/ath/ath5k/pci.c    |   32 +++++++++++++++++++++++++++++++
 5 files changed, 52 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
index 82324e9..1374e64 100644
--- a/drivers/net/wireless/ath/ath5k/ahb.c
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -18,6 +18,7 @@
 
 #include <linux/nl80211.h>
 #include <linux/platform_device.h>
+#include <linux/etherdevice.h>
 #include <ar231x_platform.h>
 #include "ath5k.h"
 #include "debug.h"
@@ -62,10 +63,27 @@ int ath5k_hw_read_srev(struct ath5k_hw *ah)
 	return 0;
 }
 
+static int ath5k_ahb_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
+{
+	struct ath5k_softc *sc = ah->ah_sc;
+	struct platform_device *pdev = to_platform_device(sc->dev);
+	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
+	u8 *cfg_mac;
+
+	if (to_platform_device(sc->dev)->id == 0)
+		cfg_mac = bcfg->config->wlan0_mac;
+	else
+		cfg_mac = bcfg->config->wlan1_mac;
+
+	memcpy(mac, cfg_mac, ETH_ALEN);
+	return 0;
+}
+
 static const struct ath_bus_ops ath_ahb_bus_ops = {
 	.ath_bus_type = ATH_AHB,
 	.read_cachesize = ath5k_ahb_read_cachesize,
 	.eeprom_read = ath5k_ahb_eeprom_read,
+	.eeprom_read_mac = ath5k_ahb_eeprom_read_mac,
 };
 
 /*Initialization*/
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 266e548..bb50700 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1159,6 +1159,7 @@ struct ath_bus_ops {
 	enum ath_bus_type ath_bus_type;
 	void (*read_cachesize)(struct ath_common *common, int *csz);
 	bool (*eeprom_read)(struct ath_common *common, u32 off, u16 *data);
+	int (*eeprom_read_mac)(struct ath5k_hw *ah, u8 *mac);
 };
 
 /*
@@ -1244,7 +1245,6 @@ int ath5k_hw_dma_stop(struct ath5k_hw *ah);
 /* EEPROM access functions */
 int ath5k_eeprom_init(struct ath5k_hw *ah);
 void ath5k_eeprom_detach(struct ath5k_hw *ah);
-int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac);
 
 
 /* Protocol Control Unit Functions */
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 16349d6..203243b 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2880,7 +2880,7 @@ ath5k_init(struct ieee80211_hw *hw)
 	INIT_WORK(&sc->reset_work, ath5k_reset_work);
 	INIT_DELAYED_WORK(&sc->tx_complete_work, ath5k_tx_complete_poll_work);
 
-	ret = ath5k_eeprom_read_mac(ah, mac);
+	ret = ath5k_hw_common(ah)->bus_ops->eeprom_read_mac(ah, mac);
 	if (ret) {
 		ATH5K_ERR(sc, "unable to read address from EEPROM\n");
 		goto err_queues;
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 0aaaab2..1fef84f 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1732,35 +1732,6 @@ ath5k_eeprom_read_spur_chans(struct ath5k_hw *ah)
 	return ret;
 }
 
-/*
- * Read the MAC address from eeprom
- */
-int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
-{
-	u8 mac_d[ETH_ALEN] = {};
-	u32 total, offset;
-	u16 data;
-	int octet;
-
-	AR5K_EEPROM_READ(0x20, data);
-
-	for (offset = 0x1f, octet = 0, total = 0; offset >= 0x1d; offset--) {
-		AR5K_EEPROM_READ(offset, data);
-
-		total += data;
-		mac_d[octet + 1] = data & 0xff;
-		mac_d[octet] = data >> 8;
-		octet += 2;
-	}
-
-	if (!total || total == 3 * 0xffff)
-		return -EINVAL;
-
-	memcpy(mac, mac_d, ETH_ALEN);
-
-	return 0;
-}
-
 
 /***********************\
 * Init/Detach functions *
diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index 3c44689..296c316 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -17,6 +17,7 @@
 #include <linux/nl80211.h>
 #include <linux/pci.h>
 #include <linux/pci-aspm.h>
+#include <linux/etherdevice.h>
 #include "../ath.h"
 #include "ath5k.h"
 #include "debug.h"
@@ -108,11 +109,42 @@ int ath5k_hw_read_srev(struct ath5k_hw *ah)
 	return 0;
 }
 
+/*
+ * Read the MAC address from eeprom or platform_data
+ */
+static int ath5k_pci_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
+{
+	u8 mac_d[ETH_ALEN] = {};
+	u32 total, offset;
+	u16 data;
+	int octet;
+
+	AR5K_EEPROM_READ(0x20, data);
+
+	for (offset = 0x1f, octet = 0, total = 0; offset >= 0x1d; offset--) {
+		AR5K_EEPROM_READ(offset, data);
+
+		total += data;
+		mac_d[octet + 1] = data & 0xff;
+		mac_d[octet] = data >> 8;
+		octet += 2;
+	}
+
+	if (!total || total == 3 * 0xffff)
+		return -EINVAL;
+
+	memcpy(mac, mac_d, ETH_ALEN);
+
+	return 0;
+}
+
+
 /* Common ath_bus_opts structure */
 static const struct ath_bus_ops ath_pci_bus_ops = {
 	.ath_bus_type = ATH_PCI,
 	.read_cachesize = ath5k_pci_read_cachesize,
 	.eeprom_read = ath5k_pci_eeprom_read,
+	.eeprom_read_mac = ath5k_pci_eeprom_read_mac,
 };
 
 /********************\
-- 
1.7.3.2

