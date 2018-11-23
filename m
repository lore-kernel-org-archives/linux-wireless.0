Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0B6C04EBA
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8E80206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8E80206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394365AbeKWWKc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:10:32 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38234 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388238AbeKWWKb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:10:31 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bY-0008GU-RZ; Fri, 23 Nov 2018 13:26:37 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:17 +0200
Message-Id: <20181123112631.29360-2-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 01/15] iwlwifi: move common 9000 cfg parameters to common macro
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

The ht_params, nvm_ver, nvm_calib_ver and max_ht_ampdu_exponent
elements in 9000 devices are always the same.  Move them to the common
macro.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c | 79 ++-----------------
 1 file changed, 6 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index d55fd23cafe6..baaaf2a5dc7b 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -157,17 +157,18 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.min_umac_error_event_table = 0x800000,				\
 	.csr = &iwl_csr_v1,						\
 	.d3_debug_data_base_addr = 0x401000,				\
-	.d3_debug_data_length = 92 * 1024
+	.d3_debug_data_length = 92 * 1024,				\
+	.ht_params = &iwl9000_ht_params,				\
+	.nvm_ver = IWL9000_NVM_VERSION,					\
+	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,			\
+	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
+
 
 const struct iwl_cfg iwl9160_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 9160",
 	.fw_name_pre = IWL9260A_FW_PRE,
 	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
 const struct iwl_cfg iwl9260_2ac_cfg = {
@@ -175,10 +176,6 @@ const struct iwl_cfg iwl9260_2ac_cfg = {
 	.fw_name_pre = IWL9260A_FW_PRE,
 	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
 const struct iwl_cfg iwl9260_killer_2ac_cfg = {
@@ -186,10 +183,6 @@ const struct iwl_cfg iwl9260_killer_2ac_cfg = {
 	.fw_name_pre = IWL9260A_FW_PRE,
 	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
 const struct iwl_cfg iwl9270_2ac_cfg = {
@@ -197,10 +190,6 @@ const struct iwl_cfg iwl9270_2ac_cfg = {
 	.fw_name_pre = IWL9260A_FW_PRE,
 	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
 const struct iwl_cfg iwl9460_2ac_cfg = {
@@ -208,10 +197,6 @@ const struct iwl_cfg iwl9460_2ac_cfg = {
 	.fw_name_pre = IWL9260A_FW_PRE,
 	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
 const struct iwl_cfg iwl9460_2ac_cfg_soc = {
@@ -220,10 +205,6 @@ const struct iwl_cfg iwl9460_2ac_cfg_soc = {
 	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
 	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 	.integrated = true,
 	.soc_latency = 5000,
 };
@@ -234,10 +215,6 @@ const struct iwl_cfg iwl9461_2ac_cfg_soc = {
 		.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
 		.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
 		IWL_DEVICE_9000,
-		.ht_params = &iwl9000_ht_params,
-		.nvm_ver = IWL9000_NVM_VERSION,
-		.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 		.integrated = true,
 		.soc_latency = 5000,
 };
@@ -248,10 +225,6 @@ const struct iwl_cfg iwl9462_2ac_cfg_soc = {
 		.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
 		.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
 		IWL_DEVICE_9000,
-		.ht_params = &iwl9000_ht_params,
-		.nvm_ver = IWL9000_NVM_VERSION,
-		.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 		.integrated = true,
 		.soc_latency = 5000,
 };
@@ -261,10 +234,6 @@ const struct iwl_cfg iwl9560_2ac_cfg = {
 	.fw_name_pre = IWL9260A_FW_PRE,
 	.fw_name_pre_b_or_c_step = IWL9260B_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
 const struct iwl_cfg iwl9560_2ac_cfg_soc = {
@@ -273,10 +242,6 @@ const struct iwl_cfg iwl9560_2ac_cfg_soc = {
 	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
 	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 	.integrated = true,
 	.soc_latency = 5000,
 };
@@ -287,10 +252,6 @@ const struct iwl_cfg iwl9560_killer_2ac_cfg_soc = {
 	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
 	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 	.integrated = true,
 	.soc_latency = 5000,
 };
@@ -301,10 +262,6 @@ const struct iwl_cfg iwl9560_killer_s_2ac_cfg_soc = {
 	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
 	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 	.integrated = true,
 	.soc_latency = 5000,
 };
@@ -315,10 +272,6 @@ const struct iwl_cfg iwl9460_2ac_cfg_shared_clk = {
 	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
 	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 	.integrated = true,
 	.soc_latency = 5000,
 	.extra_phy_cfg_flags = FW_PHY_CFG_SHARED_CLK
@@ -330,10 +283,6 @@ const struct iwl_cfg iwl9461_2ac_cfg_shared_clk = {
 	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
 	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 	.integrated = true,
 	.soc_latency = 5000,
 	.extra_phy_cfg_flags = FW_PHY_CFG_SHARED_CLK
@@ -345,10 +294,6 @@ const struct iwl_cfg iwl9462_2ac_cfg_shared_clk = {
 	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
 	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 	.integrated = true,
 	.soc_latency = 5000,
 	.extra_phy_cfg_flags = FW_PHY_CFG_SHARED_CLK
@@ -360,10 +305,6 @@ const struct iwl_cfg iwl9560_2ac_cfg_shared_clk = {
 	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
 	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 	.integrated = true,
 	.soc_latency = 5000,
 	.extra_phy_cfg_flags = FW_PHY_CFG_SHARED_CLK
@@ -375,10 +316,6 @@ const struct iwl_cfg iwl9560_killer_2ac_cfg_shared_clk = {
 	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
 	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 	.integrated = true,
 	.soc_latency = 5000,
 	.extra_phy_cfg_flags = FW_PHY_CFG_SHARED_CLK
@@ -390,10 +327,6 @@ const struct iwl_cfg iwl9560_killer_s_2ac_cfg_shared_clk = {
 	.fw_name_pre_b_or_c_step = IWL9000B_FW_PRE,
 	.fw_name_pre_rf_next_step = IWL9000RFB_FW_PRE,
 	IWL_DEVICE_9000,
-	.ht_params = &iwl9000_ht_params,
-	.nvm_ver = IWL9000_NVM_VERSION,
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,
-	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 	.integrated = true,
 	.soc_latency = 5000,
 	.extra_phy_cfg_flags = FW_PHY_CFG_SHARED_CLK
-- 
2.19.1

