Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F92C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 19:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 513132146E
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 19:15:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gsmLi7xr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LDUx3TVa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbfBOTP1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 14:15:27 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33114 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbfBOTP1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 14:15:27 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E46576087F; Fri, 15 Feb 2019 19:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550258125;
        bh=y8F7ndnLAAKT9OCwZlgLXzmrGboxHQB5pYSpPjPOHJw=;
        h=From:To:Cc:Subject:Date:From;
        b=gsmLi7xrQBzj7MC0inAbo22jZneYP3X+cVUiS+Cjfg1xdHMPVrm3ksLFSsIN+fgCJ
         5BEH13HzaHtKifRTR8nWBVYD4oadVHe6K2qr0/VG9kLYXeLeVdXiAKvlT1ZijJOSAo
         qQmb7Jf+gsdlhaIHje0YV/JA2JuA45MR+74UeL6Q=
Received: from dasaris-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dasaris@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A13736020B;
        Fri, 15 Feb 2019 19:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550258124;
        bh=y8F7ndnLAAKT9OCwZlgLXzmrGboxHQB5pYSpPjPOHJw=;
        h=From:To:Cc:Subject:Date:From;
        b=LDUx3TVaw960CNodRfKEOsrBCim9i6+e86zMUCFDOmW9nNsWxVl4JEcOjhEeYXp+9
         Q/v6Frq4OW4sFBTdx+h+b+yCjO9QBN4CYA9eEuQ40DDrV9/kbYqC+RL765Ls7iUylo
         7nKbrGOByqaIQp/cPQti8gPFvaBoaeeZwyAhEjoA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A13736020B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=dasaris@codeaurora.org
From:   Srinivas Dasari <dasaris@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Sunil Dutt <usdutt@codeaurora.org>,
        Liangwei Dong <liangwei@codeaurora.org>,
        Srinivas Dasari <dasaris@codeaurora.org>
Subject: [PATCH] cfg80211/nl80211: Offload OWE processing to user space in AP mode
Date:   Sat, 16 Feb 2019 00:44:38 +0530
Message-Id: <1550258078-13504-1-git-send-email-dasaris@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sunil Dutt <usdutt@codeaurora.org>

This interface allows the host driver to offload OWE processing
to user space. This intends to support OWE (Opportunistic Wireless
Encryption) AKM by the drivers that implement SME but rely on the
user space for the cryptographic/OWE processing in AP mode. Such
drivers are not capable of processing/deriving the DH IE.

A new NL80211 command - NL80211_CMD_UPDATE_OWE_INFO is introduced
to send the request/event between the host driver and user space.

The driver shall use the event to notify the OWE info of the peer
to the user space for the cryptographic processing of the DH IE.
Accordingly, the user space shall update the OWE info/DH IE to
the driver.

Following is the sequence in AP mode for OWE authentication.

Driver passes the OWE info obtained from the peer in the
Association Request to the user space through the event
cfg80211_update_owe_info_event. User space shall process the
OWE info received and generate new OWE info. This OWE info is
passed to the driver through NL80211_CMD_UPDATE_OWE_INFO
request. Driver eventually uses this OWE info to send the
Association Response to the peer.

This OWE info in the command interface carries the IEs that include
PMKID of the peer if the PMKSA is still valid or an updated DH IE
for generating a new PMKSA with the peer.

Signed-off-by: Liangwei Dong <liangwei@codeaurora.org>
Signed-off-by: Sunil Dutt <usdutt@codeaurora.org>
Signed-off-by: Srinivas Dasari <dasaris@codeaurora.org>
---
 include/net/cfg80211.h       | 42 ++++++++++++++++++++++++++
 include/uapi/linux/nl80211.h |  7 +++++
 net/wireless/nl80211.c       | 72 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 13 ++++++++
 net/wireless/trace.h         | 38 +++++++++++++++++++++++
 5 files changed, 172 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f81677f..9a314ee 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3100,6 +3100,32 @@ struct cfg80211_pmsr_request {
 };
 
 /**
+ * struct cfg80211_update_owe_info - OWE Information
+ *
+ * This structure provides information needed for the drivers to offload OWE
+ * (Opportunistic Wireless Encryption) processing to the user space.
+ *
+ * Commonly used across update_owe_info request and event interfaces.
+ *
+ * @peer: MAC address of the peer device for which the OWE processing
+ *	has to be done.
+ * @status: status code, %WLAN_STATUS_SUCCESS for successful OWE info
+ *	processing, use %WLAN_STATUS_UNSPECIFIED_FAILURE if user space
+ *	cannot give you the real status code for failures. Used only for
+ *	OWE update request command interface (user space to driver).
+ * @ie: IEs obtained from the peer or constructed by the user space. These are
+ *	the IEs of the remote peer in the event from the host driver and
+ *	the constructed IEs by the user space in the request interface.
+ * @ie_len: Length of IEs in octets.
+ */
+struct cfg80211_update_owe_info {
+	u8 peer[ETH_ALEN] __aligned(2);
+	u16 status;
+	const u8 *ie;
+	size_t ie_len;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -3436,6 +3462,10 @@ struct cfg80211_pmsr_request {
  *	Statistics should be cumulative, currently no way to reset is provided.
  * @start_pmsr: start peer measurement (e.g. FTM)
  * @abort_pmsr: abort peer measurement
+ *
+ * @update_owe_info: Provide updated OWE info to driver. Driver implementing SME
+ *	but offloading OWE processing to the user space will get the updated
+ *	DH IE through this interface.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3750,6 +3780,8 @@ struct cfg80211_ops {
 			      struct cfg80211_pmsr_request *request);
 	void	(*abort_pmsr)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			      struct cfg80211_pmsr_request *request);
+	int	(*update_owe_info)(struct wiphy *wiphy, struct net_device *dev,
+				   struct cfg80211_update_owe_info *owe_info);
 };
 
 /*
@@ -7160,4 +7192,14 @@ void cfg80211_pmsr_complete(struct wireless_dev *wdev,
 #define wiphy_WARN(wiphy, format, args...)			\
 	WARN(1, "wiphy: %s\n" format, wiphy_name(wiphy), ##args);
 
+/**
+ * cfg80211_update_owe_info_event - Notify the peer's OWE info to user space
+ * @netdev: network device
+ * @owe_info: peer's owe info
+ * @gfp: allocation flags
+ */
+void cfg80211_update_owe_info_event(struct net_device *netdev,
+				    struct cfg80211_update_owe_info *owe_info,
+				    gfp_t gfp);
+
 #endif /* __NET_CFG80211_H */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index dd4f86e..26aa319 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1065,6 +1065,11 @@
  *	indicated by %NL80211_ATTR_WIPHY_FREQ and other attributes
  *	determining the width and type.
  *
