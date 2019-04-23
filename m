Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77F3CC282DD
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41ED3206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 09:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfDWJKx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 05:10:53 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:58956 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725939AbfDWJKx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 05:10:53 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hIrRz-0000FN-BS; Tue, 23 Apr 2019 12:10:51 +0300
From:   Luca Coelho <luca@coelho.fi>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 02/16] iwlwifi: pcie: initialize debug_rfkill to -1
Date:   Tue, 23 Apr 2019 12:10:29 +0300
Message-Id: <20190423091043.7156-3-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190423091043.7156-1-luca@coelho.fi>
References: <20190423091043.7156-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This will let us introduce a mechanism to start with rfkill
faked, and put 0 here to override it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  4 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 11 ++++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 1f1594e136c5..b513037dc066 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -536,7 +536,7 @@ struct iwl_trans_pcie {
 	int ict_index;
 	bool use_ict;
 	bool is_down, opmode_down;
-	bool debug_rfkill;
+	s8 debug_rfkill;
 	struct isr_statistics isr_stats;
 
 	spinlock_t irq_lock;
@@ -982,7 +982,7 @@ static inline bool iwl_is_rfkill_set(struct iwl_trans *trans)
 
 	lockdep_assert_held(&trans_pcie->mutex);
 
-	if (trans_pcie->debug_rfkill)
+	if (trans_pcie->debug_rfkill == 1)
 		return true;
 
 	return !(iwl_read32(trans, CSR_GP_CNTRL) &
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 717b9b5be157..d638f41efcdd 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2688,16 +2688,17 @@ static ssize_t iwl_dbgfs_rfkill_write(struct file *file,
 {
 	struct iwl_trans *trans = file->private_data;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	bool old = trans_pcie->debug_rfkill;
+	bool new_value;
 	int ret;
 
-	ret = kstrtobool_from_user(user_buf, count, &trans_pcie->debug_rfkill);
+	ret = kstrtobool_from_user(user_buf, count, &new_value);
 	if (ret)
 		return ret;
-	if (old == trans_pcie->debug_rfkill)
+	if (new_value == trans_pcie->debug_rfkill)
 		return count;
 	IWL_WARN(trans, "changing debug rfkill %d->%d\n",
-		 old, trans_pcie->debug_rfkill);
+		 trans_pcie->debug_rfkill, new_value);
+	trans_pcie->debug_rfkill = new_value;
 	iwl_pcie_handle_rfkill_irq(trans);
 
 	return count;
@@ -3421,7 +3422,7 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		ret = -ENOMEM;
 		goto out_no_pci;
 	}
-
+	trans_pcie->debug_rfkill = -1;
 
 	if (!cfg->base_params->pcie_l1_allowed) {
 		/*
-- 
2.20.1

