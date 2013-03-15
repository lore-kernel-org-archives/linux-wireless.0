Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47898 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755658Ab3COPSy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 11:18:54 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3.9] ath9k: limit tx path hang check to normal data queues
Date: Fri, 15 Mar 2013 16:18:44 +0100
Message-Id: <1363360724-44435-1-git-send-email-nbd@openwrt.org> (sfid-20130315_161910_659900_0E1AAE20)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon and multicast-buffer queues are managed by the beacon
tasklet, and the generic tx path hang check does not help in any way
here. Running it on those queues anyway can introduce some race
conditions leading to unnecessary chip resets.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/link.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index ade3afb..39c84ec 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -28,21 +28,21 @@ void ath_tx_complete_poll_work(struct work_struct *work)
 	int i;
 	bool needreset = false;
 
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
-		if (ATH_TXQ_SETUP(sc, i)) {
-			txq = &sc->tx.txq[i];
-			ath_txq_lock(sc, txq);
-			if (txq->axq_depth) {
-				if (txq->axq_tx_inprogress) {
-					needreset = true;
-					ath_txq_unlock(sc, txq);
-					break;
-				} else {
-					txq->axq_tx_inprogress = true;
-				}
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		txq = sc->tx.txq_map[i];
+
+		ath_txq_lock(sc, txq);
+		if (txq->axq_depth) {
+			if (txq->axq_tx_inprogress) {
+				needreset = true;
+				ath_txq_unlock(sc, txq);
+				break;
+			} else {
+				txq->axq_tx_inprogress = true;
 			}
-			ath_txq_unlock_complete(sc, txq);
 		}
+		ath_txq_unlock_complete(sc, txq);
+	}
 
 	if (needreset) {
 		ath_dbg(ath9k_hw_common(sc->sc_ah), RESET,
-- 
1.8.0.2

