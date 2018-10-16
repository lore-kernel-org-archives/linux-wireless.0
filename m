Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFB53C5ACCA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 18:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86CE52098A
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 18:42:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Tm15bCPk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Cih1fN2R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86CE52098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbeJQCeo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 22:34:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51678 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbeJQCeo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 22:34:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F211360BFA; Tue, 16 Oct 2018 18:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539715377;
        bh=IYIxR43lgo32Eyjowx4Rhy5kMjIpwdhWFkC2btawqMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tm15bCPkVA6UEigN2fr/sw/K4ELKrWe9o9WU0dose99WCLTU51tC3H3g1T2e+xLbE
         CX+MQaogsW5wjc+7Ptcf51WHIJHv/JX2cvIRpEAqksHg1t8TyCMeip65SGrvDH5Bdt
         lLafoNJkCbiNSb6NDerqyA9A8VOITHqE8cVzBiV4=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0DBA960BFA;
        Tue, 16 Oct 2018 18:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539715375;
        bh=IYIxR43lgo32Eyjowx4Rhy5kMjIpwdhWFkC2btawqMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cih1fN2RJ+EV4SMsIkPGVjitVlmVhMbWDkxz1psH6H51KF2iAo2JhBtLyBvrc2TYr
         5FYIorELnWFhoPI72VLxiYiAq+/ITjlCPon5p10TKyh7+8rnelhByErV3YQuO3hZdL
         VHui7lFGaUqEohmsnvIfEmvz85ACrRBgshuhALos=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0DBA960BFA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 2/6] nl80211/mac80211: Extend NoAck policy command with peer MAC address
Date:   Wed, 17 Oct 2018 00:11:07 +0530
Message-Id: <1539715271-14325-3-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1539715271-14325-1-git-send-email-tamizhr@codeaurora.org>
References: <1539715271-14325-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>

