Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:54268 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab3LLO2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 09:28:34 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so271812ead.34
        for <linux-wireless@vger.kernel.org>; Thu, 12 Dec 2013 06:28:33 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/3] ath10k: zero CE config upon deinit
Date: Thu, 12 Dec 2013 15:24:21 +0100
Message-Id: <1386858261-16037-4-git-send-email-michal.kazior@tieto.com> (sfid-20131212_152839_995782_D31965B0)
In-Reply-To: <1386858261-16037-1-git-send-email-michal.kazior@tieto.com>
References: <1386858261-16037-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure to reset CE configuration in the exposed
device registers. This sounds like a safe plan
since CE configurations includes DMA addresses
shared between host and the device which are made
invalid after teardown.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index d44d618..ba82a03 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1109,11 +1109,38 @@ out:
 	return ce_state;
 }
 
+void ath10k_ce_reset_src_ring(struct ath10k *ar, int num)
+{
+	u32 ctrl_addr = ath10k_ce_base_address(num);
+
+	ath10k_ce_src_ring_base_addr_set(ar, ctrl_addr, 0);
+	ath10k_ce_src_ring_size_set(ar, ctrl_addr, 0);
+	ath10k_ce_src_ring_dmax_set(ar, ctrl_addr, 0);
+	ath10k_ce_src_ring_byte_swap_set(ar, ctrl_addr, 0);
+	ath10k_ce_src_ring_lowmark_set(ar, ctrl_addr, 0);
+	ath10k_ce_src_ring_highmark_set(ar, ctrl_addr, 0);
+
+}
+
+void ath10k_ce_reset_dest_ring(struct ath10k *ar, int num)
+{
+	u32 ctrl_addr = ath10k_ce_base_address(num);
+
+	ath10k_ce_dest_ring_base_addr_set(ar, ctrl_addr, 0);
+	ath10k_ce_dest_ring_size_set(ar, ctrl_addr, 0);
+	ath10k_ce_dest_ring_byte_swap_set(ar, ctrl_addr, 0);
+	ath10k_ce_dest_ring_lowmark_set(ar, ctrl_addr, 0);
+	ath10k_ce_dest_ring_highmark_set(ar, ctrl_addr, 0);
+}
+
 void ath10k_ce_deinit(struct ath10k_ce_pipe *ce_state)
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 
+	ath10k_ce_reset_src_ring(ar, ce_state->id);
+	ath10k_ce_reset_dest_ring(ar, ce_state->id);
+
 	if (ce_state->src_ring) {
 		kfree(ce_state->src_ring->shadow_base_unaligned);
 		pci_free_consistent(ar_pci->pdev,
-- 
1.8.4.rc3

