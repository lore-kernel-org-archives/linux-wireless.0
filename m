Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60800 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaDUEzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 00:55:17 -0400
Received: by mail-pa0-f53.google.com with SMTP id ld10so3320217pab.26
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 21:55:16 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 08/12] cfg80211: change function name
Date: Mon, 21 Apr 2014 12:53:03 +0800
Message-Id: <d399a064105f6250cf64d1147452e8f53b09a43d.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065556_849412_D13E5388)
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Name wiphy_to_rdev is more accurate to describe what the function
does, i.e., return a pointer pointing to struct
cfg80211_registered_device.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/wireless/chan.c        |  2 +-
 net/wireless/core.c        | 16 ++++++------
 net/wireless/core.h        |  2 +-
 net/wireless/ethtool.c     | 10 ++++----
 net/wireless/ibss.c        | 12 ++++-----
 net/wireless/mlme.c        | 24 ++++++++---------
 net/wireless/nl80211.c     | 64 +++++++++++++++++++++++-----------------------
 net/wireless/scan.c        | 24 ++++++++---------
 net/wireless/sme.c         | 37 ++++++++++++++-------------
 net/wireless/util.c        |  2 +-
 net/wireless/wext-compat.c | 32 +++++++++++------------
 net/wireless/wext-sme.c    | 10 ++++----
 12 files changed, 118 insertions(+), 117 deletions(-)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index c61bcdd..e9d8f46 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -761,7 +761,7 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 			     struct cfg80211_chan_def *chandef,
 			     enum nl80211_iftype iftype)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	bool res;
 	u32 prohibited_flags = IEEE80211_CHAN_DISABLED |
 			       IEEE80211_CHAN_RADAR;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index f7f71d9..8045ef9 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -69,7 +69,7 @@ struct cfg80211_registered_device *cfg80211_rdev_by_wiphy_idx(int wiphy_idx)
 
 int get_wiphy_idx(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	return rdev->wiphy_idx;
 }
