Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:41661 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaBCU7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:02 -0500
Received: by mail-ee0-f44.google.com with SMTP id c13so3883507eek.31
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:01 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/62] iwlwifi: rs: use const u16 for throughput tables
Date: Mon,  3 Feb 2014 22:57:34 +0200
Message-Id: <1391461088-8082-28-git-send-email-egrumbach@gmail.com> (sfid-20140203_220010_211987_7D9E7F95)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This makes the code a little bit longer as zero-extension
has to be done (mov vs. movzwl), but that's miniscule and
the space saving is significant, about 600 bytes in DVM
and 700 bytes in MVM, so the cache effect should be worth
the few bytes more code.

While at it, remove two spurious blank lines in variable
declaration blocks.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig  |   27 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/dvm/rs.c |   19 +++++++++----------
 drivers/net/wireless/iwlwifi/dvm/rs.h |    2 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c |   23 +++++++++++------------
 drivers/net/wireless/iwlwifi/mvm/rs.h |    2 +-
 5 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 7fc9881..74b3b4d 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -68,6 +68,19 @@ config IWLWIFI_OPMODE_MODULAR
 comment "WARNING: iwlwifi is useless without IWLDVM or IWLMVM"
 	depends on IWLWIFI && IWLDVM=n && IWLMVM=n
 
+config IWLWIFI_BCAST_FILTERING
+	bool "Enable broadcast filtering"
+	depends on IWLMVM
+	help
+	  Say Y here to enable default bcast filtering configuration.
+
+	  Enabling broadcast filtering will drop any incoming wireless
+	  broadcast frames, except some very specific predefined
+	  patterns (e.g. incoming arp requests).
+
+	  If unsure, don't enable this option, as some programs might
+	  expect incoming broadcasts for their normal operations.
+
 menu "Debugging Options"
 	depends on IWLWIFI
 
@@ -111,6 +124,7 @@ config IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
 	  Enable use of experimental ucode for testing and debugging.
 
 config IWLWIFI_DEVICE_TRACING
+
 	bool "iwlwifi device access tracing"
 	depends on IWLWIFI
 	depends on EVENT_TRACING
@@ -128,16 +142,3 @@ config IWLWIFI_DEVICE_TRACING
 	  If unsure, say Y so we can help you better when problems
 	  occur.
 endmenu
-
-config IWLWIFI_BCAST_FILTERING
-	bool "Enable broadcast filtering"
-	depends on IWLWIFI
-	help
-	  Say Y here to enable default bcast filtering configuration.
-
-	  Enabling broadcast filtering will drop any incoming wireless
-	  broadcast frames, except some very specific predefined
-	  patterns (e.g. incoming arp requests).
-
-	  If unsure, don't enable this option, as some programs might
-	  expect incoming broadcasts for their normal operations.
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index 0977d93..5e232b9 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -176,46 +176,46 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
  * (2.4 GHz) band.
  */
 
-static s32 expected_tpt_legacy[IWL_RATE_COUNT] = {
+static const u16 expected_tpt_legacy[IWL_RATE_COUNT] = {
 	7, 13, 35, 58, 40, 57, 72, 98, 121, 154, 177, 186, 0
 };
 
-static s32 expected_tpt_siso20MHz[4][IWL_RATE_COUNT] = {
+static const u16 expected_tpt_siso20MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0, 42, 0,  76, 102, 124, 159, 183, 193, 202}, /* Norm */
 	{0, 0, 0, 0, 46, 0,  82, 110, 132, 168, 192, 202, 210}, /* SGI */
 	{0, 0, 0, 0, 47, 0,  91, 133, 171, 242, 305, 334, 362}, /* AGG */
 	{0, 0, 0, 0, 52, 0, 101, 145, 187, 264, 330, 361, 390}, /* AGG+SGI */
 };
 
-static s32 expected_tpt_siso40MHz[4][IWL_RATE_COUNT] = {
+static const u16 expected_tpt_siso40MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0,  77, 0, 127, 160, 184, 220, 242, 250, 257}, /* Norm */
 	{0, 0, 0, 0,  83, 0, 135, 169, 193, 229, 250, 257, 264}, /* SGI */
 	{0, 0, 0, 0,  94, 0, 177, 249, 313, 423, 512, 550, 586}, /* AGG */
 	{0, 0, 0, 0, 104, 0, 193, 270, 338, 454, 545, 584, 620}, /* AGG+SGI */
 };
 
-static s32 expected_tpt_mimo2_20MHz[4][IWL_RATE_COUNT] = {
+static const u16 expected_tpt_mimo2_20MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0,  74, 0, 123, 155, 179, 214, 236, 244, 251}, /* Norm */
 	{0, 0, 0, 0,  81, 0, 131, 164, 188, 223, 243, 251, 257}, /* SGI */
 	{0, 0, 0, 0,  89, 0, 167, 235, 296, 402, 488, 526, 560}, /* AGG */
 	{0, 0, 0, 0,  97, 0, 182, 255, 320, 431, 520, 558, 593}, /* AGG+SGI*/
 };
 
