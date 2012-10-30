Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41179 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab2J3Ik6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 04:40:58 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: send deauth only with channel context
Date: Tue, 30 Oct 2012 09:41:31 +0100
Message-Id: <1351586491-28634-1-git-send-email-johannes@sipsolutions.net> (sfid-20121030_094102_786162_CFCF33FC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When userspace asks to deauthenticate and we're just
authenticated (or still authenticating) send a deauth
frame instead of deleting the auth request.

On the other hand, if we've just disassociated and
therefore deleted all our state already, drop the
deauth request because we no longer have a channel
context to send it on.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index fb9fd65..35afbbc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3688,40 +3688,44 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 	bool tx = !req->local_state_change;
+	bool sent_frame = false;
 
 	mutex_lock(&ifmgd->mtx);
 
-	if (ifmgd->auth_data) {
-		ieee80211_destroy_auth_data(sdata, false);
-		mutex_unlock(&ifmgd->mtx);
-		return 0;
-	}
-
 	sdata_info(sdata,
 		   "deauthenticating from %pM by local choice (reason=%d)\n",
 		   req->bssid, req->reason_code);
 
-	if (ifmgd->associated &&
-	    ether_addr_equal(ifmgd->associated->bssid, req->bssid)) {
-		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
-				       req->reason_code, tx, frame_buf);
-	} else {
+	if (ifmgd->auth_data) {
 		drv_mgd_prepare_tx(sdata->local, sdata);
 		ieee80211_send_deauth_disassoc(sdata, req->bssid,
 					       IEEE80211_STYPE_DEAUTH,
 					       req->reason_code, tx,
 					       frame_buf);
+		ieee80211_destroy_auth_data(sdata, false);
+		mutex_unlock(&ifmgd->mtx);
+
+		sent_frame = tx;
+		goto out;
 	}
 
+	if (ifmgd->associated &&
+	    ether_addr_equal(ifmgd->associated->bssid, req->bssid)) {
+		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
+				       req->reason_code, tx, frame_buf);
+		sent_frame = tx;
+	}
 	mutex_unlock(&ifmgd->mtx);
 
-	__cfg80211_send_deauth(sdata->dev, frame_buf,
-			       IEEE80211_DEAUTH_FRAME_LEN);
-
+ out:
 	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
 	mutex_unlock(&sdata->local->mtx);
 
+	if (sent_frame)
+		__cfg80211_send_deauth(sdata->dev, frame_buf,
+				       IEEE80211_DEAUTH_FRAME_LEN);
+
 	return 0;
 }
 
-- 
1.7.10.4

