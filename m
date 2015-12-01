Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755862AbbLAJ7h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:37 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Golan Ben-Ami <golan.ben.ami@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/41] iwlwifi: export the _no_grab version of PRPH IO functions
Date: Tue,  1 Dec 2015 11:58:46 +0200
Message-Id: <1448963947-24302-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_105948_161895_0EA2FD91)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben-Ami <golan.ben.ami@intel.com>

Expose _no_grab prph i/o functions that allow performing i/o
outside the transport, without requiring grab and release NIC access
for each operation. In addition, rename the functions so they reflect
their non-grabbing behavior.

This can be very useful for consecutive prph i/o operation that occur
outside trans, such as fw dumps.

Signed-off-by: Golan Ben-Ami <golan.ben.ami@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-io.c     | 25 +++++++++++++++----------
 drivers/net/wireless/intel/iwlwifi/iwl-io.h     |  4 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 13 +++++++------
 3 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index 0bd9d4a..603c894 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * Portions of this file are derived from the ipw3945 project.
  *
@@ -117,18 +118,20 @@ int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
 }
 IWL_EXPORT_SYMBOL(iwl_poll_direct_bit);
 
-u32 __iwl_read_prph(struct iwl_trans *trans, u32 ofs)
+u32 iwl_read_prph_no_grab(struct iwl_trans *trans, u32 ofs)
 {
 	u32 val = iwl_trans_read_prph(trans, ofs);
 	trace_iwlwifi_dev_ioread_prph32(trans->dev, ofs, val);
 	return val;
 }
+IWL_EXPORT_SYMBOL(iwl_read_prph_no_grab);
 
-void __iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
+void iwl_write_prph_no_grab(struct iwl_trans *trans, u32 ofs, u32 val)
 {
 	trace_iwlwifi_dev_iowrite_prph32(trans->dev, ofs, val);
 	iwl_trans_write_prph(trans, ofs, val);
 }
+IWL_EXPORT_SYMBOL(iwl_write_prph_no_grab);
 
 u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs)
 {
@@ -136,7 +139,7 @@ u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs)
 	u32 val = 0x5a5a5a5a;
 
 	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
-		val = __iwl_read_prph(trans, ofs);
+		val = iwl_read_prph_no_grab(trans, ofs);
 		iwl_trans_release_nic_access(trans, &flags);
 	}
 	return val;
@@ -148,7 +151,7 @@ void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val)
 	unsigned long flags;
 
 	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
-		__iwl_write_prph(trans, ofs, val);
+		iwl_write_prph_no_grab(trans, ofs, val);
 		iwl_trans_release_nic_access(trans, &flags);
 	}
 }
@@ -174,8 +177,9 @@ void iwl_set_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 	unsigned long flags;
 
 	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
-		__iwl_write_prph(trans, ofs,
-				 __iwl_read_prph(trans, ofs) | mask);
+		iwl_write_prph_no_grab(trans, ofs,
+				       iwl_read_prph_no_grab(trans, ofs) |
+				       mask);
 		iwl_trans_release_nic_access(trans, &flags);
 	}
 }
@@ -187,8 +191,9 @@ void iwl_set_bits_mask_prph(struct iwl_trans *trans, u32 ofs,
 	unsigned long flags;
 
 	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
-		__iwl_write_prph(trans, ofs,
-				 (__iwl_read_prph(trans, ofs) & mask) | bits);
+		iwl_write_prph_no_grab(trans, ofs,
+				       (iwl_read_prph_no_grab(trans, ofs) &
+					mask) | bits);
 		iwl_trans_release_nic_access(trans, &flags);
 	}
 }
@@ -200,8 +205,8 @@ void iwl_clear_bits_prph(struct iwl_trans *trans, u32 ofs, u32 mask)
 	u32 val;
 
 	if (iwl_trans_grab_nic_access(trans, false, &flags)) {
-		val = __iwl_read_prph(trans, ofs);
-		__iwl_write_prph(trans, ofs, (val & ~mask));
+		val = iwl_read_prph_no_grab(trans, ofs);
+		iwl_write_prph_no_grab(trans, ofs, (val & ~mask));
 		iwl_trans_release_nic_access(trans, &flags);
 	}
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index 501d056..2f4e12c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -55,9 +55,9 @@ u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg);
 void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value);
 
 
-u32 __iwl_read_prph(struct iwl_trans *trans, u32 ofs);
+u32 iwl_read_prph_no_grab(struct iwl_trans *trans, u32 ofs);
 u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs);
-void __iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val);
+void iwl_write_prph_no_grab(struct iwl_trans *trans, u32 ofs, u32 val);
 void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val);
 int iwl_poll_prph_bit(struct iwl_trans *trans, u32 addr,
 		      u32 bits, u32 mask, int timeout);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 889227c..3c9035d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2382,10 +2382,11 @@ iwl_trans_pci_dump_marbh_monitor(struct iwl_trans *trans,
 	if (!iwl_trans_grab_nic_access(trans, false, &flags))
 		return 0;
 
-	__iwl_write_prph(trans, MON_DMARB_RD_CTL_ADDR, 0x1);
+	iwl_write_prph_no_grab(trans, MON_DMARB_RD_CTL_ADDR, 0x1);
 	for (i = 0; i < buf_size_in_dwords; i++)
-		buffer[i] = __iwl_read_prph(trans, MON_DMARB_RD_DATA_ADDR);
-	__iwl_write_prph(trans, MON_DMARB_RD_CTL_ADDR, 0x0);
+		buffer[i] = iwl_read_prph_no_grab(trans,
+				MON_DMARB_RD_DATA_ADDR);
+	iwl_write_prph_no_grab(trans, MON_DMARB_RD_CTL_ADDR, 0x0);
 
 	iwl_trans_release_nic_access(trans, &flags);
 
@@ -2773,10 +2774,10 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 		if (iwl_trans_grab_nic_access(trans, false, &flags)) {
 			u32 hw_step;
 
-			hw_step = __iwl_read_prph(trans, WFPM_CTRL_REG);
+			hw_step = iwl_read_prph_no_grab(trans, WFPM_CTRL_REG);
 			hw_step |= ENABLE_WFPM;
-			__iwl_write_prph(trans, WFPM_CTRL_REG, hw_step);
-			hw_step = __iwl_read_prph(trans, AUX_MISC_REG);
+			iwl_write_prph_no_grab(trans, WFPM_CTRL_REG, hw_step);
+			hw_step = iwl_read_prph_no_grab(trans, AUX_MISC_REG);
 			hw_step = (hw_step >> HW_STEP_LOCATION_BITS) & 0xF;
 			if (hw_step == 0x3)
 				trans->hw_rev = (trans->hw_rev & 0xFFFFFFF3) |
-- 
2.5.0

