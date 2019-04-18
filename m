Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BDB4C282DD
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 12:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A5E12183F
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 12:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388912AbfDRMPx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 08:15:53 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53916 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388864AbfDRMPw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 08:15:52 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hH5xG-0007X3-K2; Thu, 18 Apr 2019 15:15:51 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 18 Apr 2019 15:15:42 +0300
Message-Id: <20190418121544.32040-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190418121544.32040-1-luca@coelho.fi>
References: <20190418121544.32040-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 2/4] iwlwifi: dbg_ini: check debug TLV type explicitly
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

In ini debug TLVs bit 24 is set. The driver relies on it in the memory
allocation for the debug configuration. This implementation is
problematic in case of a new debug TLV that is not supported yet is added
and uses bit 24. In such a scenario the driver allocate space without
using it which causes errors in the apply point enabling flow.

Solve it by explicitly checking if a given TLV is part of the list of
the supported ini debug TLVs.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: f14cda6f3b31 ("iwlwifi: trans: parse and store debug ini TLVs")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/file.h     | 15 +++++++++------
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c |  3 ++-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/file.h b/drivers/net/wireless/intel/iwlwifi/fw/file.h
index 641c95d03b15..e06407dc088b 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/file.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/file.h
@@ -93,7 +93,7 @@ struct iwl_ucode_header {
 	} u;
 };
 
-#define IWL_UCODE_INI_TLV_GROUP	BIT(24)
+#define IWL_UCODE_INI_TLV_GROUP	0x1000000
 
 /*
  * new TLV uCode file layout
@@ -148,11 +148,14 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_UMAC_DEBUG_ADDRS	= 54,
 	IWL_UCODE_TLV_LMAC_DEBUG_ADDRS	= 55,
 	IWL_UCODE_TLV_FW_RECOVERY_INFO	= 57,
-	IWL_UCODE_TLV_TYPE_BUFFER_ALLOCATION	= IWL_UCODE_INI_TLV_GROUP | 0x1,
-	IWL_UCODE_TLV_TYPE_HCMD			= IWL_UCODE_INI_TLV_GROUP | 0x2,
-	IWL_UCODE_TLV_TYPE_REGIONS		= IWL_UCODE_INI_TLV_GROUP | 0x3,
-	IWL_UCODE_TLV_TYPE_TRIGGERS		= IWL_UCODE_INI_TLV_GROUP | 0x4,
-	IWL_UCODE_TLV_TYPE_DEBUG_FLOW		= IWL_UCODE_INI_TLV_GROUP | 0x5,
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
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 5798f434f68f..c7070760a10a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -126,7 +126,8 @@ void iwl_alloc_dbg_tlv(struct iwl_trans *trans, size_t len, const u8 *data,
 		len -= ALIGN(tlv_len, 4);
 		data += sizeof(*tlv) + ALIGN(tlv_len, 4);
 
-		if (!(tlv_type & IWL_UCODE_INI_TLV_GROUP))
+		if (tlv_type < IWL_UCODE_TLV_DEBUG_BASE ||
+		    tlv_type > IWL_UCODE_TLV_DEBUG_MAX)
 			continue;
 
 		hdr = (void *)&tlv->data[0];
-- 
2.20.1

