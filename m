Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60143 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3LQUpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:14 -0500
Received: by mail-ee0-f46.google.com with SMTP id d49so3127653eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:13 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/36] iwlwifi: remove pointer to transport from op_mode
Date: Tue, 17 Dec 2013 22:44:23 +0200
Message-Id: <1387313079-28123-20-git-send-email-egrumbach@gmail.com> (sfid-20131217_214624_980674_04825706)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This pointer was not used anywhere.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-op-mode.h |    4 +---
 drivers/net/wireless/iwlwifi/mvm/ops.c     |    1 -
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index 976448a..f50e6c6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -155,14 +155,12 @@ void iwl_opmode_deregister(const char *name);
 
 /**
  * struct iwl_op_mode - operational mode
+ * @ops - pointer to its own ops
  *
  * This holds an implementation of the mac80211 / fw API.
- *
- * @ops - pointer to its own ops
  */
 struct iwl_op_mode {
 	const struct iwl_op_mode_ops *ops;
-	const struct iwl_trans *trans;
 
 	char op_mode_specific[0] __aligned(sizeof(void *));
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index a6f4be8..ef3fdcf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -344,7 +344,6 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	op_mode = hw->priv;
 	op_mode->ops = &iwl_mvm_ops;
-	op_mode->trans = trans;
 
 	mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	mvm->dev = trans->dev;
-- 
1.7.9.5

