Return-Path: <SRS0=ssZ+=5L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04080C2D0E5
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Mar 2020 12:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DABF320748
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Mar 2020 12:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgCZMzY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 26 Mar 2020 08:55:24 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44210 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728194AbgCZMzX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Mar 2020 08:55:23 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <luca@coelho.fi>)
        id 1jHS2b-00040Z-GL; Thu, 26 Mar 2020 14:55:22 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 26 Mar 2020 14:55:02 +0200
Message-Id: <iwlwifi.20200326145047.4631c3c945b6.I0dfd88232bdc8ff2dd9c4368b8ed9a0c40c86bc8@changeid>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200326125510.621842-1-luca@coelho.fi>
References: <20200326125510.621842-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 04/12] iwlwifi: remove support for QnJ Hr STEP A
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

We don't support QnJ HR STEP A anymore.  Remove the structures we used
for it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c  | 17 -----------------
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |  1 -
 2 files changed, 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 7b67c1ebbedf..cafc322f01a4 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -79,7 +79,6 @@
 #define IWL_22000_HR_A_F0_FW_PRE	"iwlwifi-QuQnj-f0-hr-a0-"
 #define IWL_22000_QU_B_HR_B_FW_PRE	"iwlwifi-Qu-b0-hr-b0-"
 #define IWL_22000_HR_B_FW_PRE		"iwlwifi-QuQnj-b0-hr-b0-"
-#define IWL_22000_HR_A0_FW_PRE		"iwlwifi-QuQnj-a0-hr-a0-"
 #define IWL_QU_C_HR_B_FW_PRE		"iwlwifi-Qu-c0-hr-b0-"
 #define IWL_QU_B_JF_B_FW_PRE		"iwlwifi-Qu-b0-jf-b0-"
 #define IWL_QU_C_JF_B_FW_PRE		"iwlwifi-Qu-c0-jf-b0-"
@@ -104,8 +103,6 @@
 	IWL_22000_QU_B_HR_B_FW_PRE __stringify(api) ".ucode"
 #define IWL_22000_HR_B_QNJ_MODULE_FIRMWARE(api)	\
 	IWL_22000_HR_B_FW_PRE __stringify(api) ".ucode"
-#define IWL_22000_HR_A0_QNJ_MODULE_FIRMWARE(api) \
-	IWL_22000_HR_A0_FW_PRE __stringify(api) ".ucode"
 #define IWL_QUZ_A_HR_B_MODULE_FIRMWARE(api) \
 	IWL_QUZ_A_HR_B_FW_PRE __stringify(api) ".ucode"
 #define IWL_QUZ_A_JF_B_MODULE_FIRMWARE(api) \
@@ -531,19 +528,6 @@ const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_b0 = {
 	.num_rbds = IWL_NUM_RBDS_22000_HE,
 };
 
-const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0 = {
-	.name = "Intel(R) Dual Band Wireless AX 22000",
-	.fw_name_pre = IWL_22000_HR_A0_FW_PRE,
-	IWL_DEVICE_22500,
-	/*
-	 * This device doesn't support receiving BlockAck with a large bitmap
-	 * so we need to restrict the size of transmitted aggregation to the
-	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
-	 */
-	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
-	.num_rbds = IWL_NUM_RBDS_22000_HE,
-};
-
 const struct iwl_cfg iwlax210_2ax_cfg_so_jf_a0 = {
 	.name = "Intel(R) Wireless-AC 9560 160MHz",
 	.fw_name_pre = IWL_22000_SO_A_JF_B_FW_PRE,
@@ -594,7 +578,6 @@ MODULE_FIRMWARE(IWL_22000_HR_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_JF_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_B_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL_22000_HR_A0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QU_C_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QU_B_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QUZ_A_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index ec715ee17156..9a10bd593d95 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -620,7 +620,6 @@ extern const struct iwl_cfg killer1650w_2ax_cfg;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0_f0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_b0_f0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_b0;
-extern const struct iwl_cfg iwl22000_2ax_cfg_qnj_hr_a0;
 extern const struct iwl_cfg iwlax210_2ax_cfg_so_jf_a0;
 extern const struct iwl_cfg iwlax210_2ax_cfg_so_hr_a0;
 extern const struct iwl_cfg iwlax211_2ax_cfg_so_gf_a0;
-- 
2.25.1

