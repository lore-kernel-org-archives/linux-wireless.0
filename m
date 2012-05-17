Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:46867 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761445Ab2EQJ7Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 05:59:24 -0400
From: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>, <lukasz.kucharczyk@tieto.com>
Subject: [RFC 1/2] cfg80211/mac80211: bind RTS threshold to vif.
Date: Thu, 17 May 2012 11:58:42 +0200
Message-ID: <1337248723-10946-2-git-send-email-lukasz.kucharczyk@tieto.com> (sfid-20120517_115928_118429_6326EF16)
In-Reply-To: <1337248723-10946-1-git-send-email-lukasz.kucharczyk@tieto.com>
References: <1337248723-10946-1-git-send-email-lukasz.kucharczyk@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add possibility to set rts threshold for vif
in preparation to multi channel operation.

Driver's set_rts_threshold callback has additional
<struct ieee80211_vif *vif> parameter.

>From userspace, it's possible to set rts threshold for:
* phy: .set_rts_threshold will be called with vif == NULL.
  Driver should apply new value for all interfaces.
  (backward compatible)
* vif: .set_rts_threshold will be called with vif != NULL.
  Driver should apply new value only for corresponding
  interface. If driver doesn't support setting RTS
  threshold for vif, it should return -ENOTSUPP.

Change-Id: I2b786525a23ab179cc163fd8d80c89d976d9df67
Signed-off-by: Lukasz Kucharczyk <lukasz.kucharczyk@tieto.com>
---
 include/net/cfg80211.h        |    8 +++++-
 include/net/mac80211.h        |    3 +-
 net/mac80211/cfg.c            |   21 +++++++++++++------
 net/mac80211/debugfs_netdev.c |    6 +++++
 net/mac80211/driver-ops.h     |   10 +++++++-
 net/mac80211/driver-trace.h   |   32 +++++++++++++++++++++++++++--
 net/mac80211/iface.c          |    2 +
 net/mac80211/tx.c             |    3 +-
 net/mac80211/util.c           |   16 ++++++++++++--
 net/wireless/core.c           |    1 -
 net/wireless/debugfs.c        |    3 --
 net/wireless/nl80211.c        |   43 ++++++++++++++++++++++++++++++++--------
 12 files changed, 115 insertions(+), 33 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d6cb205..77a8496 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1632,6 +1632,10 @@ struct cfg80211_ops {
 
 	int	(*set_wiphy_params)(struct wiphy *wiphy, u32 changed);
 
+	int	(*set_rts_threshold)(struct wiphy *wiphy,
+				     struct net_device *dev,
+				     int rts_threshold);
+
 	int	(*set_tx_power)(struct wiphy *wiphy,
 				enum nl80211_tx_power_setting type, int mbm);
 	int	(*get_tx_power)(struct wiphy *wiphy, int *dbm);
@@ -1959,7 +1963,6 @@ struct wiphy_wowlan_support {
  * @retry_long: Retry limit for long frames (dot11LongRetryLimit)
  * @frag_threshold: Fragmentation threshold (dot11FragmentationThreshold);
  *	-1 = fragmentation disabled, only odd values >= 256 used
- * @rts_threshold: RTS threshold (dot11RTSThreshold); -1 = RTS/CTS disabled
  * @_net: the network namespace this wiphy currently lives in
  * @perm_addr: permanent MAC address of this device
  * @addr_mask: If the device supports multiple MAC addresses by masking,
@@ -2080,7 +2083,6 @@ struct wiphy {
 	u8 retry_short;
 	u8 retry_long;
 	u32 frag_threshold;
-	u32 rts_threshold;
 	u8 coverage_class;
 
 	char fw_version[ETHTOOL_BUSINFO_LEN];
@@ -2283,6 +2285,7 @@ struct cfg80211_cached_keys;
  * @cleanup_work: work struct used for cleanup that can't be done directly
  * @beacon_interval: beacon interval used on this device for transmitting
  *	beacons, 0 when not valid
+ * @rts_threshold: RTS threshold (dot11RTSThreshold); -1 = RTS/CTS disabled
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -2322,6 +2325,7 @@ struct wireless_dev {
 	int ps_timeout;
 
 	int beacon_interval;
+	u32 rts_threshold;
 
 	u32 ap_unexpected_nlpid;
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index baba4af..e9b3716 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2296,7 +2296,8 @@ struct ieee80211_ops {
 	void (*get_tkip_seq)(struct ieee80211_hw *hw, u8 hw_key_idx,
 			     u32 *iv32, u16 *iv16);
 	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
-	int (*set_rts_threshold)(struct ieee80211_hw *hw, u32 value);
+	int (*set_rts_threshold)(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif, u32 value);
 	int (*sta_add)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct ieee80211_sta *sta);
 	int (*sta_remove)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0221270..81c9355 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1883,13 +1883,6 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 			return err;
 	}
 
-	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
-		err = drv_set_rts_threshold(local, wiphy->rts_threshold);
-
-		if (err)
-			return err;
-	}
-
 	if (changed & WIPHY_PARAM_RETRY_SHORT)
 		local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
 	if (changed & WIPHY_PARAM_RETRY_LONG)
@@ -1901,6 +1894,19 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 	return 0;
 }
 
+static int ieee80211_set_rts_threshold(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       int rts_threshold)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = NULL;
+
+	if (dev)
+		sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	return drv_set_rts_threshold(local, sdata, rts_threshold);
+}
+
 static int ieee80211_set_tx_power(struct wiphy *wiphy,
 				  enum nl80211_tx_power_setting type, int mbm)
 {
@@ -2946,6 +2952,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.join_ibss = ieee80211_join_ibss,
 	.leave_ibss = ieee80211_leave_ibss,
 	.set_wiphy_params = ieee80211_set_wiphy_params,
+	.set_rts_threshold = ieee80211_set_rts_threshold,
 	.set_tx_power = ieee80211_set_tx_power,
 	.get_tx_power = ieee80211_get_tx_power,
 	.set_wds_peer = ieee80211_set_wds_peer,
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index ea0122d..a4de84d 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -168,6 +168,7 @@ IEEE80211_IF_FILE(rc_rateidx_mcs_mask_5ghz,
 IEEE80211_IF_FILE(flags, flags, HEX);
 IEEE80211_IF_FILE(state, state, LHEX);
 IEEE80211_IF_FILE(channel_type, vif.bss_conf.channel_type, DEC);
+IEEE80211_IF_FILE(rts_threshold, wdev.rts_threshold, DEC);
 
 /* STA attributes */
 IEEE80211_IF_FILE(bssid, u.mgd.bssid, MAC);
@@ -524,6 +525,7 @@ static void add_common_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 	DEBUGFS_ADD(rc_rateidx_mcs_mask_2ghz);
 	DEBUGFS_ADD(rc_rateidx_mcs_mask_5ghz);
+	DEBUGFS_ADD(rts_threshold);
 }
 
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
@@ -536,6 +538,7 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
 	DEBUGFS_ADD_MODE(uapsd_queues, 0600);
 	DEBUGFS_ADD_MODE(uapsd_max_sp_len, 0600);
+	DEBUGFS_ADD(rts_threshold);
 }
 
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
@@ -545,16 +548,19 @@ static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(dtim_count);
 	DEBUGFS_ADD(num_buffered_multicast);
 	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
