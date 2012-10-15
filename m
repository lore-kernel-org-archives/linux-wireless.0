Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab2JOSRB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 14:17:01 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Beni Lev <beni.lev@intel.com>
Subject: [PATCH 3/3] cfg80211: add cfg80211 exported function tracing
Date: Mon, 15 Oct 2012 20:17:30 +0200
Message-Id: <1350325050-6994-4-git-send-email-johannes@sipsolutions.net> (sfid-20121015_201710_842463_745BC3A8)
In-Reply-To: <1350325050-6994-1-git-send-email-johannes@sipsolutions.net>
References: <1350325050-6994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Beni Lev <beni.lev@intel.com>

Also add tracing to the API functions that drivers
(and mac80211) can call in cfg80211.

Signed-off-by: Beni Lev <beni.lev@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/chan.c    |   13 +-
 net/wireless/ibss.c    |    2 +
 net/wireless/mesh.c    |    1 +
 net/wireless/mlme.c    |   55 ++++-
 net/wireless/nl80211.c |    5 +
 net/wireless/scan.c    |   13 ++
 net/wireless/trace.h   |  536 ++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 615 insertions(+), 10 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 71c3625..48febd2 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -53,6 +53,8 @@ bool cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
 	struct ieee80211_channel *sec_chan;
 	int diff;
 
+	trace_cfg80211_can_beacon_sec_chan(wiphy, chan, channel_type);
+
 	switch (channel_type) {
 	case NL80211_CHAN_HT40PLUS:
 		diff = 20;
@@ -61,20 +63,25 @@ bool cfg80211_can_beacon_sec_chan(struct wiphy *wiphy,
 		diff = -20;
 		break;
 	default:
+		trace_cfg80211_return_bool(true);
 		return true;
 	}
 
 	sec_chan = ieee80211_get_channel(wiphy, chan->center_freq + diff);
-	if (!sec_chan)
+	if (!sec_chan) {
+		trace_cfg80211_return_bool(false);
 		return false;
+	}
 
 	/* we'll need a DFS capability later */
 	if (sec_chan->flags & (IEEE80211_CHAN_DISABLED |
 			       IEEE80211_CHAN_PASSIVE_SCAN |
 			       IEEE80211_CHAN_NO_IBSS |
-			       IEEE80211_CHAN_RADAR))
+			       IEEE80211_CHAN_RADAR)) {
+		trace_cfg80211_return_bool(false);
 		return false;
-
+	}
+	trace_cfg80211_return_bool(true);
 	return true;
 }
 EXPORT_SYMBOL(cfg80211_can_beacon_sec_chan);
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 7fda94f..27941d5 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -62,6 +62,8 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp)
 	struct cfg80211_event *ev;
 	unsigned long flags;
 
+	trace_cfg80211_ibss_joined(dev, bssid);
+
 	CFG80211_DEV_WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTING);
 
 	ev = kzalloc(sizeof(*ev), gfp);
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index a18bb34..966cfc4 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -242,6 +242,7 @@ void cfg80211_notify_new_peer_candidate(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
+	trace_cfg80211_notify_new_peer_candidate(dev, macaddr);
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_MESH_POINT))
 		return;
 
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index fbbdf2a..062b48f 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -24,6 +24,7 @@ void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len)
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_send_rx_auth(dev);
 	wdev_lock(wdev);
 
 	nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
