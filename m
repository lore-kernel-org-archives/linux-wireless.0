Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:51389 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZD2LVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 07:21:37 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] ath9k: uninline ath9k_io{read,write}32 routines
Date: Wed, 29 Apr 2009 13:01:58 +0200
Message-Id: <1241002918-27818-1-git-send-email-juhosg@openwrt.org> (sfid-20090429_132150_426503_413829D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The spin_lock handling uses lots of instructions on some archs.
With this patch the size of the ath9k module will be significantly
smaller.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Example results on different platforms:

xscale:     468344 -> 293022 (62.6%)
mips32:     549847 -> 389421 (70.8%)
mips32r2:   510520 -> 394020 (77.2%)
ppc40x:     365153 -> 296928 (81.3%)

 drivers/net/wireless/ath/ath9k/ath9k.h |   33 +------------------------------
 drivers/net/wireless/ath/ath9k/hw.c    |   32 +++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ca12b31..eb60ba3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -701,36 +701,7 @@ void ath9k_wiphy_pause_all_forced(struct ath_softc *sc,
 bool ath9k_wiphy_scanning(struct ath_softc *sc);
 void ath9k_wiphy_work(struct work_struct *work);
 
-/*
- * Read and write, they both share the same lock. We do this to serialize
- * reads and writes on Atheros 802.11n PCI devices only. This is required
- * as the FIFO on these devices can only accept sanely 2 requests. After
- * that the device goes bananas. Serializing the reads/writes prevents this
- * from happening.
- */
-
-static inline void ath9k_iowrite32(struct ath_hw *ah, u32 reg_offset, u32 val)
-{
-	if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
-		unsigned long flags;
-		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
-		iowrite32(val, ah->ah_sc->mem + reg_offset);
-		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
-	} else
-		iowrite32(val, ah->ah_sc->mem + reg_offset);
-}
-
-static inline unsigned int ath9k_ioread32(struct ath_hw *ah, u32 reg_offset)
-{
-	u32 val;
-	if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
-		unsigned long flags;
-		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
-		val = ioread32(ah->ah_sc->mem + reg_offset);
-		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
-	} else
-		val = ioread32(ah->ah_sc->mem + reg_offset);
-	return val;
-}
+void ath9k_iowrite32(struct ath_hw *ah, u32 reg_offset, u32 val);
+unsigned int ath9k_ioread32(struct ath_hw *ah, u32 reg_offset);
 
 #endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ec2a7a4..02f4015 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -84,6 +84,38 @@ static u32 ath9k_hw_mac_to_clks(struct ath_hw *ah, u32 usecs)
 		return ath9k_hw_mac_clks(ah, usecs);
 }
 
+/*
+ * Read and write, they both share the same lock. We do this to serialize
+ * reads and writes on Atheros 802.11n PCI devices only. This is required
+ * as the FIFO on these devices can only accept sanely 2 requests. After
+ * that the device goes bananas. Serializing the reads/writes prevents this
+ * from happening.
+ */
+
+void ath9k_iowrite32(struct ath_hw *ah, u32 reg_offset, u32 val)
+{
+	if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
+		unsigned long flags;
+		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
+		iowrite32(val, ah->ah_sc->mem + reg_offset);
+		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
+	} else
+		iowrite32(val, ah->ah_sc->mem + reg_offset);
+}
+
+unsigned int ath9k_ioread32(struct ath_hw *ah, u32 reg_offset)
+{
+	u32 val;
+	if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
+		unsigned long flags;
+		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
+		val = ioread32(ah->ah_sc->mem + reg_offset);
+		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
+	} else
+		val = ioread32(ah->ah_sc->mem + reg_offset);
+	return val;
+}
+
 bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
 {
 	int i;
-- 
1.5.3.2

