Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbZIKBex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 21:34:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/4] atheros/ath9k: add common read/write ops and port ath9k to use it
Date: Thu, 10 Sep 2009 21:34:52 -0400
Message-Id: <1252632895-11914-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>
References: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In an effort to make hw code driver core agnostic read
and write operations are defined on the ath_common structure.
This patch adds that and makes ath9k use it. This allows
drivers like ath9k_htc to define its own read/write ops and
still rely on the same hw code. This also paves the way for
sharing code between ath9k/ath5k/ath9k_htc.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath.h         |    6 ++++
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 --
 drivers/net/wireless/ath/ath9k/hw.c    |   32 ------------------------
 drivers/net/wireless/ath/ath9k/hw.h    |    4 +-
 drivers/net/wireless/ath/ath9k/main.c  |   42 ++++++++++++++++++++++++++++++++
 5 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 7589b2a..91cb43c 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -39,6 +39,11 @@ struct ath_regulatory {
 	struct reg_dmn_pair_mapping *regpair;
 };
 
+struct ath_ops {
+	unsigned int (*read)(void *, u32 reg_offset);
+        void (*write)(void *, u32 reg_offset, u32 val);
+};
+
 struct ath_common {
 	u16 cachelsz;
 	u16 curaid;
@@ -46,6 +51,7 @@ struct ath_common {
 	u8 curbssid[ETH_ALEN];
 	u8 bssidmask[ETH_ALEN];
 	struct ath_regulatory regulatory;
+	struct ath_ops *ops;
 };
 
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0962505..affc3e5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -718,8 +718,5 @@ bool ath9k_wiphy_scanning(struct ath_softc *sc);
 void ath9k_wiphy_work(struct work_struct *work);
 bool ath9k_all_wiphys_idle(struct ath_softc *sc);
 
-void ath9k_iowrite32(struct ath_hw *ah, u32 reg_offset, u32 val);
-unsigned int ath9k_ioread32(struct ath_hw *ah, u32 reg_offset);
-
 int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype);
 #endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5436244..dabff52 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -81,38 +81,6 @@ static u32 ath9k_hw_mac_to_clks(struct ath_hw *ah, u32 usecs)
 		return ath9k_hw_mac_clks(ah, usecs);
 }
 
-/*
- * Read and write, they both share the same lock. We do this to serialize
- * reads and writes on Atheros 802.11n PCI devices only. This is required
- * as the FIFO on these devices can only accept sanely 2 requests. After
- * that the device goes bananas. Serializing the reads/writes prevents this
- * from happening.
- */
-
-void ath9k_iowrite32(struct ath_hw *ah, u32 reg_offset, u32 val)
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
-unsigned int ath9k_ioread32(struct ath_hw *ah, u32 reg_offset)
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
-
 bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
 {
 	int i;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 84deae4..19b1da8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -51,8 +51,8 @@
 #define AT9285_COEX3WIRE_DA_SUBSYSID	0x30ab
 
 /* Register read/write primitives */
-#define REG_WRITE(_ah, _reg, _val) ath9k_iowrite32((_ah), (_reg), (_val))
-#define REG_READ(_ah, _reg) ath9k_ioread32((_ah), (_reg))
+#define REG_WRITE(_ah, _reg, _val) _ah->common.ops->write((_ah), (_reg), (_val))
+#define REG_READ(_ah, _reg) _ah->common.ops->read((_ah), (_reg))
 
 #define SM(_v, _f)  (((_v) << _f##_S) & _f)
 #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b530e47..5f8a18a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1494,6 +1494,47 @@ static int ath_init_btcoex_timer(struct ath_softc *sc)
 }
 
 /*
+ * Read and write, they both share the same lock. We do this to serialize
+ * reads and writes on Atheros 802.11n PCI devices only. This is required
+ * as the FIFO on these devices can only accept sanely 2 requests. After
+ * that the device goes bananas. Serializing the reads/writes prevents this
+ * from happening.
+ */
+
+static void ath9k_iowrite32(void *hw_priv, u32 reg_offset, u32 val)
+{
+	struct ath_hw *ah = (struct ath_hw *) hw_priv;
+
+	if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
+		unsigned long flags;
+		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
+		iowrite32(val, ah->ah_sc->mem + reg_offset);
+		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
+	} else
+		iowrite32(val, ah->ah_sc->mem + reg_offset);
+}
+
+static unsigned int ath9k_ioread32(void *hw_priv, u32 reg_offset)
+{
+	struct ath_hw *ah = (struct ath_hw *) hw_priv;
+	u32 val;
+
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
+static struct ath_ops ath9k_common_ops = {
+	.read = ath9k_ioread32,
+	.write = ath9k_iowrite32,
+};
+
+/*
  * Initialize and fill ath_softc, ath_sofct is the
  * "Software Carrier" struct. Historically it has existed
  * to allow the separation between hardware specific
@@ -1532,6 +1573,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid)
 	sc->sc_ah = ah;
 
 	common = ath9k_hw_common(ah);
+	common->ops = &ath9k_common_ops;
 
 	/*
 	 * Cache line size is used to size and align various
-- 
1.6.3.3

