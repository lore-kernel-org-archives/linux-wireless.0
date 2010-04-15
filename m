Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab0DODa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:58 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v2 21/97] ath9k_hw: Add abstraction for rx enable
Date: Wed, 14 Apr 2010 23:29:35 -0400
Message-Id: <1271302251-9075-22-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw-ops.h |    5 +++++
 drivers/net/wireless/ath/ath9k/hw.c     |    2 ++
 drivers/net/wireless/ath/ath9k/hw.h     |    1 +
 drivers/net/wireless/ath/ath9k/mac.c    |   17 +++++++++++------
 drivers/net/wireless/ath/ath9k/mac.h    |    3 ++-
 5 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 81f3d03..19259fb 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -28,6 +28,11 @@ static inline void ath9k_hw_configpcipowersave(struct ath_hw *ah,
 	ath9k_hw_ops(ah)->config_pci_powersave(ah, restore, power_off);
 }
 
+static inline void ath9k_hw_rxena(struct ath_hw *ah)
+{
+	ath9k_hw_ops(ah)->rx_enable(ah);
+}
+
 /* Private hardware call ops */
 
 /* PHY ops */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 36c0163..0a4ccd8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1567,6 +1567,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (tsf && AR_SREV_9280(ah) && ah->eep_ops->get_eeprom(ah, EEP_OL_PWRCTRL))
 		ath9k_hw_settsf64(ah, tsf);
 
+	ar9002_hw_attach_mac_ops(ah);
+
 	if (AR_SREV_9280_10_OR_LATER(ah))
 		REG_SET_BIT(ah, AR_GPIO_INPUT_EN_VAL, AR_GPIO_JTAG_DISABLE);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6bd87bf..b07ee8d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -509,6 +509,7 @@ struct ath_hw_ops {
 	void (*config_pci_powersave)(struct ath_hw *ah,
 				     int restore,
 				     int power_off);
+	void (*rx_enable)(struct ath_hw *ah);
 };
 
 struct ath_hw {
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 4a2060e..ae9d54c 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -16,6 +16,17 @@
 
 #include "hw.h"
 
+static void ar9002_hw_rx_enable(struct ath_hw *ah)
+{
+	REG_WRITE(ah, AR_CR, AR_CR_RXE);
+}
+
+void ar9002_hw_attach_mac_ops(struct ath_hw *ah)
+{
+	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
+
+	ops->rx_enable = ar9002_hw_rx_enable;
+}
 static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 					struct ath9k_tx_queue_info *qi)
 {
@@ -999,12 +1010,6 @@ void ath9k_hw_putrxbuf(struct ath_hw *ah, u32 rxdp)
 }
 EXPORT_SYMBOL(ath9k_hw_putrxbuf);
 
-void ath9k_hw_rxena(struct ath_hw *ah)
-{
-	REG_WRITE(ah, AR_CR, AR_CR_RXE);
-}
-EXPORT_SYMBOL(ath9k_hw_rxena);
-
 void ath9k_hw_startpcureceive(struct ath_hw *ah)
 {
 	ath9k_enable_mib_counters(ah);
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 68dbd7a..9e8500a 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -729,10 +729,11 @@ void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags);
 bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set);
 void ath9k_hw_putrxbuf(struct ath_hw *ah, u32 rxdp);
-void ath9k_hw_rxena(struct ath_hw *ah);
 void ath9k_hw_startpcureceive(struct ath_hw *ah);
 void ath9k_hw_stoppcurecv(struct ath_hw *ah);
 bool ath9k_hw_stopdmarecv(struct ath_hw *ah);
 int ath9k_hw_beaconq_setup(struct ath_hw *ah);
 
+void ar9002_hw_attach_mac_ops(struct ath_hw *ah);
+
 #endif /* MAC_H */
-- 
1.6.3.3

