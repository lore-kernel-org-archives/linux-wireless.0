Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:18761 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801AbXHBCSt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 22:18:49 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/4] iwlwifi: TX aggregation fix
Date: Thu,  2 Aug 2007 10:16:04 +0800
Message-Id: <11860209712781-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1186020969666-git-send-email-yi.zhu@intel.com>
References: <1186020965807-git-send-email-yi.zhu@intel.com>
 <11860209683483-git-send-email-yi.zhu@intel.com>
 <1186020969666-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch fixes driver crash in case when one of aggregated
packets was aborted.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index 44fc2cb..0209219 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -3595,8 +3595,14 @@ int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 			idx = SEQ_TO_INDEX(seq);
 			txq_id = SEQ_TO_QUEUE(seq);
 
+			if (status &
+				(AGG_TX_STATE_FEW_BYTES_MSK|
+				 AGG_TX_STATE_ABORT_MSK))
+				continue;
+
 			IWL_DEBUG_TX_REPLY("FrameCnt = %d, txq_id=%d idx=%d\n",
 					   agg->frame_count, txq_id, idx);
+
 			hdr = iwl_tx_queue_get_hdr(priv, txq_id, idx);
 
 			if (idx != (SEQ_TO_SN(hdr->seq_ctrl) & 0xff)) {
@@ -3611,7 +3617,6 @@ int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 			IWL_DEBUG_TX_REPLY("AGG Frame i=%d idx %d seq=%d\n",
 					   i, idx, SEQ_TO_SN(hdr->seq_ctrl));
 
-
 			sh = idx - start;
 			if (sh > 64 ) {
 				sh = (start - idx) + 0xff;
@@ -3640,7 +3645,8 @@ int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 				agg->start_idx,
 				agg->bitmap0);
 
-		agg->wait_for_ba = 1;
+		if (bitmap)
+			agg->wait_for_ba = 1;
 	}
 	return 0;
 }
-- 
1.5.2
