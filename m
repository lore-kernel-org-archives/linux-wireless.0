Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:50674 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaJTM2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 08:28:33 -0400
Received: by mail-lb0-f176.google.com with SMTP id p9so3701647lbv.7
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 05:28:32 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 3/6] ath10k: split ce pipe init/alloc further
Date: Mon, 20 Oct 2014 14:14:39 +0200
Message-Id: <1413807282-27951-4-git-send-email-michal.kazior@tieto.com> (sfid-20141020_142839_893230_9FAB7E69)
In-Reply-To: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com>
References: <1413807282-27951-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calling init to reinit ce pipe state would also
re-set all static structure links and setting
(which don't change over driver lifecycle).

Make it so alloc links structures and initializes
static data and init part to setup state
variables and clear stuff.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v2:
     * add this patch to fix CE issue [Janusz]

 drivers/net/wireless/ath/ath10k/ce.c  | 56 ++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/ce.h  |  8 ++---
 drivers/net/wireless/ath/ath10k/pci.c | 67 ++++++++++++++++-------------------
 3 files changed, 62 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 4745ef2..9b89ac1 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1023,37 +1023,10 @@ ath10k_ce_alloc_dest_ring(struct ath10k *ar, unsigned int ce_id,
  * initialized by software/firmware.
  */
 int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
-			const struct ce_attr *attr,
-			void (*send_cb)(struct ath10k_ce_pipe *),
-			void (*recv_cb)(struct ath10k_ce_pipe *))
+			const struct ce_attr *attr)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
 	int ret;
 
-	/*
-	 * Make sure there's enough CE ringbuffer entries for HTT TX to avoid
-	 * additional TX locking checks.
-	 *
-	 * For the lack of a better place do the check here.
-	 */
-	BUILD_BUG_ON(2*TARGET_NUM_MSDU_DESC >
-		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
-	BUILD_BUG_ON(2*TARGET_10X_NUM_MSDU_DESC >
-		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
-
-	spin_lock_bh(&ar_pci->ce_lock);
-	ce_state->ar = ar;
-	ce_state->id = ce_id;
-	ce_state->ctrl_addr = ath10k_ce_base_address(ce_id);
-	ce_state->attr_flags = attr->flags;
-	ce_state->src_sz_max = attr->src_sz_max;
-	if (attr->src_nentries)
-		ce_state->send_cb = send_cb;
-	if (attr->dest_nentries)
-		ce_state->recv_cb = recv_cb;
-	spin_unlock_bh(&ar_pci->ce_lock);
-
 	if (attr->src_nentries) {
 		ret = ath10k_ce_init_src_ring(ar, ce_id, attr);
 		if (ret) {
@@ -1101,12 +1074,37 @@ void ath10k_ce_deinit_pipe(struct ath10k *ar, unsigned int ce_id)
 }
 
 int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
-			 const struct ce_attr *attr)
+			 const struct ce_attr *attr,
+			 void (*send_cb)(struct ath10k_ce_pipe *),
+			 void (*recv_cb)(struct ath10k_ce_pipe *))
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
 	int ret;
 
+	/*
+	 * Make sure there's enough CE ringbuffer entries for HTT TX to avoid
+	 * additional TX locking checks.
+	 *
+	 * For the lack of a better place do the check here.
+	 */
+	BUILD_BUG_ON(2*TARGET_NUM_MSDU_DESC >
+		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
+	BUILD_BUG_ON(2*TARGET_10X_NUM_MSDU_DESC >
+		     (CE_HTT_H2T_MSG_SRC_NENTRIES - 1));
+
+	ce_state->ar = ar;
+	ce_state->id = ce_id;
+	ce_state->ctrl_addr = ath10k_ce_base_address(ce_id);
+	ce_state->attr_flags = attr->flags;
+	ce_state->src_sz_max = attr->src_sz_max;
+
+	if (attr->src_nentries)
+		ce_state->send_cb = send_cb;
+
+	if (attr->dest_nentries)
+		ce_state->recv_cb = recv_cb;
+
 	if (attr->src_nentries) {
 		ce_state->src_ring = ath10k_ce_alloc_src_ring(ar, ce_id, attr);
 		if (IS_ERR(ce_state->src_ring)) {
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 608262a..617a151 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -201,12 +201,12 @@ int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 /*==================CE Engine Initialization=======================*/
 
 int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
-			const struct ce_attr *attr,
-			void (*send_cb)(struct ath10k_ce_pipe *),
-			void (*recv_cb)(struct ath10k_ce_pipe *));
+			const struct ce_attr *attr);
 void ath10k_ce_deinit_pipe(struct ath10k *ar, unsigned int ce_id);
 int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
-			 const struct ce_attr *attr);
+			 const struct ce_attr *attr,
+			 void (*send_cb)(struct ath10k_ce_pipe *),
+			 void (*recv_cb)(struct ath10k_ce_pipe *));
 void ath10k_ce_free_pipe(struct ath10k *ar, int ce_id);
 
 /*==================CE Engine Shutdown=======================*/
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 5c5a9e7..c8cf177 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1615,23 +1615,40 @@ static int ath10k_pci_init_config(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_pci_alloc_ce(struct ath10k *ar)
+static int ath10k_pci_alloc_pipes(struct ath10k *ar)
 {
+	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
+	struct ath10k_pci_pipe *pipe;
 	int i, ret;
 
 	for (i = 0; i < CE_COUNT; i++) {
-		ret = ath10k_ce_alloc_pipe(ar, i, &host_ce_config_wlan[i]);
+		pipe = &ar_pci->pipe_info[i];
+		pipe->ce_hdl = &ar_pci->ce_states[i];
+		pipe->pipe_num = i;
+		pipe->hif_ce_state = ar;
+
+		ret = ath10k_ce_alloc_pipe(ar, i, &host_ce_config_wlan[i],
+					   ath10k_pci_ce_send_done,
+					   ath10k_pci_ce_recv_data);
 		if (ret) {
 			ath10k_err(ar, "failed to allocate copy engine pipe %d: %d\n",
 				   i, ret);
 			return ret;
 		}
+
+		/* Last CE is Diagnostic Window */
+		if (i == CE_COUNT - 1) {
+			ar_pci->ce_diag = pipe->ce_hdl;
+			continue;
+		}
+
+		pipe->buf_sz = (size_t)(host_ce_config_wlan[i].src_sz_max);
 	}
 
 	return 0;
 }
 
-static void ath10k_pci_free_ce(struct ath10k *ar)
+static void ath10k_pci_free_pipes(struct ath10k *ar)
 {
 	int i;
 
@@ -1639,39 +1656,17 @@ static void ath10k_pci_free_ce(struct ath10k *ar)
 		ath10k_ce_free_pipe(ar, i);
 }
 
-static int ath10k_pci_ce_init(struct ath10k *ar)
+static int ath10k_pci_init_pipes(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_pci_pipe *pipe_info;
-	const struct ce_attr *attr;
-	int pipe_num, ret;
+	int i, ret;
 
-	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
-		pipe_info = &ar_pci->pipe_info[pipe_num];
-		pipe_info->ce_hdl = &ar_pci->ce_states[pipe_num];
-		pipe_info->pipe_num = pipe_num;
-		pipe_info->hif_ce_state = ar;
-		attr = &host_ce_config_wlan[pipe_num];
-
-		ret = ath10k_ce_init_pipe(ar, pipe_num, attr,
-					  ath10k_pci_ce_send_done,
-					  ath10k_pci_ce_recv_data);
+	for (i = 0; i < CE_COUNT; i++) {
+		ret = ath10k_ce_init_pipe(ar, i, &host_ce_config_wlan[i]);
 		if (ret) {
 			ath10k_err(ar, "failed to initialize copy engine pipe %d: %d\n",
-				   pipe_num, ret);
+				   i, ret);
 			return ret;
 		}
-
-		if (pipe_num == CE_COUNT - 1) {
-			/*
-			 * Reserve the ultimate CE for
-			 * diagnostic Window support
-			 */
-			ar_pci->ce_diag = pipe_info->ce_hdl;
-			continue;
-		}
-
-		pipe_info->buf_sz = (size_t)(attr->src_sz_max);
 	}
 
 	return 0;
@@ -1825,7 +1820,7 @@ static int __ath10k_pci_hif_power_up(struct ath10k *ar, bool cold_reset)
 		goto err;
 	}
 
