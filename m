Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:49982 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbaJ1JqH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 05:46:07 -0400
Received: by mail-lb0-f180.google.com with SMTP id z12so251421lbi.11
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2014 02:46:05 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 1/3] ath10k: fix possible bmi crash
Date: Tue, 28 Oct 2014 10:34:36 +0100
Message-Id: <1414488878-31561-2-git-send-email-michal.kazior@tieto.com> (sfid-20141028_104618_946562_C25C791C)
In-Reply-To: <1414488878-31561-1-git-send-email-michal.kazior@tieto.com>
References: <1414488878-31561-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While testing other things I've found that CE
items aren't cleared properly. This could lead to
null dereferences in BMI.

To prevent that make sure CE revoking clears the
nbytes value (which is used as a buffer completion
indication) and memset the entire CE ring data
shared between host and target when
(re)initializing.

Also make sure to check BMI xfer pointer and print
a splat instead of crashing the kernel.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v3:
     * dont reset shadow desc - its used for cleanup in hif_stop()

 drivers/net/wireless/ath/ath10k/ce.c  | 7 +++++++
 drivers/net/wireless/ath/ath10k/pci.c | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 878e1ec..a156e6e 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -558,6 +558,7 @@ int ath10k_ce_revoke_recv_next(struct ath10k_ce_pipe *ce_state,
 
 		/* sanity */
 		dest_ring->per_transfer_context[sw_index] = NULL;
+		desc->nbytes = 0;
 
 		/* Update sw_index */
 		sw_index = CE_RING_IDX_INCR(nentries_mask, sw_index);
@@ -835,6 +836,9 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 
 	nentries = roundup_pow_of_two(attr->src_nentries);
 
+	memset(src_ring->base_addr_owner_space, 0,
+	       nentries * sizeof(struct ce_desc));
+
 	src_ring->sw_index = ath10k_ce_src_ring_read_index_get(ar, ctrl_addr);
 	src_ring->sw_index &= src_ring->nentries_mask;
 	src_ring->hw_index = src_ring->sw_index;
@@ -869,6 +873,9 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 
 	nentries = roundup_pow_of_two(attr->dest_nentries);
 
+	memset(dest_ring->base_addr_owner_space, 0,
+	       nentries * sizeof(struct ce_desc));
+
 	dest_ring->sw_index = ath10k_ce_dest_ring_read_index_get(ar, ctrl_addr);
 	dest_ring->sw_index &= dest_ring->nentries_mask;
 	dest_ring->write_index =
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 63f374ed..f5e426e 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1442,6 +1442,9 @@ static void ath10k_pci_bmi_recv_data(struct ath10k_ce_pipe *ce_state)
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

