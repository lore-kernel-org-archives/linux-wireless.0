Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7398 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756458Ab1GAPxE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 11:53:04 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/11] iwlagn: introduce transport layer and implement rx_init
Date: Fri,  1 Jul 2011 08:19:59 -0700
Message-Id: <1309533605-25774-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110701_175314_790212_711ECF16)
In-Reply-To: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The transport layer is responsible for all the queues, DMA rings etc...
This is the beginning of the separation of all the code that is tighly
related to HW design to the aforementioned transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile      |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   41 +-------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h     |   16 +++
 drivers/net/wireless/iwlwifi/iwl-pci.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-rx.c      |   40 -------
 drivers/net/wireless/iwlwifi/iwl-trans.c   |  155 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h   |   64 ++++++++++++
 10 files changed, 241 insertions(+), 83 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-trans.h

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 9a56ce5..1915039 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -14,6 +14,7 @@ iwlagn-objs             += iwl-6000.o
 iwlagn-objs             += iwl-1000.o
 iwlagn-objs             += iwl-2000.o
 iwlagn-objs             += iwl-pci.o
+iwlagn-objs             += iwl-trans.o
 
 iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlagn-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index efdab65..3d97114 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -628,38 +628,6 @@ struct iwl_mod_params iwlagn_mod_params = {
 	/* the rest are 0 by default */
 };
 
