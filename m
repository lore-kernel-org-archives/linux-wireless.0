Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:48987
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536Ab2KUMn6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 07:43:58 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/6] ath9k/ath9k_htc: Remove WME macros
Date: Wed, 21 Nov 2012 18:13:10 +0530
Message-Id: <1353501795-10378-1-git-send-email-sujith@msujith.org> (sfid-20121121_134403_399809_83369C07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Use the macros provided by mac80211 and remove redundant
declarations inside the drivers.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h          | 16 ++++-----
 drivers/net/wireless/ath/ath9k/beacon.c         |  2 +-
 drivers/net/wireless/ath/ath9k/common.h         |  7 ----
 drivers/net/wireless/ath/ath9k/debug.c          | 44 ++++++++++++-------------
 drivers/net/wireless/ath/ath9k/gpio.c           |  2 +-
 drivers/net/wireless/ath/ath9k/htc.h            |  4 +--
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c  |  8 ++---
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c   |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |  8 ++---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |  4 +--
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   | 26 +++++++--------
 drivers/net/wireless/ath/ath9k/init.c           |  2 +-
 drivers/net/wireless/ath/ath9k/link.c           |  2 +-
 drivers/net/wireless/ath/ath9k/main.c           | 26 +++++++--------
 drivers/net/wireless/ath/ath9k/xmit.c           | 10 +++---
 16 files changed, 79 insertions(+), 86 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9a93d2b..1bb7fca 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -129,10 +129,10 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 #define ATH_TXMAXTRY            13
 
 #define TID_TO_WME_AC(_tid)				\
-	((((_tid) == 0) || ((_tid) == 3)) ? WME_AC_BE :	\
-	 (((_tid) == 1) || ((_tid) == 2)) ? WME_AC_BK :	\
-	 (((_tid) == 4) || ((_tid) == 5)) ? WME_AC_VI :	\
-	 WME_AC_VO)
+	((((_tid) == 0) || ((_tid) == 3)) ? IEEE80211_AC_BE :	\
+	 (((_tid) == 1) || ((_tid) == 2)) ? IEEE80211_AC_BK :	\
+	 (((_tid) == 4) || ((_tid) == 5)) ? IEEE80211_AC_VI :	\
+	 IEEE80211_AC_VO)
 
 #define ATH_AGGR_DELIM_SZ          4
 #define ATH_AGGR_MINPLEN           256 /* in bytes, minimum packet length */
@@ -265,7 +265,7 @@ struct ath_node {
 	struct ieee80211_sta *sta; /* station struct we're part of */
 	struct ieee80211_vif *vif; /* interface with which we're associated */
 	struct ath_atx_tid tid[WME_NUM_TID];
-	struct ath_atx_ac ac[WME_NUM_AC];
+	struct ath_atx_ac ac[IEEE80211_NUM_ACS];
 	int ps_key;
 
 	u16 maxampdu;
@@ -299,9 +299,9 @@ struct ath_tx {
 	struct list_head txbuf;
 	struct ath_txq txq[ATH9K_NUM_TX_QUEUES];
 	struct ath_descdma txdma;
-	struct ath_txq *txq_map[WME_NUM_AC];
-	u32 txq_max_pending[WME_NUM_AC];
-	u16 max_aggr_framelen[WME_NUM_AC][4][32];
+	struct ath_txq *txq_map[IEEE80211_NUM_ACS];
+	u32 txq_max_pending[IEEE80211_NUM_ACS];
+	u16 max_aggr_framelen[IEEE80211_NUM_ACS][4][32];
 };
 
 struct ath_rx_edma {
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 1b48414..531fffd 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -46,7 +46,7 @@ static void ath9k_beaconq_config(struct ath_softc *sc)
 		qi.tqi_cwmax = 0;
 	} else {
 		/* Adhoc mode; important thing is to use 2x cwmin. */
-		txq = sc->tx.txq_map[WME_AC_BE];
+		txq = sc->tx.txq_map[IEEE80211_AC_BE];
 		ath9k_hw_get_txq_props(ah, txq->axq_qnum, &qi_be);
 		qi.tqi_aifs = qi_be.tqi_aifs;
 		if (ah->slottime == ATH9K_SLOT_TIME_20)
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index ad14fec..76b5439 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -28,13 +28,6 @@
 #define WME_MAX_BA              WME_BA_BMP_SIZE
 #define ATH_TID_MAX_BUFS        (2 * WME_MAX_BA)
 
-/* These must match mac80211 skb queue mapping numbers */
-#define WME_AC_VO   0
-#define WME_AC_VI   1
-#define WME_AC_BE   2
-#define WME_AC_BK   3
-#define WME_NUM_AC  4
-
 #define ATH_RSSI_DUMMY_MARKER   0x127
 #define ATH_RSSI_LPF_LEN 		10
 #define RSSI_LPF_THRESHOLD		-20
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 585aee4..0b488f8 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -517,10 +517,10 @@ static const struct file_operations fops_interrupt = {
 	do {								\
 		len += snprintf(buf + len, size - len,			\
 				"%s%13u%11u%10u%10u\n", str,		\
-		sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem, \
-		sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem, \
-		sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem, \
-		sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem); \
+		sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].elem, \
+		sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].elem, \
+		sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].elem, \
+		sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].elem); \
 		if (len >= size)			  \
 			goto done;			  \
 } while(0)
