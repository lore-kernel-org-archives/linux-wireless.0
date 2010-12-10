Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:25817 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab0LJPGA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 10:06:00 -0500
From: luciano.coelho@nokia.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC v2 1/2] cfg80211/nl80211: add support for scheduled scans
Date: Fri, 10 Dec 2010 17:07:11 +0200
Message-Id: <1291993632-6921-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1291993632-6921-1-git-send-email-luciano.coelho@nokia.com>
References: <1291993632-6921-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

Implement new functionality for scheduled scan offload.  With this feature we
can scan automatically for specific SSIDs (or any if not specified) at
certain intervals.

The idea is that the hardware can perform scan automatically and filter on
desired results without waking up the host unnecessarily.

Add NL80211_CMD_START_SCHED_SCAN and NL80211_CMD_STOP_SCHED_SCAN
commands to the nl80211 interface.  When results are available they are
reported by NL80211_CMD_SCHED_SCAN_RESULTS events.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 include/linux/nl80211.h |    9 ++
 include/net/cfg80211.h  |   48 +++++++++
 net/wireless/core.c     |    6 +
 net/wireless/core.h     |    3 +
 net/wireless/nl80211.c  |  271 +++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    6 +
 net/wireless/scan.c     |   18 +++
 7 files changed, 361 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3804212..4571a90 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -199,6 +199,11 @@
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
  *	partial scan results may be available
  *
