Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:55905 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752739AbdHBKdz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 06:33:55 -0400
From: Rakesh Pillai <pillair@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@qti.qualcomm.com>
Subject: [PATCH v2] ath10k: fix memory leak in rx ring buffer allocation
Date: Wed,  2 Aug 2017 16:03:37 +0530
Message-Id: <1501670017-12862-1-git-send-email-pillair@codeaurora.org> (sfid-20170802_123359_435092_A97D86F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rakesh Pillai <pillair@qti.qualcomm.com>

ath10k: fix memory leak in rx ring buffer allocation

The rx ring buffers are added to a hash table if
firmware support full rx reorder. If the full rx
reorder support flag is not set before allocating
the rx ring buffers, none of the buffers are added
to the hash table.

There is a race condition between rx ring refill and
rx buffer replenish from napi poll. The interrupts are
enabled in hif start, before the rx ring is refilled during init.
We replenish buffers from napi poll due to the interrupts which
get enabled after hif start. Hence before the entire rx ring is
refilled during the init, the napi poll replenishes a few buffers
in steps of 100 buffers per attempt. During this rx ring replenish
from napi poll, the rx reorder flag has not been set due to which
the replenished buffers are not added to the hash table

Set the rx full reorder support flag before we allocate
the rx ring buffer to avoid the memory leak.

Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 6906bdd..10b3384 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1886,6 +1886,12 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		goto err_wmi_detach;
 	}
 
+	/* If firmware indicates Full Rx Reorder support it must be used in a
+	 * slightly different manner. Let HTT code know.
+	 */
+	ar->htt.rx_ring.in_ord_rx = !!(test_bit(WMI_SERVICE_RX_FULL_REORDER,
+						ar->wmi.svc_map));
+
 	status = ath10k_htt_rx_alloc(&ar->htt);
 	if (status) {
 		ath10k_err(ar, "failed to alloc htt rx: %d\n", status);
@@ -1997,12 +2003,6 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		}
 	}
 
-	/* If firmware indicates Full Rx Reorder support it must be used in a
-	 * slightly different manner. Let HTT code know.
-	 */
-	ar->htt.rx_ring.in_ord_rx = !!(test_bit(WMI_SERVICE_RX_FULL_REORDER,
-						ar->wmi.svc_map));
-
 	status = ath10k_htt_rx_ring_refill(ar);
 	if (status) {
 		ath10k_err(ar, "failed to refill htt rx ring: %d\n", status);
-- 
1.9.1
