Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 480EAC43610
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E594206B2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 11:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E594206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=coelho.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409637AbeKWWKf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Nov 2018 17:10:35 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:38268 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2394366AbeKWWKe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Nov 2018 17:10:34 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gQ9bc-0008GU-HO; Fri, 23 Nov 2018 13:26:41 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 23 Nov 2018 13:26:21 +0200
Message-Id: <20181123112631.29360-6-luca@coelho.fi>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181123112631.29360-1-luca@coelho.fi>
References: <20181123112631.29360-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/15] iwlwifi: don't define OTP_LOW_IMAGE_SIZE per family, but per size
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Using OTP_LOW_IMAGE_SIZE_FAMILY_8000/9000/22000 only obfuscates the
actual values, since these 3 are the same.  Redefine the values per
size so it's easier to understand and compare the different
configurations.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/1000.c   | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c   | 4 ++--
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c  | 4 ++--
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c   | 6 +++---
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c   | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c   | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c   | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 8 +++-----
 8 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/1000.c b/drivers/net/wireless/intel/iwlwifi/cfg/1000.c
index 76b5ddb20248..b67e08dfbe29 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/1000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/1000.c
@@ -48,7 +48,7 @@
 static const struct iwl_base_params iwl1000_base_params = {
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.max_tfd_queue_size = 256,
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	/* .eeprom_size = OTP_LOW_IMAGE_SIZE_2K, */
 	.pll_cfg = true,
 	.max_ll_items = OTP_MAX_LL_ITEMS_1000,
 	.shadow_ram_support = false,
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/2000.c b/drivers/net/wireless/intel/iwlwifi/cfg/2000.c
index e7e45846dd07..a6ec7ad39dcb 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/2000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/2000.c
@@ -57,7 +57,7 @@
 #define IWL135_MODULE_FIRMWARE(api) IWL135_FW_PRE __stringify(api) ".ucode"
 
 static const struct iwl_base_params iwl2000_base_params = {
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE_2K,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.max_tfd_queue_size = 256,
 	.max_ll_items = OTP_MAX_LL_ITEMS_2x00,
@@ -71,7 +71,7 @@ static const struct iwl_base_params iwl2000_base_params = {
 
 
 static const struct iwl_base_params iwl2030_base_params = {
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE_2K,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.max_tfd_queue_size = 256,
 	.max_ll_items = OTP_MAX_LL_ITEMS_2x00,
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 8b2339165bca..2d395a4a5375 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -109,7 +109,7 @@
 #define NVM_HW_SECTION_NUM_FAMILY_22000		10
 
 static const struct iwl_base_params iwl_22000_base_params = {
-	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_22000,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE_32K,
 	.num_of_queues = 512,
 	.max_tfd_queue_size = 256,
 	.shadow_ram_support = true,
@@ -121,7 +121,7 @@ static const struct iwl_base_params iwl_22000_base_params = {
 };
 
 static const struct iwl_base_params iwl_22560_base_params = {
-	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_22000,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE_32K,
 	.num_of_queues = 512,
 	.max_tfd_queue_size = 65536,
 	.shadow_ram_support = true,
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/6000.c b/drivers/net/wireless/intel/iwlwifi/cfg/6000.c
index 30e62a7c9d52..fbb18d066cd0 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/6000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/6000.c
@@ -66,7 +66,7 @@
 #define IWL6030_MODULE_FIRMWARE(api) IWL6030_FW_PRE __stringify(api) ".ucode"
 
 static const struct iwl_base_params iwl6000_base_params = {
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE_2K,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.max_tfd_queue_size = 256,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
@@ -79,7 +79,7 @@ static const struct iwl_base_params iwl6000_base_params = {
 };
 
 static const struct iwl_base_params iwl6050_base_params = {
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE_2K,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.max_tfd_queue_size = 256,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x50,
@@ -92,7 +92,7 @@ static const struct iwl_base_params iwl6050_base_params = {
 };
 
 static const struct iwl_base_params iwl6000_g2_base_params = {
-	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE_2K,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.max_tfd_queue_size = 256,
 	.max_ll_items = OTP_MAX_LL_ITEMS_6x00,
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/7000.c b/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
index c973bfaa3414..38d5db50b1ed 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/7000.c
@@ -116,7 +116,7 @@
 #define NVM_HW_SECTION_NUM_FAMILY_7000		0
 
 static const struct iwl_base_params iwl7000_base_params = {
-	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_7000,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE_16K,
 	.num_of_queues = 31,
 	.max_tfd_queue_size = 256,
 	.shadow_ram_support = true,
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
index 348c40fcddcb..dd2785e65f80 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
@@ -97,7 +97,7 @@
 #define DEFAULT_NVM_FILE_FAMILY_8000C		"nvmData-8000C"
 
 static const struct iwl_base_params iwl8000_base_params = {
-	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_8000,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE_32K,
 	.num_of_queues = 31,
 	.max_tfd_queue_size = 256,
 	.shadow_ram_support = true,
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index baaaf2a5dc7b..1bc12f8b716d 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -93,7 +93,7 @@
 #define NVM_HW_SECTION_NUM_FAMILY_9000		10
 
 static const struct iwl_base_params iwl9000_base_params = {
-	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_9000,
+	.eeprom_size = OTP_LOW_IMAGE_SIZE_32K,
 	.num_of_queues = 31,
 	.max_tfd_queue_size = 256,
 	.shadow_ram_support = true,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 5eb906a0d0d2..91861a9cbe57 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -265,11 +265,9 @@ struct iwl_tt_params {
 #define EEPROM_REGULATORY_BAND_NO_HT40		0
 
 /* lower blocks contain EEPROM image and calibration data */
-#define OTP_LOW_IMAGE_SIZE		(2 * 512 * sizeof(u16)) /* 2 KB */
-#define OTP_LOW_IMAGE_SIZE_FAMILY_7000	(16 * 512 * sizeof(u16)) /* 16 KB */
-#define OTP_LOW_IMAGE_SIZE_FAMILY_8000	(32 * 512 * sizeof(u16)) /* 32 KB */
-#define OTP_LOW_IMAGE_SIZE_FAMILY_9000	OTP_LOW_IMAGE_SIZE_FAMILY_8000
-#define OTP_LOW_IMAGE_SIZE_FAMILY_22000	OTP_LOW_IMAGE_SIZE_FAMILY_9000
+#define OTP_LOW_IMAGE_SIZE_2K		(2 * 512 * sizeof(u16))  /*  2 KB */
+#define OTP_LOW_IMAGE_SIZE_16K		(16 * 512 * sizeof(u16)) /* 16 KB */
+#define OTP_LOW_IMAGE_SIZE_32K		(32 * 512 * sizeof(u16)) /* 32 KB */
 
 struct iwl_eeprom_params {
 	const u8 regulatory_bands[7];
-- 
2.19.1