+	DEBUGFS_ADD(rts_threshold);
 }
 
 static void add_ibss_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD_MODE(tsf, 0600);
+	DEBUGFS_ADD(rts_threshold);
 }
 
 static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(peer);
+	DEBUGFS_ADD(rts_threshold);
 }
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 5e56b7c..05036a6 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -431,15 +431,21 @@ static inline int drv_set_frag_threshold(struct ieee80211_local *local,
 }
 
 static inline int drv_set_rts_threshold(struct ieee80211_local *local,
+					struct ieee80211_sub_if_data *sdata,
 					u32 value)
 {
 	int ret = 0;
+	struct ieee80211_vif *vif = NULL;
 
 	might_sleep();
 
-	trace_drv_set_rts_threshold(local, value);
+	if (sdata)
+		vif = &sdata->vif;
+
+	trace_drv_set_rts_threshold(local, sdata, value);
 	if (local->ops->set_rts_threshold)
-		ret = local->ops->set_rts_threshold(&local->hw, value);
+		ret = local->ops->set_rts_threshold(&local->hw, vif, value);
+
 	trace_drv_return_int(local, ret);
 	return ret;
 }
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 6de00b2..6859fc2 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -567,9 +567,35 @@ DEFINE_EVENT(local_u32_evt, drv_set_frag_threshold,
 	TP_ARGS(local, value)
 );
 
