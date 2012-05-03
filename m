Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:62071 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758767Ab2ECV2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 17:28:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/6] iwlwifi: don't flood logs when HT debug flag is set
Date: Thu,  3 May 2012 14:22:05 -0700
Message-Id: <1336080126-22606-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120503_232850_104775_A2C748DB)
In-Reply-To: <1336080126-22606-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1336080126-22606-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We have TX_REPLY for that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index f2e9f29..d8b6fa2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1300,10 +1300,11 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 			   (u8 *) &ba_resp->sta_addr_lo32,
 			   ba_resp->sta_id);
 	IWL_DEBUG_TX_REPLY(priv, "TID = %d, SeqCtl = %d, bitmap = 0x%llx, "
-			   "scd_flow = %d, scd_ssn = %d\n",
+			   "scd_flow = %d, scd_ssn = %d sent:%d, acked:%d\n",
 			   ba_resp->tid, le16_to_cpu(ba_resp->seq_ctl),
 			   (unsigned long long)le64_to_cpu(ba_resp->bitmap),
-			   scd_flow, ba_resp_scd_ssn);
+			   scd_flow, ba_resp_scd_ssn, ba_resp->txed,
+			   ba_resp->txed_2_done);
 
 	/* Mark that the expected block-ack response arrived */
 	agg->wait_for_ba = false;
@@ -1319,8 +1320,6 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		 */
 		ba_resp->txed = ba_resp->txed_2_done;
 	}
-	IWL_DEBUG_HT(priv, "agg frames sent:%d, acked:%d\n",
-			ba_resp->txed, ba_resp->txed_2_done);
 
 	priv->tid_data[sta_id][tid].next_reclaimed = ba_resp_scd_ssn;
 
-- 
1.7.0.4

