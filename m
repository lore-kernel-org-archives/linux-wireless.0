Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:33197 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbcJUAtT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Oct 2016 20:49:19 -0400
Received: by mail-lf0-f67.google.com with SMTP id l131so2857121lfl.0
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2016 17:49:18 -0700 (PDT)
Received: from localhost.localdomain (55.red-88-27-2.staticip.rima-tde.net. [88.27.2.55])
        by smtp.gmail.com with ESMTPSA id 129sm1329116wmq.9.2016.10.20.17.49.14
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 20 Oct 2016 17:49:16 -0700 (PDT)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH][RFC] nl80211/mac80211: Rounded RSSI reporting
Date: Fri, 21 Oct 2016 02:49:07 +0200
Message-Id: <1477010947-6207-1-git-send-email-andrew.zaborowski@intel.com> (sfid-20161021_024924_244249_6C67A54C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm looking for a way to enable userspace to receive RSSI updates
without polling and waking up only as often as needed, for use in a
wifi daemon oriented for low power.  Userspace tends to display a wifi
icon with the rssi shown as a number of "signal bars", usually 4, 5,
or 6.  This patch adds an nl80211 CQM command and an event to report
exactly this information and nothing more.  The
NL80211_ATTR_CQM_ROUNDED_RSSI_STEPS attribute is used to set how many
bars are used and assumes -100dbm to be the minimum.  It's not very
flexible.  It may be better, for example to accept a list of thresholds
and a hysteresis value to be used in the same way as with the
NL80211_ATTR_CQM_RSSI_THOLD attribute, or even modify it to allow
multiple thresholds to be given but that would need a problematic
driver api change.  What would be the best way to do that?

The assumption is that you can't simulate the same behavior with just
the current NL80211_ATTR_CQM_RSSI_THOLD attribute.

Best regards
---
 include/net/cfg80211.h       | 21 ++++++++++++++++++
 include/net/mac80211.h       |  4 ++++
 include/uapi/linux/nl80211.h | 10 +++++++++
 net/mac80211/cfg.c           | 18 +++++++++++++++
 net/mac80211/ieee80211_i.h   | 11 ++++++++--
 net/mac80211/mlme.c          | 27 +++++++++++++++++++++++
 net/wireless/nl80211.c       | 52 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 11 ++++++++++
 net/wireless/trace.h         | 33 ++++++++++++++++++++++++++++
 9 files changed, 185 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bd19faa..3487b3f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2606,6 +2606,10 @@ struct cfg80211_nan_func {
  *	disabled.)
  * @set_cqm_txe_config: Configure connection quality monitor TX error
  *	thresholds.
+ * @set_cqm_rssi_steps: Configure number of RSSI levels for the connection
+ *	quality monitor to use in deciding when to send rounded RSSI change
+ *	events.  After configuration, the driver should (soon) send an event
+ *	indicating the current level out of the number of levels set.
  * @sched_scan_start: Tell the driver to start a scheduled scan.
  * @sched_scan_stop: Tell the driver to stop an ongoing scheduled scan. This
  *	call must stop the scheduled scan and be ready for starting a new one
@@ -2891,6 +2895,9 @@ struct cfg80211_ops {
 				      struct net_device *dev,
 				      u32 rate, u32 pkts, u32 intvl);
 
+	int	(*set_cqm_rssi_steps)(struct wiphy *wiphy,
+				      struct net_device *dev, u32 steps);
+
 	void	(*mgmt_frame_register)(struct wiphy *wiphy,
 				       struct wireless_dev *wdev,
 				       u16 frame_type, bool reg);
@@ -5213,6 +5220,20 @@ void cfg80211_cqm_txe_notify(struct net_device *dev, const u8 *peer,
 void cfg80211_cqm_beacon_loss_notify(struct net_device *dev, gfp_t gfp);
 
 /**
+ * cfg80211_cqm_rounded_rssi_notify - connection quality monitoring rssi event
+ * @dev: network device
+ * @signal_level: the signal level in the range of 0 to (steps - 1)
+ * @gfp: context flags
+ *
+ * This function is called when the RSSI level, rounded to the resolution
+ * set by cfg80211_ops::set_cqm_rssi_steps, has changed.  In other words
+ * the RSSI value has gone from one of the equally sized intervals, covering
+ * the range of -100dBm to 0, to another.
+ */
+void cfg80211_cqm_rounded_rssi_notify(struct net_device *dev,
+				      u32 signal_level, gfp_t gfp);
+
+/**
  * cfg80211_radar_event - radar detection event
  * @wiphy: the wiphy
  * @chandef: chandef for the current channel
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a810dfc..5fbe275 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -503,6 +503,9 @@ struct ieee80211_mu_group_data {
  *	cause an event to be sent indicating where the current value is in
  *	relation to the newly configured threshold.
  * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis
+ * @cqm_rssi_steps: Connection quality monitor's number of RSSI levels to
+ *	use when sending rounded RSSI change events.  A zero value implies this
+ *	event is disabled.
  * @arp_addr_list: List of IPv4 addresses for hardware ARP filtering. The
  *	may filter ARP queries targeted for other addresses than listed here.
  *	The driver must allow ARP queries targeted for all address listed here
@@ -554,6 +557,7 @@ struct ieee80211_bss_conf {
 	u16 ht_operation_mode;
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
+	u32 cqm_rssi_steps;
 	struct cfg80211_chan_def chandef;
 	struct ieee80211_mu_group_data mu_group;
 	__be32 arp_addr_list[IEEE80211_BSS_ARP_ADDR_LIST_LEN];
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 56368e9..a2c8817 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3859,6 +3859,14 @@ enum nl80211_ps_state {
  *	%NL80211_CMD_NOTIFY_CQM. Set to 0 to turn off TX error reporting.
  * @NL80211_ATTR_CQM_BEACON_LOSS_EVENT: flag attribute that's set in a beacon
  *	loss event
+ * @NL80211_ATTR_CQM_ROUNDED_RSSI_STEPS: number of evenly spaced RSSI ranges
+ *	to be distinguished between -100 dBm and 0. %NL80211_CMD_NOTIFY_CQM
+ *	events will be sent when the RSSI value crosses from one range of
+ *	values to another.  Set to 0 to disable
+ *	%NL80211_ATTR_CQM_ROUNDED_RSSI_EVENT reporting.
+ * @NL80211_ATTR_CQM_ROUNDED_RSSI_EVENT: the RSSI level with range reduced to
+ *	0 to steps - 1 as configured in %NL80211_ATTR_CQM_ROUNDED_RSSI_STEPS
+ *	value.
  * @__NL80211_ATTR_CQM_AFTER_LAST: internal
  * @NL80211_ATTR_CQM_MAX: highest key attribute
  */
@@ -3872,6 +3880,8 @@ enum nl80211_attr_cqm {
 	NL80211_ATTR_CQM_TXE_PKTS,
 	NL80211_ATTR_CQM_TXE_INTVL,
 	NL80211_ATTR_CQM_BEACON_LOSS_EVENT,
+	NL80211_ATTR_CQM_ROUNDED_RSSI_STEPS,
+	NL80211_ATTR_CQM_ROUNDED_RSSI_EVENT,
 
 	/* keep last */
 	__NL80211_ATTR_CQM_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index fd6541f..73550a7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2657,6 +2657,23 @@ static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_set_cqm_rssi_steps(struct wiphy *wiphy,
+					 struct net_device *dev,
+					 u32 steps)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_vif *vif = &sdata->vif;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+
+	if (sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER)
+		return -EOPNOTSUPP;
+
+	bss_conf->cqm_rssi_steps = steps;
+	sdata->u.mgd.last_cqm_event_rounded_rssi = 0;
+
+	return 0;
+}
+
 static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 				      struct net_device *dev,
 				      const u8 *addr,
@@ -3645,6 +3662,7 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.mgmt_tx = ieee80211_mgmt_tx,
 	.mgmt_tx_cancel_wait = ieee80211_mgmt_tx_cancel_wait,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
+	.set_cqm_rssi_steps = ieee80211_set_cqm_rssi_steps,
 	.mgmt_frame_register = ieee80211_mgmt_frame_register,
 	.set_antenna = ieee80211_set_antenna,
 	.get_antenna = ieee80211_get_antenna,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 34c2add..1c04c21 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -507,12 +507,19 @@ struct ieee80211_if_managed {
 
 	/*
 	 * Last Beacon frame signal strength average (ave_beacon_signal / 16)
-	 * that triggered a cqm event. 0 indicates that no event has been
-	 * generated for the current association.
+	 * that triggered a cqm RSSI threshold-crossed event. 0 indicates
+	 * that no event has been generated for the current association.
 	 */
 	int last_cqm_event_signal;
 
 	/*
+	 * Last Beacon frame signal strength average (ave_beacon_signal / 16)
+	 * that triggered a cqm rounded RSSI level event. 0 indicates that no
+	 * event has been generated for the current association.
+	 */
+	int last_cqm_event_rounded_rssi;
+
+	/*
 	 * State variables for keeping track of RSSI of the AP currently
 	 * connected to and informing driver when RSSI has gone
 	 * below/above a certain threshold.
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7486f2d..a87422b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3253,6 +3253,14 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 		ieee80211_reset_ap_probe(sdata);
 }
 
+static void ieee80211_cqm_rounded_rssi_notify(struct ieee80211_vif *vif,
+					      u32 signal_level, gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	cfg80211_cqm_rounded_rssi_notify(sdata->dev, signal_level, gfp);
+}
+
 /*
  * This is the canonical list of information elements we care about,
  * the filter code also gives us all changes to the Microsoft OUI
@@ -3416,6 +3424,25 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
+	if (bss_conf->cqm_rssi_steps &&
+	    ifmgd->count_beacon_signal >= IEEE80211_SIGNAL_AVE_MIN_COUNT) {
+		int sig = -ewma_beacon_signal_read(&ifmgd->ave_beacon_signal);
+		int last_event = ifmgd->last_cqm_event_rounded_rssi;
+		int steps = bss_conf->cqm_rssi_steps;
+		int last_level = (last_event + 100) * steps / 100;
+		int cur_level = (sig + 100) * steps / 100;
+		/* Use a threshold of 1/4th of the step size (100dBm / steps) */
+		int thold = 25 / steps;
+
+		if (last_event == 0 ||
+		    (cur_level < last_level && sig < last_event - thold) ||
+		    (cur_level > last_level && sig > last_event + thold)) {
+			ifmgd->last_cqm_event_rounded_rssi = sig;
+			ieee80211_cqm_rounded_rssi_notify(
+					&sdata->vif, cur_level, GFP_KERNEL);
+		}
+	}
+
 	if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL) {
 		mlme_dbg_ratelimited(sdata,
 				     "cancelling AP probe due to a received beacon\n");
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c510810..5bfc853 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9278,6 +9278,8 @@ nl80211_attr_cqm_policy[NL80211_ATTR_CQM_MAX + 1] = {
 	[NL80211_ATTR_CQM_TXE_RATE] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM_TXE_PKTS] = { .type = NLA_U32 },
 	[NL80211_ATTR_CQM_TXE_INTVL] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_ROUNDED_RSSI_STEPS] = { .type = NLA_U32 },
+	[NL80211_ATTR_CQM_ROUNDED_RSSI_EVENT] = { .type = NLA_U32 },
 };
 
 static int nl80211_set_cqm_txe(struct genl_info *info,
@@ -9324,6 +9326,25 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 	return rdev_set_cqm_rssi_config(rdev, dev, threshold, hysteresis);
 }
 
