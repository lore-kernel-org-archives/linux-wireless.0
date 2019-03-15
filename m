Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26424C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E57152077B
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 16:36:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729487AbfCOQgq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 12:36:46 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44238 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728171AbfCOQgo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 12:36:44 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4pp4-0004qp-LR; Fri, 15 Mar 2019 18:36:43 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 18:36:21 +0200
Message-Id: <20190315163634.17315-4-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190315163634.17315-1-luca@coelho.fi>
References: <20190315163634.17315-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 03/16] iwlwifi: add support for 6-7 GHz channels
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

Add UHB (ultra high band) channels and use 16 bit variables
to fit the new channels.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  2 +
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  4 +-
 .../wireless/intel/iwlwifi/iwl-nvm-parse.c    | 74 +++++++++++--------
 3 files changed, 49 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index fdc56f821b5a..dd781232c8a8 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -427,12 +427,14 @@ const struct iwl_cfg iwlax210_2ax_cfg_so_hr_a0 = {
 const struct iwl_cfg iwlax210_2ax_cfg_so_gf_a0 = {
 	.name = "Intel(R) Wi-Fi 7 AX211 160MHz",
 	.fw_name_pre = IWL_22000_SO_A_GF_A_FW_PRE,
+	.uhb_supported = true,
 	IWL_DEVICE_AX210,
 };
 
 const struct iwl_cfg iwlax210_2ax_cfg_ty_gf_a0 = {
 	.name = "Intel(R) Wi-Fi 7 AX210 160MHz",
 	.fw_name_pre = IWL_22000_TY_A_GF_A_FW_PRE,
+	.uhb_supported = true,
 	IWL_DEVICE_AX210,
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index f5f87773667b..a68481d16f1f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -383,6 +383,7 @@ struct iwl_csr_params {
  * @bisr_workaround: BISR hardware workaround (for 22260 series devices)
  * @min_txq_size: minimum number of slots required in a TX queue
  * @umac_prph_offset: offset to add to UMAC periphery address
+ * @uhb_supported: ultra high band channels supported
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -433,7 +434,8 @@ struct iwl_cfg {
 	    gen2:1,
 	    cdb:1,
 	    dbgc_supported:1,
-	    bisr_workaround:1;
+	    bisr_workaround:1,
+	    uhb_supported:1;
 	u8 valid_tx_ant;
 	u8 valid_rx_ant;
 	u8 non_shared_ant;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 87d6de7efdd2..a20ac68f4ba3 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -130,7 +130,7 @@ enum nvm_sku_bits {
 /*
  * These are the channel numbers in the order that they are stored in the NVM
  */
-static const u8 iwl_nvm_channels[] = {
+static const u16 iwl_nvm_channels[] = {
 	/* 2.4 GHz */
 	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
 	/* 5 GHz */
@@ -139,7 +139,7 @@ static const u8 iwl_nvm_channels[] = {
 	149, 153, 157, 161, 165
 };
 
-static const u8 iwl_ext_nvm_channels[] = {
+static const u16 iwl_ext_nvm_channels[] = {
 	/* 2.4 GHz */
 	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
 	/* 5 GHz */
@@ -148,14 +148,27 @@ static const u8 iwl_ext_nvm_channels[] = {
 	149, 153, 157, 161, 165, 169, 173, 177, 181
 };
 
+static const u16 iwl_uhb_nvm_channels[] = {
+	/* 2.4 GHz */
+	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14,
+	/* 5 GHz */
+	36, 40, 44, 48, 52, 56, 60, 64, 68, 72, 76, 80, 84, 88, 92,
+	96, 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140, 144,
+	149, 153, 157, 161, 165, 169, 173, 177, 181,
+	/* 6-7 GHz */
+	189, 193, 197, 201, 205, 209, 213, 217, 221, 225, 229, 233, 237, 241,
+	245, 249, 253, 257, 261, 265, 269, 273, 277, 281, 285, 289, 293, 297,
+	301, 305, 309, 313, 317, 321, 325, 329, 333, 337, 341, 345, 349, 353,
+	357, 361, 365, 369, 373, 377, 381, 385, 389, 393, 397, 401, 405, 409,
+	413, 417, 421
+};
+
 #define IWL_NVM_NUM_CHANNELS		ARRAY_SIZE(iwl_nvm_channels)
 #define IWL_NVM_NUM_CHANNELS_EXT	ARRAY_SIZE(iwl_ext_nvm_channels)
+#define IWL_NVM_NUM_CHANNELS_UHB	ARRAY_SIZE(iwl_uhb_nvm_channels)
 #define NUM_2GHZ_CHANNELS		14
-#define NUM_2GHZ_CHANNELS_EXT	14
 #define FIRST_2GHZ_HT_MINUS		5
 #define LAST_2GHZ_HT_PLUS		9
-#define LAST_5GHZ_HT			165
-#define LAST_5GHZ_HT_FAMILY_8000	181
 #define N_HW_ADDR_MASK			0xF
 
 /* rate data (static) */
@@ -247,17 +260,13 @@ static u32 iwl_get_channel_flags(u8 ch_num, int ch_idx, bool is_5ghz,
 				 u16 nvm_flags, const struct iwl_cfg *cfg)
 {
 	u32 flags = IEEE80211_CHAN_NO_HT40;
-	u32 last_5ghz_ht = LAST_5GHZ_HT;
-
-	if (cfg->nvm_type == IWL_NVM_EXT)
-		last_5ghz_ht = LAST_5GHZ_HT_FAMILY_8000;
 
 	if (!is_5ghz && (nvm_flags & NVM_CHANNEL_40MHZ)) {
 		if (ch_num <= LAST_2GHZ_HT_PLUS)
 			flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
 		if (ch_num >= FIRST_2GHZ_HT_MINUS)
 			flags &= ~IEEE80211_CHAN_NO_HT40MINUS;
-	} else if (ch_num <= last_5ghz_ht && (nvm_flags & NVM_CHANNEL_40MHZ)) {
+	} else if (nvm_flags & NVM_CHANNEL_40MHZ) {
 		if ((ch_idx - NUM_2GHZ_CHANNELS) % 2 == 0)
 			flags &= ~IEEE80211_CHAN_NO_HT40PLUS;
 		else
@@ -299,17 +308,18 @@ static int iwl_init_channel_map(struct device *dev, const struct iwl_cfg *cfg,
 	int n_channels = 0;
 	struct ieee80211_channel *channel;
 	u16 ch_flags;
-	int num_of_ch, num_2ghz_channels;
-	const u8 *nvm_chan;
+	int num_of_ch, num_2ghz_channels = NUM_2GHZ_CHANNELS;
+	const u16 *nvm_chan;
 
-	if (cfg->nvm_type != IWL_NVM_EXT) {
-		num_of_ch = IWL_NVM_NUM_CHANNELS;
-		nvm_chan = &iwl_nvm_channels[0];
-		num_2ghz_channels = NUM_2GHZ_CHANNELS;
-	} else {
+	if (cfg->uhb_supported) {
+		num_of_ch = IWL_NVM_NUM_CHANNELS_UHB;
+		nvm_chan = iwl_uhb_nvm_channels;
+	} else if (cfg->nvm_type == IWL_NVM_EXT) {
 		num_of_ch = IWL_NVM_NUM_CHANNELS_EXT;
-		nvm_chan = &iwl_ext_nvm_channels[0];
-		num_2ghz_channels = NUM_2GHZ_CHANNELS_EXT;
+		nvm_chan = iwl_ext_nvm_channels;
+	} else {
+		num_of_ch = IWL_NVM_NUM_CHANNELS;
+		nvm_chan = iwl_nvm_channels;
 	}
 
 	for (ch_idx = 0; ch_idx < num_of_ch; ch_idx++) {
@@ -1013,15 +1023,11 @@ iwl_parse_nvm_data(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 }
 IWL_EXPORT_SYMBOL(iwl_parse_nvm_data);
 
-static u32 iwl_nvm_get_regdom_bw_flags(const u8 *nvm_chan,
+static u32 iwl_nvm_get_regdom_bw_flags(const u16 *nvm_chan,
 				       int ch_idx, u16 nvm_flags,
 				       const struct iwl_cfg *cfg)
 {
 	u32 flags = NL80211_RRF_NO_HT40;
-	u32 last_5ghz_ht = LAST_5GHZ_HT;
-
-	if (cfg->nvm_type == IWL_NVM_EXT)
-		last_5ghz_ht = LAST_5GHZ_HT_FAMILY_8000;
 
 	if (ch_idx < NUM_2GHZ_CHANNELS &&
 	    (nvm_flags & NVM_CHANNEL_40MHZ)) {
@@ -1029,8 +1035,7 @@ static u32 iwl_nvm_get_regdom_bw_flags(const u8 *nvm_chan,
 			flags &= ~NL80211_RRF_NO_HT40PLUS;
 		if (nvm_chan[ch_idx] >= FIRST_2GHZ_HT_MINUS)
 			flags &= ~NL80211_RRF_NO_HT40MINUS;
-	} else if (nvm_chan[ch_idx] <= last_5ghz_ht &&
-		   (nvm_flags & NVM_CHANNEL_40MHZ)) {
+	} else if (nvm_flags & NVM_CHANNEL_40MHZ) {
 		if ((ch_idx - NUM_2GHZ_CHANNELS) % 2 == 0)
 			flags &= ~NL80211_RRF_NO_HT40PLUS;
 		else
@@ -1074,8 +1079,7 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 	int ch_idx;
 	u16 ch_flags;
 	u32 reg_rule_flags, prev_reg_rule_flags = 0;
-	const u8 *nvm_chan = cfg->nvm_type == IWL_NVM_EXT ?
-			     iwl_ext_nvm_channels : iwl_nvm_channels;
+	const u16 *nvm_chan;
 	struct ieee80211_regdomain *regd, *copy_rd;
 	int size_of_regd, regd_to_copy;
 	struct ieee80211_reg_rule *rule;
@@ -1084,8 +1088,18 @@ iwl_parse_nvm_mcc_info(struct device *dev, const struct iwl_cfg *cfg,
 	int center_freq, prev_center_freq = 0;
 	int valid_rules = 0;
 	bool new_rule;
-	int max_num_ch = cfg->nvm_type == IWL_NVM_EXT ?
-			 IWL_NVM_NUM_CHANNELS_EXT : IWL_NVM_NUM_CHANNELS;
+	int max_num_ch;
+
+	if (cfg->uhb_supported) {
+		max_num_ch = IWL_NVM_NUM_CHANNELS_UHB;
+		nvm_chan = iwl_uhb_nvm_channels;
+	} else if (cfg->nvm_type == IWL_NVM_EXT) {
+		max_num_ch = IWL_NVM_NUM_CHANNELS_EXT;
+		nvm_chan = iwl_ext_nvm_channels;
+	} else {
+		max_num_ch = IWL_NVM_NUM_CHANNELS;
+		nvm_chan = iwl_nvm_channels;
+	}
 
 	if (WARN_ON(num_of_ch > max_num_ch))
 		num_of_ch = max_num_ch;
-- 
2.20.1

