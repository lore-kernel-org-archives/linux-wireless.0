Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.nokia.com ([147.243.128.24]:26080 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab0KAMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:25:59 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcE020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:18 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 02/15] cfg80211: add periodic scan request structure
Date: Mon,  1 Nov 2010 13:52:03 +0200
Message-Id: <1288612336-2830-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tihs patch adds the periodic scan request structure to cfg80211.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 include/net/cfg80211.h |   12 ++++++++++++
 net/wireless/core.h    |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2a7936d..84518cc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -719,6 +719,18 @@ struct cfg80211_scan_request {
 };
 
 /**
+ * struct cfg80211_periodic_request - periodic scan request description
+ *
+ * @wiphy: the wiphy this was for
+ * @dev: the interface
+ */
+struct cfg80211_periodic_request {
+	/* internal */
+	struct wiphy *wiphy;
+	struct net_device *dev;
+};
+
+/**
  * enum cfg80211_signal_type - signal type
  *
  * @CFG80211_SIGNAL_TYPE_NONE: no signal strength information available
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 2d1d4c7..bf4e348 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -60,6 +60,7 @@ struct cfg80211_registered_device {
 	struct rb_root bss_tree;
 	u32 bss_generation;
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
+	struct cfg80211_periodic_request *periodic_req; /* protected by RTNL */
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
 
-- 
1.7.0.4

