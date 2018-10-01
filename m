Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F43CC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DCC42089D
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:18:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DCC42089D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbeJAS4Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:56:16 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58398 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbeJAS4Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:56:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g6x9u-0004eB-6n; Mon, 01 Oct 2018 14:18:42 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: unify sending NL80211_CMD_NEW_INTERFACE
Date:   Mon,  1 Oct 2018 14:18:31 +0200
Message-Id: <20181001121831.12343-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

There isn't really any need for us to be sending this from
two different places - move cfg80211_init_wdev() later and
send the notification from there, removing it from the non-
netdev case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c    | 5 +++--
 net/wireless/nl80211.c | 9 ---------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index ba6363db1f31..5bd01058b9e6 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1186,6 +1186,8 @@ void cfg80211_init_wdev(struct cfg80211_registered_device *rdev,
 		wdev->identifier = ++rdev->wdev_id;
 	list_add_rcu(&wdev->list, &rdev->wiphy.wdev_list);
 	rdev->devlist_generation++;
+
+	nl80211_notify_iface(rdev, wdev, NL80211_CMD_NEW_INTERFACE);
 }
 
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
@@ -1213,7 +1215,6 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		 * called within code protected by it when interfaces
 		 * are added with nl80211.
 		 */
-		cfg80211_init_wdev(rdev, wdev);
 		/* can only change netns with wiphy */
 		dev->features |= NETIF_F_NETNS_LOCAL;
 
@@ -1242,7 +1243,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 
 		INIT_WORK(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
 
-		nl80211_notify_iface(rdev, wdev, NL80211_CMD_NEW_INTERFACE);
+		cfg80211_init_wdev(rdev, wdev);
 		break;
 	case NETDEV_GOING_DOWN:
 		cfg80211_leave(rdev, wdev);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 616927f70cc3..36e26ac20638 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3303,15 +3303,6 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 		return -ENOBUFS;
 	}
 
-	/*
-	 * For wdevs which have no associated netdev object (e.g. of type
-	 * NL80211_IFTYPE_P2P_DEVICE), emit the NEW_INTERFACE event here.
-	 * For all other types, the event will be generated from the
-	 * netdev notifier
-	 */
-	if (!wdev->netdev)
-		nl80211_notify_iface(rdev, wdev, NL80211_CMD_NEW_INTERFACE);
-
 	return genlmsg_reply(msg, info);
 }
 
-- 
2.14.4

