Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42475 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759981AbaEMJ45 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 05:56:57 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] mac80211: fix suspend vs. association race
Date: Tue, 13 May 2014 12:54:09 +0300
Message-Id: <1399974849-12353-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140513_115706_418125_B4AD1FB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the association is in progress while we suspend, the
stack will be in a messed up state. Clean it before we
suspend.

This patch completes Johannes's patch:

1a1cb744de160ee70086a77afff605bbc275d291
Author: Johannes Berg <johannes.berg@intel.com>

    mac80211: fix suspend vs. authentication race

Cc: <stable@vger.kernel.org>
Fixes: 12e7f517029d ("mac80211: cleanup generic suspend/resume procedures")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/mlme.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 139005d..5e4f7ea 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3600,7 +3600,7 @@ void ieee80211_mgd_quiesce(struct ieee80211_sub_if_data *sdata)
 
 	sdata_lock(sdata);
 
-	if (ifmgd->auth_data) {
+	if (ifmgd->auth_data || ifmgd->assoc_data) {
 		/*
 		 * If we are trying to authenticate while suspending, cfg80211
 		 * won't know and won't actually abort those attempts, thus we
@@ -3611,7 +3611,10 @@ void ieee80211_mgd_quiesce(struct ieee80211_sub_if_data *sdata)
 					       IEEE80211_STYPE_DEAUTH,
 					       WLAN_REASON_DEAUTH_LEAVING,
 					       false, frame_buf);
-		ieee80211_destroy_auth_data(sdata, false);
+		if (ifmgd->assoc_data)
+			ieee80211_destroy_assoc_data(sdata, false);
+		if (ifmgd->auth_data)
+			ieee80211_destroy_auth_data(sdata, false);
 		cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
 				      IEEE80211_DEAUTH_FRAME_LEN);
 	}
-- 
1.8.3.2

