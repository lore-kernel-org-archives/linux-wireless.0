Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36212 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752584AbdF2Sai (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 14:30:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Jun 2017 21:30:14 +0300
Message-Id: <20170629183027.15408-3-luca@coelho.fi> (sfid-20170629_203050_349611_6295D037)
In-Reply-To: <20170629183027.15408-1-luca@coelho.fi>
References: <20170629183027.15408-1-luca@coelho.fi>
Subject: [PATCH 02/15] iwlwifi: pcie: add MSI-X interrupt tracing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We have tracing for both pre-ICT and ICT interrupts, including all
the data read there. Extend the tracing to MSI-X interrupts.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/iwl-devtrace-io.h   | 26 +++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  4 ++++
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
index 1dccae6532cf..4164dc1745ed 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h
@@ -1,7 +1,7 @@
 /******************************************************************************
  *
  * Copyright(c) 2009 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016-2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of version 2 of the GNU General Public License as
@@ -29,6 +29,7 @@
 #define __IWLWIFI_DEVICE_TRACE_IO
 
 #include <linux/tracepoint.h>
+#include <linux/pci.h>
 
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlwifi_io
@@ -165,6 +166,29 @@ TRACE_EVENT(iwlwifi_dev_irq,
 	TP_printk("%d", 0)
 );
 
+TRACE_EVENT(iwlwifi_dev_irq_msix,
+	TP_PROTO(const struct device *dev, struct msix_entry *msix_entry,
+		 bool defirq, u32 inta_fh, u32 inta_hw),
+	TP_ARGS(dev, msix_entry, defirq, inta_fh, inta_hw),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(u32, entry)
+		__field(u8, defirq)
+		__field(u32, inta_fh)
+		__field(u32, inta_hw)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->entry = msix_entry->entry;
+		__entry->defirq = defirq;
+		__entry->inta_fh = inta_fh;
+		__entry->inta_hw = inta_hw;
+	),
+	TP_printk("entry:%d defirq:%d fh:0x%x, hw:0x%x",
+		  __entry->entry, __entry->defirq,
+		  __entry->inta_fh, __entry->inta_hw)
+);
+
 TRACE_EVENT(iwlwifi_dev_ict_read,
 	TP_PROTO(const struct device *dev, u32 index, u32 value),
 	TP_ARGS(dev, index, value),
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 1618a59a8a2f..351c4423125a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1391,6 +1391,8 @@ irqreturn_t iwl_pcie_irq_rx_msix_handler(int irq, void *dev_id)
 	struct iwl_trans_pcie *trans_pcie = iwl_pcie_get_trans_pcie(entry);
 	struct iwl_trans *trans = trans_pcie->trans;
 
+	trace_iwlwifi_dev_irq_msix(trans->dev, entry, false, 0, 0);
+
 	if (WARN_ON(entry->entry >= trans->num_rx_queues))
 		return IRQ_NONE;
 
@@ -1932,6 +1934,8 @@ irqreturn_t iwl_pcie_irq_msix_handler(int irq, void *dev_id)
 	iwl_write32(trans, CSR_MSIX_HW_INT_CAUSES_AD, inta_hw);
 	spin_unlock(&trans_pcie->irq_lock);
 
+	trace_iwlwifi_dev_irq_msix(trans->dev, entry, true, inta_fh, inta_hw);
+
 	if (unlikely(!(inta_fh | inta_hw))) {
 		IWL_DEBUG_ISR(trans, "Ignore interrupt, inta == 0\n");
 		lock_map_release(&trans->sync_cmd_lockdep_map);
-- 
2.11.0
