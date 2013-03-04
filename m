Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49978 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3CDXbm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 18:31:42 -0500
From: greearb@candelatech.com
To: ath9k-devel@venema.h4ckr.net
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] ath9k: Report txerr-filtered errors in debugfs.
Date: Mon,  4 Mar 2013 15:31:16 -0800
Message-Id: <1362439877-12345-1-git-send-email-greearb@candelatech.com> (sfid-20130305_003148_074242_373D4142)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    3 +++
 drivers/net/wireless/ath/ath9k/debug.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 3714b97..daae4d0 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -537,6 +537,7 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("AMPDUs Completed:", a_completed);
 	PR("AMPDUs Retried:  ", a_retries);
 	PR("AMPDUs XRetried: ", a_xretries);
+	PR("TXERR Filtered:  ", txerr_filtered);
 	PR("FIFO Underrun:   ", fifo_underrun);
 	PR("TXOP Exceeded:   ", xtxop);
 	PR("TXTIMER Expiry:  ", timer_exp);
@@ -756,6 +757,8 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 			TX_STAT_INC(qnum, completed);
 	}
 
+	if (ts->ts_status & ATH9K_TXERR_FILT)
+		TX_STAT_INC(qnum, txerr_filtered);
 	if (ts->ts_status & ATH9K_TXERR_FIFO)
 		TX_STAT_INC(qnum, fifo_underrun);
 	if (ts->ts_status & ATH9K_TXERR_XTXOP)
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 410d6d8..794a7ec 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -142,6 +142,7 @@ struct ath_interrupt_stats {
  * @a_completed: Total AMPDUs completed
  * @a_retries: No. of AMPDUs retried (SW)
  * @a_xretries: No. of AMPDUs dropped due to xretries
+ * @txerr_filtered: No. of frames with TXERR_FILT flag set.
  * @fifo_underrun: FIFO underrun occurrences
 	Valid only for:
 		- non-aggregate condition.
@@ -168,6 +169,7 @@ struct ath_tx_stats {
 	u32 a_completed;
 	u32 a_retries;
 	u32 a_xretries;
+	u32 txerr_filtered;
 	u32 fifo_underrun;
 	u32 xtxop;
 	u32 timer_exp;
-- 
1.7.3.4

