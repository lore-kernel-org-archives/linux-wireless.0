Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17222 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbZHSG1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 02:27:50 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] cfg80211: allow cfg80211_connect_result with bssid == NULL
Date: Wed, 19 Aug 2009 14:29:38 +0800
Message-Id: <1250663378-9113-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of connection failure, the bssid info is not a must have.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/wireless/sme.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index b78a111..bc9584a 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -435,7 +435,8 @@ void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 		return;
 
 	ev->type = EVENT_CONNECT_RESULT;
-	memcpy(ev->cr.bssid, bssid, ETH_ALEN);
+	if (bssid)
+		memcpy(ev->cr.bssid, bssid, ETH_ALEN);
 	ev->cr.req_ie = ((u8 *)ev) + sizeof(*ev);
 	ev->cr.req_ie_len = req_ie_len;
 	memcpy((void *)ev->cr.req_ie, req_ie, req_ie_len);
-- 
1.6.0.4

