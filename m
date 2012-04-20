Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:34223 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2DTGpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 02:45:13 -0400
Date: Fri, 20 Apr 2012 09:44:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 2/2] ath6kl: fix an indenting issue
Message-ID: <20120420064444.GD22649@elgon.mountain> (sfid-20120420_084517_480425_7064D007)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is supposed to be pushed in one indent level.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index 065e615..d82020e 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -793,16 +793,17 @@ static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
 				 * itself
 				 */
 				txb_mask = ((1 << ac) - 1);
-		/*
-		 * when the scatter request resources drop below a
-		 * certain threshold, disable Tx bundling for all
-		 * AC's with priority lower than the current requesting
-		 * AC. Otherwise re-enable Tx bundling for them
-		 */
-		if (scat_req->scat_q_depth < ATH6KL_SCATTER_REQS)
-			target->tx_bndl_mask &= ~txb_mask;
-		else
-			target->tx_bndl_mask |= txb_mask;
+
+			/*
+			 * when the scatter request resources drop below a
+			 * certain threshold, disable Tx bundling for all
+			 * AC's with priority lower than the current requesting
+			 * AC. Otherwise re-enable Tx bundling for them
+			 */
+			if (scat_req->scat_q_depth < ATH6KL_SCATTER_REQS)
+				target->tx_bndl_mask &= ~txb_mask;
+			else
+				target->tx_bndl_mask |= txb_mask;
 		}
 
 		ath6kl_dbg(ATH6KL_DBG_HTC, "htc tx pkts to scatter: %d\n",
