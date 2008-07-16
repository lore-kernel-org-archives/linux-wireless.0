Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:37996 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512AbYGPBo0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 21:44:26 -0400
Received: by wf-out-1314.google.com with SMTP id 27so5533655wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2008 18:44:25 -0700 (PDT)
Subject: [PATCH 09/12] mac80211: remove IEEE80211_FC helper
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 18:44:13 -0700
Message-Id: <1216172653.6610.57.camel@brick> (sfid-20080716_034430_693962_3AAF1731)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/ieee80211_i.h |    2 -
 net/mac80211/mesh_hwmp.c   |    8 +++---
 net/mac80211/mesh_plink.c  |    4 +-
 net/mac80211/mlme.c        |   46 ++++++++++++++++++++++----------------------
 net/mac80211/tx.c          |    4 +-
 5 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3ac23b8..0a235cd 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -37,8 +37,6 @@
 
 #define WLAN_FC_DATA_PRESENT(fc) (((fc) & 0x4c) == 0x08)
 
-#define IEEE80211_FC(type, subtype) cpu_to_le16(type | subtype)
-
 struct ieee80211_local;
 
 /* Maximum number of broadcast/multicast frames to buffer when some of the
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 7fa149e..bd5d518 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -99,8 +99,8 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 	mgmt = (struct ieee80211_mgmt *)
 		skb_put(skb, 25 + sizeof(mgmt->u.action.u.mesh_action));
 	memset(mgmt, 0, 25 + sizeof(mgmt->u.action.u.mesh_action));
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_ACTION);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
 
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
@@ -178,8 +178,8 @@ int mesh_path_error_tx(u8 *dst, __le32 dst_dsn, u8 *ra,
 	mgmt = (struct ieee80211_mgmt *)
 		skb_put(skb, 25 + sizeof(mgmt->u.action.u.mesh_action));
 	memset(mgmt, 0, 25 + sizeof(mgmt->u.action.u.mesh_action));
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_ACTION);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
 
 	memcpy(mgmt->da, ra, ETH_ALEN);
 	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 9efeb1f..4a7e6d0 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -163,8 +163,8 @@ static int mesh_plink_frame_tx(struct net_device *dev,
 	mgmt = (struct ieee80211_mgmt *)
 		skb_put(skb, 25 + sizeof(mgmt->u.action.u.plink_action));
 	memset(mgmt, 0, 25 + sizeof(mgmt->u.action.u.plink_action));
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_ACTION);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
 	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
 	/* BSSID is left zeroed, wildcard value */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8f51375..61f2fa3 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -644,8 +644,8 @@ static void ieee80211_send_auth(struct net_device *dev,
 
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24 + 6);
 	memset(mgmt, 0, 24 + 6);
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_AUTH);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_AUTH);
 	if (encrypt)
 		mgmt->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
@@ -774,16 +774,16 @@ static void ieee80211_send_assoc(struct net_device *dev,
 
 	if (ifsta->flags & IEEE80211_STA_PREV_BSSID_SET) {
 		skb_put(skb, 10);
-		mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-						   IEEE80211_STYPE_REASSOC_REQ);
+		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						  IEEE80211_STYPE_REASSOC_REQ);
 		mgmt->u.reassoc_req.capab_info = cpu_to_le16(capab);
 		mgmt->u.reassoc_req.listen_interval = cpu_to_le16(1);
 		memcpy(mgmt->u.reassoc_req.current_ap, ifsta->prev_bssid,
 		       ETH_ALEN);
 	} else {
 		skb_put(skb, 4);
-		mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-						   IEEE80211_STYPE_ASSOC_REQ);
+		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						  IEEE80211_STYPE_ASSOC_REQ);
 		mgmt->u.assoc_req.capab_info = cpu_to_le16(capab);
 		mgmt->u.assoc_req.listen_interval = cpu_to_le16(1);
 	}
