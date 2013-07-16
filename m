Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:46537 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab3GPHjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:39:12 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v4 10/10] ath10k: skip fw stats debugfs interface if device is down
Date: Tue, 16 Jul 2013 09:38:59 +0200
Message-ID: <1373960339-8525-11-git-send-email-michal.kazior@tieto.com> (sfid-20130716_093925_620555_94C1805B)
In-Reply-To: <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
References: <1371041642-20273-1-git-send-email-michal.kazior@tieto.com>
 <1373960339-8525-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the device is not running then there may be no
FW at all to send the query to. If the FW is
already there it might still trigger a crash if
the command is sent before the device is fully
initialized.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/debug.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 499034b..65279f5 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -161,7 +161,7 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 	struct wmi_pdev_stats *ps;
 	int i;
 
-	mutex_lock(&ar->conf_mutex);
+	spin_lock_bh(&ar->data_lock);
 
 	stats = &ar->debug.target_stats;
 
@@ -259,6 +259,7 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
 		}
 	}
 
+	spin_unlock_bh(&ar->data_lock);
 	mutex_unlock(&ar->conf_mutex);
 	complete(&ar->debug.event_stats_compl);
 }
@@ -268,35 +269,35 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 {
 	struct ath10k *ar = file->private_data;
 	struct ath10k_target_stats *fw_stats;
-	char *buf;
+	char *buf = NULL;
 	unsigned int len = 0, buf_len = 2500;
-	ssize_t ret_cnt;
+	ssize_t ret_cnt = 0;
 	long left;
 	int i;
 	int ret;
 
 	fw_stats = &ar->debug.target_stats;
 
+	mutex_lock(&ar->conf_mutex);
+
+	if (ar->state != ATH10K_STATE_ON)
+		goto exit;
+
 	buf = kzalloc(buf_len, GFP_KERNEL);
 	if (!buf)
-		return -ENOMEM;
+		goto exit;
 
 	ret = ath10k_wmi_request_stats(ar, WMI_REQUEST_PEER_STAT);
 	if (ret) {
 		ath10k_warn("could not request stats (%d)\n", ret);
-		kfree(buf);
-		return -EIO;
+		goto exit;
 	}
 
 	left = wait_for_completion_timeout(&ar->debug.event_stats_compl, 1*HZ);
+	if (left <= 0)
+		goto exit;
 
-	if (left <= 0) {
-		kfree(buf);
-		return -ETIMEDOUT;
-	}
-
-	mutex_lock(&ar->conf_mutex);
-
+	spin_lock_bh(&ar->data_lock);
 	len += scnprintf(buf + len, buf_len - len, "\n");
 	len += scnprintf(buf + len, buf_len - len, "%30s\n",
 			 "ath10k PDEV stats");
@@ -424,14 +425,15 @@ static ssize_t ath10k_read_fw_stats(struct file *file, char __user *user_buf,
 				 fw_stats->peer_stat[i].peer_tx_rate);
 		len += scnprintf(buf + len, buf_len - len, "\n");
 	}
+	spin_unlock_bh(&ar->data_lock);
 
 	if (len > buf_len)
 		len = buf_len;
 
 	ret_cnt = simple_read_from_buffer(user_buf, count, ppos, buf, len);
 
+exit:
 	mutex_unlock(&ar->conf_mutex);
-
 	kfree(buf);
 	return ret_cnt;
 }
-- 
1.7.9.5

