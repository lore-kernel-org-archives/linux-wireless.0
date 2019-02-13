Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAEA0C282CE
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 05:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A30B5222C7
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 05:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfBMFZd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 00:25:33 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:57776 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbfBMFZc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 00:25:32 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gtn32-0005Kt-AI; Wed, 13 Feb 2019 13:25:28 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gtn2v-0001lp-Jp; Wed, 13 Feb 2019 13:25:21 +0800
Date:   Wed, 13 Feb 2019 13:25:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch, johannes.berg@intel.com
Subject: [PATCH] mac80211: Use rhashtable_lookup_get_insert_fast instead of
 racy code
Message-ID: <20190213052521.htpq2a7imvwpyblh@gondor.apana.org.au>
References: <20190213050551.x3jffq3ipghw6g2m@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190213050551.x3jffq3ipghw6g2m@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 13, 2019 at 01:05:51PM +0800, Herbert Xu wrote:
> Hi:
> 
> This patch fixes a number of issues with the use of the rhashtable API
> in mac80211.  First of all it converts the use of rashtable walks over
> to a simple linked list.  This is because an rhashtable walk is
> inherently unstable and not meant for uses that require stability,
> e.g., when you're trying to lookup an object to delete.
> 
> It also fixes a potential memory leak when the rhashtable insertion
> fails (which can occur due to OOM).

On top these two fixes here is one more clean-up patch to use an
existing rhashtable API instead of rolling its own racy version:

---8<---
The code in mesh_path_add tries to handle the case where a duplicate
entry is added to the rhashtable by doing a lookup after a failed
insertion.  It also tries to handle races by repeating the insertion
should the lookup fail.

This is now unnecessary as we have rhashtable API functions that can
directly return the mathcing object.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 93fdd9a7d72c..b06f066bfa01 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -402,7 +402,6 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 {
 	struct mesh_table *tbl;
 	struct mesh_path *mpath, *new_mpath;
-	int ret;
 
 	if (ether_addr_equal(dst, sdata->vif.addr))
 		/* never add ourselves as neighbours */
@@ -419,31 +418,21 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 		return ERR_PTR(-ENOMEM);
 
 	tbl = sdata->u.mesh.mesh_paths;
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
-
-	if (ret)
+	mpath = rhashtable_lookup_get_insert_fast(&tbl->rhead,
+						  &new_mpath->rhash,
+						  mesh_rht_params);
+	if (!mpath)
+		hlist_add_head(&new_mpath->walk_list, &tbl->walk_head);
+
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
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
