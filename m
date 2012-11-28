Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:56849
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751409Ab2K1Jj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:39:26 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] ath9k: Replace WME_NUM_TID with IEEE80211_NUM_TIDS
Date: Wed, 28 Nov 2012 15:08:53 +0530
Message-Id: <1354095535-3564-2-git-send-email-sujith@msujith.org> (sfid-20121128_103931_894936_3A44E38F)
In-Reply-To: <1354095535-3564-1-git-send-email-sujith@msujith.org>
References: <1354095535-3564-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  | 2 +-
 drivers/net/wireless/ath/ath9k/common.h | 1 -
 drivers/net/wireless/ath/ath9k/xmit.c   | 8 ++++----
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 80bab1b..60bf784 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -261,7 +261,7 @@ struct ath_atx_tid {
 struct ath_node {
 	struct ieee80211_sta *sta; /* station struct we're part of */
 	struct ieee80211_vif *vif; /* interface with which we're associated */
-	struct ath_atx_tid tid[WME_NUM_TID];
+	struct ath_atx_tid tid[IEEE80211_NUM_TIDS];
 	struct ath_atx_ac ac[IEEE80211_NUM_ACS];
 	int ps_key;
 
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 76b5439..5f845be 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -23,7 +23,6 @@
 
 /* Common header for Atheros 802.11n base driver cores */
 
-#define WME_NUM_TID             16
 #define WME_BA_BMP_SIZE         64
 #define WME_MAX_BA              WME_BA_BMP_SIZE
 #define ATH_TID_MAX_BUFS        (2 * WME_MAX_BA)
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3413094..a0a3063 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1263,7 +1263,7 @@ void ath_tx_aggr_sleep(struct ieee80211_sta *sta, struct ath_softc *sc,
 	int tidno;
 
 	for (tidno = 0, tid = &an->tid[tidno];
-	     tidno < WME_NUM_TID; tidno++, tid++) {
+	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
 
 		if (!tid->sched)
 			continue;
@@ -1297,7 +1297,7 @@ void ath_tx_aggr_wakeup(struct ath_softc *sc, struct ath_node *an)
 	int tidno;
 
 	for (tidno = 0, tid = &an->tid[tidno];
-	     tidno < WME_NUM_TID; tidno++, tid++) {
+	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
 
 		ac = tid->ac;
 		txq = ac->txq;
@@ -2448,7 +2448,7 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	int tidno, acno;
 
 	for (tidno = 0, tid = &an->tid[tidno];
-	     tidno < WME_NUM_TID;
+	     tidno < IEEE80211_NUM_TIDS;
 	     tidno++, tid++) {
 		tid->an        = an;
 		tid->tidno     = tidno;
@@ -2481,7 +2481,7 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 	int tidno;
 
 	for (tidno = 0, tid = &an->tid[tidno];
-	     tidno < WME_NUM_TID; tidno++, tid++) {
+	     tidno < IEEE80211_NUM_TIDS; tidno++, tid++) {
 
 		ac = tid->ac;
 		txq = ac->txq;
-- 
1.8.0.1

