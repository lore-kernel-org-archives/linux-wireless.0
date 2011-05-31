Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55434 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab1EaTVr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:21:47 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k: show excessive-retry MPDUs in debugfs
Date: Tue, 31 May 2011 21:21:41 +0200
Message-Id: <1306869701-86181-1-git-send-email-nbd@openwrt.org> (sfid-20110531_212151_165926_C209A8E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c |    6 +++++-
 drivers/net/wireless/ath/ath9k/debug.h |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 202399d..5c00e7a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -550,6 +550,7 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 
 	PR("MPDUs Queued:    ", queued);
 	PR("MPDUs Completed: ", completed);
+	PR("MPDUs XRetried:  ", xretries);
 	PR("Aggregates:      ", a_aggr);
 	PR("AMPDUs Queued HW:", a_queued_hw);
 	PR("AMPDUs Queued SW:", a_queued_sw);
@@ -806,7 +807,10 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 		else
 			TX_STAT_INC(qnum, a_completed);
 	} else {
-		TX_STAT_INC(qnum, completed);
+		if (bf_isxretried(bf))
+			TX_STAT_INC(qnum, xretries);
+		else
+			TX_STAT_INC(qnum, completed);
 	}
 
 	if (ts->ts_status & ATH9K_TXERR_FIFO)
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 8ce6ad8..4a04510 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -116,6 +116,7 @@ struct ath_tx_stats {
 	u32 tx_bytes_all;
 	u32 queued;
 	u32 completed;
+	u32 xretries;
 	u32 a_aggr;
 	u32 a_queued_hw;
 	u32 a_queued_sw;
-- 
1.7.3.2

