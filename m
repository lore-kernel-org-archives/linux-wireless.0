Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab0CJFWB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:01 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/24] iwlagn: move ICT code into separate file
Date: Tue,  9 Mar 2010 21:21:29 -0800
Message-Id: <1268198512-6572-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

All the ICT ISR code is iwlagn specific, and doesn't
need to be in iwlcore. So create a new iwl-agn.h
header file that will hold agn specific function
declarations etc., and move the ICT code into a new
iwl-agn-ict.c file that is linked into iwlagn. This
also gets rid of exporting those symbols.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-ict.c |  303 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.h     |   74 +++++++
 drivers/net/wireless/iwlwifi/iwl-core.c    |  273 -------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    5 -
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    3 +
 10 files changed, 385 insertions(+), 279 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-ict.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn.h

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 4e378fa..e31a5cc 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -9,7 +9,7 @@ CFLAGS_iwl-devtrace.o := -I$(src)
 
 # AGN
 obj-$(CONFIG_IWLAGN)	+= iwlagn.o
-iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o
+iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-led.o iwl-agn-ict.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 3bf2e6e..59b092e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -42,6 +42,7 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-sta.h"
+#include "iwl-agn.h"
 #include "iwl-helpers.h"
 #include "iwl-5000-hw.h"
 #include "iwl-agn-led.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e476acb..f59628c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -43,6 +43,7 @@
 #include "iwl-io.h"
 #include "iwl-sta.h"
 #include "iwl-helpers.h"
+#include "iwl-agn.h"
 #include "iwl-agn-led.h"
 #include "iwl-5000-hw.h"
 #include "iwl-6000-hw.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index c4844ad..4b7bc00 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -42,6 +42,7 @@
 #include "iwl-core.h"
 #include "iwl-io.h"
 #include "iwl-sta.h"
