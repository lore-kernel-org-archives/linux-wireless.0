Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45610 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbYJ2EqJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:46:09 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:46:09 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.59891.415770.356069@gargle.gargle.HOWL> (sfid-20081029_054614_315553_7152D8EC)
Date: Wed, 29 Oct 2008 10:13:31 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 01/16] ath9k: Node cleanup
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Start removing the internal node list in ath9k, in preparation
for using mac80211's STA list.
Remove lists, locks, routines, flags, functions managing nodes in ath9k.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |  119 ++++++++++++++-----------------------
 drivers/net/wireless/ath9k/core.h |   46 ++++-----------
 drivers/net/wireless/ath9k/main.c |   95 +++--------------------------
 drivers/net/wireless/ath9k/rc.c   |   15 +----
 drivers/net/wireless/ath9k/recv.c |   42 ++-----------
 drivers/net/wireless/ath9k/xmit.c |  107 +++++++--------------------------
 6 files changed, 94 insertions(+), 330 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index c5033f6..49fc264 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -47,6 +47,41 @@ static void bus_read_cachesize(struct ath_softc *sc, int *csz)
 		*csz = DEFAULT_CACHELINE >> 2;   /* Use the default size */
 }
 
+static u8 parse_mpdudensity(u8 mpdudensity)
+{
+	/*
+	 * 802.11n D2.0 defined values for "Minimum MPDU Start Spacing":
+	 *   0 for no restriction
+	 *   1 for 1/4 us
+	 *   2 for 1/2 us
+	 *   3 for 1 us
+	 *   4 for 2 us
+	 *   5 for 4 us
+	 *   6 for 8 us
+	 *   7 for 16 us
+	 */
+	switch (mpdudensity) {
+	case 0:
+		return 0;
+	case 1:
+	case 2:
+	case 3:
+		/* Our lower layer calculations limit our precision to
+		   1 microsecond */
+		return 1;
+	case 4:
+		return 2;
+	case 5:
+		return 4;
+	case 6:
+		return 8;
+	case 7:
+		return 16;
+	default:
+		return 0;
+	}
+}
+
 /*
  *  Set current operating mode
  *
@@ -1321,101 +1356,38 @@ void ath_deinit(struct ath_softc *sc)
 /* Node Management */
 /*******************/
 
-struct ath_node *ath_node_attach(struct ath_softc *sc, u8 *addr, int if_id)
+void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta, int if_id)
 {
 	struct ath_vap *avp;
 	struct ath_node *an;
-	DECLARE_MAC_BUF(mac);
 
 	avp = sc->sc_vaps[if_id];
 	ASSERT(avp != NULL);
 
-	/* mac80211 sta_notify callback is from an IRQ context, so no sleep */
-	an = kmalloc(sizeof(struct ath_node), GFP_ATOMIC);
-	if (an == NULL)
-		return NULL;
-	memset(an, 0, sizeof(*an));
-
-	an->an_sc = sc;
-	memcpy(an->an_addr, addr, ETH_ALEN);
-	atomic_set(&an->an_refcnt, 1);
+	an = (struct ath_node *)sta->drv_priv;
 
 	/* set up per-node tx/rx state */
 	ath_tx_node_init(sc, an);
 	ath_rx_node_init(sc, an);
 
+	an->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
+			     sta->ht_cap.ampdu_factor);
+	an->mpdudensity = parse_mpdudensity(sta->ht_cap.ampdu_density);
+
 	ath_chainmask_sel_init(sc, an);
 	ath_chainmask_sel_timerstart(&an->an_chainmask_sel);
-	list_add(&an->list, &sc->node_list);
-
-	return an;
 }
 
