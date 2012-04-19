Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:50397 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005Ab2DSMDS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 08:03:18 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH] ath9k: make DFS detector pools SMP safe
Date: Thu, 19 Apr 2012 14:03:04 +0200
Message-Id: <1334836984-5983-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20120419_140322_676001_1D9160A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds locking of the detector's shared pulse and PRI sequence
pools to enable multi-wiphy operation on SMP systems.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/dfs_pri_detector.c |  110 +++++++++++++++------
 1 files changed, 78 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
index 025e88a..ecb6334 100644
--- a/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
+++ b/drivers/net/wireless/ath/ath9k/dfs_pri_detector.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 
 #include "dfs_pattern_detector.h"
 #include "dfs_pri_detector.h"
@@ -94,6 +95,73 @@ static u32 pde_get_multiple(u32 val, u32 fraction, u32 tolerance)
 static u32 singleton_pool_references;
 static LIST_HEAD(pulse_pool);
 static LIST_HEAD(pseq_pool);
+static DEFINE_SPINLOCK(pool_lock);
+
+static void pool_register_ref(void)
+{
+	spin_lock_bh(&pool_lock);
+	singleton_pool_references++;
+	spin_unlock_bh(&pool_lock);
+}
+
+static void pool_deregister_ref(void)
+{
+	spin_lock_bh(&pool_lock);
+	singleton_pool_references--;
+	if (singleton_pool_references == 0) {
+		/* free singleton pools with no references left */
+		struct pri_sequence *ps, *ps0;
+		struct pulse_elem *p, *p0;
+
+		list_for_each_entry_safe(p, p0, &pulse_pool, head) {
+			list_del(&p->head);
+			kfree(p);
+		}
+		list_for_each_entry_safe(ps, ps0, &pseq_pool, head) {
+			list_del(&ps->head);
+			kfree(ps);
+		}
+	}
+	spin_unlock_bh(&pool_lock);
+}
+
+static void pool_put_pulse_elem(struct pulse_elem *pe)
+{
+	spin_lock_bh(&pool_lock);
+	list_add(&pe->head, &pulse_pool);
+	spin_unlock_bh(&pool_lock);
+}
+
+static void pool_put_pseq_elem(struct pri_sequence *pse)
+{
+	spin_lock_bh(&pool_lock);
+	list_add(&pse->head, &pseq_pool);
+	spin_unlock_bh(&pool_lock);
+}
+
+static struct pri_sequence *pool_get_pseq_elem(void)
+{
+	struct pri_sequence *pse = NULL;
+	spin_lock_bh(&pool_lock);
+	if (!list_empty(&pseq_pool)) {
+		pse = list_first_entry(&pseq_pool, struct pri_sequence, head);
+		list_del(&pse->head);
+	}
+	spin_unlock_bh(&pool_lock);
+	return pse;
+}
+
+static struct pulse_elem *pool_get_pulse_elem(void)
+{
+	struct pulse_elem *pe = NULL;
+	spin_lock_bh(&pool_lock);
+	if (!list_empty(&pulse_pool)) {
+		pe = list_first_entry(&pulse_pool, struct pulse_elem, head);
+		list_del(&pe->head);
+	}
+	spin_unlock_bh(&pool_lock);
+	return pe;
+}
 
 static struct pulse_elem *pulse_queue_get_tail(struct pri_detector *pde)
 {
@@ -110,7 +178,7 @@ static bool pulse_queue_dequeue(struct pri_detector *pde)
 		list_del_init(&p->head);
 		pde->count--;
 		/* give it back to pool */
-		list_add(&p->head, &pulse_pool);
+		pool_put_pulse_elem(p);
 	}
 	return (pde->count > 0);
 }
@@ -138,11 +206,8 @@ static void pulse_queue_check_window(struct pri_detector *pde)
 
 static bool pulse_queue_enqueue(struct pri_detector *pde, u64 ts)
 {
-	struct pulse_elem *p;
-	if (!list_empty(&pulse_pool)) {
-		p = list_first_entry(&pulse_pool, struct pulse_elem, head);
-		list_del(&p->head);
-	} else {
+	struct pulse_elem *p = pool_get_pulse_elem();
+	if (p == NULL) {
 		p = kmalloc(sizeof(*p), GFP_KERNEL);
 		if (p == NULL) {
 			pr_err("failed to allocate pulse_elem\n");
@@ -220,12 +285,8 @@ static bool pseq_handler_create_sequences(struct pri_detector *pde,
 
 		/* this is a valid one, add it */
 		ps.deadline_ts = ps.first_ts + ps.dur;
-
-		if (!list_empty(&pseq_pool)) {
-			new_ps = list_first_entry(&pseq_pool,
-						  struct pri_sequence, head);
-			list_del(&new_ps->head);
-		} else {
+		new_ps = pool_get_pseq_elem();
+		if (new_ps == NULL) {
 			new_ps = kmalloc(sizeof(*new_ps), GFP_KERNEL);
 			if (new_ps == NULL)
 				return false;
@@ -250,7 +311,7 @@ pseq_handler_add_to_existing_seqs(struct pri_detector *pde, u64 ts)
 		/* first ensure that sequence is within window */
 		if (ts > ps->deadline_ts) {
 			list_del_init(&ps->head);
-			list_add(&ps->head, &pseq_pool);
+			pool_put_pseq_elem(ps);
 			continue;
 		}
 
@@ -299,11 +360,11 @@ static void pri_detector_reset(struct pri_detector *pde, u64 ts)
 	struct pulse_elem *p, *p0;
 	list_for_each_entry_safe(ps, ps0, &pde->sequences, head) {
 		list_del_init(&ps->head);
-		list_add(&ps->head, &pseq_pool);
+		pool_put_pseq_elem(ps);
 	}
 	list_for_each_entry_safe(p, p0, &pde->pulses, head) {
 		list_del_init(&p->head);
-		list_add(&p->head, &pulse_pool);
+		pool_put_pulse_elem(p);
 	}
 	pde->count = 0;
 	pde->last_ts = ts;
@@ -312,22 +373,7 @@ static void pri_detector_reset(struct pri_detector *pde, u64 ts)
 static void pri_detector_exit(struct pri_detector *de)
 {
 	pri_detector_reset(de, 0);
-
-	singleton_pool_references--;
-	if (singleton_pool_references == 0) {
-		/* free singleton pools with no references left */
-		struct pri_sequence *ps, *ps0;
-		struct pulse_elem *p, *p0;
-
-		list_for_each_entry_safe(p, p0, &pulse_pool, head) {
-			list_del(&p->head);
-			kfree(p);
-		}
-		list_for_each_entry_safe(ps, ps0, &pseq_pool, head) {
-			list_del(&ps->head);
-			kfree(ps);
-		}
-	}
+	pool_deregister_ref();
 	kfree(de);
 }
 
@@ -385,6 +431,6 @@ pri_detector_init(const struct radar_detector_specs *rs)
 	de->max_count = rs->ppb * 2;
 	de->rs = rs;
 
-	singleton_pool_references++;
+	pool_register_ref();
 	return de;
 }
-- 
1.7.4.1

