Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43600 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab2ISGV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 02:21:27 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: make reset debugfs depend on CONFIG_PM
Date: Wed, 19 Sep 2012 08:22:00 +0200
Message-Id: <1348035720-5254-1-git-send-email-johannes@sipsolutions.net> (sfid-20120919_082131_184009_EC167170)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The suspend/resume code depends on CONFIG_PM, so
the reset debugfs file can only be made available
if that is enabled.

Fengguang Wu's zero-day build testing found this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 97173f8..466f4b4 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -70,6 +70,7 @@ DEBUGFS_READONLY_FILE(wep_iv, "%#08x",
 DEBUGFS_READONLY_FILE(rate_ctrl_alg, "%s",
 	local->rate_ctrl ? local->rate_ctrl->ops->name : "hw/driver");
 
+#ifdef CONFIG_PM
 static ssize_t reset_write(struct file *file, const char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
@@ -88,6 +89,7 @@ static const struct file_operations reset_ops = {
 	.open = simple_open,
 	.llseek = noop_llseek,
 };
+#endif
 
 static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 			    size_t count, loff_t *ppos)
@@ -245,7 +247,9 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(total_ps_buffered);
 	DEBUGFS_ADD(wep_iv);
 	DEBUGFS_ADD(queues);
+#ifdef CONFIG_PM
 	DEBUGFS_ADD_MODE(reset, 0200);
+#endif
 	DEBUGFS_ADD(hwflags);
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
-- 
1.7.10.4