@@ -932,8 +932,8 @@ static void ieee80211_send_deauth(struct net_device *dev,
 	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
 	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
 	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_DEAUTH);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_DEAUTH);
 	skb_put(skb, 2);
 	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
 
@@ -961,8 +961,8 @@ static void ieee80211_send_disassoc(struct net_device *dev,
 	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
 	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
 	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_DISASSOC);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_DISASSOC);
 	skb_put(skb, 2);
 	mgmt->u.disassoc.reason_code = cpu_to_le16(reason);
 
@@ -1116,8 +1116,8 @@ static void ieee80211_send_probe_req(struct net_device *dev, u8 *dst,
 
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
 	memset(mgmt, 0, 24);
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_PROBE_REQ);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_PROBE_REQ);
 	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
 	if (dst) {
 		memcpy(mgmt->da, dst, ETH_ALEN);
@@ -1220,8 +1220,8 @@ static void ieee80211_send_addba_resp(struct net_device *dev, u8 *da, u16 tid,
 		memcpy(mgmt->bssid, dev->dev_addr, ETH_ALEN);
 	else
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					   IEEE80211_STYPE_ACTION);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
 
 	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addba_resp));
 	mgmt->u.action.category = WLAN_CATEGORY_BACK;
@@ -1269,8 +1269,8 @@ void ieee80211_send_addba_request(struct net_device *dev, const u8 *da,
 	else
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
 
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					IEEE80211_STYPE_ACTION);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
 
 	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addba_req));
 
@@ -1525,8 +1525,8 @@ void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
 		memcpy(mgmt->bssid, dev->dev_addr, ETH_ALEN);
 	else
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
-	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-					IEEE80211_STYPE_ACTION);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
 
 	skb_put(skb, 1 + sizeof(mgmt->u.action.u.delba));
 
@@ -1557,8 +1557,8 @@ void ieee80211_send_bar(struct net_device *dev, u8 *ra, u16 tid, u16 ssn)
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 	bar = (struct ieee80211_bar *)skb_put(skb, sizeof(*bar));
 	memset(bar, 0, sizeof(*bar));
-	bar->frame_control = IEEE80211_FC(IEEE80211_FTYPE_CTL,
-					IEEE80211_STYPE_BACK_REQ);
+	bar->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
+					 IEEE80211_STYPE_BACK_REQ);
 	memcpy(bar->ra, ra, ETH_ALEN);
 	memcpy(bar->ta, dev->dev_addr, ETH_ALEN);
 	bar_control |= (u16)IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL;
@@ -1802,7 +1802,7 @@ static void ieee80211_send_refuse_measurement_request(struct net_device *dev,
 	memcpy(msr_report->da, da, ETH_ALEN);
 	memcpy(msr_report->sa, dev->dev_addr, ETH_ALEN);
 	memcpy(msr_report->bssid, bssid, ETH_ALEN);
-	msr_report->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+	msr_report->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 						IEEE80211_STYPE_ACTION);
 
 	skb_put(skb, 1 + sizeof(msr_report->u.action.u.measurement));
@@ -2445,8 +2445,8 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
 		mgmt = (struct ieee80211_mgmt *)
 			skb_put(skb, 24 + sizeof(mgmt->u.beacon));
 		memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
-		mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-						   IEEE80211_STYPE_PROBE_RESP);
+		mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						  IEEE80211_STYPE_PROBE_RESP);
 		memset(mgmt->da, 0xff, ETH_ALEN);
 		memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
 		memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index bf733ed..1cb44f6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1892,8 +1892,8 @@ struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
 			goto out;
 
 		hdr = (struct ieee80211_hdr *) skb->data;
-		hdr->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
-						  IEEE80211_STYPE_BEACON);
+		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						 IEEE80211_STYPE_BEACON);
 
 		num_beacons = &ifsta->num_beacons;
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
-- 
1.5.6.3.499.geae9


