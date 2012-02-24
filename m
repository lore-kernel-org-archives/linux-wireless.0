Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60448 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219Ab2BXMwQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 07:52:16 -0500
Message-Id: <20120224125139.011646911@sipsolutions.net> (sfid-20120224_135224_206883_4AB726EC)
Date: Fri, 24 Feb 2012 13:50:54 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211: make deauth/disassoc sequence more natural
References: <20120224125050.809601111@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The association sequence looks (roughly) like
this now:
 * set BSSID
 * set station to EXIST state
 * send auth
 * set station to AUTH state
 * send assoc
 * set station to ASSOC state
 * set BSS info to associated

In contrast, the deauth/disassoc sequence is
the other way around:
 * clear BSSID/BSS info state
 * remove station
 * send deauth/disassoc
(in some cases the last two steps are reversed.)

This patch encodes the entire sequence in the
ieee80211_set_disassoc() function and changes
it to be like this, for good measure with an
explicit flush:
 * send deauth/disassoc
 * flush
 * remove station
 * clear BSSID/BSS info state

At least iwlwifi gets confused with the other
sequence in P2P mode and complains that it
wasn't able to flush the queues.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   84 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 47 insertions(+), 37 deletions(-)

--- a/net/mac80211/mlme.c	2012-02-24 13:50:22.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-02-24 13:50:23.000000000 +0100
@@ -1389,7 +1389,8 @@ static void ieee80211_set_associated(str
 }
 
 static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
