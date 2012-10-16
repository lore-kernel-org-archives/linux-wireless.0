Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43724 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab2JPSPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 14:15:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/8] iwlwifi: make data frame tracing optional
Date: Tue, 16 Oct 2012 20:16:14 +0200
Message-Id: <1350411380-2391-3-git-send-email-johannes@sipsolutions.net> (sfid-20121016_201557_507290_C78E5A24)
In-Reply-To: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
References: <1350411380-2391-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When tracing in iwlwifi, we get all data. Most of
the time, we don't need it, and it just takes up
a lot of extra space in the trace.

Make this optional by recording the data into two
separate trace events if it is needed. Without it,
record only the content of non-data and EAPOL TX
frames.

As a result, tracing without the data tracepoints
will record meta information including the 802.11
headers for all frames but will not record the
contents of data frames to reduce trace overhead.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c     |    3 +
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |   95 ++++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-trans.h    |    8 +++
 drivers/net/wireless/iwlwifi/pcie/rx.c      |    3 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c   |    4 +-
 5 files changed, 103 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 7ff3f14..963d02b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -1334,6 +1334,9 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	/* Configure transport layer */
 	iwl_trans_configure(priv->trans, &trans_cfg);
 
+	trans->rx_mpdu_cmd = REPLY_RX_MPDU_CMD;
+	trans->rx_mpdu_cmd_hdr_size = sizeof(struct iwl_rx_mpdu_res_start);
+
 	/* At this point both hw and priv are allocated. */
 
 	SET_IEEE80211_DEV(priv->hw, priv->trans->dev);
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index 59a5f78..678717b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -25,6 +25,39 @@
  *****************************************************************************/
 
 #if !defined(__IWLWIFI_DEVICE_TRACE) || defined(TRACE_HEADER_MULTI_READ)
+#include <linux/skbuff.h>
+#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
+#include "iwl-trans.h"
+#if !defined(__IWLWIFI_DEVICE_TRACE)
+static inline bool iwl_trace_data(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+
+	if (ieee80211_is_data(hdr->frame_control))
+		return skb->protocol != cpu_to_be16(ETH_P_PAE);
+	return false;
+}
+
+static inline size_t iwl_rx_trace_len(const struct iwl_trans *trans,
+				      void *rxbuf, size_t len)
+{
+	struct iwl_cmd_header *cmd = (void *)((u8 *)rxbuf + sizeof(__le32));
+	struct ieee80211_hdr *hdr;
+
+	if (cmd->cmd != trans->rx_mpdu_cmd)
+		return len;
+
+	hdr = (void *)((u8 *)cmd + sizeof(struct iwl_cmd_header) +
+			trans->rx_mpdu_cmd_hdr_size);
+	if (!ieee80211_is_data(hdr->frame_control))
+		return len;
+	/* maybe try to identify EAPOL frames? */
+	return sizeof(__le32) + sizeof(*cmd) + trans->rx_mpdu_cmd_hdr_size +
+		ieee80211_hdrlen(hdr->frame_control);
+}
+#endif
+
 #define __IWLWIFI_DEVICE_TRACE
 
 #include <linux/tracepoint.h>
@@ -235,6 +268,48 @@ TRACE_EVENT(iwlwifi_dbg,
 );
 
 #undef TRACE_SYSTEM
