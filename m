Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:50702 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751320AbcLES7J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 13:59:09 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 2/2] mac80211:  Show pending txqlen in debugfs.
Date: Mon,  5 Dec 2016 10:58:30 -0800
Message-Id: <1480964310-16698-2-git-send-email-greearb@candelatech.com> (sfid-20161205_195917_817719_B208E110)
In-Reply-To: <1480964310-16698-1-git-send-email-greearb@candelatech.com>
References: <1480964310-16698-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Could be useful for debugging memory consumption issues,
and perhaps power-save as well.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Use more appropriate length, add comment to explain
  magic numbers.

 net/mac80211/debugfs.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index b251b2f7..b7a0493 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -162,6 +162,31 @@ static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 	return rv;
 }
 
+static ssize_t misc_read(struct file *file, char __user *user_buf,
+			 size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	/* Max len of each line is 16 characters, plus 9 for 'pending:\n' */
+	size_t bufsz = IEEE80211_MAX_QUEUES * 16 + 9;
+	char *buf = kzalloc(bufsz, GFP_KERNEL);
+	char *pos = buf, *end = buf + bufsz - 1;
+	ssize_t rv;
+	int i;
+	int ln;
+
+	pos += scnprintf(pos, end - pos, "pending:\n");
+
+	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
+		ln = skb_queue_len(&local->pending[i]);
+		pos += scnprintf(pos, end - pos, "[%i] %d\n",
+				 i, ln);
+	}
+
+	rv = simple_read_from_buffer(user_buf, count, ppos, buf, strlen(buf));
+	kfree(buf);
+	return rv;
+}
+
 static ssize_t queues_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -182,6 +207,7 @@ static ssize_t queues_read(struct file *file, char __user *user_buf,
 
 DEBUGFS_READONLY_FILE_OPS(hwflags);
 DEBUGFS_READONLY_FILE_OPS(queues);
+DEBUGFS_READONLY_FILE_OPS(misc);
 
 /* statistics stuff */
 
@@ -250,6 +276,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(total_ps_buffered);
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(queues);
+	DEBUGFS_ADD(misc);
 #ifdef CONFIG_PM
 	DEBUGFS_ADD_MODE(reset, 0200);
 #endif
-- 
2.4.11
