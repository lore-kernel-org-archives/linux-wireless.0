Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D184C43610
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6280206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6280206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503783AbeKWWKh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:10:37 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38294 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2409635AbeKWWKh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:10:37 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bf-0008GU-0T; Fri, 23 Nov 2018 13:26:43 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:24 +0200
Message-Id: <20181123112631.29360-9-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 08/15] iwlwifi: remove all unnecessary occurrences of nvm_calib_ver
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Now that nvm_calib_ver is not checked in opmodes other than dvm, we
can remove it from all irrelevant configurations.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    |  2 --
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c | 21 -------------------
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c |  6 ------
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c |  2 --
 4 files changed, 31 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 157ff1f76ba6..a03d0b5617af 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -63,7 +63,6 @@
 
 /* NVM versions */
 #define IWL_22000_NVM_VERSION		0x0a1d
-#define IWL_22000_TX_POWER_VERSION	0xffff /* meaningless */
 
 /* Memory offsets and lengths */
 #define IWL_22000_DCCM_OFFSET		0x800000 /* LMAC1 */
@@ -155,7 +154,6 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.mac_addr_from_csr = true,					\
 	.ht_params = &iwl_22000_ht_params,				\
 	.nvm_ver = IWL_22000_NVM_VERSION,				\
-	.nvm_calib_ver = IWL_22000_TX_POWER_VERSION,			\
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,		\
 	.use_tfh = true,						\
 	.rf_id = true,							\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/7000.c b/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
index 5b4efa8ddffb..289e3c398a12 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
@@ -80,17 +80,11 @@
 
 /* NVM versions */
 #define IWL7260_NVM_VERSION		0x0a1d
-#define IWL7260_TX_POWER_VERSION	0xffff /* meaningless */
 #define IWL3160_NVM_VERSION		0x709
-#define IWL3160_TX_POWER_VERSION	0xffff /* meaningless */
 #define IWL3165_NVM_VERSION		0x709
-#define IWL3165_TX_POWER_VERSION	0xffff /* meaningless */
 #define IWL3168_NVM_VERSION		0xd01
-#define IWL3168_TX_POWER_VERSION	0xffff /* meaningless */
 #define IWL7265_NVM_VERSION		0x0a1d
-#define IWL7265_TX_POWER_VERSION	0xffff /* meaningless */
 #define IWL7265D_NVM_VERSION		0x0c11
-#define IWL7265_TX_POWER_VERSION	0xffff /* meaningless */
 
 /* DCCM offsets and lengths */
 #define IWL7000_DCCM_OFFSET		0x800000
