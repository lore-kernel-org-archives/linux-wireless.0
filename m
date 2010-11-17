Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35973 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757980Ab0KQDZf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 22:25:35 -0500
Message-ID: <4CE34B2D.3040804@openwrt.org>
Date: Wed, 17 Nov 2010 04:25:33 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH v2 1/2] ath9k: add support for reading eeprom from platform
 data on PCI devices
References: <1289963987-28583-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289963987-28583-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some embedded boards store platform data for connected PCIe AR92xx
chips in the system flash instead of a separate EEPROM chip.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    4 ---
 drivers/net/wireless/ath/ath9k/init.c |    3 ++
 drivers/net/wireless/ath/ath9k/pci.c  |   42 ++++++++++++++++++++++----------
 3 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 986c779..1dbe53b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -419,10 +419,6 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	ah->hw_version.magic = AR5416_MAGIC;
 	ah->hw_version.subvendorid = 0;
 
-	ah->ah_flags = 0;
-	if (!AR_SREV_9100(ah))
-		ah->ah_flags = AH_USE_EEPROM;
-
 	ah->atim_window = 0;
 	ah->sta_id1_defaults =
 		AR_STA_ID1_CRPT_MIC_ENABLE |
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 5c26818d..7eef1fa 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -533,6 +533,9 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	ah->hw_version.subsysid = subsysid;
 	sc->sc_ah = ah;
 
+	if (!sc->dev->platform_data)
+		ah->ah_flags |= AH_USE_EEPROM;
+
 	common = ath9k_hw_common(ah);
 	common->ops = &ath9k_common_ops;
 	common->bus_ops = bus_ops;
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 6605bc2..09f69a9 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -16,6 +16,7 @@
 
 #include <linux/nl80211.h>
 #include <linux/pci.h>
+#include <linux/ath9k_platform.h>
 #include "ath9k.h"
 
 static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
@@ -53,21 +54,36 @@ static void ath_pci_read_cachesize(struct ath_common *common, int *csz)
 
 static bool ath_pci_eeprom_read(struct ath_common *common, u32 off, u16 *data)
 {
-	struct ath_hw *ah = (struct ath_hw *) common->ah;
-
-	common->ops->read(ah, AR5416_EEPROM_OFFSET + (off << AR5416_EEPROM_S));
-
-	if (!ath9k_hw_wait(ah,
-			   AR_EEPROM_STATUS_DATA,
-			   AR_EEPROM_STATUS_DATA_BUSY |
-			   AR_EEPROM_STATUS_DATA_PROT_ACCESS, 0,
-			   AH_WAIT_TIMEOUT)) {
-		return false;
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
+	struct ath9k_platform_data *pdata = sc->dev->platform_data;
+
+	if (pdata) {
+		if (off >= (ARRAY_SIZE(pdata->eeprom_data))) {
+			ath_print(common, ATH_DBG_FATAL,
+				  "%s: eeprom read failed, offset %08x "
+				  "is out of range\n",
+				  __func__, off);
+		}
+
+		*data = pdata->eeprom_data[off];
+	} else {
+		struct ath_hw *ah = (struct ath_hw *) common->ah;
+
+		common->ops->read(ah, AR5416_EEPROM_OFFSET +
+				      (off << AR5416_EEPROM_S));
+
+		if (!ath9k_hw_wait(ah,
+				   AR_EEPROM_STATUS_DATA,
+				   AR_EEPROM_STATUS_DATA_BUSY |
+				   AR_EEPROM_STATUS_DATA_PROT_ACCESS, 0,
+				   AH_WAIT_TIMEOUT)) {
+			return false;
+		}
+
+		*data = MS(common->ops->read(ah, AR_EEPROM_STATUS_DATA),
+			   AR_EEPROM_STATUS_DATA_VAL);
 	}
 
-	*data = MS(common->ops->read(ah, AR_EEPROM_STATUS_DATA),
-		   AR_EEPROM_STATUS_DATA_VAL);
-
 	return true;
 }
 
