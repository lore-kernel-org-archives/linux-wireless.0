Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,T_MIXED_ES,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE9FC65BAF
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 18:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0B4F2084E
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 18:12:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0B4F2084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727897AbeLLSMy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 13:12:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:43853 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727748AbeLLSMx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 13:12:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Dec 2018 10:12:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,345,1539673200"; 
   d="scan'208";a="129380408"
Received: from inlubt0043.iind.intel.com ([10.223.47.124])
  by fmsmga001.fm.intel.com with ESMTP; 12 Dec 2018 10:12:51 -0800
From:   Sarada Prasanna Garnayak <sarada.prasanna.garnayak@intel.com>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Sarada Prasanna Garnayak <sarada.prasanna.garnayak@intel.com>
Subject: [RFC PATCH v1] cfg80211/nl80211: add support for AID assignment by driver
Date:   Wed, 12 Dec 2018 23:42:49 +0530
Message-Id: <20181212181249.9039-1-sarada.prasanna.garnayak@intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add support for getting and free association ID if the station
association ID management handled by the WLAN driver/firmware.

Add cfg80211 driver ops and nl80211 API and CMD to request
the WLAN driver to assign an AID for a station during association
and release the AID of the station from the WLAN driver/firmware
station database on disassociation from the AP.

Signed-off-by: Sarada Prasanna Garnayak <sarada.prasanna.garnayak@intel.com>
---
 include/net/cfg80211.h       | 12 +++++++
 include/uapi/linux/nl80211.h | 11 +++++++
 net/wireless/nl80211.c       | 74 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 22 +++++++++++++
 net/wireless/trace.h         | 36 +++++++++++++++++++++
 5 files changed, 155 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1fa41b7a1be3..b80080a32e4a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3183,6 +3183,13 @@ struct cfg80211_ftm_responder_stats {
  *
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
+ *
+ * @get_sta_aid: Get an AID for the station from the driver if AID assignment
+ *	is managed by the WLAN driver/hardware/firmware.
+ *
+ * @free_sta_aid: Release the AID of the station from the station database
+ *	on disassociation from the AP if AID assignment is managed by
+ *	the WLAN driver/hardware/firmware.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3492,6 +3499,11 @@ struct cfg80211_ops {
 	int	(*get_ftm_responder_stats)(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct cfg80211_ftm_responder_stats *ftm_stats);
+
+	int (*get_sta_aid)(struct wiphy *wiphy, struct net_device *dev,
+			   u16 *sta_aid, const u8 *mac_addr);
+	int (*free_sta_aid)(struct wiphy *wiphy, struct net_device *dev,
+			    u16 sta_aid);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6d610bae30a9..ea194ccc7888 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1036,6 +1036,14 @@
  * @NL80211_CMD_GET_FTM_RESPONDER_STATS: Retrieve FTM responder statistics, in
  *	the %NL80211_ATTR_FTM_RESPONDER_STATS attribute.
  *
+ * @NL80211_CMD_GET_STA_AID: Request association ID for a station if the station
+ *	association ID management handled by the driver/firmware/hardware
+ *	specified by %NL80211_ATTR_MAC and %NL80211_ATTR_STA_AID.
+ *
+ * @NL80211_CMD_FREE_STA_AID: Free association ID of a station if the station
+ *	association ID management handled by the driver/firmware/hardware
+ *	with specified by %NL80211_ATTR_STA_AID.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1250,6 +1258,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_GET_FTM_RESPONDER_STATS,
 
+	NL80211_CMD_GET_STA_AID,
+	NL80211_CMD_FREE_STA_AID,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8d763725498c..662309d2c577 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3391,6 +3391,66 @@ static void get_key_callback(void *c, struct key_params *params)
 	cookie->error = 1;
 }
 
+static int nl80211_get_sta_aid(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	int err;
+	struct net_device *dev = info->user_ptr[1];
+	const u8 *mac_addr = NULL;
+	u16 *sta_aid = NULL;
+	void *hdr;
+	struct sk_buff *msg;
+
+	if (info->attrs[NL80211_ATTR_STA_AID])
+		sta_aid = nla_data(info->attrs[NL80211_ATTR_STA_AID]);
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (!rdev->ops->get_sta_aid)
+		return -EOPNOTSUPP;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
+			     NL80211_CMD_GET_STA_AID);
+	if (!hdr)
+		goto get_sta_aid_err;
+
+	err = rdev_get_sta_aid(rdev, dev, sta_aid, mac_addr);
+	if (err)
+		goto get_sta_aid_err;
+
+	if (nla_put(msg, NL80211_ATTR_STA_AID, sizeof(*sta_aid), sta_aid) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr))
+		goto get_sta_aid_err;
+
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, info);
+
+get_sta_aid_err:
+	err = -ENOBUFS;
+	nlmsg_free(msg);
+	return err;
+}
+
+static int nl80211_free_sta_aid(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	u16 sta_aid = 0;
+
+	if (info->attrs[NL80211_ATTR_STA_AID])
+		sta_aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
+
+	if (!rdev->ops->free_sta_aid)
+		return -EOPNOTSUPP;
+
+	return rdev_free_sta_aid(rdev, dev, sta_aid);
+}
+
 static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -13899,6 +13959,20 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_GET_STA_AID,
