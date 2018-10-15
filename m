Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDD5C04AA5
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 17:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFC75214C3
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 17:59:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NGvPh92M";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Rpm3PWF+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFC75214C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbeJPBpS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 21:45:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38864 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbeJPBpQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 21:45:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A114F61310; Mon, 15 Oct 2018 17:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539626338;
        bh=YDR40GYdcumXU1JvJcsXzS/aPT3ZfNlH+ofYtFqICJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGvPh92MFAU/u3uJvWeMmu8cM2TJGyCPNSm41t4daZhxLJx04LATNAcI5LkO53B8m
         6Gfe2/x8odow/w+11VPd2cqQ/ioeRlvhXo+dXtMLlwN2eY38VSzRQZWBX2bcCx/Nxf
         IRiQmlOoFY1B5Y8xyG8BR0o5DKfENL94Gm7B2UsE=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 93E76613FC;
        Mon, 15 Oct 2018 17:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539626335;
        bh=YDR40GYdcumXU1JvJcsXzS/aPT3ZfNlH+ofYtFqICJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rpm3PWF+hm5/MYKm7B3Jqtz/OH8prRus4y7zbdElD3t1lj+VFt7n3kGU5MA++2cbI
         pjs6Mrg/4TOtc5v4166aCei+6WWO9XcbVH0MF8OhLxVoRip3jdEqwEzwxeFhv97Q7S
         ewPHP7uzyJrLBX99qWD1wmy1+qTNqjVOBZ7PQGU8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 93E76613FC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 1/3] cfg80211: Add support to configure station specific RSSI threshold for AP mode
Date:   Mon, 15 Oct 2018 23:27:28 +0530
Message-Id: <1539626250-769-2-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
References: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add infrastructure to configure station specific RSSI threshold
configuration to monitor station's signal strength variation.
This configuration will be useful for the application like
steering which requires change in the station's current signal
strength.

New NL80211_CMD_SET_STA_MON introduced to configure the RSSI threshold
using NL80211_ATTR_CQM nested attributes. The MAC address of
a station is passed in NL80211_ATTR_MAC. And NL80211_ATTR_STA_MON_FIXED_THOLD
introduced to have this RSSI threshold as a fixed limit or moving range thresholds.
Depends on the application's use case user can have either fixed or
moving RSSI range thresholds.

