Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:49259 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbcHKKcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 06:32:08 -0400
From: Maxim Altshul <maxim.altshul@ti.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Maxim Altshul <maxim.altshul@ti.com>
Subject: [PATCH] mac80211: Add protection to get_expected_throughput opcode
Date: Thu, 11 Aug 2016 13:38:16 +0300
Message-ID: <20160811103816.1695-2-maxim.altshul@ti.com> (sfid-20160811_123212_706000_7855AC99)
In-Reply-To: <20160811103816.1695-1-maxim.altshul@ti.com>
References: <20160811103816.1695-1-maxim.altshul@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To protect the opcode we add a check for sta->uploaded.

This is done to prevent a situation where the function gets
called from userspace for example, before sta is uploaded
to driver, causing a crash.

Also, change headers to comply with the change, wherever the
function was called.

Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>
---
 net/mac80211/driver-ops.h | 8 ++++----
 net/mac80211/sta_info.c   | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 1f75195..ec4a690 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1075,13 +1075,13 @@ static inline void drv_leave_ibss(struct ieee80211_local *local,
 }
 
 static inline u32 drv_get_expected_throughput(struct ieee80211_local *local,
-					      struct ieee80211_sta *sta)
+					      struct sta_info *sta)
 {
 	u32 ret = 0;
 
-	trace_drv_get_expected_throughput(sta);
-	if (local->ops->get_expected_throughput)
-		ret = local->ops->get_expected_throughput(&local->hw, sta);
+	trace_drv_get_expected_throughput(&sta->sta);
+	if (local->ops->get_expected_throughput && sta->uploaded)
+		ret = local->ops->get_expected_throughput(&local->hw, &sta->sta);
 	trace_drv_return_u32(local, ret);
 
 	return ret;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8860c6c..6624577 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2108,7 +2108,7 @@ u32 sta_get_expected_throughput(struct sta_info *sta)
 	if (ref && ref->ops->get_expected_throughput)
 		thr = ref->ops->get_expected_throughput(sta->rate_ctrl_priv);
 	else
-		thr = drv_get_expected_throughput(local, &sta->sta);
+		thr = drv_get_expected_throughput(local, sta);
 
 	return thr;
 }
-- 
2.9.0

