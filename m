Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42615 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759541AbcINHjv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 03:39:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix scan completed tracing
Date: Wed, 14 Sep 2016 09:39:48 +0200
Message-Id: <1473838788-27617-1-git-send-email-johannes@sipsolutions.net> (sfid-20160914_093955_094400_F01F5501)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Passing the 'info' pointer where a 'info->aborted' is expected will
always lead to tracing to erroneously record that the scan was aborted,
fix that by passing the correct info->aborted. The remaining data will
be collected in cfg80211, so I haven't duplicated it here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 070b40f15850..23d8ac829279 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -420,7 +420,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw,
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	trace_api_scan_completed(local, info);
+	trace_api_scan_completed(local, info->aborted);
 
 	set_bit(SCAN_COMPLETED, &local->scanning);
 	if (info->aborted)
-- 
2.8.1
