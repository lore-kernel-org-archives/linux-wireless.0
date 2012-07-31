Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2GaOVQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 10:21:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use eth_broadcast_addr
Date: Tue, 31 Jul 2012 16:21:11 +0200
Message-Id: <1343744471-5910-1-git-send-email-johannes@sipsolutions.net> (sfid-20120731_162119_446571_FCF4993F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of memset().

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c          |    2 +-
 net/mac80211/ibss.c         |    2 +-
 net/mac80211/mesh_pathtbl.c |    2 +-
 net/mac80211/tx.c           |    6 +++---
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5583f5b..df64b45 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -950,7 +950,7 @@ static void ieee80211_send_layer2_update(struct sta_info *sta)
 	/* 802.2 Type 1 Logical Link Control (LLC) Exchange Identifier (XID)
 	 * Update response frame; IEEE Std 802.2-1998, 5.4.1.2.1 */
 
-	memset(msg->da, 0xff, ETH_ALEN);
+	eth_broadcast_addr(msg->da);
 	memcpy(msg->sa, sta->sta.addr, ETH_ALEN);
 	msg->len = htons(6);
 	msg->dsap = 0;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d062085..1ebda2f 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -109,7 +109,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_PROBE_RESP);
-	memset(mgmt->da, 0xff, ETH_ALEN);
+	eth_broadcast_addr(mgmt->da);
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	memcpy(mgmt->bssid, ifibss->bssid, ETH_ALEN);
 	mgmt->u.beacon.beacon_int = cpu_to_le16(beacon_int);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 075bc53..bec7b28 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -531,7 +531,7 @@ int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 
 	read_lock_bh(&pathtbl_resize_lock);
 	memcpy(new_mpath->dst, dst, ETH_ALEN);
-	memset(new_mpath->rann_snd_addr, 0xff, ETH_ALEN);
+	eth_broadcast_addr(new_mpath->rann_snd_addr);
 	new_mpath->is_root = false;
 	new_mpath->sdata = sdata;
 	new_mpath->flags = 0;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5b81660..7dbcf29 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2415,7 +2415,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		memset(mgmt, 0, hdr_len);
 		mgmt->frame_control =
 		    cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
-		memset(mgmt->da, 0xff, ETH_ALEN);
+		eth_broadcast_addr(mgmt->da);
 		memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
 		mgmt->u.beacon.beacon_int =
@@ -2609,9 +2609,9 @@ struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					 IEEE80211_STYPE_PROBE_REQ);
-	memset(hdr->addr1, 0xff, ETH_ALEN);
+	eth_broadcast_addr(hdr->addr1);
 	memcpy(hdr->addr2, vif->addr, ETH_ALEN);
-	memset(hdr->addr3, 0xff, ETH_ALEN);
+	eth_broadcast_addr(hdr->addr3);
 
 	pos = skb_put(skb, ie_ssid_len);
 	*pos++ = WLAN_EID_SSID;
-- 
1.7.10.4

