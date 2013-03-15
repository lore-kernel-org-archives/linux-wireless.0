Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56228 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab3COVNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Mar 2013 17:13:24 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 1/2] mac80211:  Add debugfs file to show station-hash counts.
Date: Fri, 15 Mar 2013 14:13:12 -0700
Message-Id: <1363381993-31496-1-git-send-email-greearb@candelatech.com> (sfid-20130315_221327_585144_FB0157A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Helps debug bad hash spreads, like when you have lots of
station interfaces all connected to the same AP.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 466f4b4... 07885cb... M	net/mac80211/debugfs.c
 net/mac80211/debugfs.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 466f4b4..07885cb 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -177,8 +177,44 @@ static ssize_t queues_read(struct file *file, char __user *user_buf,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, res);
 }
 
+static ssize_t sta_hash_read(struct file *file, char __user *user_buf,
+			     size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	int mxln = STA_HASH_SIZE * 10;
+	char *buf = kzalloc(mxln, GFP_KERNEL);
+	int q, res = 0;
+	struct sta_info *sta;
+
+	if (!buf)
+		return 0;
+
+	mutex_lock(&local->sta_mtx);
+	for (q = 0; q < STA_HASH_SIZE; q++) {
+		int cnt = 0;
+		sta = local->sta_hash[q];
+		while (sta) {
+			cnt++;
+			sta = sta->hnext;
+		}
+		if (cnt) {
+			res += sprintf(buf + res, "%i: %i\n", q, cnt);
+			if (res >= (STA_HASH_SIZE * 10)) {
+				res = STA_HASH_SIZE * 10;
+				break;
+			}
+		}
+	}
+	mutex_unlock(&local->sta_mtx);
+
+	q = simple_read_from_buffer(user_buf, count, ppos, buf, res);
+	kfree(buf);
+	return q;
+}
+
 DEBUGFS_READONLY_FILE_OPS(hwflags);
 DEBUGFS_READONLY_FILE_OPS(queues);
+DEBUGFS_READONLY_FILE_OPS(sta_hash);
 
 /* statistics stuff */
 
@@ -247,6 +283,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(total_ps_buffered);
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(queues);
+	DEBUGFS_ADD(sta_hash);
 #ifdef CONFIG_PM
 	DEBUGFS_ADD_MODE(reset, 0200);
 #endif
-- 
1.7.3.4