@@ -529,10 +529,10 @@ static const struct file_operations fops_interrupt = {
 do {									\
 	len += snprintf(buf + len, size - len,				\
 			"%s%13u%11u%10u%10u\n", str,			\
-			(unsigned int)(sc->tx.txq_map[WME_AC_BE]->elem),	\
-			(unsigned int)(sc->tx.txq_map[WME_AC_BK]->elem),	\
-			(unsigned int)(sc->tx.txq_map[WME_AC_VI]->elem),	\
-			(unsigned int)(sc->tx.txq_map[WME_AC_VO]->elem));	\
+			(unsigned int)(sc->tx.txq_map[IEEE80211_AC_BE]->elem),	\
+			(unsigned int)(sc->tx.txq_map[IEEE80211_AC_BK]->elem),	\
+			(unsigned int)(sc->tx.txq_map[IEEE80211_AC_VI]->elem),	\
+			(unsigned int)(sc->tx.txq_map[IEEE80211_AC_VO]->elem));	\
 	if (len >= size)						\
 		goto done;						\
 } while(0)
@@ -541,10 +541,10 @@ do {									\
 do {									\
 	len += snprintf(buf + len, size - len,				\
 			"%s%13i%11i%10i%10i\n", str,			\
-			list_empty(&sc->tx.txq_map[WME_AC_BE]->elem),	\
-			list_empty(&sc->tx.txq_map[WME_AC_BK]->elem),	\
-			list_empty(&sc->tx.txq_map[WME_AC_VI]->elem),	\
-			list_empty(&sc->tx.txq_map[WME_AC_VO]->elem));	\
+			list_empty(&sc->tx.txq_map[IEEE80211_AC_BE]->elem),	\
+			list_empty(&sc->tx.txq_map[IEEE80211_AC_BK]->elem),	\
+			list_empty(&sc->tx.txq_map[IEEE80211_AC_VI]->elem),	\
+			list_empty(&sc->tx.txq_map[IEEE80211_AC_VO]->elem));	\
 	if (len >= size)						\
 		goto done;						\
 } while (0)
@@ -593,10 +593,10 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("TX-Failed:       ", txfailed);
 	len += snprintf(buf + len, size - len,
 			"%s%11p%11p%10p%10p\n", "txq-memory-address:",
-			sc->tx.txq_map[WME_AC_BE],
-			sc->tx.txq_map[WME_AC_BK],
-			sc->tx.txq_map[WME_AC_VI],
-			sc->tx.txq_map[WME_AC_VO]);
+			sc->tx.txq_map[IEEE80211_AC_BE],
+			sc->tx.txq_map[IEEE80211_AC_BK],
+			sc->tx.txq_map[IEEE80211_AC_VI],
+			sc->tx.txq_map[IEEE80211_AC_VO]);
 	if (len >= size)
 		goto done;
 
@@ -617,7 +617,7 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	}
 
 	/* Print out more detailed queue-info */
