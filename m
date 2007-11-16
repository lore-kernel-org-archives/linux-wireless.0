Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:61872 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757364AbXKPXHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 18:07:07 -0500
Received: by ug-out-1314.google.com with SMTP id z38so715934ugc
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2007 15:07:06 -0800 (PST)
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] iwlwifi: add power management support -v2
Date: Sat, 17 Nov 2007 00:06:49 +0100
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	yi.zhu@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200711170006.49654.mboton.lkml@gmail.com> (sfid-20071116_230713_882283_DE3DB24E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds power management support in iwl3945 and iwl4965 drivers=
=2E

Signed-off-by: Miguel Bot=C3=B3n <mboton@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/=
wireless/iwlwifi/iwl3945-base.c
index 9baf8de..5c7b422 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -6951,6 +7187,7 @@ static int iwl3945_mac_config(struct ieee80211_hw=
 *hw, struct ieee80211_conf *co
 	struct iwl3945_priv *priv =3D hw->priv;
 	const struct iwl3945_channel_info *ch_info;
 	unsigned long flags;
+	int power_mode;
=20
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel);
@@ -7001,6 +7238,23 @@ static int iwl3945_mac_config(struct ieee80211_h=
w *hw, struct ieee80211_conf *co
 	}
 #endif
=20
+	if (conf->power_management_enable)
+		power_mode =3D IWL_POWER_BATTERY | IWL_POWER_ENABLED;
+	else
+		power_mode =3D IWL_POWER_AC;
+
+	if (priv->power_mode !=3D power_mode) {
+		int rc;
+
+		rc =3D iwl3945_send_power_mode(priv, power_mode);
+		if (rc) {
+			IWL_DEBUG_MAC80211("failed setting power mode.\n");
+			mutex_unlock(&priv->mutex);
+			return -EINVAL;
+		}
+		priv->power_mode =3D power_mode;
+	}
+
 	iwl3945_radio_kill_sw(priv, !conf->radio_enabled);
=20
 	if (!conf->radio_enabled) {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/=
wireless/iwlwifi/iwl4965-base.c
index df011ea..8d303c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7352,6 +7352,7 @@ static int iwl4965_mac_config(struct ieee80211_hw=
 *hw, struct ieee80211_conf *co
 	struct iwl4965_priv *priv =3D hw->priv;
 	const struct iwl4965_channel_info *ch_info;
 	unsigned long flags;
+	int power_mode;
=20
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211("enter to channel %d\n", conf->channel);
@@ -7414,6 +7415,23 @@ static int iwl4965_mac_config(struct ieee80211_h=
w *hw, struct ieee80211_conf *co
 	}
 #endif
=20
+	if (conf->power_management_enable)
+		power_mode =3D IWL_POWER_BATTERY | IWL_POWER_ENABLED;
+	else
+		power_mode =3D IWL_POWER_AC;
+
+	if (priv->power_mode !=3D power_mode) {
+		int rc;
+
+		rc =3D iwl4965_send_power_mode(priv, power_mode);
+		if (rc) {
+			IWL_DEBUG_MAC80211("failed setting power mode.\n");
+			mutex_unlock(&priv->mutex);
+			return -EINVAL;
+		}
+		priv->power_mode =3D power_mode;
+	}
+
 	iwl4965_radio_kill_sw(priv, !conf->radio_enabled);
=20
 	if (!conf->radio_enabled) {


--=20
	Miguel Bot=C3=B3n
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
