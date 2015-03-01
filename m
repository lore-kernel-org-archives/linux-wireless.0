Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbbCATcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:12 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/31] iwlwifi: pcie: apply destination before releasing reset
Date: Sun,  1 Mar 2015 21:31:24 +0200
Message-Id: <1425238304-498-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203418_684245_02F96DCA)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows to use the firmware debugging system even when
the configuration values are set hard coded in the firmware.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 69935aa..f31a941 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -898,6 +898,9 @@ static int iwl_pcie_load_given_ucode_8000b(struct iwl_trans *trans,
 	IWL_DEBUG_FW(trans, "working with %s CPU\n",
 		     image->is_dual_cpus ? "Dual" : "Single");
 
+	if (trans->dbg_dest_tlv)
+		iwl_pcie_apply_destination(trans);
+
 	/* configure the ucode to be ready to get the secured image */
 	/* release CPU reset */
 	iwl_write_prph(trans, RELEASE_CPU_RESET, RELEASE_CPU_RESET_BIT);
@@ -914,9 +917,6 @@ static int iwl_pcie_load_given_ucode_8000b(struct iwl_trans *trans,
 	if (ret)
 		return ret;
 
-	if (trans->dbg_dest_tlv)
-		iwl_pcie_apply_destination(trans);
-
 	/* wait for image verification to complete  */
 	ret = iwl_poll_prph_bit(trans, LMPM_SECURE_BOOT_CPU1_STATUS_ADDR_B0,
 				LMPM_SECURE_BOOT_STATUS_SUCCESS,
-- 
1.9.1

