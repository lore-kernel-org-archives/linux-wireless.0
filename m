Return-Path: <SRS0=l5SL=WM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4963EC3A59C
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Aug 2019 12:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29F222064A
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Aug 2019 12:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfHPM4F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Aug 2019 08:56:05 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:36144 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726742AbfHPM4E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Aug 2019 08:56:04 -0400
Received: from [91.156.6.193] (helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hybly-00066W-KY; Fri, 16 Aug 2019 15:56:03 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 16 Aug 2019 15:55:53 +0300
Message-Id: <20190816125554.8659-4-luca@coelho.fi>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190816125554.8659-1-luca@coelho.fi>
References: <20190816125554.8659-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 3/4] iwlwifi: pcie: don't switch FW to qnj when ax201 is detected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

We have a too generic condition that switches from Qu configurations
to QnJ configurations.  We need to exclude some configurations so that
they are not erroneously switched.  Add the ax201 configuration to the
list of exclusions.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index f5df5b370d78..935e35dafce5 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3603,6 +3603,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
 		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
 		   ((trans->cfg != &iwl_ax200_cfg_cc &&
+		     trans->cfg != &iwl_ax201_cfg_qu_hr &&
 		     trans->cfg != &killer1650x_2ax_cfg &&
 		     trans->cfg != &killer1650w_2ax_cfg &&
 		     trans->cfg != &iwl_ax201_cfg_quz_hr) ||
-- 
2.23.0.rc1

