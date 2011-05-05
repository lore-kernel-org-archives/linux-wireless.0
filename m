Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:50427 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751599Ab1EENAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 09:00:31 -0400
Received: by mail-ey0-f170.google.com with SMTP id 5so790146eyf.15
        for <linux-wireless@vger.kernel.org>; Thu, 05 May 2011 06:00:30 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 1/3] cfg80211/nl80211: add support for scheduled scans
Date: Thu,  5 May 2011 16:00:17 +0300
Message-Id: <1304600420-24227-2-git-send-email-coelho@ti.com> (sfid-20110505_150043_963797_97041909)
In-Reply-To: <1304600420-24227-1-git-send-email-coelho@ti.com>
References: <1304600420-24227-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement new functionality for scheduled scan offload.  With this feature we
can scan automatically at certain intervals.

The idea is that the hardware can perform scan automatically and filter on
desired results without waking up the host unnecessarily.

Add NL80211_CMD_START_SCHED_SCAN and NL80211_CMD_STOP_SCHED_SCAN
commands to the nl80211 interface.  When results are available they are
reported by NL80211_CMD_SCHED_SCAN_RESULTS events.  The userspace is
informed when the scheduled scan has stopped with a
NL80211_CMD_SCHED_SCAN_STOPPED event, which can be triggered either by
the driver or by a call to NL80211_CMD_STOP_SCHED_SCAN.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 include/linux/nl80211.h |   25 +++++
 include/net/cfg80211.h  |   57 +++++++++++
 net/wireless/core.c     |   12 ++-
 net/wireless/core.h     |    7 ++
 net/wireless/nl80211.c  |  251 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    4 +
 net/wireless/scan.c     |   62 ++++++++++++
 7 files changed, 417 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 216b1d8..355fb65 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -203,6 +203,26 @@
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
  *	partial scan results may be available
  *
