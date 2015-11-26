Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37711 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbbKZP0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 10:26:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] Revert "mac80211: don't advertise NL80211_FEATURE_FULL_AP_CLIENT_STATE"
Date: Thu, 26 Nov 2015 16:26:14 +0100
Message-Id: <1448551574-3207-3-git-send-email-johannes@sipsolutions.net> (sfid-20151126_162633_518464_4DFC98EA)
In-Reply-To: <1448551574-3207-1-git-send-email-johannes@sipsolutions.net>
References: <1448551574-3207-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This reverts commit 45bb780a2147b9995f3d288c44ecb87ca8a330e2,
the previous two patches fixed the functionality.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 175ffcf7fb06..858f6b1cb149 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -541,7 +541,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 			   NL80211_FEATURE_HT_IBSS |
 			   NL80211_FEATURE_VIF_TXPOWER |
 			   NL80211_FEATURE_MAC_ON_CREATE |
-			   NL80211_FEATURE_USERSPACE_MPM;
+			   NL80211_FEATURE_USERSPACE_MPM |
+			   NL80211_FEATURE_FULL_AP_CLIENT_STATE;
 
 	if (!ops->hw_scan)
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
-- 
2.6.2

