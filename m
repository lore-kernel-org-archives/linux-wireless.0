Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45334 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab3JEMJn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Oct 2013 08:09:43 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.12] ath9k: fix tx queue scheduling after channel changes
Date: Sat,  5 Oct 2013 14:09:30 +0200
Message-Id: <1380974970-61770-1-git-send-email-nbd@openwrt.org> (sfid-20131005_140947_345629_EBF3C829)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise, if queues are full during a scan, tx scheduling does not
resume after switching back to the home channel.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cdb3b1e..433caf4 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -208,6 +208,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	unsigned long flags;
+	int i;
 
 	if (ath_startrecv(sc) != 0) {
 		ath_err(common, "Unable to restart recv logic\n");
@@ -235,6 +236,15 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 		}
 	work:
 		ath_restart_work(sc);
+
+		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+			if (!ATH_TXQ_SETUP(sc, i))
+				continue;
+
+			spin_lock_bh(&sc->tx.txq[i].axq_lock);
+			ath_txq_schedule(sc, &sc->tx.txq[i]);
+			spin_unlock_bh(&sc->tx.txq[i].axq_lock);
+		}
 	}
 
 	ieee80211_wake_queues(sc->hw);
@@ -545,21 +555,10 @@ chip_reset:
 
 static int ath_reset(struct ath_softc *sc)
 {
-	int i, r;
+	int r;
 
 	ath9k_ps_wakeup(sc);
-
 	r = ath_reset_internal(sc, NULL);
-
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-		if (!ATH_TXQ_SETUP(sc, i))
-			continue;
-
-		spin_lock_bh(&sc->tx.txq[i].axq_lock);
-		ath_txq_schedule(sc, &sc->tx.txq[i]);
-		spin_unlock_bh(&sc->tx.txq[i].axq_lock);
-	}
-
 	ath9k_ps_restore(sc);
 
 	return r;
-- 
1.8.0.2

