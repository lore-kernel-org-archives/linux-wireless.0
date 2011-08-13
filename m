Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60965 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab1HMDBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 23:01:11 -0400
Received: by gwaa12 with SMTP id a12so2372445gwa.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 20:01:10 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: Thomas Pedersen <thomas@cozybit.com>, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: [PATCH v4] mac80211: update mesh peering frame format
Date: Fri, 12 Aug 2011 20:01:00 -0700
Message-Id: <1313204460-4468-1-git-send-email-thomas@cozybit.com> (sfid-20110813_050114_696224_A32A3AFC)
In-Reply-To: <1313116515-26166-1-git-send-email-thomas@cozybit.com>
References: <1313116515-26166-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch updates the mesh peering frames to the format specified in
the recently ratified 802.11s standard. Several changes took place to
make this happen:

	- Change RX path to handle new self-protected frames
	- Add new Peering management IE
	- Remove old Peer Link IE
	- Remove old plink_action field in ieee80211_mgmt header

These changes by themselves would either break peering, or work by
coincidence, so squash them all into this patch.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
v4:
	- commit 0879fa44b54101c9955123582018cb511047a2b6 moves some stuff
	  around causing this patch to no longer apply cleanly.

 include/linux/ieee80211.h |   18 ---------
 include/net/cfg80211.h    |    4 +-
 net/mac80211/mesh.c       |   10 ++++-
 net/mac80211/mesh_plink.c |   89 ++++++++++++++++++++++++---------------------
 net/mac80211/rx.c         |   18 +++++++++
 net/wireless/util.c       |    6 ++--
 6 files changed, 79 insertions(+), 66 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 5c00a63..2417b90 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -736,19 +736,6 @@ struct ieee80211_mgmt {
 					__le16 params;
 					__le16 reason_code;
 				} __attribute__((packed)) delba;