+static int nl80211_set_cqm_rounded_rssi_steps(struct genl_info *info, u32 steps)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (steps == 1)
+		return -EINVAL;
+
+	if (!rdev->ops->set_cqm_rssi_steps)
+		return -EOPNOTSUPP;
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+		return -EOPNOTSUPP;
+
+	return rdev_set_cqm_rssi_steps(rdev, dev, steps);
+}
+
 static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *attrs[NL80211_ATTR_CQM_MAX + 1];
@@ -9357,6 +9378,13 @@ static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
 		return nl80211_set_cqm_txe(info, rate, pkts, intvl);
 	}
 
+	if (attrs[NL80211_ATTR_CQM_ROUNDED_RSSI_STEPS]) {
+		u32 steps = nla_get_u32(
+				attrs[NL80211_ATTR_CQM_ROUNDED_RSSI_STEPS]);
+
+		return nl80211_set_cqm_rounded_rssi_steps(info, steps);
+	}
+
 	return -EINVAL;
 }
 
@@ -13832,6 +13860,30 @@ void cfg80211_cqm_beacon_loss_notify(struct net_device *dev, gfp_t gfp)
 }
 EXPORT_SYMBOL(cfg80211_cqm_beacon_loss_notify);
 
+void cfg80211_cqm_rounded_rssi_notify(struct net_device *dev,
+				      u32 signal_level, gfp_t gfp)
+{
+	struct sk_buff *msg;
+
+	trace_cfg80211_cqm_rounded_rssi_notify(dev, signal_level);
+
+	msg = cfg80211_prepare_cqm(dev, NULL, gfp);
+	if (!msg)
+		return;
+
+	if (nla_put_u32(msg, NL80211_ATTR_CQM_ROUNDED_RSSI_EVENT,
+			signal_level))
+		goto nla_put_failure;
+
+	cfg80211_send_cqm(msg, gfp);
+
+	return;
+
+ nla_put_failure:
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_cqm_rounded_rssi_notify);
+
 static void nl80211_gtk_rekey_notify(struct cfg80211_registered_device *rdev,
 				     struct net_device *netdev, const u8 *bssid,
 				     const u8 *replay_ctr, gfp_t gfp)
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 11cf83c..3521a2f 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -737,6 +737,17 @@ rdev_set_cqm_txe_config(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_set_cqm_rssi_steps(struct cfg80211_registered_device *rdev,
+			struct net_device *dev, u32 steps)
+{
+	int ret;
+	trace_rdev_set_cqm_rssi_steps(&rdev->wiphy, dev, steps);
+	ret = rdev->ops->set_cqm_rssi_steps(&rdev->wiphy, dev, steps);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline void
 rdev_mgmt_frame_register(struct cfg80211_registered_device *rdev,
 			 struct wireless_dev *wdev, u16 frame_type, bool reg)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index a3d0a91..dbc2450 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1327,6 +1327,24 @@ TRACE_EVENT(rdev_set_cqm_txe_config,
 		  __entry->intvl)
 );
 
+TRACE_EVENT(rdev_set_cqm_rssi_steps,
+	TP_PROTO(struct wiphy *wiphy,
+		 struct net_device *netdev, u32 steps),
+	TP_ARGS(wiphy, netdev, steps),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(u32, steps)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->steps = steps;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", steps: %u ",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->steps)
+);
+
 TRACE_EVENT(rdev_disconnect,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 u16 reason_code),
@@ -2486,6 +2504,21 @@ TRACE_EVENT(cfg80211_cqm_rssi_notify,
 		  NETDEV_PR_ARG, __entry->rssi_event)
 );
 
+TRACE_EVENT(cfg80211_cqm_rounded_rssi_notify,
+	TP_PROTO(struct net_device *netdev, u32 signal_level),
+	TP_ARGS(netdev, signal_level),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		__field(u32 signal_level)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		__entry->signal_level = signal_level;
+	),
+	TP_printk(NETDEV_PR_FMT ", signal_level: %d",
+		  NETDEV_PR_ARG, __entry->signal_level)
+);
+
 TRACE_EVENT(cfg80211_reg_can_beacon,
 	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef,
 		 enum nl80211_iftype iftype, bool check_no_ir),
-- 
2.7.4
