Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33422 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753349AbcGFKoc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:46 +0300
Message-Id: <1467801651-1816-51-git-send-email-luca@coelho.fi> (sfid-20160706_125025_240424_1045C90B)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 51/56] iwlwifi: centralize 64 bit HW registers write
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Move the write_prph_64 of pcie to be transport agnostic.
Add direct write as well, as it is needed for a000 HW.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-devtrace-io.h   | 35 ++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        | 27 +++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        |  3 ++
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       | 25 ++++++----------
 4 files changed, 74 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
index 27914ee..1dccae6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
@@ -1,6 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2009 - 2014 Intel Corporation. All rights reserved.
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -83,6 +84,23 @@ TRACE_EVENT(iwlwifi_dev_iowrite32,
 		  __get_str(dev), __entry->offs, __entry->val)
 );
 
+TRACE_EVENT(iwlwifi_dev_iowrite64,
+	TP_PROTO(const struct device *dev, u64 offs, u64 val),
+	TP_ARGS(dev, offs, val),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(u64, offs)
+		__field(u64, val)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->offs = offs;
+		__entry->val = val;
+	),
+	TP_printk("[%s] write io[%llu] = %llu)",
+		  __get_str(dev), __entry->offs, __entry->val)
+);
+
 TRACE_EVENT(iwlwifi_dev_iowrite_prph32,
 	TP_PROTO(const struct device *dev, u32 offs, u32 val),
 	TP_ARGS(dev, offs, val),
@@ -100,6 +118,23 @@ TRACE_EVENT(iwlwifi_dev_iowrite_prph32,
 		  __get_str(dev), __entry->offs, __entry->val)
 );
 
+TRACE_EVENT(iwlwifi_dev_iowrite_prph64,
+	TP_PROTO(const struct device *dev, u64 offs, u64 val),
+	TP_ARGS(dev, offs, val),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(u64, offs)
+		__field(u64, val)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->offs = offs;
+		__entry->val = val;
+	),
+	TP_printk("[%s] write PRPH[%llu] = %llu)",
+		  __get_str(dev), __entry->offs, __entry->val)
+);
+
 TRACE_EVENT(iwlwifi_dev_ioread_prph32,
 	TP_PROTO(const struct device *dev, u32 offs, u32 val),
 	TP_ARGS(dev, offs, val),
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index d8b4306..92c8b5f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -51,6 +51,14 @@ void iwl_write32(struct iwl_trans *trans, u32 ofs, u32 val)
 }
 IWL_EXPORT_SYMBOL(iwl_write32);
 
+void iwl_write64(struct iwl_trans *trans, u64 ofs, u64 val)
+{
+	trace_iwlwifi_dev_iowrite64(trans->dev, ofs, val);
+	iwl_trans_write32(trans, ofs, val & 0xffffffff);
+	iwl_trans_write32(trans, ofs + 4, val >> 32);
+}
+IWL_EXPORT_SYMBOL(iwl_write64);
+
 u32 iwl_read32(struct iwl_trans *trans, u32 ofs)
 {
 	u32 val = iwl_trans_read32(trans, ofs);
@@ -102,6 +110,17 @@ void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value)
 }
 IWL_EXPORT_SYMBOL(iwl_write_direct32);
 
+void iwl_write_direct64(struct iwl_trans *trans, u64 reg, u64 value)
+{
+	unsigned long flags;
+
+	if (iwl_trans_grab_nic_access(trans, &flags)) {
+		iwl_write64(trans, reg, value);
+		iwl_trans_release_nic_access(trans, &flags);
+	}
+}
+IWL_EXPORT_SYMBOL(iwl_write_direct64);
+
 int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
 			int timeout)
 {
@@ -133,6 +152,14 @@ void iwl_write_prph_no_grab(struct iwl_trans *trans, u32 ofs, u32 val)
 }
 IWL_EXPORT_SYMBOL(iwl_write_prph_no_grab);
 
