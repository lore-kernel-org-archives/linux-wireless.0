Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60473 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab3BVVH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 16:07:29 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: move exported event functions into nl80211
Date: Fri, 22 Feb 2013 22:07:22 +0100
Message-Id: <1361567242-18718-1-git-send-email-johannes@sipsolutions.net> (sfid-20130222_220733_722326_49E9F512)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is the sort of thing gcc's LTO could do, but since
we don't have that yet we can also do it manually. The
advantage is reduced code, both source and binary, e.g.
on x86-64

   text	   data	    bss	    dec	    hex	filename
 442825	  56230	    776	 499831	  7a077	cfg80211.ko (before)
 441585	  56230	    776	 498591	  79b9f	cfg80211.ko (after)

a reduction of ~1k.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/ap.c      |  62 ------------
 net/wireless/mesh.c    |  14 ---
 net/wireless/mlme.c    | 159 -----------------------------
 net/wireless/nl80211.c | 266 ++++++++++++++++++++++++++++++++++++-------------
 net/wireless/nl80211.h |  68 -------------
 5 files changed, 195 insertions(+), 374 deletions(-)

diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index a4a14e8..324e8d8 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -46,65 +46,3 @@ int cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 
 	return err;
 }
-
-void cfg80211_ch_switch_notify(struct net_device *dev,
-			       struct cfg80211_chan_def *chandef)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	trace_cfg80211_ch_switch_notify(dev, chandef);
-
-	wdev_lock(wdev);
-
-	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
-		    wdev->iftype != NL80211_IFTYPE_P2P_GO))
-		goto out;
-
-	wdev->channel = chandef->chan;
-	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL);
-out:
-	wdev_unlock(wdev);
-	return;
-}
-EXPORT_SYMBOL(cfg80211_ch_switch_notify);
-
-bool cfg80211_rx_spurious_frame(struct net_device *dev,
-				const u8 *addr, gfp_t gfp)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	bool ret;
-
-	trace_cfg80211_rx_spurious_frame(dev, addr);
-
-	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
-		    wdev->iftype != NL80211_IFTYPE_P2P_GO)) {
-		trace_cfg80211_return_bool(false);
-		return false;
-	}
-	ret = nl80211_unexpected_frame(dev, addr, gfp);
-	trace_cfg80211_return_bool(ret);
-	return ret;
-}
-EXPORT_SYMBOL(cfg80211_rx_spurious_frame);
-
-bool cfg80211_rx_unexpected_4addr_frame(struct net_device *dev,
-					const u8 *addr, gfp_t gfp)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	bool ret;
-
-	trace_cfg80211_rx_unexpected_4addr_frame(dev, addr);
-
-	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
-		    wdev->iftype != NL80211_IFTYPE_P2P_GO &&
-		    wdev->iftype != NL80211_IFTYPE_AP_VLAN)) {
-		trace_cfg80211_return_bool(false);
-		return false;
-	}
-	ret = nl80211_unexpected_4addr_frame(dev, addr, gfp);
-	trace_cfg80211_return_bool(ret);
-	return ret;
-}
-EXPORT_SYMBOL(cfg80211_rx_unexpected_4addr_frame);
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 55957a2..9688b24 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -233,20 +233,6 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
-void cfg80211_notify_new_peer_candidate(struct net_device *dev,
-		const u8 *macaddr, const u8* ie, u8 ie_len, gfp_t gfp)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-
-	trace_cfg80211_notify_new_peer_candidate(dev, macaddr);
-	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_MESH_POINT))
-		return;
-
-	nl80211_send_new_peer_candidate(wiphy_to_dev(wdev->wiphy), dev,
-			macaddr, ie, ie_len, gfp);
-}
-EXPORT_SYMBOL(cfg80211_notify_new_peer_candidate);
-
 static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev)
 {
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index caddca3..5a97ce6 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -187,30 +187,6 @@ void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len)
 }
 EXPORT_SYMBOL(cfg80211_send_disassoc);
 
