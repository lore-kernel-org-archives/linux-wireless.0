Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:38898 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaJTMem (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 08:34:42 -0400
Received: by mail-la0-f46.google.com with SMTP id gi9so3790727lab.5
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 05:34:41 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/3] ath10k: fix possible bmi crash
Date: Mon, 20 Oct 2014 14:22:36 +0200
Message-Id: <1413807758-30249-2-git-send-email-michal.kazior@tieto.com> (sfid-20141020_143446_774419_971F453F)
In-Reply-To: <1413807758-30249-1-git-send-email-michal.kazior@tieto.com>
References: <1413807758-30249-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While testing other things I've found that CE
items aren't cleared properly. This could lead to
null dereferences in BMI.

To prevent that make sure CE revoking clears the
nbytes value (which is used as a buffer completion
indication) and memset the entire CE rings when
(re)initializing.

Also make sure to check BMI xfer pointer and print
a splat instead of crashing the kernel.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c  | 7 +++++++
 drivers/net/wireless/ath/ath10k/pci.c | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 9b89ac1..92c1c6a 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -558,6 +558,7 @@ int ath10k_ce_revoke_recv_next(struct ath10k_ce_pipe *ce_state,
 
 		/* sanity */
 		dest_ring->per_transfer_context[sw_index] = NULL;
+		desc->nbytes = 0;
 
 		/* Update sw_index */
 		sw_index = CE_RING_IDX_INCR(nentries_mask, sw_index);
@@ -837,6 +838,10 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 
 	memset(src_ring->per_transfer_context, 0,
 	       nentries * sizeof(*src_ring->per_transfer_context));
+	memset(src_ring->base_addr_owner_space, 0,
+	       nentries * sizeof(struct ce_desc));
+	memset(src_ring->shadow_base, 0,
+	       nentries * sizeof(struct ce_desc));
 
 	src_ring->sw_index = ath10k_ce_src_ring_read_index_get(ar, ctrl_addr);
 	src_ring->sw_index &= src_ring->nentries_mask;
@@ -874,6 +879,8 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 
 	memset(dest_ring->per_transfer_context, 0,
 	       nentries * sizeof(*dest_ring->per_transfer_context));
+	memset(dest_ring->base_addr_owner_space, 0,
+	       nentries * sizeof(struct ce_desc));
 
 	dest_ring->sw_index = ath10k_ce_dest_ring_read_index_get(ar, ctrl_addr);
 	dest_ring->sw_index &= dest_ring->nentries_mask;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index c1a2b84..8820f25 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1432,6 +1432,9 @@ static void ath10k_pci_bmi_recv_data(struct ath10k_ce_pipe *ce_state)
 					  &nbytes, &transfer_id, &flags))
 		return;
 
+	if (WARN_ON_ONCE(!xfer))
+		return;
+
 	if (!xfer->wait_for_resp) {
 		ath10k_warn(ar, "unexpected: BMI data received; ignoring\n");
 		return;
-- 
1.8.5.3

