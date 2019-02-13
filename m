Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F30FC282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 14:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 572E520835
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 14:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392345AbfBMOjV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 09:39:21 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:33720 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390752AbfBMOjU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 09:39:20 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gtvgw-0007EE-Hi; Wed, 13 Feb 2019 22:39:14 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gtvgw-0006bn-9h; Wed, 13 Feb 2019 22:39:14 +0800
Subject: [PATCH 4/4] rhashtable: Remove obsolete rhashtable_walk_init function
References: <20190213143853.labj6zdcsoupkris@gondor.apana.org.au>
To:     David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, johannes.berg@intel.com
Message-Id: <E1gtvgw-0006bn-9h@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed, 13 Feb 2019 22:39:14 +0800
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The rhashtable_walk_init function has been obsolete for more than
two years.  This patch finally converts its last users over to
rhashtable_walk_enter and removes it.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/linux/rhashtable.h |    8 --------
 lib/rhashtable.c           |    2 +-
 lib/test_rhashtable.c      |    9 ++-------
 net/ipv6/ila/ila_xlat.c    |   15 +++------------
 net/netlink/af_netlink.c   |   10 +---------
 5 files changed, 7 insertions(+), 37 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 20f9c6af7473..ae9c0f71f311 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -1113,14 +1113,6 @@ static inline int rhashtable_replace_fast(
 	return err;
 }
 
-/* Obsolete function, do not use in new code. */
-static inline int rhashtable_walk_init(struct rhashtable *ht,
-				       struct rhashtable_iter *iter, gfp_t gfp)
-{
-	rhashtable_walk_enter(ht, iter);
-	return 0;
-}
-
 /**
  * rhltable_walk_enter - Initialise an iterator
  * @hlt:	Table to walk over
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 852ffa5160f1..0a105d4af166 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -682,7 +682,7 @@ EXPORT_SYMBOL_GPL(rhashtable_walk_enter);
  * rhashtable_walk_exit - Free an iterator
  * @iter:	Hash table Iterator
  *
- * This function frees resources allocated by rhashtable_walk_init.
+ * This function frees resources allocated by rhashtable_walk_enter.
  */
 void rhashtable_walk_exit(struct rhashtable_iter *iter)
 {
diff --git a/lib/test_rhashtable.c b/lib/test_rhashtable.c
index 6a8ac7626797..d96962eea942 100644
--- a/lib/test_rhashtable.c
+++ b/lib/test_rhashtable.c
@@ -177,16 +177,11 @@ static int __init test_rht_lookup(struct rhashtable *ht, struct test_obj *array,
 
 static void test_bucket_stats(struct rhashtable *ht, unsigned int entries)
 {
-	unsigned int err, total = 0, chain_len = 0;
+	unsigned int total = 0, chain_len = 0;
 	struct rhashtable_iter hti;
 	struct rhash_head *pos;
 
-	err = rhashtable_walk_init(ht, &hti, GFP_KERNEL);
-	if (err) {
-		pr_warn("Test failed: allocation error");
-		return;
-	}
-
+	rhashtable_walk_enter(ht, &hti);
 	rhashtable_walk_start(&hti);
 
 	while ((pos = rhashtable_walk_next(&hti))) {
diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
index 17c455ff69ff..ae6cd4cef8db 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -385,10 +385,7 @@ int ila_xlat_nl_cmd_flush(struct sk_buff *skb, struct genl_info *info)
 	spinlock_t *lock;
 	int ret;
 
-	ret = rhashtable_walk_init(&ilan->xlat.rhash_table, &iter, GFP_KERNEL);
-	if (ret)
-		goto done;
-
+	rhashtable_walk_enter(&ilan->xlat.rhash_table, &iter);
 	rhashtable_walk_start(&iter);
 
 	for (;;) {
@@ -509,23 +506,17 @@ int ila_xlat_nl_dump_start(struct netlink_callback *cb)
 	struct net *net = sock_net(cb->skb->sk);
 	struct ila_net *ilan = net_generic(net, ila_net_id);
 	struct ila_dump_iter *iter;
-	int ret;
 
 	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
 	if (!iter)
 		return -ENOMEM;
 
-	ret = rhashtable_walk_init(&ilan->xlat.rhash_table, &iter->rhiter,
-				   GFP_KERNEL);
-	if (ret) {
-		kfree(iter);
-		return ret;
-	}
+	rhashtable_walk_enter(&ilan->xlat.rhash_table, &iter->rhiter);
 
 	iter->skip = 0;
 	cb->args[0] = (long)iter;
 
-	return ret;
+	return 0;
 }
 
 int ila_xlat_nl_dump_done(struct netlink_callback *cb)
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 3c023d6120f6..f369cc751cea 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2541,15 +2541,7 @@ struct nl_seq_iter {
 
 static int netlink_walk_start(struct nl_seq_iter *iter)
 {
-	int err;
-
-	err = rhashtable_walk_init(&nl_table[iter->link].hash, &iter->hti,
-				   GFP_KERNEL);
-	if (err) {
-		iter->link = MAX_LINKS;
-		return err;
-	}
-
+	rhashtable_walk_enter(&nl_table[iter->link].hash, &iter->hti);
 	rhashtable_walk_start(&iter->hti);
 
 	return 0;
