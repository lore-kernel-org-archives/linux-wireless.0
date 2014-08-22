Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:46952 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069AbaHVMda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 08:33:30 -0400
Received: by mail-lb0-f173.google.com with SMTP id u10so9393487lbd.18
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 05:33:29 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 4/6] ath10k: split ce irq/handler setup
Date: Fri, 22 Aug 2014 14:23:32 +0200
Message-Id: <1408710214-24894-5-git-send-email-michal.kazior@tieto.com> (sfid-20140822_143335_801602_6231892B)
In-Reply-To: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
References: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make much sense to overwrite send_cb
and recv_cb callbacks over and over again whenever
transport starts. Just make sure to unmask copy
engine interrupts when starting.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  | 36 +++++++++++-------------------
 drivers/net/wireless/ath/ath10k/ce.h  | 12 ++++------
 drivers/net/wireless/ath/ath10k/pci.c | 41 ++++-------------------------------
 3 files changed, 21 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 5117705..8cbc0ab 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -769,11 +769,11 @@ void ath10k_ce_per_engine_service_any(struct ath10k *ar)
  *
  * Called with ce_lock held.
  */
-static void ath10k_ce_per_engine_handler_adjust(struct ath10k_ce_pipe *ce_state,
-						int disable_copy_compl_intr)
+static void ath10k_ce_per_engine_handler_adjust(struct ath10k_ce_pipe *ce_state)
 {
 	u32 ctrl_addr = ce_state->ctrl_addr;
 	struct ath10k *ar = ce_state->ar;
+	bool disable_copy_compl_intr = ce_state->attr_flags & CE_ATTR_DIS_INTR;
 
 	if ((!disable_copy_compl_intr) &&
 	    (ce_state->send_cb || ce_state->recv_cb))
@@ -799,29 +799,13 @@ int ath10k_ce_disable_interrupts(struct ath10k *ar)
 	return 0;
 }
 
-void ath10k_ce_send_cb_register(struct ath10k_ce_pipe *ce_state,
-				void (*send_cb)(struct ath10k_ce_pipe *),
-				int disable_interrupts)
+void ath10k_ce_enable_interrupts(struct ath10k *ar)
 {
-	struct ath10k *ar = ce_state->ar;
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-
-	spin_lock_bh(&ar_pci->ce_lock);
-	ce_state->send_cb = send_cb;
-	ath10k_ce_per_engine_handler_adjust(ce_state, disable_interrupts);
-	spin_unlock_bh(&ar_pci->ce_lock);
-}
-
-void ath10k_ce_recv_cb_register(struct ath10k_ce_pipe *ce_state,
-				void (*recv_cb)(struct ath10k_ce_pipe *))
-{
-	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	int ce_id;
 
-	spin_lock_bh(&ar_pci->ce_lock);
-	ce_state->recv_cb = recv_cb;
-	ath10k_ce_per_engine_handler_adjust(ce_state, 0);
-	spin_unlock_bh(&ar_pci->ce_lock);
+	for (ce_id = 0; ce_id < CE_COUNT; ce_id++)
+		ath10k_ce_per_engine_handler_adjust(&ar_pci->ce_states[ce_id]);
 }
 
 static int ath10k_ce_init_src_ring(struct ath10k *ar,
@@ -1023,7 +1007,9 @@ ath10k_ce_alloc_dest_ring(struct ath10k *ar, unsigned int ce_id,
  * initialized by software/firmware.
  */
 int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
-			const struct ce_attr *attr)
+			const struct ce_attr *attr,
+			void (*send_cb)(struct ath10k_ce_pipe *),
+			void (*recv_cb)(struct ath10k_ce_pipe *))
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
@@ -1046,6 +1032,10 @@ int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
 	ce_state->ctrl_addr = ath10k_ce_base_address(ce_id);
 	ce_state->attr_flags = attr->flags;
 	ce_state->src_sz_max = attr->src_sz_max;
