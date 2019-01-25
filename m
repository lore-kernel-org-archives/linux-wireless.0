Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175ACC282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5CB2218B0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbfAYUWG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:22:06 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:50928 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725778AbfAYUWF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 15:22:05 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gn7qt-00010a-Hu; Fri, 25 Jan 2019 22:13:23 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 25 Jan 2019 22:13:04 +0200
Message-Id: <20190125201305.5616-17-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190125201305.5616-1-luca@coelho.fi>
References: <20190125201305.5616-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 16/17] iwlwifi: monitor dumping flow cleanup
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Since we use a dumping mask, checking if only monitor was requested
is redundant. Remove the unneeded code.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/pcie/trans.c    | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index e72bd9796b5b..472a85d9a358 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3169,8 +3169,7 @@ static struct iwl_trans_dump_data
 	struct iwl_txq *cmdq = trans_pcie->txq[trans_pcie->cmd_queue];
 	struct iwl_fw_error_dump_txcmd *txcmd;
 	struct iwl_trans_dump_data *dump_data;
-	u32 len, num_rbs = 0;
-	u32 monitor_len;
+	u32 len, num_rbs = 0, monitor_len = 0;
 	int i, ptr;
 	bool dump_rbs = test_bit(STATUS_FW_ERROR, &trans->status) &&
 			!trans->cfg->mq_rx_supported &&
@@ -3187,19 +3186,8 @@ static struct iwl_trans_dump_data
 		cmdq->n_window * (sizeof(*txcmd) + TFD_MAX_PAYLOAD_SIZE);
 
 	/* FW monitor */
-	monitor_len = iwl_trans_get_fw_monitor_len(trans, &len);
-
-	if (dump_mask == BIT(IWL_FW_ERROR_DUMP_FW_MONITOR)) {
-		dump_data = vzalloc(len);
-		if (!dump_data)
-			return NULL;
-
-		data = (void *)dump_data->data;
-		len = iwl_trans_pcie_dump_monitor(trans, &data, monitor_len);
-		dump_data->len = len;
-
-		return dump_data;
-	}
+	if (dump_mask & BIT(IWL_FW_ERROR_DUMP_FW_MONITOR))
+		monitor_len = iwl_trans_get_fw_monitor_len(trans, &len);
 
 	/* CSR registers */
 	if (dump_mask & BIT(IWL_FW_ERROR_DUMP_CSR))
-- 
2.20.1

