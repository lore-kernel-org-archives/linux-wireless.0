Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45447 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbbC3Hwe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 03:52:34 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211: factor out station lookup from ieee80211_build_hdr()
Date: Mon, 30 Mar 2015 09:52:30 +0200
Message-Id: <1427701950-27977-2-git-send-email-johannes@sipsolutions.net> (sfid-20150330_095238_788610_B487C6C4)
In-Reply-To: <1427701950-27977-1-git-send-email-johannes@sipsolutions.net>
References: <1427701950-27977-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In order to look up the RA station earlier to implement a TX
fastpath, factor out the lookup from ieee80211_build_hdr().
To always have a valid station pointer, also move some of the
checks into the new function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 188 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 118 insertions(+), 70 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 018f029d0c95..e5d679f38cc1 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1789,6 +1789,91 @@ fail:
 	return NETDEV_TX_OK; /* meaning, we dealt with the skb */
 }
 
+static inline bool ieee80211_is_tdls_setup(struct sk_buff *skb)
+{
+	u16 ethertype = (skb->data[12] << 8) | skb->data[13];
+
+	return ethertype == ETH_P_TDLS &&
+	       skb->len > 14 &&
+	       skb->data[14] == WLAN_TDLS_SNAP_RFTYPE;
+}
+
+static int ieee80211_lookup_ra_sta(struct ieee80211_sub_if_data *sdata,
+				   struct sk_buff *skb,
+				   struct sta_info **sta_out)
+{
+	struct sta_info *sta;
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP_VLAN:
+		sta = rcu_dereference(sdata->u.vlan.sta);
+		if (sta) {
+			*sta_out = sta;
+			return 0;
+		} else if (sdata->wdev.use_4addr) {
+			return -ENOLINK;
+		}
+		/* fall through */
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_OCB:
+	case NL80211_IFTYPE_ADHOC:
+		if (is_multicast_ether_addr(skb->data)) {
+			*sta_out = ERR_PTR(-ENOENT);
+			return 0;
+		}
+		sta = sta_info_get_bss(sdata, skb->data);
+		break;
+	case NL80211_IFTYPE_WDS:
+		sta = sta_info_get(sdata, sdata->u.wds.remote_addr);
+		break;
+#ifdef CONFIG_MAC80211_MESH
+	case NL80211_IFTYPE_MESH_POINT:
+		/* determined much later */
+		*sta_out = NULL;
+		return 0;
+#endif
+	case NL80211_IFTYPE_STATION:
+		if (sdata->wdev.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) {
+			sta = sta_info_get(sdata, skb->data);
+			if (sta) {
+				bool tdls_peer, tdls_auth;
+
+				tdls_peer = test_sta_flag(sta,
+							  WLAN_STA_TDLS_PEER);
+				tdls_auth = test_sta_flag(sta,
+						WLAN_STA_TDLS_PEER_AUTH);
+
+				if (tdls_peer && tdls_auth) {
+					*sta_out = sta;
+					return 0;
+				}
+
+				/*
+				 * TDLS link during setup - throw out frames to
+				 * peer. Allow TDLS-setup frames to unauthorized
+				 * peers for the special case of a link teardown
+				 * after a TDLS sta is removed due to being
+				 * unreachable.
+				 */
+				if (tdls_peer && !tdls_auth &&
+				    !ieee80211_is_tdls_setup(skb))
+					return -EINVAL;
+			}
+
+		}
+
+		sta = sta_info_get(sdata, sdata->u.mgd.bssid);
+		if (!sta)
+			return -ENOLINK;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	*sta_out = sta ?: ERR_PTR(-ENOENT);
+	return 0;
+}
+
 /**
  * ieee80211_build_hdr - build 802.11 header in the given frame
  * @sdata: virtual interface to build the header for
@@ -1809,7 +1894,7 @@ fail:
  */
 static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 					   struct sk_buff *skb, u32 info_flags,
-					   struct sta_info **sta_out)
+					   struct sta_info *sta)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info;
@@ -1822,17 +1907,18 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	const u8 *encaps_data;
 	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos;
-	struct sta_info *sta = NULL;
-	bool wme_sta = false, authorized = false, tdls_auth = false;
-	bool tdls_peer = false, tdls_setup_frame = false;
+	bool wme_sta = false, authorized = false;
+	bool tdls_peer;
 	bool multicast;
-	bool have_station = false;
 	u16 info_id = 0;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_sub_if_data *ap_sdata;
 	enum ieee80211_band band;
 	int ret;
 
+	if (IS_ERR(sta))
+		sta = NULL;
+
 	/* convert Ethernet header to proper 802.11 header (based on
 	 * operation mode) */
 	ethertype = (skb->data[12] << 8) | skb->data[13];
@@ -1840,8 +1926,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
-		sta = rcu_dereference(sdata->u.vlan.sta);
-		if (sta) {
+		if (sdata->wdev.use_4addr) {
 			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS);
 			/* RA TA DA SA */
 			memcpy(hdr.addr1, sta->sta.addr, ETH_ALEN);
@@ -1851,11 +1936,6 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 			hdrlen = 30;
 			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
 			wme_sta = sta->sta.wme;
-			have_station = true;
-			*sta_out = sta;
-		} else if (sdata->wdev.use_4addr) {
-			ret = -ENOLINK;
-			goto free;
 		}
 		ap_sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
 					u.ap);