+#include "iwl-agn.h"
 #include "iwl-helpers.h"
 #include "iwl-5000-hw.h"
 #include "iwl-6000-hw.h"
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ict.c b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
new file mode 100644
index 0000000..d6b028b
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ict.c
@@ -0,0 +1,303 @@
+/******************************************************************************
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/etherdevice.h>
+#include <linux/sched.h>
+#include <net/mac80211.h>
+
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-agn.h"
+#include "iwl-helpers.h"
+
+#define ICT_COUNT (PAGE_SIZE/sizeof(u32))
+
+/* Free dram table */
+void iwl_free_isr_ict(struct iwl_priv *priv)
+{
+	if (priv->ict_tbl_vir) {
+		dma_free_coherent(&priv->pci_dev->dev,
+				  (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
+				  priv->ict_tbl_vir, priv->ict_tbl_dma);
+		priv->ict_tbl_vir = NULL;
+	}
+}
+
+
+/* allocate dram shared table it is a PAGE_SIZE aligned
+ * also reset all data related to ICT table interrupt.
+ */
+int iwl_alloc_isr_ict(struct iwl_priv *priv)
+{
+
+	if (priv->cfg->use_isr_legacy)
+		return 0;
+	/* allocate shrared data table */
+	priv->ict_tbl_vir = dma_alloc_coherent(&priv->pci_dev->dev,
+					       (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
+					       &priv->ict_tbl_dma, GFP_KERNEL);
+	if (!priv->ict_tbl_vir)
+		return -ENOMEM;
+
+	/* align table to PAGE_SIZE boundry */
+	priv->aligned_ict_tbl_dma = ALIGN(priv->ict_tbl_dma, PAGE_SIZE);
+
+	IWL_DEBUG_ISR(priv, "ict dma addr %Lx dma aligned %Lx diff %d\n",
+			     (unsigned long long)priv->ict_tbl_dma,
+			     (unsigned long long)priv->aligned_ict_tbl_dma,
+			(int)(priv->aligned_ict_tbl_dma - priv->ict_tbl_dma));
+
+	priv->ict_tbl =  priv->ict_tbl_vir +
+			  (priv->aligned_ict_tbl_dma - priv->ict_tbl_dma);
+
+	IWL_DEBUG_ISR(priv, "ict vir addr %p vir aligned %p diff %d\n",
+			     priv->ict_tbl, priv->ict_tbl_vir,
+			(int)(priv->aligned_ict_tbl_dma - priv->ict_tbl_dma));
+
+	/* reset table and index to all 0 */
+	memset(priv->ict_tbl_vir,0, (sizeof(u32) * ICT_COUNT) + PAGE_SIZE);
+	priv->ict_index = 0;
+
+	/* add periodic RX interrupt */
+	priv->inta_mask |= CSR_INT_BIT_RX_PERIODIC;
+	return 0;
+}
+
+/* Device is going up inform it about using ICT interrupt table,
+ * also we need to tell the driver to start using ICT interrupt.
+ */
+int iwl_reset_ict(struct iwl_priv *priv)
+{
+	u32 val;
+	unsigned long flags;
+
+	if (!priv->ict_tbl_vir)
+		return 0;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl_disable_interrupts(priv);
+
+	memset(&priv->ict_tbl[0], 0, sizeof(u32) * ICT_COUNT);
+
+	val = priv->aligned_ict_tbl_dma >> PAGE_SHIFT;
+
+	val |= CSR_DRAM_INT_TBL_ENABLE;
+	val |= CSR_DRAM_INIT_TBL_WRAP_CHECK;
+
+	IWL_DEBUG_ISR(priv, "CSR_DRAM_INT_TBL_REG =0x%X "
+			"aligned dma address %Lx\n",
+			val, (unsigned long long)priv->aligned_ict_tbl_dma);
+
+	iwl_write32(priv, CSR_DRAM_INT_TBL_REG, val);
+	priv->use_ict = true;
+	priv->ict_index = 0;
+	iwl_write32(priv, CSR_INT, priv->inta_mask);
+	iwl_enable_interrupts(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+
+/* Device is going down disable ict interrupt usage */
+void iwl_disable_ict(struct iwl_priv *priv)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->use_ict = false;
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+static irqreturn_t iwl_isr(int irq, void *data)
+{
+	struct iwl_priv *priv = data;
+	u32 inta, inta_mask;
+#ifdef CONFIG_IWLWIFI_DEBUG
+	u32 inta_fh;
+#endif
+	if (!priv)
+		return IRQ_NONE;
+
+	spin_lock(&priv->lock);
+
+	/* Disable (but don't clear!) interrupts here to avoid
+	 *    back-to-back ISRs and sporadic interrupts from our NIC.
+	 * If we have something to service, the tasklet will re-enable ints.
+	 * If we *don't* have something, we'll re-enable before leaving here. */
+	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
+	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
+
+	/* Discover which interrupts are active/pending */
+	inta = iwl_read32(priv, CSR_INT);
+
+	/* Ignore interrupt if there's nothing in NIC to service.
+	 * This may be due to IRQ shared with another device,
+	 * or due to sporadic interrupts thrown from our NIC. */
+	if (!inta) {
+		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0\n");
+		goto none;
+	}
+
+	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
+		/* Hardware disappeared. It might have already raised
+		 * an interrupt */
+		IWL_WARN(priv, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
+		goto unplugged;
+	}
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
+		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
+		IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x, "
+			      "fh 0x%08x\n", inta, inta_mask, inta_fh);
+	}
+#endif
+
+	priv->inta |= inta;
+	/* iwl_irq_tasklet() will service interrupts and re-enable them */
+	if (likely(inta))
+		tasklet_schedule(&priv->irq_tasklet);
+	else if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
+		iwl_enable_interrupts(priv);
+
+ unplugged:
+	spin_unlock(&priv->lock);
+	return IRQ_HANDLED;
+
+ none:
+	/* re-enable interrupts here since we don't have anything to service. */
+	/* only Re-enable if diabled by irq  and no schedules tasklet. */
+	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
+		iwl_enable_interrupts(priv);
+
+	spin_unlock(&priv->lock);
+	return IRQ_NONE;
+}
+
+/* interrupt handler using ict table, with this interrupt driver will
+ * stop using INTA register to get device's interrupt, reading this register
+ * is expensive, device will write interrupts in ICT dram table, increment
+ * index then will fire interrupt to driver, driver will OR all ICT table
+ * entries from current index up to table entry with 0 value. the result is
+ * the interrupt we need to service, driver will set the entries back to 0 and
+ * set index.
+ */
+irqreturn_t iwl_isr_ict(int irq, void *data)
+{
+	struct iwl_priv *priv = data;
+	u32 inta, inta_mask;
+	u32 val = 0;
+
+	if (!priv)
+		return IRQ_NONE;
+
+	/* dram interrupt table not set yet,
+	 * use legacy interrupt.
+	 */
+	if (!priv->use_ict)
+		return iwl_isr(irq, data);
+
+	spin_lock(&priv->lock);
+
+	/* Disable (but don't clear!) interrupts here to avoid
+	 * back-to-back ISRs and sporadic interrupts from our NIC.
+	 * If we have something to service, the tasklet will re-enable ints.
+	 * If we *don't* have something, we'll re-enable before leaving here.
+	 */
+	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
+	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
+
+
+	/* Ignore interrupt if there's nothing in NIC to service.
+	 * This may be due to IRQ shared with another device,
+	 * or due to sporadic interrupts thrown from our NIC. */
+	if (!priv->ict_tbl[priv->ict_index]) {
+		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0\n");
+		goto none;
+	}
+
+	/* read all entries that not 0 start with ict_index */
+	while (priv->ict_tbl[priv->ict_index]) {
+
+		val |= le32_to_cpu(priv->ict_tbl[priv->ict_index]);
+		IWL_DEBUG_ISR(priv, "ICT index %d value 0x%08X\n",
+				priv->ict_index,
+				le32_to_cpu(priv->ict_tbl[priv->ict_index]));
+		priv->ict_tbl[priv->ict_index] = 0;
+		priv->ict_index = iwl_queue_inc_wrap(priv->ict_index,
+						     ICT_COUNT);
+
+	}
+
+	/* We should not get this value, just ignore it. */
+	if (val == 0xffffffff)
+		val = 0;
+
+	/*
+	 * this is a w/a for a h/w bug. the h/w bug may cause the Rx bit
+	 * (bit 15 before shifting it to 31) to clear when using interrupt
+	 * coalescing. fortunately, bits 18 and 19 stay set when this happens
+	 * so we use them to decide on the real state of the Rx bit.
+	 * In order words, bit 15 is set if bit 18 or bit 19 are set.
+	 */
+	if (val & 0xC0000)
+		val |= 0x8000;
+
+	inta = (0xff & val) | ((0xff00 & val) << 16);
+	IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x ict 0x%08x\n",
+			inta, inta_mask, val);
+
+	inta &= priv->inta_mask;
+	priv->inta |= inta;
+
+	/* iwl_irq_tasklet() will service interrupts and re-enable them */
+	if (likely(inta))
+		tasklet_schedule(&priv->irq_tasklet);
+	else if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta) {
+		/* Allow interrupt if was disabled by this handler and
+		 * no tasklet was schedules, We should not enable interrupt,
+		 * tasklet will enable it.
+		 */
+		iwl_enable_interrupts(priv);
+	}
+
+	spin_unlock(&priv->lock);
+	return IRQ_HANDLED;
+
+ none:
+	/* re-enable interrupts here since we don't have anything to service.
+	 * only Re-enable if disabled by irq.
+	 */
+	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
+		iwl_enable_interrupts(priv);
+
+	spin_unlock(&priv->lock);
+	return IRQ_NONE;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 47b0214..d7b8e44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -54,6 +54,7 @@
 #include "iwl-helpers.h"
 #include "iwl-sta.h"
 #include "iwl-calib.h"
+#include "iwl-agn.h"
 
 
 /******************************************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
new file mode 100644
index 0000000..26eeb58
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -0,0 +1,74 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 - 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *****************************************************************************/
+
+#ifndef __iwl_agn_h__
+#define __iwl_agn_h__
+
+#include "iwl-dev.h"
+
+int iwl_reset_ict(struct iwl_priv *priv);
+void iwl_disable_ict(struct iwl_priv *priv);
+int iwl_alloc_isr_ict(struct iwl_priv *priv);
+void iwl_free_isr_ict(struct iwl_priv *priv);
+irqreturn_t iwl_isr_ict(int irq, void *data);
+
+#endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 112149e..b994eee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -114,8 +114,6 @@ static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
 u32 iwl_debug_level;
 EXPORT_SYMBOL(iwl_debug_level);
 
-static irqreturn_t iwl_isr(int irq, void *data);
-
 /*
  * Parameter order:
  *   rate, ht rate, prev rate, next rate, prev tgg rate, next tgg rate
@@ -1664,277 +1662,6 @@ int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 }
 EXPORT_SYMBOL(iwl_set_tx_power);
 
-#define ICT_COUNT (PAGE_SIZE/sizeof(u32))
-
-/* Free dram table */
-void iwl_free_isr_ict(struct iwl_priv *priv)
-{
-	if (priv->ict_tbl_vir) {
-		dma_free_coherent(&priv->pci_dev->dev,
-				  (sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
-				  priv->ict_tbl_vir, priv->ict_tbl_dma);
-		priv->ict_tbl_vir = NULL;
-	}
-}
-EXPORT_SYMBOL(iwl_free_isr_ict);
-
-
-/* allocate dram shared table it is a PAGE_SIZE aligned
- * also reset all data related to ICT table interrupt.
- */
-int iwl_alloc_isr_ict(struct iwl_priv *priv)
-{
-
-	if (priv->cfg->use_isr_legacy)
-		return 0;
-	/* allocate shrared data table */
-	priv->ict_tbl_vir = dma_alloc_coherent(&priv->pci_dev->dev,
-					(sizeof(u32) * ICT_COUNT) + PAGE_SIZE,
-					&priv->ict_tbl_dma, GFP_KERNEL);
-	if (!priv->ict_tbl_vir)
-		return -ENOMEM;
-
-	/* align table to PAGE_SIZE boundry */
-	priv->aligned_ict_tbl_dma = ALIGN(priv->ict_tbl_dma, PAGE_SIZE);
-
-	IWL_DEBUG_ISR(priv, "ict dma addr %Lx dma aligned %Lx diff %d\n",
-			     (unsigned long long)priv->ict_tbl_dma,
-			     (unsigned long long)priv->aligned_ict_tbl_dma,
-			(int)(priv->aligned_ict_tbl_dma - priv->ict_tbl_dma));
-
-	priv->ict_tbl =  priv->ict_tbl_vir +
-			  (priv->aligned_ict_tbl_dma - priv->ict_tbl_dma);
-
-	IWL_DEBUG_ISR(priv, "ict vir addr %p vir aligned %p diff %d\n",
-			     priv->ict_tbl, priv->ict_tbl_vir,
-			(int)(priv->aligned_ict_tbl_dma - priv->ict_tbl_dma));
-
-	/* reset table and index to all 0 */
-	memset(priv->ict_tbl_vir,0, (sizeof(u32) * ICT_COUNT) + PAGE_SIZE);
-	priv->ict_index = 0;
-
-	/* add periodic RX interrupt */
-	priv->inta_mask |= CSR_INT_BIT_RX_PERIODIC;
-	return 0;
-}
-EXPORT_SYMBOL(iwl_alloc_isr_ict);
-
-/* Device is going up inform it about using ICT interrupt table,
- * also we need to tell the driver to start using ICT interrupt.
- */
-int iwl_reset_ict(struct iwl_priv *priv)
-{
-	u32 val;
-	unsigned long flags;
-
-	if (!priv->ict_tbl_vir)
-		return 0;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_disable_interrupts(priv);
-
-	memset(&priv->ict_tbl[0], 0, sizeof(u32) * ICT_COUNT);
-
-	val = priv->aligned_ict_tbl_dma >> PAGE_SHIFT;
-
-	val |= CSR_DRAM_INT_TBL_ENABLE;
-	val |= CSR_DRAM_INIT_TBL_WRAP_CHECK;
-
-	IWL_DEBUG_ISR(priv, "CSR_DRAM_INT_TBL_REG =0x%X "
-			"aligned dma address %Lx\n",
-			val, (unsigned long long)priv->aligned_ict_tbl_dma);
-
-	iwl_write32(priv, CSR_DRAM_INT_TBL_REG, val);
-	priv->use_ict = true;
-	priv->ict_index = 0;
-	iwl_write32(priv, CSR_INT, priv->inta_mask);
-	iwl_enable_interrupts(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return 0;
-}
-EXPORT_SYMBOL(iwl_reset_ict);
-
-/* Device is going down disable ict interrupt usage */
-void iwl_disable_ict(struct iwl_priv *priv)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->use_ict = false;
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
-EXPORT_SYMBOL(iwl_disable_ict);
-
-/* interrupt handler using ict table, with this interrupt driver will
- * stop using INTA register to get device's interrupt, reading this register
- * is expensive, device will write interrupts in ICT dram table, increment
- * index then will fire interrupt to driver, driver will OR all ICT table
- * entries from current index up to table entry with 0 value. the result is
- * the interrupt we need to service, driver will set the entries back to 0 and
- * set index.
- */
-irqreturn_t iwl_isr_ict(int irq, void *data)
-{
-	struct iwl_priv *priv = data;
-	u32 inta, inta_mask;
-	u32 val = 0;
-
-	if (!priv)
-		return IRQ_NONE;
-
-	/* dram interrupt table not set yet,
-	 * use legacy interrupt.
-	 */
-	if (!priv->use_ict)
-		return iwl_isr(irq, data);
-
-	spin_lock(&priv->lock);
-
-	/* Disable (but don't clear!) interrupts here to avoid
-	 * back-to-back ISRs and sporadic interrupts from our NIC.
-	 * If we have something to service, the tasklet will re-enable ints.
-	 * If we *don't* have something, we'll re-enable before leaving here.
-	 */
-	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
-	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
-
-
-	/* Ignore interrupt if there's nothing in NIC to service.
-	 * This may be due to IRQ shared with another device,
-	 * or due to sporadic interrupts thrown from our NIC. */
-	if (!priv->ict_tbl[priv->ict_index]) {
-		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0\n");
-		goto none;
-	}
-
-	/* read all entries that not 0 start with ict_index */
-	while (priv->ict_tbl[priv->ict_index]) {
-
-		val |= le32_to_cpu(priv->ict_tbl[priv->ict_index]);
-		IWL_DEBUG_ISR(priv, "ICT index %d value 0x%08X\n",
-				priv->ict_index,
-				le32_to_cpu(priv->ict_tbl[priv->ict_index]));
-		priv->ict_tbl[priv->ict_index] = 0;
-		priv->ict_index = iwl_queue_inc_wrap(priv->ict_index,
-						     ICT_COUNT);
-
-	}
-
-	/* We should not get this value, just ignore it. */
-	if (val == 0xffffffff)
-		val = 0;
-
-	/*
-	 * this is a w/a for a h/w bug. the h/w bug may cause the Rx bit
-	 * (bit 15 before shifting it to 31) to clear when using interrupt
-	 * coalescing. fortunately, bits 18 and 19 stay set when this happens
-	 * so we use them to decide on the real state of the Rx bit.
-	 * In order words, bit 15 is set if bit 18 or bit 19 are set.
-	 */
-	if (val & 0xC0000)
-		val |= 0x8000;
-
-	inta = (0xff & val) | ((0xff00 & val) << 16);
-	IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x ict 0x%08x\n",
-			inta, inta_mask, val);
-
-	inta &= priv->inta_mask;
-	priv->inta |= inta;
-
-	/* iwl_irq_tasklet() will service interrupts and re-enable them */
-	if (likely(inta))
-		tasklet_schedule(&priv->irq_tasklet);
-	else if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta) {
-		/* Allow interrupt if was disabled by this handler and
-		 * no tasklet was schedules, We should not enable interrupt,
-		 * tasklet will enable it.
-		 */
-		iwl_enable_interrupts(priv);
-	}
-
-	spin_unlock(&priv->lock);
-	return IRQ_HANDLED;
-
- none:
-	/* re-enable interrupts here since we don't have anything to service.
-	 * only Re-enable if disabled by irq.
-	 */
-	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
-		iwl_enable_interrupts(priv);
-
-	spin_unlock(&priv->lock);
-	return IRQ_NONE;
-}
-EXPORT_SYMBOL(iwl_isr_ict);
-
-
-static irqreturn_t iwl_isr(int irq, void *data)
-{
-	struct iwl_priv *priv = data;
-	u32 inta, inta_mask;
-#ifdef CONFIG_IWLWIFI_DEBUG
-	u32 inta_fh;
-#endif
-	if (!priv)
-		return IRQ_NONE;
-
-	spin_lock(&priv->lock);
-
-	/* Disable (but don't clear!) interrupts here to avoid
-	 *    back-to-back ISRs and sporadic interrupts from our NIC.
-	 * If we have something to service, the tasklet will re-enable ints.
-	 * If we *don't* have something, we'll re-enable before leaving here. */
-	inta_mask = iwl_read32(priv, CSR_INT_MASK);  /* just for debug */
-	iwl_write32(priv, CSR_INT_MASK, 0x00000000);
-
-	/* Discover which interrupts are active/pending */
-	inta = iwl_read32(priv, CSR_INT);
-
-	/* Ignore interrupt if there's nothing in NIC to service.
-	 * This may be due to IRQ shared with another device,
-	 * or due to sporadic interrupts thrown from our NIC. */
-	if (!inta) {
-		IWL_DEBUG_ISR(priv, "Ignore interrupt, inta == 0\n");
-		goto none;
-	}
-
-	if ((inta == 0xFFFFFFFF) || ((inta & 0xFFFFFFF0) == 0xa5a5a5a0)) {
-		/* Hardware disappeared. It might have already raised
-		 * an interrupt */
-		IWL_WARN(priv, "HARDWARE GONE?? INTA == 0x%08x\n", inta);
-		goto unplugged;
-	}
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
-		inta_fh = iwl_read32(priv, CSR_FH_INT_STATUS);
-		IWL_DEBUG_ISR(priv, "ISR inta 0x%08x, enabled 0x%08x, "
-			      "fh 0x%08x\n", inta, inta_mask, inta_fh);
-	}
-#endif
-
-	priv->inta |= inta;
-	/* iwl_irq_tasklet() will service interrupts and re-enable them */
-	if (likely(inta))
-		tasklet_schedule(&priv->irq_tasklet);
-	else if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
-		iwl_enable_interrupts(priv);
-
- unplugged:
-	spin_unlock(&priv->lock);
-	return IRQ_HANDLED;
-
- none:
-	/* re-enable interrupts here since we don't have anything to service. */
-	/* only Re-enable if diabled by irq  and no schedules tasklet. */
-	if (test_bit(STATUS_INT_ENABLED, &priv->status) && !priv->inta)
-		iwl_enable_interrupts(priv);
-
-	spin_unlock(&priv->lock);
-	return IRQ_NONE;
-}
-
 irqreturn_t iwl_isr_legacy(int irq, void *data)
 {
 	struct iwl_priv *priv = data;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4ef7739..f493248 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -560,11 +560,6 @@ int iwl_send_card_state(struct iwl_priv *priv, u32 flags,
  * PCI						     *
  *****************************************************/
 irqreturn_t iwl_isr_legacy(int irq, void *data);
-int iwl_reset_ict(struct iwl_priv *priv);
-void iwl_disable_ict(struct iwl_priv *priv);
-int iwl_alloc_isr_ict(struct iwl_priv *priv);
-void iwl_free_isr_ict(struct iwl_priv *priv);
-irqreturn_t iwl_isr_ict(int irq, void *data);
 
 static inline u16 iwl_pcie_link_ctl(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 51a67fb..3ff6b9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -31,6 +31,9 @@
 #define __iwl_helpers_h__
 
 #include <linux/ctype.h>
+#include <net/mac80211.h>
+
+#include "iwl-io.h"
 
 #define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
 
-- 
1.6.3.3

