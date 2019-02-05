Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0872C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 20:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5FCB2073D
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 20:22:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbfBEUWz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 15:22:55 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:41016 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbfBEUWy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 15:22:54 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gr7F6-0006ta-CB; Tue, 05 Feb 2019 21:22:52 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] mac80211: mesh: do mesh rhashtable walks with BHs disabled
Date:   Tue,  5 Feb 2019 21:22:49 +0100
Message-Id: <20190205202249.10439-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Since we do some walks from *within* softirq context and the
rhashtable code just uses a plain spin_lock(), we need to
disable softirqs for other walks that are not within softirq
context to avoid a potential deadlock (taking a softirq that
takes the spinlock while inside the spinlock from regular
process context.)

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_pathtbl.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index a5125624a76d..f235a05b8226 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -574,9 +574,11 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 	struct rhashtable_iter iter;
 	int ret;
 
+	local_bh_disable();
+
 	ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_ATOMIC);
 	if (ret)
-		return;
+		goto out;
 
 	rhashtable_walk_start(&iter);
 
@@ -592,6 +594,8 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 
 	rhashtable_walk_stop(&iter);
 	rhashtable_walk_exit(&iter);
+out:
+	local_bh_enable();
 }
 
 static void mpp_flush_by_proxy(struct ieee80211_sub_if_data *sdata,
@@ -602,9 +606,10 @@ static void mpp_flush_by_proxy(struct ieee80211_sub_if_data *sdata,
 	struct rhashtable_iter iter;
 	int ret;
 
+	local_bh_disable();
 	ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_ATOMIC);
 	if (ret)
-		return;
+		goto out;
 
 	rhashtable_walk_start(&iter);
 
@@ -620,6 +625,8 @@ static void mpp_flush_by_proxy(struct ieee80211_sub_if_data *sdata,
 
 	rhashtable_walk_stop(&iter);
 	rhashtable_walk_exit(&iter);
+out:
+	local_bh_enable();
 }
 
 static void table_flush_by_iface(struct mesh_table *tbl)
@@ -628,9 +635,10 @@ static void table_flush_by_iface(struct mesh_table *tbl)
 	struct rhashtable_iter iter;
 	int ret;
 
+	local_bh_disable();
 	ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_ATOMIC);
 	if (ret)
-		return;
+		goto out;
 
 	rhashtable_walk_start(&iter);
 
@@ -644,6 +652,8 @@ static void table_flush_by_iface(struct mesh_table *tbl)
 
 	rhashtable_walk_stop(&iter);
 	rhashtable_walk_exit(&iter);
+out:
+	local_bh_enable();
 }
 
 /**
@@ -857,9 +867,10 @@ void mesh_path_tbl_expire(struct ieee80211_sub_if_data *sdata,
 	struct rhashtable_iter iter;
 	int ret;
 
+	local_bh_disable();
 	ret = rhashtable_walk_init(&tbl->rhead, &iter, GFP_KERNEL);
 	if (ret)
-		return;
+		goto out;
 
 	rhashtable_walk_start(&iter);
 
@@ -876,6 +887,8 @@ void mesh_path_tbl_expire(struct ieee80211_sub_if_data *sdata,
 
 	rhashtable_walk_stop(&iter);
 	rhashtable_walk_exit(&iter);
+out:
+	local_bh_enable();
 }
 
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
-- 
2.17.2

