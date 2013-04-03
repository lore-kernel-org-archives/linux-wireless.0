Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58859 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759561Ab3DCQsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 12:48:54 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 2/2] mac80211:  Add vhash to debugfs.
Date: Wed,  3 Apr 2013 09:48:18 -0700
Message-Id: <1365007698-25295-2-git-send-email-greearb@candelatech.com> (sfid-20130403_184903_358954_3343352E)
In-Reply-To: <1365007698-25295-1-git-send-email-greearb@candelatech.com>
References: <1365007698-25295-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 2bbe377... b89b885... M	net/mac80211/debugfs.c
 net/mac80211/debugfs.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 2bbe377..b89b885 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -210,9 +210,45 @@ static ssize_t sta_hash_read(struct file *file, char __user *user_buf,
 	return q;
 }
 
+static ssize_t sta_lhash_read(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
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
+		sta = local->sta_vhash[q];
+		while (sta) {
+			cnt++;
+			sta = sta->vnext;
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
 DEBUGFS_READONLY_FILE_OPS(sta_hash);
+DEBUGFS_READONLY_FILE_OPS(sta_lhash);
 
 /* statistics stuff */
 
@@ -282,6 +318,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(queues);
 	DEBUGFS_ADD(sta_hash);
+	DEBUGFS_ADD(sta_lhash);
 #ifdef CONFIG_PM
 	DEBUGFS_ADD_MODE(reset, 0200);
 #endif
-- 
1.7.3.4

