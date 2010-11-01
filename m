Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.ext.nokia.com ([147.243.128.24]:26101 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382Ab0KAMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:25:59 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcN020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:27 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 11/15] mac80211: pass cfg80211 periodic scan request structure down to the driver
Date: Mon,  1 Nov 2010 13:52:12 +0200
Message-Id: <1288612336-2830-12-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pass the cfg80211_periodic_request structure down to the driver.  This
structure contains the channel information (and will have SSID and IE
information) to be passed to the driver.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 include/net/mac80211.h      |    3 ++-
 net/mac80211/driver-ops.h   |    7 ++++---
 net/mac80211/driver-trace.h |    5 +++--
 net/mac80211/scan.c         |    2 +-
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 6b50780..901debb 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1760,7 +1760,8 @@ struct ieee80211_ops {
 	int (*hw_scan)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       struct cfg80211_scan_request *req);
 	int (*periodic_start)(struct ieee80211_hw *hw,
-			      struct ieee80211_vif *vif);
+			      struct ieee80211_vif *vif,
+			      struct cfg80211_periodic_request *req);
 	int (*periodic_stop)(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif);
 	void (*sw_scan_start)(struct ieee80211_hw *hw);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index c425e1c..88b5f90 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -192,14 +192,15 @@ static inline int drv_hw_scan(struct ieee80211_local *local,
 }
 
 static inline int drv_periodic_start(struct ieee80211_local *local,
-				     struct ieee80211_sub_if_data *sdata)
+				     struct ieee80211_sub_if_data *sdata,
+				     struct cfg80211_periodic_request *req)
 {
 	int ret;
 
 	might_sleep();
 
-	trace_drv_periodic_start(local, sdata);
-	ret = local->ops->periodic_start(&local->hw, &sdata->vif);
+	trace_drv_periodic_start(local, sdata, req);
+	ret = local->ops->periodic_start(&local->hw, &sdata->vif, req);
 	trace_drv_return_int(local, ret);
 	return ret;
 }
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 2acdc43..8d6c7e6 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -441,9 +441,10 @@ TRACE_EVENT(drv_hw_scan,
 
 TRACE_EVENT(drv_periodic_start,
 	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_sub_if_data *sdata),
+		 struct ieee80211_sub_if_data *sdata,
+		 struct cfg80211_periodic_request *req),
 
-	TP_ARGS(local, sdata),
+	    TP_ARGS(local, sdata, req),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 9273ab0..fda8d41 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -846,7 +846,7 @@ int ieee80211_request_periodic_start(struct ieee80211_sub_if_data *sdata,
 
 	local->periodic_req = req;
 
-	ret = drv_periodic_start(local, sdata);
+	ret = drv_periodic_start(local, sdata, req);
 	if (!ret)
 		__set_bit(SCAN_PERIODIC_SCANNING, &local->scanning);
 	else
-- 
1.7.0.4

