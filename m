Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397FDC10F01
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 10:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13040214DA
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 10:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729419AbfBRK3g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 05:29:36 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:52978 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbfBRK3f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 05:29:35 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gvgB3-0001uj-9j; Mon, 18 Feb 2019 11:29:33 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH net] mac80211: mesh: fix missing unlock on error in table_path_del()
Date:   Mon, 18 Feb 2019 11:29:29 +0100
Message-Id: <20190218102929.22276-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

spin_lock_bh() is used in table_path_del() but rcu_read_unlock()
is used for unlocking. Fix it by using spin_unlock_bh() instead
of rcu_read_unlock() in the error handling case.

Fixes: b4c3fbe63601 ("mac80211: Use linked list instead of rhashtable walk for mesh tables")
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Dave, can you take this directly? I see little value in sending a
pull request for this one patch (but if you prefer can do so.)
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index c3a7396fb955..88a6d5e18ccc 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -627,7 +627,7 @@ static int table_path_del(struct mesh_table *tbl,
 	spin_lock_bh(&tbl->walk_lock);
 	mpath = rhashtable_lookup_fast(&tbl->rhead, addr, mesh_rht_params);
 	if (!mpath) {
-		rcu_read_unlock();
+		spin_unlock_bh(&tbl->walk_lock);
 		return -ENXIO;
 	}
 
-- 
2.17.2