@@ -44,6 +45,7 @@ void cfg80211_send_rx_assoc(struct net_device *dev, struct cfg80211_bss *bss,
 	u8 *ie = mgmt->u.assoc_resp.variable;
 	int ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
 
+	trace_cfg80211_send_rx_assoc(dev, bss);
 	wdev_lock(wdev);
 
 	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
@@ -100,6 +102,7 @@ void __cfg80211_send_deauth(struct net_device *dev,
 	const u8 *bssid = mgmt->bssid;
 	bool was_current = false;
 
+	trace___cfg80211_send_deauth(dev);
 	ASSERT_WDEV_LOCK(wdev);
 
 	if (wdev->current_bss &&
@@ -149,6 +152,7 @@ void __cfg80211_send_disassoc(struct net_device *dev,
 	u16 reason_code;
 	bool from_ap;
 
+	trace___cfg80211_send_disassoc(dev);
 	ASSERT_WDEV_LOCK(wdev);
 
 	nl80211_send_disassoc(rdev, dev, buf, len, GFP_KERNEL);
@@ -190,6 +194,7 @@ void cfg80211_send_unprot_deauth(struct net_device *dev, const u8 *buf,
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_send_unprot_deauth(dev);
 	nl80211_send_unprot_deauth(rdev, dev, buf, len, GFP_ATOMIC);
 }
 EXPORT_SYMBOL(cfg80211_send_unprot_deauth);
@@ -201,6 +206,7 @@ void cfg80211_send_unprot_disassoc(struct net_device *dev, const u8 *buf,
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_send_unprot_disassoc(dev);
 	nl80211_send_unprot_disassoc(rdev, dev, buf, len, GFP_ATOMIC);
 }
 EXPORT_SYMBOL(cfg80211_send_unprot_disassoc);
@@ -211,6 +217,7 @@ void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr)
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_send_auth_timeout(dev, addr);
 	wdev_lock(wdev);
 
 	nl80211_send_auth_timeout(rdev, dev, addr, GFP_KERNEL);
@@ -229,6 +236,7 @@ void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr)
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_send_assoc_timeout(dev, addr);
 	wdev_lock(wdev);
 
 	nl80211_send_assoc_timeout(rdev, dev, addr, GFP_KERNEL);
@@ -263,6 +271,7 @@ void cfg80211_michael_mic_failure(struct net_device *dev, const u8 *addr,
 	}
 #endif
 
+	trace_cfg80211_michael_mic_failure(dev, addr, key_type, key_id, tsc);
 	nl80211_michael_mic_failure(rdev, dev, addr, key_type, key_id, tsc, gfp);
 }
 EXPORT_SYMBOL(cfg80211_michael_mic_failure);
@@ -582,6 +591,8 @@ void cfg80211_ready_on_channel(struct wireless_dev *wdev, u64 cookie,
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_ready_on_channel(wdev, cookie, chan, channel_type,
+					duration);
 	nl80211_send_remain_on_channel(rdev, wdev, cookie, chan, channel_type,
 				       duration, gfp);
 }
@@ -595,6 +606,8 @@ void cfg80211_remain_on_channel_expired(struct wireless_dev *wdev, u64 cookie,
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_ready_on_channel_expired(wdev, cookie, chan,
+						channel_type);
 	nl80211_send_remain_on_channel_cancel(rdev, wdev, cookie, chan,
 					      channel_type, gfp);
 }
@@ -606,6 +619,7 @@ void cfg80211_new_sta(struct net_device *dev, const u8 *mac_addr,
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_new_sta(dev, mac_addr, sinfo);
 	nl80211_send_sta_event(rdev, dev, mac_addr, sinfo, gfp);
 }
 EXPORT_SYMBOL(cfg80211_new_sta);
@@ -615,6 +629,7 @@ void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp)
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_del_sta(dev, mac_addr);
 	nl80211_send_sta_del_event(rdev, dev, mac_addr, gfp);
 }
 EXPORT_SYMBOL(cfg80211_del_sta);
@@ -867,10 +882,13 @@ bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
 		cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_FCTL_STYPE);
 	u16 stype;
 
+	trace_cfg80211_rx_mgmt(wdev, freq, sig_mbm);
 	stype = (le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE) >> 4;
 
-	if (!(stypes->rx & BIT(stype)))
+	if (!(stypes->rx & BIT(stype))) {
+		trace_cfg80211_return_bool(false);
 		return false;
+	}
 
 	data = buf + ieee80211_hdrlen(mgmt->frame_control);
 	data_len = len - ieee80211_hdrlen(mgmt->frame_control);
@@ -901,6 +919,7 @@ bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
 
 	spin_unlock_bh(&wdev->mgmt_registrations_lock);
 
+	trace_cfg80211_return_bool(result);
 	return result;
 }
 EXPORT_SYMBOL(cfg80211_rx_mgmt);
@@ -911,6 +930,8 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_mgmt_tx_status(wdev, cookie, ack);
+
 	/* Indicate TX status of the Action frame to user space */
 	nl80211_send_mgmt_tx_status(rdev, wdev, cookie, buf, len, ack, gfp);
 }
@@ -924,6 +945,8 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_cqm_rssi_notify(dev, rssi_event);
+
 	/* Indicate roaming trigger event to user space */
 	nl80211_send_cqm_rssi_notify(rdev, dev, rssi_event, gfp);
 }