-	for (i = 0; i <= WME_AC_BK; i++) {
+	for (i = 0; i <= IEEE80211_AC_BK; i++) {
 		struct ath_txq *txq = &(sc->tx.txq[i]);
 		struct ath_atx_ac *ac;
 		struct ath_atx_tid *tid;
@@ -695,7 +695,7 @@ static ssize_t read_file_stations(struct file *file, char __user *user_buf,
 				goto done;
 		}
 
-		for (q = 0; q < WME_NUM_AC; q++) {
+		for (q = 0; q < IEEE80211_NUM_ACS; q++) {
 			struct ath_atx_ac *ac = &(an->ac[q]);
 			len += snprintf(buf + len, size - len,
 					" ac: %p %s %i %p\n",
@@ -1645,13 +1645,13 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_file("xmit", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_xmit);
 	debugfs_create_u32("qlen_bk", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
-			   &sc->tx.txq_max_pending[WME_AC_BK]);
+			   &sc->tx.txq_max_pending[IEEE80211_AC_BK]);
 	debugfs_create_u32("qlen_be", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
-			   &sc->tx.txq_max_pending[WME_AC_BE]);
+			   &sc->tx.txq_max_pending[IEEE80211_AC_BE]);
 	debugfs_create_u32("qlen_vi", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
-			   &sc->tx.txq_max_pending[WME_AC_VI]);
+			   &sc->tx.txq_max_pending[IEEE80211_AC_VI]);
 	debugfs_create_u32("qlen_vo", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
-			   &sc->tx.txq_max_pending[WME_AC_VO]);
+			   &sc->tx.txq_max_pending[IEEE80211_AC_VO]);
 	debugfs_create_file("stations", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_stations);
 	debugfs_create_file("misc", S_IRUSR, sc->debug.debugfs_phy, sc,
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index 4236df8..f4eebc3 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -471,7 +471,7 @@ int ath9k_init_btcoex(struct ath_softc *sc)
 		r = ath_init_btcoex_timer(sc);
 		if (r)
 			return -1;
-		txq = sc->tx.txq_map[WME_AC_BE];
+		txq = sc->tx.txq_map[IEEE80211_AC_BE];
 		ath9k_hw_init_btcoex_hw(sc->sc_ah, txq->axq_qnum);
 		sc->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
 		if (ath9k_hw_mci_is_enabled(ah)) {
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index b30596f..96bfb18 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -331,7 +331,7 @@ struct ath_tx_stats {
 	u32 skb_success;
 	u32 skb_failed;
 	u32 cab_queued;
-	u32 queue_stats[WME_NUM_AC];
+	u32 queue_stats[IEEE80211_NUM_ACS];
 };
 
 struct ath_rx_stats {
@@ -493,7 +493,7 @@ struct ath9k_htc_priv {
 
 	int beaconq;
 	int cabq;
-	int hwq_map[WME_NUM_AC];
+	int hwq_map[IEEE80211_NUM_ACS];
 
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	struct ath_btcoex btcoex;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 1318d79..d0ce1f5 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -33,7 +33,7 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
 		qi.tqi_cwmin = 0;
 		qi.tqi_cwmax = 0;
 	} else if (priv->ah->opmode == NL80211_IFTYPE_ADHOC) {
-		int qnum = priv->hwq_map[WME_AC_BE];
+		int qnum = priv->hwq_map[IEEE80211_AC_BE];
 
 		ath9k_hw_get_txq_props(ah, qnum, &qi_be);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
index 3035deb..87110de5 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
@@ -218,16 +218,16 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"%20s : %10u\n", "BE queued",
-			priv->debug.tx_stats.queue_stats[WME_AC_BE]);
+			priv->debug.tx_stats.queue_stats[IEEE80211_AC_BE]);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"%20s : %10u\n", "BK queued",
-			priv->debug.tx_stats.queue_stats[WME_AC_BK]);
+			priv->debug.tx_stats.queue_stats[IEEE80211_AC_BK]);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"%20s : %10u\n", "VI queued",
-			priv->debug.tx_stats.queue_stats[WME_AC_VI]);
+			priv->debug.tx_stats.queue_stats[IEEE80211_AC_VI]);
 	len += snprintf(buf + len, sizeof(buf) - len,
 			"%20s : %10u\n", "VO queued",
-			priv->debug.tx_stats.queue_stats[WME_AC_VO]);
+			priv->debug.tx_stats.queue_stats[IEEE80211_AC_VO]);
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 0eacfc1..105582d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -207,7 +207,7 @@ void ath9k_htc_init_btcoex(struct ath9k_htc_priv *priv, char *product)
 		priv->btcoex.bt_stomp_type = ATH_BTCOEX_STOMP_LOW;
 		ath9k_hw_btcoex_init_3wire(priv->ah);
 		ath_htc_init_btcoex_work(priv);
-		qnum = priv->hwq_map[WME_AC_BE];
+		qnum = priv->hwq_map[IEEE80211_AC_BE];
 		ath9k_hw_init_btcoex_hw(priv->ah, qnum);
 		break;
 	default:
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 5ecf128..05d5ba6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -549,20 +549,20 @@ static int ath9k_init_queues(struct ath9k_htc_priv *priv)
 		goto err;
 	}
 
