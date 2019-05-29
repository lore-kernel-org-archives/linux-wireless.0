Return-Path: <SRS0=kjT+=T5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C2BC28CC3
	for <linux-wireless@archiver.kernel.org>; Wed, 29 May 2019 13:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F06C521902
	for <linux-wireless@archiver.kernel.org>; Wed, 29 May 2019 13:40:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfE2NkG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 29 May 2019 09:40:06 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54360 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727160AbfE2NkF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 May 2019 09:40:05 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hVyoF-00080o-GM; Wed, 29 May 2019 16:40:03 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, Matt Chen <matt.chen@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5/7] iwlwifi: fix AX201 killer sku loading firmware issue
Date:   Wed, 29 May 2019 16:39:53 +0300
Message-Id: <20190529133955.31082-6-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190529133955.31082-1-luca@coelho.fi>
References: <20190529133955.31082-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Matt Chen <matt.chen@intel.com>

When try to bring up the AX201 2 killer sku, we
run into:
[81261.392463] iwlwifi 0000:01:00.0: loaded firmware version 46.8c20f243.0 op_mode iwlmvm
[81261.407407] iwlwifi 0000:01:00.0: Detected Intel(R) Dual Band Wireless AX 22000, REV=0x340
[81262.424778] iwlwifi 0000:01:00.0: Collecting data: trigger 16 fired.
[81262.673359] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
[81262.673365] iwlwifi 0000:01:00.0: Status: 0x00000000, count: -906373681
[81262.673368] iwlwifi 0000:01:00.0: Loaded firmware version: 46.8c20f243.0
[81262.673371] iwlwifi 0000:01:00.0: 0x507C015D | ADVANCED_SYSASSERT

Fix this issue by adding 2 more cfg to avoid modifying the
original cfg configuration.

Signed-off-by: Matt Chen <matt.chen@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 21da18af0155..dfa1bed124aa 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3598,7 +3598,9 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		}
 	} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
-		   (trans->cfg != &iwl_ax200_cfg_cc ||
+		   ((trans->cfg != &iwl_ax200_cfg_cc &&
+		    trans->cfg != &killer1650x_2ax_cfg &&
+		    trans->cfg != &killer1650w_2ax_cfg) ||
 		    trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0)) {
 		u32 hw_status;
 
-- 
2.20.1

