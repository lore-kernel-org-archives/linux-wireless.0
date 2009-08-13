Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7788 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869AbZHMJVg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 05:21:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211: set SME state machine correctly for roam event
Date: Thu, 13 Aug 2009 17:23:19 +0800
Message-Id: <1250155399-17847-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we receive a successful status in CFG80211_SME_CONNECTED state,
it is a roam event. We should mark it as a success result.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/wireless/sme.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 8e2ef54..1aa1190 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -393,7 +393,8 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 	}
 
 	if (status == WLAN_STATUS_SUCCESS &&
-	    wdev->sme_state == CFG80211_SME_IDLE)
+	    (wdev->sme_state == CFG80211_SME_IDLE ||
+	     wdev->sme_state == CFG80211_SME_CONNECTED))
 		goto success;
 
 	if (wdev->sme_state != CFG80211_SME_CONNECTING)
-- 
1.6.0.4