-void cfg80211_send_unprot_deauth(struct net_device *dev, const u8 *buf,
-				 size_t len)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	trace_cfg80211_send_unprot_deauth(dev);
-	nl80211_send_unprot_deauth(rdev, dev, buf, len, GFP_ATOMIC);
-}
-EXPORT_SYMBOL(cfg80211_send_unprot_deauth);
-
-void cfg80211_send_unprot_disassoc(struct net_device *dev, const u8 *buf,
-				   size_t len)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	trace_cfg80211_send_unprot_disassoc(dev);
-	nl80211_send_unprot_disassoc(rdev, dev, buf, len, GFP_ATOMIC);
-}
-EXPORT_SYMBOL(cfg80211_send_unprot_disassoc);
-
 void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
@@ -577,62 +553,6 @@ void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
 	}
 }
 
-void cfg80211_ready_on_channel(struct wireless_dev *wdev, u64 cookie,
-			       struct ieee80211_channel *chan,
-			       unsigned int duration, gfp_t gfp)
-{
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	trace_cfg80211_ready_on_channel(wdev, cookie, chan, duration);
-	nl80211_send_remain_on_channel(rdev, wdev, cookie, chan, duration, gfp);
-}
-EXPORT_SYMBOL(cfg80211_ready_on_channel);
-
-void cfg80211_remain_on_channel_expired(struct wireless_dev *wdev, u64 cookie,
-					struct ieee80211_channel *chan,
-					gfp_t gfp)
-{
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	trace_cfg80211_ready_on_channel_expired(wdev, cookie, chan);
-	nl80211_send_remain_on_channel_cancel(rdev, wdev, cookie, chan, gfp);
-}
-EXPORT_SYMBOL(cfg80211_remain_on_channel_expired);
-
-void cfg80211_new_sta(struct net_device *dev, const u8 *mac_addr,
-		      struct station_info *sinfo, gfp_t gfp)
-{
-	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	trace_cfg80211_new_sta(dev, mac_addr, sinfo);
-	nl80211_send_sta_event(rdev, dev, mac_addr, sinfo, gfp);
-}
-EXPORT_SYMBOL(cfg80211_new_sta);
-
-void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp)
-{
-	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	trace_cfg80211_del_sta(dev, mac_addr);
-	nl80211_send_sta_del_event(rdev, dev, mac_addr, gfp);
-}
-EXPORT_SYMBOL(cfg80211_del_sta);
-
-void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
-			  enum nl80211_connect_failed_reason reason,
-			  gfp_t gfp)
-{
-	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	nl80211_send_conn_failed_event(rdev, dev, mac_addr, reason, gfp);
-}
-EXPORT_SYMBOL(cfg80211_conn_failed);
-
 struct cfg80211_mgmt_registration {
 	struct list_head list;
 
@@ -909,85 +829,6 @@ bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
 }
 EXPORT_SYMBOL(cfg80211_rx_mgmt);
 
-void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
-			     const u8 *buf, size_t len, bool ack, gfp_t gfp)
-{
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	trace_cfg80211_mgmt_tx_status(wdev, cookie, ack);
-
-	/* Indicate TX status of the Action frame to user space */
-	nl80211_send_mgmt_tx_status(rdev, wdev, cookie, buf, len, ack, gfp);
-}
-EXPORT_SYMBOL(cfg80211_mgmt_tx_status);
-
-void cfg80211_cqm_rssi_notify(struct net_device *dev,
-			      enum nl80211_cqm_rssi_threshold_event rssi_event,
-			      gfp_t gfp)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	trace_cfg80211_cqm_rssi_notify(dev, rssi_event);
-
-	/* Indicate roaming trigger event to user space */
-	nl80211_send_cqm_rssi_notify(rdev, dev, rssi_event, gfp);
-}
-EXPORT_SYMBOL(cfg80211_cqm_rssi_notify);
-
-void cfg80211_cqm_pktloss_notify(struct net_device *dev,
-				 const u8 *peer, u32 num_packets, gfp_t gfp)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	trace_cfg80211_cqm_pktloss_notify(dev, peer, num_packets);
-
-	/* Indicate roaming trigger event to user space */
-	nl80211_send_cqm_pktloss_notify(rdev, dev, peer, num_packets, gfp);
-}
-EXPORT_SYMBOL(cfg80211_cqm_pktloss_notify);
-
-void cfg80211_cqm_txe_notify(struct net_device *dev,
-			     const u8 *peer, u32 num_packets,
-			     u32 rate, u32 intvl, gfp_t gfp)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	nl80211_send_cqm_txe_notify(rdev, dev, peer, num_packets,
-				    rate, intvl, gfp);
-}
-EXPORT_SYMBOL(cfg80211_cqm_txe_notify);
-
-void cfg80211_gtk_rekey_notify(struct net_device *dev, const u8 *bssid,
-			       const u8 *replay_ctr, gfp_t gfp)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	trace_cfg80211_gtk_rekey_notify(dev, bssid);
-	nl80211_gtk_rekey_notify(rdev, dev, bssid, replay_ctr, gfp);
-}
-EXPORT_SYMBOL(cfg80211_gtk_rekey_notify);
-
-void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
-				     const u8 *bssid, bool preauth, gfp_t gfp)
-{
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-
-	trace_cfg80211_pmksa_candidate_notify(dev, index, bssid, preauth);
-	nl80211_pmksa_candidate_notify(rdev, dev, index, bssid, preauth, gfp);
-}
-EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
-
 void cfg80211_dfs_channels_update_work(struct work_struct *work)
 {
 	struct delayed_work *delayed_work;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4701893a..d135a55 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9120,21 +9120,31 @@ void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
 				NL80211_CMD_DISASSOCIATE, gfp);
 }
 
