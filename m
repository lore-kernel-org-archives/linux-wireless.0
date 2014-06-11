Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47541 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397AbaFKOSn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 10:18:43 -0400
Received: by mail-wi0-f179.google.com with SMTP id cc10so1222666wib.6
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 07:18:42 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 06/10] mac80211: split tdls_mgmt function
Date: Wed, 11 Jun 2014 17:18:23 +0300
Message-Id: <1402496307-32522-6-git-send-email-arik@wizery.com> (sfid-20140611_161857_261876_7A2B513E)
In-Reply-To: <1402496307-32522-1-git-send-email-arik@wizery.com>
References: <1402496307-32522-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are setup/teardown specific actions to be done that accompany
the sending of a TDLS management packet. Split the main function to
simplify future additions.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 78 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 23 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index c4a9af3..92d203a 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -312,31 +312,21 @@ fail:
 	return ret;
 }
 
-int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
-			const u8 *peer, u8 action_code, u8 dialog_token,
-			u16 status_code, u32 peer_capability,
-			bool initiator, const u8 *extra_ies,
-			size_t extra_ies_len)
+static int
+ieee80211_tdls_mgmt_setup(struct wiphy *wiphy, struct net_device *dev,
+			  const u8 *peer, u8 action_code, u8 dialog_token,
+			  u16 status_code, u32 peer_capability, bool initiator,
+			  const u8 *extra_ies, size_t extra_ies_len)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	int ret;
 
-	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS))
-		return -ENOTSUPP;
-
-	/* make sure we are in managed mode, and associated */
-	if (sdata->vif.type != NL80211_IFTYPE_STATION ||
-	    !sdata->u.mgd.associated)
-		return -EINVAL;
-
 	mutex_lock(&local->mtx);
 
 	/* we don't support concurrent TDLS peer setups */
 	if (!is_zero_ether_addr(sdata->tdls_peer) &&
-	    !ether_addr_equal(sdata->tdls_peer, peer) &&
-	    (action_code == WLAN_TDLS_SETUP_REQUEST ||
-	     action_code == WLAN_TDLS_SETUP_RESPONSE)) {
+	    !ether_addr_equal(sdata->tdls_peer, peer)) {
 		ret = -EBUSY;
 		goto exit;
 	}
@@ -348,16 +338,58 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	if (ret < 0)
 		goto exit;
 
-	if (action_code == WLAN_TDLS_SETUP_REQUEST ||
-	    action_code == WLAN_TDLS_SETUP_RESPONSE) {
-		memcpy(sdata->tdls_peer, peer, ETH_ALEN);
-		ieee80211_queue_delayed_work(&sdata->local->hw,
-					     &sdata->tdls_peer_del_work,
-					     TDLS_PEER_SETUP_TIMEOUT);
-	}
+	memcpy(sdata->tdls_peer, peer, ETH_ALEN);
+	ieee80211_queue_delayed_work(&sdata->local->hw,
+				     &sdata->tdls_peer_del_work,
+				     TDLS_PEER_SETUP_TIMEOUT);
 
 exit:
 	mutex_unlock(&local->mtx);
+	return ret;
+}
+
+int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
+			const u8 *peer, u8 action_code, u8 dialog_token,
+			u16 status_code, u32 peer_capability,
+			bool initiator, const u8 *extra_ies,
+			size_t extra_ies_len)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	int ret;
+
+	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS))
+		return -ENOTSUPP;
+
+	/* make sure we are in managed mode, and associated */
+	if (sdata->vif.type != NL80211_IFTYPE_STATION ||
+	    !sdata->u.mgd.associated)
+		return -EINVAL;
+
+	switch (action_code) {
+	case WLAN_TDLS_SETUP_REQUEST:
+	case WLAN_TDLS_SETUP_RESPONSE:
+		ret = ieee80211_tdls_mgmt_setup(wiphy, dev, peer, action_code,
+						dialog_token, status_code,
+						peer_capability, initiator,
+						extra_ies, extra_ies_len);
+		break;
+	case WLAN_TDLS_TEARDOWN:
+	case WLAN_TDLS_SETUP_CONFIRM:
+	case WLAN_TDLS_DISCOVERY_REQUEST:
+	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
+		/* no special handling */
+		ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer,
+						      action_code,
+						      dialog_token,
+						      status_code,
+						      peer_capability,
+						      initiator, extra_ies,
+						      extra_ies_len);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
 
 	tdls_dbg(sdata, "TDLS mgmt action %d peer %pM status %d\n",
 		 action_code, peer, ret);
-- 
1.9.1