-	if (!ath9k_htc_txq_setup(priv, WME_AC_BE)) {
+	if (!ath9k_htc_txq_setup(priv, IEEE80211_AC_BE)) {
 		ath_err(common, "Unable to setup xmit queue for BE traffic\n");
 		goto err;
 	}
 
-	if (!ath9k_htc_txq_setup(priv, WME_AC_BK)) {
+	if (!ath9k_htc_txq_setup(priv, IEEE80211_AC_BK)) {
 		ath_err(common, "Unable to setup xmit queue for BK traffic\n");
 		goto err;
 	}
-	if (!ath9k_htc_txq_setup(priv, WME_AC_VI)) {
+	if (!ath9k_htc_txq_setup(priv, IEEE80211_AC_VI)) {
 		ath_err(common, "Unable to setup xmit queue for VI traffic\n");
 		goto err;
 	}
-	if (!ath9k_htc_txq_setup(priv, WME_AC_VO)) {
+	if (!ath9k_htc_txq_setup(priv, IEEE80211_AC_VO)) {
 		ath_err(common, "Unable to setup xmit queue for VO traffic\n");
 		goto err;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 02cce95..9c07a8f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1349,7 +1349,7 @@ static int ath9k_htc_conf_tx(struct ieee80211_hw *hw,
 	struct ath9k_tx_queue_info qi;
 	int ret = 0, qnum;
 
-	if (queue >= WME_NUM_AC)
+	if (queue >= IEEE80211_NUM_ACS)
 		return 0;
 
 	mutex_lock(&priv->mutex);
@@ -1376,7 +1376,7 @@ static int ath9k_htc_conf_tx(struct ieee80211_hw *hw,
 	}
 
 	if ((priv->ah->opmode == NL80211_IFTYPE_ADHOC) &&
-	    (qnum == priv->hwq_map[WME_AC_BE]))
+	    (qnum == priv->hwq_map[IEEE80211_AC_BE]))
 		    ath9k_htc_beaconq_config(priv);
 out:
 	ath9k_htc_ps_restore(priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 06cdcb7..3a22d17 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -21,10 +21,10 @@
 /******/
 
 static const int subtype_txq_to_hwq[] = {
-	[WME_AC_BE] = ATH_TXQ_AC_BE,
-	[WME_AC_BK] = ATH_TXQ_AC_BK,
-	[WME_AC_VI] = ATH_TXQ_AC_VI,
-	[WME_AC_VO] = ATH_TXQ_AC_VO,
+	[IEEE80211_AC_BE] = ATH_TXQ_AC_BE,
+	[IEEE80211_AC_BK] = ATH_TXQ_AC_BK,
+	[IEEE80211_AC_VI] = ATH_TXQ_AC_VI,
+	[IEEE80211_AC_VO] = ATH_TXQ_AC_VO,
 };
 
 #define ATH9K_HTC_INIT_TXQ(subtype) do {			\
@@ -41,15 +41,15 @@ int get_hw_qnum(u16 queue, int *hwq_map)
 {
 	switch (queue) {
 	case 0:
-		return hwq_map[WME_AC_VO];
+		return hwq_map[IEEE80211_AC_VO];
 	case 1:
-		return hwq_map[WME_AC_VI];
+		return hwq_map[IEEE80211_AC_VI];
 	case 2:
-		return hwq_map[WME_AC_BE];
+		return hwq_map[IEEE80211_AC_BE];
 	case 3:
-		return hwq_map[WME_AC_BK];
+		return hwq_map[IEEE80211_AC_BK];
 	default:
-		return hwq_map[WME_AC_BE];
+		return hwq_map[IEEE80211_AC_BE];
 	}
 }
 
@@ -106,20 +106,20 @@ static inline enum htc_endpoint_id get_htc_epid(struct ath9k_htc_priv *priv,
 
 	switch (qnum) {
 	case 0:
-		TX_QSTAT_INC(WME_AC_VO);
+		TX_QSTAT_INC(IEEE80211_AC_VO);
 		epid = priv->data_vo_ep;
 		break;
 	case 1:
-		TX_QSTAT_INC(WME_AC_VI);
+		TX_QSTAT_INC(IEEE80211_AC_VI);
 		epid = priv->data_vi_ep;
 		break;
 	case 2:
-		TX_QSTAT_INC(WME_AC_BE);
+		TX_QSTAT_INC(IEEE80211_AC_BE);
 		epid = priv->data_be_ep;
 		break;
 	case 3:
 	default:
-		TX_QSTAT_INC(WME_AC_BK);
+		TX_QSTAT_INC(IEEE80211_AC_BK);
 		epid = priv->data_bk_ep;
 		break;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 546bae9..345a01a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -435,7 +435,7 @@ static int ath9k_init_queues(struct ath_softc *sc)
 	sc->config.cabqReadytime = ATH_CABQ_READY_TIME;
 	ath_cabq_update(sc);
 
-	for (i = 0; i < WME_NUM_AC; i++) {
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		sc->tx.txq_map[i] = ath_txq_setup(sc, ATH9K_TX_QUEUE_DATA, i);
 		sc->tx.txq_map[i]->mac80211_qnum = i;
 		sc->tx.txq_max_pending[i] = ATH_MAX_QDEPTH;
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 223b969..227fdb8 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -211,7 +211,7 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
 	int time_left;
 
 	memset(&txctl, 0, sizeof(txctl));
-	txctl.txq = sc->tx.txq_map[WME_AC_BE];
+	txctl.txq = sc->tx.txq_map[IEEE80211_AC_BE];
 
 	memset(tx_info, 0, sizeof(*tx_info));
 	tx_info->band = hw->conf.channel->band;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9594b6f..4233913 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1328,7 +1328,7 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw,
 	struct ath9k_tx_queue_info qi;
 	int ret = 0;
 
-	if (queue >= WME_NUM_AC)
+	if (queue >= IEEE80211_NUM_ACS)
 		return 0;
 
 	txq = sc->tx.txq_map[queue];
@@ -1959,10 +1959,10 @@ static int ath9k_get_et_sset_count(struct ieee80211_hw *hw,
 #define PR_QNUM(_n) (sc->tx.txq_map[_n]->axq_qnum)
 #define AWDATA(elem)							\
 	do {								\
-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem; \
-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem; \
-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem; \
-		data[i++] = sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem; \
+		data[i++] = sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].elem; \
+		data[i++] = sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].elem; \
+		data[i++] = sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].elem; \
+		data[i++] = sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].elem; \
 	} while (0)
 
 #define AWDATA_RX(elem)						\
@@ -1977,14 +1977,14 @@ static void ath9k_get_et_stats(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	int i = 0;
 
-	data[i++] = (sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].tx_pkts_all +
-		     sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].tx_pkts_all +
-		     sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].tx_pkts_all +
-		     sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].tx_pkts_all);
-	data[i++] = (sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].tx_bytes_all +
-		     sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].tx_bytes_all +
-		     sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].tx_bytes_all +
-		     sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].tx_bytes_all);
+	data[i++] = (sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].tx_pkts_all +
+		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].tx_pkts_all +
+		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].tx_pkts_all +
+		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].tx_pkts_all);
+	data[i++] = (sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].tx_bytes_all +
+		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].tx_bytes_all +
+		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].tx_bytes_all +
+		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].tx_bytes_all);
 	AWDATA_RX(rx_pkts_all);
 	AWDATA_RX(rx_bytes_all);
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 741918a..ae7f289 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1354,10 +1354,10 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_tx_queue_info qi;
 	static const int subtype_txq_to_hwq[] = {
-		[WME_AC_BE] = ATH_TXQ_AC_BE,
-		[WME_AC_BK] = ATH_TXQ_AC_BK,
-		[WME_AC_VI] = ATH_TXQ_AC_VI,
-		[WME_AC_VO] = ATH_TXQ_AC_VO,
+		[IEEE80211_AC_BE] = ATH_TXQ_AC_BE,
+		[IEEE80211_AC_BK] = ATH_TXQ_AC_BK,
+		[IEEE80211_AC_VI] = ATH_TXQ_AC_VI,
+		[IEEE80211_AC_VO] = ATH_TXQ_AC_VO,
 	};
 	int axq_qnum, i;
 
@@ -2464,7 +2464,7 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	}
 
 	for (acno = 0, ac = &an->ac[acno];
-	     acno < WME_NUM_AC; acno++, ac++) {
+	     acno < IEEE80211_NUM_ACS; acno++, ac++) {
 		ac->sched    = false;
 		ac->txq = sc->tx.txq_map[acno];
 		INIT_LIST_HEAD(&ac->tid_q);
-- 
1.8.0