-				struct{
-					u8 action_code;
-					/* capab_info for open and confirm,
-					 * reason for close
-					 */
-					__le16 aux;
-					/* Followed in plink_confirm by status
-					 * code, AID and supported rates,
-					 * and directly by supported rates in
-					 * plink_open and plink_close
-					 */
-					u8 variable[0];
-				} __attribute__((packed)) plink_action;
 				struct {
 					u8 action_code;
 					u8 variable[0];
@@ -1198,11 +1185,6 @@ enum ieee80211_eid {
 	WLAN_EID_MESH_ID = 114,
 	WLAN_EID_LINK_METRIC_REPORT = 115,
 	WLAN_EID_CONGESTION_NOTIFICATION = 116,
-	/* Note that the Peer Link IE has been replaced with the similar
-	 * Peer Management IE.  We will keep the former definition until mesh
-	 * code is changed to comply with latest 802.11s drafts.
-	 */
-	WLAN_EID_PEER_LINK = 55,  /* no longer in 802.11s drafts */
 	WLAN_EID_PEER_MGMT = 117,
 	WLAN_EID_CHAN_SWITCH_PARAM = 118,
 	WLAN_EID_MESH_AWAKE_WINDOW = 119,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d86a15d..d29d11a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2291,7 +2291,7 @@ struct ieee802_11_elems {
 	struct ieee80211_ht_info *ht_info_elem;
 	struct ieee80211_meshconf_ie *mesh_config;
 	u8 *mesh_id;
-	u8 *peer_link;
+	u8 *peering;
 	u8 *preq;
 	u8 *prep;
 	u8 *perr;
@@ -2318,7 +2318,7 @@ struct ieee802_11_elems {
 	u8 wmm_info_len;
 	u8 wmm_param_len;
 	u8 mesh_id_len;
-	u8 peer_link_len;
+	u8 peering_len;
 	u8 preq_len;
 	u8 prep_len;
 	u8 perr_len;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 1990869..da5e981 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -662,8 +662,14 @@ static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
 					  struct ieee80211_rx_status *rx_status)
 {
 	switch (mgmt->u.action.category) {
-	case WLAN_CATEGORY_MESH_ACTION:
-		mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
+	case WLAN_CATEGORY_SELF_PROTECTED:
+		switch (mgmt->u.action.u.self_prot.action_code) {
+		case WLAN_SP_MESH_PEERING_OPEN:
+		case WLAN_SP_MESH_PEERING_CLOSE:
+		case WLAN_SP_MESH_PEERING_CONFIRM:
+			mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
+			break;
+		}
 		break;
 	case WLAN_CATEGORY_MESH_PATH_SEL:
 		mesh_rx_path_sel_frame(sdata, mgmt, len);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 2cf2212..1a00d0f 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -19,8 +19,8 @@
 #define mpl_dbg(fmt, args...)	do { (void)(0); } while (0)
 #endif
 
-#define PLINK_GET_LLID(p) (p + 4)
-#define PLINK_GET_PLID(p) (p + 6)
+#define PLINK_GET_LLID(p) (p + 2)
+#define PLINK_GET_PLID(p) (p + 4)
 
 #define mod_plink_timer(s, t) (mod_timer(&s->plink_timer, \
 				jiffies + HZ * t / 1000))
@@ -147,9 +147,9 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			sdata->u.mesh.ie_len);
 	struct ieee80211_mgmt *mgmt;
 	bool include_plid = false;
-	static const u8 meshpeeringproto[] = { 0x00, 0x0F, 0xAC, 0x2A };
+	int ie_len = 4;
+	u16 peering_proto = 0;
 	u8 *pos;
-	int ie_len;
 
 	if (!skb)
 		return -1;
@@ -158,24 +158,23 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	 * common action part (1)
 	 */
 	mgmt = (struct ieee80211_mgmt *)
-		skb_put(skb, 25 + sizeof(mgmt->u.action.u.plink_action));
-	memset(mgmt, 0, 25 + sizeof(mgmt->u.action.u.plink_action));
+		skb_put(skb, 25 + sizeof(mgmt->u.action.u.self_prot));
+	memset(mgmt, 0, 25 + sizeof(mgmt->u.action.u.self_prot));
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_ACTION);
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
-	mgmt->u.action.category = WLAN_CATEGORY_MESH_ACTION;
-	mgmt->u.action.u.plink_action.action_code = action;
+	mgmt->u.action.category = WLAN_CATEGORY_SELF_PROTECTED;
+	mgmt->u.action.u.self_prot.action_code = action;
 
-	if (action == WLAN_SP_MESH_PEERING_CLOSE)
-		mgmt->u.action.u.plink_action.aux = reason;
-	else {
-		mgmt->u.action.u.plink_action.aux = cpu_to_le16(0x0);
+	if (action != WLAN_SP_MESH_PEERING_CLOSE) {
+		/* capability info */
+		pos = skb_put(skb, 2);
+		memset(pos, 0, 2);
 		if (action == WLAN_SP_MESH_PEERING_CONFIRM) {
-			pos = skb_put(skb, 4);
-			/* two-byte status code followed by two-byte AID */
-			memset(pos, 0, 2);
+			/* AID */
+			pos = skb_put(skb, 2);
 			memcpy(pos + 2, &plid, 2);
 		}
 		if (mesh_add_srates_ie(skb, sdata) ||
@@ -184,42 +183,50 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata))
 			return -1;
+	} else {	/* WLAN_SP_MESH_PEERING_CLOSE */
+		if (mesh_add_meshid_ie(skb, sdata))
+			return -1;
 	}
 
-	/* Add Peer Link Management element */
+	/* Add Mesh Peering Management element */
 	switch (action) {
 	case WLAN_SP_MESH_PEERING_OPEN:
-		ie_len = 6;
 		break;
 	case WLAN_SP_MESH_PEERING_CONFIRM:
-		ie_len = 8;
+		ie_len += 2;
 		include_plid = true;
 		break;
 	case WLAN_SP_MESH_PEERING_CLOSE:
-	default:
-		if (!plid)
-			ie_len = 8;
-		else {
-			ie_len = 10;
+		if (plid) {
+			ie_len += 2;
 			include_plid = true;
 		}
+		ie_len += 2;	/* reason code */
 		break;
+	default:
+		return -EINVAL;
 	}
 
+	if (WARN_ON(skb_tailroom(skb) < 2 + ie_len))
+		return -ENOMEM;
+
 	pos = skb_put(skb, 2 + ie_len);
-	*pos++ = WLAN_EID_PEER_LINK;
+	*pos++ = WLAN_EID_PEER_MGMT;
 	*pos++ = ie_len;
-	memcpy(pos, meshpeeringproto, sizeof(meshpeeringproto));
-	pos += 4;
+	memcpy(pos, &peering_proto, 2);
+	pos += 2;
 	memcpy(pos, &llid, 2);
+	pos += 2;
 	if (include_plid) {
-		pos += 2;
 		memcpy(pos, &plid, 2);
+		pos += 2;
 	}
 	if (action == WLAN_SP_MESH_PEERING_CLOSE) {
-		pos += 2;
 		memcpy(pos, &reason, 2);
+		pos += 2;
 	}
+	if (mesh_add_vendor_ies(skb, sdata))
+		return -1;
 
 	ieee80211_tx_skb(sdata, skb);
 	return 0;
@@ -437,15 +444,15 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		return;
 	}
 
-	baseaddr = mgmt->u.action.u.plink_action.variable;
-	baselen = (u8 *) mgmt->u.action.u.plink_action.variable - (u8 *) mgmt;
-	if (mgmt->u.action.u.plink_action.action_code ==
+	baseaddr = mgmt->u.action.u.self_prot.variable;
+	baselen = (u8 *) mgmt->u.action.u.self_prot.variable - (u8 *) mgmt;
+	if (mgmt->u.action.u.self_prot.action_code ==
 						WLAN_SP_MESH_PEERING_CONFIRM) {
 		baseaddr += 4;
 		baselen += 4;
 	}
 	ieee802_11_parse_elems(baseaddr, len - baselen, &elems);
-	if (!elems.peer_link) {
+	if (!elems.peering) {
 		mpl_dbg("Mesh plink: missing necessary peer link ie\n");
 		return;
 	}
@@ -455,12 +462,12 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		return;
 	}
 
-	ftype = mgmt->u.action.u.plink_action.action_code;
-	ie_len = elems.peer_link_len;
-	if ((ftype == WLAN_SP_MESH_PEERING_OPEN && ie_len != 6) ||
-	    (ftype == WLAN_SP_MESH_PEERING_CONFIRM && ie_len != 8) ||
-	    (ftype == WLAN_SP_MESH_PEERING_CLOSE && ie_len != 8
-							&& ie_len != 10)) {
+	ftype = mgmt->u.action.u.self_prot.action_code;
+	ie_len = elems.peering_len;
+	if ((ftype == WLAN_SP_MESH_PEERING_OPEN && ie_len != 4) ||
+	    (ftype == WLAN_SP_MESH_PEERING_CONFIRM && ie_len != 6) ||
+	    (ftype == WLAN_SP_MESH_PEERING_CLOSE && ie_len != 6
+							&& ie_len != 8)) {
 		mpl_dbg("Mesh plink: incorrect plink ie length %d %d\n",
 		    ftype, ie_len);
 		return;
@@ -474,10 +481,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	/* Note the lines below are correct, the llid in the frame is the plid
 	 * from the point of view of this host.
 	 */
-	memcpy(&plid, PLINK_GET_LLID(elems.peer_link), 2);
+	memcpy(&plid, PLINK_GET_LLID(elems.peering), 2);
 	if (ftype == WLAN_SP_MESH_PEERING_CONFIRM ||
-	    (ftype == WLAN_SP_MESH_PEERING_CLOSE && ie_len == 10))
-		memcpy(&llid, PLINK_GET_PLID(elems.peer_link), 2);
+	    (ftype == WLAN_SP_MESH_PEERING_CLOSE && ie_len == 8))
+		memcpy(&llid, PLINK_GET_PLID(elems.peering), 2);
 
 	rcu_read_lock();
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fe2c2a7..3fb6dea 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2220,6 +2220,24 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 			goto handled;
 		}
 		break;
+	case WLAN_CATEGORY_SELF_PROTECTED:
+		switch (mgmt->u.action.u.self_prot.action_code) {
+		case WLAN_SP_MESH_PEERING_OPEN:
+		case WLAN_SP_MESH_PEERING_CLOSE:
+		case WLAN_SP_MESH_PEERING_CONFIRM:
+			if (!ieee80211_vif_is_mesh(&sdata->vif))
+				goto invalid;
+			if (sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE)
+				/* userspace handles this frame */
+				break;
+			goto queue;
+		case WLAN_SP_MGK_INFORM:
+		case WLAN_SP_MGK_ACK:
+			if (!ieee80211_vif_is_mesh(&sdata->vif))
+				goto invalid;
+			break;
+		}
+		break;
 	case WLAN_CATEGORY_MESH_ACTION:
 		if (!ieee80211_vif_is_mesh(&sdata->vif))
 			break;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 844ddb0..eef82f7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1158,9 +1158,9 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			if (elen >= sizeof(struct ieee80211_meshconf_ie))
 				elems->mesh_config = (void *)pos;
 			break;
-		case WLAN_EID_PEER_LINK:
-			elems->peer_link = pos;
-			elems->peer_link_len = elen;
+		case WLAN_EID_PEER_MGMT:
+			elems->peering = pos;
+			elems->peering_len = elen;
 			break;
 		case WLAN_EID_PREQ:
 			elems->preq = pos;
-- 
1.7.4.1