+		.doit = nl80211_get_sta_aid,
+		.policy = nl80211_policy,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_FREE_STA_AID,
+		.doit = nl80211_free_sta_aid,
+		.policy = nl80211_policy,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 51380b5c32f2..44e9cc489ec3 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -71,6 +71,28 @@ rdev_change_virtual_intf(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_get_sta_aid(struct cfg80211_registered_device *rdev,
+		 struct net_device *netdev, u16 *sta_aid, const u8 *mac_addr)
+{
+	int ret;
+	trace_rdev_get_sta_aid(&rdev->wiphy, netdev, sta_aid, mac_addr);
+	ret = rdev->ops->get_sta_aid(&rdev->wiphy, netdev, sta_aid, mac_addr);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline int
+rdev_free_sta_aid(struct cfg80211_registered_device *rdev,
+		  struct net_device *netdev, u16 sta_aid)
+{
+	int ret;
+	trace_rdev_free_sta_aid(&rdev->wiphy, netdev, sta_aid);
+	ret = rdev->ops->free_sta_aid(&rdev->wiphy, netdev, sta_aid);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline int rdev_add_key(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev, u8 key_index,
 			       bool pairwise, const u8 *mac_addr,
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index c6a9446b4e6b..646bd937ebea 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -389,6 +389,42 @@ TRACE_EVENT(rdev_change_virtual_intf,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->type)
 );
 
+TRACE_EVENT(rdev_get_sta_aid,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 u16 *sta_aid, const u8 *mac_addr),
+	TP_ARGS(wiphy, netdev, sta_aid, mac_addr),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(mac_addr)
+	),
+	TP_fast_assign(
+	WIPHY_ASSIGN;
+	NETDEV_ASSIGN;
+	MAC_ASSIGN(mac_addr, mac_addr);
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", mac addr: " MAC_PR_FMT,
+		WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(mac_addr))
+);
+
+TRACE_EVENT(rdev_free_sta_aid,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 u16 sta_aid),
+	TP_ARGS(wiphy, netdev, sta_aid),
+	TP_STRUCT__entry(
+	WIPHY_ENTRY
+	NETDEV_ENTRY
+	__field(u16, sta_aid)
+	),
+	TP_fast_assign(
+	WIPHY_ASSIGN;
+	NETDEV_ASSIGN;
+	__entry->sta_aid = sta_aid;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", station aid : %hu",
+		WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->sta_aid)
+);
+
 DECLARE_EVENT_CLASS(key_handle,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u8 key_index,
 		 bool pairwise, const u8 *mac_addr),
-- 
2.11.0

