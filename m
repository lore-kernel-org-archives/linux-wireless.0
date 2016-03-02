Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51900 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbcCBH5r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:47 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 42/43] iwlwifi: mvm: take the transport ref back when leaving
Date: Wed,  2 Mar 2016 09:56:43 +0200
Message-Id: <1456905404-14435-42-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085951_439667_19C8C9F0)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

If d0i3 is supported, we have released the initial transport reference
in iwl_op_mode_mvm_start(), so we should take it back in
iwl_op_mode_mvm_stop() to keep it balanced.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index f3283f4..3760a09 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -703,6 +703,13 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	int i;
 
+	/* If d0i3 is supported, we have released the reference that
+	 * the transport started with, so we should take it back now
+	 * that we are leaving.
+	 */
+	if (iwl_mvm_is_d0i3_supported(mvm))
+		iwl_trans_ref(mvm->trans);
+
 	iwl_mvm_leds_exit(mvm);
 
 	iwl_mvm_thermal_exit(mvm);
-- 
2.5.0

