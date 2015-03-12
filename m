Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:6667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbbCLNEs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:04:48 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/49] iwlwifi: mvm: init country code on init/recovery
Date: Thu, 12 Mar 2015 15:03:49 +0200
Message-Id: <1426165474-25586-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140452_166220_D1FCFFAD)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

During init queue a regulatory update to retrieve the default
regulatory settings from FW. If we're during recovery, only replay the
current country code to FW, if it exists.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c  |  4 ++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h |  1 +
 drivers/net/wireless/iwlwifi/mvm/nvm.c | 37 ++++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index a81da4c..c03bde0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -739,6 +739,10 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	if (ret)
 		goto error;
 
+	ret = iwl_mvm_init_mcc(mvm);
+	if (ret)
+		goto error;
+
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		ret = iwl_mvm_config_scan(mvm);
 		if (ret)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index a0aa3b1..b31f43c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1397,6 +1397,7 @@ int iwl_mvm_get_temp(struct iwl_mvm *mvm);
 /* Location Aware Regulatory */
 struct iwl_mcc_update_resp *
 iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2);
+int iwl_mvm_init_mcc(struct iwl_mvm *mvm);
 
 /* smart fifo */
 int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 96107b8..26c5d94 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -63,6 +63,7 @@
  *
  *****************************************************************************/
 #include <linux/firmware.h>
+#include <linux/rtnetlink.h>
 #include "iwl-trans.h"
 #include "iwl-csr.h"
 #include "mvm.h"
@@ -654,3 +655,39 @@ exit:
 		return ERR_PTR(ret);
 	return resp_cp;
 }
+
+int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
+{
+	if (!iwl_mvm_is_lar_supported(mvm))
+		return 0;
+
+	/*
+	 * During HW restart, only replay the last set MCC to FW. Otherwise,
+	 * queue an update to cfg80211 to retrieve the default alpha2 from FW.
+	 */
+	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
+		/* This should only be called during vif up and hold RTNL */
+		const struct ieee80211_regdomain *r =
+				rtnl_dereference(mvm->hw->wiphy->regd);
+
+		if (r) {
+			struct iwl_mcc_update_resp *resp;
+
+			resp = iwl_mvm_update_mcc(mvm, r->alpha2);
+			if (IS_ERR_OR_NULL(resp))
+				return -EIO;
+
+			kfree(resp);
+		}
+
+		return 0;
+	}
+
+	/*
+	 * Driver regulatory hint for initial update - use the special
+	 * unknown-country "99" code. This will also clear the "custom reg"
+	 * flag and allow regdomain changes. It will happen after init since
+	 * RTNL is required.
+	 */
+	return regulatory_hint(mvm->hw->wiphy, "99");
+}
-- 
1.9.1

