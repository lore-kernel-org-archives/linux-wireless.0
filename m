Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60790 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752846AbcGCTtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 15:49:02 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Sun,  3 Jul 2016 22:48:40 +0300
Message-Id: <1467575332-32112-1-git-send-email-luca@coelho.fi> (sfid-20160703_214916_896878_BFA99DCC)
In-Reply-To: <467405215.1837.15.camel@coelho.fi>
References: <467405215.1837.15.camel@coelho.fi>
Subject: [PATCH 01/13] iwlwifi: advertise maximal MPDU length when Rx MQ is supported
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The new hardware that supports multiple queue also
de-aggregates A-MSDUs. This means that we can advertise
the maximal size of A-MSDUs regardless of the receive
buffer's size.
In order to be able to forcefully use a lower A-MSDU size,
add a default value for the module parameter. Pre-9000
will have a default of 4K, and 9000 will have 12K.
Setting the amsdu_size module parameter to 4K will limit
the A-MSDU on 9000 as well.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/main.c         | 1 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c          | 3 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c | 4 +++-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h    | 9 +++++----
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c    | 7 +++++++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c          | 5 +++++
 6 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index 37b32a6..5915914 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -1317,6 +1317,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	trans_cfg.n_no_reclaim_cmds = ARRAY_SIZE(no_reclaim_cmds);
 
 	switch (iwlwifi_mod_params.amsdu_size) {
+	case IWL_AMSDU_DEF:
 	case IWL_AMSDU_4K:
 		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
 		break;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 60a6c36..5c5b9f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1655,7 +1655,8 @@ MODULE_PARM_DESC(11n_disable,
 	"disable 11n functionality, bitmap: 1: full, 2: disable agg TX, 4: disable agg RX, 8 enable agg TX");
 module_param_named(amsdu_size, iwlwifi_mod_params.amsdu_size,
 		   int, S_IRUGO);
-MODULE_PARM_DESC(amsdu_size, "amsdu size 0:4K 1:8K 2:12K (default 0)");
+MODULE_PARM_DESC(amsdu_size,
+		 "amsdu size 0: 12K for multi Rx queue devices, 4K for other devices 1:4K 2:8K 3:12K (default 0)");
 module_param_named(fw_restart, iwlwifi_mod_params.restart_fw, bool, S_IRUGO);
 MODULE_PARM_DESC(fw_restart, "restart firmware in case of error (default true)");
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
index bf1b69a..3199d34 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
@@ -766,7 +766,9 @@ void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
 	if (cfg->ht_params->ldpc)
 		ht_info->cap |= IEEE80211_HT_CAP_LDPC_CODING;
 
-	if (iwlwifi_mod_params.amsdu_size >= IWL_AMSDU_8K)
+	if ((cfg->mq_rx_supported &&
+	     iwlwifi_mod_params.amsdu_size != IWL_AMSDU_4K) ||
+	     iwlwifi_mod_params.amsdu_size >= IWL_AMSDU_8K)
 		ht_info->cap |= IEEE80211_HT_CAP_MAX_AMSDU;
 
 	ht_info->ampdu_factor = cfg->max_ht_ampdu_exponent;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
index 6c5c2f9..0379899 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-modparams.h
@@ -87,9 +87,10 @@ enum iwl_disable_11n {
 };
 
 enum iwl_amsdu_size {
-	IWL_AMSDU_4K = 0,
-	IWL_AMSDU_8K = 1,
-	IWL_AMSDU_12K = 2,
+	IWL_AMSDU_DEF = 0,
+	IWL_AMSDU_4K = 1,
+	IWL_AMSDU_8K = 2,
+	IWL_AMSDU_12K = 3,
 };
 
 enum iwl_uapsd_disable {
@@ -105,7 +106,7 @@ enum iwl_uapsd_disable {
  * @sw_crypto: using hardware encryption, default = 0
  * @disable_11n: disable 11n capabilities, default = 0,
  *	use IWL_[DIS,EN]ABLE_HT_* constants
- * @amsdu_size: enable 8K amsdu size, default = 4K. enum iwl_amsdu_size.
+ * @amsdu_size: See &enum iwl_amsdu_size.
  * @restart_fw: restart firmware, default = 1
  * @bt_coex_active: enable bt coex, default = true
  * @led_mode: system default, default = 0
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 21653fe..43f8f7d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -397,6 +397,13 @@ static void iwl_init_vht_hw_capab(const struct iwl_cfg *cfg,
 		vht_cap->cap |= IEEE80211_VHT_CAP_TX_ANTENNA_PATTERN;
 
 	switch (iwlwifi_mod_params.amsdu_size) {
+	case IWL_AMSDU_DEF:
+		if (cfg->mq_rx_supported)
+			vht_cap->cap |=
+				IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454;
+		else
+			vht_cap->cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895;
+		break;
 	case IWL_AMSDU_4K:
 		vht_cap->cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895;
 		break;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index a68054f..64d2b4f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -603,6 +603,7 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	trans_cfg.no_reclaim_cmds = no_reclaim_cmds;
 	trans_cfg.n_no_reclaim_cmds = ARRAY_SIZE(no_reclaim_cmds);
 	switch (iwlwifi_mod_params.amsdu_size) {
+	case IWL_AMSDU_DEF:
 	case IWL_AMSDU_4K:
 		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
 		break;
@@ -617,6 +618,10 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		       iwlwifi_mod_params.amsdu_size);
 		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
 	}
+
+	/* the hardware splits the A-MSDU */
+	if (mvm->cfg->mq_rx_supported)
+		trans_cfg.rx_buf_size = IWL_AMSDU_4K;
 	trans_cfg.wide_cmd_header = fw_has_api(&mvm->fw->ucode_capa,
 					       IWL_UCODE_TLV_API_WIDE_CMD_HDR);
 
-- 
2.8.1