@@ -936,6 +959,8 @@ void cfg80211_cqm_pktloss_notify(struct net_device *dev,
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_cqm_pktloss_notify(dev, peer, num_packets);
+
 	/* Indicate roaming trigger event to user space */
 	nl80211_send_cqm_pktloss_notify(rdev, dev, peer, num_packets, gfp);
 }
@@ -961,6 +986,7 @@ void cfg80211_gtk_rekey_notify(struct net_device *dev, const u8 *bssid,
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_gtk_rekey_notify(dev, bssid);
 	nl80211_gtk_rekey_notify(rdev, dev, bssid, replay_ctr, gfp);
 }
 EXPORT_SYMBOL(cfg80211_gtk_rekey_notify);
@@ -972,6 +998,7 @@ void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_pmksa_candidate_notify(dev, index, bssid, preauth);
 	nl80211_pmksa_candidate_notify(rdev, dev, index, bssid, preauth, gfp);
 }
 EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
@@ -984,6 +1011,8 @@ void cfg80211_ch_switch_notify(struct net_device *dev, int freq,
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct ieee80211_channel *chan;
 
+	trace_cfg80211_ch_switch_notify(dev, freq, type);
+
 	wdev_lock(wdev);
 
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
@@ -1006,12 +1035,18 @@ bool cfg80211_rx_spurious_frame(struct net_device *dev,
 				const u8 *addr, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	bool ret;
+
+	trace_cfg80211_rx_spurious_frame(dev, addr);
 
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
-		    wdev->iftype != NL80211_IFTYPE_P2P_GO))
+		    wdev->iftype != NL80211_IFTYPE_P2P_GO)) {
+		trace_cfg80211_return_bool(false);
 		return false;
-
-	return nl80211_unexpected_frame(dev, addr, gfp);
+	}
+	ret = nl80211_unexpected_frame(dev, addr, gfp);
+	trace_cfg80211_return_bool(ret);
+	return ret;
 }
 EXPORT_SYMBOL(cfg80211_rx_spurious_frame);
 
