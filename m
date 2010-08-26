Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47492 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab0HZLfo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 07:35:44 -0400
Message-Id: <20100826113438.826909320@sipsolutions.net>
Date: Thu, 26 Aug 2010 13:30:27 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] wl12xx: remove unneeded locking
References: <20100826113024.738612439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With the scan callback now being callable from
any context, these unlocks/locks can go away.
This makes the code easier to understand, since
callers of these functions must no longer be
aware that the mutex may be dropped.

As Stanislaw is working on iwlwifi scanning, I
didn't change it to take advantage of the new
mac80211 semantics.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/wl12xx/wl1251_event.c |    2 --
 drivers/net/wireless/wl12xx/wl1251_main.c  |    2 --
 drivers/net/wireless/wl12xx/wl1271_main.c  |    2 --
 drivers/net/wireless/wl12xx/wl1271_scan.c  |    2 --
 4 files changed, 8 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1251_event.c	2010-08-26 13:29:57.000000000 +0200
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1251_event.c	2010-08-26 13:30:03.000000000 +0200
@@ -36,9 +36,7 @@ static int wl1251_event_scan_complete(st
 		     mbox->scheduled_scan_channels);
 
 	if (wl->scanning) {
-		mutex_unlock(&wl->mutex);
 		ieee80211_scan_completed(wl->hw, false);
-		mutex_lock(&wl->mutex);
 		wl1251_debug(DEBUG_MAC80211, "mac80211 hw scan completed");
 		wl->scanning = false;
 	}
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1251_main.c	2010-08-26 13:29:57.000000000 +0200
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1251_main.c	2010-08-26 13:30:03.000000000 +0200
@@ -469,9 +469,7 @@ static void wl1251_op_stop(struct ieee80
 	WARN_ON(wl->state != WL1251_STATE_ON);
 
 	if (wl->scanning) {
-		mutex_unlock(&wl->mutex);
 		ieee80211_scan_completed(wl->hw, true);
-		mutex_lock(&wl->mutex);
 		wl->scanning = false;
 	}
 
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1271_main.c	2010-08-26 13:29:57.000000000 +0200
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1271_main.c	2010-08-26 13:30:03.000000000 +0200
@@ -948,9 +948,7 @@ static void wl1271_op_remove_interface(s
 		ieee80211_enable_dyn_ps(wl->vif);
 
 	if (wl->scan.state != WL1271_SCAN_STATE_IDLE) {
-		mutex_unlock(&wl->mutex);
 		ieee80211_scan_completed(wl->hw, true);
-		mutex_lock(&wl->mutex);
 		wl->scan.state = WL1271_SCAN_STATE_IDLE;
 		kfree(wl->scan.scanned_ch);
 		wl->scan.scanned_ch = NULL;
--- wireless-testing.orig/drivers/net/wireless/wl12xx/wl1271_scan.c	2010-08-26 13:29:57.000000000 +0200
+++ wireless-testing/drivers/net/wireless/wl12xx/wl1271_scan.c	2010-08-26 13:30:03.000000000 +0200
@@ -215,9 +215,7 @@ void wl1271_scan_stm(struct wl1271 *wl)
 		break;
 
 	case WL1271_SCAN_STATE_DONE:
-		mutex_unlock(&wl->mutex);
 		ieee80211_scan_completed(wl->hw, false);
-		mutex_lock(&wl->mutex);
 
 		kfree(wl->scan.scanned_ch);
 		wl->scan.scanned_ch = NULL;


