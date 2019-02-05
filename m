Return-Path: <SRS0=RZRw=QM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7408C282CB
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 19:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C24922080F
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Feb 2019 19:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbfBETxp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Feb 2019 14:53:45 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:40734 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728644AbfBETxo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Feb 2019 14:53:44 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gr6ms-0006Ga-0R; Tue, 05 Feb 2019 20:53:42 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: mesh: do mesh rhashtable walks with BHs disabled
Date:   Tue,  5 Feb 2019 20:53:39 +0100
Message-Id: <20190205195339.7585-1-johannes@sipsolutions.net>
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
 net/mac80211/mesh_pathtbl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index a5125624a76d..f1912afd03dd 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -880,8 +880,11 @@ void mesh_path_tbl_expire(struct ieee80211_sub_if_data *sdata,
 
 void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
 {
+	/* we do other walks inside softirq, so need to disable them here */
+	local_bh_disable();
 	mesh_path_tbl_expire(sdata, sdata->u.mesh.mesh_paths);
 	mesh_path_tbl_expire(sdata, sdata->u.mesh.mpp_paths);
+	local_bh_enable();
 }
 
 void mesh_pathtbl_unregister(struct ieee80211_sub_if_data *sdata)
-- 
2.17.2

