Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262Ab2JOMxc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 08:53:32 -0400
Date: Mon, 15 Oct 2012 14:52:41 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211/mac80211: avoid state mishmash on deauth
Message-ID: <20121015125231.GA9941@redhat.com> (sfid-20121015_145334_507070_B25A4FF1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid situation when we are on associate state in mac80211 and
on disassociate state in cfg80211. This can results on crash
during modules unload (like showed on this thread:
http://marc.info/?t=134373976300001&r=1&w=2) and possibly other
problems.

Reported-by: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ab78b53..9b99b60 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1218,6 +1218,7 @@ struct cfg80211_deauth_request {
 	const u8 *ie;
 	size_t ie_len;
 	u16 reason_code;
+	bool local_state_change;
 };
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e714ed8..e510a33 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3549,6 +3549,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
+	bool tx = !req->local_state_change;
 
 	mutex_lock(&ifmgd->mtx);
 
@@ -3565,12 +3566,12 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	if (ifmgd->associated &&
 	    ether_addr_equal(ifmgd->associated->bssid, req->bssid)) {
 		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
-				       req->reason_code, true, frame_buf);
+				       req->reason_code, tx, frame_buf);
 	} else {
 		drv_mgd_prepare_tx(sdata->local, sdata);
 		ieee80211_send_deauth_disassoc(sdata, req->bssid,
 					       IEEE80211_STYPE_DEAUTH,
-					       req->reason_code, true,
+					       req->reason_code, tx,
 					       frame_buf);
 	}
 
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 3df195a..f4d6226 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -457,20 +457,14 @@ int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 		.reason_code = reason,
 		.ie = ie,
 		.ie_len = ie_len,
+		.local_state_change = local_state_change,
 	};
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	if (local_state_change) {
-		if (wdev->current_bss &&
-		    ether_addr_equal(wdev->current_bss->pub.bssid, bssid)) {
-			cfg80211_unhold_bss(wdev->current_bss);
-			cfg80211_put_bss(&wdev->current_bss->pub);
-			wdev->current_bss = NULL;
-		}
-
+	if (local_state_change && (!wdev->current_bss ||
+	    !ether_addr_equal(wdev->current_bss->pub.bssid, bssid)))
 		return 0;
-	}
 
 	return rdev->ops->deauth(&rdev->wiphy, dev, &req);
 }
