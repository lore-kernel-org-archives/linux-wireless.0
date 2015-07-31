Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1095 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbbGaEnR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 00:43:17 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 1/3] iwlwifi: pcie: fix prepare card flow
Date: Fri, 31 Jul 2015 07:43:11 +0300
Message-Id: <1438317793-7435-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150731_064321_224720_DFEC99A9)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7DC508@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7DC508@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the card is not owned by the PCIe bus, we need to
acquire ownership first. This flow is implemented in
iwl_pcie_prepare_card_hw. Because of a hardware bug, we
need to disable link power management before we can
request ownership otherwise the other user of the device
won't get notified that we are requesting the device which
will prevent us from acquire ownership.

Same holds for the down flow where we need to make sure
that any other potential user is notified that the driver
is going down.

CC: <stable@vger.kernel.org> [4.1]
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 6203c4a..9e144e7 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -478,10 +478,16 @@ static void iwl_pcie_apm_stop(struct iwl_trans *trans, bool op_mode_leave)
 		if (trans->cfg->device_family == IWL_DEVICE_FAMILY_7000)
 			iwl_set_bits_prph(trans, APMG_PCIDEV_STT_REG,
 					  APMG_PCIDEV_STT_VAL_WAKE_ME);
-		else if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000)
+		else if (trans->cfg->device_family == IWL_DEVICE_FAMILY_8000) {
+			iwl_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
+				    CSR_RESET_LINK_PWR_MGMT_DISABLED);
 			iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
 				    CSR_HW_IF_CONFIG_REG_PREPARE |
 				    CSR_HW_IF_CONFIG_REG_ENABLE_PME);
+			mdelay(1);
+			iwl_clear_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
+				      CSR_RESET_LINK_PWR_MGMT_DISABLED);
+		}
 		mdelay(5);
 	}
 
@@ -575,6 +581,10 @@ static int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 	if (ret >= 0)
 		return 0;
 
+	iwl_set_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
+		    CSR_RESET_LINK_PWR_MGMT_DISABLED);
+	msleep(1);
+
 	for (iter = 0; iter < 10; iter++) {
 		/* If HW is not ready, prepare the conditions to check again */
 		iwl_set_bit(trans, CSR_HW_IF_CONFIG_REG,
@@ -582,8 +592,10 @@ static int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 
 		do {
 			ret = iwl_pcie_set_hw_ready(trans);
-			if (ret >= 0)
-				return 0;
+			if (ret >= 0) {
+				ret = 0;
+				goto out;
+			}
 
 			usleep_range(200, 1000);
 			t += 200;
@@ -593,6 +605,10 @@ static int iwl_pcie_prepare_card_hw(struct iwl_trans *trans)
 
 	IWL_ERR(trans, "Couldn't prepare the card\n");
 
+out:
+	iwl_clear_bit(trans, CSR_DBG_LINK_PWR_MGMT_REG,
+		      CSR_RESET_LINK_PWR_MGMT_DISABLED);
+
 	return ret;
 }
 
-- 
2.1.4

