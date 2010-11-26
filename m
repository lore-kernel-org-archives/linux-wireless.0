Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:33367 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab0KZJ4t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 04:56:49 -0500
Date: Fri, 26 Nov 2010 10:56:47 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org
Message-ID: <488124.461290765406088.JavaMail.wlan@CHBU500181>
In-Reply-To: <30797517.261290765072234.JavaMail.wlan@CHBU500181>
Subject: [PATCH v6 4/9] ath5k: Use generic eeprom read from common
 ath_bus_opts struct.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |    6 +++++
 drivers/net/wireless/ath/ath5k/eeprom.c |   38 +-----------------------------
 drivers/net/wireless/ath/ath5k/eeprom.h |    2 +-
 drivers/net/wireless/ath/ath5k/pci.c    |   36 +++++++++++++++++++++++++++++
 4 files changed, 45 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 68e1794..946e54a 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1316,6 +1316,12 @@ static inline void ath5k_read_cachesize(struct ath_common *common, int *csz)
 	common->bus_ops->read_cachesize(common, csz);
 }
 
+static inline bool ath5k_hw_nvram_read(struct ath5k_hw *ah, u32 off, u16 *data)
+{
+	struct ath_common *common = ath5k_hw_common(ah);
+	return common->bus_ops->eeprom_read(common, off, data);
+}
+
 static inline u32 ath5k_hw_bitswap(u32 val, unsigned int bits)
 {
 	u32 retval = 0, bit, i;
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 2112b53..92d8340 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -29,40 +29,6 @@
 #include "base.h"
 
 /*
- * Read from eeprom
- */
-static int ath5k_hw_eeprom_read(struct ath5k_hw *ah, u32 offset, u16 *data)
-{
-	u32 status, timeout;
-
-	/*
-	 * Initialize EEPROM access
-	 */
-	if (ah->ah_version == AR5K_AR5210) {
-		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, AR5K_PCICFG_EEAE);
-		(void)ath5k_hw_reg_read(ah, AR5K_EEPROM_BASE + (4 * offset));
-	} else {
-		ath5k_hw_reg_write(ah, offset, AR5K_EEPROM_BASE);
-		AR5K_REG_ENABLE_BITS(ah, AR5K_EEPROM_CMD,
-				AR5K_EEPROM_CMD_READ);
-	}
-
-	for (timeout = AR5K_TUNE_REGISTER_TIMEOUT; timeout > 0; timeout--) {
-		status = ath5k_hw_reg_read(ah, AR5K_EEPROM_STATUS);
-		if (status & AR5K_EEPROM_STAT_RDDONE) {
-			if (status & AR5K_EEPROM_STAT_RDERR)
-				return -EIO;
-			*data = (u16)(ath5k_hw_reg_read(ah, AR5K_EEPROM_DATA) &
-					0xffff);
-			return 0;
-		}
-		udelay(15);
-	}
-
-	return -ETIMEDOUT;
-}
-
-/*
  * Translate binary channel representation in EEPROM to frequency
  */
 static u16 ath5k_eeprom_bin2freq(struct ath5k_eeprom_info *ee, u16 bin,
@@ -1797,12 +1763,12 @@ int ath5k_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
 	u16 data;
 	int octet, ret;
 
-	ret = ath5k_hw_eeprom_read(ah, 0x20, &data);
+	ret = ath5k_hw_nvram_read(ah, 0x20, &data);
 	if (ret)
 		return ret;
 
 	for (offset = 0x1f, octet = 0, total = 0; offset >= 0x1d; offset--) {
-		ret = ath5k_hw_eeprom_read(ah, offset, &data);
+		ret = ath5k_hw_nvram_read(ah, offset, &data);
 		if (ret)
 			return ret;
 
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index c4a6d5f..0017006 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -241,7 +241,7 @@ enum ath5k_eeprom_freq_bands{
 #define	AR5K_SPUR_SYMBOL_WIDTH_TURBO_100Hz	6250
 
 #define AR5K_EEPROM_READ(_o, _v) do {			\
-	ret = ath5k_hw_eeprom_read(ah, (_o), &(_v));	\
+	ret = ath5k_hw_nvram_read(ah, (_o), &(_v));	\
 	if (ret)					\
 		return ret;				\
 } while (0)
diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index 9f7d3ca..3f26cf2 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -65,10 +65,46 @@ static void ath5k_pci_read_cachesize(struct ath_common *common, int *csz)
 		*csz = L1_CACHE_BYTES >> 2;   /* Use the default size */
 }
 
+/*
+ * Read from eeprom
+ */
+bool ath5k_pci_eeprom_read(struct ath_common *common, u32 offset, u16 *data)
+{
+	struct ath5k_hw *ah = (struct ath5k_hw *) common->ah;
+	u32 status, timeout;
+
+	/*
+	 * Initialize EEPROM access
+	 */
+	if (ah->ah_version == AR5K_AR5210) {
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, AR5K_PCICFG_EEAE);
+		(void)ath5k_hw_reg_read(ah, AR5K_EEPROM_BASE + (4 * offset));
+	} else {
+		ath5k_hw_reg_write(ah, offset, AR5K_EEPROM_BASE);
+		AR5K_REG_ENABLE_BITS(ah, AR5K_EEPROM_CMD,
+				AR5K_EEPROM_CMD_READ);
+	}
+
+	for (timeout = AR5K_TUNE_REGISTER_TIMEOUT; timeout > 0; timeout--) {
+		status = ath5k_hw_reg_read(ah, AR5K_EEPROM_STATUS);
+		if (status & AR5K_EEPROM_STAT_RDDONE) {
+			if (status & AR5K_EEPROM_STAT_RDERR)
+				return -EIO;
+			*data = (u16)(ath5k_hw_reg_read(ah, AR5K_EEPROM_DATA) &
+					0xffff);
+			return 0;
+		}
+		udelay(15);
+	}
+
+	return -ETIMEDOUT;
+}
+
 /* Common ath_bus_opts structure */
 static const struct ath_bus_ops ath_pci_bus_ops = {
 	.ath_bus_type = ATH_PCI,
 	.read_cachesize = ath5k_pci_read_cachesize,
+	.eeprom_read = ath5k_pci_eeprom_read,
 };
 
 /********************\
-- 
1.7.1

