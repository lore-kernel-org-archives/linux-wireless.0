Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbbDBGlq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:46 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/31] iwlwifi: pcie: initialize trans_pcie->ref_count on configure()
Date: Thu,  2 Apr 2015 09:40:59 +0300
Message-Id: <1427956879-11725-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090418_118584_F3332F2C)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

ref_count is currently initialized on start_fw(). This causes
some issues in restart flow, as currently active references
(e.g. unclaimed command) will get cleared, resulting in
invalid reference accounting.

Move the ref_count initialization to the configure() trans op,
so it won't be re-initialized on restart.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index df0022e..39e3cf0 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -964,7 +964,6 @@ static int iwl_pcie_load_given_ucode_8000b(struct iwl_trans *trans,
 static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 				   const struct fw_img *fw, bool run_in_rfkill)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	int ret;
 	bool hw_rfkill;
 
@@ -994,9 +993,6 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
 		return ret;
 	}
 
-	/* init ref_count to 1 (should be cleared when ucode is loaded) */
-	trans_pcie->ref_count = 1;
-
 	/* make sure rfkill handshake bits are cleared */
 	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
 	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR,
@@ -1315,6 +1311,9 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 	trans_pcie->bc_table_dword = trans_cfg->bc_table_dword;
 	trans_pcie->scd_set_active = trans_cfg->scd_set_active;
 
+	/* init ref_count to 1 (should be cleared when ucode is loaded) */
+	trans_pcie->ref_count = 1;
+
 	/* Initialize NAPI here - it should be before registering to mac80211
 	 * in the opmode but after the HW struct is allocated.
 	 * As this function may be called again in some corner cases don't
-- 
1.9.1