-				   bool remove_sta, bool tx)
+				   u16 stype, u16 reason, bool tx,
+				   u8 *frame_buf)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
@@ -1399,6 +1400,9 @@ static void ieee80211_set_disassoc(struc
 
 	ASSERT_MGD_MTX(ifmgd);
 
+	if (WARN_ON_ONCE(tx && !frame_buf))
+		return;
+
 	if (WARN_ON(!ifmgd->associated))
 		return;
 
@@ -1432,6 +1436,19 @@ static void ieee80211_set_disassoc(struc
 	}
 	mutex_unlock(&local->sta_mtx);
 
+	/* deauthenticate/disassociate now */
+	if (tx || frame_buf)
+		ieee80211_send_deauth_disassoc(sdata, bssid, stype, reason,
+					       tx, frame_buf);
+
+	/* flush out frame */
+	if (tx)
+		drv_flush(local, false);
+
+	/* remove AP and TDLS peers */
+	sta_info_flush(local, sdata);
+
+	/* finally reset all BSS / config parameters */
 	changed |= ieee80211_reset_erp_info(sdata);
 
 	ieee80211_led_assoc(local, 0);
@@ -1471,10 +1488,6 @@ static void ieee80211_set_disassoc(struc
 	changed |= BSS_CHANGED_BSSID | BSS_CHANGED_HT;
 	ieee80211_bss_info_change_notify(sdata, changed);
 
-	/* remove AP and TDLS peers */
-	if (remove_sta)
-		sta_info_flush(local, sdata);
-
 	del_timer_sync(&sdata->u.mgd.conn_mon_timer);
 	del_timer_sync(&sdata->u.mgd.bcn_mon_timer);
 	del_timer_sync(&sdata->u.mgd.timer);
@@ -1684,17 +1697,15 @@ static void __ieee80211_connection_loss(
 	printk(KERN_DEBUG "%s: Connection to AP %pM lost.\n",
 	       sdata->name, bssid);
 
-	ieee80211_set_disassoc(sdata, true, false);
+	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
+			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
+			       false, frame_buf);
 	mutex_unlock(&ifmgd->mtx);
 
 	/*
 	 * must be outside lock due to cfg80211,
 	 * but that's not a problem.
 	 */
-	ieee80211_send_deauth_disassoc(sdata, bssid,
-				       IEEE80211_STYPE_DEAUTH,
-				       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
-				       false, frame_buf);
 	cfg80211_send_deauth(sdata->dev, frame_buf, DEAUTH_DISASSOC_LEN);
 
 	mutex_lock(&local->mtx);
@@ -1902,7 +1913,8 @@ ieee80211_rx_mgmt_deauth(struct ieee8021
 	printk(KERN_DEBUG "%s: deauthenticated from %pM (Reason: %u)\n",
 			sdata->name, bssid, reason_code);
 
-	ieee80211_set_disassoc(sdata, true, false);
+	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
+
 	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
 	mutex_unlock(&sdata->local->mtx);
@@ -1932,10 +1944,12 @@ ieee80211_rx_mgmt_disassoc(struct ieee80
 	printk(KERN_DEBUG "%s: disassociated from %pM (Reason: %u)\n",
 			sdata->name, mgmt->sa, reason_code);
 
-	ieee80211_set_disassoc(sdata, true, false);
+	ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
+
 	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
 	mutex_unlock(&sdata->local->mtx);
+
 	return RX_MGMT_CFG80211_DISASSOC;
 }
 
@@ -2699,15 +2713,14 @@ static void ieee80211_sta_connection_los
 	ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
 			  IEEE80211_STA_BEACON_POLL);
 
-	ieee80211_set_disassoc(sdata, true, false);
+	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH, reason,
+			       false, frame_buf);
 	mutex_unlock(&ifmgd->mtx);
+
 	/*
 	 * must be outside lock due to cfg80211,
 	 * but that's not a problem.
 	 */
-	ieee80211_send_deauth_disassoc(sdata, bssid,
-				       IEEE80211_STYPE_DEAUTH,
-				       reason, false, frame_buf);
 	cfg80211_send_deauth(sdata->dev, frame_buf, DEAUTH_DISASSOC_LEN);
 
 	mutex_lock(&local->mtx);
@@ -3189,7 +3202,7 @@ int ieee80211_mgd_auth(struct ieee80211_
 	ifmgd->auth_data = auth_data;
 
 	if (ifmgd->associated)
-		ieee80211_set_disassoc(sdata, true, false);
+		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
 	printk(KERN_DEBUG "%s: authenticate with %pM\n",
 	       sdata->name, req->bss->bssid);
@@ -3267,7 +3280,7 @@ int ieee80211_mgd_assoc(struct ieee80211
 	mutex_lock(&ifmgd->mtx);
 
 	if (ifmgd->associated)
-		ieee80211_set_disassoc(sdata, true, false);
+		ieee80211_set_disassoc(sdata, 0, 0, false, NULL);
 
 	if (ifmgd->auth_data && !ifmgd->auth_data->done) {
 		err = -EBUSY;
@@ -3440,31 +3453,32 @@ int ieee80211_mgd_deauth(struct ieee8021
 			 struct cfg80211_deauth_request *req)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	bool assoc_bss = false;
 	u8 frame_buf[DEAUTH_DISASSOC_LEN];
 
 	mutex_lock(&ifmgd->mtx);
 
-	if (ifmgd->associated &&
-	    memcmp(ifmgd->associated->bssid, req->bssid, ETH_ALEN) == 0) {
-		ieee80211_set_disassoc(sdata, false, true);
-		assoc_bss = true;
-	} else if (ifmgd->auth_data) {
+	if (ifmgd->auth_data) {
 		ieee80211_destroy_auth_data(sdata, false);
 		mutex_unlock(&ifmgd->mtx);
 		return 0;
 	}
-	mutex_unlock(&ifmgd->mtx);
 
-	printk(KERN_DEBUG "%s: deauthenticating from %pM by local choice (reason=%d)\n",
+	printk(KERN_DEBUG
+	       "%s: deauthenticating from %pM by local choice (reason=%d)\n",
 	       sdata->name, req->bssid, req->reason_code);
 
-	ieee80211_send_deauth_disassoc(sdata, req->bssid,
-				       IEEE80211_STYPE_DEAUTH,
+	if (ifmgd->associated &&
+	    memcmp(ifmgd->associated->bssid, req->bssid, ETH_ALEN) == 0)
+		ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DEAUTH,
 				       req->reason_code, true, frame_buf);
+	else
+		ieee80211_send_deauth_disassoc(sdata, req->bssid,
+					       IEEE80211_STYPE_DEAUTH,
+					       req->reason_code, true,
+					       frame_buf);
+	mutex_unlock(&ifmgd->mtx);
+
 	__cfg80211_send_deauth(sdata->dev, frame_buf, DEAUTH_DISASSOC_LEN);
-	if (assoc_bss)
-		sta_info_flush(sdata->local, sdata);
 
 	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);
@@ -3497,16 +3511,12 @@ int ieee80211_mgd_disassoc(struct ieee80
 	       sdata->name, req->bss->bssid, req->reason_code);
 
 	memcpy(bssid, req->bss->bssid, ETH_ALEN);
-	ieee80211_set_disassoc(sdata, false, !req->local_state_change);
-
+	ieee80211_set_disassoc(sdata, IEEE80211_STYPE_DISASSOC,
+			       req->reason_code, !req->local_state_change,
+			       frame_buf);
 	mutex_unlock(&ifmgd->mtx);
 
-	ieee80211_send_deauth_disassoc(sdata, req->bss->bssid,
-				       IEEE80211_STYPE_DISASSOC,
-				       req->reason_code,
-				       !req->local_state_change, frame_buf);
 	__cfg80211_send_disassoc(sdata->dev, frame_buf, DEAUTH_DISASSOC_LEN);
-	sta_info_flush(sdata->local, sdata);
 
 	mutex_lock(&sdata->local->mtx);
 	ieee80211_recalc_idle(sdata->local);


