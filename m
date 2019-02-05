Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40F1C282D7
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 14:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8989F206DD
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 14:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbfBEOhP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 09:37:15 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:36182 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726533AbfBEOhP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 09:37:15 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gr1qZ-00078Q-DU; Tue, 05 Feb 2019 15:37:11 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jouni Malinen <j@w1.fi>, Thomas Graf <tgraf@suug.ch>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] rhashtable: use irq-safe spinlock in rhashtable_rehash_table()
Date:   Tue,  5 Feb 2019 15:37:06 +0100
Message-Id: <20190205143706.28371-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

When an rhashtabl walk is done from irq/bh context, we rightfully
get a lockdep complaint saying that we could get a (soft-)IRQ in
the middle of a rehash. This happened e.g. in mac80211 as it does
a walk in soft-irq context.

Fix this by using irq-safe locking here. We don't need _irqsave()
as we know this will be called only in process context from the
workqueue. We could get away with _bh() but that seems a bit less
generic, though I'm not sure anyone would want to do a walk from
a real IRQ handler.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 lib/rhashtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 852ffa5160f1..ad3c1da15475 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -327,10 +327,10 @@ static int rhashtable_rehash_table(struct rhashtable *ht)
 	/* Publish the new table pointer. */
 	rcu_assign_pointer(ht->tbl, new_tbl);
 
-	spin_lock(&ht->lock);
+	spin_lock_irq(&ht->lock);
 	list_for_each_entry(walker, &old_tbl->walkers, list)
 		walker->tbl = NULL;
-	spin_unlock(&ht->lock);
+	spin_unlock_irq(&ht->lock);
 
 	/* Wait for readers. All new readers will see the new
 	 * table, and thus no references to the old table will
-- 
2.17.2

