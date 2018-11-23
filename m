Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8C8C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00748206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 00748206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409640AbeKWWKf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:10:35 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38278 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2409635AbeKWWKf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:10:35 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bd-0008GU-EM; Fri, 23 Nov 2018 13:26:41 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:22 +0200
Message-Id: <20181123112631.29360-7-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/15] iwlwifi: remove useless NVM_HW_SECTION_NUM_FAMILY_* macros
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

These macros are useless because each one of them is used only once
and the element they are assigned to is already pretty clear about
what they mean, "nvm_hw_section_num".

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 4 +---
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c  | 4 +---
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c  | 3 +--
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c  | 4 +---
 4 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 2d395a4a5375..157ff1f76ba6 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -106,8 +106,6 @@
 #define IWL_QU_B_JF_B_MODULE_FIRMWARE(api) \
 	IWL_QU_B_JF_B_FW_PRE __stringify(api) ".ucode"
 
-#define NVM_HW_SECTION_NUM_FAMILY_22000		10
-
 static const struct iwl_base_params iwl_22000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_32K,
 	.num_of_queues = 512,
@@ -142,7 +140,7 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.ucode_api_max = IWL_22000_UCODE_API_MAX,			\
 	.ucode_api_min = IWL_22000_UCODE_API_MIN,			\
 	.led_mode = IWL_LED_RF_STATE,					\
-	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_22000,		\
+	.nvm_hw_section_num = 10,					\
 	.non_shared_ant = ANT_B,					\
 	.dccm_offset = IWL_22000_DCCM_OFFSET,				\
 	.dccm_len = IWL_22000_DCCM_LEN,					\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/7000.c b/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
index 38d5db50b1ed..5b4efa8ddffb 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
@@ -113,8 +113,6 @@
 #define IWL7265D_FW_PRE "iwlwifi-7265D-"
 #define IWL7265D_MODULE_FIRMWARE(api) IWL7265D_FW_PRE __stringify(api) ".ucode"
 
-#define NVM_HW_SECTION_NUM_FAMILY_7000		0
-
 static const struct iwl_base_params iwl7000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_16K,
 	.num_of_queues = 31,
@@ -159,7 +157,7 @@ static const struct iwl_ht_params iwl7000_ht_params = {
 	.device_family = IWL_DEVICE_FAMILY_7000,		\
 	.base_params = &iwl7000_base_params,			\
 	.led_mode = IWL_LED_RF_STATE,				\
-	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_7000,	\
+	.nvm_hw_section_num = 0,				\
 	.non_shared_ant = ANT_A,				\
 	.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,	\
 	.dccm_offset = IWL7000_DCCM_OFFSET,			\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
index dd2785e65f80..5b1da5206336 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
@@ -93,7 +93,6 @@
 #define IWL8265_MODULE_FIRMWARE(api) \
 	IWL8265_FW_PRE __stringify(api) ".ucode"
 
-#define NVM_HW_SECTION_NUM_FAMILY_8000		10
 #define DEFAULT_NVM_FILE_FAMILY_8000C		"nvmData-8000C"
 
 static const struct iwl_base_params iwl8000_base_params = {
@@ -139,7 +138,7 @@ static const struct iwl_tt_params iwl8000_tt_params = {
 	.device_family = IWL_DEVICE_FAMILY_8000,			\
 	.base_params = &iwl8000_base_params,				\
 	.led_mode = IWL_LED_RF_STATE,					\
-	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_8000,		\
+	.nvm_hw_section_num = 10,					\
 	.features = NETIF_F_RXCSUM,					\
 	.non_shared_ant = ANT_A,					\
 	.dccm_offset = IWL8260_DCCM_OFFSET,				\
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index 1bc12f8b716d..b589b0e9d515 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -90,8 +90,6 @@
 #define IWL9260B_MODULE_FIRMWARE(api) \
 	IWL9260B_FW_PRE __stringify(api) ".ucode"
 
-#define NVM_HW_SECTION_NUM_FAMILY_9000		10
-
 static const struct iwl_base_params iwl9000_base_params = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE_32K,
 	.num_of_queues = 31,
@@ -137,7 +135,7 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.device_family = IWL_DEVICE_FAMILY_9000,			\
 	.base_params = &iwl9000_base_params,				\
 	.led_mode = IWL_LED_RF_STATE,					\
-	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_9000,		\
+	.nvm_hw_section_num = 10,					\
 	.non_shared_ant = ANT_B,					\
 	.dccm_offset = IWL9000_DCCM_OFFSET,				\
 	.dccm_len = IWL9000_DCCM_LEN,					\
-- 
2.19.1

