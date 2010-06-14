Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7575 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab0FNSYl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 14:24:41 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Pradeep Kulkarni <pradeepx.kulkarni@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/2] iwlagn: verify flow id in compressed BA packet
Date: Mon, 14 Jun 2010 11:24:32 -0700
Message-Id: <1276539872-12440-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1276539872-12440-1-git-send-email-reinette.chatre@intel.com>
References: <1276539872-12440-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

The flow id (scd_flow) in a compressed BA packet should match the txq_id
of the queue from which the aggregated packets were sent. However, in
some hardware like the 1000 series, sometimes the flow id is 0 for the
txq_id (10 to 19). This can cause the annoying message:
[ 2213.306191] iwlagn 0000:01:00.0: Received BA when not expected
[ 2213.310178] iwlagn 0000:01:00.0: Read index for DMA queue txq id (0),
index 5, is out of range [0-256] 7 7.

And even worse, if agg->wait_for_ba is true when the bad BA is arriving,
this can cause system hang due to NULL pointer dereference because the
code is operating in a wrong tx queue!

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Pradeep Kulkarni <pradeepx.kulkarni@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index a732f10..7d614c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1299,6 +1299,11 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 	sta_id = ba_resp->sta_id;
 	tid = ba_resp->tid;
 	agg = &priv->stations[sta_id].tid[tid].agg;
+	if (unlikely(agg->txq_id != scd_flow)) {
+		IWL_ERR(priv, "BA scd_flow %d does not match txq_id %d\n",
+			scd_flow, agg->txq_id);
+		return;
+	}
 
 	/* Find index just before block-ack window */
 	index = iwl_queue_dec_wrap(ba_resp_scd_ssn & 0xff, txq->q.n_bd);
-- 
1.7.0.4

