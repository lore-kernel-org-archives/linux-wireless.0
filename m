Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36394 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbaFKOSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 10:18:39 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so5548617wib.0
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 07:18:38 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 03/10] mac80211: cleanup TDLS state during failed setup
Date: Wed, 11 Jun 2014 17:18:20 +0300
Message-Id: <1402496307-32522-3-git-send-email-arik@wizery.com> (sfid-20140611_161843_747156_E6CE7BDB)
In-Reply-To: <1402496307-32522-1-git-send-email-arik@wizery.com>
References: <1402496307-32522-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When setting up a TDLS session, register a delayed work to remove
the peer if setup times out. Prevent concurrent setups to support this
capacity.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |   4 ++
 net/mac80211/iface.c       |   2 +
 net/mac80211/tdls.c        | 133 +++++++++++++++++++++++++++++++++++++--------
 3 files changed, 115 insertions(+), 24 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 677e9c8..b0d1d16 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -793,6 +793,9 @@ struct ieee80211_sub_if_data {
 	bool radar_required;
 	struct delayed_work dfs_cac_timer_work;
 
+	u8 tdls_peer[ETH_ALEN] __aligned(2);
+	struct delayed_work tdls_peer_del_work;
+
 	/*
 	 * AP this belongs to: self in AP mode and
 	 * corresponding AP in VLAN mode, NULL for
@@ -1865,3 +1868,4 @@ extern const struct ethtool_ops ieee80211_ethtool_ops;
 #endif
 
 #endif /* IEEE80211_I_H */
+void ieee80211_tdls_peer_del_work(struct work_struct *wk);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 00762a1..57e01dd 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1671,6 +1671,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 			  ieee80211_dfs_cac_timer_work);
 	INIT_DELAYED_WORK(&sdata->dec_tailroom_needed_wk,
 			  ieee80211_delayed_tailroom_dec);
+	INIT_DELAYED_WORK(&sdata->tdls_peer_del_work,
+			  ieee80211_tdls_peer_del_work);
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		struct ieee80211_supported_band *sband;
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 652813b..cafcbde 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -10,6 +10,27 @@
 #include <linux/ieee80211.h>
 #include "ieee80211_i.h"
 
+/* give usermode some time for retries in setting up the TDLS session */
+#define TDLS_PEER_SETUP_TIMEOUT	(15 * HZ)
+
+void ieee80211_tdls_peer_del_work(struct work_struct *wk)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local;
+
+	sdata = container_of(wk, struct ieee80211_sub_if_data,
+			     tdls_peer_del_work.work);
+	local = sdata->local;
+
+	mutex_lock(&local->mtx);
+	if (!is_zero_ether_addr(sdata->tdls_peer)) {
+		tdls_dbg(sdata, "TDLS del peer %pM\n", sdata->tdls_peer);
+		sta_info_destroy_addr(sdata, sdata->tdls_peer);
+		eth_zero_addr(sdata->tdls_peer);
+	}
+	mutex_unlock(&local->mtx);
+}
+
 static void ieee80211_tdls_add_ext_capab(struct sk_buff *skb)
 {
 	u8 *pos = (void *)skb_put(skb, 7);
@@ -168,10 +189,12 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
-int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
-			const u8 *peer, u8 action_code, u8 dialog_token,
-			u16 status_code, u32 peer_capability,
-			const u8 *extra_ies, size_t extra_ies_len)
+static int
+ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
+				const u8 *peer, u8 action_code,
+				u8 dialog_token, u16 status_code,
+				u32 peer_capability, const u8 *extra_ies,
+				size_t extra_ies_len)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -179,17 +202,6 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	bool send_direct;
 	int ret;
 
-	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS))
-		return -ENOTSUPP;
-
-	/* make sure we are in managed mode, and associated */
-	if (sdata->vif.type != NL80211_IFTYPE_STATION ||
-	    !sdata->u.mgd.associated)
-		return -EINVAL;
-
-	tdls_dbg(sdata, "TDLS mgmt action %d peer %pM\n",
-		 action_code, peer);
-
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
 			    max(sizeof(struct ieee80211_mgmt),
 				sizeof(struct ieee80211_tdls_data)) +
