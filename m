Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59835 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbaKIQuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 11:50:40 -0500
Received: by mail-wi0-f176.google.com with SMTP id h11so8431866wiw.15
        for <linux-wireless@vger.kernel.org>; Sun, 09 Nov 2014 08:50:38 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 10/16] mac80211: prepare TDLS mgmt code for channel-switch templates
Date: Sun,  9 Nov 2014 18:50:16 +0200
Message-Id: <1415551822-20121-10-git-send-email-arik@wizery.com> (sfid-20141109_181321_483809_E43279B4)
In-Reply-To: <1415551822-20121-1-git-send-email-arik@wizery.com>
References: <1415551822-20121-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split the data-generating from the Tx-sending functionality, as we do
not want to send templates to the lower driver. Also add an optional
chandef argument to the data-generating portion. It will be used for
channel-switch templates.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 net/mac80211/tdls.c | 82 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 25 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 4554bdc..fa141ae 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -453,7 +453,8 @@ static void ieee80211_tdls_add_ies(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb, const u8 *peer,
 				   u8 action_code, u16 status_code,
 				   bool initiator, const u8 *extra_ies,
-				   size_t extra_ies_len)
+				   size_t extra_ies_len, u8 oper_class,
+				   struct cfg80211_chan_def *chandef)
 {
 	switch (action_code) {
 	case WLAN_TDLS_SETUP_REQUEST:
@@ -589,22 +590,19 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-static int
-ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
-				const u8 *peer, u8 action_code,
-				u8 dialog_token, u16 status_code,
-				u32 peer_capability, bool initiator,
-				const u8 *extra_ies, size_t extra_ies_len)
+static struct sk_buff *
+ieee80211_tdls_build_mgmt_packet_data(struct ieee80211_sub_if_data *sdata,
+				      const u8 *peer, u8 action_code,
+				      u8 dialog_token, u16 status_code,
+				      bool initiator, const u8 *extra_ies,
+				      size_t extra_ies_len, u8 oper_class,
+				      struct cfg80211_chan_def *chandef)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	struct sk_buff *skb = NULL;
-	u32 flags = 0;
-	bool send_direct;
-	struct sta_info *sta;
+	struct sk_buff *skb;
 	int ret;
 
-	skb = netdev_alloc_skb(dev,
+	skb = netdev_alloc_skb(sdata->dev,
 			       local->hw.extra_tx_headroom +
 			       max(sizeof(struct ieee80211_mgmt),
 				   sizeof(struct ieee80211_tdls_data)) +
@@ -618,7 +616,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 			       extra_ies_len +
 			       sizeof(struct ieee80211_tdls_lnkie));
 	if (!skb)
-		return -ENOMEM;
+		return NULL;
 
 	skb_reserve(skb, local->hw.extra_tx_headroom);
 
@@ -628,16 +626,16 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_TDLS_TEARDOWN:
 	case WLAN_TDLS_DISCOVERY_REQUEST:
-		ret = ieee80211_prep_tdls_encap_data(wiphy, dev, peer,
+		ret = ieee80211_prep_tdls_encap_data(local->hw.wiphy,
+						     sdata->dev, peer,
 						     action_code, dialog_token,
 						     status_code, skb);
-		send_direct = false;
 		break;
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
-		ret = ieee80211_prep_tdls_direct(wiphy, dev, peer, action_code,
+		ret = ieee80211_prep_tdls_direct(local->hw.wiphy, sdata->dev,
+						 peer, action_code,
 						 dialog_token, status_code,
 						 skb);
-		send_direct = true;
 		break;
 	default:
 		ret = -ENOTSUPP;
@@ -647,6 +645,30 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	if (ret < 0)
 		goto fail;
 
+	ieee80211_tdls_add_ies(sdata, skb, peer, action_code, status_code,
+			       initiator, extra_ies, extra_ies_len, oper_class,
+			       chandef);
+	return skb;
+
+fail:
+	dev_kfree_skb(skb);
+	return NULL;
+}
+
+static int
+ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
+				const u8 *peer, u8 action_code, u8 dialog_token,
+				u16 status_code, u32 peer_capability,
+				bool initiator, const u8 *extra_ies,
+				size_t extra_ies_len, u8 oper_class,
+				struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sk_buff *skb = NULL;
+	struct sta_info *sta;
+	u32 flags = 0;
+	int ret = 0;
+
 	rcu_read_lock();
 	sta = sta_info_get(sdata, peer);
 
@@ -691,9 +713,17 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	if (ret < 0)
 		goto fail;
 
-	ieee80211_tdls_add_ies(sdata, skb, peer, action_code, status_code,
-			       initiator, extra_ies, extra_ies_len);
-	if (send_direct) {
+	skb = ieee80211_tdls_build_mgmt_packet_data(sdata, peer, action_code,
+						    dialog_token, status_code,
+						    initiator, extra_ies,
+						    extra_ies_len, oper_class,
+						    chandef);
+	if (!skb) {
+		ret = -EINVAL;
+		goto fail;
+	}
+
+	if (action_code == WLAN_PUB_ACTION_TDLS_DISCOVER_RES) {
 		ieee80211_tx_skb(sdata, skb);
 		return 0;
 	}
@@ -720,7 +750,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	 * packet through the AP.
 	 */
 	if ((action_code == WLAN_TDLS_TEARDOWN) &&
-	    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
+	    (sdata->local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS)) {
 		struct sta_info *sta = NULL;
 		bool try_resend; /* Should we keep skb for possible resend */
 
@@ -802,7 +832,8 @@ ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
 	ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer, action_code,
 					      dialog_token, status_code,
 					      peer_capability, initiator,
-					      extra_ies, extra_ies_len);
+					      extra_ies, extra_ies_len, 0,
+					      NULL);
 	if (ret < 0)
 		goto exit;
 
@@ -841,7 +872,8 @@ ieee80211_tdls_mgmt_teardown(struct wiphy *wiphy, struct net_device *dev,
 	ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer, action_code,
 					      dialog_token, status_code,
 					      peer_capability, initiator,
-					      extra_ies, extra_ies_len);
+					      extra_ies, extra_ies_len, 0,
+					      NULL);
 	if (ret < 0)
 		sdata_err(sdata, "Failed sending TDLS teardown packet %d\n",
 			  ret);
@@ -911,7 +943,7 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 						      status_code,
 						      peer_capability,
 						      initiator, extra_ies,
-						      extra_ies_len);
+						      extra_ies_len, 0, NULL);
 		break;
 	default:
 		ret = -EOPNOTSUPP;
-- 
1.9.1

