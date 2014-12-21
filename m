Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:40625 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaLUQcc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 11:32:32 -0500
Received: by mail-wg0-f42.google.com with SMTP id k14so5058111wgh.1
        for <linux-wireless@vger.kernel.org>; Sun, 21 Dec 2014 08:32:31 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] mac80211: allow some multi-channel combinations with DFS master
Date: Sun, 21 Dec 2014 18:32:26 +0200
Message-Id: <1419179546-29313-2-git-send-email-eliad@wizery.com> (sfid-20141221_173245_372519_F88C3546)
In-Reply-To: <1419179546-29313-1-git-send-email-eliad@wizery.com>
References: <1419179546-29313-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow some multi-channel interface combinations along with
DFS master support, if there is only a single AP/GO.

Allowing other interface types at the same time is fine
(as long as the device supports them), and doesn't require
additional code.

Update ieee80211_dfs_radar_detected_work() to consider
this case, and look specifically for the chanctx with
radar_enabled.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/main.c | 11 -----------
 net/mac80211/util.c |  3 +++
 net/wireless/core.c | 23 +++++++++++++++++------
 3 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d9ce336..78d8c6d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -792,17 +792,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		 */
 		if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_WDS))
 			return -EINVAL;
-
-		/* DFS is not supported with multi-channel combinations yet */
-		for (i = 0; i < local->hw.wiphy->n_iface_combinations; i++) {
-			const struct ieee80211_iface_combination *comb;
-
-			comb = &local->hw.wiphy->iface_combinations[i];
-
-			if (comb->radar_detect_widths &&
-			    comb->num_different_channels > 1)
-				return -EINVAL;
-		}
 	}
 
 	/* Only HW csum features are currently compatible with mac80211 */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 974ebe7..61affe6 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2625,6 +2625,9 @@ void ieee80211_dfs_radar_detected_work(struct work_struct *work)
 		if (ctx->replace_state == IEEE80211_CHANCTX_REPLACES_OTHER)
 			continue;
 
+		if (!ctx->conf.radar_enabled)
+			continue;
+
 		num_chanctx++;
 		chandef = ctx->conf.def;
 	}
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 4910758..8bcadd9 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -453,7 +453,7 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 	int i, j;
 
 	for (i = 0; i < wiphy->n_iface_combinations; i++) {
-		u32 cnt = 0;
+		u32 cnt = 0, dfs_cnt = 0;
 		u16 all_iftypes = 0;
 
 		c = &wiphy->iface_combinations[i];
@@ -477,11 +477,6 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 				CFG80211_MAX_NUM_DIFFERENT_CHANNELS))
 			return -EINVAL;
 
-		/* DFS only works on one channel. */
-		if (WARN_ON(c->radar_detect_widths &&
-			    (c->num_different_channels > 1)))
-			return -EINVAL;
-
 		if (WARN_ON(!c->n_limits))
 			return -EINVAL;
 
@@ -505,6 +500,22 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 				    c->limits[j].max > 1))
 				return -EINVAL;
 
+			if (types & (BIT(NL80211_IFTYPE_AP) |
+				     BIT(NL80211_IFTYPE_P2P_GO) |
+				     BIT(NL80211_IFTYPE_ADHOC) |
+				     BIT(NL80211_IFTYPE_MESH_POINT))) {
+				dfs_cnt += c->limits[j].max;
+
+				/*
+				 * Multiple DFS masters on multiple channels
+				 * are not supported yet.
+				 */
+				if (WARN_ON(c->radar_detect_widths &&
+					    c->num_different_channels > 1 &&
+					    dfs_cnt > 1))
+					return -EINVAL;
+			}
+
 			cnt += c->limits[j].max;
 			/*
 			 * Don't advertise an unsupported type
-- 
1.8.5.1.109.g3d252a9

