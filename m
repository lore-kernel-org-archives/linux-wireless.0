Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40347 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab0GHOub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 10:50:31 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 10/13] wl1271: Update interface to temporarily disable dynamic PS
Date: Thu,  8 Jul 2010 17:50:05 +0300
Message-Id: <1278600608-22411-11-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
References: <1278600608-22411-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The mac80211 interface to temporarily disable dynamic PS changed, make
corresponding changes to the driver.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_event.c |    4 ++--
 drivers/net/wireless/wl12xx/wl1271_main.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 525ba1a..2d60d22 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -229,9 +229,9 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	if (vector & SOFT_GEMINI_SENSE_EVENT_ID &&
 	    wl->bss_type == BSS_TYPE_STA_BSS) {
 		if (mbox->soft_gemini_sense_info)
-			ieee80211_disable_dyn_ps(wl->vif, true);
+			ieee80211_disable_dyn_ps(wl->vif);
 		else
-			ieee80211_disable_dyn_ps(wl->vif, false);
+			ieee80211_enable_dyn_ps(wl->vif);
 	}
 
 	/*
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index d50c0a9..70c6b0d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -939,7 +939,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 
 	/* enable dyn ps just in case (if left on due to fw crash etc) */
 	if (wl->bss_type == BSS_TYPE_STA_BSS)
-		ieee80211_disable_dyn_ps(wl->vif, false);
+		ieee80211_enable_dyn_ps(wl->vif);
 
 	if (test_and_clear_bit(WL1271_FLAG_SCANNING, &wl->flags)) {
 		mutex_unlock(&wl->mutex);
@@ -1779,7 +1779,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			wl->aid = 0;
 
 			/* re-enable dynamic ps - just in case */
-			ieee80211_disable_dyn_ps(wl->vif, false);
+			ieee80211_enable_dyn_ps(wl->vif);
 
 			/* revert back to minimum rates for the current band */
 			wl1271_set_band_rate(wl);
-- 
1.6.3.3

