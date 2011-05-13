Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508Ab1EMTiq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:38:46 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/13] iwlagn: remove set but unused vars
Date: Fri, 13 May 2011 12:13:28 -0700
Message-Id: <1305314010-18073-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110513_213858_877720_D6CBF61B)
In-Reply-To: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

gcc is warning that a few variables in rate
scaling are set but never otherwise used.
This pointed out a few simplifications.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   28 ++++++++++------------------
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |    7 +++----
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 432f839..c38ba7c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2199,11 +2199,11 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
  * setup rate table in uCode
  * return rate_n_flags as used in the table
  */
-static u32 rs_update_rate_tbl(struct iwl_priv *priv,
-			      struct iwl_rxon_context *ctx,
-				struct iwl_lq_sta *lq_sta,
-				struct iwl_scale_tbl_info *tbl,
-				int index, u8 is_green)
+static void rs_update_rate_tbl(struct iwl_priv *priv,
+			       struct iwl_rxon_context *ctx,
+			       struct iwl_lq_sta *lq_sta,
+			       struct iwl_scale_tbl_info *tbl,
+			       int index, u8 is_green)
 {
 	u32 rate;
 
@@ -2211,8 +2211,6 @@ static u32 rs_update_rate_tbl(struct iwl_priv *priv,
 	rate = rate_n_flags_from_tbl(priv, tbl, index, is_green);
 	rs_fill_link_cmd(priv, lq_sta, rate);
 	iwl_send_lq_cmd(priv, ctx, &lq_sta->lq, CMD_ASYNC, false);
-
-	return rate;
 }
 
 /*
@@ -2241,7 +2239,6 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	u8 update_lq = 0;
 	struct iwl_scale_tbl_info *tbl, *tbl1;
 	u16 rate_scale_index_msk = 0;
-	u32 rate;
 	u8 is_green = 0;
 	u8 active_tbl = 0;
 	u8 done_search = 0;
@@ -2328,8 +2325,8 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 			tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 			/* get "active" rate info */
 			index = iwl_hwrate_to_plcp_idx(tbl->current_rate);
-			rate = rs_update_rate_tbl(priv, ctx, lq_sta,
-						  tbl, index, is_green);
+			rs_update_rate_tbl(priv, ctx, lq_sta, tbl,
+					   index, is_green);
 		}
 		return;
 	}
@@ -2570,8 +2567,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 lq_update:
 	/* Replace uCode's rate table for the destination station. */
 	if (update_lq)
-		rate = rs_update_rate_tbl(priv, ctx, lq_sta,
-					  tbl, index, is_green);
+		rs_update_rate_tbl(priv, ctx, lq_sta, tbl, index, is_green);
 
 	if (iwl_tx_ant_restriction(priv) == IWL_ANT_OK_MULTI) {
 		/* Should we stay with this modulation mode,
@@ -3270,14 +3266,10 @@ static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 static ssize_t rs_sta_dbgfs_rate_scale_data_read(struct file *file,
 			char __user *user_buf, size_t count, loff_t *ppos)
 {
-	char buff[120];
-	int desc = 0;
-
 	struct iwl_lq_sta *lq_sta = file->private_data;
-	struct iwl_priv *priv;
 	struct iwl_scale_tbl_info *tbl = &lq_sta->lq_info[lq_sta->active_tbl];
-
-	priv = lq_sta->drv;
+	char buff[120];
+	int desc = 0;
 
 	if (is_Ht(tbl->lq_type))
 		desc += sprintf(buff+desc,
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
index c839796..47a56bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -216,15 +216,14 @@ static int iwl_eeprom_verify_signature(struct iwl_priv *priv)
 
 static void iwl_set_otp_access(struct iwl_priv *priv, enum iwl_access_mode mode)
 {
-	u32 otpgp;
+	iwl_read32(priv, CSR_OTP_GP_REG);
 
-	otpgp = iwl_read32(priv, CSR_OTP_GP_REG);
 	if (mode == IWL_OTP_ACCESS_ABSOLUTE)
 		iwl_clear_bit(priv, CSR_OTP_GP_REG,
-				CSR_OTP_GP_REG_OTP_ACCESS_MODE);
+			      CSR_OTP_GP_REG_OTP_ACCESS_MODE);
 	else
 		iwl_set_bit(priv, CSR_OTP_GP_REG,
-				CSR_OTP_GP_REG_OTP_ACCESS_MODE);
+			    CSR_OTP_GP_REG_OTP_ACCESS_MODE);
 }
 
 static int iwlcore_get_nvm_type(struct iwl_priv *priv, u32 hw_rev)
-- 
1.7.0.4