@@ -1865,7 +1945,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 			goto free;
 		}
 		band = chanctx_conf->def.chan->band;
-		if (sta)
+		if (sdata->wdev.use_4addr)
 			break;
 		/* fall through */
 	case NL80211_IFTYPE_AP:
@@ -1969,44 +2049,15 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		break;
 #endif
 	case NL80211_IFTYPE_STATION:
-		if (sdata->wdev.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) {
-			sta = sta_info_get(sdata, skb->data);
-			if (sta) {
-				tdls_peer = test_sta_flag(sta,
-							  WLAN_STA_TDLS_PEER);
-				tdls_auth = test_sta_flag(sta,
-						WLAN_STA_TDLS_PEER_AUTH);
-			}
-
-			if (tdls_peer)
-				tdls_setup_frame =
-					ethertype == ETH_P_TDLS &&
-					skb->len > 14 &&
-					skb->data[14] == WLAN_TDLS_SNAP_RFTYPE;
-		}
-
-		/*
-		 * TDLS link during setup - throw out frames to peer. We allow
-		 * TDLS-setup frames to unauthorized peers for the special case
-		 * of a link teardown after a TDLS sta is removed due to being
-		 * unreachable.
-		 */
-		if (tdls_peer && !tdls_auth && !tdls_setup_frame) {
-			ret = -EINVAL;
-			goto free;
-		}
+		/* we already did checks when looking up the RA STA */
+		tdls_peer = test_sta_flag(sta, WLAN_STA_TDLS_PEER);
 
-		/* send direct packets to authorized TDLS peers */
-		if (tdls_peer && tdls_auth) {
+		if (tdls_peer) {
 			/* DA SA BSSID */
 			memcpy(hdr.addr1, skb->data, ETH_ALEN);
 			memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
 			memcpy(hdr.addr3, sdata->u.mgd.bssid, ETH_ALEN);
 			hdrlen = 24;
-			have_station = true;
-			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
-			wme_sta = sta->sta.wme;
-			*sta_out = sta;
 		}  else if (sdata->u.mgd.use_4addr &&
 			    cpu_to_be16(ethertype) != sdata->control_port_protocol) {
 			fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS |
@@ -2063,30 +2114,16 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		goto free;
 	}
 
-	/*
-	 * There's no need to try to look up the destination station
-	 * if it is a multicast address. In mesh, there's no need to
-	 * look up the station at all as it always must be QoS capable
-	 * and mesh mode checks authorization later.
-	 */
 	multicast = is_multicast_ether_addr(hdr.addr1);
-	if (multicast) {
-		*sta_out = ERR_PTR(-ENOENT);
-	} else if (!have_station && !ieee80211_vif_is_mesh(&sdata->vif)) {
-		if (sdata->control_port_protocol == skb->protocol)
-			sta = sta_info_get_bss(sdata, hdr.addr1);
-		else
-			sta = sta_info_get(sdata, hdr.addr1);
-		if (sta) {
-			authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
-			wme_sta = sta->sta.wme;
-		}
-		*sta_out = sta ?: ERR_PTR(-ENOENT);
-	}
 
-	/* For mesh, the use of the QoS header is mandatory */
-	if (ieee80211_vif_is_mesh(&sdata->vif))
+	/* sta is always NULL for mesh */
+	if (sta) {
+		authorized = test_sta_flag(sta, WLAN_STA_AUTHORIZED);
+		wme_sta = sta->sta.wme;
+	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		/* For mesh, the use of the QoS header is mandatory */
 		wme_sta = true;
+	}
 
 	/* receiver does QoS (which also means we do) use it */
 	if (wme_sta) {
@@ -2259,7 +2296,7 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  u32 info_flags)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct sta_info *sta = NULL;
+	struct sta_info *sta;
 
 	if (unlikely(skb->len < ETH_HLEN)) {
 		kfree_skb(skb);
@@ -2268,7 +2305,12 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 
 	rcu_read_lock();
 
-	skb = ieee80211_build_hdr(sdata, skb, info_flags, &sta);
+	if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
+		kfree_skb(skb);
+		goto out;
+	}
+
+	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta);
 	if (IS_ERR(skb))
 		goto out;
 
@@ -2304,11 +2346,17 @@ ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 		.local = sdata->local,
 		.sdata = sdata,
 	};
-	struct sta_info *sta_ignore;
+	struct sta_info *sta;
 
 	rcu_read_lock();
 
-	skb = ieee80211_build_hdr(sdata, skb, info_flags, &sta_ignore);
+	if (ieee80211_lookup_ra_sta(sdata, skb, &sta)) {
+		kfree_skb(skb);
+		skb = ERR_PTR(-EINVAL);
+		goto out;
+	}
+
+	skb = ieee80211_build_hdr(sdata, skb, info_flags, sta);
 	if (IS_ERR(skb))
 		goto out;
 
-- 
2.1.4

