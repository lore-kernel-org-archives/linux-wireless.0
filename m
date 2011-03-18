Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59323 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076Ab1CRUXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 16:23:15 -0400
Received: by mail-iw0-f174.google.com with SMTP id 34so4370073iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 13:23:15 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 5/5 v4] mac80211: New notification to discover mesh peer candidates.
Date: Fri, 18 Mar 2011 13:22:12 -0700
Message-Id: <1300479732-25920-6-git-send-email-javier@cozybit.com>
In-Reply-To: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Notify userspace when a beacon/presp is received from a suitable mesh
peer candidate for whom no sta information exists.  Userspace can then
decide to create a sta info for the candidate.  If userspace is not
ready to authenticate the peer right away, it can create the sta info
with the authenticated flag unset and set it later.

Also, modify the NEW_STATION command to accept PLINK_ACTIONS, in case
userspace wants to create stations and initiate a peer link right away
(for authenticated stations) or create a blocked station (for
debugging).

Signed-off-by: Javier Cardona <javier@cozybit.com>
Tested-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/linux/nl80211.h   |   14 +++++++++++++
 include/net/cfg80211.h    |   29 ++++++++++++++++++++++++++++
 net/mac80211/cfg.c        |    6 +++++
 net/mac80211/mesh.c       |    4 +--
 net/mac80211/mesh.h       |    3 +-
 net/mac80211/mesh_plink.c |   26 ++++++++++++++++++++----
 net/wireless/core.h       |    6 +++++
 net/wireless/mesh.c       |   41 ++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c    |   46 ++++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/nl80211.h    |    4 +++
 net/wireless/util.c       |    5 ++++
 11 files changed, 174 insertions(+), 10 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index f1bfa88..aa5e465 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -410,6 +410,16 @@
  *	notification. This event is used to indicate that an unprotected
  *	disassociation frame was dropped when MFP is in use.
  *
