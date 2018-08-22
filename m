Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53994 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728825AbeHVNNY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 09:13:24 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Byungchul Park <byungchul.park@lge.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 2/2] workqueue: re-add lockdep dependencies for flushing
Date: Wed, 22 Aug 2018 11:49:04 +0200
Message-Id: <20180822094904.15718-3-johannes@sipsolutions.net> (sfid-20180822_114937_589531_261E37A6)
In-Reply-To: <20180822094904.15718-1-johannes@sipsolutions.net>
References: <20180822094904.15718-1-johannes@sipsolutions.net>
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

Similarly, in flush_workqueue().

These were removed after cross-release partially caught these
problems, but now cross-release was reverted anyway. IMHO the
removal was erroneous anyway though, since lockdep should be
able to catch potential problems, not just actual ones, and
cross-release would only have caught the problem when actually
invoking wait_for_completion().

Fixes: fd1a5b04dfb8 ("workqueue: Remove now redundant lock acquisitions wrt. workqueue flushes")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 kernel/workqueue.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a6c2b823f348..60e80198c3df 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2652,6 +2652,9 @@ void flush_workqueue(struct workqueue_struct *wq)
 	if (WARN_ON(!wq_online))
 		return;
 
+	lock_map_acquire(&wq->lockdep_map);
+	lock_map_release(&wq->lockdep_map);
+
 	mutex_lock(&wq->mutex);
 
 	/*
@@ -2905,6 +2908,11 @@ static bool __flush_work(struct work_struct *work, bool from_cancel)
 	if (WARN_ON(!wq_online))
 		return false;
 
+	if (!from_cancel) {
+		lock_map_acquire(&work->lockdep_map);
+		lock_map_release(&work->lockdep_map);
+	}
+
 	if (start_flush_work(work, &barr, from_cancel)) {
 		wait_for_completion(&barr.done);
 		destroy_work_on_stack(&barr.work);
-- 
2.14.4
