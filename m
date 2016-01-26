Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38515 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964914AbcAZKe2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 05:34:28 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] rfkill: fix rfkill_fop_read wait_event usage
Date: Tue, 26 Jan 2016 11:34:21 +0100
Message-Id: <1453804461-7787-1-git-send-email-johannes@sipsolutions.net> (sfid-20160126_113432_912051_5D4CC7DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code within wait_event_interruptible() is called with
!TASK_RUNNING, so mustn't call any functions that can sleep,
like mutex_lock().

Since we re-check the list_empty() in a loop after the wait,
it's safe to simply use list_empty() without locking.

This bug has existed forever, but was only discovered now
because all userspace implementations, including the default
'rfkill' tool, use poll() or select() to get a readable fd
before attempting to read.

Cc: stable@vger.kernel.org
Fixes: c64fb01627e24 ("rfkill: create useful userspace interface")
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/rfkill/core.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index f53bf3b6558b..cf5b69ab1829 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1095,17 +1095,6 @@ static unsigned int rfkill_fop_poll(struct file *file, poll_table *wait)
 	return res;
 }
 
-static bool rfkill_readable(struct rfkill_data *data)
-{
-	bool r;
-
-	mutex_lock(&data->mtx);
-	r = !list_empty(&data->events);
-	mutex_unlock(&data->mtx);
-
-	return r;
-}
-
 static ssize_t rfkill_fop_read(struct file *file, char __user *buf,
 			       size_t count, loff_t *pos)
 {
@@ -1122,8 +1111,11 @@ static ssize_t rfkill_fop_read(struct file *file, char __user *buf,
 			goto out;
 		}
 		mutex_unlock(&data->mtx);
+		/* since we re-check and it just compares pointers,
+		 * using !list_empty() without locking isn't a problem
+		 */
 		ret = wait_event_interruptible(data->read_wait,
-					       rfkill_readable(data));
+					       !list_empty(&data->events));
 		mutex_lock(&data->mtx);
 
 		if (ret)
-- 
2.6.2