-void ath_node_detach(struct ath_softc *sc, struct ath_node *an, bool bh_flag)
+void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 {
-	unsigned long flags;
-
-	DECLARE_MAC_BUF(mac);
+	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 
 	ath_chainmask_sel_timerstop(&an->an_chainmask_sel);
-	an->an_flags |= ATH_NODE_CLEAN;
-	ath_tx_node_cleanup(sc, an, bh_flag);
-	ath_rx_node_cleanup(sc, an);
+
+	ath_tx_node_cleanup(sc, an);
 
 	ath_tx_node_free(sc, an);
 	ath_rx_node_free(sc, an);
-
-	spin_lock_irqsave(&sc->node_lock, flags);
-
-	list_del(&an->list);
-
-	spin_unlock_irqrestore(&sc->node_lock, flags);
-
-	kfree(an);
-}
-
-/* Finds a node and increases the refcnt if found */
-
-struct ath_node *ath_node_get(struct ath_softc *sc, u8 *addr)
-{
-	struct ath_node *an = NULL, *an_found = NULL;
-
-	if (list_empty(&sc->node_list)) /* FIXME */
-		goto out;
-	list_for_each_entry(an, &sc->node_list, list) {
-		if (!compare_ether_addr(an->an_addr, addr)) {
-			atomic_inc(&an->an_refcnt);
-			an_found = an;
-			break;
-		}
-	}
-out:
-	return an_found;
-}
-
-/* Decrements the refcnt and if it drops to zero, detach the node */
-
-void ath_node_put(struct ath_softc *sc, struct ath_node *an, bool bh_flag)
-{
-	if (atomic_dec_and_test(&an->an_refcnt))
-		ath_node_detach(sc, an, bh_flag);
-}
-
-/* Finds a node, doesn't increment refcnt. Caller must hold sc->node_lock */
-struct ath_node *ath_node_find(struct ath_softc *sc, u8 *addr)
-{
-	struct ath_node *an = NULL, *an_found = NULL;
-
-	if (list_empty(&sc->node_list))
-		return NULL;
-
-	list_for_each_entry(an, &sc->node_list, list)
-		if (!compare_ether_addr(an->an_addr, addr)) {
-			an_found = an;
-			break;
-		}
-
-	return an_found;
 }
 
 /*
@@ -1440,7 +1412,6 @@ void ath_newassoc(struct ath_softc *sc,
 				ath_rx_aggr_teardown(sc, an, tidno);
 		}
 	}
-	an->an_flags = 0;
 }
 
 /**************/
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index fbff9aa..d7228ec 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -373,7 +373,6 @@ void ath_flushrecv(struct ath_softc *sc);
 u32 ath_calcrxfilter(struct ath_softc *sc);
 void ath_rx_node_init(struct ath_softc *sc, struct ath_node *an);
 void ath_rx_node_free(struct ath_softc *sc, struct ath_node *an);
-void ath_rx_node_cleanup(struct ath_softc *sc, struct ath_node *an);
 void ath_handle_rx_intr(struct ath_softc *sc);
 int ath_rx_init(struct ath_softc *sc, int nbufs);
 void ath_rx_cleanup(struct ath_softc *sc);
@@ -546,8 +545,7 @@ void ath_draintxq(struct ath_softc *sc, bool retry_tx);
 void ath_tx_draintxq(struct ath_softc *sc,
 		     struct ath_txq *txq, bool retry_tx);
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an);
-void ath_tx_node_cleanup(struct ath_softc *sc,
-			 struct ath_node *an, bool bh_flag);
+void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an);
 void ath_tx_node_free(struct ath_softc *sc, struct ath_node *an);
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq);
 int ath_tx_init(struct ath_softc *sc, int nbufs);
@@ -568,11 +566,6 @@ void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb);
 /* Node / Aggregation */
 /**********************/
 
-/* indicates the node is clened up */
-#define ATH_NODE_CLEAN          0x1
-/* indicates the node is 80211 power save */
-#define ATH_NODE_PWRSAVE        0x2
-
 #define ADDBA_EXCHANGE_ATTEMPTS    10
 #define ATH_AGGR_DELIM_SZ          4   /* delimiter size   */
 #define ATH_AGGR_MINPLEN           256 /* in bytes, minimum packet length */
