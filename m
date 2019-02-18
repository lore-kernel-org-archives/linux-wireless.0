Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA7DDC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 06:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C4402184E
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 06:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbfBRGij (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 01:38:39 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:3660 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726221AbfBRGij (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 01:38:39 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6CF24A5F6D002551B248;
        Mon, 18 Feb 2019 14:38:35 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.408.0; Mon, 18 Feb 2019 14:38:28 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <linux-wireless@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: [PATCH] mac80211: mesh: fix missing unlock on error in table_path_del()
Date:   Mon, 18 Feb 2019 06:52:16 +0000
Message-ID: <20190218065216.155259-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

spin_lock_bh() is used in table_path_del() but rcu_read_unlock()
is used for unlocking. Fix it by using spin_unlock_bh() instead
of rcu_read_unlock() in the error handling case.

Fixes: b4c3fbe63601 ("mac80211: Use linked list instead of rhashtable walk for mesh tables")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index c3a7396fb955..9bdeac2749e9 100644
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



