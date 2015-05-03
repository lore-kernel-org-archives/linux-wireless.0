Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbbECTdL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:33:11 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/42] iwlwifi: allow to limit the size of the external buffer for firmware debugging
Date: Sun,  3 May 2015 22:31:45 +0300
Message-Id: <1430681513-7838-34-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213345_796821_4263C2B0)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we use an external buffer, it is allocated from the
t DRAM and can be as big as 64MB. This buffer is huge and
might not be needed for the specific issue being chased.
Especially if lots of dumps are going to be created.
Allow to limit the size of the buffer in the configuration.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h |  8 +++++---
 drivers/net/wireless/iwlwifi/pcie/trans.c  | 28 +++++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 62db2e5..c7cfc38 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -436,6 +436,7 @@ enum iwl_fw_dbg_monitor_mode {
  *
  * @version: version of the TLV - currently 0
  * @monitor_mode: %enum iwl_fw_dbg_monitor_mode
+ * @size_power: buffer size will be 2^(size_power + 11)
  * @base_reg: addr of the base addr register (PRPH)
  * @end_reg:  addr of the end addr register (PRPH)
  * @write_ptr_reg: the addr of the reg of the write pointer
@@ -449,7 +450,8 @@ enum iwl_fw_dbg_monitor_mode {
 struct iwl_fw_dbg_dest_tlv {
 	u8 version;
 	u8 monitor_mode;
-	u8 reserved[2];
+	u8 size_power;
+	u8 reserved;
 	__le32 base_reg;
 	__le32 end_reg;
 	__le32 write_ptr_reg;
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index d108e5b..4526336 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -101,14 +101,26 @@ static void iwl_pcie_free_fw_monitor(struct iwl_trans *trans)
 	trans_pcie->fw_mon_size = 0;
 }
 
-static void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans)
+static void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans, u8 max_power)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct page *page = NULL;
 	dma_addr_t phys;
-	u32 size;
+	u32 size = 0;
 	u8 power;
 
+	if (!max_power) {
+		/* default max_power is maximum */
+		max_power = 26;
+	} else {
+		max_power += 11;
+	}
+
+	if (WARN(max_power > 26,
+		 "External buffer size for monitor is too big %d, check the FW TLV\n",
+		 max_power))
+		return;
+
 	if (trans_pcie->fw_mon_page) {
 		dma_sync_single_for_device(trans->dev, trans_pcie->fw_mon_phys,
 					   trans_pcie->fw_mon_size,
@@ -117,7 +129,7 @@ static void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans)
 	}
 
 	phys = 0;
-	for (power = 26; power >= 11; power--) {
+	for (power = max_power; power >= 11; power--) {
 		int order;
 
 		size = BIT(power);
@@ -143,6 +155,12 @@ static void iwl_pcie_alloc_fw_monitor(struct iwl_trans *trans)
 	if (WARN_ON_ONCE(!page))
 		return;
 
+	if (power != max_power)
+		IWL_ERR(trans,
+			"Sorry - debug buffer is only %luK while you requested %luK\n",
+			(unsigned long)BIT(power - 10),
+			(unsigned long)BIT(max_power - 10));
+
 	trans_pcie->fw_mon_page = page;
 	trans_pcie->fw_mon_phys = phys;
 	trans_pcie->fw_mon_size = size;
@@ -834,7 +852,7 @@ static void iwl_pcie_apply_destination(struct iwl_trans *trans)
 		 get_fw_dbg_mode_string(dest->monitor_mode));
 
 	if (dest->monitor_mode == EXTERNAL_MODE)
-		iwl_pcie_alloc_fw_monitor(trans);
+		iwl_pcie_alloc_fw_monitor(trans, dest->size_power);
 	else
 		IWL_WARN(trans, "PCI should have external buffer debug\n");
 
@@ -908,7 +926,7 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 	/* supported for 7000 only for the moment */
 	if (iwlwifi_mod_params.fw_monitor &&
 	    trans->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
-		iwl_pcie_alloc_fw_monitor(trans);
+		iwl_pcie_alloc_fw_monitor(trans, 0);
 
 		if (trans_pcie->fw_mon_size) {
 			iwl_write_prph(trans, MON_BUFF_BASE_ADDR,
-- 
2.1.0

