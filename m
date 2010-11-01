Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.nokia.com ([147.243.128.24]:26082 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814Ab0KAMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:25:59 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcR020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:31 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 15/15] mac80211: create and pass the ies for each band in periodic scans
Date: Mon,  1 Nov 2010 13:52:16 +0200
Message-Id: <1288612336-2830-16-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create the scan IEs for each band and pass to the driver as part of the
periodic scan op.

For now, we don't support IEs passed from the userspace.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 net/mac80211/scan.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index fda8d41..2e7661f 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -828,7 +828,7 @@ int ieee80211_request_periodic_start(struct ieee80211_sub_if_data *sdata,
 				     struct cfg80211_periodic_request *req)
 {
 	struct ieee80211_local *local = sdata->local;
-	int ret;
+	int ret, i;
 
 	mutex_lock(&sdata->local->mtx);
 
@@ -844,6 +844,16 @@ int ieee80211_request_periodic_start(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
+		req->ie[i] = kzalloc(2 + IEEE80211_MAX_SSID_LEN +
+				     local->scan_ies_len, GFP_KERNEL);
+
+		req->ie_len[i] = ieee80211_build_preq_ies(local,
+							  (u8 *) req->ie[i],
+							  NULL, 0, i,
+							  (u32) -1, 0);
+	}
+
 	local->periodic_req = req;
 
 	ret = drv_periodic_start(local, sdata, req);
@@ -860,7 +870,7 @@ out:
 int ieee80211_request_periodic_stop(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	int ret = 0;
+	int ret = 0, i;
 
 	mutex_lock(&sdata->local->mtx);
 
@@ -870,6 +880,9 @@ int ieee80211_request_periodic_stop(struct ieee80211_sub_if_data *sdata)
 	}
 
 	if (local->periodic_req) {
+		for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+			kfree(local->periodic_req->ie[i]);
+
 		ret = drv_periodic_stop(local, sdata);
 		local->periodic_req = NULL;
 		__clear_bit(SCAN_PERIODIC_SCANNING, &local->scanning);
-- 
1.7.0.4

