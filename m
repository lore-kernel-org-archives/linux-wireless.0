Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36137 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdA0TfJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 14:35:09 -0500
Date: Fri, 27 Jan 2017 22:26:06 +0300
From: Pichugin Dmitry <smokeman85@gmail.com>
To: johannes@sipsolutions.net, davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cfg80211 debugfs: Cleanup some checkpatch issues
Message-ID: <20170127192603.GA13522@gmail.com> (sfid-20170127_203712_578214_221D21FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the checkpatch.pl warnings:
* Macros should not use a trailing semicolon.
* Spaces required around that '='.
* Symbolic permissions 'S_IRUGO' are not preferred.
* Macro argument reuse 'buflen' - possible side-effects

Signed-off-by: Pichugin Dmitry <smokeman85@gmail.com>
---
 net/wireless/debugfs.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 5d45391..96e3cff 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -17,11 +17,12 @@
 static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 			    size_t count, loff_t *ppos)			\
 {									\
-	struct wiphy *wiphy= file->private_data;		\
-	char buf[buflen];						\
+	struct wiphy *wiphy = file->private_data;			\
+	int __buflen = __builtin_constant_p(buflen) ? buflen : -1;	\
+	char buf[__buflen];						\
 	int res;							\
 									\
-	res = scnprintf(buf, buflen, fmt "\n", ##value);		\
+	res = scnprintf(buf, __buflen, fmt "\n", ##value);		\
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
 }									\
 									\
@@ -29,14 +30,14 @@ static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
 	.open = simple_open,						\
 	.llseek = generic_file_llseek,					\
-};
+}
 
 DEBUGFS_READONLY_FILE(rts_threshold, 20, "%d",
-		      wiphy->rts_threshold)
+		      wiphy->rts_threshold);
 DEBUGFS_READONLY_FILE(fragmentation_threshold, 20, "%d",
 		      wiphy->frag_threshold);
 DEBUGFS_READONLY_FILE(short_retry_limit, 20, "%d",
-		      wiphy->retry_short)
+		      wiphy->retry_short);
 DEBUGFS_READONLY_FILE(long_retry_limit, 20, "%d",
 		      wiphy->retry_long);
 
@@ -103,7 +104,7 @@ static const struct file_operations ht40allow_map_ops = {
 };
 
 #define DEBUGFS_ADD(name)						\
-	debugfs_create_file(#name, S_IRUGO, phyd, &rdev->wiphy, &name## _ops);
+	debugfs_create_file(#name, 0444, phyd, &rdev->wiphy, &name## _ops)
 
 void cfg80211_debugfs_rdev_add(struct cfg80211_registered_device *rdev)
 {
-- 
2.7.4
