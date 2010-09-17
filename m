Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19649 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396Ab0IQVXa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 17:23:30 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/10] iwlagn: log aggregation tx command status
Date: Fri, 17 Sep 2010 14:24:28 -0700
Message-Id: <1284758674-25297-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For aggregated frames with block ack, different status flag
will be used as part of tx command response.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   32 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |    3 ++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 68a2ab3..a8494d0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -147,6 +147,33 @@ static void iwlagn_set_tx_status(struct iwl_priv *priv,
 			   tx_resp->failure_frame);
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUG
+#define AGG_TX_STATE_FAIL(x) case AGG_TX_STATE_ ## x: return #x
+
+const char *iwl_get_agg_tx_fail_reason(u16 status)
+{
+	status &= AGG_TX_STATUS_MSK;
+	switch (status) {
+	case AGG_TX_STATE_TRANSMITTED:
+		return "SUCCESS";
+		AGG_TX_STATE_FAIL(UNDERRUN_MSK);
+		AGG_TX_STATE_FAIL(BT_PRIO_MSK);
+		AGG_TX_STATE_FAIL(FEW_BYTES_MSK);
+		AGG_TX_STATE_FAIL(ABORT_MSK);
+		AGG_TX_STATE_FAIL(LAST_SENT_TTL_MSK);
+		AGG_TX_STATE_FAIL(LAST_SENT_TRY_CNT_MSK);
+		AGG_TX_STATE_FAIL(LAST_SENT_BT_KILL_MSK);
+		AGG_TX_STATE_FAIL(SCD_QUERY_MSK);
+		AGG_TX_STATE_FAIL(TEST_BAD_CRC32_MSK);
+		AGG_TX_STATE_FAIL(RESPONSE_MSK);
+		AGG_TX_STATE_FAIL(DUMP_TX_MSK);
+		AGG_TX_STATE_FAIL(DELAY_TX_MSK);
+	}
+
+	return "UNKNOWN";
+}
+#endif /* CONFIG_IWLWIFI_DEBUG */
+
 static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
 				      struct iwl_ht_agg *agg,
 				      struct iwl5000_tx_resp *tx_resp,
@@ -203,6 +230,11 @@ static int iwlagn_tx_status_reply_tx(struct iwl_priv *priv,
 
 			IWL_DEBUG_TX_REPLY(priv, "FrameCnt = %d, txq_id=%d idx=%d\n",
 					   agg->frame_count, txq_id, idx);
+			IWL_DEBUG_TX_REPLY(priv, "status %s (0x%08x), "
+					   "try-count (0x%08x)\n",
+					   iwl_get_agg_tx_fail_reason(status),
+					   status & AGG_TX_STATUS_MSK,
+					   status & AGG_TX_TRY_MSK);
 
 			hdr = iwl_tx_queue_get_hdr(priv, txq_id, idx);
 			if (!hdr) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 3e4ba31..dd47aca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1868,6 +1868,9 @@ enum {
 	AGG_TX_STATE_DELAY_TX_MSK = 0x400
 };
 
+#define AGG_TX_STATUS_MSK	0x00000fff	/* bits 0:11 */
+#define AGG_TX_TRY_MSK		0x0000f000	/* bits 12:15 */
+
 #define AGG_TX_STATE_LAST_SENT_MSK  (AGG_TX_STATE_LAST_SENT_TTL_MSK | \
 				     AGG_TX_STATE_LAST_SENT_TRY_CNT_MSK | \
 				     AGG_TX_STATE_LAST_SENT_BT_KILL_MSK)
-- 
1.7.0.4

