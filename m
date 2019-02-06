Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE8FC169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 09:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 824CB20844
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 09:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfBFJH2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 04:07:28 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:51502 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbfBFJH2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 04:07:28 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1grJAy-0007z0-FH; Wed, 06 Feb 2019 10:07:24 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jouni Malinen <j@w1.fi>, Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] rhashtable: make walk safe from softirq context
Date:   Wed,  6 Feb 2019 10:07:21 +0100
Message-Id: <20190206090721.8001-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When an rhashtable walk is done from softirq context, we rightfully
get a lockdep complaint saying that we could get a softirq in the
middle of a rehash, and thus deadlock on &ht->lock. This happened
e.g. in mac80211 as it does a walk in softirq context.

Fix this by using spin_lock_bh() wherever we use the &ht->lock.

Initially, I thought it would be sufficient to do this only in the
rehash (rhashtable_rehash_table), but I changed my mind:
 * the caller doesn't really need to disable softirqs across all
   of the rhashtable_walk_* functions, only those parts that they
   actually do within the lock need it
 * maybe more importantly, it would still lead to massive lockdep
   complaints - false positives, but hard to fix - because lockdep
   wouldn't know about different ht->lock instances, and thus one
   user of the code doing a walk w/o any locking (when it only ever
   uses process context this is fine) vs. another user like in wifi
   where we noticed this problem would still cause it to complain.

Cc: stable@vger.kernel.org
Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 lib/rhashtable.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 852ffa5160f1..30d14f8d9985 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -327,10 +327,10 @@ static int rhashtable_rehash_table(struct rhashtable *ht)
 	/* Publish the new table pointer. */
 	rcu_assign_pointer(ht->tbl, new_tbl);
 
-	spin_lock(&ht->lock);
+	spin_lock_bh(&ht->lock);
 	list_for_each_entry(walker, &old_tbl->walkers, list)
 		walker->tbl = NULL;
-	spin_unlock(&ht->lock);
+	spin_unlock_bh(&ht->lock);
 
 	/* Wait for readers. All new readers will see the new
 	 * table, and thus no references to the old table will
@@ -670,11 +670,11 @@ void rhashtable_walk_enter(struct rhashtable *ht, struct rhashtable_iter *iter)
 	iter->skip = 0;
 	iter->end_of_table = 0;
 
-	spin_lock(&ht->lock);
+	spin_lock_bh(&ht->lock);
 	iter->walker.tbl =
 		rcu_dereference_protected(ht->tbl, lockdep_is_held(&ht->lock));
 	list_add(&iter->walker.list, &iter->walker.tbl->walkers);
-	spin_unlock(&ht->lock);
+	spin_unlock_bh(&ht->lock);
 }
 EXPORT_SYMBOL_GPL(rhashtable_walk_enter);
 
@@ -686,10 +686,10 @@ EXPORT_SYMBOL_GPL(rhashtable_walk_enter);
  */
 void rhashtable_walk_exit(struct rhashtable_iter *iter)
 {
-	spin_lock(&iter->ht->lock);
+	spin_lock_bh(&iter->ht->lock);
 	if (iter->walker.tbl)
 		list_del(&iter->walker.list);
-	spin_unlock(&iter->ht->lock);
+	spin_unlock_bh(&iter->ht->lock);
 }
 EXPORT_SYMBOL_GPL(rhashtable_walk_exit);
 
@@ -719,10 +719,10 @@ int rhashtable_walk_start_check(struct rhashtable_iter *iter)
 
 	rcu_read_lock();
 
-	spin_lock(&ht->lock);
+	spin_lock_bh(&ht->lock);
 	if (iter->walker.tbl)
 		list_del(&iter->walker.list);
-	spin_unlock(&ht->lock);
+	spin_unlock_bh(&ht->lock);
 
 	if (iter->end_of_table)
 		return 0;
@@ -938,12 +938,12 @@ void rhashtable_walk_stop(struct rhashtable_iter *iter)
 
 	ht = iter->ht;
 
-	spin_lock(&ht->lock);
+	spin_lock_bh(&ht->lock);
 	if (tbl->rehash < tbl->size)
 		list_add(&iter->walker.list, &tbl->walkers);
 	else
 		iter->walker.tbl = NULL;
-	spin_unlock(&ht->lock);
+	spin_unlock_bh(&ht->lock);
 
 out:
 	rcu_read_unlock();
-- 
2.17.2

