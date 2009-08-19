Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:32201 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697AbZHSIGe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 04:06:34 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH V2] cfg80211: allow cfg80211_connect_result with bssid == NULL
Date: Wed, 19 Aug 2009 16:08:22 +0800
Message-Id: <1250669302-11362-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of connection failure, the bssid info is not a must have.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
V2: change a __cfg80211_connect_result() caller to used NULL instead of zero addr

 net/wireless/core.c |    4 +++-
 net/wireless/sme.c  |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index e630648..8eddf98 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -12,6 +12,7 @@
 #include <linux/debugfs.h>
 #include <linux/notifier.h>
 #include <linux/device.h>
+#include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
@@ -309,7 +310,8 @@ static void cfg80211_process_events(struct wireless_dev *wdev)
 		switch (ev->type) {
 		case EVENT_CONNECT_RESULT:
 			__cfg80211_connect_result(
-				wdev->netdev, ev->cr.bssid,
+				wdev->netdev, is_zero_ether_addr(ev->cr.bssid) ?
+				NULL : ev->cr.bssid,
 				ev->cr.req_ie, ev->cr.req_ie_len,
 				ev->cr.resp_ie, ev->cr.resp_ie_len,
 				ev->cr.status,
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 8e2ef54..dbd8211 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -458,7 +458,8 @@ void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
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

