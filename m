Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:26852 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996AbYCCUUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 15:20:30 -0500
Received: by wf-out-1314.google.com with SMTP id 28so348509wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 12:20:28 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Fri, 29 Feb 2008 12:20:39 -0800
Subject: [PATCH 03/10] mac80211: move comment to better location
Message-ID: <47cc5d8a.1d078e0a.5902.ffffee7a@mx.google.com> (sfid-20080303_202057_073655_02638FB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/mesh.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 9de1ccc..54d5ced 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -48,11 +48,6 @@ bool mesh_matches_local(struct ieee802_11_elems *ie, struct net_device *dev)
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_if_sta *sta = &sdata->u.sta;
 
-	if (sta->mesh_id_len == ie->mesh_id_len &&
-		memcmp(sta->mesh_id, ie->mesh_id, ie->mesh_id_len) == 0 &&
-		memcmp(sta->mesh_pp_id, ie->mesh_config + PP_OFFSET, 4) == 0 &&
-		memcmp(sta->mesh_pm_id, ie->mesh_config + PM_OFFSET, 4) == 0 &&
-		memcmp(sta->mesh_cc_id, ie->mesh_config + CC_OFFSET, 4) == 0)
 	/*
 	 * As support for each feature is added, check for matching
 	 * - On mesh config capabilities
@@ -63,6 +58,11 @@ bool mesh_matches_local(struct ieee802_11_elems *ie, struct net_device *dev)
 	 *   - MDA enabled
 	 * - Power management control on fc
 	 */
+	if (sta->mesh_id_len == ie->mesh_id_len &&
+		memcmp(sta->mesh_id, ie->mesh_id, ie->mesh_id_len) == 0 &&
+		memcmp(sta->mesh_pp_id, ie->mesh_config + PP_OFFSET, 4) == 0 &&
+		memcmp(sta->mesh_pm_id, ie->mesh_config + PM_OFFSET, 4) == 0 &&
+		memcmp(sta->mesh_cc_id, ie->mesh_config + CC_OFFSET, 4) == 0)
 		return true;
 
 	return false;
-- 
1.5.2.5



