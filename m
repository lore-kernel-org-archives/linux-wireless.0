Return-Path: <SRS0=80NG=P2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95CE3C5ACD3
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7398D2086D
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Jan 2019 19:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbfARTA7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Jan 2019 14:00:59 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:48430 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729245AbfARTA6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Jan 2019 14:00:58 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gkZNO-0004cj-Oo; Fri, 18 Jan 2019 21:00:23 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 18 Jan 2019 21:00:00 +0200
Message-Id: <20190118190004.22270-13-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190118190004.22270-1-luca@coelho.fi>
References: <20190118190004.22270-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 12/16] iwlwifi: pcie: remove unnecessary iwl_pcie_enable_rx_wake() function
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

This function was only used by 9000 A-step devices, which we don't
support anymore, so it can be removed.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../wireless/intel/iwlwifi/pcie/internal.h    |  2 --
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 26 -------------------
 .../net/wireless/intel/iwlwifi/pcie/trans.c   |  4 ---
 3 files changed, 32 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index d6fc6ce73e0a..971785b17e09 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1029,8 +1029,6 @@ static inline int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans)
 int iwl_pci_fw_exit_d0i3(struct iwl_trans *trans);
 int iwl_pci_fw_enter_d0i3(struct iwl_trans *trans);
 
-void iwl_pcie_enable_rx_wake(struct iwl_trans *trans, bool enable);
-
 void iwl_pcie_rx_allocator_work(struct work_struct *data);
 
 /* common functions that are used by gen2 transport */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index e965cc588850..541da1d44762 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -868,30 +868,6 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 		iwl_set_bit(trans, CSR_INT_COALESCING, IWL_HOST_INT_OPER_MODE);
 }
 
-void iwl_pcie_enable_rx_wake(struct iwl_trans *trans, bool enable)
-{
-	if (trans->cfg->device_family != IWL_DEVICE_FAMILY_9000)
-		return;
-
-	if (CSR_HW_REV_STEP(trans->hw_rev) != SILICON_A_STEP)
-		return;
-
-	if (!trans->cfg->integrated)
-		return;
-
-	/*
-	 * Turn on the chicken-bits that cause MAC wakeup for RX-related
-	 * values.
-	 * This costs some power, but needed for W/A 9000 integrated A-step
-	 * bug where shadow registers are not in the retention list and their
-	 * value is lost when NIC powers down
-	 */
-	iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL,
-		    CSR_MAC_SHADOW_REG_CTRL_RX_WAKE);
-	iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTL2,
-		    CSR_MAC_SHADOW_REG_CTL2_RX_WAKE);
-}
-
 static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -979,8 +955,6 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 
 	/* Set interrupt coalescing timer to default (2048 usecs) */
 	iwl_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
-
-	iwl_pcie_enable_rx_wake(trans, true);
 }
 
 void iwl_pcie_rx_init_rxb_lists(struct iwl_rxq *rxq)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 55ccfa22b3c0..40e59e701273 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1530,8 +1530,6 @@ static void iwl_trans_pcie_d3_suspend(struct iwl_trans *trans, bool test,
 	iwl_clear_bit(trans, CSR_GP_CNTRL,
 		      BIT(trans->cfg->csr->flag_init_done));
 
-	iwl_pcie_enable_rx_wake(trans, false);
-
 	if (reset) {
 		/*
 		 * reset TX queues -- some of their registers reset during S3
@@ -1558,8 +1556,6 @@ static int iwl_trans_pcie_d3_resume(struct iwl_trans *trans,
 		return 0;
 	}
 
-	iwl_pcie_enable_rx_wake(trans, true);
-
 	iwl_set_bit(trans, CSR_GP_CNTRL,
 		    BIT(trans->cfg->csr->flag_mac_access_req));
 	iwl_set_bit(trans, CSR_GP_CNTRL,
-- 
2.20.1