@@ -1019,12 +1054,18 @@ bool cfg80211_rx_unexpected_4addr_frame(struct net_device *dev,
 					const u8 *addr, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	bool ret;
+
+	trace_cfg80211_rx_unexpected_4addr_frame(dev, addr);
 
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
 		    wdev->iftype != NL80211_IFTYPE_P2P_GO &&
-		    wdev->iftype != NL80211_IFTYPE_AP_VLAN))
+		    wdev->iftype != NL80211_IFTYPE_AP_VLAN)) {
+		trace_cfg80211_return_bool(false);
 		return false;
-
-	return nl80211_unexpected_4addr_frame(dev, addr, gfp);
+	}
+	ret = nl80211_unexpected_4addr_frame(dev, addr, gfp);
+	trace_cfg80211_return_bool(ret);
+	return ret;
 }
 EXPORT_SYMBOL(cfg80211_rx_unexpected_4addr_frame);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c390490..1ce40a2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8862,7 +8862,10 @@ void cfg80211_probe_status(struct net_device *dev, const u8 *addr,
 	void *hdr;
 	int err;
 
+	trace_cfg80211_probe_status(dev, addr, cookie, acked);
+
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+
 	if (!msg)
 		return;
 
@@ -8904,6 +8907,8 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
 	void *hdr;
 	u32 nlpid = ACCESS_ONCE(rdev->ap_beacons_nlpid);
 
+	trace_cfg80211_report_obss_beacon(wiphy, frame, len, freq, sig_dbm);
+
 	if (!nlpid)
 		return;
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index a957077..7f97a08 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -145,6 +145,7 @@ void __cfg80211_scan_done(struct work_struct *wk)
 
 void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
 {
+	trace_cfg80211_scan_done(request, aborted);
 	WARN_ON(request != wiphy_to_dev(request->wiphy)->scan_req);
 
 	request->aborted = aborted;
@@ -182,6 +183,7 @@ void __cfg80211_sched_scan_results(struct work_struct *wk)
 
 void cfg80211_sched_scan_results(struct wiphy *wiphy)
 {
+	trace_cfg80211_sched_scan_results(wiphy);
 	/* ignore if we're not scanning */
 	if (wiphy_to_dev(wiphy)->sched_scan_req)
 		queue_work(cfg80211_wq,
@@ -193,6 +195,8 @@ void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
+	trace_cfg80211_sched_scan_stopped(wiphy);
+
 	mutex_lock(&rdev->sched_scan_mtx);
 	__cfg80211_stop_sched_scan(rdev, true);
 	mutex_unlock(&rdev->sched_scan_mtx);
@@ -485,6 +489,9 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 	struct cfg80211_internal_bss *bss, *res = NULL;
 	unsigned long now = jiffies;
 
+	trace_cfg80211_get_bss(wiphy, channel, bssid, ssid, ssid_len, capa_mask,
+			       capa_val);
+
 	spin_lock_bh(&dev->bss_lock);
 
 	list_for_each_entry(bss, &dev->bss_list, list) {
@@ -506,6 +513,7 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 	spin_unlock_bh(&dev->bss_lock);
 	if (!res)
 		return NULL;
+	trace_cfg80211_return_bss(&res->pub);
 	return &res->pub;
 }
 EXPORT_SYMBOL(cfg80211_get_bss);
@@ -818,6 +826,7 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 	if (res->pub.capability & WLAN_CAPABILITY_ESS)
 		regulatory_hint_found_beacon(wiphy, channel, gfp);
 
+	trace_cfg80211_return_bss(&res->pub);
 	/* cfg80211_bss_update gives us a referenced result */
 	return &res->pub;
 }
@@ -830,10 +839,13 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 			  s32 signal, gfp_t gfp)
 {
 	struct cfg80211_internal_bss *res;
+
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
 	size_t privsz;
 
+	trace_cfg80211_inform_bss_frame(wiphy, channel, mgmt, len, signal);
+
 	if (WARN_ON(!mgmt))
 		return NULL;
 
@@ -887,6 +899,7 @@ cfg80211_inform_bss_frame(struct wiphy *wiphy,
 	if (res->pub.capability & WLAN_CAPABILITY_ESS)
 		regulatory_hint_found_beacon(wiphy, channel, gfp);
 
+	trace_cfg80211_return_bss(&res->pub);
 	/* cfg80211_bss_update gives us a referenced result */
 	return &res->pub;
 }
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 0940e91..857734c 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1741,6 +1741,542 @@ TRACE_EVENT(rdev_return_channel,
 		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->type)
 );
 
+/*************************************************************
+ *	     cfg80211 exported functions traces		     *
+ *************************************************************/
+
+TRACE_EVENT(cfg80211_return_bool,
+	TP_PROTO(bool ret),
+	TP_ARGS(ret),
+	TP_STRUCT__entry(
+		__field(bool, ret)
+	),
+	TP_fast_assign(
+		__entry->ret = ret;
+	),
+	TP_printk("returned %s", BOOL_TO_STR(__entry->ret))
+);
+
+DECLARE_EVENT_CLASS(cfg80211_netdev_mac_evt,
+	TP_PROTO(struct net_device *netdev, const u8 *macaddr),
+	TP_ARGS(netdev, macaddr),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(macaddr)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(macaddr, macaddr);
+	),
+	TP_printk(NETDEV_PR_FMT ", mac: " MAC_PR_FMT,
+		  NETDEV_PR_ARG, MAC_PR_ARG(macaddr))
+);
+
+DEFINE_EVENT(cfg80211_netdev_mac_evt, cfg80211_notify_new_peer_candidate,
+	TP_PROTO(struct net_device *netdev, const u8 *macaddr),
+	TP_ARGS(netdev, macaddr)
+);
+
+DECLARE_EVENT_CLASS(netdev_evt_only,
+	TP_PROTO(struct net_device *netdev),
+	TP_ARGS(netdev),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+	),
+	TP_printk(NETDEV_PR_FMT , NETDEV_PR_ARG)
+);
+
+DEFINE_EVENT(netdev_evt_only, cfg80211_send_rx_auth,
+	TP_PROTO(struct net_device *netdev),
+	TP_ARGS(netdev)
+);
+
+TRACE_EVENT(cfg80211_send_rx_assoc,
+	TP_PROTO(struct net_device *netdev, struct cfg80211_bss *bss),
+	TP_ARGS(netdev, bss),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(bssid)
+		CHAN_ENTRY
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(bssid, bss->bssid);
+		CHAN_ASSIGN(bss->channel);
+	),
+	TP_printk(NETDEV_PR_FMT MAC_PR_FMT CHAN_PR_FMT,
+		  NETDEV_PR_ARG, MAC_PR_ARG(bssid), CHAN_PR_ARG)
+);
+
+DEFINE_EVENT(netdev_evt_only, __cfg80211_send_deauth,
+	TP_PROTO(struct net_device *netdev),
+	TP_ARGS(netdev)
+);
+
+DEFINE_EVENT(netdev_evt_only, __cfg80211_send_disassoc,
+	TP_PROTO(struct net_device *netdev),
+	TP_ARGS(netdev)
+);
+
+DEFINE_EVENT(netdev_evt_only, cfg80211_send_unprot_deauth,
+	TP_PROTO(struct net_device *netdev),
+	TP_ARGS(netdev)
+);
+
+DEFINE_EVENT(netdev_evt_only, cfg80211_send_unprot_disassoc,
+	TP_PROTO(struct net_device *netdev),
+	TP_ARGS(netdev)
+);
+
+DECLARE_EVENT_CLASS(netdev_mac_evt,
+	TP_PROTO(struct net_device *netdev, const u8 *mac),
+	TP_ARGS(netdev, mac),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(mac)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(mac, mac)
+	),
+	TP_printk(NETDEV_PR_FMT ", mac: " MAC_PR_FMT,
+		  NETDEV_PR_ARG, MAC_PR_ARG(mac))
+);
+
+DEFINE_EVENT(netdev_mac_evt, cfg80211_send_auth_timeout,
+	TP_PROTO(struct net_device *netdev, const u8 *mac),
+	TP_ARGS(netdev, mac)
+);
+
+DEFINE_EVENT(netdev_mac_evt, cfg80211_send_assoc_timeout,
+	TP_PROTO(struct net_device *netdev, const u8 *mac),
+	TP_ARGS(netdev, mac)
+);
+
+TRACE_EVENT(cfg80211_michael_mic_failure,
+	TP_PROTO(struct net_device *netdev, const u8 *addr,
+		 enum nl80211_key_type key_type, int key_id, const u8 *tsc),
+	TP_ARGS(netdev, addr, key_type, key_id, tsc),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(addr)
+		__field(enum nl80211_key_type, key_type)
+		__field(int, key_id)
+		__array(u8, tsc, 6)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(addr, addr);
+		__entry->key_type = key_type;
+		__entry->key_id = key_id;
+		memcpy(__entry->tsc, tsc, 6);
+	),
+	TP_printk(NETDEV_PR_FMT MAC_PR_FMT ", key type: %d, key id: %d, tsc: %pm",
+		  NETDEV_PR_ARG, MAC_PR_ARG(addr), __entry->key_type,
+		  __entry->key_id, __entry->tsc)
+);
+
+TRACE_EVENT(cfg80211_ready_on_channel,
+	TP_PROTO(struct wireless_dev *wdev, u64 cookie,
+		 struct ieee80211_channel *chan,
+		 enum nl80211_channel_type channel_type, unsigned int duration),
+	TP_ARGS(wdev, cookie, chan, channel_type, duration),
+	TP_STRUCT__entry(
+		WDEV_ENTRY
+		__field(u64, cookie)
+		CHAN_ENTRY
+		__field(enum nl80211_channel_type, channel_type)
+		__field(unsigned int, duration)
+	),
+	TP_fast_assign(
+		WDEV_ASSIGN;
+		__entry->cookie = cookie;
+		CHAN_ASSIGN(chan);
+		__entry->channel_type = channel_type;
+		__entry->duration = duration;
+	),
+	TP_printk(WDEV_PR_FMT ", cookie: %llu, " CHAN_PR_FMT ", channel type: %d, duration: %u",
+		  WDEV_PR_ARG, __entry->cookie, CHAN_PR_ARG,
+		  __entry->channel_type, __entry->duration)
+);
+
+TRACE_EVENT(cfg80211_ready_on_channel_expired,
+	TP_PROTO(struct wireless_dev *wdev, u64 cookie,
+		 struct ieee80211_channel *chan,
+		 enum nl80211_channel_type channel_type),
+	TP_ARGS(wdev, cookie, chan, channel_type),
+	TP_STRUCT__entry(
+		WDEV_ENTRY
+		__field(u64, cookie)
+		CHAN_ENTRY
+		__field(enum nl80211_channel_type, channel_type)
+	),
+	TP_fast_assign(
+		WDEV_ASSIGN;
+		__entry->cookie = cookie;
+		CHAN_ASSIGN(chan);
+		__entry->channel_type = channel_type;
+	),
+	TP_printk(WDEV_PR_FMT ", cookie: %llu, " CHAN_PR_FMT ", channel type: %d",
+		  WDEV_PR_ARG, __entry->cookie, CHAN_PR_ARG,
+		  __entry->channel_type)
+);
+
+TRACE_EVENT(cfg80211_new_sta,
+	TP_PROTO(struct net_device *netdev, const u8 *mac_addr,
+		 struct station_info *sinfo),
+	TP_ARGS(netdev, mac_addr, sinfo),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(mac_addr)
+		SINFO_ENTRY
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(mac_addr, mac_addr);
+		SINFO_ASSIGN;
+	),
+	TP_printk(NETDEV_PR_FMT MAC_PR_FMT,
+		  NETDEV_PR_ARG, MAC_PR_ARG(mac_addr))
+);
+
+DEFINE_EVENT(cfg80211_netdev_mac_evt, cfg80211_del_sta,
+	TP_PROTO(struct net_device *netdev, const u8 *macaddr),
+	TP_ARGS(netdev, macaddr)
+);
+
+TRACE_EVENT(cfg80211_rx_mgmt,
+	TP_PROTO(struct wireless_dev *wdev, int freq, int sig_mbm),
+	TP_ARGS(wdev, freq, sig_mbm),
+	TP_STRUCT__entry(
+		WDEV_ENTRY
+		__field(int, freq)
+		__field(int, sig_mbm)
+	),
+	TP_fast_assign(
+		WDEV_ASSIGN;
+		__entry->freq = freq;
+		__entry->sig_mbm = sig_mbm;
+	),
+	TP_printk(WDEV_PR_FMT ", freq: %d, sig mbm: %d",
+		  WDEV_PR_ARG, __entry->freq, __entry->sig_mbm)
+);
+
+TRACE_EVENT(cfg80211_mgmt_tx_status,
+	TP_PROTO(struct wireless_dev *wdev, u64 cookie, bool ack),
+	TP_ARGS(wdev, cookie, ack),
+	TP_STRUCT__entry(
+		WDEV_ENTRY
+		__field(u64, cookie)
+		__field(bool, ack)
+	),
+	TP_fast_assign(
+		WDEV_ASSIGN;
+		__entry->cookie = cookie;
+		__entry->ack = ack;
+	),
+	TP_printk(WDEV_PR_FMT", cookie: %llu, ack: %s",
+		  WDEV_PR_ARG, __entry->cookie, BOOL_TO_STR(__entry->ack))
+);
+
+TRACE_EVENT(cfg80211_cqm_rssi_notify,
+	TP_PROTO(struct net_device *netdev,
+		 enum nl80211_cqm_rssi_threshold_event rssi_event),
+	TP_ARGS(netdev, rssi_event),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		__field(enum nl80211_cqm_rssi_threshold_event, rssi_event)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		__entry->rssi_event = rssi_event;
+	),
+	TP_printk(NETDEV_PR_FMT ", rssi event: %d",
+		  NETDEV_PR_ARG, __entry->rssi_event)
+);
+
+TRACE_EVENT(cfg80211_can_beacon_sec_chan,
+	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *channel,
+		 enum nl80211_channel_type channel_type),
+	TP_ARGS(wiphy, channel, channel_type),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		CHAN_ENTRY
+		__field(enum nl80211_channel_type, channel_type)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		CHAN_ASSIGN(channel);
+		__entry->channel_type = channel_type;
+	),
+	TP_printk(WIPHY_PR_FMT CHAN_PR_FMT ", channel_type: %d",
+		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->channel_type)
+);
+
+TRACE_EVENT(cfg80211_ch_switch_notify,
+	TP_PROTO(struct net_device *netdev, int freq,
+		 enum nl80211_channel_type type),
+	TP_ARGS(netdev, freq, type),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		__field(int, freq)
+		__field(enum nl80211_channel_type, type)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		__entry->freq = freq;
+		__entry->type = type;
+	),
+	TP_printk(NETDEV_PR_FMT ", freq: %d, type: %d", NETDEV_PR_ARG,
+		  __entry->freq, __entry->type)
+);
+
+DECLARE_EVENT_CLASS(cfg80211_rx_evt,
+	TP_PROTO(struct net_device *netdev, const u8 *addr),
+	TP_ARGS(netdev, addr),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(addr)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(addr, addr);
+	),
+	TP_printk(NETDEV_PR_FMT MAC_PR_FMT, NETDEV_PR_ARG, MAC_PR_ARG(addr))
+);
+
+DEFINE_EVENT(cfg80211_rx_evt, cfg80211_ibss_joined,
+	TP_PROTO(struct net_device *netdev, const u8 *addr),
+	TP_ARGS(netdev, addr)
+);
+
+DEFINE_EVENT(cfg80211_rx_evt, cfg80211_rx_spurious_frame,
+	TP_PROTO(struct net_device *netdev, const u8 *addr),
+	TP_ARGS(netdev, addr)
+);
+
+DEFINE_EVENT(cfg80211_rx_evt, cfg80211_rx_unexpected_4addr_frame,
+	TP_PROTO(struct net_device *netdev, const u8 *addr),
+	TP_ARGS(netdev, addr)
+);
+
+TRACE_EVENT(cfg80211_probe_status,
+	TP_PROTO(struct net_device *netdev, const u8 *addr, u64 cookie,
+		 bool acked),
+	TP_ARGS(netdev, addr, cookie, acked),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(addr)
+		__field(u64, cookie)
+		__field(bool, acked)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(addr, addr);
+		__entry->cookie = cookie;
+		__entry->acked = acked;
+	),
+	TP_printk(NETDEV_PR_FMT MAC_PR_FMT ", cookie: %llu, acked: %s",
+		  NETDEV_PR_ARG, MAC_PR_ARG(addr), __entry->cookie,
+		  BOOL_TO_STR(__entry->acked))
+);
+
+TRACE_EVENT(cfg80211_cqm_pktloss_notify,
+	TP_PROTO(struct net_device *netdev, const u8 *peer, u32 num_packets),
+	TP_ARGS(netdev, peer, num_packets),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(u32, num_packets)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->num_packets = num_packets;
+	),
+	TP_printk(NETDEV_PR_FMT ", peer: " MAC_PR_FMT ", num of lost packets: %u",
+		  NETDEV_PR_ARG, MAC_PR_ARG(peer), __entry->num_packets)
+);
+
+DEFINE_EVENT(cfg80211_netdev_mac_evt, cfg80211_gtk_rekey_notify,
+	TP_PROTO(struct net_device *netdev, const u8 *macaddr),
+	TP_ARGS(netdev, macaddr)
+);
+
+TRACE_EVENT(cfg80211_pmksa_candidate_notify,
+	TP_PROTO(struct net_device *netdev, int index, const u8 *bssid,
+		 bool preauth),
+	TP_ARGS(netdev, index, bssid, preauth),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		__field(int, index)
+		MAC_ENTRY(bssid)
+		__field(bool, preauth)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		__entry->index = index;
+		MAC_ASSIGN(bssid, bssid);
+		__entry->preauth = preauth;
+	),
+	TP_printk(NETDEV_PR_FMT ", index:%d, bssid: " MAC_PR_FMT ", pre auth: %s",
+		  NETDEV_PR_ARG, __entry->index, MAC_PR_ARG(bssid),
+		  BOOL_TO_STR(__entry->preauth))
+);
+
+TRACE_EVENT(cfg80211_report_obss_beacon,
+	TP_PROTO(struct wiphy *wiphy, const u8 *frame, size_t len,
+		 int freq, int sig_dbm),
+	TP_ARGS(wiphy, frame, len, freq, sig_dbm),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		__field(int, freq)
+		__field(int, sig_dbm)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		__entry->freq = freq;
+		__entry->sig_dbm = sig_dbm;
+	),
+	TP_printk(WIPHY_PR_FMT ", freq: %d, sig_dbm: %d",
+		  WIPHY_PR_ARG, __entry->freq, __entry->sig_dbm)
+);
+
+TRACE_EVENT(cfg80211_scan_done,
+	TP_PROTO(struct cfg80211_scan_request *request, bool aborted),
+	TP_ARGS(request, aborted),
+	TP_STRUCT__entry(
+		__field(u32, n_channels)
+		__dynamic_array(u8, ie, request ? request->ie_len : 0)
+		__array(u32, rates, IEEE80211_NUM_BANDS)
+		__field(u32, wdev_id)
+		MAC_ENTRY(wiphy_mac)
+		__field(bool, no_cck)
+		__field(bool, aborted)
+	),
+	TP_fast_assign(
+		if (request) {
+			memcpy(__get_dynamic_array(ie), request->ie,
+			       request->ie_len);
+			memcpy(__entry->rates, request->rates,
+			       IEEE80211_NUM_BANDS);
+			__entry->wdev_id = request->wdev ?
+					request->wdev->identifier : 0;
+			if (request->wiphy)
+				MAC_ASSIGN(wiphy_mac,
+					   request->wiphy->perm_addr);
+			__entry->no_cck = request->no_cck;
+		}
+		__entry->aborted = aborted;
+	),
+	TP_printk("aborted: %s", BOOL_TO_STR(__entry->aborted))
+);
+
+DEFINE_EVENT(wiphy_only_evt, cfg80211_sched_scan_results,
+	TP_PROTO(struct wiphy *wiphy),
+	TP_ARGS(wiphy)
+);
+
+DEFINE_EVENT(wiphy_only_evt, cfg80211_sched_scan_stopped,
+	TP_PROTO(struct wiphy *wiphy),
+	TP_ARGS(wiphy)
+);
+
+TRACE_EVENT(cfg80211_get_bss,
+	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *channel,
+		 const u8 *bssid, const u8 *ssid, size_t ssid_len,
+		 u16 capa_mask, u16 capa_val),
+	TP_ARGS(wiphy, channel, bssid, ssid, ssid_len, capa_mask, capa_val),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		CHAN_ENTRY
+		MAC_ENTRY(bssid)
+		__dynamic_array(u8, ssid, ssid_len)
+		__field(u16, capa_mask)
+		__field(u16, capa_val)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		CHAN_ASSIGN(channel);
+		MAC_ASSIGN(bssid, bssid);
+		memcpy(__get_dynamic_array(ssid), ssid, ssid_len);
+		__entry->capa_mask = capa_mask;
+		__entry->capa_val = capa_val;
+	),
+	TP_printk(WIPHY_PR_FMT CHAN_PR_FMT MAC_PR_FMT ", buf: %#.2x, "
+		  "capa_mask: %d, capa_val: %u", WIPHY_PR_ARG, CHAN_PR_ARG,
+		  MAC_PR_ARG(bssid), ((u8 *)__get_dynamic_array(ssid))[0],
+		  __entry->capa_mask, __entry->capa_val)
+);
+
+TRACE_EVENT(cfg80211_inform_bss_frame,
+	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *channel,
+		 struct ieee80211_mgmt *mgmt, size_t len,
+		 s32 signal),
+	TP_ARGS(wiphy, channel, mgmt, len, signal),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		CHAN_ENTRY
+		__dynamic_array(u8, mgmt, len)
+		__field(s32, signal)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		CHAN_ASSIGN(channel);
+		if (mgmt)
+			memcpy(__get_dynamic_array(mgmt), mgmt, len);
+		__entry->signal = signal;
+	),
+	TP_printk(WIPHY_PR_FMT CHAN_PR_FMT "signal: %d",
+		  WIPHY_PR_ARG, CHAN_PR_ARG, __entry->signal)
+);
+
+DECLARE_EVENT_CLASS(cfg80211_bss_evt,
+	TP_PROTO(struct cfg80211_bss *pub),
+	TP_ARGS(pub),
+	TP_STRUCT__entry(
+		MAC_ENTRY(bssid)
+		CHAN_ENTRY
+	),
+	TP_fast_assign(
+		MAC_ASSIGN(bssid, pub->bssid);
+		CHAN_ASSIGN(pub->channel);
+	),
+	TP_printk(MAC_PR_FMT CHAN_PR_FMT, MAC_PR_ARG(bssid), CHAN_PR_ARG)
+);
+
+DEFINE_EVENT(cfg80211_bss_evt, cfg80211_return_bss,
+	TP_PROTO(struct cfg80211_bss *pub),
+	TP_ARGS(pub)
+);
+
+TRACE_EVENT(cfg80211_return_uint,
+	TP_PROTO(unsigned int ret),
+	TP_ARGS(ret),
+	TP_STRUCT__entry(
+		__field(unsigned int, ret)
+	),
+	TP_fast_assign(
+		__entry->ret = ret;
+	),
+	TP_printk("ret: %d", __entry->ret)
+);
+
+TRACE_EVENT(cfg80211_return_u32,
+	TP_PROTO(u32 ret),
+	TP_ARGS(ret),
+	TP_STRUCT__entry(
+		__field(u32, ret)
+	),
+	TP_fast_assign(
+		__entry->ret = ret;
+	),
+	TP_printk("ret: %u", __entry->ret)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.10.4

