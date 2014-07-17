Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58008 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933778AbaGQOOL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:11 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so2115386wgh.15
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:10 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 05/15] mac80211: avoid adding some IEs on TDLS setup failure packets
Date: Thu, 17 Jul 2014 17:14:21 +0300
Message-Id: <1405606471-30128-6-git-send-email-arik@wizery.com> (sfid-20140717_161419_281860_40C2DA8C)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most setup-specific information elements are not to be added when a
setup frame is sent with an error status code.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 58 +++++++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 26 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 8d6c928..99d5ed3 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -63,26 +63,36 @@ static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata)
 	return capab;
 }
 
-static void ieee80211_tdls_add_link_ie(struct sk_buff *skb, const u8 *src_addr,
-				       const u8 *peer, const u8 *bssid)
+static void ieee80211_tdls_add_link_ie(struct ieee80211_sub_if_data *sdata,
+				       struct sk_buff *skb, const u8 *peer,
+				       bool initiator)
 {
 	struct ieee80211_tdls_lnkie *lnkid;
+	const u8 *init_addr, *rsp_addr;
+
+	if (initiator) {
+		init_addr = sdata->vif.addr;
+		rsp_addr = peer;
+	} else {
+		init_addr = peer;
+		rsp_addr = sdata->vif.addr;
+	}
 
 	lnkid = (void *)skb_put(skb, sizeof(struct ieee80211_tdls_lnkie));
 
 	lnkid->ie_type = WLAN_EID_LINK_ID;
 	lnkid->ie_len = sizeof(struct ieee80211_tdls_lnkie) - 2;
 
-	memcpy(lnkid->bssid, bssid, ETH_ALEN);
-	memcpy(lnkid->init_sta, src_addr, ETH_ALEN);
-	memcpy(lnkid->resp_sta, peer, ETH_ALEN);
+	memcpy(lnkid->bssid, sdata->u.mgd.bssid, ETH_ALEN);
+	memcpy(lnkid->init_sta, init_addr, ETH_ALEN);
+	memcpy(lnkid->resp_sta, rsp_addr, ETH_ALEN);
 }
 
 static void
 ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb, const u8 *peer,
-				   u8 action_code, const u8 *extra_ies,
-				   size_t extra_ies_len)
+				   u8 action_code, bool initiator,
+				   const u8 *extra_ies, size_t extra_ies_len)
 {
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	size_t offset = 0, noffset;
@@ -140,22 +150,26 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 		pos = skb_put(skb, noffset - offset);
 		memcpy(pos, extra_ies + offset, noffset - offset);
 	}
+
+	ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
 }
 
 static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb, const u8 *peer,
-				   u8 action_code, bool initiator,
-				   const u8 *extra_ies, size_t extra_ies_len)
+				   u8 action_code, u16 status_code,
+				   bool initiator, const u8 *extra_ies,
+				   size_t extra_ies_len)
 {
-	const u8 *init_addr, *rsp_addr;
-
 	switch (action_code) {
 	case WLAN_TDLS_SETUP_REQUEST:
 	case WLAN_TDLS_SETUP_RESPONSE:
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
-		ieee80211_tdls_add_setup_start_ies(sdata, skb, peer,
-						   action_code, extra_ies,
-						   extra_ies_len);
+		if (status_code == 0)
+			ieee80211_tdls_add_setup_start_ies(sdata, skb, peer,
+							   action_code,
+							   initiator,
+							   extra_ies,
+							   extra_ies_len);
 		break;
 	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_TDLS_TEARDOWN:
@@ -163,19 +177,11 @@ static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
 		if (extra_ies_len)
 			memcpy(skb_put(skb, extra_ies_len), extra_ies,
 			       extra_ies_len);
+		if (status_code == 0 || action_code == WLAN_TDLS_TEARDOWN)
+			ieee80211_tdls_add_link_ie(sdata, skb, peer, initiator);
 		break;
 	}
 
-	if (initiator) {
-		init_addr = sdata->vif.addr;
-		rsp_addr = peer;
-	} else {
-		init_addr = peer;
-		rsp_addr = sdata->vif.addr;
-	}
-
-	ieee80211_tdls_add_link_ie(skb, init_addr, rsp_addr,
-				   sdata->u.mgd.bssid);
 }
 
 static int
@@ -368,8 +374,8 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	if (ret < 0)
 		goto fail;
 
-	ieee80211_tdls_add_ies(sdata, skb, peer, action_code, initiator,
-			       extra_ies, extra_ies_len);
+	ieee80211_tdls_add_ies(sdata, skb, peer, action_code, status_code,
+			       initiator, extra_ies, extra_ies_len);
 	if (send_direct) {
 		ieee80211_tx_skb(sdata, skb);
 		return 0;
-- 
1.9.1

