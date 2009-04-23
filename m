Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40959 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbZDWIph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 04:45:37 -0400
Subject: [PATCH] iwlwifi: notify on scan completion even when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Reinette Chatre <reinette.chatre@intel.com>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 10:45:04 +0200
Message-Id: <1240476304.30082.174.camel@johannes.local> (sfid-20090423_104553_681934_7AE29472)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Under certain circumstances iwlwifi can get stuck and will no
longer accept scan requests, because the core code (cfg80211)
thinks that it's still processing one. This fixes one of the
points where it can happen, but I've still seen it (although
only with my radio-off-when-idle patch).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-scan.c	2009-04-21 23:36:10.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-scan.c	2009-04-23 10:43:08.000000000 +0200
@@ -814,12 +814,12 @@ void iwl_bg_scan_completed(struct work_s
 
 	IWL_DEBUG_SCAN(priv, "SCAN complete scan\n");
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
 	priv->scan_request = NULL;
 	ieee80211_scan_completed(priv->hw, false);
 
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
 	/* Since setting the TXPOWER may have been deferred while
 	 * performing the scan, fire one off */
 	mutex_lock(&priv->mutex);


