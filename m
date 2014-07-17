Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:44368 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933786AbaGQOOI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:08 -0400
Received: by mail-we0-f181.google.com with SMTP id k48so2034144wev.12
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:07 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 03/15] mac80211: consolidate TDLS IE treatment
Date: Thu, 17 Jul 2014 17:14:19 +0300
Message-Id: <1405606471-30128-4-git-send-email-arik@wizery.com> (sfid-20140717_161416_501068_31446B00)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add all information elements for TDLS discovery and setup in the same
function.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 69 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 28 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 53c235d..b61448a 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -78,13 +78,49 @@ static void ieee80211_tdls_add_link_ie(struct sk_buff *skb, const u8 *src_addr,
 	memcpy(lnkid->resp_sta, peer, ETH_ALEN);
 }
 
+static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
+				   struct sk_buff *skb, const u8 *peer,
+				   u8 action_code, bool initiator,
+				   const u8 *extra_ies, size_t extra_ies_len)
+{
+	const u8 *init_addr, *rsp_addr;
+	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+
+	switch (action_code) {
+	case WLAN_TDLS_SETUP_REQUEST:
+	case WLAN_TDLS_SETUP_RESPONSE:
+	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
+		ieee80211_add_srates_ie(sdata, skb, false, band);
+		ieee80211_add_ext_srates_ie(sdata, skb, false, band);
+		ieee80211_tdls_add_ext_capab(skb);
+		break;
+	case WLAN_TDLS_SETUP_CONFIRM:
+	case WLAN_TDLS_TEARDOWN:
+	case WLAN_TDLS_DISCOVERY_REQUEST:
+		break;
+	}
+
+	if (initiator) {
+		init_addr = sdata->vif.addr;
+		rsp_addr = peer;
+	} else {
+		init_addr = peer;
+		rsp_addr = sdata->vif.addr;
+	}
+
+	if (extra_ies_len)
+		memcpy(skb_put(skb, extra_ies_len), extra_ies, extra_ies_len);
+
+	ieee80211_tdls_add_link_ie(skb, init_addr, rsp_addr,
+				   sdata->u.mgd.bssid);
+}
+
 static int
 ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 			       const u8 *peer, u8 action_code, u8 dialog_token,
 			       u16 status_code, struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_tdls_data *tf;
 
 	tf = (void *)skb_put(skb, offsetof(struct ieee80211_tdls_data, u));
@@ -103,10 +139,6 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 		tf->u.setup_req.dialog_token = dialog_token;
 		tf->u.setup_req.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
-
-		ieee80211_add_srates_ie(sdata, skb, false, band);
-		ieee80211_add_ext_srates_ie(sdata, skb, false, band);
-		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	case WLAN_TDLS_SETUP_RESPONSE:
 		tf->category = WLAN_CATEGORY_TDLS;
@@ -117,10 +149,6 @@ ieee80211_prep_tdls_encap_data(struct wiphy *wiphy, struct net_device *dev,
 		tf->u.setup_resp.dialog_token = dialog_token;
 		tf->u.setup_resp.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
-
-		ieee80211_add_srates_ie(sdata, skb, false, band);
-		ieee80211_add_ext_srates_ie(sdata, skb, false, band);
-		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	case WLAN_TDLS_SETUP_CONFIRM:
 		tf->category = WLAN_CATEGORY_TDLS;
@@ -157,7 +185,6 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 			   u16 status_code, struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_mgmt *mgmt;
 
 	mgmt = (void *)skb_put(skb, 24);
@@ -179,10 +206,6 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 			dialog_token;
 		mgmt->u.action.u.tdls_discover_resp.capability =
 			cpu_to_le16(ieee80211_get_tdls_sta_capab(sdata));
-
-		ieee80211_add_srates_ie(sdata, skb, false, band);
-		ieee80211_add_ext_srates_ie(sdata, skb, false, band);
-		ieee80211_tdls_add_ext_capab(skb);
 		break;
 	default:
 		return -EINVAL;
@@ -202,7 +225,6 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = NULL;
 	bool send_direct;
-	const u8 *init_addr, *rsp_addr;
 	struct sta_info *sta;
 	int ret;
 
@@ -243,9 +265,6 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	if (ret < 0)
 		goto fail;
 
-	if (extra_ies_len)
-		memcpy(skb_put(skb, extra_ies_len), extra_ies, extra_ies_len);
-
 	rcu_read_lock();
 	sta = sta_info_get(sdata, peer);
 
@@ -279,21 +298,15 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 		break;
 	}
 
-	if (initiator || (sta && test_sta_flag(sta, WLAN_STA_TDLS_INITIATOR))) {
-		init_addr = sdata->vif.addr;
-		rsp_addr = peer;
-	} else {
-		init_addr = peer;
-		rsp_addr = sdata->vif.addr;
-	}
+	if (sta && test_sta_flag(sta, WLAN_STA_TDLS_INITIATOR))
+		initiator = true;
 
 	rcu_read_unlock();
 	if (ret < 0)
 		goto fail;
 
-	ieee80211_tdls_add_link_ie(skb, init_addr, rsp_addr,
-				   sdata->u.mgd.bssid);
-
+	ieee80211_tdls_add_ies(sdata, skb, peer, action_code, initiator,
+			       extra_ies, extra_ies_len);
 	if (send_direct) {
 		ieee80211_tx_skb(sdata, skb);
 		return 0;
-- 
1.9.1

