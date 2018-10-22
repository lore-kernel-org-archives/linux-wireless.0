Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B6D2C004D3
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 17:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF53220652
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 17:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QFh0Ov8E";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZYi7X/3i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF53220652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbeJWCPz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Oct 2018 22:15:55 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38136 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728658AbeJWCPz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Oct 2018 22:15:55 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BC3E061307; Mon, 22 Oct 2018 17:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540230983;
        bh=Hp/mwxDwXqz8XTd95ifQtc5ByNAbL9jrGcsbEzrr4gU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFh0Ov8ELgrHCmuxX/Y8F1Gr6IpOrQE7ZV82Q3UdUZxw7PjJeGM8goveKoPUSWej2
         9tfPvHBPgQ2/MukgjyJKs4Bm+qEBIARE5QUJ/+KDBE3I8KVtGFeY2Rc1ZSEUZdCAc+
         sqVm4pU5XyC9T8KVYZf3Yk27aNHUuLfieRPZJ7Kg=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0F44060CF4;
        Mon, 22 Oct 2018 17:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540230982;
        bh=Hp/mwxDwXqz8XTd95ifQtc5ByNAbL9jrGcsbEzrr4gU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYi7X/3i6bEjCtNMXa2SFIdit5GWoTufKiRU+8gMNE6F4oOKegmXhTvmjolvouLBH
         mCMgmWmTdiW+NeSyyssZswU8n3Z0DSX3GqOyCE2sVAE7TZhHi8IzOZlkeWAjn8SuGw
         fxI9YBeF3KhQZDp+BywfimciwwCcUlA/f1NE82uA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0F44060CF4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     ath10k@lists.infradead.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 2/4] nl80211: Add netlink attribute for AMPDU aggregation enable/disable
Date:   Mon, 22 Oct 2018 23:25:16 +0530
Message-Id: <1540230918-27712-3-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce NL80211_ATTR_TID_AMPDU_AGGR_CTRL in nl80211_attr_tid_config
to accept TID specific AMPDU aggregation enable/disable configuration
through NL80211_CMD_SET_TID_CONFIG command. TID for which the
aggregation control configuration is to be applied is passed in
NL80211_ATTR_TID attribute. When the user-space wants this
configuration peer specific rather than being applied for all the
connected stations, MAC address of the peer can be passed in
NL80211_ATTR_MAC attribute.

