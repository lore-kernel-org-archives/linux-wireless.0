Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab2EPUk4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 16:40:56 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/3] iwlwifi: fix prints in iwl_rx_handle
Date: Wed, 16 May 2012 22:40:49 +0200
Message-Id: <1337200851-20469-2-git-send-email-johannes@sipsolutions.net> (sfid-20120516_224110_652952_8246DCA7)
In-Reply-To: <1337200851-20469-1-git-send-email-johannes@sipsolutions.net>
References: <1337200851-20469-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The debug prints were wrong and buggy. The HW pointer wasn't printed
correctly, it was mixed up with the pointer to the rxbuf.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 08517d3..1a7eb2a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -497,7 +497,7 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 
 	/* Rx interrupt, but nothing sent from uCode */
 	if (i == r)
-		IWL_DEBUG_RX(trans, "r = %d, i = %d\n", r, i);
+		IWL_DEBUG_RX(trans, "HW = SW = %d\n", r);
 
 	/* calculate total frames need to be restock after handling RX */
 	total_empty = r - rxq->write_actual;
@@ -513,8 +513,8 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 		rxb = rxq->queue[i];
 		rxq->queue[i] = NULL;
 
-		IWL_DEBUG_RX(trans, "rxbuf: r = %d, i = %d (%p)\n", rxb);
-
+		IWL_DEBUG_RX(trans, "rxbuf: HW = %d, SW = %d (%p)\n",
+			     r, i, rxb);
 		iwl_rx_handle_rxbuf(trans, rxb);
 
 		i = (i + 1) & RX_QUEUE_MASK;
-- 
1.7.10

