Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 611A7C10F04
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 14:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3136F2229F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 14:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732780AbfBNODc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 09:03:32 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:39746 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728083AbfBNODc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 09:03:32 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1guHbp-000377-NU; Thu, 14 Feb 2019 22:03:25 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1guHbp-0000Nx-GQ; Thu, 14 Feb 2019 22:03:25 +0800
Subject: [PATCH 2/4] mac80211: Free mpath object when rhashtable insertion fails
References: <20190214140236.omt74prxhkfaasue@gondor.apana.org.au>
To:     David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, johannes.berg@intel.com,
        Julia Lawall <julia.lawall@lip6.fr>
Message-Id: <E1guHbp-0000Nx-GQ@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu, 14 Feb 2019 22:03:25 +0800
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When rhashtable insertion fails the mesh table code doesn't free
the now-orphan mesh path object.  This patch fixes that.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 net/mac80211/mesh_pathtbl.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 884a0d212e8b..c3a7396fb955 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -436,17 +436,15 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 	} while (unlikely(ret == -EEXIST && !mpath));
 	spin_unlock_bh(&tbl->walk_lock);
 
-	if (ret && ret != -EEXIST)
-		return ERR_PTR(ret);
-
-	/* At this point either new_mpath was added, or we found a
-	 * matching entry already in the table; in the latter case
-	 * free the unnecessary new entry.
-	 */
-	if (ret == -EEXIST) {
+	if (ret) {
 		kfree(new_mpath);
+
+		if (ret != -EEXIST)
+			return ERR_PTR(ret);
+
 		new_mpath = mpath;
 	}
+
 	sdata->u.mesh.mesh_paths_generation++;
 	return new_mpath;
 }
@@ -481,6 +479,9 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		hlist_add_head_rcu(&new_mpath->walk_list, &tbl->walk_head);
 	spin_unlock_bh(&tbl->walk_lock);
 
+	if (ret)
+		kfree(new_mpath);
+
 	sdata->u.mesh.mpp_paths_generation++;
 	return ret;
 }
