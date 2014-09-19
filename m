Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42270 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794AbaISSRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2014 14:17:53 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] ath10k: add helper method to grab debug stats.
Date: Fri, 19 Sep 2014 11:17:38 -0700
Message-Id: <1411150659-10998-1-git-send-email-greearb@candelatech.com> (sfid-20140919_201757_259569_DE677789)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

It can be nice to update the firmware's stats while
debugging other bits of the driver, so add helper method
to do this.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 26 +++++++++++++++++---------
 drivers/net/wireless/ath/ath10k/debug.h |  3 +++
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 3756feb..e223ba9 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -371,6 +371,21 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 	complete(&ar->debug.event_stats_compl);
 }
 
+int ath10k_refresh_peer_stats(struct ath10k *ar)
+{
+	int ret = ath10k_wmi_request_stats(ar, WMI_REQUEST_PEER_STAT);
+	if (ret) {
+		ath10k_warn(ar, "could not request stats (%d)\n", ret);
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
@@ -379,7 +394,6 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 	char *buf = NULL;
 	unsigned int len = 0, buf_len = 8000;
 	ssize_t ret_cnt = 0;
-	long left;
 	int i;
 	int ret;
 
@@ -394,14 +408,8 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 	if (!buf)
 		goto exit;
 
-	ret = ath10k_wmi_request_stats(ar, WMI_REQUEST_PEER_STAT);
-	if (ret) {
-		ath10k_warn(ar, "could not request stats (%d)\n", ret);
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
index b3774f7..91b217e 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -142,4 +142,7 @@ static inline void ath10k_dbg_dump(struct ath10k *ar,
 {
 }
 #endif /* CONFIG_ATH10K_DEBUG */
+
+int ath10k_refresh_peer_stats(struct ath10k *ar);
+
 #endif /* _DEBUG_H_ */
-- 
1.7.11.7