-void nl80211_send_unprot_deauth(struct cfg80211_registered_device *rdev,
-				struct net_device *netdev, const u8 *buf,
-				size_t len, gfp_t gfp)
+void cfg80211_send_unprot_deauth(struct net_device *dev, const u8 *buf,
+				 size_t len)
 {
-	nl80211_send_mlme_event(rdev, netdev, buf, len,
-				NL80211_CMD_UNPROT_DEAUTHENTICATE, gfp);
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	trace_cfg80211_send_unprot_deauth(dev);
+	nl80211_send_mlme_event(rdev, dev, buf, len,
+				NL80211_CMD_UNPROT_DEAUTHENTICATE, GFP_ATOMIC);
 }
+EXPORT_SYMBOL(cfg80211_send_unprot_deauth);
 
-void nl80211_send_unprot_disassoc(struct cfg80211_registered_device *rdev,
-				  struct net_device *netdev, const u8 *buf,
-				  size_t len, gfp_t gfp)
+void cfg80211_send_unprot_disassoc(struct net_device *dev, const u8 *buf,
+				   size_t len)
 {
-	nl80211_send_mlme_event(rdev, netdev, buf, len,
-				NL80211_CMD_UNPROT_DISASSOCIATE, gfp);
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	trace_cfg80211_send_unprot_disassoc(dev);
+	nl80211_send_mlme_event(rdev, dev, buf, len,
+				NL80211_CMD_UNPROT_DISASSOCIATE, GFP_ATOMIC);
 }
+EXPORT_SYMBOL(cfg80211_send_unprot_disassoc);
 
 static void nl80211_send_mlme_timeout(struct cfg80211_registered_device *rdev,
 				      struct net_device *netdev, int cmd,
@@ -9337,14 +9347,19 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
-void nl80211_send_new_peer_candidate(struct cfg80211_registered_device *rdev,
-		struct net_device *netdev,
-		const u8 *macaddr, const u8* ie, u8 ie_len,
-		gfp_t gfp)
+void cfg80211_notify_new_peer_candidate(struct net_device *dev, const u8 *addr,
+					const u8* ie, u8 ie_len, gfp_t gfp)
 {
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	struct sk_buff *msg;
 	void *hdr;
 
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_MESH_POINT))
+		return;
+
+	trace_cfg80211_notify_new_peer_candidate(dev, addr);
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
 	if (!msg)
 		return;
@@ -9356,8 +9371,8 @@ void nl80211_send_new_peer_candidate(struct cfg80211_registered_device *rdev,
 	}
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
-	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
-	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, macaddr) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, addr) ||
 	    (ie_len && ie &&
 	     nla_put(msg, NL80211_ATTR_IE, ie_len , ie)))
 		goto nla_put_failure;
@@ -9372,6 +9387,7 @@ void nl80211_send_new_peer_candidate(struct cfg80211_registered_device *rdev,
 	genlmsg_cancel(msg, hdr);
 	nlmsg_free(msg);
 }
+EXPORT_SYMBOL(cfg80211_notify_new_peer_candidate);
 
 void nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 				 struct net_device *netdev, const u8 *addr,
@@ -9510,31 +9526,42 @@ static void nl80211_send_remain_on_chan_event(
 	nlmsg_free(msg);
 }
 