@@ -284,11 +296,64 @@ fail:
 	return ret;
 }
 
+int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
+			const u8 *peer, u8 action_code, u8 dialog_token,
+			u16 status_code, u32 peer_capability,
+			const u8 *extra_ies, size_t extra_ies_len)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
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
+	mutex_lock(&local->mtx);
+
+	/* we don't support concurrent TDLS peer setups */
+	if (!is_zero_ether_addr(sdata->tdls_peer) &&
+	    !ether_addr_equal(sdata->tdls_peer, peer) &&
+	    (action_code == WLAN_TDLS_SETUP_REQUEST ||
+	     action_code == WLAN_TDLS_SETUP_RESPONSE)) {
+		ret = -EBUSY;
+		goto exit;
+	}
+
+	ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer, action_code,
+					      dialog_token, status_code,
+					      peer_capability, extra_ies,
+					      extra_ies_len);
+	if (ret < 0)
+		goto exit;
+
+	if (action_code == WLAN_TDLS_SETUP_REQUEST ||
+	    action_code == WLAN_TDLS_SETUP_RESPONSE) {
+		memcpy(sdata->tdls_peer, peer, ETH_ALEN);
+		ieee80211_queue_delayed_work(&sdata->local->hw,
+					     &sdata->tdls_peer_del_work,
+					     TDLS_PEER_SETUP_TIMEOUT);
+	}
+
+exit:
+	mutex_unlock(&local->mtx);
+
+	tdls_dbg(sdata, "TDLS mgmt action %d peer %pM status %d\n",
+		 action_code, peer, ret);
+	return ret;
+}
+
 int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, enum nl80211_tdls_operation oper)
 {
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	int ret;
 
 	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS))
 		return -ENOTSUPP;
@@ -296,6 +361,18 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EINVAL;
 
+	switch (oper) {
+	case NL80211_TDLS_ENABLE_LINK:
+	case NL80211_TDLS_DISABLE_LINK:
+		break;
+	case NL80211_TDLS_TEARDOWN:
+	case NL80211_TDLS_SETUP:
+	case NL80211_TDLS_DISCOVERY_REQ:
+		/* We don't support in-driver setup/teardown/discovery */
+		return -ENOTSUPP;
+	}
+
+	mutex_lock(&local->mtx);
 	tdls_dbg(sdata, "TDLS oper %d peer %pM\n", oper, peer);
 
 	switch (oper) {
@@ -304,22 +381,30 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		sta = sta_info_get(sdata, peer);
 		if (!sta) {
 			rcu_read_unlock();
-			return -ENOLINK;
+			ret = -ENOLINK;
+			break;
 		}
 
 		set_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH);
 		rcu_read_unlock();
+
+		WARN_ON_ONCE(is_zero_ether_addr(sdata->tdls_peer) ||
+			     !ether_addr_equal(sdata->tdls_peer, peer));
+		ret = 0;
 		break;
 	case NL80211_TDLS_DISABLE_LINK:
-		return sta_info_destroy_addr(sdata, peer);
-	case NL80211_TDLS_TEARDOWN:
-	case NL80211_TDLS_SETUP:
-	case NL80211_TDLS_DISCOVERY_REQ:
-		/* We don't support in-driver setup/teardown/discovery */
-		return -ENOTSUPP;
+		ret = sta_info_destroy_addr(sdata, peer);
+		break;
 	default:
-		return -ENOTSUPP;
+		ret = -ENOTSUPP;
+		break;
 	}
 
-	return 0;
+	if (ret == 0 && ether_addr_equal(sdata->tdls_peer, peer)) {
+		cancel_delayed_work(&sdata->tdls_peer_del_work);
+		eth_zero_addr(sdata->tdls_peer);
+	}
+
+	mutex_unlock(&local->mtx);
+	return ret;
 }
-- 
1.9.1

