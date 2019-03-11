Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC0ECC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 18:49:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7824620643
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 18:49:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="im+wQc2k";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ifc0qFhN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbfCKStU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 14:49:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55766 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbfCKStU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 14:49:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A79C6609F3; Mon, 11 Mar 2019 18:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552330159;
        bh=Yh1Ds6FLYRk/b+WwzNhqm6oDA+H982sxktqiXlLSVT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=im+wQc2kIplMJ9PgWWyNw4XDtnTAcAIW2rL1MIWEuOeAT1fEkfygsp2mBq45wAwDj
         93fI2rmUMw4agD8d7cHFOizYWiyE7cSfBDwpt99yXf7vvzWtG7yHqqa0qYngGwURuV
         YRonyYiXjcdJ5oZFTyifl9EE4MF+kPLJh2l8gKpY=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 983FD6030B;
        Mon, 11 Mar 2019 18:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552330158;
        bh=Yh1Ds6FLYRk/b+WwzNhqm6oDA+H982sxktqiXlLSVT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ifc0qFhN+DU3wX8O+9b4QPJWWCSwgvZMbuaR/TbW7jkflp3MljdYy8fYjZBa+VkoJ
         QyWBEPGPLtcebjtWFnk4UUDXgR7423KkXY30+Fe2Z2uKLuLrvzr3rTYkhBHKRzjQ8r
         MDL2Jw2fWZ6vImC3P6jmTEvIRLlf2fuFYGbQSXDg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 983FD6030B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Mon, 11 Mar 2019 11:49:16 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, julanhsu@google.com,
        kevinhayes@google.com, Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH v2 1/3] cfg80211: add support to probe unexercised mesh link
Date:   Mon, 11 Mar 2019 11:49:00 -0700
Message-Id: <1552330142-23228-2-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1552330142-23228-1-git-send-email-rmanohar@codeaurora.org>
References: <1552330142-23228-1-git-send-email-rmanohar@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Adding support to allow mesh HWMP to measure link metrics on unexercised
direct mesh path by sending some data frames to other mesh points which
are not currently selected as a primary traffic path but only 1 hop away.
The absence of the primary path to the chosen node makes it necessary to
apply some form of marking on a chosen packet stream so that the packets
can be properly steered to the selected node for testing, and not by the
regular mesh path lookup.

Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
---
 include/net/cfg80211.h       |  6 +++++
 include/uapi/linux/nl80211.h | 16 +++++++++++++
 net/wireless/nl80211.c       | 54 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 13 +++++++++++
 net/wireless/trace.h         | 19 ++++++++++++++++
 5 files changed, 108 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e0c41eb1c860..24ee3fc3e1f5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3379,6 +3379,9 @@ struct cfg80211_pmsr_request {
  *	Statistics should be cumulative, currently no way to reset is provided.
  * @start_pmsr: start peer measurement (e.g. FTM)
  * @abort_pmsr: abort peer measurement
+ *
+ * @probe_mesh_link: Probe direct Mesh peer's link quality by sending data frame
+ *	and overrule HWMP path selection algorithm.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3693,6 +3696,9 @@ struct cfg80211_ops {
 			      struct cfg80211_pmsr_request *request);
 	void	(*abort_pmsr)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			      struct cfg80211_pmsr_request *request);
+
+	int	(*probe_mesh_link)(struct wiphy *wiphy, struct net_device *dev,
+				   const u8 *buf, size_t len);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 31ae5c7f10e3..e9184381cbdf 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1065,6 +1065,21 @@
  *	indicated by %NL80211_ATTR_WIPHY_FREQ and other attributes
  *	determining the width and type.
  *
+ * @NL80211_CMD_PROBE_MESH_LINK: The requirement for mesh link metric
+ *	refreshing, is that from one mesh point we be able to send some data
+ *	frames to other mesh points which are not currently selected as a
+ *	primary traffic path, but which are only 1 hop away. The absence of
+ *	the primary path to the chosen node makes it necessary to apply some
+ *	form of marking on a chosen packet stream so that the packets can be
+ *	properly steered to the selected node for testing, and not by the
+ *	regular mesh path lookup. Further, the packets must be of type data
+ *	so that the rate control (often embedded in firmware) is used for
+ *	rate selection.
+ *
+ *	Here attribute %NL80211_ATTR_MAC is used to specify connected mesh
+ *	peer MAC address and %NL80211_ATTR_FRAME is used to specify the frame
+ *	content. The frame is ethernet data.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1284,6 +1299,7 @@ enum nl80211_commands {
 	NL80211_CMD_PEER_MEASUREMENT_COMPLETE,
 
 	NL80211_CMD_NOTIFY_RADAR,
+	NL80211_CMD_PROBE_MESH_LINK,
 
 	/* add new commands above here */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d91a408db113..c138bc817af8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13205,6 +13205,52 @@ static int nl80211_get_ftm_responder_stats(struct sk_buff *skb,
 	return -ENOBUFS;
 }
 
+static int nl80211_probe_mesh_link(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct station_info sinfo = {};
+	const u8 *buf;
+	size_t len;
+	u8 *dest;
+	int err;
+
+	if (!rdev->ops->probe_mesh_link || !rdev->ops->get_station)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MAC] ||
+	    !info->attrs[NL80211_ATTR_FRAME]) {
+		GENL_SET_ERR_MSG(info, "Frame or MAC missing");
+		return -EINVAL;
+	}
+
+	wdev_lock(wdev);
+	if (wdev->iftype != NL80211_IFTYPE_MESH_POINT) {
+		wdev_unlock(wdev);
+		err = -EOPNOTSUPP;
+		return err;
+	}
+	wdev_unlock(wdev);
+
+	dest = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	buf = nla_data(info->attrs[NL80211_ATTR_FRAME]);
+	len = nla_len(info->attrs[NL80211_ATTR_FRAME]);
+
+	if (len < sizeof(struct ethhdr))
+		return -EINVAL;
+
+	if (!ether_addr_equal(buf, dest) || is_multicast_ether_addr(buf) ||
+	    !ether_addr_equal(buf + ETH_ALEN, dev->dev_addr))
+		return -EINVAL;
+
+	err = rdev_get_station(rdev, dev, dest, &sinfo);
+	if (err)
+		return err;
+
+	return rdev_probe_mesh_link(rdev, dev, dest, buf, len);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -14139,6 +14185,14 @@ static void nl80211_post_doit(const struct genl_ops *ops, struct sk_buff *skb,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_PROBE_MESH_LINK,
+		.doit = nl80211_probe_mesh_link,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 5cb48d135fab..ec1b4800872f 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1272,4 +1272,17 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int
+rdev_probe_mesh_link(struct cfg80211_registered_device *rdev,
+		     struct net_device *dev, const u8 *dest,
+		     const void *buf, size_t len)
+{
+	int ret;
+
+	trace_rdev_probe_mesh_link(&rdev->wiphy, dev, dest, buf, len);
+	ret = rdev->ops->probe_mesh_link(&rdev->wiphy, dev, buf, len);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 44b2ce1bb13a..274a844c7ea9 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3362,6 +3362,25 @@
 		  WIPHY_PR_ARG, WDEV_PR_ARG,
 		  (unsigned long long)__entry->cookie)
 );
+
+TRACE_EVENT(rdev_probe_mesh_link,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const u8 *dest, const u8 *buf, size_t len),
+	TP_ARGS(wiphy, netdev, dest, buf, len),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(dest)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(dest, dest);
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(dest))
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.9.1

