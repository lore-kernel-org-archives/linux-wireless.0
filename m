Return-Path: <SRS0=UQ4x=7K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD27C433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 19:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E135F2074B
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 19:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406646AbgE1TfJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 May 2020 15:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406369AbgE1Tey (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 May 2020 15:34:54 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF93C08C5C6
        for <linux-wireless@vger.kernel.org>; Thu, 28 May 2020 12:34:54 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jeOIm-0054OL-HD; Thu, 28 May 2020 21:34:52 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 01/24] nl80211: really allow client-only BIGTK support
Date:   Thu, 28 May 2020 21:34:24 +0200
Message-Id: <20200528213443.993f108e96ca.I0086ae42d672379380d04ac5effb2f3d5135731b@changeid>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

My previous commit here was wrong, it didn't check the new
flag in two necessary places, so things didn't work. Fix that.

Fixes: 155d7c733807 ("nl80211: allow client-only BIGTK support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/sme.c  | 7 +++++--
 net/wireless/util.c | 4 +++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 3554c0d951f4..15595cf401de 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -5,7 +5,7 @@
  * (for nl80211's connect() and wext)
  *
  * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
- * Copyright (C) 2009   Intel Corporation. All rights reserved.
+ * Copyright (C) 2009, 2020 Intel Corporation. All rights reserved.
  * Copyright 2017	Intel Deutschland GmbH
  */
 
@@ -1118,7 +1118,10 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 
 		if (wiphy_ext_feature_isset(
 			    wdev->wiphy,
-			    NL80211_EXT_FEATURE_BEACON_PROTECTION))
+			    NL80211_EXT_FEATURE_BEACON_PROTECTION) ||
+		    wiphy_ext_feature_isset(
+			    wdev->wiphy,
+			    NL80211_EXT_FEATURE_BEACON_PROTECTION_CLIENT))
 			max_key_idx = 7;
 		for (i = 0; i <= max_key_idx; i++)
 			rdev_del_key(rdev, dev, i, false, NULL);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index df75e58eca5d..92585334b723 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -240,7 +240,9 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 	int max_key_idx = 5;
 
 	if (wiphy_ext_feature_isset(&rdev->wiphy,
-				    NL80211_EXT_FEATURE_BEACON_PROTECTION))
+				    NL80211_EXT_FEATURE_BEACON_PROTECTION) ||
+	    wiphy_ext_feature_isset(&rdev->wiphy,
+				    NL80211_EXT_FEATURE_BEACON_PROTECTION_CLIENT))
 		max_key_idx = 7;
 	if (key_idx < 0 || key_idx > max_key_idx)
 		return -EINVAL;
-- 
2.26.2

