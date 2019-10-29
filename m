Return-Path: <SRS0=76X5=YW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F68CA9EAE
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Oct 2019 11:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61D4421D56
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Oct 2019 11:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbfJ2L4Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Oct 2019 07:56:16 -0400
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:44169 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbfJ2L4Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Oct 2019 07:56:16 -0400
Received: from localhost.localdomain (unknown [141.24.212.108])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id DD3D8580063;
        Tue, 29 Oct 2019 12:56:14 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH] nl80211: allow more operations for mesh and ad-hoc interfaces
Date:   Tue, 29 Oct 2019 12:56:02 +0100
Message-Id: <20191029115602.78990-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This change allows mesh and ad-hoc interfaces to change beacons and
tx queue settings. The direct change of these settings should be ok
for these kind of interfaces and should maybe only forbidden for
station-like interface types.

Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
---
 net/wireless/nl80211.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d1451e731bb8..c4ff8c2033af 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2923,7 +2923,9 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 
 		if (netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-		    netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		    netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO &&
+		    netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
+		    netdev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC)
 			return -EINVAL;
 
 		if (!netif_running(netdev))
@@ -4831,7 +4833,9 @@ static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
 	int err;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC)
 		return -EOPNOTSUPP;
 
 	if (!rdev->ops->change_beacon)
-- 
2.23.0

