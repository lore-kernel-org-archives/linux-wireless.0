Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab2DSKL0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 06:11:26 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlwifi: add option to disable 5GHz band
Date: Thu, 19 Apr 2012 12:11:20 +0200
Message-Id: <1334830280-3019-1-git-send-email-sgruszka@redhat.com> (sfid-20120419_121129_785566_02E3A2DA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are various problems happened on 5GHz band not observed on
2.4 GHz (microcode errors, queue stuck, etc... ) . Also roaming
between 5GHz AP and 2GHz does not work very well. To workaround
the problems add option to disable 5GHz support. This will help
on environments where APs are dual-band, and devices will not try
to associate on band where issues happen.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 ++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7db3986..d254640 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1329,6 +1329,9 @@ static int iwl_init_geos(struct iwl_priv *priv)
 		priv->hw_params.sku &= ~EEPROM_SKU_CAP_BAND_52GHZ;
 	}
 
+	if (iwlagn_mod_params.disable_5ghz)
+		priv->bands[IEEE80211_BAND_5GHZ].n_channels = 0;
+
 	IWL_INFO(priv, "Tunable channels: %d 802.11bg, %d 802.11a channels\n",
 		   priv->bands[IEEE80211_BAND_2GHZ].n_channels,
 		   priv->bands[IEEE80211_BAND_5GHZ].n_channels);
@@ -2472,3 +2475,6 @@ module_param_named(auto_agg, iwlagn_mod_params.auto_agg,
 		bool, S_IRUGO);
 MODULE_PARM_DESC(auto_agg,
 		 "enable agg w/o check traffic load (default: enable)");
+
+module_param_named(5ghz_disable, iwlagn_mod_params.disable_5ghz, bool, S_IRUGO);
+MODULE_PARM_DESC(5ghz_disable, "disable 5GHz band (default: 0 [enabled])");
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 35bd83c..53cbbd5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -129,6 +129,7 @@ extern struct iwl_mod_params iwlagn_mod_params;
  * @ant_coupling: antenna coupling in dB, default = 0
  * @bt_ch_announce: BT channel inhibition, default = enable
  * @auto_agg: enable agg. without check, default = true
+ * @disable_5ghz: disable 5GHz capability, default = false
  */
 struct iwl_mod_params {
 	int sw_crypto;
@@ -145,6 +146,7 @@ struct iwl_mod_params {
 	int ant_coupling;
 	bool bt_ch_announce;
 	bool auto_agg;
+	bool disable_5ghz;
 };
 
 /**
-- 
1.7.1

