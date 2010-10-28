Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58524 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab0J1Tqd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 15:46:33 -0400
Received: by wyf28 with SMTP id 28so2320750wyf.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 12:46:32 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] wl1271: set wl->vif only if add_interface succeeded.
Date: Thu, 28 Oct 2010 21:46:43 +0200
Message-Id: <1288295203-12373-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

set wl->vif to the newly created interface only after the firmware booted
successfully. on the way - make the function flow more clear.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v1->v2:
	use wl1271_debug instead of wl1271_error

 drivers/net/wireless/wl12xx/wl1271_main.c |   33 +++++++++++++++++-----------
 1 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index c54887c..a3a1ebc 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -950,18 +950,19 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	struct wiphy *wiphy = hw->wiphy;
 	int retries = WL1271_BOOT_RETRIES;
 	int ret = 0;
+	bool booted = false;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
 		     vif->type, vif->addr);
 
 	mutex_lock(&wl->mutex);
 	if (wl->vif) {
+		wl1271_debug(DEBUG_MAC80211,
+			     "multiple vifs are not supported yet");
 		ret = -EBUSY;
 		goto out;
 	}
 
-	wl->vif = vif;
-
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		wl->bss_type = BSS_TYPE_STA_BSS;
@@ -999,15 +1000,8 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		if (ret < 0)
 			goto irq_disable;
 
-		wl->state = WL1271_STATE_ON;
-		wl1271_info("firmware booted (%s)", wl->chip.fw_ver);
-
-		/* update hw/fw version info in wiphy struct */
-		wiphy->hw_version = wl->chip.id;
-		strncpy(wiphy->fw_version, wl->chip.fw_ver,
-			sizeof(wiphy->fw_version));
-
-		goto out;
+		booted = true;
+		break;
 
 irq_disable:
 		wl1271_disable_interrupts(wl);
@@ -1025,8 +1019,21 @@ power_off:
 		wl1271_power_off(wl);
 	}
 
-	wl1271_error("firmware boot failed despite %d retries",
-		     WL1271_BOOT_RETRIES);
+	if (!booted) {
+		wl1271_error("firmware boot failed despite %d retries",
+			     WL1271_BOOT_RETRIES);
+		goto out;
+	}
+
+	wl->vif = vif;
+	wl->state = WL1271_STATE_ON;
+	wl1271_info("firmware booted (%s)", wl->chip.fw_ver);
+
+	/* update hw/fw version info in wiphy struct */
+	wiphy->hw_version = wl->chip.id;
+	strncpy(wiphy->fw_version, wl->chip.fw_ver,
+		sizeof(wiphy->fw_version));
+
 out:
 	mutex_unlock(&wl->mutex);
 
-- 
1.7.0.4

