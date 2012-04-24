Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8196 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758590Ab2DXXva (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 19:51:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/11] iwlwifi: add option to disable 5GHz band
Date: Tue, 24 Apr 2012 16:46:03 -0700
Message-Id: <1335311164-10252-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120425_015156_263977_0F4EEE13)
In-Reply-To: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>

There are various problems happened on 5GHz band not observed on
2.4 GHz (microcode errors, queue stuck, etc... ) . Also roaming
between 5GHz AP and 2GHz does not work very well. To workaround
the problems add option to disable 5GHz support. This will help
on environments where APs are dual-band, and devices will not try
to associate on band where issues happen.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    3 +++
 drivers/net/wireless/iwlwifi/iwl-drv.c       |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-modparams.h |    2 ++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8f60f28..2023dd1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1310,6 +1310,9 @@ static int iwl_init_geos(struct iwl_priv *priv)
 		priv->hw_params.sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
 	}
 
+	if (iwlwifi_mod_params.disable_5ghz)
+		priv->bands[IEEE80211_BAND_5GHZ].n_channels = 0;
+
 	IWL_INFO(priv, "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
 		   priv->bands[IEEE80211_BAND_2GHZ].n_channels,
 		   priv->bands[IEEE80211_BAND_5GHZ].n_channels);
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 430cca5..3c72bad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1012,3 +1012,7 @@ module_param_named(auto_agg, iwlwifi_mod_params.auto_agg,
 		bool, S_IRUGO);
 MODULE_PARM_DESC(auto_agg,
 		 "enable agg w/o check traffic load (default: enable)");
+
+module_param_named(5ghz_disable, iwlwifi_mod_params.disable_5ghz,
+		bool, S_IRUGO);
+MODULE_PARM_DESC(5ghz_disable, "disable 5GHz band (default: 0 [enabled])");
diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index 558b2e6..ca15d9a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -103,6 +103,7 @@ enum iwl_power_level {
  * @ant_coupling: antenna coupling in dB, default = 0
  * @bt_ch_announce: BT channel inhibition, default = enable
  * @auto_agg: enable agg. without check, default = true
+ * @disable_5ghz: disable 5GHz capability, default = false
  */
 struct iwl_mod_params {
 	int sw_crypto;
@@ -119,6 +120,7 @@ struct iwl_mod_params {
 	int ant_coupling;
 	bool bt_ch_announce;
 	bool auto_agg;
+	bool disable_5ghz;
 };
 
 #endif /* #__iwl_shared_h__ */
-- 
1.7.0.4

