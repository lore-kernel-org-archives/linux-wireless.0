Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD953C282CA
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 05:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86769222BA
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 05:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfBMFQY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 00:16:24 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:57668 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfBMFQY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 00:16:24 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gtmuB-0005Dv-CN; Wed, 13 Feb 2019 13:16:19 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gtmu6-0001Vl-O7; Wed, 13 Feb 2019 13:16:14 +0800
Subject: [PATCH 2/2] mac80211: Free mpath object when rhashtable insertion fails
References: <20190213050551.x3jffq3ipghw6g2m@gondor.apana.org.au>
To:     David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, johannes.berg@intel.com
Message-Id: <E1gtmu6-0001Vl-O7@gondobar>
From:   Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed, 13 Feb 2019 13:16:14 +0800
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When rhashtable insertion fails the mesh table code doesn't free
the now-orphan mesh path object.  This patch fixes that.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 net/mac80211/mesh_pathtbl.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 984ed433a8bc..93fdd9a7d72c 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -432,17 +432,18 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 			hlist_add_head(&new_mpath->walk_list, &tbl->walk_head);
 	} while (unlikely(ret == -EEXIST && !mpath));
 
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
@@ -473,6 +474,8 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 					    mesh_rht_params);
 	if (!ret)
 		hlist_add_head(&new_mpath->walk_list, &tbl->walk_head);
+	else
+		kfree(new_mpath);
 
 	sdata->u.mesh.mpp_paths_generation++;
 	return ret;
