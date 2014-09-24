Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:42112 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbaIXLQz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 07:16:55 -0400
Subject: [PATCH v3 2/3] ath10k: add diag_read() to hif ops
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 24 Sep 2014 14:16:52 +0300
Message-ID: <20140924111652.6539.45946.stgit@potku.adurom.net> (sfid-20140924_131659_989988_A3F05A16)
In-Reply-To: <20140924111416.6539.95299.stgit@potku.adurom.net>
References: <20140924111416.6539.95299.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

diag_read() is used for reading from firmware memory via the diagnose window.
First user will be cal_data debugfs file.

To serialise diagnostic window access and make it safe to use while firmware is
running take ce_lock both in ath10k_pci_diag_write_mem() and
ath10k_pci_diag_read_mem(). Because of that all the CE calls had to be changed
to _nolock variants.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  |   22 +++++++-------
 drivers/net/wireless/ath/ath10k/ce.h  |   13 ++++++++
 drivers/net/wireless/ath/ath10k/hif.h |   10 ++++++
 drivers/net/wireless/ath/ath10k/pci.c |   51 +++++++++++++++++++++------------
 4 files changed, 67 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 09ef03e7af89..4745ef2a6f01 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -443,12 +443,12 @@ int ath10k_ce_rx_post_buf(struct ath10k_ce_pipe *pipe, void *ctx, u32 paddr)
  * Guts of ath10k_ce_completed_recv_next.
  * The caller takes responsibility for any necessary locking.
  */
-static int ath10k_ce_completed_recv_next_nolock(struct ath10k_ce_pipe *ce_state,
-						void **per_transfer_contextp,
-						u32 *bufferp,
-						unsigned int *nbytesp,
-						unsigned int *transfer_idp,
-						unsigned int *flagsp)
+int ath10k_ce_completed_recv_next_nolock(struct ath10k_ce_pipe *ce_state,
+					 void **per_transfer_contextp,
+					 u32 *bufferp,
+					 unsigned int *nbytesp,
+					 unsigned int *transfer_idp,
+					 unsigned int *flagsp)
 {
 	struct ath10k_ce_ring *dest_ring = ce_state->dest_ring;
 	unsigned int nentries_mask = dest_ring->nentries_mask;
@@ -576,11 +576,11 @@ int ath10k_ce_revoke_recv_next(struct ath10k_ce_pipe *ce_state,
  * Guts of ath10k_ce_completed_send_next.
  * The caller takes responsibility for any necessary locking.
  */
-static int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
-						void **per_transfer_contextp,
-						u32 *bufferp,
-						unsigned int *nbytesp,
-						unsigned int *transfer_idp)
+int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
+					 void **per_transfer_contextp,
+					 u32 *bufferp,
+					 unsigned int *nbytesp,
+					 unsigned int *transfer_idp)
 {
 	struct ath10k_ce_ring *src_ring = ce_state->src_ring;
 	u32 ctrl_addr = ce_state->ctrl_addr;
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 329b7340fa72..608262ab964e 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -192,6 +192,12 @@ int ath10k_ce_completed_send_next(struct ath10k_ce_pipe *ce_state,
 				  unsigned int *nbytesp,
 				  unsigned int *transfer_idp);
 
+int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
+					 void **per_transfer_contextp,
+					 u32 *bufferp,
+					 unsigned int *nbytesp,
+					 unsigned int *transfer_idp);
+
 /*==================CE Engine Initialization=======================*/
 
 int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
@@ -213,6 +219,13 @@ int ath10k_ce_revoke_recv_next(struct ath10k_ce_pipe *ce_state,
 			       void **per_transfer_contextp,
 			       u32 *bufferp);
 
