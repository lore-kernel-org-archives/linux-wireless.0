Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16165 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab1HMSSs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:48 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 26/60] iwlagn: add comments to module parameters
Date: Sat, 13 Aug 2011 10:38:02 -0700
Message-Id: <1313257116-2697-27-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_204257_847994_FC931E89)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add more comments to iwl_mod_params

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-shared.h |   56 ++++++++++++++++++++---------
 1 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 6c20d03..fd9a922 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -74,26 +74,48 @@ struct iwl_trans_ops;
 
 extern struct iwl_mod_params iwlagn_mod_params;
 
+/**
+ * struct iwl_mod_params
+ * @sw_crypto: using hardware encryption, default = 0
+ * @num_of_queues: number of tx queue, HW dependent
+ * @disable_11n: 11n capabilities enabled, default = 0
+ * @amsdu_size_8K: enable 8K amsdu size, default = 1
+ * @antenna: both antennas (use diversity), default = 0
+ * @restart_fw: restart firmware, default = 1
+ * @plcp_check: enable plcp health check, default = true
+ * @ack_check: disable ack health check, default = false
+ * @wd_disable: enable stuck queue check, default = false
+ * @bt_coex_active: enable bt coex, default = true
+ * @led_mode: system default, default = 0
+ * @no_sleep_autoadjust: disable autoadjust, default = true
+ * @power_save: disable power save, default = false
+ * @power_level: power level, default = 1
+ * @debug_level: levels are IWL_DL_*
+ * @ant_coupling: antenna coupling in dB, default = 0
+ * @bt_ch_announce: BT channel inhibition, default = enable
+ * @wanted_ucode_alternative: ucode alternative to use, default = 1
+ * @auto_agg: enable agg. without check, default = true
+ */
 struct iwl_mod_params {
-	int sw_crypto;		/* def: 0 = using hardware encryption */
-	int num_of_queues;	/* def: HW dependent */
-	int disable_11n;	/* def: 0 = 11n capabilities enabled */
-	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
-	int antenna;		/* def: 0 = both antennas (use diversity) */
-	int restart_fw;		/* def: 1 = restart firmware */
-	bool plcp_check;	/* def: true = enable plcp health check */
-	bool ack_check;		/* def: false = disable ack health check */
-	bool wd_disable;	/* def: false = enable stuck queue check */
-	bool bt_coex_active;	/* def: true = enable bt coex */
-	int led_mode;		/* def: 0 = system default */
-	bool no_sleep_autoadjust; /* def: true = disable autoadjust */
-	bool power_save;	/* def: false = disable power save */
-	int power_level;	/* def: 1 = power level */
-	u32 debug_level;	/* levels are IWL_DL_* */
+	int sw_crypto;
+	int num_of_queues;
+	int disable_11n;
+	int amsdu_size_8K;
+	int antenna;
+	int restart_fw;
+	bool plcp_check;
+	bool ack_check;
+	bool wd_disable;
+	bool bt_coex_active;
+	int led_mode;
+	bool no_sleep_autoadjust;
+	bool power_save;
+	int power_level;
+	u32 debug_level;
 	int ant_coupling;
-	bool bt_ch_announce;	/* def: enable = BT channel inhibition */
+	bool bt_ch_announce;
 	int wanted_ucode_alternative;
-	bool auto_agg;		/* def: true = enable agg. without check */
+	bool auto_agg;
 };
 
 /**
-- 
1.7.0.4

