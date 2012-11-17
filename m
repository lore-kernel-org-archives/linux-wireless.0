Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:39751 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2KQGsz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:48:55 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>
Subject: [RFC 12/14] mac80211: add awake window IE to mesh beacons
Date: Fri, 16 Nov 2012 22:48:04 -0800
Message-Id: <1353134886-13256-13-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074900_731155_B5133C62)
In-Reply-To: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The awake window value is announced in an IE in beacons if the local STA
is in light or deep sleep mode towards any peer or non-peer.

Signed-off-by: Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh.c        |   23 +++++++++++++++++++++++
 net/mac80211/mesh.h        |    2 ++
 net/mac80211/tx.c          |    4 +++-
 net/mac80211/util.c        |    4 ++++
 5 files changed, 33 insertions(+), 1 deletion(-)

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
index 86f076e..fff017e 100644
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
index a9406b6..19c682e 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -237,6 +237,8 @@ int mesh_add_meshid_ie(struct sk_buff *skb,
 		       struct ieee80211_sub_if_data *sdata);
 int mesh_add_rsn_ie(struct sk_buff *skb,
 		    struct ieee80211_sub_if_data *sdata);
+int mesh_add_awake_window_ie(struct sk_buff *skb,
+			     struct ieee80211_sub_if_data *sdata);
 int mesh_add_vendor_ies(struct sk_buff *skb,
 			struct ieee80211_sub_if_data *sdata);
 int mesh_add_ds_params_ie(struct sk_buff *skb,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0ef5708..a62deaf 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2445,7 +2445,8 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 				    2 + sizeof(struct ieee80211_ht_operation) +
 				    2 + sdata->u.mesh.mesh_id_len +
 				    2 + sizeof(struct ieee80211_meshconf_ie) +
-				    sdata->u.mesh.ie_len);
+				    sdata->u.mesh.ie_len +
+				    2 + sizeof(__le16)); /* awake window */
 		if (!skb)
 			goto out;
 
@@ -2478,6 +2479,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
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

