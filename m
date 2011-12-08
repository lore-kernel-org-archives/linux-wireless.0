Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15657 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab1LHL1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 06:27:18 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>, <rodrigue@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH] cfg80211: notify core hints that helps to restore regd settings
Date: Thu, 8 Dec 2011 16:56:48 +0530
Message-ID: <1323343608-32561-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111208_122723_740427_E5B63858)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regulatory updates set by CORE are ignored for custom regulatory cards.
Let us notify the changes to the driver, as some drivers uses core hint
to restore its orig_* reg domain setting.

Cc: Paul Stewart <pstew@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/wireless/reg.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index db958ba..c45c8b7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1175,9 +1175,21 @@ void regulatory_update(struct wiphy *wiphy,
 static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 {
 	struct cfg80211_registered_device *rdev;
+	struct wiphy *wiphy;
 
-	list_for_each_entry(rdev, &cfg80211_rdev_list, list)
-		wiphy_update_regulatory(&rdev->wiphy, initiator);
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		wiphy = &rdev->wiphy;
+		wiphy_update_regulatory(wiphy, initiator);
+		/*
+		 * Regulatory updates set by CORE are ignored for custom
+		 * regulatory cards. Let us notify the changes to the driver,
+		 * as some drivers used this to restore its orig_* reg domain.
+		 */
+		if (initiator == NL80211_REGDOM_SET_BY_CORE &&
+		    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY &&
+		    wiphy->reg_notifier)
+			wiphy->reg_notifier(wiphy, last_request);
+	}
 }
 
 static void handle_channel_custom(struct wiphy *wiphy,
-- 
1.7.8

