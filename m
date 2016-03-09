Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62255 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933663AbcCIRq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 12:46:29 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/21] iwlwifi: mvm: return the cooling state index instead of the budget
Date: Wed,  9 Mar 2016 19:45:46 +0200
Message-Id: <1457545550-30677-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160309_185951_245589_7B8205CC)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

iwl_mvm_tcool_get_cur_state is the function that returns the
cooling state index to the sysfs handler. This function returns
mvm->cooling_dev.cur_state but that variable was set to the
budget and not the cooling state index. Fix that.
Add a missing blank line while at it.

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c  | 56 ++++++++++++++--------------
 2 files changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index b869db9..9abbc93 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -543,8 +543,8 @@ struct iwl_mvm_thermal_device {
 };
 
 /*
- * iwl_mvm_cooling_device
- * @cur_state: current state in milliwatts
+ * struct iwl_mvm_cooling_device
+ * @cur_state: current state
  * @cdev: struct thermal cooling device
  */
 struct iwl_mvm_cooling_device {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
index a396549..de3589a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tt.c
@@ -510,11 +510,35 @@ static const struct iwl_tt_params iwl_mvm_default_tt_params = {
 	.support_tx_backoff = true,
 };
 
-int iwl_mvm_ctdp_command(struct iwl_mvm *mvm, u32 op, u32 budget)
+/* budget in mWatt */
+static const u32 iwl_mvm_cdev_budgets[] = {
+	2000,	/* cooling state 0 */
+	1800,	/* cooling state 1 */
+	1600,	/* cooling state 2 */
+	1400,	/* cooling state 3 */
+	1200,	/* cooling state 4 */
+	1000,	/* cooling state 5 */
+	900,	/* cooling state 6 */
+	800,	/* cooling state 7 */
+	700,	/* cooling state 8 */
+	650,	/* cooling state 9 */
+	600,	/* cooling state 10 */
+	550,	/* cooling state 11 */
+	500,	/* cooling state 12 */
+	450,	/* cooling state 13 */
+	400,	/* cooling state 14 */
+	350,	/* cooling state 15 */
+	300,	/* cooling state 16 */
+	250,	/* cooling state 17 */
+	200,	/* cooling state 18 */
+	150,	/* cooling state 19 */
+};
+
+int iwl_mvm_ctdp_command(struct iwl_mvm *mvm, u32 op, u32 state)
 {
 	struct iwl_mvm_ctdp_cmd cmd = {
 		.operation = cpu_to_le32(op),
-		.budget = cpu_to_le32(budget),
+		.budget = cpu_to_le32(iwl_mvm_cdev_budgets[state]),
 		.window_size = 0,
 	};
 	int ret;
@@ -533,7 +557,7 @@ int iwl_mvm_ctdp_command(struct iwl_mvm *mvm, u32 op, u32 budget)
 
 	switch (op) {
 	case CTDP_CMD_OPERATION_START:
-		mvm->cooling_dev.cur_state = budget;
+		mvm->cooling_dev.cur_state = state;
 		break;
 	case CTDP_CMD_OPERATION_REPORT:
 		IWL_DEBUG_TEMP(mvm, "cTDP avg energy in mWatt = %d\n", status);
@@ -757,29 +781,6 @@ static void iwl_mvm_thermal_zone_register(struct iwl_mvm *mvm)
 		mvm->tz_device.temp_trips[i] = S16_MIN;
 }
 
-static const u32 iwl_mvm_cdev_budgets[] = {
-	2000,	/* cooling state 0 */
-	1800,	/* cooling state 1 */
-	1600,	/* cooling state 2 */
-	1400,	/* cooling state 3 */
-	1200,	/* cooling state 4 */
-	1000,	/* cooling state 5 */
-	900,	/* cooling state 6 */
-	800,	/* cooling state 7 */
-	700,	/* cooling state 8 */
-	650,	/* cooling state 9 */
-	600,	/* cooling state 10 */
-	550,	/* cooling state 11 */
-	500,	/* cooling state 12 */
-	450,	/* cooling state 13 */
-	400,	/* cooling state 14 */
-	350,	/* cooling state 15 */
-	300,	/* cooling state 16 */
-	250,	/* cooling state 17 */
-	200,	/* cooling state 18 */
-	150,	/* cooling state 19 */
-};
-
 static int iwl_mvm_tcool_get_max_state(struct thermal_cooling_device *cdev,
 				       unsigned long *state)
 {
@@ -797,6 +798,7 @@ static int iwl_mvm_tcool_get_cur_state(struct thermal_cooling_device *cdev,
 		return -EBUSY;
 
 	*state = mvm->cooling_dev.cur_state;
+
 	return 0;
 }
 
@@ -820,7 +822,7 @@ static int iwl_mvm_tcool_set_cur_state(struct thermal_cooling_device *cdev,
 	}
 
 	ret = iwl_mvm_ctdp_command(mvm, CTDP_CMD_OPERATION_START,
-				   iwl_mvm_cdev_budgets[new_state]);
+				   new_state);
 
 unlock:
 	mutex_unlock(&mvm->mutex);
-- 
2.5.0