@@ -189,7 +183,6 @@ const struct iwl_cfg iwl7260_2ac_cfg = {
 	IWL_DEVICE_7000,
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL7260_NVM_VERSION,
-	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
 	.lp_xtal_workaround = true,
 	.dccm_len = IWL7260_DCCM_LEN,
@@ -201,7 +194,6 @@ const struct iwl_cfg iwl7260_2ac_cfg_high_temp = {
 	IWL_DEVICE_7000,
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL7260_NVM_VERSION,
-	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
 	.high_temp = true,
 	.host_interrupt_operation_mode = true,
 	.lp_xtal_workaround = true,
@@ -215,7 +207,6 @@ const struct iwl_cfg iwl7260_2n_cfg = {
 	IWL_DEVICE_7000,
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL7260_NVM_VERSION,
-	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
 	.lp_xtal_workaround = true,
 	.dccm_len = IWL7260_DCCM_LEN,
@@ -227,7 +218,6 @@ const struct iwl_cfg iwl7260_n_cfg = {
 	IWL_DEVICE_7000,
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL7260_NVM_VERSION,
-	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
 	.lp_xtal_workaround = true,
 	.dccm_len = IWL7260_DCCM_LEN,
@@ -239,7 +229,6 @@ const struct iwl_cfg iwl3160_2ac_cfg = {
 	IWL_DEVICE_7000,
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL3160_NVM_VERSION,
-	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
 	.dccm_len = IWL3160_DCCM_LEN,
 };
@@ -250,7 +239,6 @@ const struct iwl_cfg iwl3160_2n_cfg = {
 	IWL_DEVICE_7000,
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL3160_NVM_VERSION,
-	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
 	.dccm_len = IWL3160_DCCM_LEN,
 };
@@ -261,7 +249,6 @@ const struct iwl_cfg iwl3160_n_cfg = {
 	IWL_DEVICE_7000,
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL3160_NVM_VERSION,
-	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
 	.host_interrupt_operation_mode = true,
 	.dccm_len = IWL3160_DCCM_LEN,
 };
@@ -289,7 +276,6 @@ const struct iwl_cfg iwl3165_2ac_cfg = {
 	IWL_DEVICE_7005D,
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL3165_NVM_VERSION,
-	.nvm_calib_ver = IWL3165_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 	.dccm_len = IWL7265_DCCM_LEN,
 };
@@ -300,7 +286,6 @@ const struct iwl_cfg iwl3168_2ac_cfg = {
 	IWL_DEVICE_3008,
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL3168_NVM_VERSION,
-	.nvm_calib_ver = IWL3168_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 	.dccm_len = IWL7265_DCCM_LEN,
 	.nvm_type = IWL_NVM_SDP,
@@ -312,7 +297,6 @@ const struct iwl_cfg iwl7265_2ac_cfg = {
 	IWL_DEVICE_7005,
 	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265_NVM_VERSION,
-	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 	.dccm_len = IWL7265_DCCM_LEN,
 };
@@ -323,7 +307,6 @@ const struct iwl_cfg iwl7265_2n_cfg = {
 	IWL_DEVICE_7005,
 	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265_NVM_VERSION,
-	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 	.dccm_len = IWL7265_DCCM_LEN,
 };
@@ -334,7 +317,6 @@ const struct iwl_cfg iwl7265_n_cfg = {
 	IWL_DEVICE_7005,
 	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265_NVM_VERSION,
-	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 	.dccm_len = IWL7265_DCCM_LEN,
 };
@@ -345,7 +327,6 @@ const struct iwl_cfg iwl7265d_2ac_cfg = {
 	IWL_DEVICE_7005D,
 	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265D_NVM_VERSION,
-	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 	.dccm_len = IWL7265_DCCM_LEN,
 };
@@ -356,7 +337,6 @@ const struct iwl_cfg iwl7265d_2n_cfg = {
 	IWL_DEVICE_7005D,
 	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265D_NVM_VERSION,
-	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 	.dccm_len = IWL7265_DCCM_LEN,
 };
@@ -367,7 +347,6 @@ const struct iwl_cfg iwl7265d_n_cfg = {
 	IWL_DEVICE_7005D,
 	.ht_params = &iwl7265_ht_params,
 	.nvm_ver = IWL7265D_NVM_VERSION,
-	.nvm_calib_ver = IWL7265_TX_POWER_VERSION,
 	.pwr_tx_backoffs = iwl7265_pwr_tx_backoffs,
 	.dccm_len = IWL7265_DCCM_LEN,
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
index 5b1da5206336..d7d17c1cceea 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
@@ -75,7 +75,6 @@
 
 /* NVM versions */
 #define IWL8000_NVM_VERSION		0x0a1d
-#define IWL8000_TX_POWER_VERSION	0xffff /* meaningless */
 
 /* Memory offsets and lengths */
 #define IWL8260_DCCM_OFFSET		0x800000
@@ -176,7 +175,6 @@ const struct iwl_cfg iwl8260_2n_cfg = {
 	IWL_DEVICE_8260,
 	.ht_params = &iwl8000_ht_params,
 	.nvm_ver = IWL8000_NVM_VERSION,
-	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
 };
 
 const struct iwl_cfg iwl8260_2ac_cfg = {
@@ -185,7 +183,6 @@ const struct iwl_cfg iwl8260_2ac_cfg = {
 	IWL_DEVICE_8260,
 	.ht_params = &iwl8000_ht_params,
 	.nvm_ver = IWL8000_NVM_VERSION,
-	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
@@ -195,7 +192,6 @@ const struct iwl_cfg iwl8265_2ac_cfg = {
 	IWL_DEVICE_8265,
 	.ht_params = &iwl8000_ht_params,
 	.nvm_ver = IWL8000_NVM_VERSION,
-	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 	.vht_mu_mimo_supported = true,
 };
@@ -206,7 +202,6 @@ const struct iwl_cfg iwl8275_2ac_cfg = {
 	IWL_DEVICE_8265,
 	.ht_params = &iwl8000_ht_params,
 	.nvm_ver = IWL8000_NVM_VERSION,
-	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 	.vht_mu_mimo_supported = true,
 };
@@ -217,7 +212,6 @@ const struct iwl_cfg iwl4165_2ac_cfg = {
 	IWL_DEVICE_8000,
 	.ht_params = &iwl8000_ht_params,
 	.nvm_ver = IWL8000_NVM_VERSION,
-	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index b589b0e9d515..c73460684a0c 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -64,7 +64,6 @@
 
 /* NVM versions */
 #define IWL9000_NVM_VERSION		0x0a1d
-#define IWL9000_TX_POWER_VERSION	0xffff /* meaningless */
 
 /* Memory offsets and lengths */
 #define IWL9000_DCCM_OFFSET		0x800000
@@ -158,7 +157,6 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.d3_debug_data_length = 92 * 1024,				\
 	.ht_params = &iwl9000_ht_params,				\
 	.nvm_ver = IWL9000_NVM_VERSION,					\
-	.nvm_calib_ver = IWL9000_TX_POWER_VERSION,			\
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K
 
 
-- 
2.19.1

