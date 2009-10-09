Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28629 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbZJIUWY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:22:24 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/17] iwlwifi: additional items in sensitivity range table
Date: Fri,  9 Oct 2009 13:20:24 -0700
Message-Id: <1255119634-3060-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add more items to sensitivity range table to avoid using hardcoded values.
Initialize the table per device since unique per device information is
required to perform sensitivity calibration.

additional items in sensitivity range table:
   .barker_corr_th_min: Barker correlation threshold minimum
   .barker_corr_th_min_mrc: Barker correlation threshold minimum for MRC
   .nrg_th_cca: Energy threshold for Clear Channel Assessment

Barker codes are a technique used in WLAN encoding for transmission.
MRC is "Maximal Ratio Combining", a technique for optimally combining the
signals from 2 or more receivers to achieve a better signal.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    8 ++++++++
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    4 ++++
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    9 ++++++---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    6 ------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    8 ++++++++
 6 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 782a361..9668585 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -678,6 +678,10 @@ static struct iwl_sensitivity_ranges iwl4965_sensitivity = {
 
 	.nrg_th_cck = 100,
 	.nrg_th_ofdm = 100,
+
+	.barker_corr_th_min = 190,
+	.barker_corr_th_min_mrc = 390,
+	.nrg_th_cca = 62,
 };
 
 static void iwl4965_set_ct_threshold(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 33b38aa..a9d1aa3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -329,6 +329,10 @@ static struct iwl_sensitivity_ranges iwl5000_sensitivity = {
 	.auto_corr_max_cck_mrc = 400,
 	.nrg_th_cck = 95,
 	.nrg_th_ofdm = 95,
+
+	.barker_corr_th_min = 190,
+	.barker_corr_th_min_mrc = 390,
+	.nrg_th_cca = 62,
 };
 
 static struct iwl_sensitivity_ranges iwl5150_sensitivity = {
@@ -351,6 +355,10 @@ static struct iwl_sensitivity_ranges iwl5150_sensitivity = {
 	.auto_corr_max_cck_mrc = 400,
 	.nrg_th_cck = 95,
 	.nrg_th_ofdm = 95,
+
+	.barker_corr_th_min = 190,
+	.barker_corr_th_min_mrc = 390,
+	.nrg_th_cca = 62,
 };
 
 const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 46af74b..dda1dd6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -121,6 +121,10 @@ static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
 	.auto_corr_max_cck_mrc = 310,
 	.nrg_th_cck = 97,
 	.nrg_th_ofdm = 100,
+
+	.barker_corr_th_min = 190,
+	.barker_corr_th_min_mrc = 390,
+	.nrg_th_cca = 62,
 };
 
 static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 69a80d7..1f801eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -447,11 +447,11 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 				cpu_to_le16((u16)data->nrg_th_ofdm);
 
 	cmd.table[HD_BARKER_CORR_TH_ADD_MIN_INDEX] =
-				cpu_to_le16(190);
+				cpu_to_le16(data->barker_corr_th_min);
 	cmd.table[HD_BARKER_CORR_TH_ADD_MIN_MRC_INDEX] =
-				cpu_to_le16(390);
+				cpu_to_le16(data->barker_corr_th_min_mrc);
 	cmd.table[HD_OFDM_ENERGY_TH_IN_INDEX] =
-				cpu_to_le16(62);
+				cpu_to_le16(data->nrg_th_cca);
 
 	IWL_DEBUG_CALIB(priv, "ofdm: ac %u mrc %u x1 %u mrc_x1 %u thresh %u\n",
 			data->auto_corr_ofdm, data->auto_corr_ofdm_mrc,
@@ -524,6 +524,9 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 	data->auto_corr_cck_mrc = ranges->auto_corr_min_cck_mrc;
 	data->nrg_th_cck = ranges->nrg_th_cck;
 	data->nrg_th_ofdm = ranges->nrg_th_ofdm;
+	data->barker_corr_th_min = ranges->barker_corr_th_min;
+	data->barker_corr_th_min_mrc = ranges->barker_corr_th_min_mrc;
+	data->nrg_th_cca = ranges->nrg_th_cca;
 
 	data->last_bad_plcp_cnt_ofdm = 0;
 	data->last_fa_cnt_ofdm = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index ba3e4c8..2e8a55e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3247,12 +3247,6 @@ struct iwl_missed_beacon_notif {
  *   Lower values mean higher energy; this means making sure that the value
  *   in HD_MIN_ENERGY_CCK_DET_INDEX is at or *above* "Max cck energy".
  *
- * Driver should set the following entries to fixed values:
- *
- *   HD_MIN_ENERGY_OFDM_DET_INDEX               100
- *   HD_BARKER_CORR_TH_ADD_MIN_INDEX            190
- *   HD_BARKER_CORR_TH_ADD_MIN_MRC_INDEX        390
- *   HD_OFDM_ENERGY_TH_IN_INDEX                  62
  */
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 394402a..c1b07e2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -629,6 +629,10 @@ struct iwl_sensitivity_ranges {
 	u16 auto_corr_max_cck_mrc;
 	u16 auto_corr_min_cck;
 	u16 auto_corr_min_cck_mrc;
+
+	u16 barker_corr_th_min;
+	u16 barker_corr_th_min_mrc;
+	u16 nrg_th_cca;
 };
 
 
@@ -850,6 +854,10 @@ struct iwl_sensitivity_data {
 	s32 nrg_auto_corr_silence_diff;
 	u32 num_in_cck_no_fa;
 	u32 nrg_th_ofdm;
+
+	u16 barker_corr_th_min;
+	u16 barker_corr_th_min_mrc;
+	u16 nrg_th_cca;
 };
 
 /* Chain noise (differential Rx gain) calib data */
-- 
1.5.6.3

