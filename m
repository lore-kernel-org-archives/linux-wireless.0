Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:59379 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3LPKWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 05:22:46 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] ath9k: Cleanup ath9k.h
Date: Mon, 16 Dec 2013 15:47:41 +0530
Message-Id: <1387189061-505-3-git-send-email-sujith@msujith.org> (sfid-20131216_112254_339647_FE92C73E)
In-Reply-To: <1387189061-505-1-git-send-email-sujith@msujith.org>
References: <1387189061-505-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

* Remove unused macros.
* Move definitions to appropriate sections.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 179 ++++++++++++++-------------------
 drivers/net/wireless/ath/ath9k/init.c  |   2 +-
 2 files changed, 79 insertions(+), 102 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 55bb874..9ad8a67 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -29,39 +29,13 @@
 #include "dfs.h"
 #include "spectral.h"
 
-/*
- * Header for the ath9k.ko driver core *only* -- hw code nor any other driver
- * should rely on this file or its contents.
- */
-
 struct ath_node;
+struct ath_rate_table;
 
-/* Macro to expand scalars to 64-bit objects */
-
-#define	ito64(x) (sizeof(x) == 1) ?			\
-	(((unsigned long long int)(x)) & (0xff)) :	\
-	(sizeof(x) == 2) ?				\
-	(((unsigned long long int)(x)) & 0xffff) :	\
-	((sizeof(x) == 4) ?				\
-	 (((unsigned long long int)(x)) & 0xffffffff) : \
-	 (unsigned long long int)(x))
-
-/* increment with wrap-around */
-#define INCR(_l, _sz)   do {			\
-		(_l)++;				\
-		(_l) &= ((_sz) - 1);		\
-	} while (0)
-
-/* decrement with wrap-around */
-#define DECR(_l,  _sz)  do {			\
-		(_l)--;				\
-		(_l) &= ((_sz) - 1);		\
-	} while (0)
-
-#define TSF_TO_TU(_h,_l) \
-	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
-
-#define	ATH_TXQ_SETUP(sc, i)        ((sc)->tx.txqsetup & (1<<i))
+extern struct ieee80211_ops ath9k_ops;
+extern int ath9k_modparam_nohwcrypt;
+extern int led_blink;
+extern bool is_ath9k_unloaded;
 
 struct ath_config {
 	u16 txpowlimit;
@@ -71,6 +45,17 @@ struct ath_config {
 /* Descriptor Management */
 /*************************/
 
+#define ATH_TXSTATUS_RING_SIZE 512
+
+/* Macro to expand scalars to 64-bit objects */
+#define	ito64(x) (sizeof(x) == 1) ?			\
+	(((unsigned long long int)(x)) & (0xff)) :	\
+	(sizeof(x) == 2) ?				\
+	(((unsigned long long int)(x)) & 0xffff) :	\
+	((sizeof(x) == 4) ?				\
+	 (((unsigned long long int)(x)) & 0xffffffff) : \
+	 (unsigned long long int)(x))
+
 #define ATH_TXBUF_RESET(_bf) do {				\
 		(_bf)->bf_lastbf = NULL;			\
 		(_bf)->bf_next = NULL;				\
@@ -78,23 +63,6 @@ struct ath_config {
 		       sizeof(struct ath_buf_state));		\
 	} while (0)
 
-/**
- * enum buffer_type - Buffer type flags
- *
- * @BUF_AMPDU: This buffer is an ampdu, as part of an aggregate (during TX)
- * @BUF_AGGR: Indicates whether the buffer can be aggregated
- *	(used in aggregation scheduling)
- */
-enum buffer_type {
-	BUF_AMPDU		= BIT(0),
-	BUF_AGGR		= BIT(1),
-};
-
-#define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
-#define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
-
-#define ATH_TXSTATUS_RING_SIZE 512
-
 #define	DS2PHYS(_dd, _ds)						\
 	((_dd)->dd_desc_paddr + ((caddr_t)(_ds) - (caddr_t)(_dd)->dd_desc))
 #define ATH_DESC_4KB_BOUND_CHECK(_daddr) ((((_daddr) & 0xFFF) > 0xF7F) ? 1 : 0)
@@ -114,11 +82,20 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 /* RX / TX */
 /***********/
 
+#define	ATH_TXQ_SETUP(sc, i) ((sc)->tx.txqsetup & (1<<i))
+
+/* increment with wrap-around */
+#define INCR(_l, _sz)   do {			\
+		(_l)++;				\
+		(_l) &= ((_sz) - 1);		\
+	} while (0)
+
 #define ATH_RXBUF               512
 #define ATH_TXBUF               512
 #define ATH_TXBUF_RESERVE       5
 #define ATH_MAX_QDEPTH          (ATH_TXBUF / 4 - ATH_TXBUF_RESERVE)
 #define ATH_TXMAXTRY            13