+	if (attr->src_nentries)
+		ce_state->send_cb = send_cb;
+	if (attr->dest_nentries)
+		ce_state->recv_cb = recv_cb;
 	spin_unlock_bh(&ar_pci->ce_lock);
 
 	if (attr->src_nentries) {
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 7a5a36f..d48dbb9 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -162,10 +162,6 @@ int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 
 void __ath10k_ce_send_revert(struct ath10k_ce_pipe *pipe);
 
-void ath10k_ce_send_cb_register(struct ath10k_ce_pipe *ce_state,
-				void (*send_cb)(struct ath10k_ce_pipe *),
-				int disable_interrupts);
-
 int ath10k_ce_num_free_src_entries(struct ath10k_ce_pipe *pipe);
 
 /*==================Recv=======================*/
@@ -184,9 +180,6 @@ int ath10k_ce_recv_buf_enqueue(struct ath10k_ce_pipe *ce_state,
 			       void *per_transfer_recv_context,
 			       u32 buffer);
 
-void ath10k_ce_recv_cb_register(struct ath10k_ce_pipe *ce_state,
-				void (*recv_cb)(struct ath10k_ce_pipe *));
-
 /* recv flags */
 /* Data is byte-swapped */
 #define CE_RECV_FLAG_SWAPPED	1
@@ -214,7 +207,9 @@ int ath10k_ce_completed_send_next(struct ath10k_ce_pipe *ce_state,
 /*==================CE Engine Initialization=======================*/
 
 int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
-			const struct ce_attr *attr);
+			const struct ce_attr *attr,
+			void (*send_cb)(struct ath10k_ce_pipe *),
+			void (*recv_cb)(struct ath10k_ce_pipe *));
 void ath10k_ce_deinit_pipe(struct ath10k *ar, unsigned int ce_id);
 int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
 			  const struct ce_attr *attr);
@@ -245,6 +240,7 @@ int ath10k_ce_cancel_send_next(struct ath10k_ce_pipe *ce_state,
 void ath10k_ce_per_engine_service_any(struct ath10k *ar);
 void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id);
 int ath10k_ce_disable_interrupts(struct ath10k *ar);
+void ath10k_ce_enable_interrupts(struct ath10k *ar);
 
 /* ce_attr.flags values */
 /* Use NonSnooping PCIe accesses? */
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index c3b3f62..c764dd7 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -941,37 +941,6 @@ static void ath10k_pci_hif_set_callbacks(struct ath10k *ar,
 	       sizeof(ar_pci->msg_callbacks_current));
 }
 
-static int ath10k_pci_setup_ce_irq(struct ath10k *ar)
-{
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	const struct ce_attr *attr;
-	struct ath10k_pci_pipe *pipe_info;
-	int pipe_num, disable_interrupts;
-
-	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
-		pipe_info = &ar_pci->pipe_info[pipe_num];
-
-		/* Handle Diagnostic CE specially */
-		if (pipe_info->ce_hdl == ar_pci->ce_diag)
-			continue;
-
-		attr = &host_ce_config_wlan[pipe_num];
-
-		if (attr->src_nentries) {
-			disable_interrupts = attr->flags & CE_ATTR_DIS_INTR;
-			ath10k_ce_send_cb_register(pipe_info->ce_hdl,
-						   ath10k_pci_ce_send_done,
-						   disable_interrupts);
-		}
-
-		if (attr->dest_nentries)
-			ath10k_ce_recv_cb_register(pipe_info->ce_hdl,
-						   ath10k_pci_ce_recv_data);
-	}
-
-	return 0;
-}
-
 static void ath10k_pci_kill_tasklet(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -1169,11 +1138,7 @@ static int ath10k_pci_hif_start(struct ath10k *ar)
 		goto err_early_irq;
 	}
 
-	ret = ath10k_pci_setup_ce_irq(ar);
-	if (ret) {
-		ath10k_warn("failed to setup CE interrupts: %d\n", ret);
-		goto err_stop;
-	}
+	ath10k_ce_enable_interrupts(ar);
 
 	/* Post buffers once to start things off. */
 	ret = ath10k_pci_post_rx(ar);
@@ -1786,7 +1751,9 @@ static int ath10k_pci_ce_init(struct ath10k *ar)
 		pipe_info->hif_ce_state = ar;
 		attr = &host_ce_config_wlan[pipe_num];
 
-		ret = ath10k_ce_init_pipe(ar, pipe_num, attr);
+		ret = ath10k_ce_init_pipe(ar, pipe_num, attr,
+					  ath10k_pci_ce_send_done,
+					  ath10k_pci_ce_recv_data);
 		if (ret) {
 			ath10k_err("failed to initialize copy engine pipe %d: %d\n",
 				   pipe_num, ret);
-- 
1.8.5.3

