Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52822 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755053AbdDRWV2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:21:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:26 +0300
Message-Id: <20170418221729.28372-23-luca@coelho.fi> (sfid-20170419_002133_756156_6FFA60EC)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 22/25] iwlwifi: mvm: support changing band for phy context
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

In a000 CDB firmware, we cannot update phy context to a
different band - we must first remove it and add it
again. Support this flow for all a000 devices since
we may have various combinations that cause us to fail
regardless if CDB is active.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h   |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 21 ++++++++++++++++++++-
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 8302cf03ac28..f545c5f9e4e3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -690,7 +690,7 @@ struct iwl_error_resp {
 					  (_color << FW_CTXT_COLOR_POS))
 
 /* Possible actions on PHYs, MACs and Bindings */
-enum {
+enum iwl_phy_ctxt_action {
 	FW_CTXT_ACTION_STUB = 0,
 	FW_CTXT_ACTION_ADD,
 	FW_CTXT_ACTION_MODIFY,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index 95138830b9f8..d59efe804356 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2017           Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -250,12 +251,30 @@ int iwl_mvm_phy_ctxt_changed(struct iwl_mvm *mvm, struct iwl_mvm_phy_ctxt *ctxt,
 			     struct cfg80211_chan_def *chandef,
 			     u8 chains_static, u8 chains_dynamic)
 {
+	enum iwl_phy_ctxt_action action = FW_CTXT_ACTION_MODIFY;
+
 	lockdep_assert_held(&mvm->mutex);
 
+	/* In CDB mode we cannot modify PHY context between bands so... */
+	if (iwl_mvm_has_new_tx_api(mvm) &&
+	    ctxt->channel->band != chandef->chan->band) {
+		int ret;
+
+		/* ... remove it here ...*/
+		ret = iwl_mvm_phy_ctxt_apply(mvm, ctxt, chandef,
+					     chains_static, chains_dynamic,
+					     FW_CTXT_ACTION_REMOVE, 0);
+		if (ret)
+			return ret;
+
+		/* ... and proceed to add it again */
+		action = FW_CTXT_ACTION_ADD;
+	}
+
 	ctxt->channel = chandef->chan;
 	return iwl_mvm_phy_ctxt_apply(mvm, ctxt, chandef,
 				      chains_static, chains_dynamic,
-				      FW_CTXT_ACTION_MODIFY, 0);
+				      action, 0);
 }
 
 void iwl_mvm_phy_ctxt_unref(struct iwl_mvm *mvm, struct iwl_mvm_phy_ctxt *ctxt)
-- 
2.11.0
