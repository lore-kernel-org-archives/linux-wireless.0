Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37856 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab0CAJRr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 04:17:47 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 01:17:47 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19339.35504.897393.295788@gargle.gargle.HOWL>
Date: Mon, 1 Mar 2010 15:06:48 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/7] ath9k: Move ath9k specific structures to ath9k
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These structures are not used by ath9k_htc.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |   67 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common.h |   72 -------------------------------
 drivers/net/wireless/ath/ath9k/lib.h    |    6 +++
 3 files changed, 73 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index d3acf1c..b77aedd 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -135,6 +135,11 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 #define ATH_TXMAXTRY            13
 #define ATH_MGT_TXMAXTRY        4
 
+#define WME_NUM_TID             16
+#define WME_BA_BMP_SIZE         64
+#define WME_MAX_BA              WME_BA_BMP_SIZE
+#define ATH_TID_MAX_BUFS        (2 * WME_MAX_BA)
+
 #define TID_TO_WME_AC(_tid)				\
 	((((_tid) == 0) || ((_tid) == 3)) ? WME_AC_BE :	\
 	 (((_tid) == 1) || ((_tid) == 2)) ? WME_AC_BK :	\
@@ -200,10 +205,72 @@ struct ath_txq {
 	struct list_head axq_acq;
 };
 
+struct ath_atx_ac {
+	int sched;
+	int qnum;
+	struct list_head list;
+	struct list_head tid_q;
+};
+
+struct ath_buf_state {
+	int bfs_nframes;
+	u16 bfs_al;
+	u16 bfs_frmlen;
+	int bfs_seqno;
+	int bfs_tidno;
+	int bfs_retries;
+	u8 bf_type;
+	u32 bfs_keyix;
+	enum ath9k_key_type bfs_keytype;
+};
+
+struct ath_buf {
+	struct list_head list;
+	struct ath_buf *bf_lastbf;	/* last buf of this unit (a frame or
+					   an aggregate) */
+	struct ath_buf *bf_next;	/* next subframe in the aggregate */
+	struct sk_buff *bf_mpdu;	/* enclosing frame structure */
+	struct ath_desc *bf_desc;	/* virtual addr of desc */
+	dma_addr_t bf_daddr;		/* physical addr of desc */
+	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
+	bool bf_stale;
+	bool bf_isnullfunc;
+	u16 bf_flags;
+	struct ath_buf_state bf_state;
+	dma_addr_t bf_dmacontext;
+	struct ath_wiphy *aphy;
+};
+
 #define AGGR_CLEANUP         BIT(1)
 #define AGGR_ADDBA_COMPLETE  BIT(2)
 #define AGGR_ADDBA_PROGRESS  BIT(3)
 
+struct ath_atx_tid {
+	struct list_head list;
+	struct list_head buf_q;
+	struct ath_node *an;
+	struct ath_atx_ac *ac;
+	struct ath_buf *tx_buf[ATH_TID_MAX_BUFS];
+	u16 seq_start;
+	u16 seq_next;
+	u16 baw_size;
+	int tidno;
+	int baw_head;   /* first un-acked tx buffer */
+	int baw_tail;   /* next unused tx buffer slot */
+	int sched;
+	int paused;
+	u8 state;
+};
+
+struct ath_node {
+	struct ath_common *common;
+	struct ath_atx_tid tid[WME_NUM_TID];
+	struct ath_atx_ac ac[WME_NUM_AC];
+	u16 maxampdu;
+	u8 mpdudensity;
+	int last_rssi;
+};
+
 struct ath_tx_control {
 	struct ath_txq *txq;
 	int if_id;
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 475fb14..7dcf938 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -23,17 +23,6 @@
 
 /* Common header for Atheros 802.11n base driver cores */
 
-#define WME_NUM_TID             16
-#define WME_BA_BMP_SIZE         64
-#define WME_MAX_BA              WME_BA_BMP_SIZE
-#define ATH_TID_MAX_BUFS        (2 * WME_MAX_BA)
-
-#define WME_AC_BE   0
-#define WME_AC_BK   1
-#define WME_AC_VI   2
-#define WME_AC_VO   3
-#define WME_NUM_AC  4
-
 #define ATH_RSSI_DUMMY_MARKER   0x127
 #define ATH_RSSI_LPF_LEN 		10
 #define RSSI_LPF_THRESHOLD		-20
@@ -49,64 +38,3 @@
 #define ATH_EP_RND(x, mul) 						\
 	((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
 
-struct ath_atx_ac {
-	int sched;
-	int qnum;
-	struct list_head list;
-	struct list_head tid_q;
-};
-
-struct ath_buf_state {
-	int bfs_nframes;
-	u16 bfs_al;
-	u16 bfs_frmlen;
-	int bfs_seqno;
-	int bfs_tidno;
-	int bfs_retries;
-	u8 bf_type;
-	u32 bfs_keyix;
-	enum ath9k_key_type bfs_keytype;
-};
-
-struct ath_buf {
-	struct list_head list;
-	struct ath_buf *bf_lastbf;	/* last buf of this unit (a frame or
-					   an aggregate) */
-	struct ath_buf *bf_next;	/* next subframe in the aggregate */
-	struct sk_buff *bf_mpdu;	/* enclosing frame structure */
-	struct ath_desc *bf_desc;	/* virtual addr of desc */
-	dma_addr_t bf_daddr;		/* physical addr of desc */
-	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
-	bool bf_stale;
-	bool bf_isnullfunc;
-	u16 bf_flags;
-	struct ath_buf_state bf_state;
-	dma_addr_t bf_dmacontext;
-	struct ath_wiphy *aphy;
-};
-
-struct ath_atx_tid {
-	struct list_head list;
-	struct list_head buf_q;
-	struct ath_node *an;
-	struct ath_atx_ac *ac;
-	struct ath_buf *tx_buf[ATH_TID_MAX_BUFS];
-	u16 seq_start;
-	u16 seq_next;
-	u16 baw_size;
-	int tidno;
-	int baw_head;   /* first un-acked tx buffer */
-	int baw_tail;   /* next unused tx buffer slot */
-	int sched;
-	int paused;
-	u8 state;
-};
-
-struct ath_node {
-	struct ath_common *common;
-	struct ath_atx_tid tid[WME_NUM_TID];
-	struct ath_atx_ac ac[WME_NUM_AC];
-	u16 maxampdu;
-	u8 mpdudensity;
-	int last_rssi;
-};
diff --git a/drivers/net/wireless/ath/ath9k/lib.h b/drivers/net/wireless/ath/ath9k/lib.h
index 86dc86d..b7f9978 100644
--- a/drivers/net/wireless/ath/ath9k/lib.h
+++ b/drivers/net/wireless/ath/ath9k/lib.h
@@ -64,6 +64,12 @@ enum ath_led_type {
 	ATH_LED_RX
 };
 
+#define WME_AC_BE   0
+#define WME_AC_BK   1
+#define WME_AC_VI   2
+#define WME_AC_VO   3
+#define WME_NUM_AC  4
+
 int ath9k_get_hw_crypto_keytype(struct sk_buff *skb);
 u32 ath9k_calcrxfilter(struct ieee80211_hw *hw, struct ath_hw *ah,
 		       unsigned int rxfilter);
-- 
1.7.0.1