+#define TRACE_SYSTEM iwlwifi_data
+
+TRACE_EVENT(iwlwifi_dev_tx_data,
+	TP_PROTO(const struct device *dev,
+		 struct sk_buff *skb,
+		 void *data, size_t data_len),
+	TP_ARGS(dev, skb, data, data_len),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+
+		__dynamic_array(u8, data, iwl_trace_data(skb) ? data_len : 0)
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		if (iwl_trace_data(skb))
+			memcpy(__get_dynamic_array(data), data, data_len);
+	),
+	TP_printk("[%s] TX frame data", __get_str(dev))
+);
+
+TRACE_EVENT(iwlwifi_dev_rx_data,
+	TP_PROTO(const struct device *dev,
+		 const struct iwl_trans *trans,
+		 void *rxbuf, size_t len),
+	TP_ARGS(dev, trans, rxbuf, len),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+
+		__dynamic_array(u8, data,
+				len - iwl_rx_trace_len(trans, rxbuf, len))
+	),
+	TP_fast_assign(
+		size_t offs = iwl_rx_trace_len(trans, rxbuf, len);
+		DEV_ASSIGN;
+		if (offs < len)
+			memcpy(__get_dynamic_array(data),
+			       ((u8 *)rxbuf) + offs, len - offs);
+	),
+	TP_printk("[%s] TX frame data", __get_str(dev))
+);
+
+#undef TRACE_SYSTEM
 #define TRACE_SYSTEM iwlwifi
 
 TRACE_EVENT(iwlwifi_dev_hcmd,
@@ -270,25 +345,28 @@ TRACE_EVENT(iwlwifi_dev_hcmd,
 );
 
 TRACE_EVENT(iwlwifi_dev_rx,
-	TP_PROTO(const struct device *dev, void *rxbuf, size_t len),
-	TP_ARGS(dev, rxbuf, len),
+	TP_PROTO(const struct device *dev, const struct iwl_trans *trans,
+		 void *rxbuf, size_t len),
+	TP_ARGS(dev, trans, rxbuf, len),
 	TP_STRUCT__entry(
 		DEV_ENTRY
-		__dynamic_array(u8, rxbuf, len)
+		__dynamic_array(u8, rxbuf, iwl_rx_trace_len(trans, rxbuf, len))
 	),
 	TP_fast_assign(
 		DEV_ASSIGN;
-		memcpy(__get_dynamic_array(rxbuf), rxbuf, len);
+		memcpy(__get_dynamic_array(rxbuf), rxbuf,
+		       iwl_rx_trace_len(trans, rxbuf, len));
 	),
 	TP_printk("[%s] RX cmd %#.2x",
 		  __get_str(dev), ((u8 *)__get_dynamic_array(rxbuf))[4])
 );
 
 TRACE_EVENT(iwlwifi_dev_tx,
-	TP_PROTO(const struct device *dev, void *tfd, size_t tfdlen,
+	TP_PROTO(const struct device *dev, struct sk_buff *skb,
+		 void *tfd, size_t tfdlen,
 		 void *buf0, size_t buf0_len,
 		 void *buf1, size_t buf1_len),
-	TP_ARGS(dev, tfd, tfdlen, buf0, buf0_len, buf1, buf1_len),
+	TP_ARGS(dev, skb, tfd, tfdlen, buf0, buf0_len, buf1, buf1_len),
 	TP_STRUCT__entry(
 		DEV_ENTRY
 
@@ -301,14 +379,15 @@ TRACE_EVENT(iwlwifi_dev_tx,
 		 * for the possible padding).
 		 */
 		__dynamic_array(u8, buf0, buf0_len)
-		__dynamic_array(u8, buf1, buf1_len)
+		__dynamic_array(u8, buf1, iwl_trace_data(skb) ? 0 : buf1_len)
 	),
 	TP_fast_assign(
 		DEV_ASSIGN;
 		__entry->framelen = buf0_len + buf1_len;
 		memcpy(__get_dynamic_array(tfd), tfd, tfdlen);
 		memcpy(__get_dynamic_array(buf0), buf0, buf0_len);
-		memcpy(__get_dynamic_array(buf1), buf1, buf1_len);
+		if (!iwl_trace_data(skb))
+			memcpy(__get_dynamic_array(buf1), buf1, buf1_len);
 	),
 	TP_printk("[%s] TX %.2x (%zu bytes)",
 		  __get_str(dev), ((u8 *)__get_dynamic_array(buf0))[0],
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index ff11542..f75ea6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -444,6 +444,10 @@ enum iwl_trans_state {
  * @dev_cmd_headroom: room needed for the transport's private use before the
  *	device_cmd for Tx - for internal use only
  *	The user should use iwl_trans_{alloc,free}_tx_cmd.
+ * @rx_mpdu_cmd: MPDU RX command ID, must be assigned by opmode before
+ *	starting the firmware, used for tracing
+ * @rx_mpdu_cmd_hdr_size: used for tracing, amount of data before the
+ *	start of the 802.11 header in the @rx_mpdu_cmd
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
@@ -457,6 +461,8 @@ struct iwl_trans {
 	u32 hw_id;
 	char hw_id_str[52];
 
+	u8 rx_mpdu_cmd, rx_mpdu_cmd_hdr_size;
+
 	bool pm_support;
 
 	wait_queue_head_t wait_command_queue;
@@ -516,6 +522,8 @@ static inline int iwl_trans_start_fw(struct iwl_trans *trans,
 {
 	might_sleep();
 
+	WARN_ON_ONCE(!trans->rx_mpdu_cmd);
+
 	return trans->ops->start_fw(trans, fw);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 17c8e5d..137af4c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -411,7 +411,8 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
 
 		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 		len += sizeof(u32); /* account for status word */
-		trace_iwlwifi_dev_rx(trans->dev, pkt, len);
+		trace_iwlwifi_dev_rx(trans->dev, trans, pkt, len);
+		trace_iwlwifi_dev_rx_data(trans->dev, trans, pkt, len);
 
 		/* Reclaim a command buffer only if this packet is a response
 		 *   to a (driver-originated) command.
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index fe0fffd..2349043 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1385,11 +1385,13 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	dma_sync_single_for_device(trans->dev, txcmd_phys, firstlen,
 				   DMA_BIDIRECTIONAL);
 
-	trace_iwlwifi_dev_tx(trans->dev,
+	trace_iwlwifi_dev_tx(trans->dev, skb,
 			     &txq->tfds[txq->q.write_ptr],
 			     sizeof(struct iwl_tfd),
 			     &dev_cmd->hdr, firstlen,
 			     skb->data + hdr_len, secondlen);
+	trace_iwlwifi_dev_tx_data(trans->dev, skb,
+				  skb->data + hdr_len, secondlen);
 
 	/* start timer if queue currently empty */
 	if (txq->need_update && q->read_ptr == q->write_ptr &&
-- 
1.7.10.4

