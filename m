Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55834 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752828AbeBSMv2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:51:28 -0500
From: Venkateswara Naralasetty <vnaralas@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Subject: [PATCH] ath10k: fix information leak in debugfs
Date: Mon, 19 Feb 2018 18:21:21 +0530
Message-Id: <1519044681-5663-1-git-send-email-vnaralas@codeaurora.org> (sfid-20180219_135144_549003_4D7D3898)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During write to some of debugfs in ath10k, few variables exposing stack
data when process user input. which leads to possible information leak.

This patch fix this issue by initializing buffer and checks
the return valure of 'simple_write_to_buffer'.

Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/debug.c       | 20 ++++++++---------
 drivers/net/wireless/ath/ath10k/debugfs_sta.c | 31 ++++++++++++++-------------
 2 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 554cd78..21c348b 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -987,13 +987,13 @@ static ssize_t ath10k_write_htt_max_amsdu_ampdu(struct file *file,
 {
 	struct ath10k *ar = file->private_data;
 	int res;
-	char buf[64];
+	char buf[64] = {0};
 	unsigned int amsdu, ampdu;
 
-	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
-
-	/* make sure that buf is null terminated */
-	buf[sizeof(buf) - 1] = 0;
+	res = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos,
+				     user_buf, count);
+	if (res <= 0)
+		return res;
 
 	res = sscanf(buf, "%u %u", &amsdu, &ampdu);
 
@@ -1043,14 +1043,14 @@ static ssize_t ath10k_write_fw_dbglog(struct file *file,
 {
 	struct ath10k *ar = file->private_data;
 	int ret;
-	char buf[96];
+	char buf[96] = {0};
 	unsigned int log_level;
 	u64 mask;
 
-	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
-
-	/* make sure that buf is null terminated */
-	buf[sizeof(buf) - 1] = 0;
+	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos,
+				     user_buf, count);
+	if (ret <= 0)
+		return ret;
 
 	ret = sscanf(buf, "%llx %u", &mask, &log_level);
 
diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index b260b09..5583854 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2014-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -136,12 +137,12 @@ static ssize_t ath10k_dbg_sta_write_addba(struct file *file,
 	struct ath10k *ar = arsta->arvif->ar;
 	u32 tid, buf_size;
 	int ret;
-	char buf[64];
+	char buf[64] = {0};
 
-	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
-
-	/* make sure that buf is null terminated */
-	buf[sizeof(buf) - 1] = '\0';
+	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos,
+				     user_buf, count);
+	if (ret <= 0)
+		return ret;
 
 	ret = sscanf(buf, "%u %u", &tid, &buf_size);
 	if (ret != 2)
@@ -187,12 +188,12 @@ static ssize_t ath10k_dbg_sta_write_addba_resp(struct file *file,
 	struct ath10k *ar = arsta->arvif->ar;
 	u32 tid, status;
 	int ret;
-	char buf[64];
-
-	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
+	char buf[64] = {0};
 
-	/* make sure that buf is null terminated */
-	buf[sizeof(buf) - 1] = '\0';
+	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos,
+				     user_buf, count);
+	if (ret <= 0)
+		return ret;
 
 	ret = sscanf(buf, "%u %u", &tid, &status);
 	if (ret != 2)
@@ -237,12 +238,12 @@ static ssize_t ath10k_dbg_sta_write_delba(struct file *file,
 	struct ath10k *ar = arsta->arvif->ar;
 	u32 tid, initiator, reason;
 	int ret;
-	char buf[64];
-
-	simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
+	char buf[64] = {0};
 
-	/* make sure that buf is null terminated */
-	buf[sizeof(buf) - 1] = '\0';
+	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos,
+				     user_buf, count);
+	if (ret <= 0)
+		return ret;
 
 	ret = sscanf(buf, "%u %u %u", &tid, &initiator, &reason);
 	if (ret != 3)
-- 
2.7.4
