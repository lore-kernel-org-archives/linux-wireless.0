Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbbAVUet (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:49 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 35/38] iwlwifi: mvm: use a new API for enabling STBC
Date: Thu, 22 Jan 2015 22:33:26 +0200
Message-Id: <1421958809-3371-35-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214446_324995_911B1ED2)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The new API tells the FW that it's allowed to use STBC
but the FW will decide on its own whether to use STBC
or SISO (and in the future Beamformer).
Keep support for the old API which sets STBC explicitly
in the rates in the LQ table while we still support old
FW revisions.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h   |  2 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h | 15 +++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/rs.c        | 14 +++++++++++++-
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index b998aaf..e4f5898 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -249,6 +249,7 @@ enum iwl_ucode_tlv_flag {
  *	through the dedicated host command.
  * @IWL_UCODE_TLV_API_SINGLE_SCAN_EBS: EBS is supported for single scans too.
  * @IWL_UCODE_TLV_API_ASYNC_DTM: Async temperature notifications are supported.
+ * @IWL_UCODE_TLV_API_LQ_SS_PARAMS: Configure STBC/BFER via LQ CMD ss_params
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
@@ -261,6 +262,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_SCD_CFG		= BIT(15),
 	IWL_UCODE_TLV_API_SINGLE_SCAN_EBS	= BIT(16),
 	IWL_UCODE_TLV_API_ASYNC_DTM		= BIT(17),
+	IWL_UCODE_TLV_API_LQ_SS_PARAMS		= BIT(18),
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
index 8bb5b94..6a2a6b0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-rs.h
@@ -308,6 +308,17 @@ enum {
 #define LQ_FLAG_DYNAMIC_BW_POS          6
 #define LQ_FLAG_DYNAMIC_BW_MSK          (1 << LQ_FLAG_DYNAMIC_BW_POS)
 
+/* Single Stream Parameters
+ * SS_STBC/BFER_ALLOWED - Controls whether STBC or Beamformer (BFER) is allowed
+ * ucode will make a smart decision between SISO/STBC/BFER
+ * SS_PARAMS_VALID - if not set ignore the ss_params field.
+ */
+enum {
+	RS_SS_STBC_ALLOWED = BIT(0),
+	RS_SS_BFER_ALLOWED = BIT(1),
+	RS_SS_PARAMS_VALID = BIT(31),
+};
+
 /**
  * struct iwl_lq_cmd - link quality command
  * @sta_id: station to update
@@ -330,7 +341,7 @@ enum {
  *	2 - 0x3f: maximal number of frames (up to 3f == 63)
  * @rs_table: array of rates for each TX try, each is rate_n_flags,
  *	meaning it is a combination of RATE_MCS_* and IWL_RATE_*_PLCP
- * @bf_params: beam forming params, currently not used
+ * @ss_params: single stream features. declare whether STBC or BFER are allowed.
  */
 struct iwl_lq_cmd {
 	u8 sta_id;
@@ -348,6 +359,6 @@ struct iwl_lq_cmd {
 	u8 agg_frame_cnt_limit;
 	__le32 reserved2;
 	__le32 rs_table[LQ_MAX_RETRY_NUM];
-	__le32 bf_params;
+	__le32 ss_params;
 }; /* LINK_QUALITY_CMD_API_S_VER_1 */
 #endif /* __fw_api_rs_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 554b3a5..f30eff2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2868,11 +2868,23 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 	u8 valid_tx_ant = 0;
 	struct iwl_lq_cmd *lq_cmd = &lq_sta->lq;
 	bool toggle_ant = false;
+	bool stbc_allowed = false;
 
 	memcpy(&rate, initial_rate, sizeof(rate));
 
 	valid_tx_ant = iwl_mvm_get_valid_tx_ant(mvm);
-	rate.stbc = rs_stbc_allow(mvm, sta, lq_sta);
+
+	stbc_allowed = rs_stbc_allow(mvm, sta, lq_sta);
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_LQ_SS_PARAMS) {
+		u32 ss_params = RS_SS_PARAMS_VALID;
+
+		if (stbc_allowed)
+			ss_params |= RS_SS_STBC_ALLOWED;
+		lq_cmd->ss_params = cpu_to_le32(ss_params);
+	} else {
+		/* TODO: remove old API when min FW API hits 14 */
+		rate.stbc = stbc_allowed;
+	}
 
 	if (is_siso(&rate)) {
 		num_rates = IWL_MVM_RS_INITIAL_SISO_NUM_RATES;
-- 
1.9.1

