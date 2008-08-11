Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16327 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbYHKIpY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 04:45:24 -0400
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 01:45:24 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18591.63857.287141.273206@localhost.localdomain> (sfid-20080811_104526_293433_48ED0A00)
Date: Mon, 11 Aug 2008 14:03:53 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 04/10] ath9k: Remove a few unnecessary macros
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |   15 +++------------
 drivers/net/wireless/ath9k/xmit.c |    2 +-
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 9e16c6c..19399da 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -396,8 +396,7 @@ int ath_rx_subframe(struct ath_node *an, struct sk_buff *skb,
 /* TX */
 /******/
 
-#define ATH_FRAG_PER_MSDU       1
-#define ATH_TXBUF               (512/ATH_FRAG_PER_MSDU)
+#define ATH_TXBUF               512
 /* max number of transmit attempts (tries) */
 #define ATH_TXMAXTRY            13
 /* max number of 11n transmit attempts (tries) */
@@ -551,10 +550,10 @@ void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq);
 int ath_tx_setup(struct ath_softc *sc, int haltype);
 void ath_draintxq(struct ath_softc *sc, bool retry_tx);
 void ath_tx_draintxq(struct ath_softc *sc,
-	struct ath_txq *txq, bool retry_tx);
+		     struct ath_txq *txq, bool retry_tx);
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an);
 void ath_tx_node_cleanup(struct ath_softc *sc,
-	struct ath_node *an, bool bh_flag);
+			 struct ath_node *an, bool bh_flag);
 void ath_tx_node_free(struct ath_softc *sc, struct ath_node *an);
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq);
 int ath_tx_init(struct ath_softc *sc, int nbufs);
@@ -579,7 +578,6 @@ void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 /* indicates the node is 80211 power save */
 #define ATH_NODE_PWRSAVE        0x2
 
-#define ADDBA_TIMEOUT              200 /* 200 milliseconds */
 #define ADDBA_EXCHANGE_ATTEMPTS    10
 #define ATH_AGGR_DELIM_SZ          4   /* delimiter size   */
 #define ATH_AGGR_MINPLEN           256 /* in bytes, minimum packet length */
@@ -699,9 +697,6 @@ struct ath_node *ath_node_find(struct ath_softc *sc, u8 *addr);
 #define	ATH_BCBUF               	4   /* number of beacon buffers */
 #define ATH_DEFAULT_BINTVAL     	100 /* default beacon interval in TU */
 #define ATH_DEFAULT_BMISS_LIMIT 	10
-#define	ATH_BEACON_AIFS_DEFAULT		0  /* Default aifs for ap beacon q */
-#define	ATH_BEACON_CWMIN_DEFAULT	0  /* Default cwmin for ap beacon q */
-#define	ATH_BEACON_CWMAX_DEFAULT	0  /* Default cwmax for ap beacon q */
 #define IEEE80211_MS_TO_TU(x)           (((x) * 1000) / 1024)
 
 /* beacon configuration */
@@ -838,8 +833,6 @@ void ath_setdefantenna(void *sc, u32 antenna);
 #define ATH_PREAMBLE_SHORT	(1<<0)
 #define ATH_PROTECT_ENABLE	(1<<1)
 #define ATH_MAX_SW_RETRIES      10
-/* Num farmes difference in tx to flip default recv */
-#define	ATH_ANTENNA_DIFF	2
 #define ATH_CHAN_MAX            255
 #define IEEE80211_WEP_NKID      4       /* number of key ids */
 #define IEEE80211_RATE_VAL      0x7f
@@ -853,9 +846,7 @@ void ath_setdefantenna(void *sc, u32 antenna);
  */
 #define	ATH_KEYMAX	        128        /* max key cache size we handle */
 
-#define RESET_RETRY_TXQ         0x00000001
 #define ATH_IF_ID_ANY   	0xff
-
 #define ATH_TXPOWER_MAX         100     /* .5 dBm units */
 
 #define RSSI_LPF_THRESHOLD         -20
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 47cf9f3..a24a3a5 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -2174,7 +2174,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 
 		/* Setup tx descriptors */
 		error = ath_descdma_setup(sc, &sc->sc_txdma, &sc->sc_txbuf,
-			"tx", nbufs * ATH_FRAG_PER_MSDU, 1);
+			"tx", nbufs, 1);
 		if (error != 0) {
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: failed to allocate tx descriptors: %d\n",
-- 
1.5.6.5

