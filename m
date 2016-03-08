Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:48113 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932243AbcCHLq0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 06:46:26 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: Set global RRM capability
Date: Tue,  8 Mar 2016 13:46:01 +0200
Message-Id: <1457437561-19387-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160308_124633_747686_6F74EB4B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow publishing RRM capabilities for features that are not
HW dependent.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8190bf2..0c9b621 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -548,7 +548,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 			   NL80211_FEATURE_VIF_TXPOWER |
 			   NL80211_FEATURE_MAC_ON_CREATE |
 			   NL80211_FEATURE_USERSPACE_MPM |
-			   NL80211_FEATURE_FULL_AP_CLIENT_STATE;
+			   NL80211_FEATURE_FULL_AP_CLIENT_STATE |
+			   NL80211_EXT_FEATURE_RRM;
 
 	if (!ops->hw_scan)
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
-- 
2.5.0

