Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.181]:34380 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbYDABBl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 21:01:41 -0400
Received: by el-out-1112.google.com with SMTP id v27so701982ele.17
        for <linux-wireless@vger.kernel.org>; Mon, 31 Mar 2008 18:01:41 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Cc: akpm@linux-foundation.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Date: Mon, 31 Mar 2008 15:10:22 -0700
Subject: [PATCH] mac80211: fix deadlocks in debugfs_netdev.c
Message-ID: <47f18973.1498600a.3eb4.ffffbefb@mx.google.com> (sfid-20080401_020146_132504_4AAB59F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The bug shows up with CONFIG_PREEMPT enabled. Pointed out by Andrew Morton.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>
Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/debugfs_netdev.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 107b0fe..7454d0c 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -31,11 +31,13 @@ static ssize_t ieee80211_if_read(
 	ssize_t ret = -EINVAL;
 
 	read_lock(&dev_base_lock);
-	if (sdata->dev->reg_state == NETREG_REGISTERED) {
+	if (sdata->dev->reg_state == NETREG_REGISTERED)
 		ret = (*format)(sdata, buf, sizeof(buf));
-		ret = simple_read_from_buffer(userbuf, count, ppos, buf, ret);
-	}
 	read_unlock(&dev_base_lock);
+
+	if (ret != -EINVAL)
+		ret = simple_read_from_buffer(userbuf, count, ppos, buf, ret);
+
 	return ret;
 }
 
@@ -51,13 +53,13 @@ static ssize_t ieee80211_if_write(
 
 	memset(buf, 0x00, sizeof(buf));
 	buf_size = min(count, (sizeof(buf)-1));
-	read_lock(&dev_base_lock);
 	if (copy_from_user(buf, userbuf, buf_size))
-		goto endwrite;
+		return count;
+	read_lock(&dev_base_lock);
 	if (sdata->dev->reg_state == NETREG_REGISTERED)
 		(*format)(sdata, buf);
-endwrite:
 	read_unlock(&dev_base_lock);
+
 	return count;
 }
 #endif
-- 
1.5.4.3



