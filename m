Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC26AC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98D222084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 12:09:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98D222084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbeJASrB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:47:01 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58214 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728999AbeJASrB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:47:01 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g6x10-0004QA-9V; Mon, 01 Oct 2018 14:09:30 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: combine wdev/netdev unregister code
Date:   Mon,  1 Oct 2018 14:09:17 +0200
Message-Id: <20181001120917.10565-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We currently have two places that do similar things, depending
on whether it's a wdev with or without netdev.

Combine the code to avoid having to duplicate all new additions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 52dba3976803..fffb35010c52 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1047,36 +1047,49 @@ void cfg80211_cqm_config_free(struct wireless_dev *wdev)
 	wdev->cqm_config = NULL;
 }
 
-void cfg80211_unregister_wdev(struct wireless_dev *wdev)
+static void __cfg80211_unregister_wdev(struct wireless_dev *wdev, bool sync)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
 
 	ASSERT_RTNL();
 
-	if (WARN_ON(wdev->netdev))
-		return;
-
 	nl80211_notify_iface(rdev, wdev, NL80211_CMD_DEL_INTERFACE);
 
 	list_del_rcu(&wdev->list);
-	synchronize_rcu();
+	if (sync)
+		synchronize_rcu();
 	rdev->devlist_generation++;
 
+	cfg80211_mlme_purge_registrations(wdev);
+
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_P2P_DEVICE:
-		cfg80211_mlme_purge_registrations(wdev);
 		cfg80211_stop_p2p_device(rdev, wdev);
 		break;
 	case NL80211_IFTYPE_NAN:
 		cfg80211_stop_nan(rdev, wdev);
 		break;
 	default:
-		WARN_ON_ONCE(1);
 		break;
 	}
 
+#ifdef CONFIG_CFG80211_WEXT
+	kzfree(wdev->wext.keys);
+#endif
+	/* only initialized if we have a netdev */
+	if (wdev->netdev)
+		flush_work(&wdev->disconnect_wk);
+
 	cfg80211_cqm_config_free(wdev);
 }
+
+void cfg80211_unregister_wdev(struct wireless_dev *wdev)
+{
+	if (WARN_ON(wdev->netdev))
+		return;
+
+	__cfg80211_unregister_wdev(wdev, true);
+}
 EXPORT_SYMBOL(cfg80211_unregister_wdev);
 
 static const struct device_type wiphy_type = {
@@ -1337,17 +1350,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		 * remove and clean it up.
 		 */
 		if (!list_empty(&wdev->list)) {
-			nl80211_notify_iface(rdev, wdev,
-					     NL80211_CMD_DEL_INTERFACE);
+			__cfg80211_unregister_wdev(wdev, false);
 			sysfs_remove_link(&dev->dev.kobj, "phy80211");
-			list_del_rcu(&wdev->list);
-			rdev->devlist_generation++;
-			cfg80211_mlme_purge_registrations(wdev);
-#ifdef CONFIG_CFG80211_WEXT
-			kzfree(wdev->wext.keys);
-#endif
-			flush_work(&wdev->disconnect_wk);
-			cfg80211_cqm_config_free(wdev);
 		}
 		/*
 		 * synchronise (so that we won't find this netdev
-- 
2.14.4