-void nl80211_send_remain_on_channel(struct cfg80211_registered_device *rdev,
-				    struct wireless_dev *wdev, u64 cookie,
-				    struct ieee80211_channel *chan,
-				    unsigned int duration, gfp_t gfp)
+void cfg80211_ready_on_channel(struct wireless_dev *wdev, u64 cookie,
+			       struct ieee80211_channel *chan,
+			       unsigned int duration, gfp_t gfp)
 {
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	trace_cfg80211_ready_on_channel(wdev, cookie, chan, duration);
 	nl80211_send_remain_on_chan_event(NL80211_CMD_REMAIN_ON_CHANNEL,
 					  rdev, wdev, cookie, chan,
 					  duration, gfp);
 }
+EXPORT_SYMBOL(cfg80211_ready_on_channel);
 
-void nl80211_send_remain_on_channel_cancel(
-	struct cfg80211_registered_device *rdev,
-	struct wireless_dev *wdev,
-	u64 cookie, struct ieee80211_channel *chan, gfp_t gfp)
+void cfg80211_remain_on_channel_expired(struct wireless_dev *wdev, u64 cookie,
+					struct ieee80211_channel *chan,
+					gfp_t gfp)
 {
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	trace_cfg80211_ready_on_channel_expired(wdev, cookie, chan);
 	nl80211_send_remain_on_chan_event(NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL,
 					  rdev, wdev, cookie, chan, 0, gfp);
 }
+EXPORT_SYMBOL(cfg80211_remain_on_channel_expired);
 
-void nl80211_send_sta_event(struct cfg80211_registered_device *rdev,
-			    struct net_device *dev, const u8 *mac_addr,
-			    struct station_info *sinfo, gfp_t gfp)
+void cfg80211_new_sta(struct net_device *dev, const u8 *mac_addr,
+		      struct station_info *sinfo, gfp_t gfp)
 {
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct sk_buff *msg;
 
+	trace_cfg80211_new_sta(dev, mac_addr, sinfo);
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
 	if (!msg)
 		return;
@@ -9548,14 +9575,17 @@ void nl80211_send_sta_event(struct cfg80211_registered_device *rdev,
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, gfp);
 }
+EXPORT_SYMBOL(cfg80211_new_sta);
 
-void nl80211_send_sta_del_event(struct cfg80211_registered_device *rdev,
-				struct net_device *dev, const u8 *mac_addr,
-				gfp_t gfp)
+void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp)
 {
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct sk_buff *msg;
 	void *hdr;
 
+	trace_cfg80211_del_sta(dev, mac_addr);
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
 	if (!msg)
 		return;
@@ -9580,12 +9610,14 @@ void nl80211_send_sta_del_event(struct cfg80211_registered_device *rdev,
 	genlmsg_cancel(msg, hdr);
 	nlmsg_free(msg);
 }
+EXPORT_SYMBOL(cfg80211_del_sta);
 
-void nl80211_send_conn_failed_event(struct cfg80211_registered_device *rdev,
-				    struct net_device *dev, const u8 *mac_addr,
-				    enum nl80211_connect_failed_reason reason,
-				    gfp_t gfp)
+void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
+			  enum nl80211_connect_failed_reason reason,
+			  gfp_t gfp)
 {
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct sk_buff *msg;
 	void *hdr;
 
@@ -9614,6 +9646,7 @@ void nl80211_send_conn_failed_event(struct cfg80211_registered_device *rdev,
 	genlmsg_cancel(msg, hdr);
 	nlmsg_free(msg);
 }
+EXPORT_SYMBOL(cfg80211_conn_failed);
 
 static bool __nl80211_unexpected_frame(struct net_device *dev, u8 cmd,
 				       const u8 *addr, gfp_t gfp)
@@ -9658,19 +9691,47 @@ static bool __nl80211_unexpected_frame(struct net_device *dev, u8 cmd,
 	return true;
 }
 
-bool nl80211_unexpected_frame(struct net_device *dev, const u8 *addr, gfp_t gfp)
+bool cfg80211_rx_spurious_frame(struct net_device *dev,
+				const u8 *addr, gfp_t gfp)
 {
-	return __nl80211_unexpected_frame(dev, NL80211_CMD_UNEXPECTED_FRAME,
-					  addr, gfp);
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	bool ret;
+
+	trace_cfg80211_rx_spurious_frame(dev, addr);
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_GO)) {
+		trace_cfg80211_return_bool(false);
+		return false;
+	}
+	ret = __nl80211_unexpected_frame(dev, NL80211_CMD_UNEXPECTED_FRAME,
+					 addr, gfp);
+	trace_cfg80211_return_bool(ret);
+	return ret;
 }
