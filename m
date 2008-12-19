Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26230 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbYLSCoz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:44:55 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/43] iwlwifi: 3945 extract flow handler definitions into iwl-3945-fh.h
Date: Fri, 19 Dec 2008 10:37:01 +0800
Message-Id: <1229654263-21454-2-git-send-email-yi.zhu@intel.com> (sfid-20081219_034500_191034_F3B79F22)
In-Reply-To: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves 3945 definitions into iwl-3945-fh.h
It renames FH_ to FH39 to help inclusion of 3945 into iwlcore
framework

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-fh.h  |  178 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |  101 ---------------
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   83 +++++++------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    3 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   10 +-
 5 files changed, 226 insertions(+), 149 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-3945-fh.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-fh.h b/drivers/net/wireless/iwlwifi/iwl-3945-fh.h
new file mode 100644
index 0000000..bbcd0ce
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-fh.h
@@ -0,0 +1,178 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
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
+ * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
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
+#ifndef __iwl_3945_fh_h__
+#define __iwl_3945_fh_h__
+
+/************************************/
+/* iwl3945 Flow Handler Definitions */
+/************************************/
+
+/**
+ * This I/O area is directly read/writable by driver (e.g. Linux uses writel())
+ * Addresses are offsets from device's PCI hardware base address.
+ */
+#define FH39_MEM_LOWER_BOUND                   (0x0800)
+#define FH39_MEM_UPPER_BOUND                   (0x1000)
+
+#define FH39_CBCC_TABLE		(FH39_MEM_LOWER_BOUND + 0x140)
+#define FH39_TFDB_TABLE		(FH39_MEM_LOWER_BOUND + 0x180)
+#define FH39_RCSR_TABLE		(FH39_MEM_LOWER_BOUND + 0x400)
+#define FH39_RSSR_TABLE		(FH39_MEM_LOWER_BOUND + 0x4c0)
+#define FH39_TCSR_TABLE		(FH39_MEM_LOWER_BOUND + 0x500)
+#define FH39_TSSR_TABLE		(FH39_MEM_LOWER_BOUND + 0x680)
+
+/* TFDB (Transmit Frame Buffer Descriptor) */
+#define FH39_TFDB(_ch, buf)			(FH39_TFDB_TABLE + \
+						 ((_ch) * 2 + (buf)) * 0x28)
+#define FH39_TFDB_CHNL_BUF_CTRL_REG(_ch)	(FH39_TFDB_TABLE + 0x50 * (_ch))
+
+/* CBCC channel is [0,2] */
+#define FH39_CBCC(_ch)		(FH39_CBCC_TABLE + (_ch) * 0x8)
+#define FH39_CBCC_CTRL(_ch)	(FH39_CBCC(_ch) + 0x00)
+#define FH39_CBCC_BASE(_ch)	(FH39_CBCC(_ch) + 0x04)
+
+/* RCSR channel is [0,2] */
+#define FH39_RCSR(_ch)			(FH39_RCSR_TABLE + (_ch) * 0x40)
+#define FH39_RCSR_CONFIG(_ch)		(FH39_RCSR(_ch) + 0x00)
+#define FH39_RCSR_RBD_BASE(_ch)		(FH39_RCSR(_ch) + 0x04)
+#define FH39_RCSR_WPTR(_ch)		(FH39_RCSR(_ch) + 0x20)
+#define FH39_RCSR_RPTR_ADDR(_ch)	(FH39_RCSR(_ch) + 0x24)
+
+#define FH39_RSCSR_CHNL0_WPTR		(FH39_RCSR_WPTR(0))
+
+/* RSSR */
+#define FH39_RSSR_CTRL			(FH39_RSSR_TABLE + 0x000)
+#define FH39_RSSR_STATUS		(FH39_RSSR_TABLE + 0x004)
+
+/* TCSR */
+#define FH39_TCSR(_ch)			(FH39_TCSR_TABLE + (_ch) * 0x20)
+#define FH39_TCSR_CONFIG(_ch)		(FH39_TCSR(_ch) + 0x00)
+#define FH39_TCSR_CREDIT(_ch)		(FH39_TCSR(_ch) + 0x04)
+#define FH39_TCSR_BUFF_STTS(_ch)	(FH39_TCSR(_ch) + 0x08)
+
+/* TSSR */
+#define FH39_TSSR_CBB_BASE        (FH39_TSSR_TABLE + 0x000)
+#define FH39_TSSR_MSG_CONFIG      (FH39_TSSR_TABLE + 0x008)
+#define FH39_TSSR_TX_STATUS       (FH39_TSSR_TABLE + 0x010)
+
+
+/* DBM */
+
+#define FH39_SRVC_CHNL                            (6)
+
+#define FH39_RCSR_RX_CONFIG_REG_POS_RBDC_SIZE     (20)
+#define FH39_RCSR_RX_CONFIG_REG_POS_IRQ_RBTH      (4)
+
+#define FH39_RCSR_RX_CONFIG_REG_BIT_WR_STTS_EN    (0x08000000)
+
+#define FH39_RCSR_RX_CONFIG_REG_VAL_DMA_CHNL_EN_ENABLE        (0x80000000)
+
+#define FH39_RCSR_RX_CONFIG_REG_VAL_RDRBD_EN_ENABLE           (0x20000000)
+
+#define FH39_RCSR_RX_CONFIG_REG_VAL_MAX_FRAG_SIZE_128		(0x01000000)
+
+#define FH39_RCSR_RX_CONFIG_REG_VAL_IRQ_DEST_INT_HOST		(0x00001000)
+
+#define FH39_RCSR_RX_CONFIG_REG_VAL_MSG_MODE_FH			(0x00000000)
+
+#define FH39_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF		(0x00000000)
+#define FH39_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_DRIVER		(0x00000001)
+
+#define FH39_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE_VAL	(0x00000000)
+#define FH39_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL	(0x00000008)
+
+#define FH39_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD		(0x00200000)
+
+#define FH39_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT		(0x00000000)
+
+#define FH39_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE		(0x00000000)
+#define FH39_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE		(0x80000000)
+
+#define FH39_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID		(0x00004000)
+
+#define FH39_TCSR_CHNL_TX_BUF_STS_REG_BIT_TFDB_WPTR		(0x00000001)
+
+#define FH39_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON	(0xFF000000)
+#define FH39_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_TXPD_ON	(0x00FF0000)
+
+#define FH39_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_128B	(0x00000400)
+
+#define FH39_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TFD_ON		(0x00000100)
+#define FH39_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_CBB_ON		(0x00000080)
+
+#define FH39_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RSP_WAIT_TH	(0x00000020)
+#define FH39_TSSR_TX_MSG_CONFIG_REG_VAL_RSP_WAIT_TH		(0x00000005)
+
+#define FH39_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_ch)	(BIT(_ch) << 24)
+#define FH39_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_ch)	(BIT(_ch) << 16)
+
+#define FH39_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(_ch) \
+	(FH39_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_ch) | \
+	 FH39_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_ch))
+
+#define FH39_RSSR_CHNL0_RX_STATUS_CHNL_IDLE			(0x01000000)
+
+#define TFD_QUEUE_SIZE_MAX      (256)
+
+#endif /* __iwl_3945_fh_h__ */
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 94ea0e6..1df385b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -288,107 +288,6 @@ struct iwl3945_eeprom {
 #define PCI_REG_WUM8       0x0E8
 #define PCI_CFG_PMC_PME_FROM_D3COLD_SUPPORT         (0x80000000)
 
-/*=== FH (data Flow Handler) ===*/
-#define FH_BASE     (0x800)
-
-#define FH_CBCC_TABLE           (FH_BASE+0x140)
-#define FH_TFDB_TABLE           (FH_BASE+0x180)
-#define FH_RCSR_TABLE           (FH_BASE+0x400)
-#define FH_RSSR_TABLE           (FH_BASE+0x4c0)
-#define FH_TCSR_TABLE           (FH_BASE+0x500)
-#define FH_TSSR_TABLE           (FH_BASE+0x680)
-
-/* TFDB (Transmit Frame Buffer Descriptor) */
-#define FH_TFDB(_channel, buf) \
-	(FH_TFDB_TABLE+((_channel)*2+(buf))*0x28)
-#define ALM_FH_TFDB_CHNL_BUF_CTRL_REG(_channel) \
-	(FH_TFDB_TABLE + 0x50 * _channel)
-/* CBCC _channel is [0,2] */
-#define FH_CBCC(_channel)           (FH_CBCC_TABLE+(_channel)*0x8)
-#define FH_CBCC_CTRL(_channel)      (FH_CBCC(_channel)+0x00)
-#define FH_CBCC_BASE(_channel)      (FH_CBCC(_channel)+0x04)
-
-/* RCSR _channel is [0,2] */
-#define FH_RCSR(_channel)           (FH_RCSR_TABLE+(_channel)*0x40)
-#define FH_RCSR_CONFIG(_channel)    (FH_RCSR(_channel)+0x00)
-#define FH_RCSR_RBD_BASE(_channel)  (FH_RCSR(_channel)+0x04)
-#define FH_RCSR_WPTR(_channel)      (FH_RCSR(_channel)+0x20)
-#define FH_RCSR_RPTR_ADDR(_channel) (FH_RCSR(_channel)+0x24)
-
-#define FH_RSCSR_CHNL0_WPTR        (FH_RCSR_WPTR(0))
-
-/* RSSR */
-#define FH_RSSR_CTRL            (FH_RSSR_TABLE+0x000)
-#define FH_RSSR_STATUS          (FH_RSSR_TABLE+0x004)
-#define FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE	(0x01000000)
-/* TCSR */
-#define FH_TCSR(_channel)           (FH_TCSR_TABLE+(_channel)*0x20)
-#define FH_TCSR_CONFIG(_channel)    (FH_TCSR(_channel)+0x00)
-#define FH_TCSR_CREDIT(_channel)    (FH_TCSR(_channel)+0x04)
-#define FH_TCSR_BUFF_STTS(_channel) (FH_TCSR(_channel)+0x08)
-/* TSSR */
-#define FH_TSSR_CBB_BASE        (FH_TSSR_TABLE+0x000)
-#define FH_TSSR_MSG_CONFIG      (FH_TSSR_TABLE+0x008)
-#define FH_TSSR_TX_STATUS       (FH_TSSR_TABLE+0x010)
-
-
-/* DBM */
-
-#define ALM_FH_SRVC_CHNL                            (6)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_POS_RBDC_SIZE     (20)
-#define ALM_FH_RCSR_RX_CONFIG_REG_POS_IRQ_RBTH      (4)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_BIT_WR_STTS_EN    (0x08000000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_DMA_CHNL_EN_ENABLE        (0x80000000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_RDRBD_EN_ENABLE           (0x20000000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_MAX_FRAG_SIZE_128         (0x01000000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_IRQ_DEST_INT_HOST         (0x00001000)
-
-#define ALM_FH_RCSR_RX_CONFIG_REG_VAL_MSG_MODE_FH               (0x00000000)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF              (0x00000000)
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_DRIVER           (0x00000001)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_DISABLE_VAL    (0x00000000)
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL     (0x00000008)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD           (0x00200000)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT            (0x00000000)
-
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_PAUSE            (0x00000000)
-#define ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE           (0x80000000)
-
-#define ALM_FH_TCSR_CHNL_TX_BUF_STS_REG_VAL_TFDB_VALID          (0x00004000)
-
-#define ALM_FH_TCSR_CHNL_TX_BUF_STS_REG_BIT_TFDB_WPTR           (0x00000001)
-
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON      (0xFF000000)
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_TXPD_ON      (0x00FF0000)
-
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_128B    (0x00000400)
-
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TFD_ON       (0x00000100)
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_CBB_ON       (0x00000080)
-
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RSP_WAIT_TH     (0x00000020)
-#define ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_RSP_WAIT_TH           (0x00000005)
-
-#define ALM_TB_MAX_BYTES_COUNT      (0xFFF0)
-
-#define ALM_FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_channel) \
-	((1LU << _channel) << 24)
-#define ALM_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_channel) \
-	((1LU << _channel) << 16)
-
-#define ALM_FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(_channel) \
-	(ALM_FH_TSSR_TX_STATUS_REG_BIT_BUFS_EMPTY(_channel) | \
-	 ALM_FH_TSSR_TX_STATUS_REG_BIT_NO_PEND_REQ(_channel))
 #define PCI_CFG_REV_ID_BIT_BASIC_SKU                (0x40)	/* bit 6    */
 #define PCI_CFG_REV_ID_BIT_RTP                      (0x80)	/* bit 7    */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 2327dd2..77cf2d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -39,6 +39,7 @@
 #include <net/mac80211.h>
 
 #include "iwl-3945-core.h"
+#include "iwl-3945-fh.h"
 #include "iwl-3945.h"
 #include "iwl-helpers.h"
 #include "iwl-3945-rs.h"
@@ -985,23 +986,23 @@ static int iwl3945_rx_init(struct iwl3945_priv *priv, struct iwl3945_rx_queue *r
 		return rc;
 	}
 
-	iwl3945_write_direct32(priv, FH_RCSR_RBD_BASE(0), rxq->dma_addr);
-	iwl3945_write_direct32(priv, FH_RCSR_RPTR_ADDR(0),
+	iwl3945_write_direct32(priv, FH39_RCSR_RBD_BASE(0), rxq->dma_addr);
+	iwl3945_write_direct32(priv, FH39_RCSR_RPTR_ADDR(0),
 			     priv->hw_setting.shared_phys +
 			     offsetof(struct iwl3945_shared, rx_read_ptr[0]));
-	iwl3945_write_direct32(priv, FH_RCSR_WPTR(0), 0);
-	iwl3945_write_direct32(priv, FH_RCSR_CONFIG(0),
-		ALM_FH_RCSR_RX_CONFIG_REG_VAL_DMA_CHNL_EN_ENABLE |
-		ALM_FH_RCSR_RX_CONFIG_REG_VAL_RDRBD_EN_ENABLE |
-		ALM_FH_RCSR_RX_CONFIG_REG_BIT_WR_STTS_EN |
-		ALM_FH_RCSR_RX_CONFIG_REG_VAL_MAX_FRAG_SIZE_128 |
-		(RX_QUEUE_SIZE_LOG << ALM_FH_RCSR_RX_CONFIG_REG_POS_RBDC_SIZE) |
-		ALM_FH_RCSR_RX_CONFIG_REG_VAL_IRQ_DEST_INT_HOST |
-		(1 << ALM_FH_RCSR_RX_CONFIG_REG_POS_IRQ_RBTH) |
-		ALM_FH_RCSR_RX_CONFIG_REG_VAL_MSG_MODE_FH);
+	iwl3945_write_direct32(priv, FH39_RCSR_WPTR(0), 0);
+	iwl3945_write_direct32(priv, FH39_RCSR_CONFIG(0),
+		FH39_RCSR_RX_CONFIG_REG_VAL_DMA_CHNL_EN_ENABLE |
+		FH39_RCSR_RX_CONFIG_REG_VAL_RDRBD_EN_ENABLE |
+		FH39_RCSR_RX_CONFIG_REG_BIT_WR_STTS_EN |
+		FH39_RCSR_RX_CONFIG_REG_VAL_MAX_FRAG_SIZE_128 |
+		(RX_QUEUE_SIZE_LOG << FH39_RCSR_RX_CONFIG_REG_POS_RBDC_SIZE) |
+		FH39_RCSR_RX_CONFIG_REG_VAL_IRQ_DEST_INT_HOST |
+		(1 << FH39_RCSR_RX_CONFIG_REG_POS_IRQ_RBTH) |
+		FH39_RCSR_RX_CONFIG_REG_VAL_MSG_MODE_FH);
 
 	/* fake read to flush all prev I/O */
-	iwl3945_read_direct32(priv, FH_RSSR_CTRL);
+	iwl3945_read_direct32(priv, FH39_RSSR_CTRL);
 
 	iwl3945_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -1035,17 +1036,17 @@ static int iwl3945_tx_reset(struct iwl3945_priv *priv)
 	iwl3945_write_prph(priv, ALM_SCD_TXF4MF_REG, 0x000004);
 	iwl3945_write_prph(priv, ALM_SCD_TXF5MF_REG, 0x000005);
 
-	iwl3945_write_direct32(priv, FH_TSSR_CBB_BASE,
+	iwl3945_write_direct32(priv, FH39_TSSR_CBB_BASE,
 			     priv->hw_setting.shared_phys);
 
-	iwl3945_write_direct32(priv, FH_TSSR_MSG_CONFIG,
-		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON |
-		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_TXPD_ON |
-		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_128B |
-		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TFD_ON |
-		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_CBB_ON |
-		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RSP_WAIT_TH |
-		ALM_FH_TSSR_TX_MSG_CONFIG_REG_VAL_RSP_WAIT_TH);
+	iwl3945_write_direct32(priv, FH39_TSSR_MSG_CONFIG,
+		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TXPD_ON |
+		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_TXPD_ON |
+		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_MAX_FRAG_SIZE_128B |
+		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_SNOOP_RD_TFD_ON |
+		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RD_CBB_ON |
+		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_ORDER_RSP_WAIT_TH |
+		FH39_TSSR_TX_MSG_CONFIG_REG_VAL_RSP_WAIT_TH);
 
 	iwl3945_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -1211,7 +1212,7 @@ int iwl3945_hw_nic_init(struct iwl3945_priv *priv)
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
-	iwl3945_write_direct32(priv, FH_RCSR_WPTR(0), rxq->write & ~7);
+	iwl3945_write_direct32(priv, FH39_RCSR_WPTR(0), rxq->write & ~7);
 	iwl3945_release_nic_access(priv);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
@@ -1241,7 +1242,7 @@ void iwl3945_hw_txq_ctx_free(struct iwl3945_priv *priv)
 
 void iwl3945_hw_txq_ctx_stop(struct iwl3945_priv *priv)
 {
-	int queue;
+	int txq_id;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -1255,10 +1256,10 @@ void iwl3945_hw_txq_ctx_stop(struct iwl3945_priv *priv)
 	iwl3945_write_prph(priv, ALM_SCD_MODE_REG, 0);
 
 	/* reset TFD queues */
-	for (queue = TFD_QUEUE_MIN; queue < TFD_QUEUE_MAX; queue++) {
-		iwl3945_write_direct32(priv, FH_TCSR_CONFIG(queue), 0x0);
-		iwl3945_poll_direct_bit(priv, FH_TSSR_TX_STATUS,
-				ALM_FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(queue),
+	for (txq_id = 0; txq_id < TFD_QUEUE_MAX; txq_id++) {
+		iwl3945_write_direct32(priv, FH39_TCSR_CONFIG(txq_id), 0x0);
+		iwl3945_poll_direct_bit(priv, FH39_TSSR_TX_STATUS,
+				FH39_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(txq_id),
 				1000);
 	}
 
@@ -2308,9 +2309,9 @@ int iwl3945_hw_rxq_stop(struct iwl3945_priv *priv)
 		return rc;
 	}
 
-	iwl3945_write_direct32(priv, FH_RCSR_CONFIG(0), 0);
-	rc = iwl3945_poll_direct_bit(priv, FH_RSSR_STATUS,
-			FH_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
+	iwl3945_write_direct32(priv, FH39_RCSR_CONFIG(0), 0);
+	rc = iwl3945_poll_direct_bit(priv, FH39_RSSR_STATUS,
+			FH39_RSSR_CHNL0_RX_STATUS_CHNL_IDLE, 1000);
 	if (rc < 0)
 		IWL_ERROR("Can't stop Rx DMA.\n");
 
@@ -2336,19 +2337,19 @@ int iwl3945_hw_tx_queue_init(struct iwl3945_priv *priv, struct iwl3945_tx_queue
 		spin_unlock_irqrestore(&priv->lock, flags);
 		return rc;
 	}
-	iwl3945_write_direct32(priv, FH_CBCC_CTRL(txq_id), 0);
-	iwl3945_write_direct32(priv, FH_CBCC_BASE(txq_id), 0);
-
-	iwl3945_write_direct32(priv, FH_TCSR_CONFIG(txq_id),
-		ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT |
-		ALM_FH_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF |
-		ALM_FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD |
-		ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL |
-		ALM_FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE);
+	iwl3945_write_direct32(priv, FH39_CBCC_CTRL(txq_id), 0);
+	iwl3945_write_direct32(priv, FH39_CBCC_BASE(txq_id), 0);
+
+	iwl3945_write_direct32(priv, FH39_TCSR_CONFIG(txq_id),
+		FH39_TCSR_TX_CONFIG_REG_VAL_CIRQ_RTC_NOINT |
+		FH39_TCSR_TX_CONFIG_REG_VAL_MSG_MODE_TXF |
+		FH39_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_IFTFD |
+		FH39_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL |
+		FH39_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE);
 	iwl3945_release_nic_access(priv);
 
 	/* fake read to flush all prev. writes */
-	iwl3945_read32(priv, FH_TSSR_CBB_BASE);
+	iwl3945_read32(priv, FH39_TSSR_CBB_BASE);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 2c0ddc5..d8f40bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -691,7 +691,6 @@ static inline void iwl3945_rfkill_unregister(struct iwl3945_priv *priv) {}
 static inline int iwl3945_rfkill_init(struct iwl3945_priv *priv) { return 0; }
 #endif
 
-#define IWL_MAX_NUM_QUEUES IWL39_MAX_NUM_QUEUES
 
 struct iwl3945_priv {
 
@@ -815,7 +814,7 @@ struct iwl3945_priv {
 
 	/* Rx and Tx DMA processing queues */
 	struct iwl3945_rx_queue rxq;
-	struct iwl3945_tx_queue txq[IWL_MAX_NUM_QUEUES];
+	struct iwl3945_tx_queue txq[IWL39_MAX_NUM_QUEUES];
 
 	unsigned long status;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 7379855..3726939 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -48,6 +48,7 @@
 
 #include "iwl-3945-core.h"
 #include "iwl-3945.h"
+#include "iwl-3945-fh.h"
 #include "iwl-helpers.h"
 
 #ifdef CONFIG_IWL3945_DEBUG
@@ -3485,14 +3486,14 @@ int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv, struct iwl3945_
 			goto exit_unlock;
 
 		/* Device expects a multiple of 8 */
-		iwl3945_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
+		iwl3945_write_direct32(priv, FH39_RSCSR_CHNL0_WPTR,
 				     q->write & ~0x7);
 		iwl3945_release_nic_access(priv);
 
 	/* Else device is assumed to be awake */
 	} else
 		/* Device expects a multiple of 8 */
-		iwl3945_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
+		iwl3945_write32(priv, FH39_RSCSR_CHNL0_WPTR, q->write & ~0x7);
 
 
 	q->need_update = 0;
@@ -4349,9 +4350,8 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
 
 		iwl3945_write32(priv, CSR_FH_INT_STATUS, (1 << 6));
 		if (!iwl3945_grab_nic_access(priv)) {
-			iwl3945_write_direct32(priv,
-					     FH_TCSR_CREDIT
-					     (ALM_FH_SRVC_CHNL), 0x0);
+			iwl3945_write_direct32(priv, FH39_TCSR_CREDIT
+					     (FH39_SRVC_CHNL), 0x0);
 			iwl3945_release_nic_access(priv);
 		}
 		handled |= CSR_INT_BIT_FH_TX;
-- 
1.5.3.6

