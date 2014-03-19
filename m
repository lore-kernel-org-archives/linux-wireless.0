Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962AbaCSI2w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 04:28:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] mac80211: verify deauthentication and return error on failure
Date: Wed, 19 Mar 2014 09:28:49 +0100
Message-Id: <1395217729-13565-1-git-send-email-johannes@sipsolutions.net> (sfid-20140319_092858_551105_A3D36DB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When still authenticating the mac80211 code handling a deauthentication
requests from userspace doesn't verify that the request is valid in any
way, fix that. Additionally, it never returns an error, even if there's
no connection or authentication attempt, fix that as well.

While at it, move the message to not print a message in the error case
and to distinguish between the two cases.

Also simplify the code by duplicating the cfg80211 call.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 423816f18b55..5ade21eb3602 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4393,37 +4393,41 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 	bool tx = !req->local_state_change;
-	bool report_frame = false;
 
-	sdata_info(sdata,
-		   "deauthenticating from %pM by local choice (Reason: %u=%s)\n",
-		   req->bssid, req->reason_code, ieee80211_get_reason_code_string(req->reason_code));
+	if (ifmgd->auth_data &&
+	    ether_addr_equal(ifmgd->auth_data->bss->bssid, req->bssid)) {
+		sdata_info(sdata,
+			   "aborting authentication with %pM by local choice (Reason: %u=%s)\n",
+			   req->bssid, req->reason_code,
+			   ieee80211_get_reason_code_string(req->reason_code));
 
-	if (ifmgd->auth_data) {
 		drv_mgd_prepare_tx(sdata->local, sdata);
 		ieee80211_send_deauth_disassoc(sdata, req->bssid,
 					       IEEE80211_STYPE_DEAUTH,
 					       req->reason_code, tx,
 					       frame_buf);
 		ieee80211_destroy_auth_data(sdata, false);
+		cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
+				      IEEE80211_DEAUTH_FRAME_LEN);
 
-		report_frame = true;
-		goto out;
+		return 0;
 	}
 
 	if (ifmgd->associated &&
 	    ether_addr_equal(ifmgd->associated->bssid, req->bssid)) {
+		sdata_info(sdata,
+			   "deauthenticating from %pM by local choice (Reason: %u=%s)\n",
+			   req->bssid, req->reason_code,
+			   ieee80211_get_reason_code_string(req->reason_code));
+
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       req->reason_code, tx, frame_buf);
-		report_frame = true;
-	}
-
- out:
-	if (report_frame)
 		cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
 				      IEEE80211_DEAUTH_FRAME_LEN);
+		return 0;
+	}
 
-	return 0;
+	return -ENOTCONN;
 }
 
 int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
-- 
1.8.5.3

