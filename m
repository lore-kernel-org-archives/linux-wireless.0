Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59826 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab2LLVzn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 16:55:43 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 1/6] ath9k: Report txerr-filtered errors in debugfs.
Date: Wed, 12 Dec 2012 13:54:50 -0800
Message-Id: <1355349295-30960-1-git-send-email-greearb@candelatech.com> (sfid-20121212_225545_855951_1C69263D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    3 +++
 drivers/net/wireless/ath/ath9k/debug.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 13ff9ed..429be51 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -536,6 +536,7 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("AMPDUs Completed:", a_completed);
 	PR("AMPDUs Retried:  ", a_retries);
 	PR("AMPDUs XRetried: ", a_xretries);
+	PR("TXERR Filtered:  ", txerr_filtered);
 	PR("FIFO Underrun:   ", fifo_underrun);
 	PR("TXOP Exceeded:   ", xtxop);
 	PR("TXTIMER Expiry:  ", timer_exp);
@@ -755,6 +756,8 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 			TX_STAT_INC(qnum, completed);
 	}
 
+	if (ts->ts_status & ATH9K_TXERR_FILT)
+		TX_STAT_INC(qnum, txerr_filtered);
 	if (ts->ts_status & ATH9K_TXERR_FIFO)
 		TX_STAT_INC(qnum, fifo_underrun);
 	if (ts->ts_status & ATH9K_TXERR_XTXOP)
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 375c3b4..5c2db3e 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -141,6 +141,7 @@ struct ath_interrupt_stats {
  * @a_completed: Total AMPDUs completed
  * @a_retries: No. of AMPDUs retried (SW)
  * @a_xretries: No. of AMPDUs dropped due to xretries
+ * @txerr_filtered: No. of frames with TXERR_FILT flag set.
  * @fifo_underrun: FIFO underrun occurrences
 	Valid only for:
 		- non-aggregate condition.
@@ -167,6 +168,7 @@ struct ath_tx_stats {
 	u32 a_completed;
 	u32 a_retries;
 	u32 a_xretries;
+	u32 txerr_filtered;
 	u32 fifo_underrun;
 	u32 xtxop;
 	u32 timer_exp;
-- 
1.7.3.4

