Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99DAC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9081D20854
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 10:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfCHKJD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 05:09:03 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:41398 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725975AbfCHKJD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 05:09:03 -0500
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h2CR2-0006tZ-BL; Fri, 08 Mar 2019 12:09:00 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri,  8 Mar 2019 12:08:43 +0200
Message-Id: <20190308100848.13188-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308100848.13188-1-luca@coelho.fi>
References: <20190308100848.13188-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 2/7] iwlwifi: add sync_nmi to trans ops
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

Allow modules from outside pcie to call sync_nmi.

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 7 +++++++
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 5 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 2 +-
 5 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index bbebbf3efd57..fa750711d889 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -618,6 +618,7 @@ struct iwl_trans_ops {
 	struct iwl_trans_dump_data *(*dump_data)(struct iwl_trans *trans,
 						 u32 dump_mask);
 	void (*debugfs_cleanup)(struct iwl_trans *trans);
+	void (*sync_nmi)(struct iwl_trans *trans);
 };
 
 /**
@@ -1245,6 +1246,12 @@ static inline void iwl_trans_fw_error(struct iwl_trans *trans)
 
 }
 
+static inline void iwl_trans_sync_nmi(struct iwl_trans *trans)
+{
+	if (trans->ops->sync_nmi)
+		trans->ops->sync_nmi(trans);
+}
+
 /*****************************************************
  * transport helper functions
  *****************************************************/
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index bf8b61a476c5..59213164f35e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1043,7 +1043,7 @@ static inline bool iwl_pcie_dbg_on(struct iwl_trans *trans)
 
 void iwl_trans_pcie_rf_kill(struct iwl_trans *trans, bool state);
 void iwl_trans_pcie_dump_regs(struct iwl_trans *trans);
-void iwl_trans_sync_nmi(struct iwl_trans *trans);
+void iwl_trans_pcie_sync_nmi(struct iwl_trans *trans);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index fe8269d023de..28d6ae8c9336 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3318,7 +3318,8 @@ static void iwl_trans_pcie_resume(struct iwl_trans *trans)
 	.unref = iwl_trans_pcie_unref,					\
 	.dump_data = iwl_trans_pcie_dump_data,				\
 	.d3_suspend = iwl_trans_pcie_d3_suspend,			\
-	.d3_resume = iwl_trans_pcie_d3_resume
+	.d3_resume = iwl_trans_pcie_d3_resume,				\
+	.sync_nmi = iwl_trans_pcie_sync_nmi
 
 #ifdef CONFIG_PM_SLEEP
 #define IWL_TRANS_PM_OPS						\
@@ -3637,7 +3638,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	return ERR_PTR(ret);
 }
 
-void iwl_trans_sync_nmi(struct iwl_trans *trans)
+void iwl_trans_pcie_sync_nmi(struct iwl_trans *trans)
 {
 	unsigned long timeout = jiffies + IWL_TRANS_NMI_TIMEOUT;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 88530d9f4a54..38d110338987 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -965,7 +965,7 @@ static int iwl_pcie_gen2_send_hcmd_sync(struct iwl_trans *trans,
 			       cmd_str);
 		ret = -ETIMEDOUT;
 
-		iwl_trans_sync_nmi(trans);
+		iwl_trans_pcie_sync_nmi(trans);
 		goto cancel;
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 9fbd37d23e85..7be73e2c4681 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1960,7 +1960,7 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 			       iwl_get_cmd_string(trans, cmd->id));
 		ret = -ETIMEDOUT;
 
-		iwl_trans_sync_nmi(trans);
+		iwl_trans_pcie_sync_nmi(trans);
 		goto cancel;
 	}
 
-- 
2.20.1