@@ -584,6 +577,7 @@ void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb);
 #define IEEE80211_SEQ_SEQ_SHIFT    4
 #define IEEE80211_SEQ_MAX          4096
 #define IEEE80211_MIN_AMPDU_BUF    0x8
+#define IEEE80211_HTCAP_MAXRXAMPDU_FACTOR 13
 
 /* return whether a bit at index _n in bitmap _bm is set
  * _sz is the size of the bitmap  */
@@ -638,15 +632,10 @@ struct ath_node_aggr {
 
 /* driver-specific node state */
 struct ath_node {
-	struct list_head list;
 	struct ath_softc *an_sc;
-	atomic_t an_refcnt;
 	struct ath_chainmask_sel an_chainmask_sel;
 	struct ath_node_aggr an_aggr;
 	u8 an_smmode; /* SM Power save mode */
-	u8 an_flags;
-	u8 an_addr[ETH_ALEN];
-
 	u16 maxampdu;
 	u8 mpdudensity;
 };
@@ -659,28 +648,17 @@ void ath_tx_aggr_teardown(struct ath_softc *sc,
 	struct ath_node *an, u8 tidno);
 void ath_rx_aggr_teardown(struct ath_softc *sc,
 	struct ath_node *an, u8 tidno);
-int ath_rx_aggr_start(struct ath_softc *sc,
-		      const u8 *addr,
-		      u16 tid,
-		      u16 *ssn);
-int ath_rx_aggr_stop(struct ath_softc *sc,
-		     const u8 *addr,
-		     u16 tid);
-int ath_tx_aggr_start(struct ath_softc *sc,
-		      const u8 *addr,
-		      u16 tid,
-		      u16 *ssn);
-int ath_tx_aggr_stop(struct ath_softc *sc,
-		     const u8 *addr,
-		     u16 tid);
+int ath_rx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
+		      u16 tid, u16 *ssn);
+int ath_rx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
+int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
+		      u16 tid, u16 *ssn);
+int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 void ath_newassoc(struct ath_softc *sc,
 	struct ath_node *node, int isnew, int isuapsd);
-struct ath_node *ath_node_attach(struct ath_softc *sc,
-	u8 addr[ETH_ALEN], int if_id);
-void ath_node_detach(struct ath_softc *sc, struct ath_node *an, bool bh_flag);
-struct ath_node *ath_node_get(struct ath_softc *sc, u8 addr[ETH_ALEN]);
-void ath_node_put(struct ath_softc *sc, struct ath_node *an, bool bh_flag);
-struct ath_node *ath_node_find(struct ath_softc *sc, u8 *addr);
+void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
+		     int if_id);
+void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta);
 
 /*******************/
 /* Beacon Handling */
