Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 462C6C282C2
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 11:48:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EE6D218CD
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 11:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbfAYLsd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 06:48:33 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:55806 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbfAYLsc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 06:48:32 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gmzyI-0007S0-Mm; Fri, 25 Jan 2019 12:48:30 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH 06/12] cfg80211: properly free nontransmitted list on all paths
Date:   Fri, 25 Jan 2019 12:48:19 +0100
Message-Id: <20190125114825.5872-6-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190125114825.5872-1-johannes@sipsolutions.net>
References: <20190125114825.5872-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

Free the list inside __cfg80211_unlink_bss and not in
cfg80211_unlink_bss, since not all paths call the later.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 40 +++++++++++++++++++++++++---------------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 1e95b46e84e2..1f5535ec4b01 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -152,6 +152,9 @@ static inline void bss_ref_put(struct cfg80211_registered_device *rdev,
 static bool __cfg80211_unlink_bss(struct cfg80211_registered_device *rdev,
 				  struct cfg80211_internal_bss *bss)
 {
+	struct cfg80211_bss *nontrans_bss, *tmp;
+	struct cfg80211_internal_bss *tmp1;
+
 	lockdep_assert_held(&rdev->bss_lock);
 
 	if (!list_empty(&bss->hidden_list)) {
@@ -168,8 +171,26 @@ static bool __cfg80211_unlink_bss(struct cfg80211_registered_device *rdev,
 		list_del_init(&bss->hidden_list);
 	}
 
-	list_del_init(&bss->list);
+	/*
+	 * If the deleted entry is a non-transmitting BSS, just remove it
+	 * from the list.
+	 * if it is the transmitting BSS - free the entire list.
+	 */
+	if (!bss->pub.transmitted_bss &&
+	    !list_empty(&bss->pub.nontrans_list)) {
+		list_for_each_entry_safe(nontrans_bss, tmp,
+					 &bss->pub.nontrans_list,
+					 nontrans_list) {
+			tmp1 = container_of(nontrans_bss,
+					    struct cfg80211_internal_bss, pub);
+			if (__cfg80211_unlink_bss(rdev, tmp1))
+				rdev->bss_generation++;
+		}
+	}
 	list_del_init(&bss->pub.nontrans_list);
+
+	list_del_init(&bss->list);
+
 	rb_erase(&bss->rbn, &rdev->bss_tree);
 	rdev->bss_entries--;
 	WARN_ONCE((rdev->bss_entries == 0) ^ list_empty(&rdev->bss_list),
@@ -1787,8 +1808,7 @@ EXPORT_SYMBOL(cfg80211_put_bss);
 void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
-	struct cfg80211_internal_bss *bss, *tmp1;
-	struct cfg80211_bss *nontrans_bss, *tmp;
+	struct cfg80211_internal_bss *bss;
 
 	if (WARN_ON(!pub))
 		return;
@@ -1796,21 +1816,11 @@ void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 	bss = container_of(pub, struct cfg80211_internal_bss, pub);
 
 	spin_lock_bh(&rdev->bss_lock);
-	if (list_empty(&bss->list))
-		goto out;
 
-	list_for_each_entry_safe(nontrans_bss, tmp,
-				 &pub->nontrans_list,
-				 nontrans_list) {
-		tmp1 = container_of(nontrans_bss,
-				    struct cfg80211_internal_bss, pub);
-		if (__cfg80211_unlink_bss(rdev, tmp1))
+	if (!list_empty(&bss->list))
+		if (__cfg80211_unlink_bss(rdev, bss))
 			rdev->bss_generation++;
-	}
 
-	if (__cfg80211_unlink_bss(rdev, bss))
-		rdev->bss_generation++;
-out:
 	spin_unlock_bh(&rdev->bss_lock);
 }
 EXPORT_SYMBOL(cfg80211_unlink_bss);
-- 
2.17.2

