Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:64708 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaCYLSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 07:18:22 -0400
Received: by mail-ee0-f53.google.com with SMTP id b57so305363eek.26
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 04:18:21 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: split ce initialization and allocation
Date: Tue, 25 Mar 2014 12:12:23 +0100
Message-Id: <1395745943-29492-3-git-send-email-michal.kazior@tieto.com> (sfid-20140325_121827_396778_17470E0A)
In-Reply-To: <1395745943-29492-1-git-send-email-michal.kazior@tieto.com>
References: <1395745943-29492-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Definitions by which copy engine structure are
allocated do not change so it doesn't make much
sense to re-create those structures each time
device is booted (e.g. due to firmware recovery).

This should decrease chance of memory allocation
failures.

Reported-By: Avery Pennarun <apenwarr@gmail.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  | 307 ++++++++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/ce.h  |  15 +-
 drivers/net/wireless/ath/ath10k/pci.c |  66 +++++---
 3 files changed, 229 insertions(+), 159 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 653a240..1e4cad8 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -840,34 +840,17 @@ void ath10k_ce_recv_cb_register(struct ath10k_ce_pipe *ce_state,
 
 static int ath10k_ce_init_src_ring(struct ath10k *ar,
 				   unsigned int ce_id,
-				   struct ath10k_ce_pipe *ce_state,
 				   const struct ce_attr *attr)
 {
-	struct ath10k_ce_ring *src_ring;
-	unsigned int nentries = attr->src_nentries;
-	unsigned int ce_nbytes;
-	u32 ctrl_addr = ath10k_ce_base_address(ce_id);
-	dma_addr_t base_addr;
-	char *ptr;
-
-	nentries = roundup_pow_of_two(nentries);
-
-	if (ce_state->src_ring) {
-		WARN_ON(ce_state->src_ring->nentries != nentries);
-		return 0;
-	}
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
+	struct ath10k_ce_ring *src_ring = ce_state->src_ring;
+	u32 nentries, ctrl_addr = ath10k_ce_base_address(ce_id);
 
-	ce_nbytes = sizeof(struct ath10k_ce_ring) + (nentries * sizeof(void *));
-	ptr = kzalloc(ce_nbytes, GFP_KERNEL);
-	if (ptr == NULL)
-		return -ENOMEM;
+	nentries = roundup_pow_of_two(attr->src_nentries);
 
-	ce_state->src_ring = (struct ath10k_ce_ring *)ptr;
-	src_ring = ce_state->src_ring;
-
-	ptr += sizeof(struct ath10k_ce_ring);
-	src_ring->nentries = nentries;
-	src_ring->nentries_mask = nentries - 1;
+	memset(src_ring->per_transfer_context, 0,
+	       nentries * sizeof(*src_ring->per_transfer_context));
 
 	src_ring->sw_index = ath10k_ce_src_ring_read_index_get(ar, ctrl_addr);
 	src_ring->sw_index &= src_ring->nentries_mask;
@@ -877,7 +860,74 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 		ath10k_ce_src_ring_write_index_get(ar, ctrl_addr);
 	src_ring->write_index &= src_ring->nentries_mask;
 
-	src_ring->per_transfer_context = (void **)ptr;
+	ath10k_ce_src_ring_base_addr_set(ar, ctrl_addr,
+					 src_ring->base_addr_ce_space);
+	ath10k_ce_src_ring_size_set(ar, ctrl_addr, nentries);
+	ath10k_ce_src_ring_dmax_set(ar, ctrl_addr, attr->src_sz_max);
+	ath10k_ce_src_ring_byte_swap_set(ar, ctrl_addr, 0);
+	ath10k_ce_src_ring_lowmark_set(ar, ctrl_addr, 0);
+	ath10k_ce_src_ring_highmark_set(ar, ctrl_addr, nentries);
+
+	ath10k_dbg(ATH10K_DBG_BOOT,
+		   "boot init ce src ring id %d entries %d base_addr %p\n",
+		   ce_id, nentries, src_ring->base_addr_owner_space);
+
+	return 0;
+}
+
+static int ath10k_ce_init_dest_ring(struct ath10k *ar,
+				    unsigned int ce_id,
+				    const struct ce_attr *attr)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
+	struct ath10k_ce_ring *dest_ring = ce_state->dest_ring;
+	u32 nentries, ctrl_addr = ath10k_ce_base_address(ce_id);
+
+	nentries = roundup_pow_of_two(attr->dest_nentries);
+
+	memset(dest_ring->per_transfer_context, 0,
+	       nentries * sizeof(*dest_ring->per_transfer_context));
+
+	dest_ring->sw_index = ath10k_ce_dest_ring_read_index_get(ar, ctrl_addr);
+	dest_ring->sw_index &= dest_ring->nentries_mask;
+	dest_ring->write_index =
+		ath10k_ce_dest_ring_write_index_get(ar, ctrl_addr);
+	dest_ring->write_index &= dest_ring->nentries_mask;
+
+	ath10k_ce_dest_ring_base_addr_set(ar, ctrl_addr,
+					  dest_ring->base_addr_ce_space);
+	ath10k_ce_dest_ring_size_set(ar, ctrl_addr, nentries);
+	ath10k_ce_dest_ring_byte_swap_set(ar, ctrl_addr, 0);
+	ath10k_ce_dest_ring_lowmark_set(ar, ctrl_addr, 0);
+	ath10k_ce_dest_ring_highmark_set(ar, ctrl_addr, nentries);
+
+	ath10k_dbg(ATH10K_DBG_BOOT,
+		   "boot ce dest ring id %d entries %d base_addr %p\n",
+		   ce_id, nentries, dest_ring->base_addr_owner_space);
+
+	return 0;
+}
+
+static struct ath10k_ce_ring *
+ath10k_ce_alloc_src_ring(struct ath10k *ar, unsigned int ce_id,
+			 const struct ce_attr *attr)
+{
+	struct ath10k_ce_ring *src_ring;
+	u32 nentries = attr->src_nentries;
+	dma_addr_t base_addr;
+
+	nentries = roundup_pow_of_two(nentries);
+
+	src_ring = kzalloc(sizeof(*src_ring) +
+			   (nentries *
+			    sizeof(*src_ring->per_transfer_context)),
+			   GFP_KERNEL);
+	if (src_ring == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	src_ring->nentries = nentries;
+	src_ring->nentries_mask = nentries - 1;
 
 	/*
 	 * Legacy platforms that do not support cache
@@ -889,9 +939,8 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 				    CE_DESC_RING_ALIGN),
 				   &base_addr, GFP_KERNEL);
 	if (!src_ring->base_addr_owner_space_unaligned) {
-		kfree(ce_state->src_ring);
-		ce_state->src_ring = NULL;
-		return -ENOMEM;
+		kfree(src_ring);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	src_ring->base_addr_ce_space_unaligned = base_addr;
@@ -916,69 +965,37 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 				   CE_DESC_RING_ALIGN),
 				  src_ring->base_addr_owner_space,
 				  src_ring->base_addr_ce_space);
-		kfree(ce_state->src_ring);
-		ce_state->src_ring = NULL;
-		return -ENOMEM;
+		kfree(src_ring);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	src_ring->shadow_base = PTR_ALIGN(
 			src_ring->shadow_base_unaligned,
 			CE_DESC_RING_ALIGN);
 
-	ath10k_ce_src_ring_base_addr_set(ar, ctrl_addr,
-					 src_ring->base_addr_ce_space);
-	ath10k_ce_src_ring_size_set(ar, ctrl_addr, nentries);
-	ath10k_ce_src_ring_dmax_set(ar, ctrl_addr, attr->src_sz_max);
-	ath10k_ce_src_ring_byte_swap_set(ar, ctrl_addr, 0);
-	ath10k_ce_src_ring_lowmark_set(ar, ctrl_addr, 0);
-	ath10k_ce_src_ring_highmark_set(ar, ctrl_addr, nentries);
-
-	ath10k_dbg(ATH10K_DBG_BOOT,
-		   "boot ce src ring id %d entries %d base_addr %p\n",
-		   ce_id, nentries, src_ring->base_addr_owner_space);
-
-	return 0;
+	return src_ring;
 }
 
-static int ath10k_ce_init_dest_ring(struct ath10k *ar,
-				    unsigned int ce_id,
-				    struct ath10k_ce_pipe *ce_state,
-				    const struct ce_attr *attr)
+static struct ath10k_ce_ring *
+ath10k_ce_alloc_dest_ring(struct ath10k *ar, unsigned int ce_id,
+			  const struct ce_attr *attr)
 {
 	struct ath10k_ce_ring *dest_ring;
-	unsigned int nentries = attr->dest_nentries;
-	unsigned int ce_nbytes;
-	u32 ctrl_addr = ath10k_ce_base_address(ce_id);
+	u32 nentries;
 	dma_addr_t base_addr;
-	char *ptr;
 
-	nentries = roundup_pow_of_two(nentries);
+	nentries = roundup_pow_of_two(attr->dest_nentries);
 
-	if (ce_state->dest_ring) {
-		WARN_ON(ce_state->dest_ring->nentries != nentries);
-		return 0;
-	}
-
-	ce_nbytes = sizeof(struct ath10k_ce_ring) + (nentries * sizeof(void *));
-	ptr = kzalloc(ce_nbytes, GFP_KERNEL);
-	if (ptr == NULL)
-		return -ENOMEM;
-
-	ce_state->dest_ring = (struct ath10k_ce_ring *)ptr;
-	dest_ring = ce_state->dest_ring;
+	dest_ring = kzalloc(sizeof(*dest_ring) +
+			    (nentries *
+			     sizeof(*dest_ring->per_transfer_context)),
+			    GFP_KERNEL);
+	if (dest_ring == NULL)
+		return ERR_PTR(-ENOMEM);
 
-	ptr += sizeof(struct ath10k_ce_ring);
 	dest_ring->nentries = nentries;
 	dest_ring->nentries_mask = nentries - 1;
 
-	dest_ring->sw_index = ath10k_ce_dest_ring_read_index_get(ar, ctrl_addr);
-	dest_ring->sw_index &= dest_ring->nentries_mask;
-	dest_ring->write_index =
-		ath10k_ce_dest_ring_write_index_get(ar, ctrl_addr);
-	dest_ring->write_index &= dest_ring->nentries_mask;
-
-	dest_ring->per_transfer_context = (void **)ptr;
-
 	/*
 	 * Legacy platforms that do not support cache
 	 * coherent DMA are unsupported
@@ -989,9 +1006,8 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 				    CE_DESC_RING_ALIGN),
 				   &base_addr, GFP_KERNEL);
 	if (!dest_ring->base_addr_owner_space_unaligned) {
-		kfree(ce_state->dest_ring);
-		ce_state->dest_ring = NULL;
-		return -ENOMEM;
+		kfree(dest_ring);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	dest_ring->base_addr_ce_space_unaligned = base_addr;
@@ -1010,39 +1026,7 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 			dest_ring->base_addr_ce_space_unaligned,
 			CE_DESC_RING_ALIGN);
 
-	ath10k_ce_dest_ring_base_addr_set(ar, ctrl_addr,
-					  dest_ring->base_addr_ce_space);
-	ath10k_ce_dest_ring_size_set(ar, ctrl_addr, nentries);
-	ath10k_ce_dest_ring_byte_swap_set(ar, ctrl_addr, 0);
-	ath10k_ce_dest_ring_lowmark_set(ar, ctrl_addr, 0);
-	ath10k_ce_dest_ring_highmark_set(ar, ctrl_addr, nentries);
-
-	ath10k_dbg(ATH10K_DBG_BOOT,
-		   "boot ce dest ring id %d entries %d base_addr %p\n",
-		   ce_id, nentries, dest_ring->base_addr_owner_space);
-
-	return 0;
-}
-
-static struct ath10k_ce_pipe *ath10k_ce_init_state(struct ath10k *ar,
-					     unsigned int ce_id,
-					     const struct ce_attr *attr)
-{
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
-	u32 ctrl_addr = ath10k_ce_base_address(ce_id);
-
-	spin_lock_bh(&ar_pci->ce_lock);
-
-	ce_state->ar = ar;
-	ce_state->id = ce_id;
-	ce_state->ctrl_addr = ctrl_addr;
-	ce_state->attr_flags = attr->flags;
-	ce_state->src_sz_max = attr->src_sz_max;
-
-	spin_unlock_bh(&ar_pci->ce_lock);
-
-	return ce_state;
+	return dest_ring;
 }
 
 /*
@@ -1052,11 +1036,11 @@ static struct ath10k_ce_pipe *ath10k_ce_init_state(struct ath10k *ar,
  * initialization. It may be that only one side or the other is
  * initialized by software/firmware.
  */
-struct ath10k_ce_pipe *ath10k_ce_init(struct ath10k *ar,
-				unsigned int ce_id,
-				const struct ce_attr *attr)
+int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
+			const struct ce_attr *attr)
 {
-	struct ath10k_ce_pipe *ce_state;
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
 	int ret;
 
 	/*
@@ -1072,44 +1056,109 @@ struct ath10k_ce_pipe *ath10k_ce_init(struct ath10k *ar,
 
 	ret = ath10k_pci_wake(ar);
 	if (ret)
-		return NULL;
+		return ret;
 
-	ce_state = ath10k_ce_init_state(ar, ce_id, attr);
-	if (!ce_state) {
-		ath10k_err("Failed to initialize CE state for ID: %d\n", ce_id);
-		goto out;
-	}
+	spin_lock_bh(&ar_pci->ce_lock);
+	ce_state->ar = ar;
+	ce_state->id = ce_id;
+	ce_state->ctrl_addr = ath10k_ce_base_address(ce_id);
+	ce_state->attr_flags = attr->flags;
+	ce_state->src_sz_max = attr->src_sz_max;
+	spin_unlock_bh(&ar_pci->ce_lock);
 
 	if (attr->src_nentries) {
-		ret = ath10k_ce_init_src_ring(ar, ce_id, ce_state, attr);
+		ret = ath10k_ce_init_src_ring(ar, ce_id, attr);
 		if (ret) {
 			ath10k_err("Failed to initialize CE src ring for ID: %d (%d)\n",
 				   ce_id, ret);
-			ath10k_ce_deinit(ce_state);
-			ce_state = NULL;
 			goto out;
 		}
 	}
 
 	if (attr->dest_nentries) {
-		ret = ath10k_ce_init_dest_ring(ar, ce_id, ce_state, attr);
+		ret = ath10k_ce_init_dest_ring(ar, ce_id, attr);
 		if (ret) {
 			ath10k_err("Failed to initialize CE dest ring for ID: %d (%d)\n",
 				   ce_id, ret);
-			ath10k_ce_deinit(ce_state);
-			ce_state = NULL;
 			goto out;
 		}
 	}
 
 out:
 	ath10k_pci_sleep(ar);
-	return ce_state;
+	return ret;
 }
 
-void ath10k_ce_deinit(struct ath10k_ce_pipe *ce_state)
+static void ath10k_ce_deinit_src_ring(struct ath10k *ar, unsigned int ce_id)
 {
-	struct ath10k *ar = ce_state->ar;
+	u32 ctrl_addr = ath10k_ce_base_address(ce_id);
+
+	ath10k_ce_src_ring_base_addr_set(ar, ctrl_addr, 0);
+	ath10k_ce_src_ring_size_set(ar, ctrl_addr, 0);
+	ath10k_ce_src_ring_dmax_set(ar, ctrl_addr, 0);
+	ath10k_ce_src_ring_highmark_set(ar, ctrl_addr, 0);
+}
+
+static void ath10k_ce_deinit_dest_ring(struct ath10k *ar, unsigned int ce_id)
+{
+	u32 ctrl_addr = ath10k_ce_base_address(ce_id);
+
+	ath10k_ce_dest_ring_base_addr_set(ar, ctrl_addr, 0);
+	ath10k_ce_dest_ring_size_set(ar, ctrl_addr, 0);
+	ath10k_ce_dest_ring_highmark_set(ar, ctrl_addr, 0);
+}
+
+void ath10k_ce_deinit_pipe(struct ath10k *ar, unsigned int ce_id)
+{
+	int ret;
+
+	ret = ath10k_pci_wake(ar);
+	if (ret)
+		return;
+
+	ath10k_ce_deinit_src_ring(ar, ce_id);
+	ath10k_ce_deinit_dest_ring(ar, ce_id);
+
+	ath10k_pci_sleep(ar);
+}
+
+int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
+			 const struct ce_attr *attr)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
+	int ret;
+
+	if (attr->src_nentries) {
+		ce_state->src_ring = ath10k_ce_alloc_src_ring(ar, ce_id, attr);
+		if (IS_ERR(ce_state->src_ring)) {
+			ret = PTR_ERR(ce_state->src_ring);
+			ath10k_err("failed to allocate copy engine source ring %d: %d\n",
+				   ce_id, ret);
+			ce_state->src_ring = NULL;
+			return ret;
+		}
+	}
+
+	if (attr->dest_nentries) {
+		ce_state->dest_ring = ath10k_ce_alloc_dest_ring(ar, ce_id,
+								attr);
+		if (IS_ERR(ce_state->dest_ring)) {
+			ret = PTR_ERR(ce_state->dest_ring);
+			ath10k_err("failed to allocate copy engine destination ring %d: %d\n",
+				   ce_id, ret);
+			ce_state->dest_ring = NULL;
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+void ath10k_ce_free_pipe(struct ath10k *ar, int ce_id)
+{
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
 
 	if (ce_state->src_ring) {
 		kfree(ce_state->src_ring->shadow_base_unaligned);
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 8eb7f99..fd0bc35 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -104,7 +104,8 @@ struct ath10k_ce_ring {
 	void *shadow_base_unaligned;
 	struct ce_desc *shadow_base;
 
-	void **per_transfer_context;
+	/* keep last */
+	void *per_transfer_context[0];
 };
 
 struct ath10k_ce_pipe {
@@ -210,10 +211,12 @@ int ath10k_ce_completed_send_next(struct ath10k_ce_pipe *ce_state,
 
 /*==================CE Engine Initialization=======================*/
 
-/* Initialize an instance of a CE */
-struct ath10k_ce_pipe *ath10k_ce_init(struct ath10k *ar,
-				unsigned int ce_id,
-				const struct ce_attr *attr);
+int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
+			const struct ce_attr *attr);
+void ath10k_ce_deinit_pipe(struct ath10k *ar, unsigned int ce_id);
+int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
+			  const struct ce_attr *attr);
+void ath10k_ce_free_pipe(struct ath10k *ar, int ce_id);
 
 /*==================CE Engine Shutdown=======================*/
 /*
@@ -236,8 +239,6 @@ int ath10k_ce_cancel_send_next(struct ath10k_ce_pipe *ce_state,
 			       unsigned int *nbytesp,
 			       unsigned int *transfer_idp);
 
-void ath10k_ce_deinit(struct ath10k_ce_pipe *ce_state);
-
 /*==================CE Interrupt Handlers====================*/
 void ath10k_ce_per_engine_service_any(struct ath10k *ar);
 void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id);
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 4cd3537..e0a6d68 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1255,18 +1255,10 @@ static void ath10k_pci_buffer_cleanup(struct ath10k *ar)
 
 static void ath10k_pci_ce_deinit(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_pci_pipe *pipe_info;
-	int pipe_num;
+	int i;
 
-	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
-		pipe_info = &ar_pci->pipe_info[pipe_num];
-		if (pipe_info->ce_hdl) {
-			ath10k_ce_deinit(pipe_info->ce_hdl);
-			pipe_info->ce_hdl = NULL;
-			pipe_info->buf_sz = 0;
-		}
-	}
+	for (i = 0; i < CE_COUNT; i++)
+		ath10k_ce_deinit_pipe(ar, i);
 }
 
 static void ath10k_pci_hif_stop(struct ath10k *ar)
