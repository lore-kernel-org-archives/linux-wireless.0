Return-Path: <SRS0=9ImR=NH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F471C46475
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Oct 2018 07:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00A652082C
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Oct 2018 07:31:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00A652082C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=strongswan.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbeJ0QLd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 27 Oct 2018 12:11:33 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:51183 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727643AbeJ0QLd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Oct 2018 12:11:33 -0400
Received: from book.fritz.box (unknown [IPv6:2a01:2a8:8106:7c01:b5f0:8f23:2aa:553])
        by mail.strongswan.org (Postfix) with ESMTPSA id A87A740644;
        Sat, 27 Oct 2018 09:31:32 +0200 (CEST)
From:   Martin Willi <martin@strongswan.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: announce radios/interfaces when switching namespaces
Date:   Sat, 27 Oct 2018 09:31:24 +0200
Message-Id: <20181027073124.4427-1-martin@strongswan.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When a wiphy changes its namespace, all interfaces are moved to the
new namespace as well. The network interfaces are properly announced
as leaving on the old and as appearing on the new namespace through
RTM_NEWLINK/RTM_DELLINK. On nl80211, however, these events are missing
for radios and their interfaces.

Add netlink announcements through nl80211 when switching namespaces,
so userspace can rely on these events to discover radios properly.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 net/wireless/core.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5bd01058b9e6..286617396d14 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -190,11 +190,25 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		return err;
 	}
 
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+		if (!wdev->netdev)
+			continue;
+		nl80211_notify_iface(rdev, wdev, NL80211_CMD_DEL_INTERFACE);
+	}
+	nl80211_notify_wiphy(rdev, NL80211_CMD_DEL_WIPHY);
+
 	wiphy_net_set(&rdev->wiphy, net);
 
 	err = device_rename(&rdev->wiphy.dev, dev_name(&rdev->wiphy.dev));
 	WARN_ON(err);
 
+	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+		if (!wdev->netdev)
+			continue;
+		nl80211_notify_iface(rdev, wdev, NL80211_CMD_NEW_INTERFACE);
+	}
+
 	return 0;
 }
 
-- 
2.17.1

