Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:53633 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab3H3Maq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 08:30:46 -0400
Subject: [PATCH 6/7] ath10k: convert ath10k_pci_wake() to return
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Aug 2013 15:30:43 +0300
Message-ID: <20130830123043.31164.98926.stgit@localhost6.localdomain6> (sfid-20130830_143048_574008_C6E3A0DE)
In-Reply-To: <20130830122905.31164.50662.stgit@localhost6.localdomain6>
References: <20130830122905.31164.50662.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should not try to access hw if wakeup fails so add
proper error checking for that. Also add the timeout lenght
to the warning message.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  |   43 ++++++++++++++++++++++++++-------
 drivers/net/wireless/ath/ath10k/pci.c |   11 +++++---
 drivers/net/wireless/ath/ath10k/pci.h |    8 ++++--
 3 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 496baa2..0f6735a 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -277,7 +277,9 @@ static int ath10k_ce_send_nolock(struct ath10k_ce_pipe *ce_state,
 		ath10k_warn("%s: send more we can (nbytes: %d, max: %d)\n",
 			    __func__, nbytes, ce_state->src_sz_max);
 
-	ath10k_pci_wake(ar);
+	ret = ath10k_pci_wake(ar);
+	if (ret)
+		return ret;
 
 	if (unlikely(CE_RING_DELTA(nentries_mask,
 				   write_index, sw_index - 1) <= 0)) {
@@ -419,7 +421,9 @@ int ath10k_ce_recv_buf_enqueue(struct ath10k_ce_pipe *ce_state,
 	write_index = dest_ring->write_index;
 	sw_index = dest_ring->sw_index;
 
-	ath10k_pci_wake(ar);
+	ret = ath10k_pci_wake(ar);
+	if (ret)
+		goto out;
 
 	if (CE_RING_DELTA(nentries_mask, write_index, sw_index - 1) > 0) {
 		struct ce_desc *base = dest_ring->base_addr_owner_space;
@@ -441,6 +445,8 @@ int ath10k_ce_recv_buf_enqueue(struct ath10k_ce_pipe *ce_state,
 		ret = -EIO;
 	}
 	ath10k_pci_sleep(ar);
+
+out:
 	spin_unlock_bh(&ar_pci->ce_lock);
 
 	return ret;
@@ -596,6 +602,7 @@ static int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 	unsigned int sw_index = src_ring->sw_index;
 	struct ce_desc *sdesc, *sbase;
 	unsigned int read_index;
+	int ret;
 
 	if (src_ring->hw_index == sw_index) {
 		/*
@@ -605,10 +612,15 @@ static int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 		 * the SW has really caught up to the HW, or if the cached
 		 * value of the HW index has become stale.
 		 */
-		ath10k_pci_wake(ar);
+
+		ret = ath10k_pci_wake(ar);
+		if (ret)
+			return ret;
+
 		src_ring->hw_index =
 			ath10k_ce_src_ring_read_index_get(ar, ctrl_addr);
 		src_ring->hw_index &= nentries_mask;
+
 		ath10k_pci_sleep(ar);
 	}
 
@@ -735,8 +747,12 @@ void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id)
 	unsigned int nbytes;
 	unsigned int id;
 	unsigned int flags;
+	int ret;
+
+	ret = ath10k_pci_wake(ar);
+	if (ret)
+		return;
 
-	ath10k_pci_wake(ar);
 	spin_lock_bh(&ar_pci->ce_lock);
 
 	/* Clear the copy-complete interrupts that will be handled here. */
@@ -795,10 +811,13 @@ void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id)
 void ath10k_ce_per_engine_service_any(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int ce_id;
+	int ce_id, ret;
 	u32 intr_summary;
 
-	ath10k_pci_wake(ar);
+	ret = ath10k_pci_wake(ar);
+	if (ret)
+		return;
+
 	intr_summary = CE_INTERRUPT_SUMMARY(ar);
 
 	for (ce_id = 0; intr_summary && (ce_id < ar_pci->ce_count); ce_id++) {
@@ -826,8 +845,11 @@ static void ath10k_ce_per_engine_handler_adjust(struct ath10k_ce_pipe *ce_state,
 {
 	u32 ctrl_addr = ce_state->ctrl_addr;
 	struct ath10k *ar = ce_state->ar;
+	int ret;
 
-	ath10k_pci_wake(ar);
+	ret = ath10k_pci_wake(ar);
+	if (ret)
+		return;
 
 	if ((!disable_copy_compl_intr) &&
 	    (ce_state->send_cb || ce_state->recv_cb))
@@ -843,9 +865,12 @@ static void ath10k_ce_per_engine_handler_adjust(struct ath10k_ce_pipe *ce_state,
 void ath10k_ce_disable_interrupts(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	int ce_id;
+	int ce_id, ret;
+
+	ret = ath10k_pci_wake(ar);
+	if (ret)
+		return;
 
-	ath10k_pci_wake(ar);
 	for (ce_id = 0; ce_id < ar_pci->ce_count; ce_id++) {
 		struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
 		u32 ctrl_addr = ce_state->ctrl_addr;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 61f4086..66ca652 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -537,7 +537,7 @@ static void ath10k_pci_wait(struct ath10k *ar)
 		ath10k_warn("Unable to wakeup target\n");
 }
 
-void ath10k_do_pci_wake(struct ath10k *ar)
+int ath10k_do_pci_wake(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	void __iomem *pci_addr = ar_pci->mem;
@@ -553,18 +553,19 @@ void ath10k_do_pci_wake(struct ath10k *ar)
 	atomic_inc(&ar_pci->keep_awake_count);
 
 	if (ar_pci->verified_awake)
-		return;
+		return 0;
 
 	for (;;) {
 		if (ath10k_pci_target_is_awake(ar)) {
 			ar_pci->verified_awake = true;
-			break;
+			return 0;
 		}
 
 		if (tot_delay > PCIE_WAKE_TIMEOUT) {
-			ath10k_warn("target takes too long to wake up (awake count %d)\n",
+			ath10k_warn("target took longer %d us to wake up (awake count %d)\n",
+				    PCIE_WAKE_TIMEOUT,
 				    atomic_read(&ar_pci->keep_awake_count));
-			break;
+			return -ETIMEDOUT;
 		}
 
 		udelay(curr_delay);
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index 5c0f9aa..49aff20 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -325,15 +325,17 @@ static inline u32 ath10k_pci_read32(struct ath10k *ar, u32 offset)
 	return ioread32(ar_pci->mem + offset);
 }
 
-void ath10k_do_pci_wake(struct ath10k *ar);
+int ath10k_do_pci_wake(struct ath10k *ar);
 void ath10k_do_pci_sleep(struct ath10k *ar);
 
-static inline void ath10k_pci_wake(struct ath10k *ar)
+static inline int ath10k_pci_wake(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
 	if (test_bit(ATH10K_PCI_FEATURE_SOC_POWER_SAVE, ar_pci->features))
-		ath10k_do_pci_wake(ar);
+		return ath10k_do_pci_wake(ar);
+
+	return 0;
 }
 
 static inline void ath10k_pci_sleep(struct ath10k *ar)

