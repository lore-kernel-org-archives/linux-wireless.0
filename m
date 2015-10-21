Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53997 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbbJUXxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 19:53:21 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath6kl@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] ath6k:  break stats gathering code into separate method.
Date: Wed, 21 Oct 2015 16:53:16 -0700
Message-Id: <1445471597-26091-1-git-send-email-greearb@candelatech.com> (sfid-20151022_015324_696208_04F27042)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This will allow us to call it from elsewhere when implementing
ethtool stats.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath6kl/debug.c | 55 +++++++++++++++++++--------------
 drivers/net/wireless/ath/ath6kl/debug.h |  2 ++
 2 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index 81ba48d..91ff6a5 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -98,6 +98,33 @@ void ath6kl_warn(const char *fmt, ...)
 }
 EXPORT_SYMBOL(ath6kl_warn);
 
+int ath6k_read_tgt_stats(struct ath6kl *ar, struct ath6kl_vif *vif)
+{
+	long left;
+
+	if (down_interruptible(&ar->sem))
+		return -EBUSY;
+
+	set_bit(STATS_UPDATE_PEND, &vif->flags);
+
+	if (ath6kl_wmi_get_stats_cmd(ar->wmi, 0)) {
+		up(&ar->sem);
+		return -EIO;
+	}
+
+	left = wait_event_interruptible_timeout(ar->event_wq,
+						!test_bit(STATS_UPDATE_PEND,
+						&vif->flags), WMI_TIMEOUT);
+
+	up(&ar->sem);
+
+	if (left <= 0)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+EXPORT_SYMBOL(ath6k_read_tgt_stats);
+
 #ifdef CONFIG_ATH6KL_DEBUG
 
 void ath6kl_dbg(enum ATH6K_DEBUG_MASK mask, const char *fmt, ...)
@@ -544,42 +571,24 @@ static ssize_t read_file_tgt_stats(struct file *file, char __user *user_buf,
 	char *buf;
 	unsigned int len = 0, buf_len = 1500;
 	int i;
-	long left;
 	ssize_t ret_cnt;
+	int rv;
 
 	vif = ath6kl_vif_first(ar);
 	if (!vif)
 		return -EIO;
 
-	tgt_stats = &vif->target_stats;
-
 	buf = kzalloc(buf_len, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	if (down_interruptible(&ar->sem)) {
+	rv = ath6k_read_tgt_stats(ar, vif);
+	if (rv < 0) {
 		kfree(buf);
-		return -EBUSY;
+		return rv;
 	}
 
-	set_bit(STATS_UPDATE_PEND, &vif->flags);
-
-	if (ath6kl_wmi_get_stats_cmd(ar->wmi, 0)) {
-		up(&ar->sem);
-		kfree(buf);
-		return -EIO;
-	}
-
-	left = wait_event_interruptible_timeout(ar->event_wq,
-						!test_bit(STATS_UPDATE_PEND,
-						&vif->flags), WMI_TIMEOUT);
-
-	up(&ar->sem);
-
-	if (left <= 0) {
-		kfree(buf);
-		return -ETIMEDOUT;
-	}
+	tgt_stats = &vif->target_stats;
 
 	len += scnprintf(buf + len, buf_len - len, "\n");
 	len += scnprintf(buf + len, buf_len - len, "%25s\n",
diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
index 19106ed..be54f19 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.h
+++ b/drivers/net/wireless/ath/ath6kl/debug.h
@@ -59,6 +59,8 @@ enum ath6kl_war {
 	ATH6KL_WAR_INVALID_RATE,
 };
 
+int ath6k_read_tgt_stats(struct ath6kl *ar, struct ath6kl_vif *vif);
+
 #ifdef CONFIG_ATH6KL_DEBUG
 
 void ath6kl_dbg(enum ATH6K_DEBUG_MASK mask, const char *fmt, ...);
-- 
2.4.3