+ * @NL80211_CMD_START_SCHED_SCAN: start a periodic scan
+ * @NL80211_CMD_STOP_SCHED_SCAN: stop a periodic scan
+ * @NL80211_CMD_SCHED_SCAN_RESULTS: there are periodic scan results
+ *	available.
+ *
  * @NL80211_CMD_GET_SURVEY: get survey resuls, e.g. channel occupation
  *      or noise level
  * @NL80211_CMD_NEW_SURVEY_RESULTS: survey data notification (as a reply to
@@ -508,6 +513,10 @@ enum nl80211_commands {
 	NL80211_CMD_JOIN_MESH,
 	NL80211_CMD_LEAVE_MESH,
 
+	NL80211_CMD_START_SCHED_SCAN,
+	NL80211_CMD_STOP_SCHED_SCAN,
+	NL80211_CMD_SCHED_SCAN_RESULTS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0d59799..ff2e8fe 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -741,6 +741,33 @@ struct cfg80211_scan_request {
 };
 
 /**
+ * struct cfg80211_sched_scan_request - periodic scan request description
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
@@ -1173,6 +1200,8 @@ struct cfg80211_pmksa {
  * @set_power_mgmt: Configure WLAN power management. A timeout value of -1
  *	allows the driver to adjust the dynamic ps timeout value.
  * @set_cqm_rssi_config: Configure connection quality monitor RSSI threshold.
+ * @sched_scan_start: Tell the driver to start a periodic scan.
+ * @sched_scan_stop: Tell the driver to stop an ongoing periodic scan.
  *
  * @mgmt_frame_register: Notify driver that a management frame type was
  *	registered. Note that this callback may not sleep, and cannot run
@@ -1351,6 +1380,12 @@ struct cfg80211_ops {
 
 	int	(*set_antenna)(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant);
 	int	(*get_antenna)(struct wiphy *wiphy, u32 *tx_ant, u32 *rx_ant);
+
+	int	(*sched_scan_start)(struct wiphy *wiphy,
+				    struct net_device *dev,
+				    struct cfg80211_sched_scan_request *request);
+	int	(*sched_scan_stop)(struct wiphy *wiphy,
+				   struct net_device *dev);
 };
 
 /*
@@ -1393,6 +1428,7 @@ struct cfg80211_ops {
  *	control port protocol ethertype. The device also honours the
  *	control_port_no_encrypt flag.
  * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
+ * @WIPHY_FLAG_SCHED_SCAN: The device supports scheduled scans
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1404,6 +1440,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
+	WIPHY_FLAG_SUPPORTS_SCHED_SCAN		= BIT(9),
 };
 
 struct mac_address {
@@ -1457,6 +1494,8 @@ struct ieee80211_txrx_stypes {
  * @max_scan_ie_len: maximum length of user-controlled IEs device can
  *	add to probe request frames transmitted during a scan, must not
  *	include fixed IEs like supported rates
+ * @max_sched_scan_ssids: maximum number of SSIDs the device can use in
+ *	periodic scans
  * @coverage_class: current coverage class
  * @fw_version: firmware version for ethtool reporting
  * @hw_version: hardware version for ethtool reporting
@@ -1493,6 +1532,8 @@ struct wiphy {
 	u8 max_scan_ssids;
 	u16 max_scan_ie_len;
 
+	u8 max_sched_scan_ssids;
+
 	int n_cipher_suites;
 	const u32 *cipher_suites;
 
@@ -2170,6 +2211,13 @@ int cfg80211_wext_siwpmksa(struct net_device *dev,
 void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted);
 
 /**
+ * cfg80211_sched_scan_results - notify that new scan results are available
+ *
+ * @request: the corresponding periodic scan request
+ */
+void cfg80211_sched_scan_results(struct wiphy *wiphy);
+
+/**
  * cfg80211_inform_bss_frame - inform cfg80211 of a received BSS frame
  *
  * @wiphy: the wiphy reporting the BSS
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 79772fc..241a106 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -365,6 +365,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	spin_lock_init(&rdev->bss_lock);
 	INIT_LIST_HEAD(&rdev->bss_list);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
+	INIT_WORK(&rdev->sched_scan_wk, __cfg80211_sched_scan_results);
 
 #ifdef CONFIG_CFG80211_WEXT
 	rdev->wiphy.wext = &cfg80211_wext_handler;
@@ -647,6 +648,11 @@ static void wdev_cleanup_work(struct work_struct *work)
 		___cfg80211_scan_done(rdev, true);
 	}
 
+	if (rdev->sched_scan_req &&
+	    rdev->sched_scan_req->dev == wdev->netdev) {
+		nl80211_sched_scan_stopped(rdev, wdev->netdev);
+	}
+
 	cfg80211_unlock_rdev(rdev);
 
 	mutex_lock(&rdev->devlist_mtx);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 743203b..0d35692 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -60,8 +60,10 @@ struct cfg80211_registered_device {
 	struct rb_root bss_tree;
 	u32 bss_generation;
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
+	struct cfg80211_sched_scan_request *sched_scan_req;
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
+	struct work_struct sched_scan_wk;
 
 #ifdef CONFIG_NL80211_TESTMODE
 	struct genl_info *testmode_info;
@@ -396,6 +398,7 @@ void cfg80211_sme_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
 void cfg80211_sme_disassoc(struct net_device *dev, int idx);
 void __cfg80211_scan_done(struct work_struct *wk);
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak);
+void __cfg80211_sched_scan_results(struct work_struct *wk);
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
 int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev, enum nl80211_iftype ntype,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c3f80e5..c8331a5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -683,6 +683,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	}
 	CMD(set_channel, SET_CHANNEL);
 	CMD(set_wds_peer, SET_WDS_PEER);
+	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
+		CMD(sched_scan_start, START_SCHED_SCAN);
 
 #undef CMD
 
@@ -3106,6 +3108,200 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
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
+	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
+		return -EINVAL;
+
+	printk(KERN_DEBUG "nl80211_start_sched_scan\n");
+
+	if (!rdev->ops->sched_scan_start) {
+		return -EOPNOTSUPP;
+	}
+
+	if (rdev->sched_scan_req) {
+		return -EINPROGRESS;
+	}
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
+		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp)
+			n_ssids++;
+
+	if (n_ssids > wiphy->max_sched_scan_ssids)
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
+		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_FREQUENCIES], tmp) {
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
+		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
+			if (request->ssids[i].ssid_len > IEEE80211_MAX_SSID_LEN) {
+				err = -EINVAL;
+				goto out_free;
+			}
+			memcpy(request->ssids[i].ssid, nla_data(attr), nla_len(attr));
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
+	if (!err) {
+		nl80211_send_sched_scan(rdev, dev,
+					NL80211_CMD_START_SCHED_SCAN);
+		dev_hold(dev);
+	} else {
+out_free:
+		kfree(request);
+		rdev->sched_scan_req = NULL;
+	}
+
+	return err;
+}
+
+void nl80211_sched_scan_stopped(struct cfg80211_registered_device *rdev,
+				struct net_device *dev)
+{
+	dev_put(dev);
+	kfree(rdev->sched_scan_req);
+	rdev->sched_scan_req = NULL;
+}
+
+static int nl80211_stop_sched_scan(struct sk_buff *skb,
+				   struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	int err;
+
+	printk(KERN_DEBUG "nl80211_stop_sched_scan\n");
+
+	if (!rdev->ops->sched_scan_stop)
+		return -EOPNOTSUPP;
+
+	if (!rdev->sched_scan_req)
+		return 0;
+
+	err = rdev->ops->sched_scan_stop(&rdev->wiphy, dev);
+	if (err)
+		goto out;
+
+	nl80211_send_sched_scan(rdev, dev, NL80211_CMD_STOP_SCHED_SCAN);
+
+	nl80211_sched_scan_stopped(rdev, dev);
+out:
+	return err;
+}
+
 static int nl80211_send_bss(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
 			    struct wireless_dev *wdev,
@@ -4876,6 +5072,22 @@ static struct genl_ops nl80211_ops[] = {
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
@@ -5185,6 +5397,28 @@ static int nl80211_send_scan_msg(struct sk_buff *msg,
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
@@ -5242,6 +5476,43 @@ void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
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
index 16c2f71..9e12758 100644
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
@@ -91,5 +95,7 @@ void
 nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev, const u8 *peer,
 				u32 num_packets, gfp_t gfp);
+void nl80211_sched_scan_stopped(struct cfg80211_registered_device *rdev,
+				struct net_device *dev);
 
 #endif /* __NET_WIRELESS_NL80211_H */
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 503ebb8..e28101c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -93,6 +93,24 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
 }
 EXPORT_SYMBOL(cfg80211_scan_done);
 
+void __cfg80211_sched_scan_results(struct work_struct *wk)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rdev = container_of(wk, struct cfg80211_registered_device,
+			    sched_scan_wk);
+
+	cfg80211_lock_rdev(rdev);
+	nl80211_send_sched_scan_results(rdev, rdev->sched_scan_req->dev);
+	cfg80211_unlock_rdev(rdev);
+}
+
+void cfg80211_sched_scan_results(struct wiphy *wiphy)
+{
+	queue_work(cfg80211_wq, &wiphy_to_dev(wiphy)->sched_scan_wk);
+}
+EXPORT_SYMBOL(cfg80211_sched_scan_results);
+
 static void bss_release(struct kref *ref)
 {
 	struct cfg80211_internal_bss *bss;
-- 
1.7.0.4