-void iwlagn_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
-{
-	unsigned long flags;
-	int i;
-	spin_lock_irqsave(&rxq->lock, flags);
-	INIT_LIST_HEAD(&rxq->rx_free);
-	INIT_LIST_HEAD(&rxq->rx_used);
-	/* Fill the rx_used queue with _all_ of the Rx buffers */
-	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
-		/* In the reset function, these buffers may have been allocated
-		 * to an SKB, so we need to unmap and free potential storage */
-		if (rxq->pool[i].page != NULL) {
-			dma_unmap_page(priv->bus.dev, rxq->pool[i].page_dma,
-				PAGE_SIZE << priv->hw_params.rx_page_order,
-				DMA_FROM_DEVICE);
-			__iwl_free_pages(priv, rxq->pool[i].page);
-			rxq->pool[i].page = NULL;
-		}
-		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
-	}
-
-	for (i = 0; i < RX_QUEUE_SIZE; i++)
-		rxq->queue[i] = NULL;
-
-	/* Set us so that we have processed and used all buffers, but have
-	 * not restocked the Rx queue with fresh buffers */
-	rxq->read = rxq->write = 0;
-	rxq->write_actual = 0;
-	rxq->free_count = 0;
-	spin_unlock_irqrestore(&rxq->lock, flags);
-}
-
 int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 {
 	u32 rb_size;
@@ -747,14 +715,7 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 	priv->cfg->ops->lib->apm_ops.config(priv);
 
 	/* Allocate the RX queue, or reset if it is already allocated */
-	if (!rxq->bd) {
-		ret = iwl_rx_queue_alloc(priv);
-		if (ret) {
-			IWL_ERR(priv, "Unable to initialize Rx queue\n");
-			return -ENOMEM;
-		}
-	} else
-		iwlagn_rx_queue_reset(priv, rxq);
+	priv->trans.ops->rx_init(priv);
 
 	iwlagn_rx_replenish(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 58789e8..b065718 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -56,7 +56,7 @@
 #include "iwl-agn-calib.h"
 #include "iwl-agn.h"
 #include "iwl-pci.h"
-
+#include "iwl-trans.h"
 
 /******************************************************************************
  *
@@ -3517,6 +3517,8 @@ int iwl_probe(void *bus_specific, struct iwl_bus_ops *bus_ops,
 	priv->bus.ops->set_drv_data(&priv->bus, priv);
 	priv->bus.dev = priv->bus.ops->get_dev(&priv->bus);
 
+	iwl_trans_register(&priv->trans);
+
 	/* At this point both hw and priv are allocated. */
 
 	SET_IEEE80211_DEV(hw, priv->bus.dev);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index dcdf225..7273297 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -182,7 +182,6 @@ void iwlagn_temperature(struct iwl_priv *priv);
 u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv);
 const u8 *iwlagn_eeprom_query_addr(const struct iwl_priv *priv,
 				   size_t offset);
-void iwlagn_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwlagn_hw_nic_init(struct iwl_priv *priv);
 int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index a311cf8..13d819b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -383,7 +383,6 @@ static inline void iwl_update_stats(struct iwl_priv *priv, bool is_tx,
 ******************************************************/
 void iwl_cmd_queue_free(struct iwl_priv *priv);
 void iwl_cmd_queue_unmap(struct iwl_priv *priv);
-int iwl_rx_queue_alloc(struct iwl_priv *priv);
 void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_rx_queue *q);
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ae2ecc2..7d3e55d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1227,6 +1227,21 @@ struct iwl_bus {
 	unsigned int irq;
 };
 
+struct iwl_trans;
+
+/**
+ * struct iwl_trans_ops - transport specific operations
+
+ * @rx_init: inits the rx memory, allocate it if needed
+ */
+struct iwl_trans_ops {
+	int (*rx_init)(struct iwl_priv *priv);
+};
+
+struct iwl_trans {
+	const struct iwl_trans_ops *ops;
+};
+
 struct iwl_priv {
 
 	/* ieee device used by generic ieee processing code */
@@ -1295,6 +1310,7 @@ struct iwl_priv {
 	struct mutex mutex;
 
 	struct iwl_bus bus;	/* bus specific data */
+	struct iwl_trans trans;
 
 	/* microcode/device supports multiple contexts */
 	u8 valid_contexts;
diff --git a/drivers/net/wireless/iwlwifi/iwl-pci.c b/drivers/net/wireless/iwlwifi/iwl-pci.c
index 3b5844b..2c26b42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-pci.c
+++ b/drivers/net/wireless/iwlwifi/iwl-pci.c
@@ -67,6 +67,7 @@
 #include "iwl-agn.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
+#include "iwl-trans.h"
 
 /* PCI registers */
 #define PCI_CFG_RETRY_TIMEOUT	0x041
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 3efa706..065d2c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -179,46 +179,6 @@ void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv, struct iwl_rx_queue *q
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
-int iwl_rx_queue_alloc(struct iwl_priv *priv)
-{
-	struct iwl_rx_queue *rxq = &priv->rxq;
-	struct device *dev = priv->bus.dev;
-	int i;
-
-	spin_lock_init(&rxq->lock);
-	INIT_LIST_HEAD(&rxq->rx_free);
-	INIT_LIST_HEAD(&rxq->rx_used);
-
-	/* Alloc the circular buffer of Read Buffer Descriptors (RBDs) */
-	rxq->bd = dma_alloc_coherent(dev, 4 * RX_QUEUE_SIZE, &rxq->bd_dma,
-				     GFP_KERNEL);
-	if (!rxq->bd)
-		goto err_bd;
-
-	rxq->rb_stts = dma_alloc_coherent(dev, sizeof(struct iwl_rb_status),
-					  &rxq->rb_stts_dma, GFP_KERNEL);
-	if (!rxq->rb_stts)
-		goto err_rb;
-
-	/* Fill the rx_used queue with _all_ of the Rx buffers */
-	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
-		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
-
-	/* Set us so that we have processed and used all buffers, but have
-	 * not restocked the Rx queue with fresh buffers */
-	rxq->read = rxq->write = 0;
-	rxq->write_actual = 0;
-	rxq->free_count = 0;
-	rxq->need_update = 0;
-	return 0;
-
-err_rb:
-	dma_free_coherent(dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-			  rxq->bd_dma);
-err_bd:
-	return -ENOMEM;
-}
-
 /******************************************************************************
  *
  * Generic RX handler implementations
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
new file mode 100644
index 0000000..ccf73ff
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -0,0 +1,155 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
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
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
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
+ *
+ *****************************************************************************/
+ #include "iwl-dev.h"
+#include "iwl-trans.h"
+
+static int iwl_trans_rx_alloc(struct iwl_priv *priv)
+{
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	struct device *dev = priv->bus.dev;
+
+	memset(&priv->rxq, 0, sizeof(priv->rxq));
+
+	spin_lock_init(&rxq->lock);
+	INIT_LIST_HEAD(&rxq->rx_free);
+	INIT_LIST_HEAD(&rxq->rx_used);
+
+	if (WARN_ON(rxq->bd || rxq->rb_stts))
+		return -EINVAL;
+
+	/* Allocate the circular buffer of Read Buffer Descriptors (RBDs) */
+	/*Every descriptor is an __le32, hence its */
+	rxq->bd = dma_alloc_coherent(dev, 4 * RX_QUEUE_SIZE, &rxq->bd_dma,
+				     GFP_KERNEL);
+	if (!rxq->bd)
+		goto err_bd;
+	memset(rxq->bd, 0, 4 * RX_QUEUE_SIZE);
+
+	/*Allocate the driver's pointer to receive buffer status */
+	rxq->rb_stts = dma_alloc_coherent(dev, sizeof(*rxq->rb_stts),
+					  &rxq->rb_stts_dma, GFP_KERNEL);
+	if (!rxq->rb_stts)
+		goto err_rb_stts;
+	memset(rxq->rb_stts, 0, sizeof(*rxq->rb_stts));
+
+	return 0;
+
+err_rb_stts:
+	dma_free_coherent(dev, 4 * RX_QUEUE_SIZE, rxq->bd, rxq->bd_dma);
+	memset(&rxq->bd_dma, 0, sizeof(rxq->bd_dma));
+	rxq->bd = NULL;
+err_bd:
+	return -ENOMEM;
+}
+
+static int iwl_trans_rx_init(struct iwl_priv *priv)
+{
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	int i, err;
+	unsigned long flags;
+
+	if (!rxq->bd) {
+		err = iwl_trans_rx_alloc(priv);
+		if (err)
+			return err;
+	}
+
+	spin_lock_irqsave(&rxq->lock, flags);
+	INIT_LIST_HEAD(&rxq->rx_free);
+	INIT_LIST_HEAD(&rxq->rx_used);
+
+	/* Fill the rx_used queue with _all_ of the Rx buffers */
+	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
+		/* In the reset function, these buffers may have been allocated
+		 * to an SKB, so we need to unmap and free potential storage */
+		if (rxq->pool[i].page != NULL) {
+			dma_unmap_page(priv->bus.dev, rxq->pool[i].page_dma,
+				PAGE_SIZE << priv->hw_params.rx_page_order,
+				DMA_FROM_DEVICE);
+			__iwl_free_pages(priv, rxq->pool[i].page);
+			rxq->pool[i].page = NULL;
+		}
+		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
+	}
+
+	for (i = 0; i < RX_QUEUE_SIZE; i++)
+		rxq->queue[i] = NULL;
+
+	/* Set us so that we have processed and used all buffers, but have
+	 * not restocked the Rx queue with fresh buffers */
+	rxq->read = rxq->write = 0;
+	rxq->write_actual = 0;
+	rxq->free_count = 0;
+	spin_unlock_irqrestore(&rxq->lock, flags);
+
+	return 0;
+}
+
+static const struct iwl_trans_ops trans_ops = {
+	.rx_init = iwl_trans_rx_init,
+};
+
+void iwl_trans_register(struct iwl_trans *trans)
+{
+	trans->ops = &trans_ops;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
new file mode 100644
index 0000000..bec494c
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -0,0 +1,64 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2011 Intel Corporation. All rights reserved.
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
+ * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
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
+ *
+ *****************************************************************************/
+
+void iwl_trans_register(struct iwl_trans *trans);
-- 
1.7.0.4

