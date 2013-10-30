Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:43385 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab3J3LpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 07:45:11 -0400
Received: by mail-ee0-f49.google.com with SMTP id e52so559604eek.8
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 04:45:10 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH/RFT 01/12] ath10k: remove ar_pci->ce_count
Date: Wed, 30 Oct 2013 12:42:15 +0100
Message-Id: <1383133346-8135-2-git-send-email-michal.kazior@tieto.com> (sfid-20131030_124520_211089_CA1BDA57)
In-Reply-To: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It wasn't really useful to have it to begin with.
This makes it a little simpler to re-arrange PCI
init code as some function depended on
ar_pci->ce_count being set.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  |  9 +++------
 drivers/net/wireless/ath/ath10k/pci.c | 18 ++++++++----------
 drivers/net/wireless/ath/ath10k/pci.h |  3 ---
 3 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index d243f28..2b99bd4 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -731,7 +731,6 @@ void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id)
 
 void ath10k_ce_per_engine_service_any(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ce_id, ret;
 	u32 intr_summary;
 
@@ -741,7 +740,7 @@ void ath10k_ce_per_engine_service_any(struct ath10k *ar)
 
 	intr_summary = CE_INTERRUPT_SUMMARY(ar);
 
-	for (ce_id = 0; intr_summary && (ce_id < ar_pci->ce_count); ce_id++) {
+	for (ce_id = 0; intr_summary && (ce_id < CE_COUNT); ce_id++) {
 		if (intr_summary & (1 << ce_id))
 			intr_summary &= ~(1 << ce_id);
 		else
@@ -785,16 +784,14 @@ static void ath10k_ce_per_engine_handler_adjust(struct ath10k_ce_pipe *ce_state,
 
 void ath10k_ce_disable_interrupts(struct ath10k *ar)
 {
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ce_id, ret;
 
 	ret = ath10k_pci_wake(ar);
 	if (ret)
 		return;
 
-	for (ce_id = 0; ce_id < ar_pci->ce_count; ce_id++) {
-		struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
-		u32 ctrl_addr = ce_state->ctrl_addr;
+	for (ce_id = 0; ce_id < CE_COUNT; ce_id++) {
+		u32 ctrl_addr = ath10k_ce_base_address(ce_id);
 
 		ath10k_ce_copy_complete_intr_disable(ar, ctrl_addr);
 	}
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 42d2473..05cdbf0 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -831,7 +831,7 @@ static int ath10k_pci_start_ce(struct ath10k *ar)
 	spin_lock_init(&ar_pci->compl_lock);
 	INIT_LIST_HEAD(&ar_pci->compl_process);
 
-	for (pipe_num = 0; pipe_num < ar_pci->ce_count; pipe_num++) {
+	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
 		pipe_info = &ar_pci->pipe_info[pipe_num];
 
 		spin_lock_init(&pipe_info->pipe_lock);
@@ -924,7 +924,7 @@ static void ath10k_pci_cleanup_ce(struct ath10k *ar)
 	spin_unlock_bh(&ar_pci->compl_lock);
 
 	/* Free unused completions for each pipe. */
-	for (pipe_num = 0; pipe_num < ar_pci->ce_count; pipe_num++) {
+	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
 		pipe_info = &ar_pci->pipe_info[pipe_num];
 
 		spin_lock_bh(&pipe_info->pipe_lock);
@@ -1166,7 +1166,7 @@ static int ath10k_pci_post_rx(struct ath10k *ar)
 	const struct ce_attr *attr;
 	int pipe_num, ret = 0;
 
-	for (pipe_num = 0; pipe_num < ar_pci->ce_count; pipe_num++) {
+	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
 		pipe_info = &ar_pci->pipe_info[pipe_num];
 		attr = &host_ce_config_wlan[pipe_num];
 
@@ -1295,7 +1295,7 @@ static void ath10k_pci_buffer_cleanup(struct ath10k *ar)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int pipe_num;
 
-	for (pipe_num = 0; pipe_num < ar_pci->ce_count; pipe_num++) {
+	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
 		struct ath10k_pci_pipe *pipe_info;
 
 		pipe_info = &ar_pci->pipe_info[pipe_num];
@@ -1310,7 +1310,7 @@ static void ath10k_pci_ce_deinit(struct ath10k *ar)
 	struct ath10k_pci_pipe *pipe_info;
 	int pipe_num;
 
-	for (pipe_num = 0; pipe_num < ar_pci->ce_count; pipe_num++) {
+	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
 		pipe_info = &ar_pci->pipe_info[pipe_num];
 		if (pipe_info->ce_hdl) {
 			ath10k_ce_deinit(pipe_info->ce_hdl);
@@ -1755,7 +1755,7 @@ static int ath10k_pci_ce_init(struct ath10k *ar)
 	const struct ce_attr *attr;
 	int pipe_num;
 
-	for (pipe_num = 0; pipe_num < ar_pci->ce_count; pipe_num++) {
+	for (pipe_num = 0; pipe_num < CE_COUNT; pipe_num++) {
 		pipe_info = &ar_pci->pipe_info[pipe_num];
 		pipe_info->pipe_num = pipe_num;
 		pipe_info->hif_ce_state = ar;
@@ -1772,13 +1772,12 @@ static int ath10k_pci_ce_init(struct ath10k *ar)
 			return -1;
 		}
 
-		if (pipe_num == ar_pci->ce_count - 1) {
+		if (pipe_num == CE_COUNT - 1) {
 			/*
 			 * Reserve the ultimate CE for
 			 * diagnostic Window support
 			 */
-			ar_pci->ce_diag =
-			ar_pci->pipe_info[ar_pci->ce_count - 1].ce_hdl;
+			ar_pci->ce_diag = pipe_info->ce_hdl;
 			continue;
 		}
 
@@ -2235,7 +2234,6 @@ static int ath10k_pci_start_intr(struct ath10k *ar)
 
 exit:
 	ar_pci->num_msi_intrs = num;
-	ar_pci->ce_count = CE_COUNT;
 	return ret;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index a304c33..73a3d4e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -199,9 +199,6 @@ struct ath10k_pci {
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct msi_fw_err;
 
-	/* Number of Copy Engines supported */
-	unsigned int ce_count;
-
 	int started;
 
 	atomic_t keep_awake_count;
-- 
1.8.4.rc3

