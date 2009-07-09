Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7205 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758457AbZGII7w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 04:59:52 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] cfg80211: fix NULL dereference in IBSS SIOCGIWAP
Date: Thu,  9 Jul 2009 16:59:49 +0800
Message-Id: <1247129989-24989-1-git-send-email-yi.zhu@intel.com>
CC: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch avoids memcpy from wdev->wext.ibss.bssid if it is NULL.
This could happen if we SIOCGIWAP before SIOCSIWAP.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/wireless/ibss.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 99ef936..cf3a7dc 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -434,8 +434,11 @@ int cfg80211_ibss_wext_giwap(struct net_device *dev,
 	wdev_lock(wdev);
 	if (wdev->current_bss)
 		memcpy(ap_addr->sa_data, wdev->current_bss->pub.bssid, ETH_ALEN);
-	else
+	else if (wdev->wext.ibss.bssid)
 		memcpy(ap_addr->sa_data, wdev->wext.ibss.bssid, ETH_ALEN);
+	else
+		memset(ap_addr->sa_data, 0, ETH_ALEN);
+
 	wdev_unlock(wdev);
 
 	return 0;
-- 
1.6.0.4

