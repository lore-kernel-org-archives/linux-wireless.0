Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46134 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932603AbXHHHiN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 03:38:13 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 22/28] iwlwifi: replace private snprint_line with common hex_dump_xxx
Date: Wed,  8 Aug 2007 15:33:39 +0800
Message-Id: <11865584771950-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11865584754153-git-send-email-yi.zhu@intel.com>
References: <11865584251026-git-send-email-yi.zhu@intel.com>
 <11865584292234-git-send-email-yi.zhu@intel.com>
 <1186558432932-git-send-email-yi.zhu@intel.com>
 <11865584342308-git-send-email-yi.zhu@intel.com>
 <11865584363863-git-send-email-yi.zhu@intel.com>
 <11865584392893-git-send-email-yi.zhu@intel.com>
 <11865584413292-git-send-email-yi.zhu@intel.com>
 <1186558443548-git-send-email-yi.zhu@intel.com>
 <11865584452614-git-send-email-yi.zhu@intel.com>
 <11865584473732-git-send-email-yi.zhu@intel.com>
 <11865584503648-git-send-email-yi.zhu@intel.com>
 <11865584521358-git-send-email-yi.zhu@intel.com>
 <11865584543903-git-send-email-yi.zhu@intel.com>
 <11865584562811-git-send-email-yi.zhu@intel.com>
 <11865584583336-git-send-email-yi.zhu@intel.com>
 <11865584603865-git-send-email-yi.zhu@intel.com>
 <11865584631842-git-send-email-yi.zhu@intel.com>
 <11865584661209-git-send-email-yi.zhu@intel.com>
 <11865584683474-git-send-email-yi.zhu@intel.com>
 <1186558470949-git-send-email-yi.zhu@intel.com>
 <11865584733882-git-send-email-yi.zhu@intel.com>
 <11865584754153-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-base.c    |   45 ++++++++++++++++++++++++-----------
 drivers/net/wireless/iwl-helpers.h |   21 ----------------
 2 files changed, 31 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwl-base.c b/drivers/net/wireless/iwl-base.c
index efd4762..2c107e7 100644
--- a/drivers/net/wireless/iwl-base.c
+++ b/drivers/net/wireless/iwl-base.c
@@ -184,6 +184,23 @@ static const char *iwl_escape_essid(const char *essid, u8 essid_len)
 	return escaped;
 }
 
