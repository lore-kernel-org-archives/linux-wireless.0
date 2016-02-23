Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49461 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543AbcBWH26 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 02:28:58 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Fix sanity check on enabling btcoex via debugfs
Date: Tue, 23 Feb 2016 12:58:36 +0530
Message-ID: <1456212516-3989-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160223_082903_426046_61A0B4A0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

First check for the device state before enabling / disabling
btcoex, also return a proper error value. Enabling / disabling
btcoex ideally does a f/w + ath10k_core_restart so the checks
that are applicable for 'simulate_fw_crash' shall be applicable
for this as well

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 628b031..e3e29fb 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -2116,6 +2116,7 @@ static ssize_t ath10k_write_btcoex(struct file *file,
 	struct ath10k *ar = file->private_data;
 	char buf[32];
 	size_t buf_size;
+	int ret = 0;
 	bool val;
 
 	buf_size = min(count, (sizeof(buf) - 1));
@@ -2129,6 +2130,12 @@ static ssize_t ath10k_write_btcoex(struct file *file,
 
 	mutex_lock(&ar->conf_mutex);
 
+	if (ar->state != ATH10K_STATE_ON &&
+	    ar->state != ATH10K_STATE_RESTARTED) {
+		ret = -ENETDOWN;
+		goto exit;
+	}
+
 	if (!(test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags) ^ val))
 		goto exit;
 
@@ -2137,17 +2144,15 @@ static ssize_t ath10k_write_btcoex(struct file *file,
 	else
 		clear_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags);
 
-	if (ar->state != ATH10K_STATE_ON)
-		goto exit;
-
 	ath10k_info(ar, "restarting firmware due to btcoex change");
 
 	queue_work(ar->workqueue, &ar->restart_work);
+	ret = count;
 
 exit:
 	mutex_unlock(&ar->conf_mutex);
 
-	return count;
+	return ret;
 }
 
 static ssize_t ath10k_read_btcoex(struct file *file, char __user *ubuf,
-- 
1.7.9.5

