Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490D3C282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 07:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21DB02176F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 07:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbfDQHf2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 03:35:28 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53526 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726773AbfDQHf2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 03:35:28 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hGf6G-0006gA-PY; Wed, 17 Apr 2019 10:35:21 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        emmanuel.grumbach@intel.com, linuxwifi@intel.com
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Wed, 17 Apr 2019 10:35:16 +0300
Message-Id: <20190417073516.24250-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <748205b02961167b0926d4afe8d9ad9cb37bf6ef.camel@coelho.fi>
References: <748205b02961167b0926d4afe8d9ad9cb37bf6ef.camel@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH] iwlwifi: don't panic in error path on non-msix systems
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

The driver uses msix causes-register to handle both msix and non msix
interrupts when performing sync nmi.  On devices that do not support
msix this register is unmapped and accessing it causes a kernel panic.

Solve this by differentiating the two cases and accessing the proper
causes-register in each case.

Reported-by: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 79c1dc05f948..c4375b868901 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3644,20 +3644,27 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 
 void iwl_trans_pcie_sync_nmi(struct iwl_trans *trans)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	unsigned long timeout = jiffies + IWL_TRANS_NMI_TIMEOUT;
+	u32 inta_addr, sw_err_bit;
+
+	if (trans_pcie->msix_enabled) {
+		inta_addr = CSR_MSIX_HW_INT_CAUSES_AD;
+		sw_err_bit = MSIX_HW_INT_CAUSES_REG_SW_ERR;
+	} else {
+		inta_addr = CSR_INT;
+		sw_err_bit = CSR_INT_BIT_SW_ERR;
+	}
 
 	iwl_disable_interrupts(trans);
 	iwl_force_nmi(trans);
 	while (time_after(timeout, jiffies)) {
-		u32 inta_hw = iwl_read32(trans,
-					 CSR_MSIX_HW_INT_CAUSES_AD);
+		u32 inta_hw = iwl_read32(trans, inta_addr);
 
 		/* Error detected by uCode */
-		if (inta_hw & MSIX_HW_INT_CAUSES_REG_SW_ERR) {
+		if (inta_hw & sw_err_bit) {
 			/* Clear causes register */
-			iwl_write32(trans, CSR_MSIX_HW_INT_CAUSES_AD,
-				    inta_hw &
-				    MSIX_HW_INT_CAUSES_REG_SW_ERR);
+			iwl_write32(trans, inta_addr, inta_hw & sw_err_bit);
 			break;
 		}
 
-- 
2.20.1