-	ret = ath10k_pci_ce_init(ar);
+	ret = ath10k_pci_init_pipes(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to initialize CE: %d\n", ret);
 		goto err;
@@ -2494,7 +2489,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 		goto err_sleep;
 	}
 
-	ret = ath10k_pci_alloc_ce(ar);
+	ret = ath10k_pci_alloc_pipes(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to allocate copy engine pipes: %d\n",
 			   ret);
@@ -2507,7 +2502,7 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ret = ath10k_pci_init_irq(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to init irqs: %d\n", ret);
-		goto err_free_ce;
+		goto err_free_pipes;
 	}
 
 	ath10k_info(ar, "pci irq %s interrupts %d irq_mode %d reset_mode %d\n",
@@ -2535,8 +2530,8 @@ err_free_irq:
 err_deinit_irq:
 	ath10k_pci_deinit_irq(ar);
 
-err_free_ce:
-	ath10k_pci_free_ce(ar);
+err_free_pipes:
+	ath10k_pci_free_pipes(ar);
 
 err_sleep:
 	ath10k_pci_sleep(ar);
@@ -2570,7 +2565,7 @@ static void ath10k_pci_remove(struct pci_dev *pdev)
 	ath10k_pci_kill_tasklet(ar);
 	ath10k_pci_deinit_irq(ar);
 	ath10k_pci_ce_deinit(ar);
-	ath10k_pci_free_ce(ar);
+	ath10k_pci_free_pipes(ar);
 	ath10k_pci_sleep(ar);
 	ath10k_pci_release(ar);
 	ath10k_core_destroy(ar);
-- 
1.8.5.3