cfg80211_sta_mon_rssi_notify introduced to notify change in the
station's signal stregnth cross event using NL80211_CMD_NOTIFY_STA_MON.
Driver supporting this feature should advertise
NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG feature flag.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |   28 +++++++++
 include/uapi/linux/nl80211.h |   18 ++++++
 net/wireless/nl80211.c       |  131 +++++++++++++++++++++++++++++++++++++-----
 net/wireless/rdev-ops.h      |   18 ++++++
 4 files changed, 181 insertions(+), 14 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1fa41b7..8f6a906 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3183,6 +3183,12 @@ struct cfg80211_ftm_responder_stats {
  *
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
+ *
+ * @set_sta_mon_rssi_config: Configure  RSSI threshold for a station.
+ *     After configuration, the driver should (soon) send an event indicating
+ *     the current level of a station is above/below the configured threshold;
+ *     this may need some care when the configuration is changed
+ *     (without first being disabled.)
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3492,6 +3498,12 @@ struct cfg80211_ops {
 	int	(*get_ftm_responder_stats)(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct cfg80211_ftm_responder_stats *ftm_stats);
+	int	(*set_sta_mon_rssi_config)(struct wiphy *wiphy,
+					  struct net_device *dev,
+					  const u8 *addr,
+					  const s32 *rssi_tholds,
+					  u32 rssi_hyst, int rssi_n_tholds,
+					  bool fixed_thold);
 };
 
 /*
@@ -6024,6 +6036,22 @@ bool cfg80211_rx_control_port(struct net_device *dev,
 			      struct sk_buff *skb, bool unencrypted);
 
 /**
+ * cfg80211_sta_mon_rssi_notify - Station's rssi out of range event
+ * @dev: network device
+ * @peer: Station's mac address
+ * @rssi_event: the triggered RSSI event
+ * @rssi_level: new RSSI level value or 0 if not available
+ * @gfp: context flags
+ *
+ * This function is called when a configured rssi threshold reached event
+ * occurs for a station.
+ */
+void
+cfg80211_sta_mon_rssi_notify(struct net_device *dev, const u8 *peer,
+			     enum nl80211_cqm_rssi_threshold_event rssi_event,
+			     s32 rssi_level, gfp_t gfp);
+
+/**
  * cfg80211_cqm_rssi_notify - connection quality monitoring rssi event
  * @dev: network device
  * @rssi_event: the triggered RSSI event
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6d610ba..0f4cc09 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1036,6 +1036,11 @@
  * @NL80211_CMD_GET_FTM_RESPONDER_STATS: Retrieve FTM responder statistics, in
  *	the %NL80211_ATTR_FTM_RESPONDER_STATS attribute.
  *
+ * @NL80211_CMD_SET_STA_MON: This command is used to configure station's
+ *	connection monitoring notification trigger levels.
+ * @NL80211_CMD_NOTIFY_STA_MON: This is used as an event to notify
+ *	the user space that a trigger level was reached for a station.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1250,6 +1255,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_GET_FTM_RESPONDER_STATS,
 
+	NL80211_CMD_SET_STA_MON,
+	NL80211_CMD_NOTIFY_STA_MON,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2254,6 +2262,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_FTM_RESPONDER_STATS: Nested attribute with FTM responder
  *	statistics, see &enum nl80211_ftm_responder_stats.
  *
+ * @NL80211_ATTR_STA_MON_FIXED_THOLD: Flag attribute is used with
+ *	%NL80211_CMD_SET_STA_MON to indicate driver that the monitoring
+ *	configuration is fixed limit or a moving range threshold.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2699,6 +2711,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_FTM_RESPONDER_STATS,
 
+	NL80211_ATTR_STA_MON_FIXED_THOLD,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -5258,6 +5272,9 @@ enum nl80211_feature_flags {
  *      if this flag is not set. Ignoring this can leak clear text packets and/or
  *      freeze the connection.
  *
+ * @NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG: Driver supports monitoring
+ *	station's RSSI threshold value should adveritise this flag.
+ *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
  */
@@ -5297,6 +5314,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
+	NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 744b585..3013c86 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -497,6 +497,7 @@ static int validate_ie_attr(const struct nlattr *attr,
 		.type = NLA_NESTED,
 		.validation_data = nl80211_ftm_responder_policy,
 	},
+	[NL80211_ATTR_STA_MON_FIXED_THOLD] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -10208,23 +10209,33 @@ static int cfg80211_cqm_rssi_update(struct cfg80211_registered_device *rdev,
 	return rdev_set_cqm_rssi_range_config(rdev, dev, low, high);
 }
 
-static int nl80211_set_cqm_rssi(struct genl_info *info,
-				const s32 *thresholds, int n_thresholds,
-				u32 hysteresis)
+static int nl80211_validate_rssi_tholds(const s32 *thresholds, int n_tholds)
 {
-	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct net_device *dev = info->user_ptr[1];
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	int i, err;
+	int i;
 	s32 prev = S32_MIN;
 
 	/* Check all values negative and sorted */
-	for (i = 0; i < n_thresholds; i++) {
+	for (i = 0; i < n_tholds; i++) {
 		if (thresholds[i] > 0 || thresholds[i] <= prev)
 			return -EINVAL;
 
 		prev = thresholds[i];
 	}
+	return 0;
+}
+
+static int nl80211_set_cqm_rssi(struct genl_info *info,
+				const s32 *thresholds, int n_thresholds,
+				u32 hysteresis)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	err = nl80211_validate_rssi_tholds(thresholds, n_thresholds);
+	if (err)
+		return err;
 
 	if (wdev->iftype != NL80211_IFTYPE_STATION &&
 	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
@@ -12980,6 +12991,55 @@ static int nl80211_get_ftm_responder_stats(struct sk_buff *skb,
 	return -ENOBUFS;
 }
 
+static int nl80211_set_sta_mon(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct nlattr *attrs[NL80211_ATTR_CQM_MAX + 1];
+	bool fixed_thold = false;
+	struct nlattr *sta_mon;
+	u8 *addr = NULL;
+	int err;
+
+	if (!wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG))
+		return -EOPNOTSUPP;
+
+	sta_mon = info->attrs[NL80211_ATTR_CQM];
+	if (!sta_mon || !(info->attrs[NL80211_ATTR_MAC]))
+		return -EINVAL;
+
+	err = nla_parse_nested(attrs, NL80211_ATTR_CQM_MAX, sta_mon,
+			       nl80211_attr_cqm_policy, info->extack);
+	if (err)
+		return err;
+
+	addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	fixed_thold =
+		nla_get_flag(info->attrs[NL80211_ATTR_STA_MON_FIXED_THOLD]);
+
+	if (attrs[NL80211_ATTR_CQM_RSSI_THOLD] &&
+	    attrs[NL80211_ATTR_CQM_RSSI_HYST]) {
+		const s32 *thresholds =
+			nla_data(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
+		int len = nla_len(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
+		u32 hysteresis = nla_get_u32(attrs[NL80211_ATTR_CQM_RSSI_HYST]);
+
+		if (len % 4)
+			return -EINVAL;
+
+		err = nl80211_validate_rssi_tholds(thresholds, len / 4);
+		if (err)
+			return err;
+
+		return rdev_set_sta_mon_rssi_config(rdev, dev, addr, thresholds,
+						    hysteresis, len / 4,
+						    fixed_thold);
+	}
+
+	return -EINVAL;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -13898,6 +13958,14 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_SET_STA_MON,
+		.doit = nl80211_set_sta_mon,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
@@ -15093,7 +15161,8 @@ bool cfg80211_rx_control_port(struct net_device *dev,
 EXPORT_SYMBOL(cfg80211_rx_control_port);
 
 static struct sk_buff *cfg80211_prepare_cqm(struct net_device *dev,
-					    const char *mac, gfp_t gfp)
+					    const char *mac, gfp_t gfp,
+					    enum nl80211_commands cmd)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
@@ -15105,7 +15174,7 @@ static struct sk_buff *cfg80211_prepare_cqm(struct net_device *dev,
 
 	cb = (void **)msg->cb;
 
-	cb[0] = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NOTIFY_CQM);
+	cb[0] = nl80211hdr_put(msg, 0, 0, 0, cmd);
 	if (!cb[0]) {
 		nlmsg_free(msg);
 		return NULL;
@@ -15167,7 +15236,7 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			rssi_level = wdev->cqm_config->last_rssi_event_value;
 	}
 
-	msg = cfg80211_prepare_cqm(dev, NULL, gfp);
+	msg = cfg80211_prepare_cqm(dev, NULL, gfp, NL80211_CMD_NOTIFY_CQM);
 	if (!msg)
 		return;
 
@@ -15188,13 +15257,47 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 }
 EXPORT_SYMBOL(cfg80211_cqm_rssi_notify);
 
+void
+cfg80211_sta_mon_rssi_notify(struct net_device *dev, const u8 *peer,
+			     enum nl80211_cqm_rssi_threshold_event rssi_event,
+			     s32 rssi_level, gfp_t gfp)
+{
+	struct sk_buff *msg;
+
+	if (WARN_ON(!peer))
+		return;
+
+	if (WARN_ON(rssi_event != NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW &&
+		    rssi_event != NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH))
+		return;
+
+	msg = cfg80211_prepare_cqm(dev, peer, gfp, NL80211_CMD_NOTIFY_STA_MON);
+	if (!msg)
+		return;
+
+	if (nla_put_u32(msg, NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT,
+			rssi_event))
+		goto nla_put_failure;
+
+	if (rssi_level && nla_put_s32(msg, NL80211_ATTR_CQM_RSSI_LEVEL,
+				      rssi_level))
+		goto nla_put_failure;
+
+	cfg80211_send_cqm(msg, gfp);
+	return;
+
+ nla_put_failure:
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_sta_mon_rssi_notify);
+
 void cfg80211_cqm_txe_notify(struct net_device *dev,
 			     const u8 *peer, u32 num_packets,
 			     u32 rate, u32 intvl, gfp_t gfp)
 {
 	struct sk_buff *msg;
 
-	msg = cfg80211_prepare_cqm(dev, peer, gfp);
+	msg = cfg80211_prepare_cqm(dev, peer, gfp, NL80211_CMD_NOTIFY_CQM);
 	if (!msg)
 		return;
 
@@ -15222,7 +15325,7 @@ void cfg80211_cqm_pktloss_notify(struct net_device *dev,
 
 	trace_cfg80211_cqm_pktloss_notify(dev, peer, num_packets);
 
-	msg = cfg80211_prepare_cqm(dev, peer, gfp);
+	msg = cfg80211_prepare_cqm(dev, peer, gfp, NL80211_CMD_NOTIFY_CQM);
 	if (!msg)
 		return;
 
@@ -15241,7 +15344,7 @@ void cfg80211_cqm_beacon_loss_notify(struct net_device *dev, gfp_t gfp)
 {
 	struct sk_buff *msg;
 
-	msg = cfg80211_prepare_cqm(dev, NULL, gfp);
+	msg = cfg80211_prepare_cqm(dev, NULL, gfp, NL80211_CMD_NOTIFY_CQM);
 	if (!msg)
 		return;
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 51380b5..b4ac0ad 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1247,4 +1247,22 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_set_sta_mon_rssi_config(struct cfg80211_registered_device *rdev,
+			     struct net_device *dev, const u8 *addr,
+			     const s32 *rssi_tholds, u32 rssi_hyst,
+			     int n_rssi_tholds, bool fixed_thold)
+{
+	int ret = -EOPNOTSUPP;
+
+	if (rdev->ops->set_sta_mon_rssi_config)
+		ret = rdev->ops->set_sta_mon_rssi_config(&rdev->wiphy, dev,
+							 addr, rssi_tholds,
+							 rssi_hyst,
+							 n_rssi_tholds,
+							 fixed_thold);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
-- 
1.7.9.5

