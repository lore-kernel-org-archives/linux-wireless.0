Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43408 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaDAR4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 13:56:37 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/1] ath10k:  add helper method to grab debug stats.
Date: Tue,  1 Apr 2014 10:55:40 -0700
Message-Id: <1396374940-21453-1-git-send-email-greearb@candelatech.com> (sfid-20140401_195644_857582_E33E0750)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

It can be nice to update the firmware's stats while
debugging other bits of the driver, so add helper method
to do this.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 26 +++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/debug.h |  2 ++
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index f562ac5..5813286 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -283,6 +283,21 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 	complete(&ar->debug.event_stats_compl);
 }
 
+int ath10k_refresh_peer_stats(struct ath10k *ar)
+{
+	int ret = ath10k_wmi_request_stats(ar, WMI_REQUEST_PEER_STAT);
+	if (ret) {
+		ath10k_warn("could not request stats (%d)\n", ret);
+		return ret;
+	}
+
+	ret = wait_for_completion_timeout(&ar->debug.event_stats_compl, 1*HZ);
+	if (ret <= 0)
+		return ret;
+
+	return 0;
+}
+
 static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 				    size_t count, loff_t *ppos)
 {
@@ -291,7 +306,6 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 	char *buf = NULL;
 	unsigned int len = 0, buf_len = 8000;
 	ssize_t ret_cnt = 0;
-	long left;
 	int i;
 	int ret;
 
@@ -306,14 +320,8 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 	if (!buf)
 		goto exit;
 
-	ret = ath10k_wmi_request_stats(ar, WMI_REQUEST_PEER_STAT);
-	if (ret) {
-		ath10k_warn("could not request stats (%d)\n", ret);
-		goto exit;
-	}
-
-	left = wait_for_completion_timeout(&ar->debug.event_stats_compl, 1*HZ);
-	if (left <= 0)
+	ret = ath10k_refresh_peer_stats(ar);
+	if (ret)
 		goto exit;
 
 	spin_lock_bh(&ar->data_lock);
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 12573fa..e5d1391 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -135,4 +135,6 @@ struct dbglog_hdr_s {
 
 void ath10k_dbg_print_fw_dbg_buffer(u8 *buffer, int len, const char* lvl);
 
+int ath10k_refresh_peer_stats(struct ath10k *ar);
+
 #endif /* _DEBUG_H_ */
-- 
1.7.11.7

