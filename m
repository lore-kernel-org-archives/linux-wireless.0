Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:52426 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab2KWUT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 15:19:28 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com, thomas@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Subject: [RFCv2 11/13] mac80211: add awake window IE to mesh beacons
Date: Fri, 23 Nov 2012 12:18:52 -0800
Message-Id: <1353701934-12752-12-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121123_214526_456178_C1054DD4)
In-Reply-To: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The awake window value is announced in an IE in beacons if the local STA
is in light or deep sleep mode towards any peer or non-peer. On receipt STA
parse the IE.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
---
 net/mac80211/cfg.c         |    5 +++++
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh.c        |   23 +++++++++++++++++++++++
 net/mac80211/mesh.h        |    2 ++
 net/mac80211/tx.c          |    4 +++-
 net/mac80211/util.c        |    4 ++++
 6 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index db27208..e49eb08 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1683,6 +1683,11 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		conf->power_mode = nconf->power_mode;
 		ieee80211_mesh_local_ps_update(sdata);
 	}
+	if (_chg_mesh_attr(NL80211_MESHCONF_AWAKE_WINDOW, mask)) {
+		conf->dot11MeshAwakeWindowDuration =
+			nconf->dot11MeshAwakeWindowDuration;
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
+	}
 	return 0;
 }
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index eec4aac..3d4c43f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1204,6 +1204,7 @@ struct ieee802_11_elems {
 	struct ieee80211_meshconf_ie *mesh_config;
 	u8 *mesh_id;
 	u8 *peering;
+	u8 *awake_window;
 	u8 *preq;
 	u8 *prep;
 	u8 *perr;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index c61bbc0..ad5dca7 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -301,6 +301,29 @@ mesh_add_meshid_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 }
 
 int
+mesh_add_awake_window_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u8 *pos;
+
+	/* see IEEE802.11-2012 13.14.6 */
+	if (ifmsh->ps_peers_light_sleep == 0 &&
+	    ifmsh->ps_peers_deep_sleep == 0 &&
+	    ifmsh->nonpeer_ps_mode == NL80211_MESH_POWER_ACTIVE)
+		return 0;
+
+	if (skb_tailroom(skb) < 4)
+		return -ENOMEM;
+
+	pos = skb_put(skb, 2 + 2);
+	*pos++ = WLAN_EID_MESH_AWAKE_WINDOW;
+	*pos++ = 2;
+	put_unaligned_le16(ifmsh->mshcfg.dot11MeshAwakeWindowDuration, pos);
+
+	return 0;
+}
+
+int
 mesh_add_vendor_ies(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 62ca646..f7bf9e3 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -222,6 +222,8 @@ int mesh_add_meshid_ie(struct sk_buff *skb,
 		       struct ieee80211_sub_if_data *sdata);
 int mesh_add_rsn_ie(struct sk_buff *skb,
 		    struct ieee80211_sub_if_data *sdata);
+int mesh_add_awake_window_ie(struct sk_buff *skb,
+			     struct ieee80211_sub_if_data *sdata);
 int mesh_add_vendor_ies(struct sk_buff *skb,
 			struct ieee80211_sub_if_data *sdata);
 int mesh_add_ds_params_ie(struct sk_buff *skb,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 88994dc..1194020 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2444,7 +2444,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 				    2 + sizeof(struct ieee80211_ht_operation) +
 				    2 + sdata->u.mesh.mesh_id_len +
 				    2 + sizeof(struct ieee80211_meshconf_ie) +
-				    sdata->u.mesh.ie_len);
+				    sdata->u.mesh.ie_len +
+				    2 + sizeof(__le16)); /* awake window */
 		if (!skb)
 			goto out;
 
@@ -2477,6 +2478,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		    mesh_add_ht_oper_ie(skb, sdata) ||
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata) ||
+		    mesh_add_awake_window_ie(skb, sdata) ||
 		    mesh_add_vendor_ies(skb, sdata)) {
 			pr_err("o11s: couldn't add ies!\n");
 			goto out;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index acbb8c9..390d1a6 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -795,6 +795,10 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			elems->peering = pos;
 			elems->peering_len = elen;
 			break;
+		case WLAN_EID_MESH_AWAKE_WINDOW:
+			if (elen >= 2)
+				elems->awake_window = pos;
+			break;
 		case WLAN_EID_PREQ:
 			elems->preq = pos;
 			elems->preq_len = elen;
-- 
1.7.9.5

