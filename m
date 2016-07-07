Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35660 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932883AbcGFXIi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 19:08:38 -0400
Received: by mail-oi0-f66.google.com with SMTP id d132so180343oig.2
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2016 16:08:37 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH 1/5] nl80211: Add nl80211_notify_iface
Date: Thu,  7 Jul 2016 02:08:46 -0500
Message-Id: <1467875330-7835-2-git-send-email-denkenz@gmail.com> (sfid-20160707_010854_310553_78FE4EBA)
In-Reply-To: <1467875330-7835-1-git-send-email-denkenz@gmail.com>
References: <1467875330-7835-1-git-send-email-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function emits NL80211_CMD_NEW_INTERFACE or
NL80211_CMD_DEL_INTERFACE events.  This is meant to be used by the core
to notify userspace applications such as wpa_supplicant when a netdev
related to a wireless device has been added or removed.
---
 net/wireless/nl80211.c | 28 ++++++++++++++++++++++++++++
 net/wireless/nl80211.h |  3 +++
 2 files changed, 31 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f39fd4d..da03e17 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11855,6 +11855,34 @@ void nl80211_notify_wiphy(struct cfg80211_registered_device *rdev,
 				NL80211_MCGRP_CONFIG, GFP_KERNEL);
 }
 
+void nl80211_notify_iface(struct cfg80211_registered_device *rdev,
+				struct wireless_dev *wdev,
+				enum nl80211_commands cmd)
+{
+	struct sk_buff *msg;
+	bool removal;
+
+	WARN_ON(cmd != NL80211_CMD_NEW_INTERFACE &&
+		cmd != NL80211_CMD_DEL_INTERFACE);
+
+	if (cmd == NL80211_CMD_DEL_INTERFACE)
+		removal = true;
+	else
+		removal = false;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	if (nl80211_send_iface(msg, 0, 0, 0, rdev, wdev, removal) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_CONFIG, GFP_KERNEL);
+}
+
 static int nl80211_add_scan_req(struct sk_buff *msg,
 				struct cfg80211_registered_device *rdev)
 {
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index a63f402..6f6b73c 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -7,6 +7,9 @@ int nl80211_init(void);
 void nl80211_exit(void);
 void nl80211_notify_wiphy(struct cfg80211_registered_device *rdev,
 			  enum nl80211_commands cmd);
+void nl80211_notify_iface(struct cfg80211_registered_device *rdev,
+				struct wireless_dev *wdev,
+				enum nl80211_commands cmd);
 void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
 			     struct wireless_dev *wdev);
 struct sk_buff *nl80211_build_scan_msg(struct cfg80211_registered_device *rdev,
-- 
2.7.3

