Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59498 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbeHUPXU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 11:23:20 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] workqueue: create lockdep dependency in flush_work()
Date: Tue, 21 Aug 2018 14:03:17 +0200
Message-Id: <20180821120317.4115-3-johannes@sipsolutions.net> (sfid-20180821_140330_094925_D662ADF1)
In-Reply-To: <20180821120317.4115-1-johannes@sipsolutions.net>
References: <20180821120317.4115-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In flush_work(), we need to create a lockdep dependency so that
the following scenario is appropriately tagged as a problem:

  work_function()
  {
    mutex_lock(&mutex);
    ...
  }

  other_function()
  {
    mutex_lock(&mutex);
    flush_work(&work); // or cancel_work_sync(&work);
  }

This is a problem since the work might be running and be blocked
on trying to acquire the mutex.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 kernel/workqueue.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a6c2b823f348..29d4d84ba512 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2852,6 +2852,11 @@ static bool start_flush_work(struct work_struct *work, struct wq_barrier *barr,
 
 	might_sleep();
 
+	if (!from_cancel) {
+		lock_map_acquire(&work->lockdep_map);
+		lock_map_release(&work->lockdep_map);
+	}
+
 	local_irq_disable();
 	pool = get_work_pool(work);
 	if (!pool) {
-- 
2.14.4
