Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UPPERCASE_50_75,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C945C10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:10:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BDBB206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfDWJK4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:10:56 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:58980 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725939AbfDWJKy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 05:10:54 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIrS1-0000FN-7J; Tue, 23 Apr 2019 12:10:53 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 06/16] iwlwifi: support fseq tlv and print fseq version
Date:   Tue, 23 Apr 2019 12:10:33 +0300
Message-Id: <20190423091043.7156-7-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423091043.7156-1-luca@coelho.fi>
References: <20190423091043.7156-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Support fseq tlv and print fseq version to dmesg.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/file.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 42cbf57857af..2faec36f3d76 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -148,11 +148,15 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_UMAC_DEBUG_ADDRS	= 54,
 	IWL_UCODE_TLV_LMAC_DEBUG_ADDRS	= 55,
 	IWL_UCODE_TLV_FW_RECOVERY_INFO	= 57,
-	IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION	= IWL_UCODE_INI_TLV_GROUP | 0x1,
-	IWL_UCODE_TLV_TYPE_HCMD			= IWL_UCODE_INI_TLV_GROUP | 0x2,
-	IWL_UCODE_TLV_TYPE_REGIONS		= IWL_UCODE_INI_TLV_GROUP | 0x3,
-	IWL_UCODE_TLV_TYPE_TRIGGERS		= IWL_UCODE_INI_TLV_GROUP | 0x4,
-	IWL_UCODE_TLV_TYPE_DEBUG_FLOW		= IWL_UCODE_INI_TLV_GROUP | 0x5,
+	IWL_UCODE_TLV_FW_FSEQ_VERSION		= 60,
+
+	IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION	= IWL_UCODE_INI_TLV_GROUP + 0x1,
+	IWL_UCODE_TLV_DEBUG_BASE = IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION,
+	IWL_UCODE_TLV_TYPE_HCMD			= IWL_UCODE_INI_TLV_GROUP + 0x2,
+	IWL_UCODE_TLV_TYPE_REGIONS		= IWL_UCODE_INI_TLV_GROUP + 0x3,
+	IWL_UCODE_TLV_TYPE_TRIGGERS		= IWL_UCODE_INI_TLV_GROUP + 0x4,
+	IWL_UCODE_TLV_TYPE_DEBUG_FLOW		= IWL_UCODE_INI_TLV_GROUP + 0x5,
+	IWL_UCODE_TLV_DEBUG_MAX = IWL_UCODE_TLV_TYPE_DEBUG_FLOW,
 
 	/* TLVs 0x1000-0x2000 are for internal driver usage */
 	IWL_UCODE_TLV_FW_DBG_DUMP_LST	= 0x1000,
-- 
2.20.1

