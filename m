Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:49104 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433Ab3KETXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:23:00 -0500
Received: by mail-pd0-f177.google.com with SMTP id p10so8991562pdj.36
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:22:59 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 11/17] mac80211: factor peering frame processing into own function
Date: Tue,  5 Nov 2013 11:16:59 -0800
Message-Id: <1383679025-7150-11-git-send-email-thomas@cozybit.com> (sfid-20131105_202307_129252_25CAF2BB)
In-Reply-To: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
References: <1383679025-7150-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh_plink.c | 88 ++++++++++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 40 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 429f692..c234ddb 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -691,54 +691,29 @@ static u32 mesh_plink_establish(struct ieee80211_sub_if_data *sdata,
 	return changed;
 }
 
-
-void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
-			 struct ieee80211_mgmt *mgmt, size_t len,
-			 struct ieee80211_rx_status *rx_status)
+static void
+mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
+			 struct ieee80211_mgmt *mgmt,
+			 struct ieee802_11_elems *elems)
 {
+
 	struct mesh_config *mshcfg = &sdata->u.mesh.mshcfg;
 	enum ieee80211_self_protected_actioncode action = 0;
-	struct ieee802_11_elems elems;
 	struct sta_info *sta;
 	enum plink_event event;
 	enum ieee80211_self_protected_actioncode ftype;
-	size_t baselen;
 	bool matches_local;
-	u8 ie_len;
-	u8 *baseaddr;
 	u32 changed = 0;
+	u8 ie_len;
 	__le16 plid, llid;
 
-	/* need action_code, aux */
-	if (len < IEEE80211_MIN_ACTION_SIZE + 3)
-		return;
-
-	if (sdata->u.mesh.user_mpm)
-		/* userspace must register for these */
-		return;
-
-	if (is_multicast_ether_addr(mgmt->da)) {
-		mpl_dbg(sdata,
-			"Mesh plink: ignore frame from multicast address\n");
-		return;
-	}
-
-	baseaddr = mgmt->u.action.u.self_prot.variable;
-	baselen = (u8 *) mgmt->u.action.u.self_prot.variable - (u8 *) mgmt;
-	if (mgmt->u.action.u.self_prot.action_code ==
-						WLAN_SP_MESH_PEERING_CONFIRM) {
-		baseaddr += 4;
-		baselen += 4;
-	}
-	ieee802_11_parse_elems(baseaddr, len - baselen, true, &elems);
-
-	if (!elems.peering) {
+	if (!elems->peering) {
 		mpl_dbg(sdata,
 			"Mesh plink: missing necessary peer link ie\n");
 		return;
 	}
 
-	if (elems.rsn_len &&
+	if (elems->rsn_len &&
 	    sdata->u.mesh.security == IEEE80211_MESH_SEC_NONE) {
 		mpl_dbg(sdata,
 			"Mesh plink: can't establish link with secure peer\n");
@@ -746,7 +721,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 	}
 
 	ftype = mgmt->u.action.u.self_prot.action_code;
-	ie_len = elems.peering_len;
+	ie_len = elems->peering_len;
 	if ((ftype == WLAN_SP_MESH_PEERING_OPEN && ie_len != 4) ||
 	    (ftype == WLAN_SP_MESH_PEERING_CONFIRM && ie_len != 6) ||
 	    (ftype == WLAN_SP_MESH_PEERING_CLOSE && ie_len != 6
@@ -758,25 +733,25 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (ftype != WLAN_SP_MESH_PEERING_CLOSE &&
-	    (!elems.mesh_id || !elems.mesh_config)) {
+	    (!elems->mesh_id || !elems->mesh_config)) {
 		mpl_dbg(sdata, "Mesh plink: missing necessary ie\n");
 		return;
 	}
 	/* Note the lines below are correct, the llid in the frame is the plid
 	 * from the point of view of this host.
 	 */
-	memcpy(&plid, PLINK_GET_LLID(elems.peering), 2);
+	memcpy(&plid, PLINK_GET_LLID(elems->peering), 2);
 	if (ftype == WLAN_SP_MESH_PEERING_CONFIRM ||
 	    (ftype == WLAN_SP_MESH_PEERING_CLOSE && ie_len == 8))
-		memcpy(&llid, PLINK_GET_PLID(elems.peering), 2);
+		memcpy(&llid, PLINK_GET_PLID(elems->peering), 2);
 
 	/* WARNING: Only for sta pointer, is dropped & re-acquired */
 	rcu_read_lock();
 
 	sta = sta_info_get(sdata, mgmt->sa);
 
-	matches_local = ftype == WLAN_SP_MESH_PEERING_CLOSE ||
-			mesh_matches_local(sdata, &elems);
+	matches_local = (ftype == WLAN_SP_MESH_PEERING_CLOSE ||
+			 mesh_matches_local(sdata, elems));
 
 	if (ftype == WLAN_SP_MESH_PEERING_OPEN &&
 	    !rssi_threshold_check(sdata, sta)) {
@@ -872,7 +847,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 	if (event == OPN_ACPT) {
 		rcu_read_unlock();
 		/* allocate sta entry if necessary and update info */
-		sta = mesh_sta_info_get(sdata, mgmt->sa, &elems);
+		sta = mesh_sta_info_get(sdata, mgmt->sa, elems);
 		if (!sta) {
 			mpl_dbg(sdata, "Mesh plink: failed to init peer!\n");
 			rcu_read_unlock();
@@ -1028,3 +1003,36 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 	if (changed)
 		ieee80211_mbss_info_change_notify(sdata, changed);
 }
+
+void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
+			 struct ieee80211_mgmt *mgmt, size_t len,
+			 struct ieee80211_rx_status *rx_status)
+{
+	struct ieee802_11_elems elems;
+	size_t baselen;
+	u8 *baseaddr;
+
+	/* need action_code, aux */
+	if (len < IEEE80211_MIN_ACTION_SIZE + 3)
+		return;
+
+	if (sdata->u.mesh.user_mpm)
+		/* userspace must register for these */
+		return;
+
+	if (is_multicast_ether_addr(mgmt->da)) {
+		mpl_dbg(sdata,
+			"Mesh plink: ignore frame from multicast address\n");
+		return;
+	}
+
+	baseaddr = mgmt->u.action.u.self_prot.variable;
+	baselen = (u8 *) mgmt->u.action.u.self_prot.variable - (u8 *) mgmt;
+	if (mgmt->u.action.u.self_prot.action_code ==
+						WLAN_SP_MESH_PEERING_CONFIRM) {
+		baseaddr += 4;
+		baselen += 4;
+	}
+	ieee802_11_parse_elems(baseaddr, len - baselen, true, &elems);
+	mesh_process_plink_frame(sdata, mgmt, &elems);
+}
-- 
1.8.4.rc3

