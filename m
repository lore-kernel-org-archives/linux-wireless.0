Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab2BXMwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 07:52:13 -0500
Message-Id: <20120224125138.742154031@sipsolutions.net> (sfid-20120224_135221_591370_ADD4C2FE)
Date: Fri, 24 Feb 2012 13:50:52 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/4] mac80211: dont call cfg80211 from
 ieee80211_send_deauth_disassoc
References: <20120224125050.809601111@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of calling cfg80211 in ieee80211_send_deauth_disassoc()
pass out the frame and call it from the caller. That saves the
SKB allocation if we don't actually want to send the frame and
enables us to make the ordering smarter in the future.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c |   71 +++++++++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

--- a/net/mac80211/mlme.c	2012-02-24 13:50:18.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-02-24 13:50:20.000000000 +0100
@@ -88,6 +88,8 @@ MODULE_PARM_DESC(probe_wait_ms,
 #define TMR_RUNNING_TIMER	0
 #define TMR_RUNNING_CHANSW	1
 
+#define DEAUTH_DISASSOC_LEN	(24 /* hdr */ + 2 /* reason */)
+
 /*
  * All cfg80211 functions have to be called outside a locked
  * section so that they can acquire a lock themselves... This
@@ -613,47 +615,41 @@ static void ieee80211_send_assoc(struct
 
 static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 					   const u8 *bssid, u16 stype,
-					   u16 reason, bool cfg80211_locked,
-					   bool send_frame)
+					   u16 reason, bool send_frame,
+					   u8 *frame_buf)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct sk_buff *skb;
-	struct ieee80211_mgmt *mgmt;
-
-	skb = dev_alloc_skb(local->hw.extra_tx_headroom + sizeof(*mgmt));
-	if (!skb)
-		return;
+	struct ieee80211_mgmt *mgmt = (void *)frame_buf;
 
-	skb_reserve(skb, local->hw.extra_tx_headroom);
-
-	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
-	memset(mgmt, 0, 24);
+	/* build frame */
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | stype);
+	mgmt->duration = 0; /* initialize only */
+	mgmt->seq_ctrl = 0; /* initialize only */
 	memcpy(mgmt->da, bssid, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	memcpy(mgmt->bssid, bssid, ETH_ALEN);
-	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | stype);
-	skb_put(skb, 2);
 	/* u.deauth.reason_code == u.disassoc.reason_code */
 	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
 
-	if (stype == IEEE80211_STYPE_DEAUTH)
-		if (cfg80211_locked)
-			__cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
-		else
-			cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
-	else
-		if (cfg80211_locked)
-			__cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
-		else
-			cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
-	if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
-		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
+	if (send_frame) {
+		skb = dev_alloc_skb(local->hw.extra_tx_headroom +
+				    DEAUTH_DISASSOC_LEN);
+		if (!skb)
+			return;
+
+		skb_reserve(skb, local->hw.extra_tx_headroom);
 
-	if (send_frame)
+		/* copy in frame */
+		memcpy(skb_put(skb, DEAUTH_DISASSOC_LEN),
+		       mgmt, DEAUTH_DISASSOC_LEN);
+
+		if (!(ifmgd->flags & IEEE80211_STA_MFP_ENABLED))
+			IEEE80211_SKB_CB(skb)->flags |=
+				IEEE80211_TX_INTFL_DONT_ENCRYPT;
 		ieee80211_tx_skb(sdata, skb);
-	else
-		kfree_skb(skb);
+	}
 }
 
 void ieee80211_send_pspoll(struct ieee80211_local *local,
@@ -1675,6 +1671,7 @@ static void __ieee80211_connection_loss(
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
 	u8 bssid[ETH_ALEN];
+	u8 frame_buf[DEAUTH_DISASSOC_LEN];
 
 	mutex_lock(&ifmgd->mtx);
 	if (!ifmgd->associated) {
@@ -1697,7 +1694,8 @@ static void __ieee80211_connection_loss(
 	ieee80211_send_deauth_disassoc(sdata, bssid,
 				       IEEE80211_STYPE_DEAUTH,
 				       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
-				       false, true);
+				       false, frame_buf);
+	cfg80211_send_deauth(sdata->dev, frame_buf, DEAUTH_DISASSOC_LEN);
 
 	mutex_lock(&local->mtx);
 	ieee80211_recalc_idle(local);
@@ -2696,6 +2694,7 @@ static void ieee80211_sta_connection_los
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	u8 frame_buf[DEAUTH_DISASSOC_LEN];
 
 	ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
 			  IEEE80211_STA_BEACON_POLL);
@@ -2708,7 +2707,8 @@ static void ieee80211_sta_connection_los
 	 */
 	ieee80211_send_deauth_disassoc(sdata, bssid,
 				       IEEE80211_STYPE_DEAUTH,
-				       reason, false, true);
+				       reason, false, frame_buf);
+	cfg80211_send_deauth(sdata->dev, frame_buf, DEAUTH_DISASSOC_LEN);
 
 	mutex_lock(&local->mtx);
 	ieee80211_recalc_idle(local);
@@ -3441,6 +3441,7 @@ int ieee80211_mgd_deauth(struct ieee8021
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	bool assoc_bss = false;
+	u8 frame_buf[DEAUTH_DISASSOC_LEN];
 
 	mutex_lock(&ifmgd->mtx);
 
@@ -3460,7 +3461,8 @@ int ieee80211_mgd_deauth(struct ieee8021
 
 	ieee80211_send_deauth_disassoc(sdata, req->bssid,
 				       IEEE80211_STYPE_DEAUTH,
-				       req->reason_code, true, true);
+				       req->reason_code, true, frame_buf);
+	__cfg80211_send_deauth(sdata->dev, frame_buf, DEAUTH_DISASSOC_LEN);
 	if (assoc_bss)
 		sta_info_flush(sdata->local, sdata);
 
@@ -3476,6 +3478,7 @@ int ieee80211_mgd_disassoc(struct ieee80
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	u8 bssid[ETH_ALEN];
+	u8 frame_buf[DEAUTH_DISASSOC_LEN];
 
 	mutex_lock(&ifmgd->mtx);
 
@@ -3499,8 +3502,10 @@ int ieee80211_mgd_disassoc(struct ieee80
 	mutex_unlock(&ifmgd->mtx);
 
 	ieee80211_send_deauth_disassoc(sdata, req->bss->bssid,
-			IEEE80211_STYPE_DISASSOC, req->reason_code,
-			true, !req->local_state_change);
+				       IEEE80211_STYPE_DISASSOC,
+				       req->reason_code,
+				       !req->local_state_change, frame_buf);
+	__cfg80211_send_disassoc(sdata->dev, frame_buf, DEAUTH_DISASSOC_LEN);
 	sta_info_flush(sdata->local, sdata);
 
 	mutex_lock(&sdata->local->mtx);


