Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64229 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaEOM4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 08:56:09 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so633997eei.33
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 05:56:07 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, apenwarr@gmail.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/3] ath10k: protect src_ring state with ce_lock in tx_sg()
Date: Thu, 15 May 2014 14:48:57 +0200
Message-Id: <1400158139-13836-2-git-send-email-michal.kazior@tieto.com> (sfid-20140515_145614_155069_2E1C42EB)
In-Reply-To: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com>
References: <1400158139-13836-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible to read invalid state of CE ring
buffer indexes. This could lead to scatter-gather
transfer failure in mid-way and crash firmware
later by leaving garbage data on the ring.

Reported-By: Avery Pennarun <apenwarr@gmail.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 91d6076..04d8cbf 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -762,13 +762,17 @@ static int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
 	struct ath10k_pci_pipe *pci_pipe = &ar_pci->pipe_info[pipe_id];
 	struct ath10k_ce_pipe *ce_pipe = pci_pipe->ce_hdl;
 	struct ath10k_ce_ring *src_ring = ce_pipe->src_ring;
-	unsigned int nentries_mask = src_ring->nentries_mask;
-	unsigned int sw_index = src_ring->sw_index;
-	unsigned int write_index = src_ring->write_index;
+	unsigned int nentries_mask;
+	unsigned int sw_index;
+	unsigned int write_index;
 	int err, i;
 
 	spin_lock_bh(&ar_pci->ce_lock);
 
+	nentries_mask = src_ring->nentries_mask;
+	sw_index = src_ring->sw_index;
+	write_index = src_ring->write_index;
+
 	if (unlikely(CE_RING_DELTA(nentries_mask,
 				   write_index, sw_index - 1) < n_items)) {
 		err = -ENOBUFS;
-- 
1.8.5.3