+EXPORT_SYMBOL(cfg80211_rx_spurious_frame);
 
-bool nl80211_unexpected_4addr_frame(struct net_device *dev,
-				    const u8 *addr, gfp_t gfp)
+bool cfg80211_rx_unexpected_4addr_frame(struct net_device *dev,
+					const u8 *addr, gfp_t gfp)
 {
-	return __nl80211_unexpected_frame(dev,
-					  NL80211_CMD_UNEXPECTED_4ADDR_FRAME,
-					  addr, gfp);
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	bool ret;
+
+	trace_cfg80211_rx_unexpected_4addr_frame(dev, addr);
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_GO &&
+		    wdev->iftype != NL80211_IFTYPE_AP_VLAN)) {
+		trace_cfg80211_return_bool(false);
+		return false;
+	}
+	ret = __nl80211_unexpected_frame(dev,
+					 NL80211_CMD_UNEXPECTED_4ADDR_FRAME,
+					 addr, gfp);
+	trace_cfg80211_return_bool(ret);
+	return ret;
 }
+EXPORT_SYMBOL(cfg80211_rx_unexpected_4addr_frame);
 
 int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev, u32 nlportid,
@@ -9710,15 +9771,17 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 	return -ENOBUFS;
 }
 
-void nl80211_send_mgmt_tx_status(struct cfg80211_registered_device *rdev,
-				 struct wireless_dev *wdev, u64 cookie,
-				 const u8 *buf, size_t len, bool ack,
-				 gfp_t gfp)
+void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
+			     const u8 *buf, size_t len, bool ack, gfp_t gfp)
 {
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct net_device *netdev = wdev->netdev;
 	struct sk_buff *msg;
 	void *hdr;
 
+	trace_cfg80211_mgmt_tx_status(wdev, cookie, ack);
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
 	if (!msg)
 		return;
@@ -9746,17 +9809,21 @@ void nl80211_send_mgmt_tx_status(struct cfg80211_registered_device *rdev,
 	genlmsg_cancel(msg, hdr);
 	nlmsg_free(msg);
 }
+EXPORT_SYMBOL(cfg80211_mgmt_tx_status);
 
-void
-nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
-			     struct net_device *netdev,
-			     enum nl80211_cqm_rssi_threshold_event rssi_event,
-			     gfp_t gfp)
+void cfg80211_cqm_rssi_notify(struct net_device *dev,
+			      enum nl80211_cqm_rssi_threshold_event rssi_event,
+			      gfp_t gfp)
 {
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct sk_buff *msg;
 	struct nlattr *pinfoattr;
 	void *hdr;
 
+	trace_cfg80211_cqm_rssi_notify(dev, rssi_event);
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
 	if (!msg)
 		return;
@@ -9768,7 +9835,7 @@ nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
 	}
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
-	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex))
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
 
 	pinfoattr = nla_nest_start(msg, NL80211_ATTR_CQM);
@@ -9791,10 +9858,11 @@ nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
 	genlmsg_cancel(msg, hdr);
 	nlmsg_free(msg);
 }
+EXPORT_SYMBOL(cfg80211_cqm_rssi_notify);
 