Provides peer level NoAck policy configuration by extending
NL80211_CMD_SET_NOACK_MAP command with peer MAC address.
If user space does not give any peer mac address, the driver
should retain the existing functionality of applying the NoAck
policy for all the staions connected to the netdev. For a connected
peer, the peer specific configuration takes precedence over netdev
level configuration when both are set by the user. When the command
is given without attribute NL80211_ATTR_NOACK_MAP for a peer, the
NoAck policy for the peer will be reset to default which is peer's
netdev NoAck policy. Newly connected stations will have default
NoAck policy. Drivers supporting per-sta NoAck policy must advertise
the support through the extended flag index
NL80211_EXT_FEATURE_PER_STA_NOACK_MAP. Since a value of -1 NoAck map
is used for default configuration, redefine noack_map as int from u16.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |   12 ++++++++++--
 include/net/mac80211.h       |    2 +-
 include/uapi/linux/nl80211.h |   16 +++++++++++++++-
 net/mac80211/cfg.c           |    3 ++-
 net/mac80211/driver-ops.h    |    2 +-
 net/mac80211/ieee80211_i.h   |    2 +-
 net/mac80211/trace.h         |    6 +++---
 net/wireless/nl80211.c       |   22 +++++++++++++++++-----
 net/wireless/rdev-ops.h      |    7 ++++---
 net/wireless/trace.h         |   15 +++++++++------
 10 files changed, 63 insertions(+), 24 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1fa41b7..5801d76 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3086,7 +3086,15 @@ struct cfg80211_ftm_responder_stats {
  * @probe_client: probe an associated client, must return a cookie that it
  *	later passes to cfg80211_probe_status().
  *
- * @set_noack_map: Set the NoAck Map for the TIDs.
+ * @set_noack_map: Set the NoAck Map for the TIDs. When peer is not %NULL NoAck
+ *	map will be applied for that particular peer. A NoAck map value of -1
+ *	for non-%NULL peer would indicate that the peer's current NoAck
+ *	configuration should be reset to the default one. The default NoAck
+ *	configuration for a peer uses the currently configured NoAck setting of
+ *	netdev. When peer is %NULL NoAck map will be applied for all the
+ *	connected stations on the netdev which have default NoAck policy
+ *	configuration. Default NoAck configuration should be used for newly
+ *	connected stations.
  *
  * @get_channel: Get the current operating channel for the virtual interface.
  *	For monitor interfaces, it should return %NULL unless there's a single
@@ -3403,7 +3411,7 @@ struct cfg80211_ops {
 
 	int	(*set_noack_map)(struct wiphy *wiphy,
 				  struct net_device *dev,
-				  u16 noack_map);
+				  const u8 *peer, int noack_map);
 
 	int	(*get_channel)(struct wiphy *wiphy,
 			       struct wireless_dev *wdev,
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7da9d30..5ce7ce7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3917,7 +3917,7 @@ struct ieee80211_ops {
 				       struct cfg80211_ftm_responder_stats *ftm_stats);
 
 	int (*set_noack_tid_bitmap)(struct ieee80211_hw *hw,
-				    struct ieee80211_vif *vif, u16 noack_map);
+				    struct ieee80211_vif *vif, int noack_map);
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6d610ba..31b7a4b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -788,7 +788,18 @@
  *	messages. Note that per PHY only one application may register.
  *
  * @NL80211_CMD_SET_NOACK_MAP: sets a bitmap for the individual TIDs whether
- *      No Acknowledgement Policy should be applied.
+ *	No Acknowledgement Policy should be applied. %NL80211_ATTR_MAC is used
+ *	to apply No Acknowledgement policy for a particular connected station.
+ *	When the command is received without %NL80211_ATTR_NOACK_MAP for a
+ *	connected station (%NL80211_ATTR_MAC), the station's current NoAck
+ *	policy configuration should be reset to default. The default
+ *	configuration for a peer should use the current ndev level NoAck
+ *	policy configuration. Station specific NoAck policy configuration is
+ *	valid only for STA's current connection, i.e. the configuration will
+ *	be reset to default when the station connects back after disconnection/
+ *	roaming. When user-space does not include %NL80211_ATTR_MAC, the No
+ *	Acknowledgement Policy setting should be treated as per-netdev
+ *	configuration.
  *
  * @NL80211_CMD_CH_SWITCH_NOTIFY: An AP or GO may decide to switch channels
  *	independently of the userspace SME, send this event indicating
@@ -5257,6 +5268,8 @@ enum nl80211_feature_flags {
  *      able to rekey an in-use key correctly. Userspace must not rekey PTK keys
  *      if this flag is not set. Ignoring this can leak clear text packets and/or
  *      freeze the connection.
+ * @NL80211_EXT_FEATURE_PER_STA_NOACK_MAP: Driver supports STA specific NoAck
+ *	policy functionality.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5297,6 +5310,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT,
 	NL80211_EXT_FEATURE_CAN_REPLACE_PTK0,
 	NL80211_EXT_FEATURE_ENABLE_FTM_RESPONDER,
+	NL80211_EXT_FEATURE_PER_STA_NOACK_MAP,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 4d8cc8d..7a7e423 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -340,7 +340,8 @@ static void ieee80211_del_nan_func(struct wiphy *wiphy,
 
 static int ieee80211_set_noack_map(struct wiphy *wiphy,
 				  struct net_device *dev,
-				  u16 noack_map)
+				  const u8 *peer,
+				  int noack_map)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index a6dcef5..d705938 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1280,7 +1280,7 @@ static inline void drv_del_nan_func(struct ieee80211_local *local,
 
 static inline int drv_set_noack_tid_bitmap(struct ieee80211_local *local,
 					   struct ieee80211_sub_if_data *sdata,
-					   u16 noack_map)
+					   int noack_map)
 {
 	int ret;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 10a0506..257dec5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -891,7 +891,7 @@ struct ieee80211_sub_if_data {
 	unsigned int fragment_next;
 
 	/* TID bitmap for NoAck policy */
-	u16 noack_map;
+	int noack_map;
 
 	/* bit field of ACM bits (BIT(802.1D tag)) */
 	u8 wmm_acm;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index a563904..e0e6c9a 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1885,13 +1885,13 @@ struct trace_switch_entry {
 TRACE_EVENT(drv_set_noack_tid_bitmap,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
-		 u16 noack_map),
+		 int noack_map),
 
 	TP_ARGS(local, sdata, noack_map),
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		VIF_ENTRY
-		__field(u16, noack_map)
+		__field(int, noack_map)
 	),
 
 	TP_fast_assign(
@@ -1902,7 +1902,7 @@ struct trace_switch_entry {
 
 	TP_printk(
 		LOCAL_PR_FMT  VIF_PR_FMT
-		", noack_map: %u",
+		", noack_map: %d",
 		LOCAL_PR_ARG, VIF_PR_ARG, __entry->noack_map
 	)
 );
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 744b585..d744388 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3331,17 +3331,29 @@ static int nl80211_set_noack_map(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
-	u16 noack_map;
+	int noack_map = -1;
+	const u8 *peer = NULL;
 
-	if (!info->attrs[NL80211_ATTR_NOACK_MAP])
+	if (!(info->attrs[NL80211_ATTR_NOACK_MAP] ||
+	      info->attrs[NL80211_ATTR_MAC]))
 		return -EINVAL;
 
+	if (info->attrs[NL80211_ATTR_NOACK_MAP])
+		noack_map = nla_get_u16(info->attrs[NL80211_ATTR_NOACK_MAP]);
+
+	if (info->attrs[NL80211_ATTR_MAC]) {
+		if (!wiphy_ext_feature_isset(
+				&rdev->wiphy,
+				NL80211_EXT_FEATURE_PER_STA_NOACK_MAP))
+			return -EOPNOTSUPP;
+
+		peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	}
+
 	if (!rdev->ops->set_noack_map)
 		return -EOPNOTSUPP;
 
-	noack_map = nla_get_u16(info->attrs[NL80211_ATTR_NOACK_MAP]);
-
-	return rdev_set_noack_map(rdev, dev, noack_map);
+	return rdev_set_noack_map(rdev, dev, peer, noack_map);
 }
 
 struct get_key_cookie {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 51380b5..8426eb1 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -908,11 +908,12 @@ static inline int rdev_probe_client(struct cfg80211_registered_device *rdev,
 }
 
 static inline int rdev_set_noack_map(struct cfg80211_registered_device *rdev,
-				     struct net_device *dev, u16 noack_map)
+				     struct net_device *dev, const u8 *peer,
+				     int noack_map)
 {
 	int ret;
-	trace_rdev_set_noack_map(&rdev->wiphy, dev, noack_map);
-	ret = rdev->ops->set_noack_map(&rdev->wiphy, dev, noack_map);
+	trace_rdev_set_noack_map(&rdev->wiphy, dev, peer, noack_map);
+	ret = rdev->ops->set_noack_map(&rdev->wiphy, dev, peer, noack_map);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index c6a9446..2ff78dd 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1909,21 +1909,24 @@
 );
 
 TRACE_EVENT(rdev_set_noack_map,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
-		 u16 noack_map),
-	TP_ARGS(wiphy, netdev, noack_map),
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, const u8 *peer,
+		 int noack_map),
+	TP_ARGS(wiphy, netdev, peer, noack_map),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		NETDEV_ENTRY
-		__field(u16, noack_map)
+		MAC_ENTRY(peer)
+		__field(int, noack_map)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
 		__entry->noack_map = noack_map;
 	),
-	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", noack_map: %u",
-		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->noack_map)
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT
+		  ", noack_map: %d", WIPHY_PR_ARG, NETDEV_PR_ARG,
+		  MAC_PR_ARG(peer), __entry->noack_map)
 );
 
 DEFINE_EVENT(wiphy_wdev_evt, rdev_get_channel,
-- 
1.7.9.5