@@ -975,7 +953,6 @@ struct ath_softc {
 	u8 sc_rxotherant;		/* rx's on non-default antenna */
 
 	struct ath9k_node_stats sc_halstats; /* station-mode rssi stats */
-	struct list_head node_list;
 	struct ath_ht_info sc_ht_info;
 	enum ath9k_ht_extprotspacing sc_ht_extprotspacing;
 
@@ -1036,7 +1013,6 @@ struct ath_softc {
 	spinlock_t sc_rxbuflock;
 	spinlock_t sc_txbuflock;
 	spinlock_t sc_resetlock;
-	spinlock_t node_lock;
 
 	/* LEDs */
 	struct ath_led radio_led;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 58d86b2..d008f0d 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -21,8 +21,6 @@
 
 #define ATH_PCI_VERSION "0.1"
 
-#define IEEE80211_HTCAP_MAXRXAMPDU_FACTOR	13
-
 static char *dev_info = "ath9k";
 
 MODULE_AUTHOR("Atheros Communications");
@@ -297,41 +295,6 @@ static void ath9k_rx_prepare(struct ath_softc *sc,
 	rx_status->flag |= RX_FLAG_TSFT;
 }
 
-static u8 parse_mpdudensity(u8 mpdudensity)
-{
-	/*
-	 * 802.11n D2.0 defined values for "Minimum MPDU Start Spacing":
-	 *   0 for no restriction
-	 *   1 for 1/4 us
-	 *   2 for 1/2 us
-	 *   3 for 1 us
-	 *   4 for 2 us
-	 *   5 for 4 us
-	 *   6 for 8 us
-	 *   7 for 16 us
-	 */
-	switch (mpdudensity) {
-	case 0:
-		return 0;
-	case 1:
-	case 2:
-	case 3:
-		/* Our lower layer calculations limit our precision to
-		   1 microsecond */
-		return 1;
-	case 4:
-		return 2;
-	case 5:
-		return 4;
-	case 6:
-		return 8;
-	case 7:
-		return 16;
-	default:
-		return 0;
-	}
-}
-
 static void ath9k_ht_conf(struct ath_softc *sc,
 			  struct ieee80211_bss_conf *bss_conf)
 {
@@ -480,8 +443,6 @@ void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	tx_info->status.rates[0].count = tx_status->retries + 1;
 
 	ieee80211_tx_status(hw, skb);
-	if (an)
-		ath_node_put(sc, an, ATH9K_BH_STATUS_CHANGE);
 }
 
 int _ath_rx_indicate(struct ath_softc *sc,
@@ -519,10 +480,6 @@ int _ath_rx_indicate(struct ath_softc *sc,
 			rx_status.flag |= RX_FLAG_DECRYPTED;
 	}
 
-	spin_lock_bh(&sc->node_lock);
-	an = ath_node_find(sc, hdr->addr2);
-	spin_unlock_bh(&sc->node_lock);
-
 	if (an) {
 		ath_rx_input(sc, an,
 			     skb, status, &st);
@@ -914,11 +871,6 @@ static int ath_attach(u16 devid,
 	if (error != 0)
 		return error;
 
-	/* Init nodes */
-
-	INIT_LIST_HEAD(&sc->node_list);
-	spin_lock_init(&sc->node_lock);
-
 	/* get mac address from hardware and set in mac80211 */
 
 	SET_IEEE80211_PERM_ADDR(hw, sc->sc_myaddr);
@@ -1406,51 +1358,22 @@ static void ath9k_configure_filter(struct ieee80211_hw *hw,
 		__func__, sc->rx_filter);
 }
 
+/* Only a single interface is currently supported,
+   so pass 0 as the interface id to ath_node_attach */
+
 static void ath9k_sta_notify(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     enum sta_notify_cmd cmd,
 			     struct ieee80211_sta *sta)
 {
 	struct ath_softc *sc = hw->priv;
-	struct ath_node *an;
-	unsigned long flags;
-	DECLARE_MAC_BUF(mac);
-
-	spin_lock_irqsave(&sc->node_lock, flags);
-	an = ath_node_find(sc, sta->addr);
-	spin_unlock_irqrestore(&sc->node_lock, flags);
 
 	switch (cmd) {
 	case STA_NOTIFY_ADD:
-		spin_lock_irqsave(&sc->node_lock, flags);
-		if (!an) {
-			ath_node_attach(sc, sta->addr, 0);
-			DPRINTF(sc, ATH_DBG_CONFIG, "%s: Attach a node: %s\n",
-				__func__, print_mac(mac, sta->addr));
-		} else {
-			ath_node_get(sc, sta->addr);
-		}
-
-		/* XXX: Is this right? Can the capabilities change? */
-		an = ath_node_find(sc, sta->addr);
-		an->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
-					sta->ht_cap.ampdu_factor);
-		an->mpdudensity =
-			parse_mpdudensity(sta->ht_cap.ampdu_density);
-
-		spin_unlock_irqrestore(&sc->node_lock, flags);
+		ath_node_attach(sc, sta, 0);
 		break;
 	case STA_NOTIFY_REMOVE:
-		if (!an)
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: Removal of a non-existent node\n",
-				__func__);
-		else {
-			ath_node_put(sc, an, ATH9K_BH_STATUS_INTACT);
-			DPRINTF(sc, ATH_DBG_CONFIG, "%s: Put a node: %s\n",
-				__func__,
-				print_mac(mac, sta->addr));
-		}
+		ath_node_detach(sc, sta);
 		break;
 	default:
 		break;
@@ -1598,21 +1521,21 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		ret = ath_rx_aggr_start(sc, sta->addr, tid, ssn);
+		ret = ath_rx_aggr_start(sc, sta, tid, ssn);
 		if (ret < 0)
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to start RX aggregation\n",
 				__func__);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
-		ret = ath_rx_aggr_stop(sc, sta->addr, tid);
+		ret = ath_rx_aggr_stop(sc, sta, tid);
 		if (ret < 0)
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to stop RX aggregation\n",
 				__func__);
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		ret = ath_tx_aggr_start(sc, sta->addr, tid, ssn);
+		ret = ath_tx_aggr_start(sc, sta, tid, ssn);
 		if (ret < 0)
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to start TX aggregation\n",
@@ -1621,7 +1544,7 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 			ieee80211_start_tx_ba_cb_irqsafe(hw, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_STOP:
-		ret = ath_tx_aggr_stop(sc, sta->addr, tid);
+		ret = ath_tx_aggr_stop(sc, sta, tid);
 		if (ret < 0)
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: Unable to stop TX aggregation\n",
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index c7800e0..e254606 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1867,9 +1867,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	/* XXX: UGLY HACK!! */
 	tx_info_priv = (struct ath_tx_info_priv *)tx_info->control.vif;
 
-	spin_lock_bh(&sc->node_lock);
-	an = ath_node_find(sc, hdr->addr1);
-	spin_unlock_bh(&sc->node_lock);
+	an = (struct ath_node *)sta->drv_priv;
 
 	if (tx_info_priv == NULL)
 		return;
@@ -1985,16 +1983,7 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 			qc = ieee80211_get_qos_ctl(hdr);
 			tid = qc[0] & 0xf;
 
-			spin_lock_bh(&sc->node_lock);
-			an = ath_node_find(sc, hdr->addr1);
-			spin_unlock_bh(&sc->node_lock);
-
-			if (!an) {
-				DPRINTF(sc, ATH_DBG_AGGR,
-					"%s: Node not found to "
-					"init/chk TX aggr\n", __func__);
-				return;
-			}
+			an = (struct ath_node *)sta->drv_priv;
 
 			chk = ath_tx_aggr_check(sc, an, tid);
 			if (chk == AGGR_REQUIRED) {
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 8283228..6b4006e 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -1095,7 +1095,7 @@ rx_next:
 /* Process ADDBA request in per-TID data structure */
 
 int ath_rx_aggr_start(struct ath_softc *sc,
-		      const u8 *addr,
+		      struct ieee80211_sta *sta,
 		      u16 tid,
 		      u16 *ssn)
 {
@@ -1105,17 +1105,7 @@ int ath_rx_aggr_start(struct ath_softc *sc,
 	struct ieee80211_supported_band *sband;
 	u16 buffersize = 0;
 
-	spin_lock_bh(&sc->node_lock);
-	an = ath_node_find(sc, (u8 *) addr);
-	spin_unlock_bh(&sc->node_lock);
-
-	if (!an) {
-		DPRINTF(sc, ATH_DBG_AGGR,
-			"%s: Node not found to initialize RX aggregation\n",
-			__func__);
-		return -1;
-	}
-
+	an = (struct ath_node *)sta->drv_priv;
 	sband = hw->wiphy->bands[hw->conf.channel->band];
 	buffersize = IEEE80211_MIN_AMPDU_BUF <<
 		sband->ht_cap.ampdu_factor; /* FIXME */
@@ -1172,21 +1162,9 @@ int ath_rx_aggr_start(struct ath_softc *sc,
 
 /* Process DELBA */
 
-int ath_rx_aggr_stop(struct ath_softc *sc,
-		     const u8 *addr,
-		     u16 tid)
+int ath_rx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 {
-	struct ath_node *an;
-
-	spin_lock_bh(&sc->node_lock);
-	an = ath_node_find(sc, (u8 *) addr);
-	spin_unlock_bh(&sc->node_lock);
-
-	if (!an) {
-		DPRINTF(sc, ATH_DBG_AGGR,
-			"%s: RX aggr stop for non-existent node\n", __func__);
-		return -1;
-	}
+	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 
 	ath_rx_aggr_teardown(sc, an, tid);
 	return 0;
@@ -1194,8 +1172,7 @@ int ath_rx_aggr_stop(struct ath_softc *sc,
 
 /* Rx aggregation tear down */
 
-void ath_rx_aggr_teardown(struct ath_softc *sc,
-	struct ath_node *an, u8 tid)
+void ath_rx_aggr_teardown(struct ath_softc *sc, struct ath_node *an, u8 tid)
 {
 	struct ath_arx_tid *rxtid = &an->an_aggr.rx.tid[tid];
 
@@ -1253,7 +1230,7 @@ void ath_rx_node_init(struct ath_softc *sc, struct ath_node *an)
 	}
 }
 
-void ath_rx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
+void ath_rx_node_free(struct ath_softc *sc, struct ath_node *an)
 {
 	if (sc->sc_flags & SC_OP_RXAGGR) {
 		struct ath_arx_tid *rxtid;
@@ -1281,10 +1258,3 @@ void ath_rx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 	}
 
 }
-
-/* Cleanup per-node receive state */
-
-void ath_rx_node_free(struct ath_softc *sc, struct ath_node *an)
-{
-	ath_rx_node_cleanup(sc, an);
-}
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index b80315b..70339f3 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -214,15 +214,6 @@ static int ath_tx_prepare(struct ath_softc *sc,
 	rt = sc->sc_currates;
 	BUG_ON(!rt);
 
-	/* Fill misc fields */
-
-	spin_lock_bh(&sc->node_lock);
-	txctl->an = ath_node_get(sc, hdr->addr1);
-	/* create a temp node, if the node is not there already */
-	if (!txctl->an)
-		txctl->an = ath_node_attach(sc, hdr->addr1, 0);
-	spin_unlock_bh(&sc->node_lock);
-
 	if (ieee80211_is_data_qos(fc)) {
 		qc = ieee80211_get_qos_ctl(hdr);
 		txctl->tidno = qc[0] & 0xf;
@@ -496,11 +487,9 @@ unlock:
 
 /* Compute the number of bad frames */
 
-static int ath_tx_num_badfrms(struct ath_softc *sc,
-	struct ath_buf *bf, int txok)
+static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
+			      int txok)
 {
-	struct ath_node *an = bf->bf_node;
-	int isnodegone = (an->an_flags & ATH_NODE_CLEAN);
 	struct ath_buf *bf_last = bf->bf_lastbf;
 	struct ath_desc *ds = bf_last->bf_desc;
 	u16 seq_st = 0;
@@ -509,7 +498,7 @@ static int ath_tx_num_badfrms(struct ath_softc *sc,
 	int nbad = 0;
 	int isaggr = 0;
 
-	if (isnodegone || ds->ds_txstat.ts_flags == ATH9K_TX_SW_ABORTED)
+	if (ds->ds_txstat.ts_flags == ATH9K_TX_SW_ABORTED)
 		return 0;
 
 	isaggr = bf_isaggr(bf);
@@ -908,7 +897,6 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 	u16 seq_st = 0;
 	u32 ba[WME_BA_BMP_SIZE >> 5];
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0;
-	int isnodegone = (an->an_flags & ATH_NODE_CLEAN);
 
 	isaggr = bf_isaggr(bf);
 	if (isaggr) {
@@ -954,7 +942,7 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 			/* transmit completion */
 		} else {
 
-			if (!tid->cleanup_inprogress && !isnodegone &&
+			if (!tid->cleanup_inprogress &&
 			    ds->ds_txstat.ts_flags != ATH9K_TX_SW_ABORTED) {
 				if (bf->bf_retries < ATH_MAX_SW_RETRIES) {
 					ath_tx_set_retry(sc, bf);
@@ -1083,15 +1071,6 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 		bf = bf_next;
 	}
 
-	/*
-	 * node is already gone. no more assocication
-	 * with the node. the node might have been freed
-	 * any  node acces can result in panic.note tid
-	 * is part of the node.
-	 */
-	if (isnodegone)
-		return;
-
 	if (tid->cleanup_inprogress) {
 		/* check to see if we're done with cleaning the h/w queue */
 		spin_lock_bh(&txq->axq_lock);
@@ -1795,8 +1774,8 @@ static void ath_tx_sched_aggr(struct ath_softc *sc,
 
 static void ath_tid_drain(struct ath_softc *sc,
 			  struct ath_txq *txq,
-			  struct ath_atx_tid *tid,
-			  bool bh_flag)
+			  struct ath_atx_tid *tid)
+
 {
 	struct ath_buf *bf;
 	struct list_head bf_head;
@@ -1817,18 +1796,12 @@ static void ath_tid_drain(struct ath_softc *sc,
 		 * do not indicate packets while holding txq spinlock.
 		 * unlock is intentional here
 		 */
-		if (likely(bh_flag))
-			spin_unlock_bh(&txq->axq_lock);
-		else
-			spin_unlock(&txq->axq_lock);
+		spin_unlock(&txq->axq_lock);
 
 		/* complete this sub-frame */
 		ath_tx_complete_buf(sc, bf, &bf_head, 0, 0);
 
-		if (likely(bh_flag))
-			spin_lock_bh(&txq->axq_lock);
-		else
-			spin_lock(&txq->axq_lock);
+		spin_lock(&txq->axq_lock);
 	}
 
 	/*
@@ -1847,8 +1820,7 @@ static void ath_tid_drain(struct ath_softc *sc,
  */
 
 static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
-					  struct ath_txq *txq,
-					  bool bh_flag)
+					  struct ath_txq *txq)
 {
 	struct ath_atx_ac *ac, *ac_tmp;
 	struct ath_atx_tid *tid, *tid_tmp;
@@ -1859,7 +1831,7 @@ static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
 		list_for_each_entry_safe(tid, tid_tmp, &ac->tid_q, list) {
 			list_del(&tid->list);
 			tid->sched = false;
-			ath_tid_drain(sc, txq, tid, bh_flag);
+			ath_tid_drain(sc, txq, tid);
 		}
 	}
 }
@@ -2294,8 +2266,6 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb)
 		 * or asynchrounsly once DMA is complete.
 		 */
 		xmit_map_sg(sc, skb, &txctl);
-	else
-		ath_node_put(sc, txctl.an, ATH9K_BH_STATUS_CHANGE);
 
 	/* failed packets will be dropped by the caller */
 	return error;
@@ -2374,8 +2344,7 @@ void ath_tx_draintxq(struct ath_softc *sc,
 	if (sc->sc_flags & SC_OP_TXAGGR) {
 		if (!retry_tx) {
 			spin_lock_bh(&txq->axq_lock);
-			ath_txq_drain_pending_buffers(sc, txq,
-				ATH9K_BH_STATUS_CHANGE);
+			ath_txq_drain_pending_buffers(sc, txq);
 			spin_unlock_bh(&txq->axq_lock);
 		}
 	}
@@ -2442,24 +2411,13 @@ enum ATH_AGGR_CHECK ath_tx_aggr_check(struct ath_softc *sc,
 
 /* Start TX aggregation */
 
-int ath_tx_aggr_start(struct ath_softc *sc,
-		      const u8 *addr,
-		      u16 tid,
-		      u16 *ssn)
+int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
+		      u16 tid, u16 *ssn)
 {
 	struct ath_atx_tid *txtid;
 	struct ath_node *an;
 
-	spin_lock_bh(&sc->node_lock);
-	an = ath_node_find(sc, (u8 *) addr);
-	spin_unlock_bh(&sc->node_lock);
-
-	if (!an) {
-		DPRINTF(sc, ATH_DBG_AGGR,
-			"%s: Node not found to initialize "
-			"TX aggregation\n", __func__);
-		return -1;
-	}
+	an = (struct ath_node *)sta->drv_priv;
 
 	if (sc->sc_flags & SC_OP_TXAGGR) {
 		txtid = ATH_AN_2_TID(an, tid);
@@ -2472,21 +2430,9 @@ int ath_tx_aggr_start(struct ath_softc *sc,
 
 /* Stop tx aggregation */
 
-int ath_tx_aggr_stop(struct ath_softc *sc,
-		     const u8 *addr,
-		     u16 tid)
+int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 {
-	struct ath_node *an;
-
-	spin_lock_bh(&sc->node_lock);
-	an = ath_node_find(sc, (u8 *) addr);
-	spin_unlock_bh(&sc->node_lock);
-
-	if (!an) {
-		DPRINTF(sc, ATH_DBG_AGGR,
-			"%s: TX aggr stop for non-existent node\n", __func__);
-		return -1;
-	}
+	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 
 	ath_tx_aggr_teardown(sc, an, tid);
 	return 0;
@@ -2499,8 +2445,7 @@ int ath_tx_aggr_stop(struct ath_softc *sc,
  * - Discard all retry frames from the s/w queue.
  */
 
-void ath_tx_aggr_teardown(struct ath_softc *sc,
-	struct ath_node *an, u8 tid)
+void ath_tx_aggr_teardown(struct ath_softc *sc, struct ath_node *an, u8 tid)
 {
 	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
 	struct ath_txq *txq = &sc->sc_txq[txtid->ac->qnum];
@@ -2626,8 +2571,6 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		struct ath_atx_ac *ac;
 		int tidno, acno;
 
-		an->maxampdu = ATH_AMPDU_LIMIT_DEFAULT;
-
 		/*
 		 * Init per tid tx state
 		 */
@@ -2685,8 +2628,7 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 
 /* Cleanupthe pending buffers for the node. */
 
-void ath_tx_node_cleanup(struct ath_softc *sc,
-	struct ath_node *an, bool bh_flag)
+void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 {
 	int i;
 	struct ath_atx_ac *ac, *ac_tmp;
@@ -2696,10 +2638,7 @@ void ath_tx_node_cleanup(struct ath_softc *sc,
 		if (ATH_TXQ_SETUP(sc, i)) {
 			txq = &sc->sc_txq[i];
 
-			if (likely(bh_flag))
-				spin_lock_bh(&txq->axq_lock);
-			else
-				spin_lock(&txq->axq_lock);
+			spin_lock(&txq->axq_lock);
 
 			list_for_each_entry_safe(ac,
 					ac_tmp, &txq->axq_acq, list) {
@@ -2714,17 +2653,14 @@ void ath_tx_node_cleanup(struct ath_softc *sc,
 						tid_tmp, &ac->tid_q, list) {
 					list_del(&tid->list);
 					tid->sched = false;
-					ath_tid_drain(sc, txq, tid, bh_flag);
+					ath_tid_drain(sc, txq, tid);
 					tid->addba_exchangecomplete = 0;
 					tid->addba_exchangeattempts = 0;
 					tid->cleanup_inprogress = false;
 				}
 			}
 
-			if (likely(bh_flag))
-				spin_unlock_bh(&txq->axq_lock);
-			else
-				spin_unlock(&txq->axq_lock);
+			spin_unlock(&txq->axq_lock);
 		}
 	}
 }
@@ -2795,7 +2731,6 @@ void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb)
 		 */
 		xmit_map_sg(sc, skb, &txctl);
 	} else {
-		ath_node_put(sc, txctl.an, ATH9K_BH_STATUS_CHANGE);
 		DPRINTF(sc, ATH_DBG_XMIT, "%s: TX CABQ failed\n", __func__);
 		dev_kfree_skb_any(skb);
 	}
-- 
1.6.0.3