-void nl80211_gtk_rekey_notify(struct cfg80211_registered_device *rdev,
-			      struct net_device *netdev, const u8 *bssid,
-			      const u8 *replay_ctr, gfp_t gfp)
+static void nl80211_gtk_rekey_notify(struct cfg80211_registered_device *rdev,
+				     struct net_device *netdev, const u8 *bssid,
+				     const u8 *replay_ctr, gfp_t gfp)
 {
 	struct sk_buff *msg;
 	struct nlattr *rekey_attr;
@@ -9836,9 +9904,22 @@ void nl80211_gtk_rekey_notify(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
-void nl80211_pmksa_candidate_notify(struct cfg80211_registered_device *rdev,
-				    struct net_device *netdev, int index,
-				    const u8 *bssid, bool preauth, gfp_t gfp)
+void cfg80211_gtk_rekey_notify(struct net_device *dev, const u8 *bssid,
+			       const u8 *replay_ctr, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	trace_cfg80211_gtk_rekey_notify(dev, bssid);
+	nl80211_gtk_rekey_notify(rdev, dev, bssid, replay_ctr, gfp);
+}
+EXPORT_SYMBOL(cfg80211_gtk_rekey_notify);
+
+static void
+nl80211_pmksa_candidate_notify(struct cfg80211_registered_device *rdev,
+			       struct net_device *netdev, int index,
+			       const u8 *bssid, bool preauth, gfp_t gfp)
 {
 	struct sk_buff *msg;
 	struct nlattr *attr;
@@ -9881,9 +9962,22 @@ void nl80211_pmksa_candidate_notify(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
-void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
-			      struct net_device *netdev,
-			      struct cfg80211_chan_def *chandef, gfp_t gfp)
+void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
+				     const u8 *bssid, bool preauth, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	trace_cfg80211_pmksa_candidate_notify(dev, index, bssid, preauth);
+	nl80211_pmksa_candidate_notify(rdev, dev, index, bssid, preauth, gfp);
+}
+EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
+
+static void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
+				     struct net_device *netdev,
+				     struct cfg80211_chan_def *chandef,
+				     gfp_t gfp)
 {
 	struct sk_buff *msg;
 	void *hdr;
@@ -9915,11 +10009,36 @@ void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
-void
-nl80211_send_cqm_txe_notify(struct cfg80211_registered_device *rdev,
-			    struct net_device *netdev, const u8 *peer,
-			    u32 num_packets, u32 rate, u32 intvl, gfp_t gfp)
+void cfg80211_ch_switch_notify(struct net_device *dev,
+			       struct cfg80211_chan_def *chandef)
 {
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	trace_cfg80211_ch_switch_notify(dev, chandef);
+
+	wdev_lock(wdev);
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_GO))
+		goto out;
+
+	wdev->channel = chandef->chan;
+	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL);
+out:
+	wdev_unlock(wdev);
+	return;
+}
+EXPORT_SYMBOL(cfg80211_ch_switch_notify);
+
+void cfg80211_cqm_txe_notify(struct net_device *dev,
+			     const u8 *peer, u32 num_packets,
+			     u32 rate, u32 intvl, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct sk_buff *msg;
 	struct nlattr *pinfoattr;
 	void *hdr;
@@ -9935,7 +10054,7 @@ nl80211_send_cqm_txe_notify(struct cfg80211_registered_device *rdev,
 	}
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
-	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
 	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, peer))
 		goto nla_put_failure;
 
@@ -9964,6 +10083,7 @@ nl80211_send_cqm_txe_notify(struct cfg80211_registered_device *rdev,
 	genlmsg_cancel(msg, hdr);
 	nlmsg_free(msg);
 }
+EXPORT_SYMBOL(cfg80211_cqm_txe_notify);
 
 void
 nl80211_radar_notify(struct cfg80211_registered_device *rdev,
@@ -10016,15 +10136,18 @@ nl80211_radar_notify(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
-void
-nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
-				struct net_device *netdev, const u8 *peer,
-				u32 num_packets, gfp_t gfp)
+void cfg80211_cqm_pktloss_notify(struct net_device *dev,
+				 const u8 *peer, u32 num_packets, gfp_t gfp)
 {
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct sk_buff *msg;
 	struct nlattr *pinfoattr;
 	void *hdr;
 
+	trace_cfg80211_cqm_pktloss_notify(dev, peer, num_packets);
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
 	if (!msg)
 		return;
@@ -10036,7 +10159,7 @@ nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 	}
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
-	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
 	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, peer))
 		goto nla_put_failure;
 
@@ -10059,6 +10182,7 @@ nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 	genlmsg_cancel(msg, hdr);
 	nlmsg_free(msg);
 }
+EXPORT_SYMBOL(cfg80211_cqm_pktloss_notify);
 
 void cfg80211_probe_status(struct net_device *dev, const u8 *addr,
 			   u64 cookie, bool acked, gfp_t gfp)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index b061da4..a4073e8 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -29,12 +29,6 @@ void nl80211_send_deauth(struct cfg80211_registered_device *rdev,
 void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
 			   struct net_device *netdev,
 			   const u8 *buf, size_t len, gfp_t gfp);