+int ath10k_ce_completed_recv_next_nolock(struct ath10k_ce_pipe *ce_state,
+					 void **per_transfer_contextp,
+					 u32 *bufferp,
+					 unsigned int *nbytesp,
+					 unsigned int *transfer_idp,
+					 unsigned int *flagsp);
+
 /*
  * Support clean shutdown by allowing the caller to cancel
  * pending sends.  Target DMA must be stopped before using
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 62323fea27e1..30301f5b6051 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -43,6 +43,10 @@ struct ath10k_hif_ops {
 	int (*tx_sg)(struct ath10k *ar, u8 pipe_id,
 		     struct ath10k_hif_sg_item *items, int n_items);
 
+	/* read firmware memory through the diagnose interface */
+	int (*diag_read)(struct ath10k *ar, u32 address, void *buf,
+			 size_t buf_len);
+
 	/*
 	 * API to handle HIF-specific BMI message exchanges, this API is
 	 * synchronous and only allowed to be called from a context that
@@ -98,6 +102,12 @@ static inline int ath10k_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
 	return ar->hif.ops->tx_sg(ar, pipe_id, items, n_items);
 }
 
+static inline int ath10k_hif_diag_read(struct ath10k *ar, u32 address, void *buf,
+				       size_t buf_len)
+{
+	return ar->hif.ops->diag_read(ar, address, buf, buf_len);
+}
+
 static inline int ath10k_hif_exchange_bmi_msg(struct ath10k *ar,
 					      void *request, u32 request_len,
 					      void *response, u32 *response_len)
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 59e0ea83be50..0784b48b04ce 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -485,6 +485,8 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 	void *data_buf = NULL;
 	int i;
 
+	spin_lock_bh(&ar_pci->ce_lock);
+
 	ce_diag = ar_pci->ce_diag;
 
 	/*
@@ -511,7 +513,7 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		nbytes = min_t(unsigned int, remaining_bytes,
 			       DIAG_TRANSFER_LIMIT);
 
-		ret = ath10k_ce_rx_post_buf(ce_diag, NULL, ce_data);
+		ret = __ath10k_ce_rx_post_buf(ce_diag, NULL, ce_data);
 		if (ret != 0)
 			goto done;
 
@@ -527,15 +529,15 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		address = TARG_CPU_SPACE_TO_CE_SPACE(ar, ar_pci->mem,
 						     address);
 
-		ret = ath10k_ce_send(ce_diag, NULL, (u32)address, nbytes, 0,
-				     0);
+		ret = ath10k_ce_send_nolock(ce_diag, NULL, (u32)address, nbytes, 0,
+					    0);
 		if (ret)
 			goto done;
 
 		i = 0;
-		while (ath10k_ce_completed_send_next(ce_diag, NULL, &buf,
-						     &completed_nbytes,
-						     &id) != 0) {
+		while (ath10k_ce_completed_send_next_nolock(ce_diag, NULL, &buf,
+							    &completed_nbytes,
+							    &id) != 0) {
 			mdelay(1);
 			if (i++ > DIAG_ACCESS_CE_TIMEOUT_MS) {
 				ret = -EBUSY;
@@ -554,9 +556,9 @@ static int ath10k_pci_diag_read_mem(struct ath10k *ar, u32 address, void *data,
 		}
 
 		i = 0;
-		while (ath10k_ce_completed_recv_next(ce_diag, NULL, &buf,
-						     &completed_nbytes,
-						     &id, &flags) != 0) {
+		while (ath10k_ce_completed_recv_next_nolock(ce_diag, NULL, &buf,
+							    &completed_nbytes,
+							    &id, &flags) != 0) {
 			mdelay(1);
 
 			if (i++ > DIAG_ACCESS_CE_TIMEOUT_MS) {
@@ -591,6 +593,8 @@ done:
 		dma_free_coherent(ar->dev, orig_nbytes, data_buf,
 				  ce_data_base);
 
+	spin_unlock_bh(&ar_pci->ce_lock);
+
 	return ret;
 }
 
@@ -648,6 +652,8 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 	dma_addr_t ce_data_base = 0;
 	int i;
 
+	spin_lock_bh(&ar_pci->ce_lock);
+
 	ce_diag = ar_pci->ce_diag;
 
 	/*
@@ -688,7 +694,7 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		nbytes = min_t(int, remaining_bytes, DIAG_TRANSFER_LIMIT);
 
 		/* Set up to receive directly into Target(!) address */
-		ret = ath10k_ce_rx_post_buf(ce_diag, NULL, address);
+		ret = __ath10k_ce_rx_post_buf(ce_diag, NULL, address);
 		if (ret != 0)
 			goto done;
 
@@ -696,15 +702,15 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		 * Request CE to send caller-supplied data that
 		 * was copied to bounce buffer to Target(!) address.
 		 */
-		ret = ath10k_ce_send(ce_diag, NULL, (u32)ce_data,
-				     nbytes, 0, 0);
+		ret = ath10k_ce_send_nolock(ce_diag, NULL, (u32)ce_data,
+					    nbytes, 0, 0);
 		if (ret != 0)
 			goto done;
 
 		i = 0;
-		while (ath10k_ce_completed_send_next(ce_diag, NULL, &buf,
-						     &completed_nbytes,
-						     &id) != 0) {
+		while (ath10k_ce_completed_send_next_nolock(ce_diag, NULL, &buf,
+							    &completed_nbytes,
+							    &id) != 0) {
 			mdelay(1);
 
 			if (i++ > DIAG_ACCESS_CE_TIMEOUT_MS) {
@@ -724,9 +730,9 @@ static int ath10k_pci_diag_write_mem(struct ath10k *ar, u32 address,
 		}
 
 		i = 0;
-		while (ath10k_ce_completed_recv_next(ce_diag, NULL, &buf,
-						     &completed_nbytes,
-						     &id, &flags) != 0) {
+		while (ath10k_ce_completed_recv_next_nolock(ce_diag, NULL, &buf,
+							    &completed_nbytes,
+							    &id, &flags) != 0) {
 			mdelay(1);
 
 			if (i++ > DIAG_ACCESS_CE_TIMEOUT_MS) {
@@ -760,6 +766,8 @@ done:
 		ath10k_warn(ar, "failed to write diag value at 0x%x: %d\n",
 			    address, ret);
 
+	spin_unlock_bh(&ar_pci->ce_lock);
+
 	return ret;
 }
 
@@ -936,6 +944,12 @@ err:
 	return err;
 }
 
+static int ath10k_pci_hif_diag_read(struct ath10k *ar, u32 address, void *buf,
+				    size_t buf_len)
+{
+	return ath10k_pci_diag_read_mem(ar, address, buf, buf_len);
+}
+
 static u16 ath10k_pci_hif_get_free_queue_number(struct ath10k *ar, u8 pipe)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -1921,6 +1935,7 @@ static int ath10k_pci_hif_resume(struct ath10k *ar)
 
 static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.tx_sg			= ath10k_pci_hif_tx_sg,
+	.diag_read		= ath10k_pci_hif_diag_read,
 	.exchange_bmi_msg	= ath10k_pci_hif_exchange_bmi_msg,
 	.start			= ath10k_pci_hif_start,
 	.stop			= ath10k_pci_hif_stop,

