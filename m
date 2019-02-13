Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10212C4151A
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 14:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4F052190A
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 14:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392323AbfBMOjS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 09:39:18 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:33714 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390752AbfBMOjS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 09:39:18 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gtvgu-0007Cw-D1; Wed, 13 Feb 2019 22:39:12 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gtvgu-0006bT-4G; Wed, 13 Feb 2019 22:39:12 +0800
Subject: [PATCH 2/4] mac80211: Free mpath object when rhashtable insertion fails
References: <20190213143853.labj6zdcsoupkris@gondor.apana.org.au>
To:     David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, johannes.berg@intel.com
Message-Id: <E1gtvgu-0006bT-4G@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed, 13 Feb 2019 22:39:12 +0800
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When rhashtable insertion fails the mesh table code doesn't free
the now-orphan mesh path object.  This patch fixes that.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 net/mac80211/mesh_pathtbl.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 884a0d212e8b..db5a1aef22db 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -436,17 +436,18 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	} while (unlikely(ret == -EEXIST && !mpath));
 	spin_unlock_bh(&tbl->walk_lock);
 
-	if (ret && ret != -EEXIST)
+	if (ret)
+		kfree(new_mpath);
+
+	if (ret != -EEXIST)
 		return ERR_PTR(ret);
 
 	/* At this point either new_mpath was added, or we found a
 	 * matching entry already in the table; in the latter case
 	 * free the unnecessary new entry.
 	 */
-	if (ret == -EEXIST) {
-		kfree(new_mpath);
+	if (ret == -EEXIST)
 		new_mpath = mpath;
-	}
 	sdata->u.mesh.mesh_paths_generation++;
 	return new_mpath;
 }
@@ -481,6 +482,9 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		hlist_add_head_rcu(&new_mpath->walk_list, &tbl->walk_head);
 	spin_unlock_bh(&tbl->walk_lock);
 
+	if (ret)
+		kfree(new_mpath);
+
 	sdata->u.mesh.mpp_paths_generation++;
 	return ret;
 }
