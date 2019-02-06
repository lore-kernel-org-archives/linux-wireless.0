Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1973C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA1142081B
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 11:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbfBFLYe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 06:24:34 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55814 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728463AbfBFLYd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 06:24:33 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grLCz-0001ED-B3; Wed, 06 Feb 2019 13:17:37 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  6 Feb 2019 13:17:19 +0200
Message-Id: <20190206111721.29283-14-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206111721.29283-1-luca@coelho.fi>
References: <20190206111721.29283-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 13/15] cfg80211: allow sending vendor events unicast
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Sometimes, we may want to transport higher bandwidth data
through vendor events, and in that case sending it multicast
is a bad idea. Allow vendor events to be unicast.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h | 49 ++++++++++++++++++++++++++++++++++++++++--
 net/wireless/nl80211.c | 30 ++++++++++++++++++++------
 2 files changed, 71 insertions(+), 8 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7f2739a90bdb..31c8bde4580a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5690,6 +5690,7 @@ struct sk_buff *__cfg80211_alloc_event_skb(struct wiphy *wiphy,
 					   struct wireless_dev *wdev,
 					   enum nl80211_commands cmd,
 					   enum nl80211_attrs attr,
+					   unsigned int portid,
 					   int vendor_event_idx,
 					   int approxlen, gfp_t gfp);
 
@@ -5739,6 +5740,15 @@ cfg80211_vendor_cmd_alloc_reply_skb(struct wiphy *wiphy, int approxlen)
  */
 int cfg80211_vendor_cmd_reply(struct sk_buff *skb);
 
+/**
+ * cfg80211_vendor_cmd_get_sender
+ * @wiphy: the wiphy
+ *
+ * Return the current netlink port ID in a vendor command handler.
+ * Valid to call only there.
+ */
+unsigned int cfg80211_vendor_cmd_get_sender(struct wiphy *wiphy);
+
 /**
  * cfg80211_vendor_event_alloc - allocate vendor-specific event skb
  * @wiphy: the wiphy
@@ -5766,7 +5776,42 @@ cfg80211_vendor_event_alloc(struct wiphy *wiphy, struct wireless_dev *wdev,
 {
 	return __cfg80211_alloc_event_skb(wiphy, wdev, NL80211_CMD_VENDOR,
 					  NL80211_ATTR_VENDOR_DATA,
-					  event_idx, approxlen, gfp);
+					  0, event_idx, approxlen, gfp);
+}
+
+/**
+ * cfg80211_vendor_event_alloc_ucast - alloc unicast vendor-specific event skb
+ * @wiphy: the wiphy
+ * @wdev: the wireless device
+ * @event_idx: index of the vendor event in the wiphy's vendor_events
+ * @portid: port ID of the receiver
+ * @approxlen: an upper bound of the length of the data that will
+ *	be put into the skb
+ * @gfp: allocation flags
+ *
+ * This function allocates and pre-fills an skb for an event to send to
+ * a specific (userland) socket. This socket would previously have been
+ * obtained by cfg80211_vendor_cmd_get_sender(), and the caller MUST take
+ * care to register a netlink notifier to see when the socket closes.
+ *
+ * If wdev != NULL, both the ifindex and identifier of the specified
+ * wireless device are added to the event message before the vendor data
+ * attribute.
+ *
+ * When done filling the skb, call cfg80211_vendor_event() with the
+ * skb to send the event.
+ *
+ * Return: An allocated and pre-filled skb. %NULL if any errors happen.
+ */
+static inline struct sk_buff *
+cfg80211_vendor_event_alloc_ucast(struct wiphy *wiphy,
+				  struct wireless_dev *wdev,
+				  unsigned int portid, int approxlen,
+				  int event_idx, gfp_t gfp)
+{
+	return __cfg80211_alloc_event_skb(wiphy, wdev, NL80211_CMD_VENDOR,
+					  NL80211_ATTR_VENDOR_DATA,
+					  portid, event_idx, approxlen, gfp);
 }
 
 /**
@@ -5866,7 +5911,7 @@ static inline struct sk_buff *
 cfg80211_testmode_alloc_event_skb(struct wiphy *wiphy, int approxlen, gfp_t gfp)
 {
 	return __cfg80211_alloc_event_skb(wiphy, NULL, NL80211_CMD_TESTMODE,
-					  NL80211_ATTR_TESTDATA, -1,
+					  NL80211_ATTR_TESTDATA, 0, -1,
 					  approxlen, gfp);
 }
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e36437abc45a..82437819885c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4,7 +4,7 @@
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright 2015-2017	Intel Deutschland GmbH
- * Copyright (C) 2018 Intel Corporation
+ * Copyright (C) 2018-2019 Intel Corporation
  */
 
 #include <linux/if.h>