+ * @NL80211_CMD_NEW_PEER_CANDIDATE: Notification on the reception of a
+ *      beacon or probe response from a compatible mesh peer.  This is only
+ *      sent while no station information (sta_info) exists for the new peer
+ *      candidate and when @NL80211_MESH_SETUP_ENABLE_SECURITY is set.  On
+ *      reception of this notification, userspace may decide to create a new
+ *      station (@NL80211_CMD_NEW_STATION).  To stop this notification from
+ *      reoccurring, the userspace authentication daemon may want to create the
+ *      new station with the AUTHENTICATED flag unset and maybe change it later
+ *      depending on the authentication result.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -522,6 +532,8 @@ enum nl80211_commands {
 	NL80211_CMD_UNPROT_DEAUTHENTICATE,
 	NL80211_CMD_UNPROT_DISASSOCIATE,
 
+	NL80211_CMD_NEW_PEER_CANDIDATE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1170,6 +1182,7 @@ enum nl80211_iftype {
  * @NL80211_STA_FLAG_WME: station is WME/QoS capable
  * @NL80211_STA_FLAG_MFP: station uses management frame protection
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
+ * @NL80211_STA_FLAG_AUTHENTICATED: station is authenticated
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
 enum nl80211_sta_flags {
@@ -1178,6 +1191,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_SHORT_PREAMBLE,
 	NL80211_STA_FLAG_WME,
 	NL80211_STA_FLAG_MFP,
+	NL80211_STA_FLAG_AUTHENTICATED,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2334985..e4453c2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2451,6 +2451,35 @@ void cfg80211_michael_mic_failure(struct net_device *dev, const u8 *addr,
 void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp);
 
 /**
+ * cfg80211_notify_new_candidate - notify cfg80211 of a new mesh peer candidate
+ *
+ * @dev: network device
+ * @macaddr: the MAC address of the new candidate
+ * @ie: information elements advertised by the peer candidate
+ * @ie_len: lenght of the information elements buffer
+ * @gfp: allocation flags
+ *
+ * This function notifies cfg80211 that the mesh peer candidate has been
+ * detected, most likely via a beacon or, less likely, via a probe response.
+ * cfg80211 then sends a notification to userspace.
+ */
+void cfg80211_notify_new_peer_candidate(struct net_device *dev,
+		const u8 *macaddr, const u8 *ie, u8 ie_len, gfp_t gfp);
+
+/**
+ * __cfg80211_notify_new_candidate - see cfg80211_notify_new_candidate
+ *
+ * @dev: network device
+ * @macaddr: the MAC address of the new candidate
+ * @ie: information elements advertised by the peer candidate
+ * @ie_len: lenght of the information elements buffer
+ *
+ * Like cfg80211_notify_new_candidate(), but doesn't take the wdev lock.
+ */
+void __cfg80211_notify_new_peer_candidate(struct net_device *dev,
+		const u8 *macaddr, const u8 *ie, u8 ie_len);
+
+/**
  * DOC: RFkill integration
  *
  * RFkill integration in cfg80211 is almost invisible to drivers,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4f73085..c57d653 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -675,6 +675,12 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 		if (set & BIT(NL80211_STA_FLAG_MFP))
 			sta->flags |= WLAN_STA_MFP;
 	}
+
+	if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED)) {
+		sta->flags &= ~WLAN_STA_AUTH;
+		if (set & BIT(NL80211_STA_FLAG_AUTHENTICATED))
+			sta->flags |= WLAN_STA_AUTH;
+	}
 	spin_unlock_irqrestore(&sta->flaglock, flags);
 
 	/*
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 47a26c0..1120797 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -590,9 +590,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (elems.mesh_id && elems.mesh_config &&
 	    mesh_matches_local(&elems, sdata)) {
 		supp_rates = ieee80211_sta_get_rates(local, &elems, band);
-
-		mesh_neighbour_update(mgmt->sa, supp_rates, sdata,
-				      mesh_peer_accepts_plinks(&elems));
+		mesh_neighbour_update(mgmt->sa, supp_rates, sdata, &elems);
 	}
 }
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index b99e230..10acf1c 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -226,7 +226,8 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata);
 /* Mesh plinks */
 void mesh_neighbour_update(u8 *hw_addr, u32 rates,
-		struct ieee80211_sub_if_data *sdata, bool add);
+		struct ieee80211_sub_if_data *sdata,
+		struct ieee802_11_elems *ie);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
 void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index b4b1c53..84e5b05 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -237,8 +237,9 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void mesh_neighbour_update(u8 *hw_addr, u32 rates, struct ieee80211_sub_if_data *sdata,
-			   bool peer_accepting_plinks)
+void mesh_neighbour_update(u8 *hw_addr, u32 rates,
+		struct ieee80211_sub_if_data *sdata,
+		struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
@@ -248,8 +249,13 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates, struct ieee80211_sub_if_data
 	sta = sta_info_get(sdata, hw_addr);
 	if (!sta) {
 		rcu_read_unlock();
-		/* Userspace handles peer allocation when security is enabled */
-		if (!sdata->u.mesh.is_secure)
+		/* Userspace handles peer allocation when security is enabled
+		 * */
+		if (sdata->u.mesh.is_secure)
+			cfg80211_notify_new_peer_candidate(sdata->dev, hw_addr,
+					elems->ie_start, elems->total_len,
+					GFP_KERNEL);
+		else
 			sta = mesh_plink_alloc(sdata, hw_addr, rates);
 		if (!sta)
 			return;
@@ -261,7 +267,8 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates, struct ieee80211_sub_if_data
 
 	sta->last_rx = jiffies;
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
-	if (peer_accepting_plinks && sta->plink_state == PLINK_LISTEN &&
+	if (mesh_peer_accepts_plinks(elems) &&
+			sta->plink_state == PLINK_LISTEN &&
 			sdata->u.mesh.accepting_plinks &&
 			sdata->u.mesh.mshcfg.auto_open_plinks)
 		mesh_plink_open(sta);
@@ -373,6 +380,9 @@ int mesh_plink_open(struct sta_info *sta)
 	__le16 llid;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
+	if (!test_sta_flags(sta, WLAN_STA_AUTH))
+		return -EPERM;
+
 	spin_lock_bh(&sta->lock);
 	get_random_bytes(&llid, 2);
 	sta->llid = llid;
@@ -485,6 +495,12 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		return;
 	}
 
+	if (sta && !test_sta_flags(sta, WLAN_STA_AUTH)) {
+		mpl_dbg("Mesh plink: Action frame from non-authed peer\n");
+		rcu_read_unlock();
+		return;
+	}
+
 	if (sta && sta->plink_state == PLINK_BLOCKED) {
 		rcu_read_unlock();
 		return;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 26a0a08..5ee28ae 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -213,6 +213,7 @@ enum cfg80211_event_type {
 	EVENT_ROAMED,
 	EVENT_DISCONNECTED,
 	EVENT_IBSS_JOINED,
+	EVENT_NEW_CANDIDATE,
 };
 
 struct cfg80211_event {
@@ -243,6 +244,11 @@ struct cfg80211_event {
 		struct {
 			u8 bssid[ETH_ALEN];
 		} ij;
+		struct {
+			u8 macaddr[ETH_ALEN];
+			const u8 *ie;
+			size_t ie_len;
+		} nc;
 	};
 };
 
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index c51e3c5..2a41b2a 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -1,5 +1,6 @@
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
+#include "nl80211.h"
 #include "core.h"
 
 /* Default values, timeouts in ms */
@@ -106,6 +107,46 @@ int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	return err;
 }
 
+void __cfg80211_notify_new_peer_candidate(struct net_device *dev,
+		const u8 *macaddr, const u8* ie, u8 ie_len)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_MESH_POINT))
+		return;
+
+	nl80211_send_new_peer_candidate(wiphy_to_dev(wdev->wiphy), dev,
+			macaddr, ie, ie_len, GFP_KERNEL);
+	kfree(ie);
+}
+
+void cfg80211_notify_new_peer_candidate(struct net_device *dev,
+		const u8 *macaddr, const u8* ie, u8 ie_len, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_event *ev;
+	unsigned long flags;
+
+	ev = kzalloc(sizeof(*ev), gfp);
+	if (!ev)
+		return;
+	ev->type = EVENT_NEW_CANDIDATE;
+	memcpy(ev->nc.macaddr, macaddr, ETH_ALEN);
+	if (ie_len && ie) {
+		ev->nc.ie = kmemdup(ie, ie_len, gfp);
+		ev->nc.ie_len = (ev->nc.ie) ? ie_len : 0;
+	}
+
+	spin_lock_irqsave(&wdev->event_lock, flags);
+	list_add_tail(&ev->list, &wdev->event_list);
+	spin_unlock_irqrestore(&wdev->event_lock, flags);
+	queue_work(cfg80211_wq, &rdev->event_work);
+
+	return;
+}
+EXPORT_SYMBOL(cfg80211_notify_new_peer_candidate);
+
 static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev)
 {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 316e08f..fd10658 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1922,6 +1922,7 @@ static const struct nla_policy sta_flags_policy[NL80211_STA_FLAG_MAX + 1] = {
 	[NL80211_STA_FLAG_SHORT_PREAMBLE] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_WME] = { .type = NLA_FLAG },
 	[NL80211_STA_FLAG_MFP] = { .type = NLA_FLAG },
+	[NL80211_STA_FLAG_AUTHENTICATED] = { .type = NLA_FLAG },
 };
 
 static int parse_station_flags(struct genl_info *info,
@@ -2262,7 +2263,8 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 			err = -EINVAL;
 		if (params.supported_rates)
 			err = -EINVAL;
-		if (params.sta_flags_mask)
+		if (params.sta_flags_mask &
+				~BIT(NL80211_STA_FLAG_AUTHENTICATED))
 			err = -EINVAL;
 		break;
 	default:
@@ -2324,6 +2326,10 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		params.ht_capa =
 			nla_data(info->attrs[NL80211_ATTR_HT_CAPABILITY]);
 
+	if (info->attrs[NL80211_ATTR_STA_PLINK_ACTION])
+		params.plink_action =
+		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
+
 	if (parse_station_flags(info, &params))
 		return -EINVAL;
 
@@ -5789,6 +5795,44 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 	nlmsg_free(msg);
 }
 