-static s32 expected_tpt_mimo2_40MHz[4][IWL_RATE_COUNT] = {
+static const u16 expected_tpt_mimo2_40MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0, 123, 0, 182, 214, 235, 264, 279, 285, 289}, /* Norm */
 	{0, 0, 0, 0, 131, 0, 191, 222, 242, 270, 284, 289, 293}, /* SGI */
 	{0, 0, 0, 0, 171, 0, 305, 410, 496, 634, 731, 771, 805}, /* AGG */
 	{0, 0, 0, 0, 186, 0, 329, 439, 527, 667, 764, 803, 838}, /* AGG+SGI */
 };
 
-static s32 expected_tpt_mimo3_20MHz[4][IWL_RATE_COUNT] = {
+static const u16 expected_tpt_mimo3_20MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0,  99, 0, 153, 186, 208, 239, 256, 263, 268}, /* Norm */
 	{0, 0, 0, 0, 106, 0, 162, 194, 215, 246, 262, 268, 273}, /* SGI */
 	{0, 0, 0, 0, 134, 0, 249, 346, 431, 574, 685, 732, 775}, /* AGG */
 	{0, 0, 0, 0, 148, 0, 272, 376, 465, 614, 727, 775, 818}, /* AGG+SGI */
 };
 
-static s32 expected_tpt_mimo3_40MHz[4][IWL_RATE_COUNT] = {
+static const u16 expected_tpt_mimo3_40MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0, 152, 0, 211, 239, 255, 279,  290,  294,  297}, /* Norm */
 	{0, 0, 0, 0, 160, 0, 219, 245, 261, 284,  294,  297,  300}, /* SGI */
 	{0, 0, 0, 0, 254, 0, 443, 584, 695, 868,  984, 1030, 1070}, /* AGG */
@@ -1111,7 +1111,7 @@ static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 				      struct iwl_scale_tbl_info *tbl)
 {
 	/* Used to choose among HT tables */
-	s32 (*ht_tbl_pointer)[IWL_RATE_COUNT];
+	const u16 (*ht_tbl_pointer)[IWL_RATE_COUNT];
 
 	/* Check for invalid LQ type */
 	if (WARN_ON_ONCE(!is_legacy(tbl->lq_type) && !is_Ht(tbl->lq_type))) {
@@ -1173,9 +1173,8 @@ static s32 rs_get_best_rate(struct iwl_priv *priv,
 	    &(lq_sta->lq_info[lq_sta->active_tbl]);
 	s32 active_sr = active_tbl->win[index].success_ratio;
 	s32 active_tpt = active_tbl->expected_tpt[index];
-
 	/* expected "search" throughput */
-	s32 *tpt_tbl = tbl->expected_tpt;
+	const u16 *tpt_tbl = tbl->expected_tpt;
 
 	s32 new_rate, high, low, start_hi;
 	u16 high_low;
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.h b/drivers/net/wireless/iwlwifi/dvm/rs.h
index bdd5644..f6bd25c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.h
@@ -315,7 +315,7 @@ struct iwl_scale_tbl_info {
 	u8 is_dup;	/* 1 = duplicated data streams */
 	u8 action;	/* change modulation; IWL_[LEGACY/SISO/MIMO]_SWITCH_* */
 	u8 max_search;	/* maximun number of tables we can search */
-	s32 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
+	const u16 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
 	u32 current_rate;  /* rate_n_flags, uCode API format */
 	struct iwl_rate_scale_data win[IWL_RATE_COUNT]; /* rate histories */
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 6abf74e..9ec8eca 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -380,49 +380,49 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search);
  * (2.4 GHz) band.
  */
 
-static s32 expected_tpt_legacy[IWL_RATE_COUNT] = {
+static const u16 expected_tpt_legacy[IWL_RATE_COUNT] = {
 	7, 13, 35, 58, 40, 57, 72, 98, 121, 154, 177, 186, 0, 0, 0
 };
 
 /* Expected TpT tables. 4 indexes:
  * 0 - NGI, 1 - SGI, 2 - AGG+NGI, 3 - AGG+SGI
  */
-static s32 expected_tpt_siso_20MHz[4][IWL_RATE_COUNT] = {
+static const u16 expected_tpt_siso_20MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0, 42, 0,  76, 102, 124, 159, 183, 193, 202, 216, 0},
 	{0, 0, 0, 0, 46, 0,  82, 110, 132, 168, 192, 202, 210, 225, 0},
 	{0, 0, 0, 0, 49, 0,  97, 145, 192, 285, 375, 420, 464, 551, 0},
 	{0, 0, 0, 0, 54, 0, 108, 160, 213, 315, 415, 465, 513, 608, 0},
 };
 
-static s32 expected_tpt_siso_40MHz[4][IWL_RATE_COUNT] = {
+static const u16 expected_tpt_siso_40MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0,  77, 0, 127, 160, 184, 220, 242, 250,  257,  269,  275},
 	{0, 0, 0, 0,  83, 0, 135, 169, 193, 229, 250, 257,  264,  275,  280},
 	{0, 0, 0, 0, 101, 0, 199, 295, 389, 570, 744, 828,  911, 1070, 1173},
 	{0, 0, 0, 0, 112, 0, 220, 326, 429, 629, 819, 912, 1000, 1173, 1284},
 };
 
-static s32 expected_tpt_siso_80MHz[4][IWL_RATE_COUNT] = {
+static const u16 expected_tpt_siso_80MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0, 130, 0, 191, 223, 244,  273,  288,  294,  298,  305,  308},
 	{0, 0, 0, 0, 138, 0, 200, 231, 251,  279,  293,  298,  302,  308,  312},
 	{0, 0, 0, 0, 217, 0, 429, 634, 834, 1220, 1585, 1760, 1931, 2258, 2466},
 	{0, 0, 0, 0, 241, 0, 475, 701, 921, 1343, 1741, 1931, 2117, 2468, 2691},
 };
 
-static s32 expected_tpt_mimo2_20MHz[4][IWL_RATE_COUNT] = {
+static const u16 expected_tpt_mimo2_20MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0,  74, 0, 123, 155, 179, 213, 235, 243, 250,  261, 0},
 	{0, 0, 0, 0,  81, 0, 131, 164, 187, 221, 242, 250, 256,  267, 0},
 	{0, 0, 0, 0,  98, 0, 193, 286, 375, 550, 718, 799, 878, 1032, 0},
 	{0, 0, 0, 0, 109, 0, 214, 316, 414, 607, 790, 879, 965, 1132, 0},
 };
 
