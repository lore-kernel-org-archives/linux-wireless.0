Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51900 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbcCBH5o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:57:44 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luca Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 40/43] iwlwifi: mvm: only release the trans ref if d0i3 is supported in fw
Date: Wed,  2 Mar 2016 09:56:41 +0200
Message-Id: <1456905404-14435-40-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160302_085952_046430_9E0F6136)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

If d0i3 is not supported by the firmware (or if it's disabled via
module parameters) we shouldn't release the initial transport
reference, so that we won't enter runtime suspend.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 4716176..f3283f4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -672,8 +672,10 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	memset(&mvm->rx_stats, 0, sizeof(struct mvm_statistics_rx));
 
-	/* rpm starts with a taken reference, we can release it now */
-	iwl_trans_unref(mvm->trans);
+	/* The transport always starts with a taken reference, we can
+	 * release it now if d0i3 is supported */
+	if (iwl_mvm_is_d0i3_supported(mvm))
+		iwl_trans_unref(mvm->trans);
 
 	iwl_mvm_tof_init(mvm);
 
-- 
2.5.0

