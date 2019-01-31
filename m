Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35913C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02B5D218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 20:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfAaUXT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 15:23:19 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:53734 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727435AbfAaUXT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 15:23:19 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gpIqz-0004pL-Bk; Thu, 31 Jan 2019 22:22:29 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Thu, 31 Jan 2019 22:22:03 +0200
Message-Id: <20190131202206.15903-19-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190131202206.15903-1-luca@coelho.fi>
References: <20190131202206.15903-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 18/21] iwlwifi: fix send hcmd timeout recovery flow
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Both iwl_trans_fw_error and iwl_force_nmi initiate async recovery flow.
Calling them both is redundant and causing a race.

Solve this by removing the call to iwl_trans_fw_error.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: cfadc3ffccd5 ("iwlwifi: pcie: stop the firmware when we restart it")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-trans.h    |  3 +++
 .../wireless/intel/iwlwifi/pcie/internal.h    |  1 +
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 25 +++++++++++++++++++
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  8 +++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c  |  8 +++---
 5 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 36d0addb79e8..ef23c6aafb5c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -688,6 +688,9 @@ enum iwl_plat_pm_mode {
  */
 #define IWL_TRANS_IDLE_TIMEOUT 2000
 
+/* Max time to wait for nmi interrupt */
+#define IWL_TRANS_NMI_TIMEOUT (HZ / 4)
+
 /**
  * struct iwl_dram_data
  * @physical: page phy pointer
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index ee38ae3b0d30..9e1bcafad786 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1036,6 +1036,7 @@ static inline bool iwl_pcie_dbg_on(struct iwl_trans *trans)
 
 void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state);
 void iwl_trans_pcie_dump_regs(struct iwl_trans *trans);
+void iwl_trans_sync_nmi(struct iwl_trans *trans);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index ac82c891595c..0b29b2ebb23d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3650,3 +3650,28 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	iwl_trans_free(trans);
 	return ERR_PTR(ret);
 }
+
+void iwl_trans_sync_nmi(struct iwl_trans *trans)
+{
+	unsigned long timeout = jiffies + IWL_TRANS_NMI_TIMEOUT;
+
+	iwl_disable_interrupts(trans);
+	iwl_force_nmi(trans);
+	while (time_after(timeout, jiffies)) {
+		u32 inta_hw = iwl_read32(trans,
+					 CSR_MSIX_HW_INT_CAUSES_AD);
+
+		/* Error detected by uCode */
+		if (inta_hw & MSIX_HW_INT_CAUSES_REG_SW_ERR) {
+			/* Clear causes register */
+			iwl_write32(trans, CSR_MSIX_HW_INT_CAUSES_AD,
+				    inta_hw &
+				    MSIX_HW_INT_CAUSES_REG_SW_ERR);
+			break;
+		}
+
+		mdelay(1);
+	}
+	iwl_enable_interrupts(trans);
+	iwl_trans_fw_error(trans);
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index f3d2e8fe920b..88530d9f4a54 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -20,7 +20,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2017 Intel Deutschland GmbH
- * Copyright(c) 2018        Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -965,9 +965,7 @@ static int iwl_pcie_gen2_send_hcmd_sync(struct iwl_trans *trans,
 			       cmd_str);
 		ret = -ETIMEDOUT;
 
-		iwl_force_nmi(trans);
-		iwl_trans_fw_error(trans);
-
+		iwl_trans_sync_nmi(trans);
 		goto cancel;
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 07395502f419..28a371814387 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 Intel Corporation
+ * Copyright(c) 2018 - 2019 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1942,9 +1942,7 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 			       iwl_get_cmd_string(trans, cmd->id));
 		ret = -ETIMEDOUT;
 
-		iwl_force_nmi(trans);
-		iwl_trans_fw_error(trans);
-
+		iwl_trans_sync_nmi(trans);
 		goto cancel;
 	}
 
-- 
2.20.1

