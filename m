Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF719C282C0
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97A262146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfA0KUT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:20:19 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51446 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726839AbfA0KUT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:20:19 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhXN-0001vC-RU; Sun, 27 Jan 2019 12:19:38 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:19:07 +0200
Message-Id: <20190127101908.6428-21-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 20/21] iwlwifi: dbg_ini: set dump mask BIT(n) instead of n
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

The driver sets dump_mask value instead of BIT(value).
fix it by updating dump_mask correctly.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: 7a14c23dcdee ("iwlwifi: dbg: dump data according to the new ini TLVs")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 02ad87022e78..22efd94da6d3 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1216,13 +1216,13 @@ static void iwl_fw_ini_dump_trigger(struct iwl_fw_runtime *fwrt,
 			iwl_dump_prph_ini(fwrt->trans, data, reg);
 			break;
 		case IWL_FW_INI_REGION_DRAM_BUFFER:
-			*dump_mask |= IWL_FW_ERROR_DUMP_FW_MONITOR;
+			*dump_mask |= BIT(IWL_FW_ERROR_DUMP_FW_MONITOR);
 			break;
 		case IWL_FW_INI_REGION_PAGING:
 			if (iwl_fw_dbg_is_paging_enabled(fwrt))
 				iwl_dump_paging(fwrt, data);
 			else
-				*dump_mask |= IWL_FW_ERROR_DUMP_PAGING;
+				*dump_mask |= BIT(IWL_FW_ERROR_DUMP_PAGING);
 			break;
 		case IWL_FW_INI_REGION_TXF:
 			iwl_fw_dump_txf(fwrt, data);
-- 
2.20.1

