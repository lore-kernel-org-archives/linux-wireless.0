Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47754 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab1FWIJV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 04:09:21 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2011 01:08:45 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/2] ath9k_hw: Fix false tx hung detection in AR9003 chips
Date: Thu, 23 Jun 2011 13:39:13 +0530
Message-ID: <1308816554-2910-1-git-send-email-rmanoharan@atheros.com> (sfid-20110623_100925_806771_5DA3441F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

The edma based (AR9003 family) chips update tx status
descriptors in a common ring buffer for all transmitted
frames. Whenever tx interrupt is raised, the descriptors
are processed and tx status index is moved.

The complete tx stauts ring are updated with beacons tx status
when there are no data frames to be sent for a period of time.
In this state, transmitting data frames causes the driver to
wait for the tx status on an incorrect tx status index though
the status was updated by hw properly. The driver detects this
condition as a h/w hang and does unnecessary chip resets.

This issue was orginally reported in adhoc mode while sending
frames after an idle time.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    8 ++++++--
 drivers/net/wireless/ath/ath9k/beacon.c     |    6 ++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
index 04e6be0..575e185 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -229,6 +229,7 @@ static void ar9003_hw_fill_txdesc(struct ath_hw *ah, void *ds, u32 seglen,
 static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 				 struct ath_tx_status *ts)
 {
+	struct ar9003_txc *txc = (struct ar9003_txc *) ds;
 	struct ar9003_txs *ads;
 	u32 status;
 
@@ -238,7 +239,11 @@ static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	if ((status & AR_TxDone) == 0)
 		return -EINPROGRESS;
 
-	ah->ts_tail = (ah->ts_tail + 1) % ah->ts_size;
+	ts->qid = MS(ads->ds_info, AR_TxQcuNum);
+	if (!txc || (MS(txc->info, AR_TxQcuNum) == ts->qid))
+		ah->ts_tail = (ah->ts_tail + 1) % ah->ts_size;
+	else
+		return -ENOENT;
 
 	if ((MS(ads->ds_info, AR_DescId) != ATHEROS_VENDOR_ID) ||
 	    (MS(ads->ds_info, AR_TxRxDesc) != 1)) {
@@ -254,7 +259,6 @@ static int ar9003_hw_proc_txdesc(struct ath_hw *ah, void *ds,
 	ts->ts_seqnum = MS(status, AR_SeqNum);
 	ts->tid = MS(status, AR_TxTid);
 
-	ts->qid = MS(ads->ds_info, AR_TxQcuNum);
 	ts->desc_id = MS(ads->status1, AR_TxDescId);
 	ts->ts_tstamp = ads->status4;
 	ts->ts_status = 0;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 0174cdb..0b6e3b6 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -360,6 +360,7 @@ void ath_beacon_tasklet(unsigned long data)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_buf *bf = NULL;
 	struct ieee80211_vif *vif;
+	struct ath_tx_status ts;
 	int slot;
 	u32 bfaddr, bc = 0;
 
@@ -464,6 +465,11 @@ void ath_beacon_tasklet(unsigned long data)
 		ath9k_hw_txstart(ah, sc->beacon.beaconq);
 
 		sc->beacon.ast_be_xmit += bc;     /* XXX per-vif? */
+		if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+			spin_lock_bh(&sc->sc_pcu_lock);
+			ath9k_hw_txprocdesc(ah, bf->bf_desc, (void *)&ts);
+			spin_unlock_bh(&sc->sc_pcu_lock);
+		}
 	}
 }
 
-- 
1.7.5.2

