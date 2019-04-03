Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4659C4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF19620830
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 09:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbfDCJWi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 05:22:38 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:49724 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726427AbfDCJWh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 05:22:37 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hBc6N-0007aR-1t; Wed, 03 Apr 2019 12:22:35 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed,  3 Apr 2019 12:22:16 +0300
Message-Id: <20190403092224.815-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190403092224.815-1-luca@coelho.fi>
References: <20190403092224.815-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 05/13] iwlwifi: add FW_INFO debug level
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Add FW_INFO debug level. This level is enabled if INFO or FW debug
levels are set.
Also, set fw request and callback prints under this debug level.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h | 2 ++
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c   | 8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-debug.h b/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
index 655ff5694560..d3ba6a1422ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-debug.h
@@ -218,5 +218,7 @@ do {                                            			\
 #define IWL_DEBUG_TPT(p, f, a...)	IWL_DEBUG(p, IWL_DL_TPT, f, ## a)
 #define IWL_DEBUG_RPM(p, f, a...)	IWL_DEBUG(p, IWL_DL_RPM, f, ## a)
 #define IWL_DEBUG_LAR(p, f, a...)	IWL_DEBUG(p, IWL_DL_LAR, f, ## a)
+#define IWL_DEBUG_FW_INFO(p, f, a...)		\
+		IWL_DEBUG(p, IWL_DL_INFO | IWL_DL_FW, f, ## a)
 
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 689a65b11cc3..1ad739bace0f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -252,8 +252,8 @@ static int iwl_request_firmware(struct iwl_drv *drv, bool first)
 	snprintf(drv->firmware_name, sizeof(drv->firmware_name), "%s%s.ucode",
 		 cfg->fw_name_pre, tag);
 
-	IWL_DEBUG_INFO(drv, "attempting to load firmware '%s'\n",
-		       drv->firmware_name);
+	IWL_DEBUG_FW_INFO(drv, "attempting to load firmware '%s'\n",
+			  drv->firmware_name);
 
 	return request_firmware_nowait(THIS_MODULE, 1, drv->firmware_name,
 				       drv->trans->dev,
@@ -1318,8 +1318,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 	if (!ucode_raw)
 		goto try_again;
 
-	IWL_DEBUG_INFO(drv, "Loaded firmware file '%s' (%zd bytes).\n",
-		       drv->firmware_name, ucode_raw->size);
+	IWL_DEBUG_FW_INFO(drv, "Loaded firmware file '%s' (%zd bytes).\n",
+			  drv->firmware_name, ucode_raw->size);
 
 	/* Make sure that we got at least the API version number */
 	if (ucode_raw->size < 4) {
-- 
2.20.1

