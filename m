Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbYLVDik (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 22:38:40 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 01/10] iwl3945: rearrange 3945 tfd
Date: Mon, 22 Dec 2008 11:31:14 +0800
Message-Id: <1229916683-9772-2-git-send-email-yi.zhu@intel.com> (sfid-20081222_043852_969996_B9F41812)
In-Reply-To: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch moves 3945 TFD structures to iwl-3945-fh.h. It renames them
similarly to AGN naming. This patch also eliminates iwl3945_tx_info and
fixes endianity issue in iwl3945_tx_skb and iwl3945_enqueue_hcmd caused
by ugly casting.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-fh.h  |   12 +++++++-
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |   11 -------
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   19 +++++++------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    8 +-----
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   13 +++++----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   40 +++++++++++---------------
 6 files changed, 46 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-fh.h b/drivers/net/wireless/iwlwifi/iwl-3945-fh.h
index bbcd0ce..53ed249 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-fh.h
@@ -172,7 +172,17 @@
 
 #define FH39_RSSR_CHNL0_RX_STATUS_CHNL_IDLE			(0x01000000)
 
-#define TFD_QUEUE_SIZE_MAX      (256)
+struct iwl3945_tfd_tb {
+	__le32 addr;
+	__le32 len;
+} __attribute__ ((packed));
+
+struct iwl3945_tfd {
+	__le32 control_flags;
+	struct iwl3945_tfd_tb tbs[4];
+	u8 __pad[28];
+} __attribute__ ((packed));
+
 
 #endif /* __iwl_3945_fh_h__ */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index fc1b774..1ba59df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -304,17 +304,6 @@ struct iwl3945_shared {
 	__le32 tx_base_ptr[8];
 } __attribute__ ((packed));
 
