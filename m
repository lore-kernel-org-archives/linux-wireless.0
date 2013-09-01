Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:39511 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab3IAHCE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Sep 2013 03:02:04 -0400
Subject: [PATCH v2 5/7] ath10k: clean up ath10k_ce_completed_send_next_nolock()
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 01 Sep 2013 10:02:00 +0300
Message-ID: <20130901070200.14695.24176.stgit@localhost6.localdomain6> (sfid-20130901_090208_003832_2F0B5989)
In-Reply-To: <20130901070020.14695.16694.stgit@localhost6.localdomain6>
References: <20130901070020.14695.16694.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The error handling was just weird, simplify it.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c |   41 +++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index dd80c24..6a80142 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -594,8 +594,8 @@ static int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 	struct ath10k *ar = ce_state->ar;
 	unsigned int nentries_mask = src_ring->nentries_mask;
 	unsigned int sw_index = src_ring->sw_index;
+	struct ce_desc *sdesc, *sbase;
 	unsigned int read_index;
-	int ret = -EIO;
 
 	if (src_ring->hw_index == sw_index) {
 		/*
@@ -611,32 +611,33 @@ static int ath10k_ce_completed_send_next_nolock(struct ath10k_ce_pipe *ce_state,
 		src_ring->hw_index &= nentries_mask;
 		ath10k_pci_sleep(ar);
 	}
+
 	read_index = src_ring->hw_index;
 
-	if ((read_index != sw_index) && (read_index != 0xffffffff)) {
-		struct ce_desc *sbase = src_ring->shadow_base;
-		struct ce_desc *sdesc = CE_SRC_RING_TO_DESC(sbase, sw_index);
+	if ((read_index == sw_index) || (read_index == 0xffffffff))
+		return -EIO;
 
-		/* Return data from completed source descriptor */
-		*bufferp = __le32_to_cpu(sdesc->addr);
-		*nbytesp = __le16_to_cpu(sdesc->nbytes);
-		*transfer_idp = MS(__le16_to_cpu(sdesc->flags),
-						CE_DESC_FLAGS_META_DATA);
+	sbase = src_ring->shadow_base;
+	sdesc = CE_SRC_RING_TO_DESC(sbase, sw_index);
 
-		if (per_transfer_contextp)
-			*per_transfer_contextp =
-				src_ring->per_transfer_context[sw_index];
+	/* Return data from completed source descriptor */
+	*bufferp = __le32_to_cpu(sdesc->addr);
+	*nbytesp = __le16_to_cpu(sdesc->nbytes);
+	*transfer_idp = MS(__le16_to_cpu(sdesc->flags),
+			   CE_DESC_FLAGS_META_DATA);
 
-		/* sanity */
-		src_ring->per_transfer_context[sw_index] = NULL;
+	if (per_transfer_contextp)
+		*per_transfer_contextp =
+			src_ring->per_transfer_context[sw_index];
 
-		/* Update sw_index */
-		sw_index = CE_RING_IDX_INCR(nentries_mask, sw_index);
-		src_ring->sw_index = sw_index;
-		ret = 0;
-	}
+	/* sanity */
+	src_ring->per_transfer_context[sw_index] = NULL;
 
-	return ret;
+	/* Update sw_index */
+	sw_index = CE_RING_IDX_INCR(nentries_mask, sw_index);
+	src_ring->sw_index = sw_index;
+
+	return 0;
 }
 
 /* NB: Modeled after ath10k_ce_completed_send_next */

