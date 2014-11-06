Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:50434 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbaKFHyY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:54:24 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 12/21] ath9k: move ath9k_spectral_scan_ from main.c to spectral.c
Date: Thu,  6 Nov 2014 08:53:29 +0100
Message-Id: <1415260418-14321-13-git-send-email-linux@rempel-privat.de> (sfid-20141106_085429_143324_0A1DBD40)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now we should be ready to make this code common.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/main.c     | 70 -------------------------------
 drivers/net/wireless/ath/ath9k/spectral.c | 70 +++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ec1ebf9..2f0eec2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1339,76 +1339,6 @@ static void ath9k_disable_ps(struct ath_softc *sc)
 	ath_dbg(common, PS, "PowerSave disabled\n");
 }
 
-void ath9k_spectral_scan_trigger(struct ath_common *common,
-				 struct ath_spec_scan_priv *spec_priv)
-{
-	struct ath_hw *ah = spec_priv->ah;
-	u32 rxfilter;
-
-	if (config_enabled(CONFIG_ATH9K_TX99))
-		return;
-
-	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
-		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
-		return;
-	}
-
-	ath_ps_ops(common)->wakeup(common);
-	rxfilter = ath9k_hw_getrxfilter(ah);
-	ath9k_hw_setrxfilter(ah, rxfilter |
-				 ATH9K_RX_FILTER_PHYRADAR |
-				 ATH9K_RX_FILTER_PHYERR);
-
-	/* TODO: usually this should not be neccesary, but for some reason
-	 * (or in some mode?) the trigger must be called after the
-	 * configuration, otherwise the register will have its values reset
-	 * (on my ar9220 to value 0x01002310)
-	 */
-	ath9k_spectral_scan_config(common, spec_priv, spec_priv->spectral_mode);
-	ath9k_hw_ops(ah)->spectral_scan_trigger(ah);
-	ath_ps_ops(common)->restore(common);
-}
-
-int ath9k_spectral_scan_config(struct ath_common *common,
-			       struct ath_spec_scan_priv *spec_priv,
-			       enum spectral_mode spectral_mode)
-{
-	struct ath_hw *ah = spec_priv->ah;
-
-	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
-		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
-		return -1;
-	}
-
-	switch (spectral_mode) {
-	case SPECTRAL_DISABLED:
-		spec_priv->spec_config.enabled = 0;
-		break;
-	case SPECTRAL_BACKGROUND:
-		/* send endless samples.
-		 * TODO: is this really useful for "background"?
-		 */
-		spec_priv->spec_config.endless = 1;
-		spec_priv->spec_config.enabled = 1;
-		break;
-	case SPECTRAL_CHANSCAN:
-	case SPECTRAL_MANUAL:
-		spec_priv->spec_config.endless = 0;
-		spec_priv->spec_config.enabled = 1;
-		break;
-	default:
-		return -1;
-	}
-
-	ath_ps_ops(common)->wakeup(common);
-	ath9k_hw_ops(ah)->spectral_scan_config(ah, &spec_priv->spec_config);
-	ath_ps_ops(common)->restore(common);
-
-	spec_priv->spectral_mode = spectral_mode;
-
-	return 0;
-}
-
 static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ath_softc *sc = hw->priv;
diff --git a/drivers/net/wireless/ath/ath9k/spectral.c b/drivers/net/wireless/ath/ath9k/spectral.c
index 756d63e..bf85740 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.c
+++ b/drivers/net/wireless/ath/ath9k/spectral.c
@@ -234,6 +234,76 @@ static ssize_t read_file_spec_scan_ctl(struct file *file, char __user *user_buf,
 	return simple_read_from_buffer(user_buf, count, ppos, mode, len);
 }
 
+void ath9k_spectral_scan_trigger(struct ath_common *common,
+				 struct ath_spec_scan_priv *spec_priv)
+{
+	struct ath_hw *ah = spec_priv->ah;
+	u32 rxfilter;
+
+	if (config_enabled(CONFIG_ATH9K_TX99))
+		return;
+
+	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
+		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
+		return;
+	}
+
+	ath_ps_ops(common)->wakeup(common);
+	rxfilter = ath9k_hw_getrxfilter(ah);
+	ath9k_hw_setrxfilter(ah, rxfilter |
+				 ATH9K_RX_FILTER_PHYRADAR |
+				 ATH9K_RX_FILTER_PHYERR);
+
+	/* TODO: usually this should not be neccesary, but for some reason
+	 * (or in some mode?) the trigger must be called after the
+	 * configuration, otherwise the register will have its values reset
+	 * (on my ar9220 to value 0x01002310)
+	 */
+	ath9k_spectral_scan_config(common, spec_priv, spec_priv->spectral_mode);
+	ath9k_hw_ops(ah)->spectral_scan_trigger(ah);
+	ath_ps_ops(common)->restore(common);
+}
+
+int ath9k_spectral_scan_config(struct ath_common *common,
+			       struct ath_spec_scan_priv *spec_priv,
+			       enum spectral_mode spectral_mode)
+{
+	struct ath_hw *ah = spec_priv->ah;
+
+	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
+		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
+		return -1;
+	}
+
+	switch (spectral_mode) {
+	case SPECTRAL_DISABLED:
+		spec_priv->spec_config.enabled = 0;
+		break;
+	case SPECTRAL_BACKGROUND:
+		/* send endless samples.
+		 * TODO: is this really useful for "background"?
+		 */
+		spec_priv->spec_config.endless = 1;
+		spec_priv->spec_config.enabled = 1;
+		break;
+	case SPECTRAL_CHANSCAN:
+	case SPECTRAL_MANUAL:
+		spec_priv->spec_config.endless = 0;
+		spec_priv->spec_config.enabled = 1;
+		break;
+	default:
+		return -1;
+	}
+
+	ath_ps_ops(common)->wakeup(common);
+	ath9k_hw_ops(ah)->spectral_scan_config(ah, &spec_priv->spec_config);
+	ath_ps_ops(common)->restore(common);
+
+	spec_priv->spectral_mode = spectral_mode;
+
+	return 0;
+}
+
 static ssize_t write_file_spec_scan_ctl(struct file *file,
 					const char __user *user_buf,
 					size_t count, loff_t *ppos)
-- 
1.9.1