-static s32 expected_tpt_mimo2_40MHz[4][IWL_RATE_COUNT] = {
+static const u16 expected_tpt_mimo2_40MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0, 123, 0, 182, 214, 235,  264,  279,  285,  289,  296,  300},
 	{0, 0, 0, 0, 131, 0, 191, 222, 242,  270,  284,  289,  293,  300,  303},
 	{0, 0, 0, 0, 200, 0, 390, 571, 741, 1067, 1365, 1505, 1640, 1894, 2053},
 	{0, 0, 0, 0, 221, 0, 430, 630, 816, 1169, 1490, 1641, 1784, 2053, 2221},
 };
 
-static s32 expected_tpt_mimo2_80MHz[4][IWL_RATE_COUNT] = {
+static const u16 expected_tpt_mimo2_80MHz[4][IWL_RATE_COUNT] = {
 	{0, 0, 0, 0, 182, 0, 240,  264,  278,  299,  308,  311,  313,  317,  319},
 	{0, 0, 0, 0, 190, 0, 247,  269,  282,  302,  310,  313,  315,  319,  320},
 	{0, 0, 0, 0, 428, 0, 833, 1215, 1577, 2254, 2863, 3147, 3418, 3913, 4219},
@@ -1169,12 +1169,12 @@ static void rs_set_stay_in_table(struct iwl_mvm *mvm, u8 is_legacy,
 	lq_sta->visited_columns = 0;
 }
 
-static s32 *rs_get_expected_tpt_table(struct iwl_lq_sta *lq_sta,
+static const u16 *rs_get_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 				      const struct rs_tx_column *column,
 				      u32 bw)
 {
 	/* Used to choose among HT tables */
-	s32 (*ht_tbl_pointer)[IWL_RATE_COUNT];
+	const u16 (*ht_tbl_pointer)[IWL_RATE_COUNT];
 
 	if (WARN_ON_ONCE(column->mode != RS_LEGACY &&
 			 column->mode != RS_SISO &&
@@ -1262,9 +1262,8 @@ static s32 rs_get_best_rate(struct iwl_mvm *mvm,
 	    &(lq_sta->lq_info[lq_sta->active_tbl]);
 	s32 active_sr = active_tbl->win[index].success_ratio;
 	s32 active_tpt = active_tbl->expected_tpt[index];
-
 	/* expected "search" throughput */
-	s32 *tpt_tbl = tbl->expected_tpt;
+	const u16 *tpt_tbl = tbl->expected_tpt;
 
 	s32 new_rate, high, low, start_hi;
 	u16 high_low;
@@ -1479,7 +1478,7 @@ static enum rs_column rs_get_next_column(struct iwl_mvm *mvm,
 	const struct rs_tx_column *next_col;
 	allow_column_func_t allow_func;
 	u8 valid_ants = iwl_fw_valid_tx_ant(mvm->fw);
-	s32 *expected_tpt_tbl;
+	const u16 *expected_tpt_tbl;
 	s32 tpt, max_expected_tpt;
 
 	for (i = 0; i < MAX_NEXT_COLUMNS; i++) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.h b/drivers/net/wireless/iwlwifi/mvm/rs.h
index 7bc6404..3332b39 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.h
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.h
@@ -277,7 +277,7 @@ enum rs_column {
 struct iwl_scale_tbl_info {
 	struct rs_rate rate;
 	enum rs_column column;
-	s32 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
+	const u16 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
 	struct iwl_rate_scale_data win[IWL_RATE_COUNT]; /* rate histories */
 };
 
-- 
1.7.9.5