+ * @NL80211_CMD_UPDATE_OWE_INFO: This interface allows the host driver to
+ *	offload OWE processing to user space. This intends to support
+ *	OWE AKM by the host drivers that implement SME but rely
+ *	on the user space for the cryptographic/DH IE processing in AP mode.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1285,6 +1290,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_NOTIFY_RADAR,
 
+	NL80211_CMD_UPDATE_OWE_INFO,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 80878b4..2fe0421 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13241,6 +13241,31 @@ static int nl80211_get_ftm_responder_stats(struct sk_buff *skb,
 	return -ENOBUFS;
 }
 
+static int nl80211_update_owe_info(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct cfg80211_update_owe_info owe_info;
+	struct net_device *dev = info->user_ptr[1];
+
+	if (!rdev->ops->update_owe_info)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_STATUS_CODE] ||
+	    !info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	memset(&owe_info, 0, sizeof(owe_info));
+	owe_info.status = nla_get_u16(info->attrs[NL80211_ATTR_STATUS_CODE]);
+	nla_memcpy(owe_info.peer, info->attrs[NL80211_ATTR_MAC], ETH_ALEN);
+
+	if (info->attrs[NL80211_ATTR_IE]) {
+		owe_info.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		owe_info.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	}
+
+	return rdev_update_owe_info(rdev, dev, &owe_info);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -14175,6 +14200,14 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_UPDATE_OWE_INFO,
+		.doit = nl80211_update_owe_info,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
@@ -16340,6 +16373,45 @@ int cfg80211_external_auth_request(struct net_device *dev,
 }
 EXPORT_SYMBOL(cfg80211_external_auth_request);
 
+void cfg80211_update_owe_info_event(struct net_device *netdev,
+				    struct cfg80211_update_owe_info *owe_info,
+				    gfp_t gfp)
+{
+	struct wiphy *wiphy = netdev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+
+	trace_cfg80211_update_owe_info_event(wiphy, netdev, owe_info);
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_UPDATE_OWE_INFO);
+	if (!hdr)
+		goto nla_put_failure;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, owe_info->peer))
+		goto nla_put_failure;
+
+	if (nla_put(msg, NL80211_ATTR_IE, owe_info->ie_len, owe_info->ie))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_MLME, gfp);
+	return;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_update_owe_info_event);
+
 /* initialisation/exit functions */
 
 int __init nl80211_init(void)
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 5cb48d1..c1e3210 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1272,4 +1272,17 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int rdev_update_owe_info(struct cfg80211_registered_device *rdev,
+				       struct net_device *dev,
+				       struct cfg80211_update_owe_info *oweinfo)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_rdev_update_owe_info(&rdev->wiphy, dev, oweinfo);
+	if (rdev->ops->update_owe_info)
+		ret = rdev->ops->update_owe_info(&rdev->wiphy, dev, oweinfo);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 44b2ce1..2dda529 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3362,6 +3362,44 @@
 		  WIPHY_PR_ARG, WDEV_PR_ARG,
 		  (unsigned long long)__entry->cookie)
 );
+
+TRACE_EVENT(rdev_update_owe_info,
+	    TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		     struct cfg80211_update_owe_info *owe_info),
+	    TP_ARGS(wiphy, netdev, owe_info),
+	    TP_STRUCT__entry(WIPHY_ENTRY
+			     NETDEV_ENTRY
+			     MAC_ENTRY(peer)
+			     __field(u16, status)
+			     __dynamic_array(u8, ie, owe_info->ie_len)),
+	    TP_fast_assign(WIPHY_ASSIGN;
+			   NETDEV_ASSIGN;
+			   MAC_ASSIGN(peer, owe_info->peer);
+			   __entry->status = owe_info->status;
+			   memcpy(__get_dynamic_array(ie),
+				  owe_info->ie, owe_info->ie_len);),
+	    TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", peer: " MAC_PR_FMT
+		  " status %d", WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer),
+		  __entry->status)
+);
+
+TRACE_EVENT(cfg80211_update_owe_info_event,
+	    TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		     struct cfg80211_update_owe_info *owe_info),
+	    TP_ARGS(wiphy, netdev, owe_info),
+	    TP_STRUCT__entry(WIPHY_ENTRY
+			     NETDEV_ENTRY
+			     MAC_ENTRY(peer)
+			     __dynamic_array(u8, ie, owe_info->ie_len)),
+	    TP_fast_assign(WIPHY_ASSIGN;
+			   NETDEV_ASSIGN;
+			   MAC_ASSIGN(peer, owe_info->peer);
+			   memcpy(__get_dynamic_array(ie), owe_info->ie,
+				  owe_info->ie_len);),
+	    TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", peer: " MAC_PR_FMT,
+		      WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer))
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.9.1