@@ -1719,30 +1711,49 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_pci_alloc_ce(struct ath10k *ar)
+{
+	int i, ret;
+
+	for (i = 0; i < CE_COUNT; i++) {
+		ret = ath10k_ce_alloc_pipe(ar, i, &host_ce_config_wlan[i]);
+		if (ret) {
+			ath10k_err("failed to allocate copy engine pipe %d: %d\n",
+				   i, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static void ath10k_pci_free_ce(struct ath10k *ar)
+{
+	int i;
 
+	for (i = 0; i < CE_COUNT; i++)
+		ath10k_ce_free_pipe(ar, i);
+}
 
 static int ath10k_pci_ce_init(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_pci_pipe *pipe_info;
 	const struct ce_attr *attr;
-	int pipe_num;
+	int pipe_num, ret;
 
 	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
 		pipe_info = &ar_pci->pipe_info[pipe_num];
+		pipe_info->ce_hdl = &ar_pci->ce_states[pipe_num];
 		pipe_info->pipe_num = pipe_num;
 		pipe_info->hif_ce_state = ar;
 		attr = &host_ce_config_wlan[pipe_num];
 
-		pipe_info->ce_hdl = ath10k_ce_init(ar, pipe_num, attr);
-		if (pipe_info->ce_hdl == NULL) {
-			ath10k_err("failed to initialize CE for pipe: %d\n",
-				   pipe_num);
-
-			/* It is safe to call it here. It checks if ce_hdl is
-			 * valid for each pipe */
-			ath10k_pci_ce_deinit(ar);
-			return -1;
+		ret = ath10k_ce_init_pipe(ar, pipe_num, attr);
+		if (ret) {
+			ath10k_err("failed to initialize copy engine pipe %d: %d\n",
+				   pipe_num, ret);
+			return ret;
 		}
 
 		if (pipe_num == CE_COUNT - 1) {
@@ -2018,9 +2029,9 @@ static void ath10k_pci_hif_power_down(struct ath10k *ar)
 	ath10k_pci_free_early_irq(ar);
 	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_deinit_irq(ar);
+	ath10k_pci_ce_deinit(ar);
 	ath10k_pci_warm_reset(ar);
 
-	ath10k_pci_ce_deinit(ar);
 	if (!test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
 		ath10k_do_pci_sleep(ar);
 }
@@ -2642,16 +2653,24 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 	ath10k_do_pci_sleep(ar);
 
+	ret = ath10k_pci_alloc_ce(ar);
+	if (ret) {
+		ath10k_err("failed to allocate copy engine pipes: %d\n", ret);
+		goto err_iomap;
+	}
+
 	ath10k_dbg(ATH10K_DBG_BOOT, "boot pci_mem 0x%p\n", ar_pci->mem);
 
 	ret = ath10k_core_register(ar, chip_id);
 	if (ret) {
 		ath10k_err("failed to register driver core: %d\n", ret);
-		goto err_iomap;
+		goto err_free_ce;
 	}
 
 	return 0;
 
+err_free_ce:
+	ath10k_pci_free_ce(ar);
 err_iomap:
 	pci_iounmap(pdev, mem);
 err_master:
@@ -2687,6 +2706,7 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 	tasklet_kill(&ar_pci->msi_fw_err);
 
 	ath10k_core_unregister(ar);
+	ath10k_pci_free_ce(ar);
 
 	pci_iounmap(pdev, ar_pci->mem);
 	pci_release_region(pdev, BAR_NUM);
-- 
1.8.5.3

