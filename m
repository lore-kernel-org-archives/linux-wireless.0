Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:40062 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030357Ab3HIGkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 02:40:40 -0400
Received: by mail-ee0-f53.google.com with SMTP id b15so1952527eek.12
        for <linux-wireless@vger.kernel.org>; Thu, 08 Aug 2013 23:40:38 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] ath10k: check allocation errors in CE
Date: Fri,  9 Aug 2013 08:39:13 +0200
Message-Id: <1376030353-32421-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20130809_084045_624315_9B29DA35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle pci_alloc_consistent(), kmalloc()
errors in copy engine module.
Found during code review.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index f8b969f..4e266bf 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -970,6 +970,12 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 				     (nentries * sizeof(struct ce_desc) +
 				      CE_DESC_RING_ALIGN),
 				     &base_addr);
+	if (!src_ring->base_addr_owner_space_unaligned) {
+		kfree(ce_state->src_ring);
+		ce_state->src_ring = NULL;
+		return -ENOMEM;
+	}
+
 	src_ring->base_addr_ce_space_unaligned = base_addr;
 
 	src_ring->base_addr_owner_space = PTR_ALIGN(
@@ -986,6 +992,16 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 	src_ring->shadow_base_unaligned =
 		kmalloc((nentries * sizeof(struct ce_desc) +
 			 CE_DESC_RING_ALIGN), GFP_KERNEL);
+	if (!src_ring->shadow_base_unaligned) {
+		pci_free_consistent(ar_pci->pdev,
+				    (nentries * sizeof(struct ce_desc) +
+				     CE_DESC_RING_ALIGN),
+				    src_ring->base_addr_owner_space,
+				    src_ring->base_addr_ce_space);
+		kfree(ce_state->src_ring);
+		ce_state->src_ring = NULL;
+		return -ENOMEM;
+	}
 
 	src_ring->shadow_base = PTR_ALIGN(
 			src_ring->shadow_base_unaligned,
@@ -1055,6 +1071,12 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 				     (nentries * sizeof(struct ce_desc) +
 				      CE_DESC_RING_ALIGN),
 				     &base_addr);
+	if (!dest_ring->base_addr_owner_space_unaligned) {
+		kfree(ce_state->dest_ring);
+		ce_state->dest_ring = NULL;
+		return -ENOMEM;
+	}
+
 	dest_ring->base_addr_ce_space_unaligned = base_addr;
 
 	/*
-- 
1.7.9.5

