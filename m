Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69206C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41300218A5
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 13:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbfCVN76 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:59:58 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:46218 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727946AbfCVN76 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 09:59:58 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h7Khm-0000bK-Qi; Fri, 22 Mar 2019 15:59:31 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 22 Mar 2019 15:59:01 +0200
Message-Id: <20190322135903.10631-23-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190322135903.10631-1-luca@coelho.fi>
References: <20190322135903.10631-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 22/24] iwlwifi: set 512 TX queue slots for AX210 devices
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

AX210 devices support 256 BA (256 MPDUs in an AMPDU).
The firmware requires that the number of TFDs will be
minimum twice as big as the BA size (2 * 256 = 512).

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c  | 3 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 3 +++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c    | 6 ++++--
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index e0db1988b6a3..3203aa72541a 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -209,7 +209,8 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.base_params = &iwl_22000_base_params,				\
 	.csr = &iwl_csr_v1,						\
 	.min_txq_size = 128,						\
-	.gp2_reg_addr = 0xd02c68
+	.gp2_reg_addr = 0xd02c68,					\
+	.min_256_ba_txq_size = 512
 
 const struct iwl_cfg iwl22000_2ac_cfg_hr = {
 	.name = "Intel(R) Dual Band Wireless AC 22000",
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index bc929d6639bd..486b6daea370 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -384,6 +384,8 @@ struct iwl_csr_params {
  * @min_txq_size: minimum number of slots required in a TX queue
  * @umac_prph_offset: offset to add to UMAC periphery address
  * @uhb_supported: ultra high band channels supported
+ * @min_256_ba_txq_size: minimum number of slots required in a TX queue which
+ *	supports 256 BA aggregation
  *
  * We enable the driver to be backward compatible wrt. hardware features.
  * API differences in uCode shouldn't be handled here but through TLVs
@@ -457,6 +459,7 @@ struct iwl_cfg {
 	u32 fw_mon_smem_cycle_cnt_ptr_addr;
 	u32 fw_mon_smem_cycle_cnt_ptr_msk;
 	u32 gp2_reg_addr;
+	u32 min_256_ba_txq_size;
 };
 
 extern const struct iwl_csr_params iwl_csr_v1;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 9fbd37d23e85..bb0fc1c2b4f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -999,7 +999,8 @@ static int iwl_pcie_tx_alloc(struct iwl_trans *trans)
 			slots_num = max_t(u32, TFD_CMD_SLOTS,
 					  trans->cfg->min_txq_size);
 		else
-			slots_num = TFD_TX_CMD_SLOTS;
+			slots_num = max_t(u32, TFD_TX_CMD_SLOTS,
+					  trans->cfg->min_256_ba_txq_size);
 		trans_pcie->txq[txq_id] = &trans_pcie->txq_memory[txq_id];
 		ret = iwl_pcie_txq_alloc(trans, trans_pcie->txq[txq_id],
 					 slots_num, cmd_queue);
@@ -1052,7 +1053,8 @@ int iwl_pcie_tx_init(struct iwl_trans *trans)
 			slots_num = max_t(u32, TFD_CMD_SLOTS,
 					  trans->cfg->min_txq_size);
 		else
-			slots_num = TFD_TX_CMD_SLOTS;
+			slots_num = max_t(u32, TFD_TX_CMD_SLOTS,
+					  trans->cfg->min_256_ba_txq_size);
 		ret = iwl_pcie_txq_init(trans, trans_pcie->txq[txq_id],
 					slots_num, cmd_queue);
 		if (ret) {
-- 
2.20.1

