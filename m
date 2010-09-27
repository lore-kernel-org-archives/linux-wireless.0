Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56017 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837Ab0I0IiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:19 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8bvwX023998
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:38:16 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 04/25] wl1271: Fix scan race condition
Date: Mon, 27 Sep 2010 11:37:28 +0300
Message-Id: <1285576669-8070-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

In the scan state machine, the wl1271_mutex is unlocked first then relocked,
and then the scan state variables are modified.

This makes it possible for ieee80211_scan_complete to be called twice in some
scenarios, as the scan completion event from the firmware may be processed
while the mutex is unlocked.

To fix the issue, move the ieee80211_scan_complete call last in the function.
This is generally safer, but there still may be issues is functions calling
the scan state machine rely on states checked before the unlocking of the
global mutex.

(forward ported from 2.6.32 -- this is not strictly needed anymore, because
the mutex doesn't need to be unlocked anymore, but I'm applying this change
anyway, so that the call to ieee80211_scan_complete is in the same place)

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    2 +-
 drivers/net/wireless/wl12xx/wl1271_scan.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 45d4ce3..02ad6c6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1015,10 +1015,10 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 		ieee80211_enable_dyn_ps(wl->vif);
 
 	if (wl->scan.state != WL1271_SCAN_STATE_IDLE) {
-		ieee80211_scan_completed(wl->hw, true);
 		wl->scan.state = WL1271_SCAN_STATE_IDLE;
 		kfree(wl->scan.scanned_ch);
 		wl->scan.scanned_ch = NULL;
+		ieee80211_scan_completed(wl->hw, true);
 	}
 
 	wl->state = WL1271_STATE_OFF;
diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.c b/drivers/net/wireless/wl12xx/wl1271_scan.c
index 9c80ba9..8ceaabe 100644
--- a/drivers/net/wireless/wl12xx/wl1271_scan.c
+++ b/drivers/net/wireless/wl12xx/wl1271_scan.c
@@ -215,12 +215,11 @@ void wl1271_scan_stm(struct wl1271 *wl)
 		break;
 
 	case WL1271_SCAN_STATE_DONE:
-		ieee80211_scan_completed(wl->hw, false);
-
 		kfree(wl->scan.scanned_ch);
 		wl->scan.scanned_ch = NULL;
 
 		wl->scan.state = WL1271_SCAN_STATE_IDLE;
+		ieee80211_scan_completed(wl->hw, false);
 		break;
 
 	default:
-- 
1.6.3.3

