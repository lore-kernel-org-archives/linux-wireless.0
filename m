Return-Path: <SRS0=rkzg=W3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233BAC3A5A1
	for <linux-wireless@archiver.kernel.org>; Sat, 31 Aug 2019 09:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED99922CF7
	for <linux-wireless@archiver.kernel.org>; Sat, 31 Aug 2019 09:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfHaJtM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 31 Aug 2019 05:49:12 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:39664 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726685AbfHaJtL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 31 Aug 2019 05:49:11 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1i400L-0002OQ-VJ; Sat, 31 Aug 2019 12:49:10 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sat, 31 Aug 2019 12:48:47 +0300
Message-Id: <20190831094859.6391-8-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190831094859.6391-1-luca@coelho.fi>
References: <20190831094859.6391-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 07/19] iwlwifi: remove duplicate FW string definitions
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

The string we define as IWL_22000_HR_B_F0_FW_PRE is duplicate with
IWL_22000_QU_B_HR_B_FW_PRE.  Remove the former to avoid confusion.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index cd230b9b896b..af52a26bcaca 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -76,7 +76,6 @@
 #define IWL_22000_HR_FW_PRE		"iwlwifi-Qu-a0-hr-a0-"
 #define IWL_22000_HR_CDB_FW_PRE		"iwlwifi-QuIcp-z0-hrcdb-a0-"
 #define IWL_22000_HR_A_F0_FW_PRE	"iwlwifi-QuQnj-f0-hr-a0-"
-#define IWL_22000_HR_B_F0_FW_PRE	"iwlwifi-Qu-b0-hr-b0-"
 #define IWL_22000_QU_B_HR_B_FW_PRE	"iwlwifi-Qu-b0-hr-b0-"
 #define IWL_22000_HR_B_FW_PRE		"iwlwifi-QuQnj-b0-hr-b0-"
 #define IWL_22000_HR_A0_FW_PRE		"iwlwifi-QuQnj-a0-hr-a0-"
@@ -99,8 +98,6 @@
 	IWL_22000_JF_FW_PRE __stringify(api) ".ucode"
 #define IWL_22000_HR_A_F0_QNJ_MODULE_FIRMWARE(api) \
 	IWL_22000_HR_A_F0_FW_PRE __stringify(api) ".ucode"
-#define IWL_22000_HR_B_F0_QNJ_MODULE_FIRMWARE(api) \
-	IWL_22000_HR_B_F0_FW_PRE __stringify(api) ".ucode"
 #define IWL_22000_QU_B_HR_B_MODULE_FIRMWARE(api) \
 	IWL_22000_QU_B_HR_B_FW_PRE __stringify(api) ".ucode"
 #define IWL_22000_HR_B_QNJ_MODULE_FIRMWARE(api)	\
@@ -639,7 +636,6 @@ const struct iwl_cfg iwlax411_2ax_cfg_so_gf4_a0 = {
 MODULE_FIRMWARE(IWL_22000_HR_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_JF_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
-MODULE_FIRMWARE(IWL_22000_HR_B_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_B_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QU_C_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
-- 
2.23.0.rc1