+ * @NL80211_CMD_START_SCHED_SCAN: start a scheduled scan.  Like with normal
+ *	scans, if SSIDs (%NL80211_ATTR_SCAN_SSIDS) are passed, they are used
+ *	in the probe requests.  For broadcast, a broadcast SSID must be
+ *	passed (ie. an empty string).  If no SSID is passed, no probe
+ *	requests are sent and a passive scan is performed.
+ *	%NL80211_ATTR_SCAN_FREQUENCIES, if passed, define which channels
+ *	should be scanned; if not passed, all channels allowed for the
+ *	current regulatory domain are used.  Extra IEs can also be passed
+ *	from the userspace by using the %NL80211_ATTR_IE attribute.
+ * @NL80211_CMD_STOP_SCHED_SCAN: stop a scheduled scan
+ * @NL80211_CMD_SCHED_SCAN_RESULTS: indicates that there are scheduled scan
+ *	results available.
+ * @NL80211_CMD_SCHED_SCAN_STOPPED: indicates that the scheduled scan has
+ *	stopped.  The driver may issue this event at any time during a
+ *	scheduled scan.  One reason for stopping the scan is if the hardware
+ *	does not support starting an association or a normal scan while running
+ *	a scheduled scan.  This event is also sent when the
+ *	%NL80211_CMD_STOP_SCHED_SCAN command is received or when the interface
+ *	is brought down while a scheduled scan was running.
+ *
  * @NL80211_CMD_GET_SURVEY: get survey resuls, e.g. channel occupation
  *      or noise level
  * @NL80211_CMD_NEW_SURVEY_RESULTS: survey data notification (as a reply to
@@ -534,6 +554,11 @@ enum nl80211_commands {
 
 	NL80211_CMD_NEW_PEER_CANDIDATE,
 
+	NL80211_CMD_START_SCHED_SCAN,
+	NL80211_CMD_STOP_SCHED_SCAN,
+	NL80211_CMD_SCHED_SCAN_RESULTS,
+	NL80211_CMD_SCHED_SCAN_STOPPED,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d30eada..117df56 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -793,6 +793,33 @@ struct cfg80211_scan_request {
 };
 
 /**
+ * struct cfg80211_sched_scan_request - scheduled scan request description
+ *
+ * @ssids: SSIDs to report (other SSIDs will be filtered out)
+ * @n_ssids: number of SSIDs
+ * @n_channels: total number of channels to scan
+ * @ie: optional information element(s) to add into Probe Request or %NULL
+ * @ie_len: length of ie in octets
+ * @wiphy: the wiphy this was for
+ * @dev: the interface
+ * @channels: channels to scan
+ */
+struct cfg80211_sched_scan_request {
+	struct cfg80211_ssid *ssids;
+	int n_ssids;
+	u32 n_channels;
+	const u8 *ie;
+	size_t ie_len;
+
+	/* internal */
+	struct wiphy *wiphy;
+	struct net_device *dev;
+
+	/* keep last */
+	struct ieee80211_channel *channels[0];
+};
+
+/**
  * enum cfg80211_signal_type - signal type
  *
  * @CFG80211_SIGNAL_TYPE_NONE: no signal strength information available
@@ -1227,6 +1254,10 @@ struct cfg80211_pmksa {
  * @set_power_mgmt: Configure WLAN power management. A timeout value of -1
  *	allows the driver to adjust the dynamic ps timeout value.
  * @set_cqm_rssi_config: Configure connection quality monitor RSSI threshold.
+ * @sched_scan_start: Tell the driver to start a scheduled scan.
+ * @sched_scan_stop: Tell the driver to stop an ongoing scheduled
+ *	scan.  The driver_initiated flag specifies whether the driver
+ *	itself has informed that the scan has stopped.
  *
  * @mgmt_frame_register: Notify driver that a management frame type was
  *	registered. Note that this callback may not sleep, and cannot run
@@ -1413,6 +1444,12 @@ struct cfg80211_ops {
 	int	(*set_ringparam)(struct wiphy *wiphy, u32 tx, u32 rx);
 	void	(*get_ringparam)(struct wiphy *wiphy,
 				 u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);
+
+	int	(*sched_scan_start)(struct wiphy *wiphy,
+				struct net_device *dev,
+				struct cfg80211_sched_scan_request *request);
+	int	(*sched_scan_stop)(struct wiphy *wiphy, struct net_device *dev,
+				   bool driver_initiated);
 };
 
 /*
@@ -1459,6 +1496,7 @@ struct cfg80211_ops {
  *	unicast and multicast TX keys.
  * @WIPHY_FLAG_MESH_AUTH: The device supports mesh authentication by routing
  *	auth frames to userspace. See @NL80211_MESH_SETUP_USERSPACE_AUTH.
+ * @WIPHY_FLAG_SCHED_SCAN: The device supports scheduled scans.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1472,6 +1510,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
 	WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS= BIT(9),
 	WIPHY_FLAG_MESH_AUTH			= BIT(10),
+	WIPHY_FLAG_SUPPORTS_SCHED_SCAN		= BIT(11),
 };
 
 struct mac_address {
@@ -2257,6 +2296,24 @@ int cfg80211_wext_siwpmksa(struct net_device *dev,
 void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted);
 
 /**
+ * cfg80211_sched_scan_results - notify that new scan results are available
+ *
+ * @wiphy: the wiphy which got scheduled scan results
+ */
+void cfg80211_sched_scan_results(struct wiphy *wiphy);
+
+/**
+ * cfg80211_sched_scan_stopped - notify that the scheduled scan has stopped
+ *
+ * @wiphy: the wiphy on which the scheduled scan stopped
+ *
+ * The driver can call this function to inform cfg80211 that the
+ * scheduled scan had to be stopped, for whatever reason.  The driver
+ * is then called back via the sched_scan_stop operation when done.
+ */
+void cfg80211_sched_scan_stopped(struct wiphy *wiphy);
+
+/**
  * cfg80211_inform_bss_frame - inform cfg80211 of a received BSS frame
  *
  * @wiphy: the wiphy reporting the BSS
diff --git a/net/wireless/core.c b/net/wireless/core.c
index bbf1fa1..e99efe6 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -370,7 +370,8 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	spin_lock_init(&rdev->bss_lock);
 	INIT_LIST_HEAD(&rdev->bss_list);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
-
+	INIT_WORK(&rdev->sched_scan_results_wk, __cfg80211_sched_scan_results);
+	INIT_WORK(&rdev->sched_scan_stopped_wk, __cfg80211_sched_scan_stopped);
 #ifdef CONFIG_CFG80211_WEXT
 	rdev->wiphy.wext = &cfg80211_wext_handler;
 #endif
@@ -664,6 +665,11 @@ static void wdev_cleanup_work(struct work_struct *work)
 		___cfg80211_scan_done(rdev, true);
 	}
 
+	if (WARN_ON(rdev->sched_scan_req &&
+		    rdev->sched_scan_req->dev == wdev->netdev)) {
+		__cfg80211_stop_sched_scan(rdev, false);
+	}
+
 	cfg80211_unlock_rdev(rdev);
 
 	mutex_lock(&rdev->devlist_mtx);
@@ -751,6 +757,10 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 			break;
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_STATION:
+			cfg80211_lock_rdev(rdev);
+			__cfg80211_stop_sched_scan(rdev, false);
+			cfg80211_unlock_rdev(rdev);
+
 			wdev_lock(wdev);
 #ifdef CONFIG_CFG80211_WEXT
 			kfree(wdev->wext.ie);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 26a0a08..8bb4b75 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -60,8 +60,11 @@ struct cfg80211_registered_device {
 	struct rb_root bss_tree;
 	u32 bss_generation;
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
+	struct cfg80211_sched_scan_request *sched_scan_req;
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
+	struct work_struct sched_scan_results_wk;
+	struct work_struct sched_scan_stopped_wk;
 
 #ifdef CONFIG_NL80211_TESTMODE
 	struct genl_info *testmode_info;
@@ -397,6 +400,10 @@ void cfg80211_sme_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
 void cfg80211_sme_disassoc(struct net_device *dev, int idx);
 void __cfg80211_scan_done(struct work_struct *wk);
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak);
+void __cfg80211_sched_scan_results(struct work_struct *wk);
+int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
+			       bool driver_initiated);
+void __cfg80211_sched_scan_stopped(struct work_struct *wk);
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
 int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev, enum nl80211_iftype ntype,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0efa7fd..a971501 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -749,6 +749,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	}
 	CMD(set_channel, SET_CHANNEL);
 	CMD(set_wds_peer, SET_WDS_PEER);
+	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
+		CMD(sched_scan_start, START_SCHED_SCAN);
 
 #undef CMD
 
@@ -3318,6 +3320,180 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int nl80211_start_sched_scan(struct sk_buff *skb,
+				    struct genl_info *info)
+{
+	struct cfg80211_sched_scan_request *request;
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct cfg80211_ssid *ssid;
+	struct ieee80211_channel *channel;
+	struct nlattr *attr;
+	struct wiphy *wiphy;
+	int err, tmp, n_ssids = 0, n_channels, i;
+	enum ieee80211_band band;
+	size_t ie_len;
+
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
+	    !rdev->ops->sched_scan_start)
+		return -EOPNOTSUPP;
+
+	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
+		return -EINVAL;
+
+	if (rdev->sched_scan_req)
+		return -EINPROGRESS;
+
+	wiphy = &rdev->wiphy;
+
+	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
+		n_channels = validate_scan_freqs(
+				info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]);
+		if (!n_channels)
+			return -EINVAL;
+	} else {
+		n_channels = 0;
+
+		for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+			if (wiphy->bands[band])
+				n_channels += wiphy->bands[band]->n_channels;
+	}
+
+	if (info->attrs[NL80211_ATTR_SCAN_SSIDS])
+		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS],
+				    tmp)
+			n_ssids++;
+
+	if (n_ssids > wiphy->max_scan_ssids)
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_IE])
+		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	else
+		ie_len = 0;
+
+	if (ie_len > wiphy->max_scan_ie_len)
+		return -EINVAL;
+
+	request = kzalloc(sizeof(*request)
+			+ sizeof(*ssid) * n_ssids
+			+ sizeof(channel) * n_channels
+			+ ie_len, GFP_KERNEL);
+	if (!request)
+		return -ENOMEM;
+
+	if (n_ssids)
+		request->ssids = (void *)&request->channels[n_channels];
+	request->n_ssids = n_ssids;
+	if (ie_len) {
+		if (request->ssids)
+			request->ie = (void *)(request->ssids + n_ssids);
+		else
+			request->ie = (void *)(request->channels + n_channels);
+	}
+
+	i = 0;
+	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
+		/* user specified, bail out if channel not found */
+		nla_for_each_nested(attr,
+				    info->attrs[NL80211_ATTR_SCAN_FREQUENCIES],
+				    tmp) {
+			struct ieee80211_channel *chan;
+
+			chan = ieee80211_get_channel(wiphy, nla_get_u32(attr));
+
+			if (!chan) {
+				err = -EINVAL;
+				goto out_free;
+			}
+
+			/* ignore disabled channels */
+			if (chan->flags & IEEE80211_CHAN_DISABLED)
+				continue;
+
+			request->channels[i] = chan;
+			i++;
+		}
+	} else {
+		/* all channels */
+		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+			int j;
+			if (!wiphy->bands[band])
+				continue;
+			for (j = 0; j < wiphy->bands[band]->n_channels; j++) {
+				struct ieee80211_channel *chan;
+
+				chan = &wiphy->bands[band]->channels[j];
+
+				if (chan->flags & IEEE80211_CHAN_DISABLED)
+					continue;
+
+				request->channels[i] = chan;
+				i++;
+			}
+		}
+	}
+
+	if (!i) {
+		err = -EINVAL;
+		goto out_free;
+	}
+
+	request->n_channels = i;
+
+	i = 0;
+	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
+		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS],
+				    tmp) {
+			if (request->ssids[i].ssid_len >
+			    IEEE80211_MAX_SSID_LEN) {
+				err = -EINVAL;
+				goto out_free;
+			}
+			memcpy(request->ssids[i].ssid, nla_data(attr),
+			       nla_len(attr));
+			request->ssids[i].ssid_len = nla_len(attr);
+			i++;
+		}
+	}
+
+	if (info->attrs[NL80211_ATTR_IE]) {
+		request->ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+		memcpy((void *)request->ie,
+		       nla_data(info->attrs[NL80211_ATTR_IE]),
+		       request->ie_len);
+	}
+
+	request->dev = dev;
+	request->wiphy = &rdev->wiphy;
+
+	rdev->sched_scan_req = request;
+
+	err = rdev->ops->sched_scan_start(&rdev->wiphy, dev, request);
+	if (!err)
+		nl80211_send_sched_scan(rdev, dev,
+					NL80211_CMD_START_SCHED_SCAN);
+	else {
+out_free:
+		kfree(request);
+		rdev->sched_scan_req = NULL;
+	}
+
+	return err;
+}
+
+static int nl80211_stop_sched_scan(struct sk_buff *skb,
+				   struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
+	    !rdev->ops->sched_scan_stop)
+		return -EOPNOTSUPP;
+
+	return __cfg80211_stop_sched_scan(rdev, false);
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
 			    struct wireless_dev *wdev,
