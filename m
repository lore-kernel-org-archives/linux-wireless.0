Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:65439 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbaKFHzC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:55:02 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 11/21] ath9k: make ath9k_spectral_scan_ do not depend on ath_softc
Date: Thu,  6 Nov 2014 08:53:28 +0100
Message-Id: <1415260418-14321-12-git-send-email-linux@rempel-privat.de> (sfid-20141106_085507_435583_A2C41E1E)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

last preparation before moving ath9k_spectral_scan_ to spectral.c

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/channel.c  |  2 +-
 drivers/net/wireless/ath/ath9k/main.c     | 26 +++++++++++++-------------
 drivers/net/wireless/ath/ath9k/spectral.c | 10 +++++-----
 drivers/net/wireless/ath/ath9k/spectral.h |  4 +++-
 4 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 814178a..32ce931 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -93,7 +93,7 @@ static int ath_set_channel(struct ath_softc *sc)
 		/* perform spectral scan if requested. */
 		if (test_bit(ATH_OP_SCANNING, &common->op_flags) &&
 			sc->spec_priv.spectral_mode == SPECTRAL_CHANSCAN)
-			ath9k_spectral_scan_trigger(common);
+			ath9k_spectral_scan_trigger(common, &sc->spec_priv);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6edd4d3..ec1ebf9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1339,10 +1339,10 @@ static void ath9k_disable_ps(struct ath_softc *sc)
 	ath_dbg(common, PS, "PowerSave disabled\n");
 }
 
-void ath9k_spectral_scan_trigger(struct ath_common *common)
+void ath9k_spectral_scan_trigger(struct ath_common *common,
+				 struct ath_spec_scan_priv *spec_priv)
 {
-	struct ath_softc *sc = common->priv;
-	struct ath_hw *ah = sc->sc_ah;
+	struct ath_hw *ah = spec_priv->ah;
 	u32 rxfilter;
 
 	if (config_enabled(CONFIG_ATH9K_TX99))
@@ -1364,16 +1364,16 @@ void ath9k_spectral_scan_trigger(struct ath_common *common)
 	 * configuration, otherwise the register will have its values reset
 	 * (on my ar9220 to value 0x01002310)
 	 */
-	ath9k_spectral_scan_config(common, sc->spec_priv.spectral_mode);
+	ath9k_spectral_scan_config(common, spec_priv, spec_priv->spectral_mode);
 	ath9k_hw_ops(ah)->spectral_scan_trigger(ah);
 	ath_ps_ops(common)->restore(common);
 }
 
 int ath9k_spectral_scan_config(struct ath_common *common,
+			       struct ath_spec_scan_priv *spec_priv,
 			       enum spectral_mode spectral_mode)
 {
-	struct ath_softc *sc = common->priv;
-	struct ath_hw *ah = sc->sc_ah;
+	struct ath_hw *ah = spec_priv->ah;
 
 	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
 		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
@@ -1382,29 +1382,29 @@ int ath9k_spectral_scan_config(struct ath_common *common,
 
 	switch (spectral_mode) {
 	case SPECTRAL_DISABLED:
-		sc->spec_priv.spec_config.enabled = 0;
+		spec_priv->spec_config.enabled = 0;
 		break;
 	case SPECTRAL_BACKGROUND:
 		/* send endless samples.
 		 * TODO: is this really useful for "background"?
 		 */
-		sc->spec_priv.spec_config.endless = 1;
-		sc->spec_priv.spec_config.enabled = 1;
+		spec_priv->spec_config.endless = 1;
+		spec_priv->spec_config.enabled = 1;
 		break;
 	case SPECTRAL_CHANSCAN:
 	case SPECTRAL_MANUAL:
-		sc->spec_priv.spec_config.endless = 0;
-		sc->spec_priv.spec_config.enabled = 1;
+		spec_priv->spec_config.endless = 0;
+		spec_priv->spec_config.enabled = 1;
 		break;
 	default:
 		return -1;
 	}
 
 	ath_ps_ops(common)->wakeup(common);
-	ath9k_hw_ops(ah)->spectral_scan_config(ah, &sc->spec_priv.spec_config);
+	ath9k_hw_ops(ah)->spectral_scan_config(ah, &spec_priv->spec_config);
 	ath_ps_ops(common)->restore(common);
 
-	sc->spec_priv.spectral_mode = spectral_mode;
+	spec_priv->spectral_mode = spectral_mode;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/spectral.c b/drivers/net/wireless/ath/ath9k/spectral.c
index 4549dce..756d63e 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.c
+++ b/drivers/net/wireless/ath/ath9k/spectral.c
@@ -253,18 +253,18 @@ static ssize_t write_file_spec_scan_ctl(struct file *file,
 	buf[len] = '\0';
 
 	if (strncmp("trigger", buf, 7) == 0) {
-		ath9k_spectral_scan_trigger(common);
+		ath9k_spectral_scan_trigger(common, spec_priv);
 	} else if (strncmp("background", buf, 10) == 0) {
-		ath9k_spectral_scan_config(common, SPECTRAL_BACKGROUND);
+		ath9k_spectral_scan_config(common, spec_priv, SPECTRAL_BACKGROUND);
 		ath_dbg(common, CONFIG, "spectral scan: background mode enabled\n");
 	} else if (strncmp("chanscan", buf, 8) == 0) {
-		ath9k_spectral_scan_config(common, SPECTRAL_CHANSCAN);
+		ath9k_spectral_scan_config(common, spec_priv, SPECTRAL_CHANSCAN);
 		ath_dbg(common, CONFIG, "spectral scan: channel scan mode enabled\n");
 	} else if (strncmp("manual", buf, 6) == 0) {
-		ath9k_spectral_scan_config(common, SPECTRAL_MANUAL);
+		ath9k_spectral_scan_config(common, spec_priv, SPECTRAL_MANUAL);
 		ath_dbg(common, CONFIG, "spectral scan: manual mode enabled\n");
 	} else if (strncmp("disable", buf, 7) == 0) {
-		ath9k_spectral_scan_config(common, SPECTRAL_DISABLED);
+		ath9k_spectral_scan_config(common, spec_priv, SPECTRAL_DISABLED);
 		ath_dbg(common, CONFIG, "spectral scan: disabled\n");
 	} else {
 		return -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/spectral.h b/drivers/net/wireless/ath/ath9k/spectral.h
index 53660e6..77582cf 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.h
+++ b/drivers/net/wireless/ath/ath9k/spectral.h
@@ -133,8 +133,10 @@ static inline u8 spectral_bitmap_weight(u8 *bins)
 void ath9k_spectral_init_debug(struct ath_spec_scan_priv *spec_priv, struct dentry *debugfs_phy);
 void ath9k_spectral_deinit_debug(struct ath_spec_scan_priv *spec_priv);
 
-void ath9k_spectral_scan_trigger(struct ath_common *common);
+void ath9k_spectral_scan_trigger(struct ath_common *common,
+				 struct ath_spec_scan_priv *spec_priv);
 int ath9k_spectral_scan_config(struct ath_common *common,
+			       struct ath_spec_scan_priv *spec_priv,
 			       enum spectral_mode spectral_mode);
 
 #ifdef CONFIG_ATH9K_DEBUGFS
-- 
1.9.1

