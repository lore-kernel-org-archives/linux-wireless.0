Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3ENHlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 May 2013 03:41:25 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10] mac80211: report deauth to cfg80211 for local state change
Date: Tue, 14 May 2013 09:41:20 +0200
Message-Id: <1368517280-5714-1-git-send-email-johannes@sipsolutions.net> (sfid-20130514_094130_233944_A6973CB8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Even if the frame isn't transmitted to the AP, we need to
report it to cfg80211 so the state there can be updated
correctly.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d87d3f1..a46e490 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4370,7 +4370,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
 	bool tx = !req->local_state_change;
-	bool sent_frame = false;
+	bool report_frame = false;
 
 	mutex_lock(&ifmgd->mtx);
 
@@ -4387,7 +4387,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 		ieee80211_destroy_auth_data(sdata, false);
 		mutex_unlock(&ifmgd->mtx);
 
-		sent_frame = tx;
+		report_frame = true;
 		goto out;
 	}
 
@@ -4395,12 +4395,12 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	    ether_addr_equal(ifmgd->associated->bssid, req->bssid)) {
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       req->reason_code, tx, frame_buf);
-		sent_frame = tx;
+		report_frame = true;
 	}
 	mutex_unlock(&ifmgd->mtx);
 
  out:
-	if (sent_frame)
+	if (report_frame)
 		__cfg80211_send_deauth(sdata->dev, frame_buf,
 				       IEEE80211_DEAUTH_FRAME_LEN);
 
-- 
1.8.0

