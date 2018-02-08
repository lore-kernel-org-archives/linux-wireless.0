Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60251 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbeBHF2K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 00:28:10 -0500
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
To: kvalo@codeaurora.org
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Subject: [PATCH] ath9k: turn on btcoex_enable as default
Date: Thu,  8 Feb 2018 13:28:01 +0800
Message-Id: <20180208052801.15670-1-kai.heng.feng@canonical.com> (sfid-20180208_062842_935019_A684D9B9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without btcoex_enable, WiFi activies make both WiFi and Bluetooth
unstable if there's a bluetooth connection.

Enable this option when bt_ant_diversity is disabled.

BugLink: https://bugs.launchpad.net/bugs/1746164
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e479fae5aab9..f8f6b091a077 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -56,7 +56,7 @@ static int ath9k_led_active_high = -1;
 module_param_named(led_active_high, ath9k_led_active_high, int, 0444);
 MODULE_PARM_DESC(led_active_high, "Invert LED polarity");
 
-static int ath9k_btcoex_enable;
+static int ath9k_btcoex_enable = 1;
 module_param_named(btcoex_enable, ath9k_btcoex_enable, int, 0444);
 MODULE_PARM_DESC(btcoex_enable, "Enable wifi-BT coexistence");
 
@@ -693,7 +693,6 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	common->hw = sc->hw;
 	common->priv = sc;
 	common->debug_mask = ath9k_debug;
-	common->btcoex_enabled = ath9k_btcoex_enable == 1;
 	common->disable_ani = false;
 
 	/*
@@ -715,14 +714,17 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	/*
 	 * Enable WLAN/BT RX Antenna diversity only when:
 	 *
-	 * - BTCOEX is disabled.
 	 * - the user manually requests the feature.
 	 * - the HW cap is set using the platform data.
 	 */
-	if (!common->btcoex_enabled && ath9k_bt_ant_diversity &&
+	if (ath9k_bt_ant_diversity &&
 	    (pCap->hw_caps & ATH9K_HW_CAP_BT_ANT_DIV))
 		common->bt_ant_diversity = 1;
 
+	/* Enable btcoex when ant_diversity is disabled */
+	if (!common->bt_ant_diversity && ath9k_btcoex_enable)
+		common->btcoex_enabled = 1;
+
 	spin_lock_init(&common->cc_lock);
 	spin_lock_init(&sc->intr_lock);
 	spin_lock_init(&sc->sc_serial_rw);
-- 
2.15.1
