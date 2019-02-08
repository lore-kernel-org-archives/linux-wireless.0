Return-Path: <SRS0=Ms0V=QP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001E4C282CC
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC2B320869
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Feb 2019 13:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfBHNYW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Feb 2019 08:24:22 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:48868 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbfBHNYV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Feb 2019 08:24:21 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gs60Q-0008Jb-6z; Fri, 08 Feb 2019 14:15:46 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH v8 13/15] cfg80211: fix memory leak of new_ie
Date:   Fri,  8 Feb 2019 14:15:37 +0100
Message-Id: <20190208131539.6813-13-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190208131539.6813-1-johannes@sipsolutions.net>
References: <20190208131539.6813-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

new_ie is used as a temporary storage for the generation of
the new elements. However, after copying from it the memory
wasn't freed and leaked. Free it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 46ecb10e85fb..287518c6caa4 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1576,10 +1576,8 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
 	if (!new_ie)
 		return;
 	new_ies = kzalloc(sizeof(*new_ies) + new_ie_len, gfp);
-	if (!new_ies) {
-		kfree(new_ie);
-		return;
-	}
+	if (!new_ies)
+		goto out_free;
 
 	pos = new_ie;
 
@@ -1613,6 +1611,9 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
 		if (old)
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
 	}
+
+out_free:
+	kfree(new_ie);
 }
 
 /* cfg80211_inform_bss_width_frame helper */
-- 
2.17.2

