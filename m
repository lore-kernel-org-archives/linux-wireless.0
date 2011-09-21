Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13705 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1IUIxP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 04:53:15 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	<senthilb@qca.qualcomm.com>, <rmanohar@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k: add Block ACK bitmap in sample debug
Date: Wed, 21 Sep 2011 14:22:49 +0530
Message-ID: <1316595169-2744-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110921_105319_708630_A69C1B0D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

this represents the bitmap of block ACK received after the
successful transmission of an aggregate frame. also made few
changes to beautify the display

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   24 ++++++++++++++++++------
 drivers/net/wireless/ath/ath9k/debug.h |    2 ++
 2 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 179da20..a5329c9 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -876,6 +876,15 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 	TX_SAMP_DBG(rssi) = ts->ts_rssi;
 	TX_SAMP_DBG(tid) = ts->tid;
 	TX_SAMP_DBG(qid) = ts->qid;
+
+	if (ts->ts_flags & ATH9K_TX_BA) {
+		TX_SAMP_DBG(ba_low) = ts->ba_low;
+		TX_SAMP_DBG(ba_high) = ts->ba_high;
+	} else {
+		TX_SAMP_DBG(ba_low) = 0;
+		TX_SAMP_DBG(ba_high) = 0;
+	}
+
 	sc->debug.tsidx = (sc->debug.tsidx + 1) % ATH_DBG_MAX_SAMPLES;
 	spin_unlock(&sc->debug.samp_lock);
 
@@ -1516,14 +1525,15 @@ static int open_file_bb_mac_samps(struct inode *inode, struct file *file)
 	len += snprintf(buf + len, size - len, "Tx status Dump :\n");
 	len += snprintf(buf + len, size - len,
 			"Sample rssi:- ctl0 ctl1 ctl2 ext0 ext1 ext2 comb "
-			"isok rts_fail data_fail rate tid qid tx_before(ms)\n");
+			"isok rts_fail data_fail rate tid qid "
+					"ba_low  ba_high tx_before(ms)\n");
 	for (sampidx = 0; sampidx < ATH_DBG_MAX_SAMPLES; sampidx++) {
 		for (i = 0; i < ATH_DBG_MAX_SAMPLES; i++) {
 			if (!ATH_SAMP_DBG(ts[i].jiffies))
 				continue;
-			len += snprintf(buf + len, size - len, "%4d \t"
-				"%8d %4d %4d %4d %4d %4d %4d %4d %4d "
-				"%4d %4d %2d %2d %d\n",
+			len += snprintf(buf + len, size - len, "%-14d"
+				"%-4d %-4d %-4d %-4d %-4d %-4d %-4d %-4d %-8d "
+				"%-9d %-4d %-3d %-3d %08x %08x %-11d\n",
 				sampidx,
 				ATH_SAMP_DBG(ts[i].rssi_ctl0),
 				ATH_SAMP_DBG(ts[i].rssi_ctl1),
@@ -1538,6 +1548,8 @@ static int open_file_bb_mac_samps(struct inode *inode, struct file *file)
 				ATH_SAMP_DBG(ts[i].rateindex),
 				ATH_SAMP_DBG(ts[i].tid),
 				ATH_SAMP_DBG(ts[i].qid),
+				ATH_SAMP_DBG(ts[i].ba_low),
+				ATH_SAMP_DBG(ts[i].ba_high),
 				jiffies_to_msecs(jiffies -
 					ATH_SAMP_DBG(ts[i].jiffies)));
 		}
@@ -1550,8 +1562,8 @@ static int open_file_bb_mac_samps(struct inode *inode, struct file *file)
 		for (i = 0; i < ATH_DBG_MAX_SAMPLES; i++) {
 			if (!ATH_SAMP_DBG(rs[i].jiffies))
 				continue;
-			len += snprintf(buf + len, size - len, "%4d \t"
-				"%8d %4d %4d %4d %4d %4d %4d %s %4d %02x %d\n",
+			len += snprintf(buf + len, size - len, "%-14d"
+				"%-4d %-4d %-4d %-4d %-4d %-4d %-4d %-9s %-2d %02x %-13d\n",
 				sampidx,
 				ATH_SAMP_DBG(rs[i].rssi_ctl0),
 				ATH_SAMP_DBG(rs[i].rssi_ctl1),
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 39f89bc..b93e88b 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -196,6 +196,8 @@ struct ath_dbg_bb_mac_samp {
 		u8 rateindex;
 		u8 qid;
 		u8 tid;
+		u32 ba_low;
+		u32 ba_high;
 	} ts[ATH_DBG_MAX_SAMPLES];
 	struct {
 		u64 jiffies;
-- 
1.7.0.4

