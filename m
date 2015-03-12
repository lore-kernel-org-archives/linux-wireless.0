Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23662 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbbCLNGA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:00 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/49] iwlwifi: fix smatch warning:  warn: inconsistent indenting
Date: Thu, 12 Mar 2015 15:04:13 +0200
Message-Id: <1426165474-25586-28-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140748_087360_1A0924F5)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While at it, fix a few checkpatch issues.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/rs.c  |  7 ++++---
 drivers/net/wireless/iwlwifi/dvm/tx.c  |  6 +++---
 drivers/net/wireless/iwlwifi/iwl-drv.c | 18 +++++++++---------
 drivers/net/wireless/iwlwifi/mvm/rs.c  | 18 +++++++++---------
 4 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index 32b78a6..3bd7c86 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -3153,12 +3153,13 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 	desc += sprintf(buff+desc, "lq type %s\n",
 	   (is_legacy(tbl->lq_type)) ? "legacy" : "HT");
 	if (is_Ht(tbl->lq_type)) {
-		desc += sprintf(buff+desc, " %s",
+		desc += sprintf(buff + desc, " %s",
 		   (is_siso(tbl->lq_type)) ? "SISO" :
 		   ((is_mimo2(tbl->lq_type)) ? "MIMO2" : "MIMO3"));
-		   desc += sprintf(buff+desc, " %s",
+		desc += sprintf(buff + desc, " %s",
 		   (tbl->is_ht40) ? "40MHz" : "20MHz");
-		   desc += sprintf(buff+desc, " %s %s %s\n", (tbl->is_SGI) ? "SGI" : "",
+		desc += sprintf(buff + desc, " %s %s %s\n",
+		   (tbl->is_SGI) ? "SGI" : "",
 		   (lq_sta->is_green) ? "GF enabled" : "",
 		   (lq_sta->is_agg) ? "AGG on" : "");
 	}
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 1e40a12..275df12 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -189,9 +189,9 @@ static void iwlagn_tx_cmd_build_rate(struct iwl_priv *priv,
 		rate_flags |= RATE_MCS_CCK_MSK;
 
 	/* Set up antennas */
-	 if (priv->lib->bt_params &&
-	     priv->lib->bt_params->advanced_bt_coexist &&
-	     priv->bt_full_concurrent) {
+	if (priv->lib->bt_params &&
+	    priv->lib->bt_params->advanced_bt_coexist &&
+	    priv->bt_full_concurrent) {
 		/* operated as 1x1 in full concurrency mode */
 		priv->mgmt_tx_ant = iwl_toggle_tx_ant(priv, priv->mgmt_tx_ant,
 				first_antenna(priv->nvm_data->valid_tx_ant));
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index f1d73d5..66ca000 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1014,34 +1014,34 @@ static int validate_sec_sizes(struct iwl_drv *drv,
 
 	/* Verify that uCode images will fit in card's SRAM. */
 	if (get_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_INST) >
-							cfg->max_inst_size) {
+	    cfg->max_inst_size) {
 		IWL_ERR(drv, "uCode instr len %Zd too large to fit in\n",
 			get_sec_size(pieces, IWL_UCODE_REGULAR,
-						IWL_UCODE_SECTION_INST));
+				     IWL_UCODE_SECTION_INST));
 		return -1;
 	}
 
 	if (get_sec_size(pieces, IWL_UCODE_REGULAR, IWL_UCODE_SECTION_DATA) >
-							cfg->max_data_size) {
+	    cfg->max_data_size) {
 		IWL_ERR(drv, "uCode data len %Zd too large to fit in\n",
 			get_sec_size(pieces, IWL_UCODE_REGULAR,
-						IWL_UCODE_SECTION_DATA));
+				     IWL_UCODE_SECTION_DATA));
 		return -1;
 	}
 
-	 if (get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST) >
-							cfg->max_inst_size) {
+	if (get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_INST) >
+	     cfg->max_inst_size) {
 		IWL_ERR(drv, "uCode init instr len %Zd too large to fit in\n",
 			get_sec_size(pieces, IWL_UCODE_INIT,
-						IWL_UCODE_SECTION_INST));
+				     IWL_UCODE_SECTION_INST));
 		return -1;
 	}
 
 	if (get_sec_size(pieces, IWL_UCODE_INIT, IWL_UCODE_SECTION_DATA) >
-							cfg->max_data_size) {
+	    cfg->max_data_size) {
 		IWL_ERR(drv, "uCode init data len %Zd too large to fit in\n",
 			get_sec_size(pieces, IWL_UCODE_REGULAR,
-						IWL_UCODE_SECTION_DATA));
+				     IWL_UCODE_SECTION_DATA));
 		return -1;
 	}
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 6578498..d8dacb3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -3343,16 +3343,16 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 			(is_legacy(rate)) ? "legacy" :
 			is_vht(rate) ? "VHT" : "HT");
 	if (!is_legacy(rate)) {
-		desc += sprintf(buff+desc, " %s",
+		desc += sprintf(buff + desc, " %s",
 		   (is_siso(rate)) ? "SISO" : "MIMO2");
-		   desc += sprintf(buff+desc, " %s",
-				   (is_ht20(rate)) ? "20MHz" :
-				   (is_ht40(rate)) ? "40MHz" :
-				   (is_ht80(rate)) ? "80Mhz" : "BAD BW");
-		   desc += sprintf(buff+desc, " %s %s %s\n",
-				   (rate->sgi) ? "SGI" : "NGI",
-				   (rate->ldpc) ? "LDPC" : "BCC",
-				   (lq_sta->is_agg) ? "AGG on" : "");
+		desc += sprintf(buff + desc, " %s",
+				(is_ht20(rate)) ? "20MHz" :
+				(is_ht40(rate)) ? "40MHz" :
+				(is_ht80(rate)) ? "80Mhz" : "BAD BW");
+		desc += sprintf(buff + desc, " %s %s %s\n",
+				(rate->sgi) ? "SGI" : "NGI",
+				(rate->ldpc) ? "LDPC" : "BCC",
+				(lq_sta->is_agg) ? "AGG on" : "");
 	}
 	desc += sprintf(buff+desc, "last tx rate=0x%X\n",
 			lq_sta->last_rate_n_flags);
-- 
1.9.1

