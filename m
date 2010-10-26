Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50734 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab0JZP0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 11:26:06 -0400
Received: by wyf28 with SMTP id 28so4764616wyf.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Oct 2010 08:26:05 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH] wl1271: set wl->vif only if add_interface succeeded.
Date: Tue, 26 Oct 2010 17:26:09 +0200
Message-Id: <1288106769-11990-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

set wl->vif to the newly created interface only after the firmware booted
successfully. on the way - make the function flow more clear.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   32 +++++++++++++++++-----------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index c54887c..2599157 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -950,18 +950,18 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	struct wiphy *wiphy = hw->wiphy;
 	int retries = WL1271_BOOT_RETRIES;
 	int ret = 0;
+	bool booted = false;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
 		     vif->type, vif->addr);
 
 	mutex_lock(&wl->mutex);
 	if (wl->vif) {
+		wl1271_error("multiple vifs are not supported yet");
 		ret = -EBUSY;
 		goto out;
 	}
 
-	wl->vif = vif;
-
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		wl->bss_type = BSS_TYPE_STA_BSS;
@@ -999,15 +999,8 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
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
@@ -1025,8 +1018,21 @@ power_off:
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

