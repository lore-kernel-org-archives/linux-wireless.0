Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34414 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758921Ab2EKK7G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 06:59:06 -0400
Message-ID: <1336733942.4310.21.camel@jlt3.sipsolutions.net> (sfid-20120511_125911_500419_782D934F)
Subject: [PATCH 1/4 v2] iwlwifi: fix prints in iwl_rx_handle
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Fri, 11 May 2012 12:59:02 +0200
In-Reply-To: <1336665952-24363-2-git-send-email-johannes@sipsolutions.net> (sfid-20120510_180602_348662_B04FB76A)
References: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
	 <1336665952-24363-2-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120510_180602_348662_B04FB76A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    
The debug prints were wrong and buggy. The HW pointer wasn't printed
correctly, it was mixed up with the pointer to the rxbuf.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: make patch apply -- looks like some whitespace diff to upstream
crept into our tree, thanks dileks.

--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -499,7 +499,7 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 
 	/* Rx interrupt, but nothing sent from uCode */
 	if (i == r)
-		IWL_DEBUG_RX(trans, "r = %d, i = %d\n", r, i);
+		IWL_DEBUG_RX(trans, "HW = SW = %d\n", r);
 
 	/* calculate total frames need to be restock after handling RX */
 	total_empty = r - rxq->write_actual;
@@ -515,8 +515,8 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 		rxb = rxq->queue[i];
 		rxq->queue[i] = NULL;
 
-		IWL_DEBUG_RX(trans, "rxbuf: r = %d, i = %d (%p)\n", rxb);
-
+		IWL_DEBUG_RX(trans, "rxbuf: HW = %d, SW = %d (%p)\n",
+			     r, i, rxb);
 		iwl_rx_handle_rxbuf(trans, rxb);
 
 		i = (i + 1) & RX_QUEUE_MASK;


