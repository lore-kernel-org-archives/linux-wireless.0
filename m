Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39200 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503Ab2AUNoo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 08:44:44 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: add __cancel_delayed_work()
Date: Sat, 21 Jan 2012 14:44:35 +0100
Message-Id: <1327153475-28081-1-git-send-email-hauke@hauke-m.de> (sfid-20120121_144446_886897_97C1C5C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

__cancel_delayed_work is needed by include/net/bluetooth/l2cap.h and
not available in old kernel versions. This was just copied from the
kernel.

This should also go into compat-wireless-stable-3.3.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.31.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-2.6.31.h b/include/linux/compat-2.6.31.h
index 25db973..a1244cb 100644
--- a/include/linux/compat-2.6.31.h
+++ b/include/linux/compat-2.6.31.h
@@ -215,6 +215,20 @@ extern long long atomic64_add_return(long long a, atomic64_t *v);
 
 #endif
 
+/*
+ * Like above, but uses del_timer() instead of del_timer_sync(). This means,
+ * if it returns 0 the timer function may be running and the queueing is in
+ * progress.
+ */
+static inline bool __cancel_delayed_work(struct delayed_work *work)
+{
+	bool ret;
+
+	ret = del_timer(&work->timer);
+	if (ret)
+		work_clear_pending(&work->work);
+	return ret;
+}
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) */
 
-- 
1.7.5.4

