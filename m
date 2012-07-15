Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40172 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab2GORxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Jul 2012 13:53:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 07/12] ath9k: make per-WMM-AC queue sizes configurable via debugfs
Date: Sun, 15 Jul 2012 19:53:35 +0200
Message-Id: <1342374820-92409-7-git-send-email-nbd@openwrt.org> (sfid-20120715_195350_948252_7DFB8977)
In-Reply-To: <1342374820-92409-6-git-send-email-nbd@openwrt.org>
References: <1342374820-92409-1-git-send-email-nbd@openwrt.org>
 <1342374820-92409-2-git-send-email-nbd@openwrt.org>
 <1342374820-92409-3-git-send-email-nbd@openwrt.org>
 <1342374820-92409-4-git-send-email-nbd@openwrt.org>
 <1342374820-92409-5-git-send-email-nbd@openwrt.org>
 <1342374820-92409-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prepare for using different queue size defaults for each AC.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/debug.c |    8 ++++++++
 drivers/net/wireless/ath/ath9k/init.c  |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c  |    6 ++++--
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 54f0c9d0..db17ec4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -297,6 +297,7 @@ struct ath_tx {
 	struct ath_txq txq[ATH9K_NUM_TX_QUEUES];
 	struct ath_descdma txdma;
 	struct ath_txq *txq_map[WME_NUM_AC];
+	u32 txq_max_pending[WME_NUM_AC];
 };
 
 struct ath_rx_edma {
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 5c3192f..b9ea067 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1556,6 +1556,14 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_interrupt);
 	debugfs_create_file("xmit", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_xmit);
+	debugfs_create_u32("qlen_bk", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+			   &sc->tx.txq_max_pending[WME_AC_BK]);
+	debugfs_create_u32("qlen_be", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+			   &sc->tx.txq_max_pending[WME_AC_BE]);
+	debugfs_create_u32("qlen_vi", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+			   &sc->tx.txq_max_pending[WME_AC_VI]);
+	debugfs_create_u32("qlen_vo", S_IRUSR | S_IWUSR, sc->debug.debugfs_phy,
+			   &sc->tx.txq_max_pending[WME_AC_VO]);
 	debugfs_create_file("stations", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_stations);
 	debugfs_create_file("misc", S_IRUSR, sc->debug.debugfs_phy, sc,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index af95d18..181977a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -434,6 +434,7 @@ static int ath9k_init_queues(struct ath_softc *sc)
 	for (i = 0; i < WME_NUM_AC; i++) {
 		sc->tx.txq_map[i] = ath_txq_setup(sc, ATH9K_TX_QUEUE_DATA, i);
 		sc->tx.txq_map[i]->mac80211_qnum = i;
+		sc->tx.txq_max_pending[i] = ATH_MAX_QDEPTH;
 	}
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index cafb4a0..571d773 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1988,7 +1988,8 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 
 	ath_txq_lock(sc, txq);
 	if (txq == sc->tx.txq_map[q] &&
-	    ++txq->pending_frames > ATH_MAX_QDEPTH && !txq->stopped) {
+	    ++txq->pending_frames > sc->tx.txq_max_pending[q] &&
+	    !txq->stopped) {
 		ieee80211_stop_queue(sc->hw, q);
 		txq->stopped = true;
 	}
@@ -2047,7 +2048,8 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		if (WARN_ON(--txq->pending_frames < 0))
 			txq->pending_frames = 0;
 
-		if (txq->stopped && txq->pending_frames < ATH_MAX_QDEPTH) {
+		if (txq->stopped &&
+		    txq->pending_frames < sc->tx.txq_max_pending[q]) {
 			ieee80211_wake_queue(sc->hw, q);
 			txq->stopped = false;
 		}
-- 
1.7.7.5 (Apple Git-26)