-DEFINE_EVENT(local_u32_evt, drv_set_rts_threshold,
-	TP_PROTO(struct ieee80211_local *local, u32 value),
-	TP_ARGS(local, value)
+TRACE_EVENT(drv_set_rts_threshold,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata, u32 value),
+	TP_ARGS(local, sdata, value),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(enum nl80211_iftype, vif_type)
+		__field(void *, sdata)
+		__field(bool, p2p)
+		__string(vif_name,  "<nodev>")
+		__field(u32, value)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->vif_type = sdata ? sdata->vif.type :
+			NL80211_IFTYPE_UNSPECIFIED;
+		__entry->sdata = sdata;
+		__entry->p2p = sdata ? sdata->vif.p2p : false;
+		__assign_str(vif_name, (sdata && sdata->dev) ?
+			     sdata->dev->name : "<nodev>");
+		__entry->value = value;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT VIF_PR_FMT " RTS:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->value
+	)
 );
 
 TRACE_EVENT(drv_set_coverage_class,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 9b89fc6..70dccf2 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1003,6 +1003,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	skb_queue_head_init(&sdata->skb_queue);
 	INIT_WORK(&sdata->work, ieee80211_iface_work);
 
+	sdata->wdev.rts_threshold = (u32) -1;
+
 	switch (type) {
 	case NL80211_IFTYPE_P2P_GO:
 		type = NL80211_IFTYPE_AP;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 56c68db..7f11f7d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -650,9 +650,8 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 		    tx->sdata->vif.type == NL80211_IFTYPE_ADHOC);
 
 	/* set up RTS protection if desired */
-	if (len > tx->local->hw.wiphy->rts_threshold) {
+	if (len > tx->sdata->wdev.rts_threshold)
 		txrc.rts = rts = true;
-	}
 
 	/*
 	 * Use short preamble if the BSS can handle it, but not for
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 22f2216..d9b0432 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1236,9 +1236,6 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	/* setup fragmentation threshold */
 	drv_set_frag_threshold(local, hw->wiphy->frag_threshold);
 
-	/* setup RTS threshold */
-	drv_set_rts_threshold(local, hw->wiphy->rts_threshold);
-
 	/* reset coverage class */
 	drv_set_coverage_class(local, hw->wiphy->coverage_class);
 
@@ -1397,6 +1394,19 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		if (ieee80211_sdata_running(sdata))
 			ieee80211_enable_keys(sdata);
 
+
+	/* setup RTS threshold */
+	list_for_each_entry(sdata, &local->interfaces, list)
+		if (drv_set_rts_threshold(local, sdata,
+					  sdata->wdev.rts_threshold)) {
+			/* If setting rts threshold for particular interface
+			 * failed, it means that driver only supports
+			 * setting rts threshold for hw */
+			drv_set_rts_threshold(local, NULL,
+					      sdata->wdev.rts_threshold);
+			break;
+		}
+
  wake_up:
 	ieee80211_wake_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
diff --git a/net/wireless/core.c b/net/wireless/core.c
index e1171de..a36bd5f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -423,7 +423,6 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	rdev->wiphy.retry_short = 7;
 	rdev->wiphy.retry_long = 4;
 	rdev->wiphy.frag_threshold = (u32) -1;
-	rdev->wiphy.rts_threshold = (u32) -1;
 	rdev->wiphy.coverage_class = 0;
 
 	return &rdev->wiphy;
diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 920cabe..1314427 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -31,8 +31,6 @@ static const struct file_operations name## _ops = {			\
 	.llseek = generic_file_llseek,					\
 };
 