@@ -475,7 +475,7 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 
 int wiphy_register(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	int res;
 	enum ieee80211_band band;
 	struct ieee80211_supported_band *sband;
@@ -656,7 +656,7 @@ EXPORT_SYMBOL(wiphy_register);
 
 void wiphy_rfkill_start_polling(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	if (!rdev->ops->rfkill_poll)
 		return;
@@ -667,7 +667,7 @@ EXPORT_SYMBOL(wiphy_rfkill_start_polling);
 
 void wiphy_rfkill_stop_polling(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	rfkill_pause_polling(rdev->rfkill);
 }
@@ -675,7 +675,7 @@ EXPORT_SYMBOL(wiphy_rfkill_stop_polling);
 
 void wiphy_unregister(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	wait_event(rdev->dev_wait, ({
 		int __count;
@@ -750,7 +750,7 @@ EXPORT_SYMBOL(wiphy_free);
 
 void wiphy_rfkill_set_hw_state(struct wiphy *wiphy, bool blocked)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	if (rfkill_set_hw_state(rdev->rfkill, blocked))
 		schedule_work(&rdev->rfkill_sync);
@@ -759,7 +759,7 @@ EXPORT_SYMBOL(wiphy_rfkill_set_hw_state);
 
 void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 
 	ASSERT_RTNL();
 
@@ -843,7 +843,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 	if (!wdev)
 		return NOTIFY_DONE;
 
-	rdev = wiphy_to_dev(wdev->wiphy);
+	rdev = wiphy_to_rdev(wdev->wiphy);
 
 	WARN_ON(wdev->iftype == NL80211_IFTYPE_UNSPECIFIED);
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index c65f4a9..681b8fa 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -90,7 +90,7 @@ struct cfg80211_registered_device {
 };
 
 static inline
-struct cfg80211_registered_device *wiphy_to_dev(struct wiphy *wiphy)
+struct cfg80211_registered_device *wiphy_to_rdev(struct wiphy *wiphy)
 {
 	BUG_ON(!wiphy);
 	return container_of(wiphy, struct cfg80211_registered_device, wiphy);
diff --git a/net/wireless/ethtool.c b/net/wireless/ethtool.c
index e37862f..d4860bf 100644
--- a/net/wireless/ethtool.c
+++ b/net/wireless/ethtool.c
@@ -43,7 +43,7 @@ static void cfg80211_get_ringparam(struct net_device *dev,
 				   struct ethtool_ringparam *rp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 
 	memset(rp, 0, sizeof(*rp));
 
@@ -56,7 +56,7 @@ static int cfg80211_set_ringparam(struct net_device *dev,
 				  struct ethtool_ringparam *rp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 
 	if (rp->rx_mini_pending != 0 || rp->rx_jumbo_pending != 0)
 		return -EINVAL;
@@ -70,7 +70,7 @@ static int cfg80211_set_ringparam(struct net_device *dev,
 static int cfg80211_get_sset_count(struct net_device *dev, int sset)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	if (rdev->ops->get_et_sset_count)
 		return rdev_get_et_sset_count(rdev, dev, sset);
 	return -EOPNOTSUPP;
@@ -80,7 +80,7 @@ static void cfg80211_get_stats(struct net_device *dev,
 			       struct ethtool_stats *stats, u64 *data)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	if (rdev->ops->get_et_stats)
 		rdev_get_et_stats(rdev, dev, stats, data);
 }
@@ -88,7 +88,7 @@ static void cfg80211_get_stats(struct net_device *dev,
 static void cfg80211_get_strings(struct net_device *dev, u32 sset, u8 *data)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	if (rdev->ops->get_et_strings)
 		rdev_get_et_strings(rdev, dev, sset, data);
 }
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index f55f6ff..6b50588 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -45,7 +45,7 @@ void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 
 	cfg80211_upload_connect_keys(wdev);
 
-	nl80211_send_ibss_bssid(wiphy_to_dev(wdev->wiphy), dev, bssid,
+	nl80211_send_ibss_bssid(wiphy_to_rdev(wdev->wiphy), dev, bssid,
 				GFP_KERNEL);
 #ifdef CONFIG_CFG80211_WEXT
 	memset(&wrqu, 0, sizeof(wrqu));
@@ -58,7 +58,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 			  struct ieee80211_channel *channel, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_event *ev;
 	unsigned long flags;
 
@@ -156,7 +156,7 @@ int cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 static void __cfg80211_clear_ibss(struct net_device *dev, bool nowext)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	int i;
 
 	ASSERT_WDEV_LOCK(wdev);
@@ -311,7 +311,7 @@ int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 			       struct iw_freq *wextfreq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct ieee80211_channel *chan = NULL;
 	int err, freq;
 
@@ -396,7 +396,7 @@ int cfg80211_ibss_wext_siwessid(struct net_device *dev,
 				struct iw_point *data, char *ssid)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	size_t len = data->length;
 	int err;
 
@@ -463,7 +463,7 @@ int cfg80211_ibss_wext_siwap(struct net_device *dev,
 			     struct sockaddr *ap_addr, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	u8 *bssid = ap_addr->sa_data;
 	int err;
 
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 4b4ba70..266766b 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -23,7 +23,7 @@ void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
 	u8 *ie = mgmt->u.assoc_resp.variable;
 	int ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(cfg80211_rx_assoc_resp);
 static void cfg80211_process_auth(struct wireless_dev *wdev,
 				  const u8 *buf, size_t len)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 
 	nl80211_send_rx_auth(rdev, wdev->netdev, buf, len, GFP_KERNEL);
 	cfg80211_sme_rx_auth(wdev, buf, len);
@@ -63,7 +63,7 @@ static void cfg80211_process_auth(struct wireless_dev *wdev,
 static void cfg80211_process_deauth(struct wireless_dev *wdev,
 				    const u8 *buf, size_t len)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
 	const u8 *bssid = mgmt->bssid;
 	u16 reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
@@ -82,7 +82,7 @@ static void cfg80211_process_deauth(struct wireless_dev *wdev,
 static void cfg80211_process_disassoc(struct wireless_dev *wdev,
 				      const u8 *buf, size_t len)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
 	const u8 *bssid = mgmt->bssid;
 	u16 reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
@@ -123,7 +123,7 @@ void cfg80211_auth_timeout(struct net_device *dev, const u8 *addr)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	trace_cfg80211_send_auth_timeout(dev, addr);
 
@@ -136,7 +136,7 @@ void cfg80211_assoc_timeout(struct net_device *dev, struct cfg80211_bss *bss)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	trace_cfg80211_send_assoc_timeout(dev, bss->bssid);
 
@@ -172,7 +172,7 @@ void cfg80211_michael_mic_failure(struct net_device *dev, const u8 *addr,
 				  const u8 *tsc, gfp_t gfp)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 #ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 	char *buf = kmalloc(128, gfp);
@@ -402,7 +402,7 @@ int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_portid,
 				int match_len)
 {
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_mgmt_registration *reg, *nreg;
 	int err = 0;
 	u16 mgmt_type;
@@ -461,7 +461,7 @@ int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_portid,
 void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlportid)
 {
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_mgmt_registration *reg, *tmp;
 
 	spin_lock_bh(&wdev->mgmt_registrations_lock);
@@ -608,7 +608,7 @@ bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
 		      const u8 *buf, size_t len, u32 flags, gfp_t gfp)
 {
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_mgmt_registration *reg;
 	const struct ieee80211_txrx_stypes *stypes =
 		&wiphy->mgmt_stypes[wdev->iftype];
@@ -727,7 +727,7 @@ void cfg80211_radar_event(struct wiphy *wiphy,
 			  struct cfg80211_chan_def *chandef,
 			  gfp_t gfp)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	unsigned long timeout;
 
 	trace_cfg80211_radar_event(wiphy, chandef);
@@ -752,7 +752,7 @@ void cfg80211_cac_event(struct net_device *netdev,
 {
 	struct wireless_dev *wdev = netdev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	unsigned long timeout;
 
 	trace_cfg80211_cac_event(netdev, event);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9edbb5f..6550e20 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -168,8 +168,8 @@ __cfg80211_rdev_from_attrs(struct net *netns, struct nlattr **attrs)
 		netdev = __dev_get_by_index(netns, ifindex);
 		if (netdev) {
 			if (netdev->ieee80211_ptr)
-				tmp = wiphy_to_dev(
-						netdev->ieee80211_ptr->wiphy);
+				tmp = wiphy_to_rdev(
+					netdev->ieee80211_ptr->wiphy);
 			else
 				tmp = NULL;
 
@@ -485,7 +485,7 @@ static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 			err = PTR_ERR(*wdev);
 			goto out_unlock;
 		}
-		*rdev = wiphy_to_dev((*wdev)->wiphy);
+		*rdev = wiphy_to_rdev((*wdev)->wiphy);
 		/* 0 is the first index - add 1 to parse only once */
 		cb->args[0] = (*rdev)->wiphy_idx + 1;
 		cb->args[1] = (*wdev)->identifier;
@@ -498,7 +498,7 @@ static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 			err = -ENODEV;
 			goto out_unlock;
 		}
-		*rdev = wiphy_to_dev(wiphy);
+		*rdev = wiphy_to_rdev(wiphy);
 		*wdev = NULL;
 
 		list_for_each_entry(tmp, &(*rdev)->wdev_list, list) {
@@ -1691,7 +1691,7 @@ static int nl80211_dump_wiphy_parse(struct sk_buff *skb,
 		if (!netdev)
 			return -ENODEV;
 		if (netdev->ieee80211_ptr) {
-			rdev = wiphy_to_dev(
+			rdev = wiphy_to_rdev(
 				netdev->ieee80211_ptr->wiphy);
 			state->filter_wiphy = rdev->wiphy_idx;
 		}
@@ -2020,7 +2020,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 
 		netdev = __dev_get_by_index(genl_info_net(info), ifindex);
 		if (netdev && netdev->ieee80211_ptr)
-			rdev = wiphy_to_dev(netdev->ieee80211_ptr->wiphy);
+			rdev = wiphy_to_rdev(netdev->ieee80211_ptr->wiphy);
 		else
 			netdev = NULL;
 	}
@@ -2236,7 +2236,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 static inline u64 wdev_id(struct wireless_dev *wdev)
 {
 	return (u64)wdev->identifier |
-	       ((u64)wiphy_to_dev(wdev->wiphy)->wiphy_idx << 32);
+	       ((u64)wiphy_to_rdev(wdev->wiphy)->wiphy_idx << 32);
 }
 
 static int nl80211_send_chandef(struct sk_buff *msg,
@@ -6867,7 +6867,7 @@ struct sk_buff *__cfg80211_alloc_event_skb(struct wiphy *wiphy,
 					   int vendor_event_idx,
 					   int approxlen, gfp_t gfp)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	const struct nl80211_vendor_cmd_info *info;
 
 	switch (cmd) {
@@ -9179,7 +9179,7 @@ struct sk_buff *__cfg80211_alloc_reply_skb(struct wiphy *wiphy,
 					   enum nl80211_attrs attr,
 					   int approxlen)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	if (WARN_ON(!rdev->cur_cmd_info))
 		return NULL;
@@ -9303,7 +9303,7 @@ static int nl80211_pre_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		}
 
 		dev = wdev->netdev;
-		rdev = wiphy_to_dev(wdev->wiphy);
+		rdev = wiphy_to_rdev(wdev->wiphy);
 
 		if (ops->internal_flags & NL80211_FLAG_NEED_NETDEV) {
 			if (!dev) {
@@ -10332,7 +10332,7 @@ void cfg80211_rx_unprot_mlme_mgmt(struct net_device *dev, const u8 *buf,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	const struct ieee80211_mgmt *mgmt = (void *)buf;
 	u32 cmd;
 
@@ -10554,7 +10554,7 @@ void cfg80211_notify_new_peer_candidate(struct net_device *dev, const u8 *addr,
 					const u8* ie, u8 ie_len, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct sk_buff *msg;
 	void *hdr;
 
@@ -10734,7 +10734,7 @@ void cfg80211_ready_on_channel(struct wireless_dev *wdev, u64 cookie,
 			       unsigned int duration, gfp_t gfp)
 {
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	trace_cfg80211_ready_on_channel(wdev, cookie, chan, duration);
 	nl80211_send_remain_on_chan_event(NL80211_CMD_REMAIN_ON_CHANNEL,
@@ -10748,7 +10748,7 @@ void cfg80211_remain_on_channel_expired(struct wireless_dev *wdev, u64 cookie,
 					gfp_t gfp)
 {
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	trace_cfg80211_ready_on_channel_expired(wdev, cookie, chan);
 	nl80211_send_remain_on_chan_event(NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL,
@@ -10760,7 +10760,7 @@ void cfg80211_new_sta(struct net_device *dev, const u8 *mac_addr,
 		      struct station_info *sinfo, gfp_t gfp)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct sk_buff *msg;
 
 	trace_cfg80211_new_sta(dev, mac_addr, sinfo);
@@ -10783,7 +10783,7 @@ EXPORT_SYMBOL(cfg80211_new_sta);
 void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct sk_buff *msg;
 	void *hdr;
 
@@ -10820,7 +10820,7 @@ void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
 			  gfp_t gfp)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct sk_buff *msg;
 	void *hdr;
 
@@ -10855,7 +10855,7 @@ static bool __nl80211_unexpected_frame(struct net_device *dev, u8 cmd,
 				       const u8 *addr, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct sk_buff *msg;
 	void *hdr;
 	u32 nlportid = ACCESS_ONCE(wdev->ap_unexpected_nlportid);
@@ -10975,7 +10975,7 @@ void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 			     const u8 *buf, size_t len, bool ack, gfp_t gfp)
 {
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct net_device *netdev = wdev->netdev;
 	struct sk_buff *msg;
 	void *hdr;
@@ -11019,7 +11019,7 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct sk_buff *msg;
 	struct nlattr *pinfoattr;
 	void *hdr;
@@ -11111,7 +11111,7 @@ void cfg80211_gtk_rekey_notify(struct net_device *dev, const u8 *bssid,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	trace_cfg80211_gtk_rekey_notify(dev, bssid);
 	nl80211_gtk_rekey_notify(rdev, dev, bssid, replay_ctr, gfp);
@@ -11169,7 +11169,7 @@ void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	trace_cfg80211_pmksa_candidate_notify(dev, index, bssid, preauth);
 	nl80211_pmksa_candidate_notify(rdev, dev, index, bssid, preauth, gfp);
@@ -11216,7 +11216,7 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -11240,7 +11240,7 @@ void cfg80211_cqm_txe_notify(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct sk_buff *msg;
 	struct nlattr *pinfoattr;
 	void *hdr;
@@ -11340,7 +11340,7 @@ void cfg80211_cqm_pktloss_notify(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct sk_buff *msg;
 	struct nlattr *pinfoattr;
 	void *hdr;
@@ -11387,7 +11387,7 @@ void cfg80211_probe_status(struct net_device *dev, const u8 *addr,
 			   u64 cookie, bool acked, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct sk_buff *msg;
 	void *hdr;
 
@@ -11427,7 +11427,7 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
 				 const u8 *frame, size_t len,
 				 int freq, int sig_dbm)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct sk_buff *msg;
 	void *hdr;
 	struct cfg80211_beacon_registration *reg;
@@ -11474,7 +11474,7 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
 				   struct cfg80211_wowlan_wakeup *wakeup,
 				   gfp_t gfp)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct sk_buff *msg;
 	void *hdr;
 	int size = 200;
@@ -11584,7 +11584,7 @@ void cfg80211_tdls_oper_request(struct net_device *dev, const u8 *peer,
 				u16 reason_code, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct sk_buff *msg;
 	void *hdr;
 
@@ -11683,7 +11683,7 @@ void cfg80211_ft_event(struct net_device *netdev,
 		       struct cfg80211_ft_event_params *ft_event)
 {
 	struct wiphy *wiphy = netdev->ieee80211_ptr->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct sk_buff *msg;
 	void *hdr;
 
@@ -11730,7 +11730,7 @@ void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp)
 	void *hdr;
 	u32 nlportid;
 
-	rdev = wiphy_to_dev(wdev->wiphy);
+	rdev = wiphy_to_rdev(wdev->wiphy);
 	if (!rdev->crit_proto_nlportid)
 		return;
 
@@ -11765,7 +11765,7 @@ EXPORT_SYMBOL(cfg80211_crit_proto_stopped);
 void nl80211_send_ap_stopped(struct wireless_dev *wdev)
 {
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct sk_buff *msg;
 	void *hdr;
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 6d6f082..0f5da18 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -238,11 +238,11 @@ void __cfg80211_scan_done(struct work_struct *wk)
 void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
 {
 	trace_cfg80211_scan_done(request, aborted);
-	WARN_ON(request != wiphy_to_dev(request->wiphy)->scan_req);
+	WARN_ON(request != wiphy_to_rdev(request->wiphy)->scan_req);
 
 	request->aborted = aborted;
 	request->notified = true;
-	queue_work(cfg80211_wq, &wiphy_to_dev(request->wiphy)->scan_done_wk);
+	queue_work(cfg80211_wq, &wiphy_to_rdev(request->wiphy)->scan_done_wk);
 }
 EXPORT_SYMBOL(cfg80211_scan_done);
 
@@ -278,15 +278,15 @@ void cfg80211_sched_scan_results(struct wiphy *wiphy)
 {
 	trace_cfg80211_sched_scan_results(wiphy);
 	/* ignore if we're not scanning */
-	if (wiphy_to_dev(wiphy)->sched_scan_req)
+	if (wiphy_to_rdev(wiphy)->sched_scan_req)
 		queue_work(cfg80211_wq,
-			   &wiphy_to_dev(wiphy)->sched_scan_results_wk);
+			   &wiphy_to_rdev(wiphy)->sched_scan_results_wk);
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_results);
 
 void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
 	trace_cfg80211_sched_scan_stopped(wiphy);
 
@@ -526,7 +526,7 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      const u8 *ssid, size_t ssid_len,
 				      u16 capa_mask, u16 capa_val)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_internal_bss *bss, *res = NULL;
 	unsigned long now = jiffies;
 
@@ -919,7 +919,7 @@ cfg80211_inform_bss_width(struct wiphy *wiphy,
 	rcu_assign_pointer(tmp.pub.beacon_ies, ies);
 	rcu_assign_pointer(tmp.pub.ies, ies);
 
-	res = cfg80211_bss_update(wiphy_to_dev(wiphy), &tmp,
+	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp,
 				  rx_channel == channel);
 	if (!res)
 		return NULL;
@@ -991,7 +991,7 @@ cfg80211_inform_bss_width_frame(struct wiphy *wiphy,
 	tmp.pub.beacon_interval = le16_to_cpu(mgmt->u.probe_resp.beacon_int);
 	tmp.pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
 
-	res = cfg80211_bss_update(wiphy_to_dev(wiphy), &tmp,
+	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp,
 				  rx_channel == channel);
 	if (!res)
 		return NULL;
@@ -1007,7 +1007,7 @@ EXPORT_SYMBOL(cfg80211_inform_bss_width_frame);
 
 void cfg80211_ref_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_internal_bss *bss;
 
 	if (!pub)
@@ -1023,7 +1023,7 @@ EXPORT_SYMBOL(cfg80211_ref_bss);
 
 void cfg80211_put_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_internal_bss *bss;
 
 	if (!pub)
@@ -1039,7 +1039,7 @@ EXPORT_SYMBOL(cfg80211_put_bss);
 
 void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct cfg80211_internal_bss *bss;
 
 	if (WARN_ON(!pub))
@@ -1069,7 +1069,7 @@ cfg80211_get_dev_from_ifindex(struct net *net, int ifindex)
 	if (!dev)
 		return ERR_PTR(-ENODEV);
 	if (dev->ieee80211_ptr)
-		rdev = wiphy_to_dev(dev->ieee80211_ptr->wiphy);
+		rdev = wiphy_to_rdev(dev->ieee80211_ptr->wiphy);
 	else
 		rdev = ERR_PTR(-ENODEV);
 	dev_put(dev);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 0a96d67..72b1944 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -59,7 +59,7 @@ static void cfg80211_sme_free(struct wireless_dev *wdev)
 
 static int cfg80211_conn_scan(struct wireless_dev *wdev)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_scan_request *request;
 	int n_channels, err;
 
@@ -130,7 +130,7 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 
 static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_connect_params *params;
 	struct cfg80211_assoc_request req = {};
 	int err;
@@ -245,7 +245,7 @@ void cfg80211_conn_work(struct work_struct *work)
 /* Returned bss is reference counted and must be cleaned up appropriately. */
 static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_bss *bss;
 	u16 capa = WLAN_CAPABILITY_ESS;
 
@@ -275,7 +275,7 @@ static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 static void __cfg80211_sme_scan_done(struct net_device *dev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_bss *bss;
 
 	ASSERT_WDEV_LOCK(wdev);
@@ -306,7 +306,7 @@ void cfg80211_sme_scan_done(struct net_device *dev)
 void cfg80211_sme_rx_auth(struct wireless_dev *wdev, const u8 *buf, size_t len)
 {
 	struct wiphy *wiphy = wdev->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
 	u16 status_code = le16_to_cpu(mgmt->u.auth.status_code);
 
@@ -352,7 +352,7 @@ void cfg80211_sme_rx_auth(struct wireless_dev *wdev, const u8 *buf, size_t len)
 
 bool cfg80211_sme_rx_assoc_resp(struct wireless_dev *wdev, u16 status)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 
 	if (!wdev->conn)
 		return false;
@@ -386,7 +386,7 @@ void cfg80211_sme_deauth(struct wireless_dev *wdev)
 
 void cfg80211_sme_auth_timeout(struct wireless_dev *wdev)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 
 	if (!wdev->conn)
 		return;
@@ -397,7 +397,7 @@ void cfg80211_sme_auth_timeout(struct wireless_dev *wdev)
 
 void cfg80211_sme_disassoc(struct wireless_dev *wdev)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 
 	if (!wdev->conn)
 		return;
@@ -408,7 +408,7 @@ void cfg80211_sme_disassoc(struct wireless_dev *wdev)
 
 void cfg80211_sme_assoc_timeout(struct wireless_dev *wdev)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 
 	if (!wdev->conn)
 		return;
@@ -421,7 +421,7 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 				struct cfg80211_connect_params *connect,
 				const u8 *prev_bssid)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_bss *bss;
 	int err;
 
@@ -505,7 +505,7 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 
 static int cfg80211_sme_disconnect(struct wireless_dev *wdev, u16 reason)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	int err;
 
 	if (!wdev->conn)
@@ -593,7 +593,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 		return;
 	}
 
-	nl80211_send_connect_result(wiphy_to_dev(wdev->wiphy), dev,
+	nl80211_send_connect_result(wiphy_to_rdev(wdev->wiphy), dev,
 				    bssid, req_ie, req_ie_len,
 				    resp_ie, resp_ie_len,
 				    status, GFP_KERNEL);
@@ -624,7 +624,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 #endif
 
 	if (!bss && (status == WLAN_STATUS_SUCCESS)) {
-		WARN_ON_ONCE(!wiphy_to_dev(wdev->wiphy)->ops->connect);
+		WARN_ON_ONCE(!wiphy_to_rdev(wdev->wiphy)->ops->connect);
 		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
 				       wdev->ssid, wdev->ssid_len,
 				       WLAN_CAPABILITY_ESS,
@@ -686,7 +686,7 @@ void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			     u16 status, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_event *ev;
 	unsigned long flags;
 
@@ -741,7 +741,8 @@ void __cfg80211_roamed(struct wireless_dev *wdev,
 	cfg80211_hold_bss(bss_from_pub(bss));
 	wdev->current_bss = bss_from_pub(bss);
 
-	nl80211_send_roamed(wiphy_to_dev(wdev->wiphy), wdev->netdev, bss->bssid,
+	nl80211_send_roamed(wiphy_to_rdev(wdev->wiphy),
+			    wdev->netdev, bss->bssid,
 			    req_ie, req_ie_len, resp_ie, resp_ie_len,
 			    GFP_KERNEL);
 
@@ -800,7 +801,7 @@ void cfg80211_roamed_bss(struct net_device *dev,
 			 size_t resp_ie_len, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_event *ev;
 	unsigned long flags;
 
@@ -833,7 +834,7 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 			     size_t ie_len, u16 reason, bool from_ap)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	int i;
 #ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
@@ -879,7 +880,7 @@ void cfg80211_disconnected(struct net_device *dev, u16 reason,
 			   u8 *ie, size_t ie_len, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_event *ev;
 	unsigned long flags;
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index d032a31..49b9fc3 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -770,7 +770,7 @@ EXPORT_SYMBOL(ieee80211_bss_get_ie);
 
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
 {
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct net_device *dev = wdev->netdev;
 	int i;
 
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 836b006..11120bb 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -73,7 +73,7 @@ int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
 	struct vif_params vifparams;
 	enum nl80211_iftype type;
 
-	rdev = wiphy_to_dev(wdev->wiphy);
+	rdev = wiphy_to_rdev(wdev->wiphy);
 
 	switch (*mode) {
 	case IW_MODE_INFRA:
@@ -286,7 +286,7 @@ int cfg80211_wext_siwrts(struct net_device *dev,
 			 struct iw_param *rts, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	u32 orts = wdev->wiphy->rts_threshold;
 	int err;
 
@@ -324,7 +324,7 @@ int cfg80211_wext_siwfrag(struct net_device *dev,
 			  struct iw_param *frag, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	u32 ofrag = wdev->wiphy->frag_threshold;
 	int err;
 
@@ -364,7 +364,7 @@ static int cfg80211_wext_siwretry(struct net_device *dev,
 				  struct iw_param *retry, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	u32 changed = 0;
 	u8 olong = wdev->wiphy->retry_long;
 	u8 oshort = wdev->wiphy->retry_short;
@@ -587,7 +587,7 @@ static int cfg80211_wext_siwencode(struct net_device *dev,
 				   struct iw_point *erq, char *keybuf)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	int idx, err;
 	bool remove = false;
 	struct key_params params;
@@ -647,7 +647,7 @@ static int cfg80211_wext_siwencodeext(struct net_device *dev,
 				      struct iw_point *erq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct iw_encode_ext *ext = (struct iw_encode_ext *) extra;
 	const u8 *addr;
 	int idx;
@@ -775,7 +775,7 @@ static int cfg80211_wext_siwfreq(struct net_device *dev,
 				 struct iw_freq *wextfreq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_chan_def chandef = {
 		.width = NL80211_CHAN_WIDTH_20_NOHT,
 	};
@@ -818,7 +818,7 @@ static int cfg80211_wext_giwfreq(struct net_device *dev,
 				 struct iw_freq *freq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_chan_def chandef;
 	int ret;
 
@@ -847,7 +847,7 @@ static int cfg80211_wext_siwtxpower(struct net_device *dev,
 				    union iwreq_data *data, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	enum nl80211_tx_power_setting type;
 	int dbm = 0;
 
@@ -899,7 +899,7 @@ static int cfg80211_wext_giwtxpower(struct net_device *dev,
 				    union iwreq_data *data, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	int err, val;
 
 	if ((data->txpower.flags & IW_TXPOW_TYPE) != IW_TXPOW_DBM)
@@ -1119,7 +1119,7 @@ static int cfg80211_wext_siwpower(struct net_device *dev,
 				  struct iw_param *wrq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	bool ps = wdev->ps;
 	int timeout = wdev->ps_timeout;
 	int err;
@@ -1177,7 +1177,7 @@ static int cfg80211_wds_wext_siwap(struct net_device *dev,
 				   struct sockaddr *addr, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	int err;
 
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_WDS))
@@ -1221,7 +1221,7 @@ static int cfg80211_wext_siwrate(struct net_device *dev,
 				 struct iw_param *rate, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_bitrate_mask mask;
 	u32 fixed, maxrate;
 	struct ieee80211_supported_band *sband;
@@ -1272,7 +1272,7 @@ static int cfg80211_wext_giwrate(struct net_device *dev,
 				 struct iw_param *rate, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	/* we are under RTNL - globally locked - so can use a static struct */
 	static struct station_info sinfo;
 	u8 addr[ETH_ALEN];
@@ -1310,7 +1310,7 @@ static int cfg80211_wext_giwrate(struct net_device *dev,
 static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	/* we are under RTNL - globally locked - so can use static structs */
 	static struct iw_statistics wstats;
 	static struct station_info sinfo;
@@ -1449,7 +1449,7 @@ static int cfg80211_wext_siwpmksa(struct net_device *dev,
 				  struct iw_point *data, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct cfg80211_pmksa cfg_pmksa;
 	struct iw_pmksa *pmksa = (struct iw_pmksa *)extra;
 
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index c05a018..c7e5c8e 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -67,7 +67,7 @@ int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
 			      struct iw_freq *wextfreq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	struct ieee80211_channel *chan = NULL;
 	int err, freq;
 
@@ -169,7 +169,7 @@ int cfg80211_mgd_wext_siwessid(struct net_device *dev,
 			       struct iw_point *data, char *ssid)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	size_t len = data->length;
 	int err;
 
@@ -260,7 +260,7 @@ int cfg80211_mgd_wext_siwap(struct net_device *dev,
 			    struct sockaddr *ap_addr, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	u8 *bssid = ap_addr->sa_data;
 	int err;
 
@@ -333,7 +333,7 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
 			   struct iw_point *data, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 	u8 *ie = extra;
 	int ie_len = data->length, err;
 
@@ -390,7 +390,7 @@ int cfg80211_wext_siwmlme(struct net_device *dev,
 	if (!wdev)
 		return -EOPNOTSUPP;
 
-	rdev = wiphy_to_dev(wdev->wiphy);
+	rdev = wiphy_to_rdev(wdev->wiphy);
 
 	if (wdev->iftype != NL80211_IFTYPE_STATION)
 		return -EINVAL;
-- 
1.9.0

