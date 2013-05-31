Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab3EaPNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 11:13:21 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: thomas@cozybit.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: advertise userspace MPM only if mesh is supported
Date: Fri, 31 May 2013 17:13:11 +0200
Message-Id: <1370013191-25900-1-git-send-email-johannes@sipsolutions.net> (sfid-20130531_171324_115740_2E2B04A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no danger in always advertising it, but it would
look a bit inconsistent so don't do it unless supported.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1998f14..810e20c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -556,8 +556,10 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	wiphy->features |= NL80211_FEATURE_SK_TX_STATUS |
 			   NL80211_FEATURE_SAE |
 			   NL80211_FEATURE_HT_IBSS |
-			   NL80211_FEATURE_VIF_TXPOWER |
-			   NL80211_FEATURE_USERSPACE_MPM;
+			   NL80211_FEATURE_VIF_TXPOWER;
+#ifdef CONFIG_MAC80211_MESH
+	wiphy->features |= NL80211_FEATURE_USERSPACE_MPM;
+#endif
 
 	if (!ops->hw_scan)
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
-- 
1.8.0