+void iwl_write_prph64_no_grab(struct iwl_trans *trans, u64 ofs, u64 val)
+{
+	trace_iwlwifi_dev_iowrite_prph64(trans->dev, ofs, val);
+	iwl_write_prph_no_grab(trans, ofs, val & 0xffffffff);
+	iwl_write_prph_no_grab(trans, ofs + 4, val >> 32);
+}
+IWL_EXPORT_SYMBOL(iwl_write_prph64_no_grab);
+
 u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs)
 {
 	unsigned long flags;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
index a9bcc78..5c8c0e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
@@ -34,6 +34,7 @@
 
 void iwl_write8(struct iwl_trans *trans, u32 ofs, u8 val);
 void iwl_write32(struct iwl_trans *trans, u32 ofs, u32 val);
+void iwl_write64(struct iwl_trans *trans, u64 ofs, u64 val);
 u32 iwl_read32(struct iwl_trans *trans, u32 ofs);
 
 static inline void iwl_set_bit(struct iwl_trans *trans, u32 reg, u32 mask)
@@ -53,11 +54,13 @@ int iwl_poll_direct_bit(struct iwl_trans *trans, u32 addr, u32 mask,
 
 u32 iwl_read_direct32(struct iwl_trans *trans, u32 reg);
 void iwl_write_direct32(struct iwl_trans *trans, u32 reg, u32 value);
+void iwl_write_direct64(struct iwl_trans *trans, u64 reg, u64 value);
 
 
 u32 iwl_read_prph_no_grab(struct iwl_trans *trans, u32 ofs);
 u32 iwl_read_prph(struct iwl_trans *trans, u32 ofs);
 void iwl_write_prph_no_grab(struct iwl_trans *trans, u32 ofs, u32 val);
+void iwl_write_prph64_no_grab(struct iwl_trans *trans, u64 ofs, u64 val);
 void iwl_write_prph(struct iwl_trans *trans, u32 ofs, u32 val);
 int iwl_poll_prph_bit(struct iwl_trans *trans, u32 addr,
 		      u32 bits, u32 mask, int timeout);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 153b308..5c36e6d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -161,13 +161,6 @@ static inline __le32 iwl_pcie_dma_addr2rbd_ptr(dma_addr_t dma_addr)
 	return cpu_to_le32((u32)(dma_addr >> 8));
 }
 
-static void iwl_pcie_write_prph_64_no_grab(struct iwl_trans *trans, u64 ofs,
-					   u64 val)
-{
-	iwl_write_prph_no_grab(trans, ofs, val & 0xffffffff);
-	iwl_write_prph_no_grab(trans, ofs + 4, val >> 32);
-}
-
 /*
  * iwl_pcie_rx_stop - stops the Rx DMA
  */
@@ -817,17 +810,17 @@ static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
 
 	for (i = 0; i < trans->num_rx_queues; i++) {
 		/* Tell device where to find RBD free table in DRAM */
-		iwl_pcie_write_prph_64_no_grab(trans,
-					       RFH_Q_FRBDCB_BA_LSB(i),
-					       trans_pcie->rxq[i].bd_dma);
+		iwl_write_prph64_no_grab(trans,
+					 RFH_Q_FRBDCB_BA_LSB(i),
+					 trans_pcie->rxq[i].bd_dma);
 		/* Tell device where to find RBD used table in DRAM */
-		iwl_pcie_write_prph_64_no_grab(trans,
-					       RFH_Q_URBDCB_BA_LSB(i),
-					       trans_pcie->rxq[i].used_bd_dma);
+		iwl_write_prph64_no_grab(trans,
+					 RFH_Q_URBDCB_BA_LSB(i),
+					 trans_pcie->rxq[i].used_bd_dma);
 		/* Tell device where in DRAM to update its Rx status */
-		iwl_pcie_write_prph_64_no_grab(trans,
-					       RFH_Q_URBD_STTS_WPTR_LSB(i),
-					       trans_pcie->rxq[i].rb_stts_dma);
+		iwl_write_prph64_no_grab(trans,
+					 RFH_Q_URBD_STTS_WPTR_LSB(i),
+					 trans_pcie->rxq[i].rb_stts_dma);
 		/* Reset device indice tables */
 		iwl_write_prph_no_grab(trans, RFH_Q_FRBDCB_WIDX(i), 0);
 		iwl_write_prph_no_grab(trans, RFH_Q_FRBDCB_RIDX(i), 0);
-- 
2.8.1