+static void iwl_print_hex_dump(int level, void *p, u32 len)
+{
+#ifdef CONFIG_IWLWIFI_DEBUG
+	u32 ofs = 0;
+
+	if (!(iwl_debug_level & level))
+		return;
+
+	while (len) {
+		print_hex_dump(KERN_DEBUG, "iwl data: ", DUMP_PREFIX_OFFSET,
+			       16, 1, p + ofs, len, 1);
+		ofs += 16;
+		len -= min(len, 16U);
+	}
+#endif
+}
+
 /*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
  * DMA services
  *
@@ -1819,7 +1836,7 @@ void iwl_report_frame(struct iwl_priv *priv,
 		}
 	}
 	if (print_dump)
-		printk_buf(IWL_DL_RX, data, length);
+		iwl_print_hex_dump(IWL_DL_RX, data, length);
 }
 #endif
 
@@ -2836,7 +2853,7 @@ static int iwl_get_sta_id(struct iwl_priv *priv, struct ieee80211_hdr *hdr)
 		IWL_DEBUG_DROP("Station " MAC_FMT " not in station map. "
 			       "Defaulting to broadcast...\n",
 			       MAC_ARG(hdr->addr1));
-		printk_buf(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
+		iwl_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 		return IWL_BROADCAST_ID;
 	}
 
@@ -3028,10 +3045,11 @@ static int iwl_tx_skb(struct iwl_priv *priv,
 		txq->need_update = 0;
 	}
 
-	printk_buf(IWL_DL_TX, out_cmd->cmd.payload, sizeof(out_cmd->cmd.tx));
+	iwl_print_hex_dump(IWL_DL_TX, out_cmd->cmd.payload,
+			   sizeof(out_cmd->cmd.tx));
 
-	printk_buf(IWL_DL_TX, (u8 *) out_cmd->cmd.tx.hdr,
-		   ieee80211_get_hdrlen(fc));
+	iwl_print_hex_dump(IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
+			   ieee80211_get_hdrlen(fc));
 
 	iwl4965_tx_queue_update_wr_ptr(priv, txq, len);
 
@@ -3939,7 +3957,7 @@ static void iwl_rx_pm_debug_statistics_notif(struct iwl_priv *priv,
 	IWL_DEBUG_RADIO("Dumping %d bytes of unhandled "
 			"notification for %s:\n",
 			le32_to_cpu(pkt->len), get_cmd_string(pkt->hdr.cmd));
-	printk_buf(IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
+	iwl_print_hex_dump(IWL_DL_RADIO, pkt->u.raw, le32_to_cpu(pkt->len));
 }
 
 static void iwl_rx_beacon_notif(struct iwl_priv *priv,
@@ -4762,7 +4780,7 @@ int iwl_tx_queue_update_write_ptr(struct iwl_priv *priv,
 static void iwl_print_rx_config_cmd(struct iwl_rxon_cmd *rxon)
 {
 	IWL_DEBUG_RADIO("RX CONFIG:\n");
-	printk_buf(IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
+	iwl_print_hex_dump(IWL_DL_RADIO, (u8 *) rxon, sizeof(*rxon));
 	IWL_DEBUG_RADIO("u16 channel: 0x%x\n", le16_to_cpu(rxon->channel));
 	IWL_DEBUG_RADIO("u32 flags: 0x%08X\n", le32_to_cpu(rxon->flags));
 	IWL_DEBUG_RADIO("u32 filter_flags: 0x%08x\n",
@@ -8525,7 +8543,6 @@ static ssize_t show_measurement(struct device *d,
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
 	struct iwl_spectrum_notification measure_report;
-
 	u32 size = sizeof(measure_report), len = 0, ofs = 0;
 	u8 *data = (u8 *) & measure_report;
 	unsigned long flags;
@@ -8540,9 +8557,9 @@ static ssize_t show_measurement(struct device *d,
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	while (size && (PAGE_SIZE - len)) {
-		len +=
-		    snprint_line(&buf[len], PAGE_SIZE - len,
-				 &data[ofs], min(size, 16U), ofs);
+		hex_dump_to_buffer(data + ofs, size, 16, 1, buf + len,
+				   PAGE_SIZE - len, 1);
+		len = strlen(buf);
 		if (PAGE_SIZE - len)
 			buf[len++] = '\n';
 
@@ -8828,9 +8845,9 @@ static ssize_t show_statistics(struct device *d,
 	}
 
 	while (size && (PAGE_SIZE - len)) {
-		len +=
-		    snprint_line(&buf[len], PAGE_SIZE - len,
-				 &data[ofs], min(size, 16U), ofs);
+		hex_dump_to_buffer(data + ofs, size, 16, 1, buf + len,
+				   PAGE_SIZE - len, 1);
+		len = strlen(buf);
 		if (PAGE_SIZE - len)
 			buf[len++] = '\n';
 
diff --git a/drivers/net/wireless/iwl-helpers.h b/drivers/net/wireless/iwl-helpers.h
index 6ac119f..78b536e 100644
--- a/drivers/net/wireless/iwl-helpers.h
+++ b/drivers/net/wireless/iwl-helpers.h
@@ -287,25 +287,4 @@ static inline int snprint_line(char *buf, size_t count,
 	return out;
 }
 
-#ifdef CONFIG_IWLWIFI_DEBUG
-static inline void printk_buf(int level, const void *p, u32 len)
-{
-	const u8 *data = p;
-	char line[81];
-	u32 ofs = 0;
-	if (!(iwl_debug_level & level))
-		return;
-
-	while (len) {
-		snprint_line(line, sizeof(line), &data[ofs],
-			     min(len, 16U), ofs);
-		printk(KERN_DEBUG "%s\n", line);
-		ofs += 16;
-		len -= min(len, 16U);
-	}
-}
-#else
-#define printk_buf(level, p, len) do {} while (0)
-#endif
-
 #endif				/* __iwl_helpers_h__ */
-- 
1.5.2