Driver supporting this feature should advertise
NL80211_EXT_FEATURE_PER_TID_AMPDU_AGGR_CTRL and supporting per-STA aggregation
configuration should advertise NL80211_EXT_FEATURE_PER_STA_AMPDU_AGGR_CTRL.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |    6 ++++++
 include/uapi/linux/nl80211.h |   21 +++++++++++++++++++++
 net/wireless/nl80211.c       |   17 +++++++++++++++++
 net/wireless/rdev-ops.h      |   15 +++++++++++++++
 net/wireless/trace.h         |   23 +++++++++++++++++++++++
 5 files changed, 82 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index dd024da..f2b4280 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3194,6 +3194,9 @@ struct cfg80211_ftm_responder_stats {
  * @set_data_retry_count: configure the number of retries for the data frames
  *	for the given TID. If the retry configuration needs to be peer specific,
  *	peer MAC address can be passed.
+ * @set_tid_aggr_config: enable/disable aggregation configuration for the given
+ *	TID. If this configuration needs to be peer specific peer MAC address
+ *	can be passed.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3507,6 +3510,9 @@ struct cfg80211_ops {
 					struct net_device *dev,
 					const u8 *peer, u8 tid,
 					int retry_short, int retry_long);
+	int	(*set_tid_aggr_config)(struct wiphy *wiphy,
+				       struct net_device *dev, const u8 *peer,
+				       u8 tid, bool aggr);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9dfcf0a6..7ba0fb7 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4449,6 +4449,20 @@ enum nl80211_ps_state {
  *	the max value should be advertised by the driver through
  *	max_data_retry_count. when this attribute is not present, the driver
  *	would use the default configuration.
+ * @NL80211_ATTR_TID_AMPDU_AGGR_CTRL: Enable/Disable aggregation for the TID
+ *	specified in %%NL80211_ATTR_TID. Its type is u8, if the peer MAC address
+ *	is passed in %NL80211_ATTR_MAC, the aggregation configuration is applied
+ *	to the data frame for the tid to that connected station.
+ *	Station specific aggregation configuration is valid only for STA's
+ *	current connection. i.e. the configuration will be reset to default when
+ *	the station connects back after disconnection/roaming.
+ *	when user-space does not include %NL80211_ATTR_MAC, this configuration
+ *	should be treated as per-netdev configuration. This configuration will
+ *	be cleared when the interface goes down and on the disconnection from a
+ *	BSS. Driver supporting this feature should advertise
+ *	NL80211_EXT_FEATURE_PER_STA_AMPDU_AGGR_CTRL and supporting per station
+ *	aggregation configuration should advertise
+ *	NL80211_EXT_FEATURE_PER_STA_AMPDU_AGGR_CTRL.
  */
 enum nl80211_attr_tid_config {
 	__NL80211_ATTR_TID_INVALID,
@@ -4456,6 +4470,7 @@ enum nl80211_attr_tid_config {
 	NL80211_ATTR_TID_RETRY_CONFIG,
 	NL80211_ATTR_TID_RETRY_SHORT,
 	NL80211_ATTR_TID_RETRY_LONG,
+	NL80211_ATTR_TID_AMPDU_AGGR_CTRL,
 
 	/* keep last */
 	__NL80211_ATTR_TID_AFTER_LAST,
@@ -5337,6 +5352,10 @@ enum nl80211_feature_flags {
  *	count funcationality.
  * @NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG: Driver supports STA specific
  *	data retry count functionality.
+ * @NL80211_EXT_FEATURE_PER_TID_AMPDU_AGGR_CTRL: Driver supports TID specific
+ *	aggregation control(enable/disable).
+ * @NL80211_EXT_FEATURE_PER_STA_AMPDU_AGGR_CTRL: Driver supports per STA
+ *	specific TID aggregation control(enable/disable).
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5380,6 +5399,8 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_PER_STA_NOACK_MAP,
 	NL80211_EXT_FEATURE_PER_TID_RETRY_CONFIG,
 	NL80211_EXT_FEATURE_PER_STA_RETRY_CONFIG,
+	NL80211_EXT_FEATURE_PER_TID_AMPDU_AGGR_CTRL,
+	NL80211_EXT_FEATURE_PER_STA_AMPDU_AGGR_CTRL,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d386ad7..20c349b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13002,6 +13002,7 @@ static int nl80211_get_ftm_responder_stats(struct sk_buff *skb,
 	[NL80211_ATTR_TID_RETRY_CONFIG] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TID_RETRY_SHORT] = { .type = NLA_U8 },
 	[NL80211_ATTR_TID_RETRY_LONG] = { .type = NLA_U8 },
+	[NL80211_ATTR_TID_AMPDU_AGGR_CTRL] = { .type = NLA_U8 },
 };
 
 static int nl80211_set_tid_config(struct sk_buff *skb,
@@ -13014,6 +13015,7 @@ static int nl80211_set_tid_config(struct sk_buff *skb,
 	const char *peer = NULL;
 	u8 tid_no;
 	int ret = -EINVAL, retry_short = -1, retry_long = -1;
+	bool aggr;
 
 	tid = info->attrs[NL80211_ATTR_TID_CONFIG];
 	if (!tid)
@@ -13067,6 +13069,21 @@ static int nl80211_set_tid_config(struct sk_buff *skb,
 						retry_short, retry_long);
 	}
 
+	if (attrs[NL80211_ATTR_TID_AMPDU_AGGR_CTRL]) {
+		if (!rdev->ops->set_tid_aggr_config ||
+		    !wiphy_ext_feature_isset(&rdev->wiphy,
+				NL80211_EXT_FEATURE_PER_TID_AMPDU_AGGR_CTRL))
+			return -EOPNOTSUPP;
+
+		if (peer && !wiphy_ext_feature_isset(
+				&rdev->wiphy,
+				NL80211_EXT_FEATURE_PER_STA_AMPDU_AGGR_CTRL))
+			return -EOPNOTSUPP;
+
+		aggr = !!nla_get_u8(attrs[NL80211_ATTR_TID_AMPDU_AGGR_CTRL]);
+		ret = rdev_set_tid_aggr_config(rdev, dev, peer, tid_no, aggr);
+	}
+
 	return ret;
 }
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index b61e476..6c35b75 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1263,4 +1263,19 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_set_tid_aggr_config(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev, const u8 *peer,
+			 u8 tid, bool aggr)
+{
+	int ret;
+
+	trace_rdev_set_tid_aggr_config(&rdev->wiphy, dev, peer, tid,
+				       aggr);
+	ret = rdev->ops->set_tid_aggr_config(&rdev->wiphy, dev, peer,
+					     tid, aggr);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 7b55da9..246f122 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3324,6 +3324,29 @@
 		  __entry->retry_short, __entry->retry_long)
 );
 
+TRACE_EVENT(rdev_set_tid_aggr_config,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const u8 *peer, u8 tid, bool aggr),
+	TP_ARGS(wiphy, netdev, peer, tid, aggr),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(u8, tid)
+		__field(bool, aggr)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->tid = tid;
+		__entry->aggr = aggr;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", peer: " MAC_PR_FMT
+		  ", tid: %u, aggregation: %s", WIPHY_PR_ARG,
+		  NETDEV_PR_ARG, MAC_PR_ARG(peer), __entry->tid,
+		  BOOL_TO_STR(__entry->aggr))
+);
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.7.9.5