-DEBUGFS_READONLY_FILE(rts_threshold, 20, "%d",
-		      wiphy->rts_threshold)
 DEBUGFS_READONLY_FILE(fragmentation_threshold, 20, "%d",
 		      wiphy->frag_threshold);
 DEBUGFS_READONLY_FILE(short_retry_limit, 20, "%d",
@@ -107,7 +105,6 @@ void cfg80211_debugfs_rdev_add(struct cfg80211_registered_device *rdev)
 {
 	struct dentry *phyd = rdev->wiphy.debugfsdir;
 
-	DEBUGFS_ADD(rts_threshold);
 	DEBUGFS_ADD(fragmentation_threshold);
 	DEBUGFS_ADD(short_retry_limit);
 	DEBUGFS_ADD(long_retry_limit);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fa05e96..8656dd8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -730,8 +730,6 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		       dev->wiphy.retry_long) ||
 	    nla_put_u32(msg, NL80211_ATTR_WIPHY_FRAG_THRESHOLD,
 			dev->wiphy.frag_threshold) ||
-	    nla_put_u32(msg, NL80211_ATTR_WIPHY_RTS_THRESHOLD,
-			dev->wiphy.rts_threshold) ||
 	    nla_put_u8(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS,
 		       dev->wiphy.coverage_class) ||
 	    nla_put_u8(msg, NL80211_ATTR_MAX_NUM_SCAN_SSIDS,
@@ -1464,9 +1462,38 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_RTS_THRESHOLD]) {
+		u32 old_rts_threshold;
 		rts_threshold = nla_get_u32(
 			info->attrs[NL80211_ATTR_WIPHY_RTS_THRESHOLD]);
-		changed |= WIPHY_PARAM_RTS_THRESHOLD;
+		if (!rdev->ops->set_rts_threshold) {
+			result = -EOPNOTSUPP;
+			goto bad_res;
+		}
+
+		if (netdev) {
+			wdev = netdev->ieee80211_ptr;
+		} else {
+			mutex_lock(&rdev->devlist_mtx);
+			wdev = list_entry(rdev->netdev_list.next,
+					  typeof(*wdev), list);
+			mutex_unlock(&rdev->devlist_mtx);
+		}
+		old_rts_threshold = wdev->rts_threshold;
+
+		wdev->rts_threshold = rts_threshold;
+		result = rdev->ops->set_rts_threshold(&rdev->wiphy, netdev,
+						      rts_threshold);
+
+		if (result) {
+			wdev->rts_threshold = old_rts_threshold;
+			goto bad_res;
+		} else if (!netdev) {
+			mutex_lock(&rdev->devlist_mtx);
+			list_for_each_entry(wdev, &rdev->netdev_list, list) {
+				wdev->rts_threshold = rts_threshold;
+			}
+			mutex_unlock(&rdev->devlist_mtx);
+		}
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_COVERAGE_CLASS]) {
@@ -1477,7 +1504,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 
 	if (changed) {
 		u8 old_retry_short, old_retry_long;
-		u32 old_frag_threshold, old_rts_threshold;
+		u32 old_frag_threshold;
 		u8 old_coverage_class;
 
 		if (!rdev->ops->set_wiphy_params) {
@@ -1488,7 +1515,6 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		old_retry_short = rdev->wiphy.retry_short;
 		old_retry_long = rdev->wiphy.retry_long;
 		old_frag_threshold = rdev->wiphy.frag_threshold;
-		old_rts_threshold = rdev->wiphy.rts_threshold;
 		old_coverage_class = rdev->wiphy.coverage_class;
 
 		if (changed & WIPHY_PARAM_RETRY_SHORT)
@@ -1497,8 +1523,6 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			rdev->wiphy.retry_long = retry_long;
 		if (changed & WIPHY_PARAM_FRAG_THRESHOLD)
 			rdev->wiphy.frag_threshold = frag_threshold;
-		if (changed & WIPHY_PARAM_RTS_THRESHOLD)
-			rdev->wiphy.rts_threshold = rts_threshold;
 		if (changed & WIPHY_PARAM_COVERAGE_CLASS)
 			rdev->wiphy.coverage_class = coverage_class;
 
@@ -1507,7 +1531,6 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			rdev->wiphy.retry_short = old_retry_short;
 			rdev->wiphy.retry_long = old_retry_long;
 			rdev->wiphy.frag_threshold = old_frag_threshold;
-			rdev->wiphy.rts_threshold = old_rts_threshold;
 			rdev->wiphy.coverage_class = old_coverage_class;
 		}
 	}
@@ -1537,7 +1560,9 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			dev->ieee80211_ptr->iftype) ||
 	    nla_put_u32(msg, NL80211_ATTR_GENERATION,
 			rdev->devlist_generation ^
-			(cfg80211_rdev_list_generation << 2)))
+			(cfg80211_rdev_list_generation << 2)) ||
+	    nla_put_u32(msg, NL80211_ATTR_WIPHY_RTS_THRESHOLD,
+			dev->ieee80211_ptr->rts_threshold))
 		goto nla_put_failure;
 
 	if (rdev->ops->get_channel) {
-- 
1.7.0.4