+void nl80211_send_new_peer_candidate(struct cfg80211_registered_device *rdev,
+		struct net_device *netdev,
+		const u8 *macaddr, const u8* ie, u8 ie_len,
+		gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NEW_PEER_CANDIDATE);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, macaddr);
+	if (ie_len && ie)
+		NLA_PUT(msg, NL80211_ATTR_IE, ie_len , ie);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
 void nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 				 struct net_device *netdev, const u8 *addr,
 				 enum nl80211_key_type key_type, int key_id,
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index e3f7fa8..b7710b5 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -50,6 +50,10 @@ void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev, u16 reason,
 			       const u8 *ie, size_t ie_len, bool from_ap);
 
+void nl80211_send_new_peer_candidate(struct cfg80211_registered_device *rdev,
+				     struct net_device *netdev,
+				     const u8 *macaddr, const u8* ie, u8 ie_len,
+				     gfp_t gfp);
 void
 nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 			    struct net_device *netdev, const u8 *addr,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 6a750bc..33b9ccc 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -753,6 +753,11 @@ static void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 		case EVENT_IBSS_JOINED:
 			__cfg80211_ibss_joined(wdev->netdev, ev->ij.bssid);
 			break;
+		case EVENT_NEW_CANDIDATE:
+			__cfg80211_notify_new_peer_candidate(wdev->netdev,
+					ev->nc.macaddr, ev->nc.ie,
+					ev->nc.ie_len);
+			break;
 		}
 		wdev_unlock(wdev);
 
-- 
1.7.1

