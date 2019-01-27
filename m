Return-Path: <SRS0=DVo7=QD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DA6C282C9
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AC612146E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Jan 2019 10:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfA0KUb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:20:31 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:51470 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726590AbfA0KUb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 05:20:31 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gnhXM-0001vC-HZ; Sun, 27 Jan 2019 12:19:36 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sun, 27 Jan 2019 12:19:05 +0200
Message-Id: <20190127101908.6428-19-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190127101908.6428-1-luca@coelho.fi>
References: <20190127101908.6428-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 18/21] iwlwifi: dbg_ini: properly handle ini user trigger
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

in case of a user trigger while ini is enable we change
FW_DBG_TRIGGER_USER to IWL_FW_TRIGGER_ID_USER_TRIGGER in
iwl_fw_dbg_collect and then again we attempt to do so in
_iwl_fw_error_ini_dump which causes to abort the dump.

Fix it by removing the second check in _iwl_fw_error_ini_dump.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: 7a14c23dcdee ("iwlwifi: dbg: dump data according to the new ini TLVs")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 947f282c05a9..07dc2919b0b4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1254,10 +1254,6 @@ _iwl_fw_error_ini_dump(struct iwl_fw_runtime *fwrt,
 
 	if (id == FW_DBG_TRIGGER_FW_ASSERT)
 		id = IWL_FW_TRIGGER_ID_FW_ASSERT;
-	else if (id == FW_DBG_TRIGGER_USER)
-		id = IWL_FW_TRIGGER_ID_USER_TRIGGER;
-	else if (id < FW_DBG_TRIGGER_MAX)
-		return NULL;
 
 	if (WARN_ON(id >= ARRAY_SIZE(fwrt->dump.active_trigs)))
 		return NULL;
-- 
2.20.1

