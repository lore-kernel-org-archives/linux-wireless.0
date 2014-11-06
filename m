Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62633 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbaKFHzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:55:25 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 10/21] ath9k: use ath_common instead of ieee80211_hw in ath9k_spectral_scan_
Date: Thu,  6 Nov 2014 08:53:27 +0100
Message-Id: <1415260418-14321-11-git-send-email-linux@rempel-privat.de> (sfid-20141106_085536_307198_686291D6)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we don't have here any ieee80211_hw dependencies any way.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/channel.c  |  2 +-
 drivers/net/wireless/ath/ath9k/main.c     | 12 +++++-------
 drivers/net/wireless/ath/ath9k/spectral.c | 10 +++++-----
 drivers/net/wireless/ath/ath9k/spectral.h |  4 ++--
 4 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 25a21fa..814178a 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -93,7 +93,7 @@ static int ath_set_channel(struct ath_softc *sc)
 		/* perform spectral scan if requested. */
 		if (test_bit(ATH_OP_SCANNING, &common->op_flags) &&
 			sc->spec_priv.spectral_mode == SPECTRAL_CHANSCAN)
-			ath9k_spectral_scan_trigger(hw);
+			ath9k_spectral_scan_trigger(common);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 747dd5a..6edd4d3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1339,11 +1339,10 @@ static void ath9k_disable_ps(struct ath_softc *sc)
 	ath_dbg(common, PS, "PowerSave disabled\n");
 }
 
-void ath9k_spectral_scan_trigger(struct ieee80211_hw *hw)
+void ath9k_spectral_scan_trigger(struct ath_common *common)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_softc *sc = common->priv;
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
 	u32 rxfilter;
 
 	if (config_enabled(CONFIG_ATH9K_TX99))
@@ -1365,17 +1364,16 @@ void ath9k_spectral_scan_trigger(struct ieee80211_hw *hw)
 	 * configuration, otherwise the register will have its values reset
 	 * (on my ar9220 to value 0x01002310)
 	 */
-	ath9k_spectral_scan_config(hw, sc->spec_priv.spectral_mode);
+	ath9k_spectral_scan_config(common, sc->spec_priv.spectral_mode);
 	ath9k_hw_ops(ah)->spectral_scan_trigger(ah);
 	ath_ps_ops(common)->restore(common);
 }
 
-int ath9k_spectral_scan_config(struct ieee80211_hw *hw,
+int ath9k_spectral_scan_config(struct ath_common *common,
 			       enum spectral_mode spectral_mode)
 {
-	struct ath_softc *sc = hw->priv;
+	struct ath_softc *sc = common->priv;
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
 		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
diff --git a/drivers/net/wireless/ath/ath9k/spectral.c b/drivers/net/wireless/ath/ath9k/spectral.c
index 50af6bc..4549dce 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.c
+++ b/drivers/net/wireless/ath/ath9k/spectral.c
@@ -253,18 +253,18 @@ static ssize_t write_file_spec_scan_ctl(struct file *file,
 	buf[len] = '\0';
 
 	if (strncmp("trigger", buf, 7) == 0) {
-		ath9k_spectral_scan_trigger(common->hw);
+		ath9k_spectral_scan_trigger(common);
 	} else if (strncmp("background", buf, 10) == 0) {
-		ath9k_spectral_scan_config(common->hw, SPECTRAL_BACKGROUND);
+		ath9k_spectral_scan_config(common, SPECTRAL_BACKGROUND);
 		ath_dbg(common, CONFIG, "spectral scan: background mode enabled\n");
 	} else if (strncmp("chanscan", buf, 8) == 0) {
-		ath9k_spectral_scan_config(common->hw, SPECTRAL_CHANSCAN);
+		ath9k_spectral_scan_config(common, SPECTRAL_CHANSCAN);
 		ath_dbg(common, CONFIG, "spectral scan: channel scan mode enabled\n");
 	} else if (strncmp("manual", buf, 6) == 0) {
-		ath9k_spectral_scan_config(common->hw, SPECTRAL_MANUAL);
+		ath9k_spectral_scan_config(common, SPECTRAL_MANUAL);
 		ath_dbg(common, CONFIG, "spectral scan: manual mode enabled\n");
 	} else if (strncmp("disable", buf, 7) == 0) {
-		ath9k_spectral_scan_config(common->hw, SPECTRAL_DISABLED);
+		ath9k_spectral_scan_config(common, SPECTRAL_DISABLED);
 		ath_dbg(common, CONFIG, "spectral scan: disabled\n");
 	} else {
 		return -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/spectral.h b/drivers/net/wireless/ath/ath9k/spectral.h
index 555fcbb..53660e6 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.h
+++ b/drivers/net/wireless/ath/ath9k/spectral.h
@@ -133,8 +133,8 @@ static inline u8 spectral_bitmap_weight(u8 *bins)
 void ath9k_spectral_init_debug(struct ath_spec_scan_priv *spec_priv, struct dentry *debugfs_phy);
 void ath9k_spectral_deinit_debug(struct ath_spec_scan_priv *spec_priv);
 
-void ath9k_spectral_scan_trigger(struct ieee80211_hw *hw);
-int ath9k_spectral_scan_config(struct ieee80211_hw *hw,
+void ath9k_spectral_scan_trigger(struct ath_common *common);
+int ath9k_spectral_scan_config(struct ath_common *common,
 			       enum spectral_mode spectral_mode);
 
 #ifdef CONFIG_ATH9K_DEBUGFS
-- 
1.9.1

