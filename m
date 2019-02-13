Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A97C4151A
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 14:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8737520835
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 14:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392340AbfBMOjV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 09:39:21 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:33722 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392327AbfBMOjU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 09:39:20 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gtvgv-0007Dc-E6; Wed, 13 Feb 2019 22:39:13 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gtvgv-0006bd-7B; Wed, 13 Feb 2019 22:39:13 +0800
Subject: [PATCH 3/4] mac80211: Use rhashtable_lookup_get_insert_fast instead of racy code
References: <20190213143853.labj6zdcsoupkris@gondor.apana.org.au>
To:     David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, johannes.berg@intel.com
Message-Id: <E1gtvgv-0006bd-7B@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed, 13 Feb 2019 22:39:13 +0800
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The code in mesh_path_add tries to handle the case where a duplicate
entry is added to the rhashtable by doing a lookup after a failed
insertion.  It also tries to handle races by repeating the insertion
should the lookup fail.

This is now unnecessary as we have rhashtable API functions that can
directly return the mathcing object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 net/mac80211/mesh_pathtbl.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index db5a1aef22db..8902395e406e 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -404,7 +404,6 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 {
 	struct mesh_table *tbl;
 	struct mesh_path *mpath, *new_mpath;
-	int ret;
 
 	if (ether_addr_equal(dst, sdata->vif.addr))
 		/* never add ourselves as neighbours */
@@ -422,32 +421,22 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 
 	tbl = sdata->u.mesh.mesh_paths;
 	spin_lock_bh(&tbl->walk_lock);
-	do {
-		ret = rhashtable_lookup_insert_fast(&tbl->rhead,
-						    &new_mpath->rhash,
-						    mesh_rht_params);
-
-		if (ret == -EEXIST)
-			mpath = rhashtable_lookup_fast(&tbl->rhead,
-						       dst,
-						       mesh_rht_params);
-		else if (!ret)
-			hlist_add_head(&new_mpath->walk_list, &tbl->walk_head);
-	} while (unlikely(ret == -EEXIST && !mpath));
+	mpath = rhashtable_lookup_get_insert_fast(&tbl->rhead,
+						  &new_mpath->rhash,
+						  mesh_rht_params);
+	if (!mpath)
+		hlist_add_head(&new_mpath->walk_list, &tbl->walk_head);
 	spin_unlock_bh(&tbl->walk_lock);
 
-	if (ret)
+	if (mpath) {
 		kfree(new_mpath);
 
-	if (ret != -EEXIST)
-		return ERR_PTR(ret);
+		if (IS_ERR(mpath))
+			return mpath;
 
-	/* At this point either new_mpath was added, or we found a
-	 * matching entry already in the table; in the latter case
-	 * free the unnecessary new entry.
-	 */
-	if (ret == -EEXIST)
 		new_mpath = mpath;
+	}
+
 	sdata->u.mesh.mesh_paths_generation++;
 	return new_mpath;
 }
