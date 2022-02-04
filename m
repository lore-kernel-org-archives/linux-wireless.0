Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EEAC433F5
	for <linux-wireless@archiver.kernel.org>; Fri,  4 Feb 2022 10:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbiBDKZX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 4 Feb 2022 05:25:23 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:37964 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1357055AbiBDKZW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Feb 2022 05:25:22 -0500
Received: from 91-156-4-210.elisa-laajakaista.fi ([91.156.4.210] helo=kveik.lan)
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <luca@coelho.fi>)
        id 1nFvmK-0005zM-IP;
        Fri, 04 Feb 2022 12:25:21 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@kernel.org
Cc:     luca@coelho.fi, linux-wireless@vger.kernel.org
Date:   Fri,  4 Feb 2022 12:25:05 +0200
Message-Id: <iwlwifi.20220204122220.57bd62a4365c.I873aa9b3d13abf5633a4963c55c3a09a833254f0@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204102511.606112-1-luca@coelho.fi>
References: <20220204102511.606112-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 06/12] iwlwifi: pcie: Adapt rx queue write pointer for Bz family
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Matti Gottlieb <matti.gottlieb@intel.com>

Adapt rx queue write pointer for Bz family.
The register has moved to the same one as Tx.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h | 3 +++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 9 ++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index f90d4662c164..c0a18e820b51 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -533,6 +533,9 @@ enum {
  * 11-8:  queue selector
  */
 #define HBUS_TARG_WRPTR         (HBUS_BASE+0x060)
+/* This register is common for Tx and Rx, Rx queues start from 512 */
+#define HBUS_TARG_WRPTR_Q_SHIFT (16)
+#define HBUS_TARG_WRPTR_RX_Q(q) (((q) + 512) << HBUS_TARG_WRPTR_Q_SHIFT)
 
 /**********************************************************
  * CSR values
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 331c1a059183..71db571a42e0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -190,11 +190,14 @@ static void iwl_pcie_rxq_inc_wr_ptr(struct iwl_trans *trans,
 	}
 
 	rxq->write_actual = round_down(rxq->write, 8);
-	if (trans->trans_cfg->mq_rx_supported)
+	if (!trans->trans_cfg->mq_rx_supported)
+		iwl_write32(trans, FH_RSCSR_CHNL0_WPTR, rxq->write_actual);
+	else if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_BZ)
+		iwl_write32(trans, HBUS_TARG_WRPTR, rxq->write_actual |
+			    HBUS_TARG_WRPTR_RX_Q(rxq->id));
+	else
 		iwl_write32(trans, RFH_Q_FRBDCB_WIDX_TRG(rxq->id),
 			    rxq->write_actual);
-	else
-		iwl_write32(trans, FH_RSCSR_CHNL0_WPTR, rxq->write_actual);
 }
 
 static void iwl_pcie_rxq_check_wrptr(struct iwl_trans *trans)
-- 
2.34.1

