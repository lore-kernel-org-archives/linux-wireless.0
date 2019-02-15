Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E4FC10F02
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE29321929
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391359AbfBOLuN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:50:13 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:60560 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729084AbfBOLuN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:50:13 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1guc01-0008TN-2Q; Fri, 15 Feb 2019 13:49:45 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Feb 2019 13:49:22 +0200
Message-Id: <20190215114924.2545-19-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190215114924.2545-1-luca@coelho.fi>
References: <20190215114924.2545-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 18/20] iwlwifi: remove redundant condition from prior alive dump flow
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

After the FW image was loaded for the first time,
fwrt->smem_cfg.num_lmacs value will no longer be zero since we don't
clean it when we stop the device. So if we load the image once and then
we fail on a consecutive attempt, the driver will abort any dumping.

Solve this by removing the condition. It is safe to remove since
when we do the actual dumping in iwl_fw_dbg_collect_sync we check
that STATUS_DEVICE_ENABLED bit is still active.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 202f96e9ca0c..b189a605ec13 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1592,22 +1592,6 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 			    bool monitor_only,
 			    unsigned int delay)
 {
-	/*
-	 * If the loading of the FW completed successfully, the next step is to
-	 * get the SMEM config data. Thus, if fwrt->smem_cfg.num_lmacs is non
-	 * zero, the FW was already loaded successully. If the state is "NO_FW"
-	 * in such a case - exit, since FW may be dead. Otherwise, we
-	 * can try to collect the data, since FW might just not be fully
-	 * loaded (no "ALIVE" yet), and the debug data is accessible.
-	 *
-	 * Corner case: got the FW alive but crashed before getting the SMEM
-	 *	config. In such a case, due to HW access problems, we might
-	 *	collect garbage.
-	 */
-	if (fwrt->trans->state == IWL_TRANS_NO_FW &&
-	    fwrt->smem_cfg.num_lmacs)
-		return -EIO;
-
 	if (test_and_set_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status))
 		return -EBUSY;
 
-- 
2.20.1