@@ -5100,6 +5276,22 @@ static struct genl_ops nl80211_ops[] = {
 		.dumpit = nl80211_dump_scan,
 	},
 	{
+		.cmd = NL80211_CMD_START_SCHED_SCAN,
+		.doit = nl80211_start_sched_scan,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_STOP_SCHED_SCAN,
+		.doit = nl80211_stop_sched_scan,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
 		.cmd = NL80211_CMD_AUTHENTICATE,
 		.doit = nl80211_authenticate,
 		.policy = nl80211_policy,
@@ -5409,6 +5601,28 @@ static int nl80211_send_scan_msg(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static int
+nl80211_send_sched_scan_msg(struct sk_buff *msg,
+			    struct cfg80211_registered_device *rdev,
+			    struct net_device *netdev,
+			    u32 pid, u32 seq, int flags, u32 cmd)
+{
+	void *hdr;
+
+	hdr = nl80211hdr_put(msg, pid, seq, flags, cmd);
+	if (!hdr)
+		return -1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+
+	return genlmsg_end(msg, hdr);
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
 void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev)
 {
@@ -5466,6 +5680,43 @@ void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 				nl80211_scan_mcgrp.id, GFP_KERNEL);
 }
 
+void nl80211_send_sched_scan_results(struct cfg80211_registered_device *rdev,
+				     struct net_device *netdev)
+{
+	struct sk_buff *msg;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	if (nl80211_send_sched_scan_msg(msg, rdev, netdev, 0, 0, 0,
+					NL80211_CMD_SCHED_SCAN_RESULTS) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_scan_mcgrp.id, GFP_KERNEL);
+}
+
+void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
+			     struct net_device *netdev, u32 cmd)
+{
+	struct sk_buff *msg;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	if (nl80211_send_sched_scan_msg(msg, rdev, netdev, 0, 0, 0, cmd) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_scan_mcgrp.id, GFP_KERNEL);
+}
+
 /*
  * This can happen on global regulatory changes or device specific settings
  * based on custom world regulatory domains.
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index f2af695..2f1bfb8 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -12,6 +12,10 @@ void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
 			    struct net_device *netdev);
 void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev);
+void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
+			     struct net_device *netdev, u32 cmd);
+void nl80211_send_sched_scan_results(struct cfg80211_registered_device *rdev,
+				     struct net_device *netdev);
 void nl80211_send_reg_change_event(struct regulatory_request *request);
 void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
 			  struct net_device *netdev,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index fbf6f33..6e82215 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -93,6 +93,68 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
 }
 EXPORT_SYMBOL(cfg80211_scan_done);
 
+void __cfg80211_sched_scan_results(struct work_struct *wk)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rdev = container_of(wk, struct cfg80211_registered_device,
+			    sched_scan_results_wk);
+
+	cfg80211_lock_rdev(rdev);
+	nl80211_send_sched_scan_results(rdev, rdev->sched_scan_req->dev);
+	cfg80211_unlock_rdev(rdev);
+}
+
+void cfg80211_sched_scan_results(struct wiphy *wiphy)
+{
+	queue_work(cfg80211_wq, &wiphy_to_dev(wiphy)->sched_scan_results_wk);
+}
+EXPORT_SYMBOL(cfg80211_sched_scan_results);
+
+void __cfg80211_sched_scan_stopped(struct work_struct *wk)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rdev = container_of(wk, struct cfg80211_registered_device,
+			    sched_scan_stopped_wk);
+
+	cfg80211_lock_rdev(rdev);
+	__cfg80211_stop_sched_scan(rdev, true);
+	cfg80211_unlock_rdev(rdev);
+}
+
+void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
+{
+	queue_work(cfg80211_wq, &wiphy_to_dev(wiphy)->sched_scan_stopped_wk);
+}
+EXPORT_SYMBOL(cfg80211_sched_scan_stopped);
+
+int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
+			       bool driver_initiated)
+{
+	int err;
+	struct net_device *dev;
+
+	ASSERT_RDEV_LOCK(rdev);
+
+	if (!rdev->sched_scan_req)
+		return 0;
+
+	dev = rdev->sched_scan_req->dev;
+
+	err = rdev->ops->sched_scan_stop(&rdev->wiphy, dev,
+					 driver_initiated);
+	if (err)
+		return err;
+
+	nl80211_send_sched_scan(rdev, dev, NL80211_CMD_SCHED_SCAN_STOPPED);
+
+	kfree(rdev->sched_scan_req);
+	rdev->sched_scan_req = NULL;
+
+	return err;
+}
+
 static void bss_release(struct kref *ref)
 {
 	struct cfg80211_internal_bss *bss;
-- 
1.7.1

