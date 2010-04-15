Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54788 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756817Ab0DODax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:53 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v2 38/97] ath9k_hw: Add abstraction to set/get link pointer
Date: Wed, 14 Apr 2010 23:29:52 -0400
Message-Id: <1271302251-9075-39-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |   12 ++++++++++++
 drivers/net/wireless/ath/ath9k/hw-ops.h     |   11 +++++++++++
 drivers/net/wireless/ath/ath9k/hw.h         |    2 ++
 drivers/net/wireless/ath/ath9k/mac.c        |   13 +++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c       |    7 ++++---
 5 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 2089006..f28adb2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -20,11 +20,23 @@ static void ar9003_hw_rx_enable(struct ath_hw *hw)
 	REG_WRITE(hw, AR_CR, 0);
 }
 
+static void ar9003_hw_set_desc_link(void *ds, u32 ds_link)
+{
+	((struct ar9003_txc *) ds)->link = ds_link;
+}
+
+static void ar9003_hw_get_desc_link(void *ds, u32 **ds_link)
+{
+	*ds_link = &((struct ar9003_txc *) ds)->link;
+}
+
 void ar9003_hw_attach_mac_ops(struct ath_hw *hw)
 {
 	struct ath_hw_ops *ops = ath9k_hw_ops(hw);
 
 	ops->rx_enable = ar9003_hw_rx_enable;
+	ops->set_desc_link = ar9003_hw_set_desc_link;
+	ops->get_desc_link = ar9003_hw_get_desc_link;
 }
 
 void ath9k_hw_set_rx_bufsize(struct ath_hw *ah, u16 buf_size)
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 08a51a2..a770107 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -33,6 +33,17 @@ static inline void ath9k_hw_rxena(struct ath_hw *ah)
 	ath9k_hw_ops(ah)->rx_enable(ah);
 }
 
+static inline void ath9k_hw_set_desc_link(struct ath_hw *ah, void *ds,
+					  u32 link)
+{
+	ath9k_hw_ops(ah)->set_desc_link(ds, link);
+}
+
+static inline void ath9k_hw_get_desc_link(struct ath_hw *ah, void *ds,
+					  u32 **link)
+{
+	ath9k_hw_ops(ah)->get_desc_link(ds, link);
+}
 /* Private hardware call ops */
 
 /* PHY ops */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0361f42..51b6b26 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -520,6 +520,8 @@ struct ath_hw_ops {
 				     int restore,
 				     int power_off);
 	void (*rx_enable)(struct ath_hw *ah);
+	void (*set_desc_link)(void *ds, u32 link);
+	void (*get_desc_link)(void *ds, u32 **link);
 };
 
 struct ath_hw {
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 0c9c378..a8dab23 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -21,12 +21,25 @@ static void ar9002_hw_rx_enable(struct ath_hw *ah)
 	REG_WRITE(ah, AR_CR, AR_CR_RXE);
 }
 
+static void ar9002_hw_set_desc_link(void *ds, u32 ds_link)
+{
+	((struct ath_desc *) ds)->ds_link = ds_link;
+}
+
+static void ar9002_hw_get_desc_link(void *ds, u32 **ds_link)
+{
+	*ds_link = &((struct ath_desc *)ds)->ds_link;
+}
+
 void ar9002_hw_attach_mac_ops(struct ath_hw *ah)
 {
 	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
 
 	ops->rx_enable = ar9002_hw_rx_enable;
+	ops->set_desc_link = ar9002_hw_set_desc_link;
+	ops->get_desc_link = ar9002_hw_get_desc_link;
 }
+
 static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 					struct ath9k_tx_queue_info *qi)
 {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 7219e29..4f12de9 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -665,7 +665,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		bpad = PADBYTES(al_delta) + (ndelim << 2);
 
 		bf->bf_next = NULL;
-		bf->bf_desc->ds_link = 0;
+		ath9k_hw_set_desc_link(sc->sc_ah, bf->bf_desc, 0);
 
 		/* link buffers of this frame to the aggregate */
 		ath_tx_addto_baw(sc, tid, bf);
@@ -673,7 +673,8 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		list_move_tail(&bf->list, bf_q);
 		if (bf_prev) {
 			bf_prev->bf_next = bf;
-			bf_prev->bf_desc->ds_link = bf->bf_daddr;
+			ath9k_hw_set_desc_link(sc->sc_ah, bf_prev->bf_desc,
+					       bf->bf_daddr);
 		}
 		bf_prev = bf;
 
@@ -1659,7 +1660,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	list_add_tail(&bf->list, &bf_head);
 
 	ds = bf->bf_desc;
-	ds->ds_link = 0;
+	ath9k_hw_set_desc_link(ah, ds, 0);
 
 	ath9k_hw_set11n_txdesc(ah, ds, bf->bf_frmlen, frm_type, MAX_RATE_POWER,
 			       bf->bf_keyix, bf->bf_keytype, bf->bf_flags);
-- 
1.6.3.3

