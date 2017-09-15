Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54370 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751323AbdIOMrQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 08:47:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 15 Sep 2017 15:46:56 +0300
Message-Id: <20170915124704.9032-3-luca@coelho.fi> (sfid-20170915_144721_948119_F3B9B217)
In-Reply-To: <20170915124704.9032-1-luca@coelho.fi>
References: <20170915124704.9032-1-luca@coelho.fi>
Subject: [PATCH 02/10] iwlwifi: trans: move ref/unref code to the common part of the transport
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

De-inline iwl_trans_ref/unref and move it to common transport code
in preparation for more common code to come to these functions.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c | 16 ++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 14 ++------------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 784bdd0ed233..7e9c924e1220 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -6,6 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,6 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -205,3 +207,17 @@ int iwl_cmd_groups_verify_sorted(const struct iwl_trans_config *trans)
 	return 0;
 }
 IWL_EXPORT_SYMBOL(iwl_cmd_groups_verify_sorted);
+
+void iwl_trans_ref(struct iwl_trans *trans)
+{
+	if (trans->ops->ref)
+		trans->ops->ref(trans);
+}
+IWL_EXPORT_SYMBOL(iwl_trans_ref);
+
+void iwl_trans_unref(struct iwl_trans *trans)
+{
+	if (trans->ops->unref)
+		trans->ops->unref(trans);
+}
+IWL_EXPORT_SYMBOL(iwl_trans_unref);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index e90abbfba718..91ec077900f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -875,18 +875,6 @@ static inline int iwl_trans_d3_resume(struct iwl_trans *trans,
 	return trans->ops->d3_resume(trans, status, test, reset);
 }
 
-static inline void iwl_trans_ref(struct iwl_trans *trans)
-{
-	if (trans->ops->ref)
-		trans->ops->ref(trans);
-}
-
-static inline void iwl_trans_unref(struct iwl_trans *trans)
-{
-	if (trans->ops->unref)
-		trans->ops->unref(trans);
-}
-
 static inline int iwl_trans_suspend(struct iwl_trans *trans)
 {
 	if (!trans->ops->suspend)
@@ -1191,6 +1179,8 @@ struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 				  const struct iwl_cfg *cfg,
 				  const struct iwl_trans_ops *ops);
 void iwl_trans_free(struct iwl_trans *trans);
+void iwl_trans_ref(struct iwl_trans *trans);
+void iwl_trans_unref(struct iwl_trans *trans);
 
 /*****************************************************
 * driver (transport) register/unregister functions
-- 
2.14.1
