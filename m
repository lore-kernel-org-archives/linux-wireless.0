Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.smtp.broadcom.com ([192.19.211.62]:50623 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935255AbcKQSFk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 13:05:40 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC V2 4/5] nl80211: add support for gscan
Date: Thu, 17 Nov 2016 13:18:45 +0000
Message-Id: <1479388726-3288-5-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161117_190548_111868_D82710D6)
In-Reply-To: <1479388726-3288-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479388726-3288-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for GScan which is a scan offload feature
used in Android.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
V2:
 - removed pr_err() statements.
---
 include/net/cfg80211.h       |  91 ++++++++++-
 include/uapi/linux/nl80211.h | 146 ++++++++++++++++++
 net/wireless/core.c          |  31 ++++
 net/wireless/core.h          |   4 +
 net/wireless/nl80211.c       | 351 ++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/rdev-ops.h      |  25 +++
 net/wireless/scan.c          |  28 ++++
 net/wireless/trace.h         |   9 ++
 8 files changed, 678 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c77bb08..b4b0536 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2464,6 +2464,90 @@ struct cfg80211_nan_func {
 };
 
 /**
+ * struct cfg80211_gscan_channel - GScan channel parameters.
+ *
+
+ * @ch: specific channel.
+ * @dwell_time: hint for dwell time in milliseconds.
+ * @passive: indicates passive scan is requested.
+ */
+struct cfg80211_gscan_channel {
+    struct ieee80211_channel *ch;
+    int dwell_time;
+    bool passive;
+};
+
+/**
+ * struct cfg80211_gscan_bucket - GScan bucket parameters.
+ *
+ * @idx: unique bucket index.
+ * @band: bit flags for band(s) to use, see %enum nl80211_bucket_band.
+ * @period: period in which the bucket is scheduled to be scanned. If the
+ *	period is too small for driver it should not fail but report results
+ *	as fast as it can. For exponential backoff bucket this is the minimum
+ *	period.
+ * @report_events: This is a bit field according %enum nl80211_bucket_report_event.
+ * @max_period: used only for the exponential backoff bucket whose scan period will
+ *	grow exponentially to a maximum period of max_period.
+ * @exponent: used only for the exponential backoff bucket.
+ * @step_count: used only for the exponential backoff bucket.
+ * @n_channels: number of channels in @channels array.
+ * @channels: channels to scan which may include DFS channels.
+ */
+struct cfg80211_gscan_bucket {
+	int idx;
+	u32 band;
+	int period;
+	u8 report_events;
+	int max_period;
+	int exponent;
+	int step_count;
+	int n_channels;
+	struct cfg80211_gscan_channel *channels;
+};
+
+/**
+ * struct cfg80211_gscan_request - GScan request parameters.
+ *
+ * @flags: scan request flags according %enum nl80211_scan_flags.
+ * @base_period: base timer period in milliseconds.
+ * @max_ap_per_scan: number of APs to store in each scan entry in the BSSID/RSSI
+ *	history buffer (keep APS with highest RSSI).
+ * @report_threshold_percent: wake up system when scan buffer is filled to this
+ *	percentage.
+ * @report_threshold_num_scans: wake up system when this many scans are stored
+ *	in scan buffer.
+ * @mac: MAC address used for randomisation.
+ * @mac_mask: MAC address mask. bits that are 0 in the mask should be
+ *	randomised, bits that are 1 should be taken as is from @mac.
+ * @n_buckets: number of entries in @buckets array.
+ * @buckets: array of GScan buckets.
+ *
+ * @dev: net device for which GScan is requested.
+ * @rcu_head: RCU callback used to free the struct.
+ * @owner_nlportid: netlink port which initiated this request.
+ */
+struct cfg80211_gscan_request {
+	u32 flags;
+	int base_period;
+	int max_ap_per_scan;
+	u8 report_threshold_percent;
+	int report_threshold_num_scans;
+	u8 mac[ETH_ALEN];
+	u8 mac_mask[ETH_ALEN];
+
+	int n_buckets;
+
+	/* internal */
+	struct net_device *dev;
+	struct rcu_head rcu_head;
+	u32 owner_nlportid;
+
+	/* keep last */
+	struct cfg80211_gscan_bucket buckets[0];
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2773,8 +2857,9 @@ struct cfg80211_nan_func {
  * @nan_change_conf: changes NAN configuration. The changed parameters must
  *	be specified in @changes (using &enum cfg80211_nan_conf_changes);
  *	All other parameters must be ignored.
- *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
+ * @start_gscan: start the GSCAN scanning offload.
+ * @stop_gscan: stop the GSCAN scanning offload.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3055,10 +3140,12 @@ struct cfg80211_ops {
 				   struct wireless_dev *wdev,
 				   struct cfg80211_nan_conf *conf,
 				   u32 changes);
-
 	int	(*set_multicast_to_unicast)(struct wiphy *wiphy,
 					    struct net_device *dev,
 					    const bool enabled);
+	int	(*start_gscan)(struct wiphy *wiphy, struct net_device *dev,
+			       struct cfg80211_gscan_request *gscan_req);
+	int	(*stop_gscan)(struct wiphy *wiphy, struct net_device *dev);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 232a792..8071dae 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -894,6 +894,12 @@
  *	does not result in a change for the current association. Currently,
  *	only the %NL80211_ATTR_IE data is used and updated with this command.
  *
+ * @NL80211_CMD_START_GSCAN: start GScan.
+ * @NL80211_CMD_STOP_GSCAN: request to stop current GScan.
+ * @NL80211_CMD_GSCAN_STOPPED: indicates that the currently running GScan
+ *	has stopped. This event is generated upon @NL80211_CMD_STOP_GSCAN and
+ *	the driver may issue this event at any time when a GScan is running.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1093,6 +1099,10 @@ enum nl80211_commands {
 
 	NL80211_CMD_UPDATE_CONNECT_PARAMS,
 
+	NL80211_CMD_START_GSCAN,
+	NL80211_CMD_STOP_GSCAN,
+	NL80211_CMD_GSCAN_STOPPED,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2385,6 +2395,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED,
 
 	NL80211_ATTR_GSCAN_CAPS,
+	NL80211_ATTR_GSCAN_PARAMS,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -4779,12 +4790,15 @@ enum nl80211_connect_failed_reason {
  *	locally administered 1, multicast 0) is assumed.
  *	This flag must not be requested when the feature isn't supported, check
  *	the nl80211 feature flags for the device.
+ * @NL80211_SCAN_FLAGS_IE_DATA: request the device to supply IE data in the
+ *	request.
  */
 enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_LOW_PRIORITY			= 1<<0,
 	NL80211_SCAN_FLAG_FLUSH				= 1<<1,
 	NL80211_SCAN_FLAG_AP				= 1<<2,
 	NL80211_SCAN_FLAG_RANDOM_ADDR			= 1<<3,
+	NL80211_SCAN_FLAG_IE_DATA			= 1<<4,
 };
 
 /**
@@ -5246,4 +5260,136 @@ enum nl80211_gscan_caps_attr {
 	NL80211_GSCAN_CAPS_ATTR_MAX = __NL80211_GSCAN_CAPS_ATTR_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_gscan_attr - common GScan parameters.
+ *
+ * @__NL80211_GSCAN_ATTR_INVALID: reserved.
+ * @NL80211_GSCAN_ATTR_BASE_PERIOD: base timer period in milliseconds.
+ * @NL80211_GSCAN_ATTR_MAX_AP_PER_SCAN: number of APs that are kept per
+ *	scan. The kept APs are the ones with strongest RSSI level.
+ * @NL80211_GSCAN_ATTR_REPORT_PERC: threshold specifying percentage of
+ *	scan cache filled that should trigger event for scan results.
+ * @NL80211_GSCAN_ATTR_REPORT_SCANS: threshold specifying number of scans
+ *	after which an event is expected for scan results.
+ * @NL80211_GSCAN_ATTR_BUCKETS: nested attribute specifying
+ *	per-bucket parameters for GScan. See %enum nl80211_gscan_bucket_attr
+ *	for description.
+ * @NL80211_GSCAN_ATTR_MAX: highest GScan attribute.
+ * @__NL80211_GSCAN_ATTR_AFTER_LAST: internal use.
+ */
+enum nl80211_gscan_attr {
+	__NL80211_GSCAN_ATTR_INVALID,
+	NL80211_GSCAN_ATTR_BASE_PERIOD,
+	NL80211_GSCAN_ATTR_MAX_AP_PER_SCAN,
+	NL80211_GSCAN_ATTR_REPORT_PERC,
+	NL80211_GSCAN_ATTR_REPORT_SCANS,
+	NL80211_GSCAN_ATTR_BUCKETS,
+
+	/* keep last */
+	__NL80211_GSCAN_ATTR_AFTER_LAST,
+	NL80211_GSCAN_ATTR_MAX = __NL80211_GSCAN_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_gscan_bucket_attr - per-bucket GScan parameters.
+ *
+ * @__NL80211_GSCAN_BUCKET_ATTR_INVALID,
+ * @NL80211_GSCAN_BUCKET_ATTR_ID: unique bucket id.
+ * @NL80211_GSCAN_BUCKET_ATTR_BAND: specifies the band to be scanned
+ *	according %enum nl80211_bucket_band. If specified
+ *	@NL80211_GSCAN_BUCKET_ATTR_CHANNELS is ignored.
+ * @NL80211_GSCAN_BUCKET_ATTR_PERIOD: specifies the period between
+ *	consecutive scans of this bucket. For backoff bucket this
+ *	is period(0).
+ * @NL80211_GSCAN_BUCKET_ATTR_REPORT: specifies reporting flags according
+ *	%enum nl80211_bucket_report_event.
+ * @NL80211_GSCAN_BUCKET_ATTR_MAX_PERIOD: maximum period between
+ *	consecutive scans. If specified this is a backoff bucket in
+ *	which the period increases according formula:
+ *	period(N) = period(0) * (base ^ (N/step_count))
+ * @NL80211_GSCAN_BUCKET_ATTR_EXPONENT: exponential base value as used
+ *	in given formula. This attribute is required when
+ *	@NL80211_GSCAN_BUCKET_ATTR_MAX_PERIOD is specified.
+ * @NL80211_GSCAN_BUCKET_ATTR_STEPS: step count as used in given formula.
+ *	This attribute is required when @NL80211_GSCAN_BUCKET_ATTR_MAX_PERIOD
+ *	is specified.
+ * @NL80211_GSCAN_BUCKET_ATTR_CHANNELS: nested attribute specifying the
+ *	channels that are to be scanned for this bucket.
+ * @NL80211_GSCAN_BUCKET_ATTR_MAX: highest GScan bucket attribute.
+ * @__NL80211_GSCAN_BUCKET_ATTR_AFTER_LAST: internal use.
+ */
+enum nl80211_gscan_bucket_attr {
+	__NL80211_GSCAN_BUCKET_ATTR_INVALID,
+	NL80211_GSCAN_BUCKET_ATTR_ID,
+	NL80211_GSCAN_BUCKET_ATTR_BAND,
+	NL80211_GSCAN_BUCKET_ATTR_PERIOD,
+	NL80211_GSCAN_BUCKET_ATTR_REPORT,
+	NL80211_GSCAN_BUCKET_ATTR_MAX_PERIOD,
+	NL80211_GSCAN_BUCKET_ATTR_EXPONENT,
+	NL80211_GSCAN_BUCKET_ATTR_STEPS,
+	NL80211_GSCAN_BUCKET_ATTR_CHANNELS,
+
+	/* keep last */
+	__NL80211_GSCAN_BUCKET_ATTR_AFTER_LAST,
+	NL80211_GSCAN_BUCKET_ATTR_MAX = __NL80211_GSCAN_BUCKET_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_gscan_chan_attr - GScan bucket channel parameters.
+ *
+ * @__NL80211_GSCAN_CHAN_ATTR_INVALID: reserved.
+ * @NL80211_GSCAN_CHAN_ATTR_FREQ: frequency of channel.
+ * @NL80211_GSCAN_CHAN_ATTR_DWELL_TIME: dwell time to be used for scanning
+ *	this channel.
+ * @NL80211_GSCAN_CHAN_ATTR_NO_IR: scanning should be done passive.
+ * @NL80211_GSCAN_CHAN_ATTR_MAX: highest GScan channel attribute.
+ * @__NL80211_GSCAN_CHAN_ATTR_AFTER_LAST: internal use.
+ */
+enum nl80211_gscan_chan_attr {
+	__NL80211_GSCAN_CHAN_ATTR_INVALID,
+	NL80211_GSCAN_CHAN_ATTR_FREQ,
+	NL80211_GSCAN_CHAN_ATTR_DWELL_TIME,
+	NL80211_GSCAN_CHAN_ATTR_NO_IR,
+
+	/* keep last */
+	__NL80211_GSCAN_CHAN_ATTR_AFTER_LAST,
+	NL80211_GSCAN_CHAN_ATTR_MAX = __NL80211_GSCAN_CHAN_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_bucket_band - GScan bucket band selection.
+ *
+ * @NL80211_BUCKET_BAND_2GHZ: consider all device supported channels
+ *	in 2G band.
+ * @NL80211_BUCKET_BAND_5GHZ: consider all device supported channels
+ *	in 5G band, ie. both DFS and non-DFS when @NL80211_BUCKET_BAND_NODFS
+ *	and @NL80211_BUCKET_BAND_DFS_ONLY are not set.
+ * @NL80211_BUCKET_BAND_NODFS: only consider non-DFS channels. Only
+ *	applicable when 5G band is selected, otherwise ignored.
+ * @NL80211_BUCKET_BAND_DFS_ONLY: only consider DFS channels. Only
+ *	applicable when 5G band is selected, otherwise ignored.
+ *
+ * Setting both @NL80211_BUCKET_BAND_NODFS and @NL80211_BUCKET_BAND_DFS_ONLY
+ * is considerd invalid.
+ */
+enum nl80211_bucket_band {
+	NL80211_BUCKET_BAND_2GHZ	= (1 << 0),
+	NL80211_BUCKET_BAND_5GHZ	= (1 << 1),
+	NL80211_BUCKET_BAND_NODFS	= (1 << 2),
+	NL80211_BUCKET_BAND_DFS_ONLY	= (1 << 3),
+};
+
+/**
+ * enum nl80211_bucket_report_event - GScan bucket report flags.
+ *
+ * @NL80211_BUCKET_REPORT_EACH_SCAN: trigger event after each scan.
+ * @NL80211_BUCKET_REPORT_FULL_RESULTS: report full scan results.
+ * @NL80211_BUCKET_REPORT_NO_BATCH: no batching required.
+ */
+enum nl80211_bucket_report_event {
+	NL80211_BUCKET_REPORT_EACH_SCAN		= (1 << 0),
+	NL80211_BUCKET_REPORT_FULL_RESULTS	= (1 << 1),
+	NL80211_BUCKET_REPORT_NO_BATCH		= (1 << 2),
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 158c59e..760a2fb 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -357,6 +357,20 @@ static void cfg80211_sched_scan_stop_wk(struct work_struct *work)
 	rtnl_unlock();
 }
 
+static void cfg80211_gscan_stop_wk(struct work_struct *work)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rdev = container_of(work, struct cfg80211_registered_device,
+			    gscan_stop_wk);
+
+	rtnl_lock();
+
+	__cfg80211_stop_gscan(rdev, false);
+
+	rtnl_unlock();
+}
+
 /* exported functions */
 
 struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
@@ -383,6 +397,7 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	WARN_ON(ops->remain_on_channel && !ops->cancel_remain_on_channel);
 	WARN_ON(ops->tdls_channel_switch && !ops->tdls_cancel_channel_switch);
 	WARN_ON(ops->add_tx_ts && !ops->del_tx_ts);
+	WARN_ON(ops->start_gscan && !ops->stop_gscan);
 
 	alloc_size = sizeof(*rdev) + sizeof_priv;
 
@@ -456,6 +471,7 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	spin_lock_init(&rdev->destroy_list_lock);
 	INIT_WORK(&rdev->destroy_work, cfg80211_destroy_iface_wk);
 	INIT_WORK(&rdev->sched_scan_stop_wk, cfg80211_sched_scan_stop_wk);
+	INIT_WORK(&rdev->gscan_stop_wk, cfg80211_gscan_stop_wk);
 
 #ifdef CONFIG_CFG80211_DEFAULT_PS
 	rdev->wiphy.flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
@@ -690,6 +706,12 @@ int wiphy_register(struct wiphy *wiphy)
 		    (wiphy->bss_select_support & ~(BIT(__NL80211_BSS_SELECT_ATTR_AFTER_LAST) - 2))))
 		return -EINVAL;
 
+	/* buckets must have unique index and in nl80211 parsing
+	 * a u32 is used to verify that hence this limit.
+	 */
+	if (WARN_ON(wiphy->gscan && wiphy->gscan->max_scan_buckets > 32))
+		return -EINVAL;
+
 	if (wiphy->addresses)
 		memcpy(wiphy->perm_addr, wiphy->addresses[0].addr, ETH_ALEN);
 
@@ -1001,6 +1023,7 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 {
 	struct net_device *dev = wdev->netdev;
 	struct cfg80211_sched_scan_request *sched_scan_req;
+	struct cfg80211_gscan_request *gscan_req;
 
 	ASSERT_RTNL();
 	ASSERT_WDEV_LOCK(wdev);
@@ -1014,6 +1037,9 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		sched_scan_req = rtnl_dereference(rdev->sched_scan_req);
 		if (sched_scan_req && dev == sched_scan_req->dev)
 			__cfg80211_stop_sched_scan(rdev, false);
+		gscan_req = rtnl_dereference(rdev->gscan_req);
+		if (gscan_req && dev == gscan_req->dev)
+			__cfg80211_stop_gscan(rdev, false);
 
 #ifdef CONFIG_CFG80211_WEXT
 		kfree(wdev->wext.ie);
@@ -1089,6 +1115,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev;
 	struct cfg80211_sched_scan_request *sched_scan_req;
+	struct cfg80211_gscan_request *gscan_req;
 
 	if (!wdev)
 		return NOTIFY_DONE;
@@ -1160,6 +1187,10 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			    sched_scan_req->dev == wdev->netdev)) {
 			__cfg80211_stop_sched_scan(rdev, false);
 		}
+		gscan_req = rtnl_dereference(rdev->gscan_req);
+		if (WARN_ON(gscan_req && gscan_req->dev == wdev->netdev)) {
+			__cfg80211_stop_gscan(rdev, false);
+		}
 
 		rdev->opencount--;
 		wake_up(&rdev->dev_wait);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index fb2fcd5..b0f2519 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -74,6 +74,7 @@ struct cfg80211_registered_device {
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
 	struct sk_buff *scan_msg;
 	struct cfg80211_sched_scan_request __rcu *sched_scan_req;
+	struct cfg80211_gscan_request __rcu *gscan_req;
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
 	struct work_struct sched_scan_results_wk;
@@ -95,6 +96,7 @@ struct cfg80211_registered_device {
 	struct work_struct destroy_work;
 
 	struct work_struct sched_scan_stop_wk;
+	struct work_struct gscan_stop_wk;
 
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
@@ -421,6 +423,8 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 void __cfg80211_sched_scan_results(struct work_struct *wk);
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			       bool driver_initiated);
+int __cfg80211_stop_gscan(struct cfg80211_registered_device *rdev,
+			  bool driver_initiated);
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
 int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev, enum nl80211_iftype ntype,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 073280d..7ec4bd5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -404,6 +404,7 @@ enum nl80211_multicast_groups {
 				    .len = FILS_MAX_KEK_LEN },
 	[NL80211_ATTR_FILS_NONCES] = { .len = 2 * FILS_NONCE_LEN },
 	[NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED] = { .type = NLA_FLAG, },
+	[NL80211_ATTR_GSCAN_PARAMS] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -11860,6 +11861,318 @@ static int nl80211_set_multicast_to_unicast(struct sk_buff *skb,
 	return rdev_set_multicast_to_unicast(rdev, dev, enabled);
 }
 
+static const
+struct nla_policy nl80211_gscan_policy[NL80211_GSCAN_ATTR_MAX + 1] = {
+	[NL80211_GSCAN_ATTR_BASE_PERIOD] = { .type = NLA_U32 },
+	[NL80211_GSCAN_ATTR_MAX_AP_PER_SCAN] = { .type = NLA_U32 },
+	[NL80211_GSCAN_ATTR_REPORT_PERC] = { .type = NLA_U8 },
+	[NL80211_GSCAN_ATTR_REPORT_SCANS] = { .type = NLA_U32 },
+	[NL80211_GSCAN_ATTR_BUCKETS] = { .type = NLA_NESTED },
+};
+
+static const struct nla_policy
+nl80211_gscan_bucket_policy[NL80211_GSCAN_BUCKET_ATTR_MAX + 1] = {
+	[NL80211_GSCAN_BUCKET_ATTR_ID] = { .type = NLA_U32 },
+	[NL80211_GSCAN_BUCKET_ATTR_BAND] = { .type = NLA_U32 },
+	[NL80211_GSCAN_BUCKET_ATTR_PERIOD] = { .type = NLA_U32 },
+	[NL80211_GSCAN_BUCKET_ATTR_REPORT] = { .type = NLA_U32 },
+	[NL80211_GSCAN_BUCKET_ATTR_MAX_PERIOD] = { .type = NLA_U32 },
+	[NL80211_GSCAN_BUCKET_ATTR_EXPONENT] = { .type = NLA_U32 },
+	[NL80211_GSCAN_BUCKET_ATTR_STEPS] = { .type = NLA_U32 },
+	[NL80211_GSCAN_BUCKET_ATTR_CHANNELS] = { .type = NLA_NESTED },
+};
+
+static const struct nla_policy
+nl80211_gscan_channel_policy[NL80211_GSCAN_CHAN_ATTR_MAX + 1] = {
+        [NL80211_GSCAN_CHAN_ATTR_FREQ] = { .type = NLA_U32 },
+        [NL80211_GSCAN_CHAN_ATTR_DWELL_TIME] = { .type = NLA_U32 },
+        [NL80211_GSCAN_CHAN_ATTR_NO_IR] = { .type = NLA_FLAG },
+};
+
+static int nl80211_parse_gscan_channel(struct cfg80211_registered_device *rdev,
+				       struct nlattr *nattr,
+				       struct cfg80211_gscan_channel *chan)
+{
+	struct nlattr *tb[NL80211_GSCAN_CHAN_ATTR_MAX + 1];
+	struct ieee80211_channel *ch;
+	int err;
+
+	err = nla_parse(tb, NL80211_GSCAN_CHAN_ATTR_MAX, nla_data(nattr),
+			nla_len(nattr), nl80211_gscan_channel_policy);
+	if (err)
+		return err;
+
+	if (!tb[NL80211_GSCAN_CHAN_ATTR_FREQ])
+		return -EINVAL;
+
+	ch = ieee80211_get_channel(&rdev->wiphy,
+				   nla_get_u32(tb[NL80211_GSCAN_CHAN_ATTR_FREQ]));
+	if (!ch || (ch->flags & IEEE80211_CHAN_DISABLED))
+		return -EINVAL;
+
+	chan->ch = ch;
+
+	if (tb[NL80211_GSCAN_CHAN_ATTR_DWELL_TIME])
+		chan->dwell_time = nla_get_u32(tb[NL80211_GSCAN_CHAN_ATTR_DWELL_TIME]);
+	if (tb[NL80211_GSCAN_CHAN_ATTR_NO_IR])
+		chan->passive = true;
+	return 0;
+}
+
+static int nl80211_parse_gscan_bucket(struct cfg80211_registered_device *rdev,
+				      struct nlattr *nattr,
+				      struct cfg80211_gscan_bucket *bucket,
+				      struct cfg80211_gscan_channel *channels)
+{
+	struct nlattr *tb[NL80211_GSCAN_BUCKET_ATTR_MAX + 1];
+	struct nlattr *chan;
+	struct cfg80211_gscan_channel *ch;
+	int err, rem;
+	int num_chans = 0;
+	u32 band_select = 0;
+	u32 dfs_invalid_mask;
+
+	err = nla_parse(tb, NL80211_GSCAN_BUCKET_ATTR_MAX, nla_data(nattr),
+			nla_len(nattr), nl80211_gscan_bucket_policy);
+	if (err)
+		return err;
+
+	if (!tb[NL80211_GSCAN_BUCKET_ATTR_ID] ||
+	    !tb[NL80211_GSCAN_BUCKET_ATTR_PERIOD])
+		return -EINVAL;
+
+	bucket->idx = nla_get_u32(tb[NL80211_GSCAN_BUCKET_ATTR_ID]);
+	if (tb[NL80211_GSCAN_BUCKET_ATTR_BAND]) {
+		band_select = nla_get_u32(tb[NL80211_GSCAN_BUCKET_ATTR_BAND]);
+
+		/* only makes sense if a band is selected */
+		if (!(band_select & (NL80211_BUCKET_BAND_2GHZ | NL80211_BUCKET_BAND_5GHZ)))
+			return -EINVAL;
+	}
+
+	dfs_invalid_mask = NL80211_BUCKET_BAND_5GHZ | NL80211_BUCKET_BAND_NODFS |
+			   NL80211_BUCKET_BAND_DFS_ONLY;
+	if ((band_select & dfs_invalid_mask) == dfs_invalid_mask)
+		return -EINVAL;
+
+	bucket->band = band_select;
+	bucket->period = nla_get_u32(tb[NL80211_GSCAN_BUCKET_ATTR_PERIOD]);
+
+	if (tb[NL80211_GSCAN_BUCKET_ATTR_MAX_PERIOD])
+		bucket->max_period = nla_get_u32(tb[NL80211_GSCAN_BUCKET_ATTR_MAX_PERIOD]);
+
+	if (bucket->max_period) {
+		if (bucket->max_period < bucket->period)
+			return -EINVAL;
+		/* additional attributes required for backoff bucket */
+		if (bucket->max_period > bucket->period) {
+			if (!tb[NL80211_GSCAN_BUCKET_ATTR_EXPONENT] ||
+			    !tb[NL80211_GSCAN_BUCKET_ATTR_STEPS])
+				return -EINVAL;
+
+			bucket->exponent = nla_get_u32(tb[NL80211_GSCAN_BUCKET_ATTR_EXPONENT]);
+			bucket->step_count = nla_get_u32(tb[NL80211_GSCAN_BUCKET_ATTR_STEPS]);
+		}
+	}
+
+	/* ignore channels if band is specified */
+	if (band_select)
+		return 0;
+
+        nla_for_each_nested(chan, tb[NL80211_GSCAN_BUCKET_ATTR_CHANNELS], rem) {
+                num_chans++;
+        }
+	if (num_chans > 16)
+		return -EINVAL;
+
+	bucket->n_channels = num_chans;
+	if (!num_chans)
+		return 0;
+
+	bucket->channels = channels;
+	ch = &bucket->channels[0];
+        nla_for_each_nested(chan, tb[NL80211_GSCAN_BUCKET_ATTR_CHANNELS], rem) {
+		err = nl80211_parse_gscan_channel(rdev, chan, ch);
+		if (err) {
+			return err;
+		}
+		ch++;
+        }
+
+	return 0;
+}
+
+static struct cfg80211_gscan_request *
+nl80211_alloc_gscan_request(struct cfg80211_registered_device *rdev,
+			    struct nlattr *buckets_attr)
+{
+	struct cfg80211_gscan_request *req;
+	struct cfg80211_gscan_bucket *b;
+	struct cfg80211_gscan_channel *ch;
+	int n_buckets, n_channels;
+	struct nlattr *attr, *bucket, *channel;
+	int rem, rem_b, rem_c;
+	size_t reqsize;
+
+	if (!buckets_attr)
+		return ERR_PTR(-EINVAL);
+
+	n_buckets = 0;
+	n_channels = 0;
+	nla_for_each_nested(bucket, buckets_attr, rem) {
+		n_buckets++;
+		if (n_buckets > rdev->wiphy.gscan->max_scan_buckets)
+			return ERR_PTR(-EINVAL);
+
+		nla_for_each_nested(attr, bucket, rem_b) {
+			if (nla_type(attr) == NL80211_GSCAN_BUCKET_ATTR_CHANNELS) {
+				nla_for_each_nested(channel, attr, rem_c)
+					n_channels++;
+			}
+		}
+	}
+
+	reqsize = sizeof(*req) +
+		  sizeof(*b) * n_buckets +
+		  sizeof(*ch) * n_channels;
+
+	req = kzalloc(reqsize, GFP_KERNEL);
+	if (!req)
+		return ERR_PTR(-ENOMEM);
+
+	req->n_buckets = n_buckets;
+	return req;
+}
+
+static int nl80211_parse_gscan_params(struct cfg80211_registered_device *rdev,
+				      struct nlattr *attrs[],
+				      struct cfg80211_gscan_request **request)
+{
+	struct cfg80211_gscan_request *req;
+	struct nlattr *tb[NL80211_GSCAN_ATTR_MAX + 1];
+	struct nlattr *bucket;
+	struct cfg80211_gscan_bucket *b;
+	struct cfg80211_gscan_channel *ch;
+	int err, rem, i;
+	u32 bucket_map;
+
+	if (!attrs[NL80211_ATTR_GSCAN_PARAMS])
+		return -EINVAL;
+
+	err = nla_parse(tb, NL80211_GSCAN_ATTR_MAX,
+			nla_data(attrs[NL80211_ATTR_GSCAN_PARAMS]),
+			nla_len(attrs[NL80211_ATTR_GSCAN_PARAMS]),
+			nl80211_gscan_policy);
+	if (err)
+		return err;
+
+	req = nl80211_alloc_gscan_request(rdev, tb[NL80211_GSCAN_ATTR_BUCKETS]);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	if (!tb[NL80211_GSCAN_ATTR_BASE_PERIOD])
+		return -EINVAL;
+
+	req->base_period = nla_get_u32(tb[NL80211_GSCAN_ATTR_BASE_PERIOD]);
+
+	if (tb[NL80211_GSCAN_ATTR_MAX_AP_PER_SCAN])
+		req->max_ap_per_scan = nla_get_u32(tb[NL80211_GSCAN_ATTR_MAX_AP_PER_SCAN]);
+	if (tb[NL80211_GSCAN_ATTR_REPORT_PERC])
+		req->report_threshold_percent = nla_get_u8(tb[NL80211_GSCAN_ATTR_REPORT_PERC]);
+	if (tb[NL80211_GSCAN_ATTR_REPORT_SCANS])
+		req->report_threshold_num_scans = nla_get_u32(tb[NL80211_GSCAN_ATTR_REPORT_SCANS]);
+	if (attrs[NL80211_ATTR_MAC])
+		memcpy(req->mac, nla_data(attrs[NL80211_ATTR_MAC]), ETH_ALEN);
+	if (attrs[NL80211_ATTR_MAC_MASK])
+		memcpy(req->mac_mask, nla_data(attrs[NL80211_ATTR_MAC_MASK]),
+		       ETH_ALEN);
+	if (attrs[NL80211_ATTR_SCAN_FLAGS])
+		req->flags = nla_get_u32(attrs[NL80211_ATTR_SCAN_FLAGS]);
+
+	b = &req->buckets[0];
+	ch = (struct cfg80211_gscan_channel *)(&req->buckets[req->n_buckets]);
+	nla_for_each_nested(bucket, tb[NL80211_GSCAN_ATTR_BUCKETS], rem) {
+		err = nl80211_parse_gscan_bucket(rdev, bucket, b, ch);
+		if (err)
+			goto free_req;
+		ch += b->n_channels;
+		b++;
+	}
+	bucket_map = 0;
+	for (i = 0; i < req->n_buckets; i++) {
+		if (BIT(req->buckets[i].idx) & bucket_map) {
+			err = -EINVAL;
+			goto free_req;
+		}
+		bucket_map |= BIT(req->buckets[i].idx);
+
+		if (req->buckets[i].period % req->base_period) {
+			err = -EINVAL;
+			goto free_req;
+		}
+		if (req->buckets[i].max_period &&
+		    (req->buckets[i].max_period % req->base_period)) {
+			err = -EINVAL;
+			goto free_req;
+		}
+	}
+	*request = req;
+	return 0;
+
+free_req:
+	kfree(req);
+	return err;
+}
+
+static int nl80211_start_gscan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_gscan_request *request;
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	if (!rdev->wiphy.gscan ||
+	    !rdev->ops->start_gscan)
+		return -EOPNOTSUPP;
+
+	if (rdev->gscan_req)
+		return -EINPROGRESS;
+
+	err = nl80211_parse_gscan_params(rdev, info->attrs, &request);
+	if (err)
+		return err;
+
+	wdev_lock(wdev);
+	err = rdev_start_gscan(rdev, dev, request);
+	wdev_unlock(wdev);
+	if (err) {
+		kfree(request);
+		return err;
+	}
+
+	request->dev = dev;
+	if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
+		request->owner_nlportid = info->snd_portid;
+
+	rcu_assign_pointer(rdev->gscan_req, request);
+
+	nl80211_send_scan_event(rdev, dev,
+				NL80211_CMD_START_GSCAN);
+	return 0;
+}
+
+static int nl80211_stop_gscan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+
+	if (!rdev->wiphy.gscan ||
+	    !rdev->ops->stop_gscan)
+		return -EOPNOTSUPP;
+
+	return __cfg80211_stop_gscan(rdev, false);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -12735,6 +13048,22 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_START_GSCAN,
+		.doit = nl80211_start_gscan,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_STOP_GSCAN,
+		.doit = nl80211_stop_gscan,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
@@ -14540,12 +14869,18 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list) {
 		bool schedule_destroy_work = false;
 		bool schedule_scan_stop = false;
+		bool schedule_gscan_stop = false;
 		struct cfg80211_sched_scan_request *sched_scan_req =
 			rcu_dereference(rdev->sched_scan_req);
+		struct cfg80211_gscan_request *gscan_req =
+			rcu_dereference(rdev->gscan_req);
 
 		if (sched_scan_req && notify->portid &&
 		    sched_scan_req->owner_nlportid == notify->portid)
 			schedule_scan_stop = true;
+		if (gscan_req && notify->portid &&
+		    gscan_req->owner_nlportid == notify->portid)
+			schedule_gscan_stop = true;
 
 		list_for_each_entry_rcu(wdev, &rdev->wiphy.wdev_list, list) {
 			cfg80211_mlme_unregister_socket(wdev, notify->portid);
@@ -14576,12 +14911,18 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 				spin_unlock(&rdev->destroy_list_lock);
 				schedule_work(&rdev->destroy_work);
 			}
-		} else if (schedule_scan_stop) {
-			sched_scan_req->owner_nlportid = 0;
+		} else {
+			if (schedule_scan_stop) {
+				sched_scan_req->owner_nlportid = 0;
 
-			if (rdev->ops->sched_scan_stop &&
-			    rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
-				schedule_work(&rdev->sched_scan_stop_wk);
+				if (rdev->ops->sched_scan_stop &&
+				    rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
+					schedule_work(&rdev->sched_scan_stop_wk);
+			}
+			if (schedule_gscan_stop) {
+				gscan_req->owner_nlportid = 0;
+				schedule_work(&rdev->gscan_stop_wk);
+			}
 		}
 	}
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 2f42507..196e6a7 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1153,4 +1153,29 @@ static inline int rdev_set_qos_map(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
+
+static inline int
+rdev_start_gscan(struct cfg80211_registered_device *rdev,
+		 struct net_device *dev,
+		 struct cfg80211_gscan_request *request)
+{
+	int ret;
+
+	trace_rdev_start_gscan(&rdev->wiphy, dev);
+	ret = rdev->ops->start_gscan(&rdev->wiphy, dev, request);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline int
+rdev_stop_gscan(struct cfg80211_registered_device *rdev,
+		struct net_device *dev)
+{
+	int ret;
+
+	trace_rdev_stop_gscan(&rdev->wiphy, dev);
+	ret = rdev->ops->stop_gscan(&rdev->wiphy, dev);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index dbdb53f..327b23c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -335,6 +335,34 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 	return 0;
 }
 
+int __cfg80211_stop_gscan(struct cfg80211_registered_device *rdev,
+			  bool driver_initiated)
+{
+	struct cfg80211_gscan_request *gscan_req;
+	struct net_device *dev;
+
+	ASSERT_RTNL();
+
+	if (!rdev->gscan_req)
+		return -ENOENT;
+
+	gscan_req = rtnl_dereference(rdev->gscan_req);
+	dev = gscan_req->dev;
+
+	if (!driver_initiated) {
+		int err = rdev_stop_gscan(rdev, dev);
+		if (err)
+			return err;
+	}
+
+	nl80211_send_scan_event(rdev, dev, NL80211_CMD_GSCAN_STOPPED);
+
+	RCU_INIT_POINTER(rdev->gscan_req, NULL);
+	kfree_rcu(gscan_req, rcu_head);
+
+	return 0;
+}
+
 void cfg80211_bss_age(struct cfg80211_registered_device *rdev,
                       unsigned long age_secs)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index ea1b47e..1d0fde9 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3067,6 +3067,15 @@
 		  WIPHY_PR_ARG, NETDEV_PR_ARG,
 		  BOOL_TO_STR(__entry->enabled))
 );
+
+DEFINE_EVENT(wiphy_netdev_evt, rdev_start_gscan,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
+DEFINE_EVENT(wiphy_netdev_evt, rdev_stop_gscan,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.9.1
