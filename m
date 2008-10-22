Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43405 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbYJVXln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 19:41:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: correct warnings in minstrel rate control algorithm
Date: Wed, 22 Oct 2008 19:41:34 -0400
Message-Id: <1224718894-25861-1-git-send-email-linville@tuxdriver.com> (sfid-20081023_014146_340361_0F53A941)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/rc80211_minstrel_debugfs.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index 0b024cd..98f4807 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -94,8 +94,8 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 				prob / 10, prob % 10,
 				mr->last_success,
 				mr->last_attempts,
-				mr->succ_hist,
-				mr->att_hist);
+				(unsigned long long)mr->succ_hist,
+				(unsigned long long)mr->att_hist);
 	}
 	p += sprintf(p, "\nTotal packet count::    ideal %d      "
 			"lookaround %d\n\n",
@@ -106,7 +106,7 @@ minstrel_stats_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int
+static ssize_t
 minstrel_stats_read(struct file *file, char __user *buf, size_t len, loff_t *o)
 {
 	struct minstrel_stats_info *ms;
-- 
1.5.5.1