-struct iwl3945_tfd_frame_data {
-	__le32 addr;
-	__le32 len;
-} __attribute__ ((packed));
-
-struct iwl3945_tfd_frame {
-	__le32 control_flags;
-	struct iwl3945_tfd_frame_data pa[4];
-	u8 reserved[28];
-} __attribute__ ((packed));
-
 static inline u8 iwl3945_hw_get_rate(__le16 rate_n_flags)
 {
 	return le16_to_cpu(rate_n_flags) & 0xFF;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 131bae7..24cdc5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -38,6 +38,7 @@
 #include <asm/unaligned.h>
 #include <net/mac80211.h>
 
+#include "iwl-fh.h"
 #include "iwl-3945-fh.h"
 #include "iwl-commands.h"
 #include "iwl-3945.h"
@@ -307,7 +308,7 @@ static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
 {
 	struct iwl3945_tx_queue *txq = &priv->txq39[txq_id];
 	struct iwl_queue *q = &txq->q;
-	struct iwl3945_tx_info *tx_info;
+	struct iwl_tx_info *tx_info;
 
 	BUG_ON(txq_id == IWL_CMD_QUEUE_NUM);
 
@@ -728,7 +729,7 @@ int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 {
 	int count;
 	u32 pad;
-	struct iwl3945_tfd_frame *tfd = (struct iwl3945_tfd_frame *)ptr;
+	struct iwl3945_tfd *tfd = (struct iwl3945_tfd *)ptr;
 
 	count = TFD_CTL_COUNT_GET(le32_to_cpu(tfd->control_flags));
 	pad = TFD_CTL_PAD_GET(le32_to_cpu(tfd->control_flags));
@@ -739,8 +740,8 @@ int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 		return -EINVAL;
 	}
 
-	tfd->pa[count].addr = cpu_to_le32(addr);
-	tfd->pa[count].len = cpu_to_le32(len);
+	tfd->tbs[count].addr = cpu_to_le32(addr);
+	tfd->tbs[count].len = cpu_to_le32(len);
 
 	count++;
 
@@ -757,8 +758,8 @@ int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
  */
 int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl3945_tx_queue *txq)
 {
-	struct iwl3945_tfd_frame *bd_tmp = (struct iwl3945_tfd_frame *)&txq->bd[0];
-	struct iwl3945_tfd_frame *bd = &bd_tmp[txq->q.read_ptr];
+	struct iwl3945_tfd *tfd_tmp = (struct iwl3945_tfd *)&txq->tfds[0];
+	struct iwl3945_tfd *tfd = &tfd_tmp[txq->q.read_ptr];
 	struct pci_dev *dev = priv->pci_dev;
 	int i;
 	int counter;
@@ -769,7 +770,7 @@ int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl3945_tx_queue *txq)
 		return 0;
 
 	/* sanity check */
-	counter = TFD_CTL_COUNT_GET(le32_to_cpu(bd->control_flags));
+	counter = TFD_CTL_COUNT_GET(le32_to_cpu(tfd->control_flags));
 	if (counter > NUM_TFD_CHUNKS) {
 		IWL_ERR(priv, "Too many chunks: %i\n", counter);
 		/* @todo issue fatal error, it is quite serious situation */
@@ -779,8 +780,8 @@ int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl3945_tx_queue *txq)
 	/* unmap chunks if any */
 
 	for (i = 1; i < counter; i++) {
-		pci_unmap_single(dev, le32_to_cpu(bd->pa[i].addr),
-				 le32_to_cpu(bd->pa[i].len), PCI_DMA_TODEVICE);
+		pci_unmap_single(dev, le32_to_cpu(tfd->tbs[i].addr),
+			 le32_to_cpu(tfd->tbs[i].len), PCI_DMA_TODEVICE);
 		if (txq->txb[txq->q.read_ptr].skb[0]) {
 			struct sk_buff *skb = txq->txb[txq->q.read_ptr].skb[0];
 			if (txq->txb[txq->q.read_ptr].skb[0]) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index aff6a3a..716c4b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -45,6 +45,7 @@ extern struct pci_device_id iwl3945_hw_card_ids[];
 
 #include "iwl-csr.h"
 #include "iwl-prph.h"
+#include "iwl-fh.h"
 #include "iwl-3945-hw.h"
 #include "iwl-debug.h"
 #include "iwl-power.h"
@@ -107,13 +108,6 @@ enum iwl3945_antenna {
 
 int iwl3945_x2_queue_used(const struct iwl_queue *q, int i);
 
-#define MAX_NUM_OF_TBS          (20)
-
-/* One for each TFD */
-struct iwl3945_tx_info {
-	struct sk_buff *skb[MAX_NUM_OF_TBS];
-};
-
 #include "iwl-agn-rs.h"
 
 #define IWL_TX_FIFO_AC0	0
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8981c05..1ad4d08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -36,14 +36,15 @@
 #include <linux/kernel.h>
 #include <net/ieee80211_radiotap.h>
 
-#include "iwl-rfkill.h"
 #include "iwl-eeprom.h"
-#include "iwl-4965-hw.h"
-#include "iwl-3945-hw.h"
-#include "iwl-3945-led.h"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
+#include "iwl-fh.h"
 #include "iwl-debug.h"
+#include "iwl-rfkill.h"
+#include "iwl-4965-hw.h"
+#include "iwl-3945-hw.h"
+#include "iwl-3945-led.h"
 #include "iwl-led.h"
 #include "iwl-power.h"
 #include "iwl-agn-rs.h"
@@ -239,10 +240,10 @@ struct iwl_channel_info {
  */
 struct iwl3945_tx_queue {
 	struct iwl_queue q;
-	struct iwl3945_tfd_frame *bd;
+	struct iwl3945_tfd *tfds;
 	struct iwl_cmd *cmd;
 	dma_addr_t dma_addr_cmd;
-	struct iwl3945_tx_info *txb;
+	struct iwl_tx_info *txb;
 	int need_update;
 	int active;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 4b4ed65..5a0e25b 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -48,9 +48,10 @@
 
 #define DRV_NAME	"iwl3945"
 
+#include "iwl-fh.h"
+#include "iwl-3945-fh.h"
 #include "iwl-commands.h"
 #include "iwl-3945.h"
-#include "iwl-3945-fh.h"
 #include "iwl-helpers.h"
 #include "iwl-core.h"
 #include "iwl-dev.h"
@@ -180,13 +181,13 @@ static int iwl3945_tx_queue_alloc(struct iwl_priv *priv,
 
 	/* Circular buffer of transmit frame descriptors (TFDs),
 	 * shared with device */
-	txq->bd = pci_alloc_consistent(dev,
-			sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX,
+	txq->tfds = pci_alloc_consistent(dev,
+			sizeof(txq->tfds[0]) * TFD_QUEUE_SIZE_MAX,
 			&txq->q.dma_addr);
 
-	if (!txq->bd) {
+	if (!txq->tfds) {
 		IWL_ERR(priv, "pci_alloc_consistent(%zd) failed\n",
-			  sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX);
+			  sizeof(txq->tfds[0]) * TFD_QUEUE_SIZE_MAX);
 		goto error;
 	}
 	txq->q.id = id;
@@ -278,8 +279,8 @@ void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl3945_tx_queue *txq)
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
-		pci_free_consistent(dev, sizeof(struct iwl3945_tfd_frame) *
-				    txq->q.n_bd, txq->bd, txq->q.dma_addr);
+		pci_free_consistent(dev, sizeof(struct iwl3945_tfd) *
+				    txq->q.n_bd, txq->tfds, txq->q.dma_addr);
 
 	/* De-alloc array of per-TFD driver data */
 	kfree(txq->txb);
@@ -446,14 +447,12 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	struct iwl3945_tx_queue *txq = &priv->txq39[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
-	struct iwl3945_tfd_frame *tfd;
-	u32 *control_flags;
+	struct iwl3945_tfd *tfd;
 	struct iwl_cmd *out_cmd;
 	u32 idx;
 	u16 fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
 	dma_addr_t phys_addr;
 	int pad;
-	u16 count;
 	int ret;
 	unsigned long flags;
 
@@ -476,11 +475,9 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	spin_lock_irqsave(&priv->hcmd_lock, flags);
 
-	tfd = &txq->bd[q->write_ptr];
+	tfd = &txq->tfds[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
 
-	control_flags = (u32 *) tfd;
-
 	idx = get_cmd_index(q, q->write_ptr, cmd->meta.flags & CMD_SIZE_HUGE);
 	out_cmd = &txq->cmd[idx];
 
@@ -502,8 +499,7 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
 
 	pad = U32_PAD(cmd->len);
-	count = TFD_CTL_COUNT_GET(*control_flags);
-	*control_flags = TFD_CTL_COUNT_SET(count) | TFD_CTL_PAD_SET(pad);
+	tfd->control_flags |= cpu_to_le32(TFD_CTL_PAD_SET(pad));
 
 	IWL_DEBUG_HC("Sending command %s (#%x), seq: 0x%04X, "
 		     "%d bytes at %d[%d]:%d\n",
@@ -2235,8 +2231,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct iwl3945_tfd_frame *tfd;
-	u32 *control_flags;
+	struct iwl3945_tfd *tfd;
 	int txq_id = skb_get_queue_mapping(skb);
 	struct iwl3945_tx_queue *txq = NULL;
 	struct iwl_queue *q = NULL;
@@ -2323,13 +2318,12 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	/* Set up first empty TFD within this queue's circular TFD buffer */
-	tfd = &txq->bd[q->write_ptr];
+	tfd = &txq->tfds[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
-	control_flags = (u32 *) tfd;
 	idx = get_cmd_index(q, q->write_ptr, 0);
 
 	/* Set up driver data for this TFD */
-	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl3945_tx_info));
+	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
 	txq->txb[q->write_ptr].skb[0] = skb;
 
 	/* Init first empty entry in queue's array of Tx/cmd buffers */
@@ -2393,12 +2387,12 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	if (!len)
 		/* If there is no payload, then we use only one Tx buffer */
-		*control_flags = TFD_CTL_COUNT_SET(1);
+		tfd->control_flags = cpu_to_le32(TFD_CTL_COUNT_SET(1));
 	else
 		/* Else use 2 buffers.
 		 * Tell 3945 about any padding after MAC header */
-		*control_flags = TFD_CTL_COUNT_SET(2) |
-			TFD_CTL_PAD_SET(U32_PAD(len));
+		tfd->control_flags = cpu_to_le32(TFD_CTL_COUNT_SET(2) |
+			TFD_CTL_PAD_SET(U32_PAD(len)));
 
 	/* Total # bytes to be transmitted */
 	len = (u16)skb->len;
-- 
1.5.3.6

