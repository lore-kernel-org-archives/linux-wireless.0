Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20496 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031502Ab2CFWnj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 17:43:39 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 29/33] iwlwifi: remove priv from shared
Date: Tue,  6 Mar 2012 13:31:04 -0800
Message-Id: <1331069468-11074-30-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120306_234353_932186_ADEA3F46)
In-Reply-To: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1331069468-11074-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Finally nothing needs to access priv
from shared any more, so remove it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-shared.h |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 98f32e5..4cd375c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1205,7 +1205,6 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	op_mode->ops = &iwl_dvm_ops;
 	priv = IWL_OP_MODE_GET_DVM(op_mode);
 	priv->shrd = trans->shrd;
-	priv->shrd->priv = priv;
 	priv->fw = fw;
 	/* TODO: remove fw from shared data later */
 	priv->shrd->fw = fw;
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index a6c2539..55f9f07 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -376,7 +376,6 @@ struct iwl_shared {
 	u8 valid_contexts;
 
 	const struct iwl_cfg *cfg;
-	struct iwl_priv *priv;
 	struct iwl_trans *trans;
 	void *drv;
 	struct iwl_hw_params hw_params;
@@ -398,7 +397,6 @@ struct iwl_shared {
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, these macros will work */
-#define priv(_m)	((_m)->shrd->priv)
 #define cfg(_m)		((_m)->shrd->cfg)
 #define trans(_m)	((_m)->shrd->trans)
 #define hw_params(_m)	((_m)->shrd->hw_params)
-- 
1.7.0.4