-void nl80211_send_unprot_deauth(struct cfg80211_registered_device *rdev,
-				struct net_device *netdev,
-				const u8 *buf, size_t len, gfp_t gfp);
-void nl80211_send_unprot_disassoc(struct cfg80211_registered_device *rdev,
-				  struct net_device *netdev,
-				  const u8 *buf, size_t len, gfp_t gfp);
 void nl80211_send_auth_timeout(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev,
 			       const u8 *addr, gfp_t gfp);
@@ -54,10 +48,6 @@ void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev, u16 reason,
 			       const u8 *ie, size_t ie_len, bool from_ap);
 
-void nl80211_send_new_peer_candidate(struct cfg80211_registered_device *rdev,
-				     struct net_device *netdev,
-				     const u8 *macaddr, const u8* ie, u8 ie_len,
-				     gfp_t gfp);
 void
 nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 			    struct net_device *netdev, const u8 *addr,
@@ -73,41 +63,10 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, const u8 *bssid,
 			     gfp_t gfp);
 
-void nl80211_send_remain_on_channel(struct cfg80211_registered_device *rdev,
-				    struct wireless_dev *wdev, u64 cookie,
-				    struct ieee80211_channel *chan,
-				    unsigned int duration, gfp_t gfp);
-void nl80211_send_remain_on_channel_cancel(
-	struct cfg80211_registered_device *rdev,
-	struct wireless_dev *wdev,
-	u64 cookie, struct ieee80211_channel *chan, gfp_t gfp);
-
-void nl80211_send_sta_event(struct cfg80211_registered_device *rdev,
-			    struct net_device *dev, const u8 *mac_addr,
-			    struct station_info *sinfo, gfp_t gfp);
-void nl80211_send_sta_del_event(struct cfg80211_registered_device *rdev,
-				struct net_device *dev, const u8 *mac_addr,
-				gfp_t gfp);
-
-void nl80211_send_conn_failed_event(struct cfg80211_registered_device *rdev,
-				    struct net_device *dev, const u8 *mac_addr,
-				    enum nl80211_connect_failed_reason reason,
-				    gfp_t gfp);
-
 int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev, u32 nlpid,
 		      int freq, int sig_dbm,
 		      const u8 *buf, size_t len, gfp_t gfp);
-void nl80211_send_mgmt_tx_status(struct cfg80211_registered_device *rdev,
-				 struct wireless_dev *wdev, u64 cookie,
-				 const u8 *buf, size_t len, bool ack,
-				 gfp_t gfp);
-
-void
-nl80211_send_cqm_rssi_notify(struct cfg80211_registered_device *rdev,
-			     struct net_device *netdev,
-			     enum nl80211_cqm_rssi_threshold_event rssi_event,
-			     gfp_t gfp);
 
 void
 nl80211_radar_notify(struct cfg80211_registered_device *rdev,
@@ -115,31 +74,4 @@ nl80211_radar_notify(struct cfg80211_registered_device *rdev,
 		     enum nl80211_radar_event event,
 		     struct net_device *netdev, gfp_t gfp);
 
-void
-nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
-				struct net_device *netdev, const u8 *peer,
-				u32 num_packets, gfp_t gfp);
-
-void
-nl80211_send_cqm_txe_notify(struct cfg80211_registered_device *rdev,
-			    struct net_device *netdev, const u8 *peer,
-			    u32 num_packets, u32 rate, u32 intvl, gfp_t gfp);
-
-void nl80211_gtk_rekey_notify(struct cfg80211_registered_device *rdev,
-			      struct net_device *netdev, const u8 *bssid,
-			      const u8 *replay_ctr, gfp_t gfp);
-
-void nl80211_pmksa_candidate_notify(struct cfg80211_registered_device *rdev,
-				    struct net_device *netdev, int index,
-				    const u8 *bssid, bool preauth, gfp_t gfp);
-
-void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
-			      struct net_device *dev,
-			      struct cfg80211_chan_def *chandef, gfp_t gfp);
-
-bool nl80211_unexpected_frame(struct net_device *dev,
-			      const u8 *addr, gfp_t gfp);
-bool nl80211_unexpected_4addr_frame(struct net_device *dev,
-				    const u8 *addr, gfp_t gfp);
-
 #endif /* __NET_WIRELESS_NL80211_H */
-- 
1.8.0

