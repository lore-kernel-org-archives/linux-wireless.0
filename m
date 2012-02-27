Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36041 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745Ab2B0S6v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 13:58:51 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	rmanohar@qca.qualcomm.com
Subject: [PATCH 3.3 1/4] Revert "ath9k_hw: Fix false tx hung detection in AR9003 chips"
Date: Mon, 27 Feb 2012 19:58:39 +0100
Message-Id: <1330369122-60220-1-git-send-email-nbd@openwrt.org> (sfid-20120227_195858_344550_1441E97B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The approach of this change is flawed, as it triggers tx status processing
from more callsites, yet the chips only have one global tx status queue.
Subsequent patches will properly fix the issue that this one tried to address.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    8 ++------
 drivers/net/wireless/ath/ath9k/beacon.c     |    6 ------
 2 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 09b8c9d..73d44bc 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -346,7 +346,6 @@ static bool ar9003_hw_get_isr(struct ath_hw *ah, enum ath9k_int *masked)
 static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 				 struct ath_tx_status *ts)
 {
-	struct ar9003_txc *txc = (struct ar9003_txc *) ds;
 	struct ar9003_txs *ads;
 	u32 status;
 
@@ -356,11 +355,7 @@ static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	if ((status & AR_TxDone) == 0)
 		return -EINPROGRESS;
 
-	ts->qid = MS(ads->ds_info, AR_TxQcuNum);
-	if (!txc || (MS(txc->info, AR_TxQcuNum) == ts->qid))
-		ah->ts_tail = (ah->ts_tail + 1) % ah->ts_size;
-	else
-		return -ENOENT;
+	ah->ts_tail = (ah->ts_tail + 1) % ah->ts_size;
 
 	if ((MS(ads->ds_info, AR_DescId) != ATHEROS_VENDOR_ID) ||
 	    (MS(ads->ds_info, AR_TxRxDesc) != 1)) {
@@ -374,6 +369,7 @@ static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	ts->ts_seqnum = MS(status, AR_SeqNum);
 	ts->tid = MS(status, AR_TxTid);
 
+	ts->qid = MS(ads->ds_info, AR_TxQcuNum);
 	ts->desc_id = MS(ads->status1, AR_TxDescId);
 	ts->ts_tstamp = ads->status4;
 	ts->ts_status = 0;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index b8967e4..6d1e465 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -355,7 +355,6 @@ void ath_beacon_tasklet(unsigned long data)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_buf *bf = NULL;
 	struct ieee80211_vif *vif;
-	struct ath_tx_status ts;
 	bool edma = !!(ah->caps.hw_caps & ATH9K_HW_CAP_EDMA);
 	int slot;
 	u32 bfaddr, bc = 0;
@@ -462,11 +461,6 @@ void ath_beacon_tasklet(unsigned long data)
 			ath9k_hw_txstart(ah, sc->beacon.beaconq);
 
 		sc->beacon.ast_be_xmit += bc;     /* XXX per-vif? */
-		if (edma) {
-			spin_lock_bh(&sc->sc_pcu_lock);
-			ath9k_hw_txprocdesc(ah, bf->bf_desc, (void *)&ts);
-			spin_unlock_bh(&sc->sc_pcu_lock);
-		}
 	}
 }
 
-- 
1.7.3.2

