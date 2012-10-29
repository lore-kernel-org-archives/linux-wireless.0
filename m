Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:54422 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532Ab2J2MZc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 08:25:32 -0400
From: Sven Eckelmann <sven@narfation.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, nbd@openwrt.org,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH] ath9k: Test for TID only in BlockAcks while checking tx status
Date: Mon, 29 Oct 2012 13:25:20 +0100
Message-Id: <1351513520-23536-1-git-send-email-sven@narfation.org> (sfid-20121029_132541_879346_3E367136)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath9k xmit functions for AMPDUs can send frames as non-aggregate in case
only one frame is currently available. The client will then answer using a
normal Ack instead of a BlockAck. This acknowledgement has no TID stored and
therefore the hardware is not able to provide us the corresponding TID.

The TID set by the hardware in the tx status descriptor has to be seen as
undefined and not as a valid TID value for normal acknowledgements. Doing
otherwise results in a massive amount of retransmissions and stalls of
connections.

Users may experience low bandwidth and complete connection stalls in
environments with transfers using multiple TIDs.

This regression was introduced in b11b160defc48e4daa283f785192ea3a23a51f8e
("ath9k: validate the TID in the tx status information").

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 378bd70..d34d929 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -393,7 +393,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	u16 seq_st = 0, acked_cnt = 0, txfail_cnt = 0, seq_first;
 	u32 ba[WME_BA_BMP_SIZE >> 5];
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
-	bool rc_update = true;
+	bool rc_update = true, isba;
 	struct ieee80211_tx_rate rates[4];
 	struct ath_frame_info *fi;
 	int nframes;
@@ -437,13 +437,17 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	tidno = ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
 	tid = ATH_AN_2_TID(an, tidno);
 	seq_first = tid->seq_start;
+	isba = ts->ts_flags & ATH9K_TX_BA;
 
 	/*
 	 * The hardware occasionally sends a tx status for the wrong TID.
 	 * In this case, the BA status cannot be considered valid and all
 	 * subframes need to be retransmitted
+	 *
+	 * Only BlockAcks have a TID and therefore normal Acks cannot be
+	 * checked
 	 */
-	if (tidno != ts->tid)
+	if (isba && tidno != ts->tid)
 		txok = false;
 
 	isaggr = bf_isaggr(bf);
-- 
1.7.10.4

