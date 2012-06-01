Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41166 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758972Ab2FAIN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 04:13:58 -0400
Received: by wgbdr13 with SMTP id dr13so1692567wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jun 2012 01:13:57 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: clear ifmgd->bssid only after building DELBA
Date: Fri,  1 Jun 2012 11:14:03 +0300
Message-Id: <1338538443-23172-1-git-send-email-eliad@wizery.com> (sfid-20120601_101426_512766_847B35B5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_set_disassoc() clears ifmgd->bssid before
building DELBA frames, resulting in frames with invalid
bssid ("00:00:00:00:00:00").

Fix it by clearing ifmgd->bssid only after building
all the needed frames.

After this change, we no longer need to save the
bssid (before clearing it), so remove the local array.

Reported-by: Ido Yariv <ido@wizery.com>
Cc: stable@vger.kernel.org
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/mlme.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index da52587..96a7f64 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1327,7 +1327,6 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	u32 changed = 0;
-	u8 bssid[ETH_ALEN];
 
 	ASSERT_MGD_MTX(ifmgd);
 
@@ -1337,10 +1336,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	if (WARN_ON(!ifmgd->associated))
 		return;
 
-	memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
-
 	ifmgd->associated = NULL;
-	memset(ifmgd->bssid, 0, ETH_ALEN);
 
 	/*
 	 * we need to commit the associated = NULL change because the
@@ -1360,7 +1356,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	netif_carrier_off(sdata->dev);
 
 	mutex_lock(&local->sta_mtx);
-	sta = sta_info_get(sdata, bssid);
+	sta = sta_info_get(sdata, ifmgd->bssid);
 	if (sta) {
 		set_sta_flag(sta, WLAN_STA_BLOCK_BA);
 		ieee80211_sta_tear_down_BA_sessions(sta, tx);
@@ -1369,13 +1365,16 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	/* deauthenticate/disassociate now */
 	if (tx || frame_buf)
-		ieee80211_send_deauth_disassoc(sdata, bssid, stype, reason,
-					       tx, frame_buf);
+		ieee80211_send_deauth_disassoc(sdata, ifmgd->bssid, stype,
+					       reason, tx, frame_buf);
 
 	/* flush out frame */
 	if (tx)
 		drv_flush(local, false);
 
+	/* clear bssid only after building the needed mgmt frames */
+	memset(ifmgd->bssid, 0, ETH_ALEN);
+
 	/* remove AP and TDLS peers */
 	sta_info_flush(local, sdata);
 
-- 
1.7.6.401.g6a319