+#define ATH_MAX_SW_RETRIES      30
 
 #define TID_TO_WME_AC(_tid)				\
 	((((_tid) == 0) || ((_tid) == 3)) ? IEEE80211_AC_BE :	\
@@ -134,6 +111,9 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 #define ATH_AGGR_MIN_QDEPTH        2
 /* minimum h/w qdepth for non-aggregated traffic */
 #define ATH_NON_AGGR_MIN_QDEPTH    8
+#define ATH_TX_COMPLETE_POLL_INT   1000
+#define ATH_TXFIFO_DEPTH           8
+#define ATH_TX_ERROR               0x01
 
 #define IEEE80211_SEQ_SEQ_SHIFT    4
 #define IEEE80211_SEQ_MAX          4096
@@ -168,9 +148,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 
 #define IS_CCK_RATE(rate) ((rate >= 0x18) && (rate <= 0x1e))
 
-#define ATH_TX_COMPLETE_POLL_INT	1000
-
-#define ATH_TXFIFO_DEPTH 8
 struct ath_txq {
 	int mac80211_qnum; /* mac80211 queue number, -1 means not mac80211 Q */
 	u32 axq_qnum; /* ath9k hardware queue number */
@@ -215,6 +192,21 @@ struct ath_rxbuf {
 	dma_addr_t bf_buf_addr;
 };
 
+/**
+ * enum buffer_type - Buffer type flags
+ *
+ * @BUF_AMPDU: This buffer is an ampdu, as part of an aggregate (during TX)
+ * @BUF_AGGR: Indicates whether the buffer can be aggregated
+ *	(used in aggregation scheduling)
+ */
+enum buffer_type {
+	BUF_AMPDU		= BIT(0),
+	BUF_AGGR		= BIT(1),
+};
+
+#define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
+#define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
+
 struct ath_buf_state {
 	u8 bf_type;
 	u8 bfs_paprd;
@@ -279,7 +271,6 @@ struct ath_tx_control {
 	struct ieee80211_sta *sta;
 };
 
-#define ATH_TX_ERROR        0x01
 
 /**
  * @txq_map:  Index is mac80211 queue number.  This is
@@ -373,6 +364,22 @@ struct ath_vif {
 	struct ath_buf *av_bcbuf;
 };
 
+struct ath9k_vif_iter_data {
+	u8 hw_macaddr[ETH_ALEN]; /* address of the first vif */
+	u8 mask[ETH_ALEN]; /* bssid mask */
+	bool has_hw_macaddr;
+
+	int naps;      /* number of AP vifs */
+	int nmeshes;   /* number of mesh vifs */
+	int nstations; /* number of station vifs */
+	int nwds;      /* number of WDS vifs */
+	int nadhocs;   /* number of adhoc vifs */
+};
+
+void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       struct ath9k_vif_iter_data *iter_data);
+
 /*******************/
 /* Beacon Handling */
 /*******************/
@@ -388,6 +395,9 @@ struct ath_vif {
 #define ATH_DEFAULT_BMISS_LIMIT 	10
 #define IEEE80211_MS_TO_TU(x)           (((x) * 1000) / 1024)
 
+#define TSF_TO_TU(_h,_l) \
+	((((u32)(_h)) << 22) | (((u32)(_l)) >> 10))
+
 struct ath_beacon_config {
 	int beacon_interval;
 	u16 listen_interval;
@@ -441,10 +451,9 @@ bool ath9k_csa_is_finished(struct ath_softc *sc);
 #define ATH_LONG_CALINTERVAL_INT  1000    /* 1000 ms */
 #define ATH_LONG_CALINTERVAL      30000   /* 30 seconds */
 #define ATH_RESTART_CALINTERVAL   1200000 /* 20 minutes */
-#define ATH_ANI_MAX_SKIP_COUNT  10
-
-#define ATH_PAPRD_TIMEOUT	100 /* msecs */
-#define ATH_PLL_WORK_INTERVAL   100
+#define ATH_ANI_MAX_SKIP_COUNT    10
+#define ATH_PAPRD_TIMEOUT         100 /* msecs */
+#define ATH_PLL_WORK_INTERVAL     100
 
 void ath_tx_complete_poll_work(struct work_struct *work);
 void ath_reset_work(struct work_struct *work);
@@ -538,12 +547,6 @@ static inline int ath9k_dump_btcoex(struct ath_softc *sc, u8 *buf, u32 size)
 }
 #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
 
-struct ath9k_wow_pattern {
-	u8 pattern_bytes[MAX_PATTERN_SIZE];
-	u8 mask_bytes[MAX_PATTERN_SIZE];
-	u32 pattern_len;
-};
-
 /********************/
 /*   LED Control    */
 /********************/
@@ -575,6 +578,12 @@ static inline void ath_fill_led_pin(struct ath_softc *sc)
 /* Wake on Wireless LAN */
 /************************/
 
+struct ath9k_wow_pattern {
+	u8 pattern_bytes[MAX_PATTERN_SIZE];
+	u8 mask_bytes[MAX_PATTERN_SIZE];
+	u32 pattern_len;
+};
+
 #ifdef CONFIG_ATH9K_WOW
 void ath9k_init_wow(struct ieee80211_hw *hw);
 int ath9k_suspend(struct ieee80211_hw *hw,
@@ -678,13 +687,8 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
  * Used when PCI device not fully initialized by bootrom/BIOS
 */
 #define DEFAULT_CACHELINE       32
-#define ATH_REGCLASSIDS_MAX     10
 #define ATH_CABQ_READY_TIME     80      /* % of beacon interval */
-#define ATH_MAX_SW_RETRIES      30
-#define ATH_CHAN_MAX            255
-
 #define ATH_TXPOWER_MAX         100     /* .5 dBm units */
-#define ATH_RATE_DUMMY_MARKER   0
 
 enum sc_op_flags {
 	SC_OP_INVALID,
@@ -703,20 +707,6 @@ enum sc_op_flags {
 #define PS_BEACON_SYNC            BIT(4)
 #define PS_WAIT_FOR_ANI           BIT(5)
 
-struct ath_rate_table;
-
-struct ath9k_vif_iter_data {
-	u8 hw_macaddr[ETH_ALEN]; /* address of the first vif */
-	u8 mask[ETH_ALEN]; /* bssid mask */
-	bool has_hw_macaddr;
-
-	int naps;      /* number of AP vifs */
-	int nmeshes;   /* number of mesh vifs */
-	int nstations; /* number of station vifs */
-	int nwds;      /* number of WDS vifs */
-	int nadhocs;   /* number of adhoc vifs */
-};
-
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
@@ -826,19 +816,13 @@ static inline int ath9k_tx99_send(struct ath_softc *sc,
 }
 #endif /* CONFIG_ATH9K_TX99 */
 
-void ath9k_tasklet(unsigned long data);
-int ath_cabq_update(struct ath_softc *);
-
 static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 {
 	common->bus_ops->read_cachesize(common, csz);
 }
 
-extern struct ieee80211_ops ath9k_ops;
-extern int ath9k_modparam_nohwcrypt;
-extern int led_blink;
-extern bool is_ath9k_unloaded;
-
+void ath9k_tasklet(unsigned long data);
+int ath_cabq_update(struct ath_softc *);
 u8 ath9k_parse_mpdudensity(u8 mpdudensity);
 irqreturn_t ath_isr(int irq, void *dev);
 int ath_reset(struct ath_softc *sc);
@@ -847,8 +831,12 @@ void ath_restart_work(struct ath_softc *sc);
 int ath9k_init_device(u16 devid, struct ath_softc *sc,
 		    const struct ath_bus_ops *bus_ops);
 void ath9k_deinit_device(struct ath_softc *sc);
-void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
 void ath9k_reload_chainmask_settings(struct ath_softc *sc);
+u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate);
+void ath_start_rfkill_poll(struct ath_softc *sc);
+void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
+void ath9k_ps_wakeup(struct ath_softc *sc);
+void ath9k_ps_restore(struct ath_softc *sc);
 
 #ifdef CONFIG_ATH9K_PCI
 int ath_pci_init(void);
@@ -866,15 +854,4 @@ static inline int ath_ahb_init(void) { return 0; };
 static inline void ath_ahb_exit(void) {};
 #endif
 
-void ath9k_ps_wakeup(struct ath_softc *sc);
-void ath9k_ps_restore(struct ath_softc *sc);
-
-u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate);
-
-void ath_start_rfkill_poll(struct ath_softc *sc);
-void ath9k_rfkill_poll_state(struct ieee80211_hw *hw);
-void ath9k_calculate_iter_data(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
-			       struct ath9k_vif_iter_data *iter_data);
-
 #endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 609b7e1..9d2c3eb 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -899,7 +899,7 @@ static const struct ieee80211_iface_combination if_comb[] = {
 	}
 };
 
-void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
+static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-- 
1.8.5.1

