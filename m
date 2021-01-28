Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55318C433E6
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Jan 2021 17:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18F5164E10
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Jan 2021 17:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbhA1RhP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Jan 2021 12:37:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbhA1RgU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jan 2021 12:36:20 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94417C061793
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jan 2021 09:35:38 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l5BCh-00CwTh-Ke; Thu, 28 Jan 2021 18:35:36 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        syzbot+d2d412349f88521938aa@syzkaller.appspotmail.com
Subject: [PATCH 2/4] wext: call cfg80211_change_iface() with wiphy lock held
Date:   Thu, 28 Jan 2021 18:35:26 +0100
Message-Id: <20210128183454.e81bc6789b4b.I5deb8b6bfdc8b4ea7696cb2447ee6c58c7ce9a4e@changeid>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210128173528.76393-1-johannes@sipsolutions.net>
References: <20210128173528.76393-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This is needed now that all the driver callbacks are protected by
the wiphy lock rather than (just) the RTNL.

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Reported-by: syzbot+d2d412349f88521938aa@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/wext-compat.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 2e35cb78221e..0c6ea6212496 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -39,6 +39,7 @@ int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
 	struct cfg80211_registered_device *rdev;
 	struct vif_params vifparams;
 	enum nl80211_iftype type;
+	int ret;
 
 	rdev = wiphy_to_rdev(wdev->wiphy);
 
@@ -61,7 +62,11 @@ int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
 
 	memset(&vifparams, 0, sizeof(vifparams));
 
-	return cfg80211_change_iface(rdev, dev, type, &vifparams);
+	wiphy_lock(wdev->wiphy);
+	ret = cfg80211_change_iface(rdev, dev, type, &vifparams);
+	wiphy_unlock(wdev->wiphy);
+
+	return ret;
 }
 EXPORT_WEXT_HANDLER(cfg80211_wext_siwmode);
 
-- 
2.26.2