@@ -9318,6 +9318,7 @@ struct sk_buff *__cfg80211_alloc_event_skb(struct wiphy *wiphy,
 					   struct wireless_dev *wdev,
 					   enum nl80211_commands cmd,
 					   enum nl80211_attrs attr,
+					   unsigned int portid,
 					   int vendor_event_idx,
 					   int approxlen, gfp_t gfp)
 {
@@ -9341,7 +9342,7 @@ struct sk_buff *__cfg80211_alloc_event_skb(struct wiphy *wiphy,
 		return NULL;
 	}
 
-	return __cfg80211_alloc_vendor_skb(rdev, wdev, approxlen, 0, 0,
+	return __cfg80211_alloc_vendor_skb(rdev, wdev, approxlen, portid, 0,
 					   cmd, attr, info, gfp);
 }
 EXPORT_SYMBOL(__cfg80211_alloc_event_skb);
@@ -9350,6 +9351,7 @@ void __cfg80211_send_event_skb(struct sk_buff *skb, gfp_t gfp)
 {
 	struct cfg80211_registered_device *rdev = ((void **)skb->cb)[0];
 	void *hdr = ((void **)skb->cb)[1];
+	struct nlmsghdr *nlhdr = nlmsg_hdr(skb);
 	struct nlattr *data = ((void **)skb->cb)[2];
 	enum nl80211_multicast_groups mcgrp = NL80211_MCGRP_TESTMODE;
 
@@ -9359,11 +9361,16 @@ void __cfg80211_send_event_skb(struct sk_buff *skb, gfp_t gfp)
 	nla_nest_end(skb, data);
 	genlmsg_end(skb, hdr);
 
-	if (data->nla_type == NL80211_ATTR_VENDOR_DATA)
-		mcgrp = NL80211_MCGRP_VENDOR;
+	if (nlhdr->nlmsg_pid) {
+		genlmsg_unicast(wiphy_net(&rdev->wiphy), skb,
+				nlhdr->nlmsg_pid);
+	} else {
+		if (data->nla_type == NL80211_ATTR_VENDOR_DATA)
+			mcgrp = NL80211_MCGRP_VENDOR;
 
-	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), skb, 0,
-				mcgrp, gfp);
+		genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy),
+					skb, 0, mcgrp, gfp);
+	}
 }
 EXPORT_SYMBOL(__cfg80211_send_event_skb);
 
@@ -12748,6 +12755,17 @@ int cfg80211_vendor_cmd_reply(struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(cfg80211_vendor_cmd_reply);
 
+unsigned int cfg80211_vendor_cmd_get_sender(struct wiphy *wiphy)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+
+	if (WARN_ON(!rdev->cur_cmd_info))
+		return 0;
+
+	return rdev->cur_cmd_info->snd_portid;
+}
+EXPORT_SYMBOL_GPL(cfg80211_vendor_cmd_get_sender);
+
 static int nl80211_set_qos_map(struct sk_buff *skb,
 			       struct genl_info *info)
 {
-- 
2.20.1

