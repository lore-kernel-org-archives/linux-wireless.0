Return-Path: <SRS0=ZHYo=P7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3C1C282C0
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 07:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFCFD20870
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 07:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfAWHDA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Jan 2019 02:03:00 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:49890 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726328AbfAWHDA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Jan 2019 02:03:00 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gmCYr-0007ub-MT; Wed, 23 Jan 2019 09:02:58 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 23 Jan 2019 09:02:52 +0200
Message-Id: <20190123070252.23648-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <201901220400.QGup99vm%fengguang.wu@intel.com>
References: <201901220400.QGup99vm%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH v2] iwlwifi: pcie: recognize NICs with hw_rev 0x364 correctly
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Some devices with PCI ID 0x2723, which is supposed to be 22260, are
actually not.  So we need to differentiate them by checking the hw_rev
and change the cfg accordingly.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---

In v2:

   * Added missing definition of CSR_HW_REV_TYPE_QNJ_B0

drivers/net/wireless/intel/iwlwifi/iwl-csr.h    | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index caa5806acd81..42af421bbc3c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -325,6 +325,7 @@ enum {
 #define CSR_HW_REV_TYPE_7265D		(0x0000210)
 #define CSR_HW_REV_TYPE_NONE		(0x00001F0)
 #define CSR_HW_REV_TYPE_QNJ		(0x0000360)
+#define CSR_HW_REV_TYPE_QNJ_B0		(0x0000364)
 #define CSR_HW_REV_TYPE_HR_CDB		(0x0000340)
 
 /* RF_ID value */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index fc2f98f2d516..633444d2f930 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3569,6 +3569,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		}
 	}
 
+	IWL_DEBUG_INFO(trans, "HW REV: 0x%0x\n", trans->hw_rev);
+
 	/*
 	 * 9000-series integrated A-step has a problem with suspend/resume
 	 * and sometimes even causes the whole platform to get stuck. This
@@ -3603,7 +3605,8 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		}
 	} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
-		   trans->cfg != &iwl22260_2ax_cfg) {
+		   (trans->cfg != &iwl22260_2ax_cfg ||
+		    trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0)) {
 		u32 hw_status;
 
 		hw_status = iwl_read_prph(trans, UMAG_GEN_HW_STATUS);
-- 
2.20.1

