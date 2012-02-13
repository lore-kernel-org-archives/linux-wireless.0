Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499Ab2BMKYR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:17 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 13/24] iwlegacy: get rid of tx/rx traffic log
Date: Mon, 13 Feb 2012 11:23:20 +0100
Message-Id: <1329128611-6815-14-git-send-email-sgruszka@redhat.com> (sfid-20120213_112425_073647_51C3DE2D)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The same data can be gathered using monitor mode.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |   12 +--
 drivers/net/wireless/iwlegacy/3945.c     |    2 -
 drivers/net/wireless/iwlegacy/4965-mac.c |   13 +--
 drivers/net/wireless/iwlegacy/common.c   |  247 ------------------------------
 drivers/net/wireless/iwlegacy/common.h   |   51 +------
 drivers/net/wireless/iwlegacy/debug.c    |  243 ++++++++++++++++-------------
 6 files changed, 145 insertions(+), 423 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 19a4d56..1743acc 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -573,7 +573,6 @@ il3945_tx_skb(struct il_priv *il, struct sk_buff *skb)
 	len = (u16) skb->len;
 	tx_cmd->len = cpu_to_le16(len);
 
-	il_dbg_log_tx_data_frame(il, len, hdr);
 	il_update_stats(il, true, fc, len);
 	tx_cmd->tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
 	tx_cmd->tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
@@ -3098,11 +3097,9 @@ il3945_store_debug_level(struct device *d, struct device_attribute *attr,
 	ret = strict_strtoul(buf, 0, &val);
 	if (ret)
 		IL_INFO("%s is not in hex or decimal form.\n", buf);
-	else {
+	else
 		il->debug_level = val;
-		if (il_alloc_traffic_mem(il))
-			IL_ERR("Not enough memory to generate traffic log\n");
-	}
+
 	return strnlen(buf, count);
 }
 
@@ -3625,9 +3622,6 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	il->pci_dev = pdev;
 	il->inta_mask = CSR_INI_SET_MASK;
 
-	if (il_alloc_traffic_mem(il))
-		IL_ERR("Not enough memory to generate traffic log\n");
-
 	/***************************
 	 * 2. Initializing PCI bus
 	 * *************************/
@@ -3790,7 +3784,6 @@ out_pci_disable_device:
 	pci_set_drvdata(pdev, NULL);
 	pci_disable_device(pdev);
 out_ieee80211_free_hw:
-	il_free_traffic_mem(il);
 	ieee80211_free_hw(il->hw);
 out:
 	return err;
@@ -3858,7 +3851,6 @@ il3945_pci_remove(struct pci_dev *pdev)
 	 * until now... */
 	destroy_workqueue(il->workqueue);
 	il->workqueue = NULL;
-	il_free_traffic_mem(il);
 
 	free_irq(pdev->irq, il);
 	pci_disable_msi(pdev);
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index fde6979..95ebd43 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -573,8 +573,6 @@ il3945_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 		network_packet ? '*' : ' ', le16_to_cpu(rx_hdr->channel),
 		rx_status.signal, rx_status.signal, rx_status.rate_idx);
 
-	il_dbg_log_rx_data_frame(il, le16_to_cpu(rx_hdr->len), header);
-
 	if (network_packet) {
 		il->_3945.last_beacon_time =
 		    le32_to_cpu(rx_end->beacon_timestamp);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 89275bf..b251d34 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -688,7 +688,6 @@ il4965_hdl_rx(struct il_priv *il, struct il_rx_buf *rxb)
 	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
 	rx_status.signal = il4965_calc_rssi(il, phy_res);
 
-	il_dbg_log_rx_data_frame(il, len, header);
 	D_STATS("Rssi %d, TSF %llu\n", rx_status.signal,
 		(unsigned long long)rx_status.mactime);
 
@@ -1781,7 +1780,6 @@ il4965_tx_skb(struct il_priv *il, struct sk_buff *skb)
 
 	/* TODO need this for burst mode later on */
 	il4965_tx_cmd_build_basic(il, skb, tx_cmd, info, hdr, sta_id);
-	il_dbg_log_tx_data_frame(il, len, hdr);
 
 	il4965_tx_cmd_build_rate(il, tx_cmd, info, fc);
 
@@ -4541,11 +4539,9 @@ il4965_store_debug_level(struct device *d, struct device_attribute *attr,
 	ret = strict_strtoul(buf, 0, &val);
 	if (ret)
 		IL_ERR("%s is not in hex or decimal form.\n", buf);
-	else {
+	else
 		il->debug_level = val;
-		if (il_alloc_traffic_mem(il))
-			IL_ERR("Not enough memory to generate traffic log\n");
-	}
+
 	return strnlen(buf, count);
 }
 
@@ -6483,9 +6479,6 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	il->pci_dev = pdev;
 	il->inta_mask = CSR_INI_SET_MASK;
 
-	if (il_alloc_traffic_mem(il))
-		IL_ERR("Not enough memory to generate traffic log\n");
-
 	/**************************
 	 * 2. Initializing PCI bus
 	 **************************/
@@ -6663,7 +6656,6 @@ out_pci_release_regions:
 out_pci_disable_device:
 	pci_disable_device(pdev);
 out_ieee80211_free_hw:
-	il_free_traffic_mem(il);
 	ieee80211_free_hw(il->hw);
 out:
 	return err;
@@ -6734,7 +6726,6 @@ il4965_pci_remove(struct pci_dev *pdev)
 	 * until now... */
 	destroy_workqueue(il->workqueue);
 	il->workqueue = NULL;
-	il_free_traffic_mem(il);
 
 	free_irq(il->pci_dev->irq, il);
 	pci_disable_msi(il->pci_dev);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 1bf8616..21b355a 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4574,253 +4574,6 @@ il_txq_mem(struct il_priv *il)
 }
 EXPORT_SYMBOL(il_txq_mem);
 
-#ifdef CONFIG_IWLEGACY_DEBUGFS
-
-#define IL_TRAFFIC_DUMP_SIZE	(IL_TRAFFIC_ENTRY_SIZE * IL_TRAFFIC_ENTRIES)
-
-void
-il_reset_traffic_log(struct il_priv *il)
-{
-	il->tx_traffic_idx = 0;
-	il->rx_traffic_idx = 0;
-	if (il->tx_traffic)
-		memset(il->tx_traffic, 0, IL_TRAFFIC_DUMP_SIZE);
-	if (il->rx_traffic)
-		memset(il->rx_traffic, 0, IL_TRAFFIC_DUMP_SIZE);
-}
-
-int
-il_alloc_traffic_mem(struct il_priv *il)
-{
-	u32 traffic_size = IL_TRAFFIC_DUMP_SIZE;
-
-	if (il_debug_level & IL_DL_TX) {
-		if (!il->tx_traffic) {
-			il->tx_traffic = kzalloc(traffic_size, GFP_KERNEL);
-			if (!il->tx_traffic)
-				return -ENOMEM;
-		}
-	}
-	if (il_debug_level & IL_DL_RX) {
-		if (!il->rx_traffic) {
-			il->rx_traffic = kzalloc(traffic_size, GFP_KERNEL);
-			if (!il->rx_traffic)
-				return -ENOMEM;
-		}
-	}
-	il_reset_traffic_log(il);
-	return 0;
-}
-EXPORT_SYMBOL(il_alloc_traffic_mem);
-
-void
-il_free_traffic_mem(struct il_priv *il)
-{
-	kfree(il->tx_traffic);
-	il->tx_traffic = NULL;
-
-	kfree(il->rx_traffic);
-	il->rx_traffic = NULL;
-}
-EXPORT_SYMBOL(il_free_traffic_mem);
-
-void
-il_dbg_log_tx_data_frame(struct il_priv *il, u16 length,
-			 struct ieee80211_hdr *header)
-{
-	__le16 fc;
-	u16 len;
-
-	if (likely(!(il_debug_level & IL_DL_TX)))
-		return;
-
-	if (!il->tx_traffic)
-		return;
-
-	fc = header->frame_control;
-	if (ieee80211_is_data(fc)) {
-		len =
-		    (length >
-		     IL_TRAFFIC_ENTRY_SIZE) ? IL_TRAFFIC_ENTRY_SIZE : length;
-		memcpy((il->tx_traffic +
-			(il->tx_traffic_idx * IL_TRAFFIC_ENTRY_SIZE)), header,
-		       len);
-		il->tx_traffic_idx =
-		    (il->tx_traffic_idx + 1) % IL_TRAFFIC_ENTRIES;
-	}
-}
-EXPORT_SYMBOL(il_dbg_log_tx_data_frame);
-
-void
-il_dbg_log_rx_data_frame(struct il_priv *il, u16 length,
-			 struct ieee80211_hdr *header)
-{
-	__le16 fc;
-	u16 len;
-
-	if (likely(!(il_debug_level & IL_DL_RX)))
-		return;
-
-	if (!il->rx_traffic)
-		return;
-
-	fc = header->frame_control;
-	if (ieee80211_is_data(fc)) {
-		len =
-		    (length >
-		     IL_TRAFFIC_ENTRY_SIZE) ? IL_TRAFFIC_ENTRY_SIZE : length;
-		memcpy((il->rx_traffic +
-			(il->rx_traffic_idx * IL_TRAFFIC_ENTRY_SIZE)), header,
-		       len);
-		il->rx_traffic_idx =
-		    (il->rx_traffic_idx + 1) % IL_TRAFFIC_ENTRIES;
-	}
-}
-EXPORT_SYMBOL(il_dbg_log_rx_data_frame);
-
-const char *
-il_get_mgmt_string(int cmd)
-{
-	switch (cmd) {
-		IL_CMD(MANAGEMENT_ASSOC_REQ);
-		IL_CMD(MANAGEMENT_ASSOC_RESP);
-		IL_CMD(MANAGEMENT_REASSOC_REQ);
-		IL_CMD(MANAGEMENT_REASSOC_RESP);
-		IL_CMD(MANAGEMENT_PROBE_REQ);
-		IL_CMD(MANAGEMENT_PROBE_RESP);
-		IL_CMD(MANAGEMENT_BEACON);
-		IL_CMD(MANAGEMENT_ATIM);
-		IL_CMD(MANAGEMENT_DISASSOC);
-		IL_CMD(MANAGEMENT_AUTH);
-		IL_CMD(MANAGEMENT_DEAUTH);
-		IL_CMD(MANAGEMENT_ACTION);
-	default:
-		return "UNKNOWN";
-
-	}
-}
-
-const char *
-il_get_ctrl_string(int cmd)
-{
-	switch (cmd) {
-		IL_CMD(CONTROL_BACK_REQ);
-		IL_CMD(CONTROL_BACK);
-		IL_CMD(CONTROL_PSPOLL);
-		IL_CMD(CONTROL_RTS);
-		IL_CMD(CONTROL_CTS);
-		IL_CMD(CONTROL_ACK);
-		IL_CMD(CONTROL_CFEND);
-		IL_CMD(CONTROL_CFENDACK);
-	default:
-		return "UNKNOWN";
-
-	}
-}
-
-void
-il_clear_traffic_stats(struct il_priv *il)
-{
-	memset(&il->tx_stats, 0, sizeof(struct traffic_stats));
-	memset(&il->rx_stats, 0, sizeof(struct traffic_stats));
-}
-
-/*
- * if CONFIG_IWLEGACY_DEBUGFS defined,
- * il_update_stats function will
- * record all the MGMT, CTRL and DATA pkt for both TX and Rx pass
- * Use debugFs to display the rx/rx_stats
- * if CONFIG_IWLEGACY_DEBUGFS not being defined, then no MGMT and CTRL
- * information will be recorded, but DATA pkt still will be recorded
- * for the reason of il_led.c need to control the led blinking based on
- * number of tx and rx data.
- *
- */
-void
-il_update_stats(struct il_priv *il, bool is_tx, __le16 fc, u16 len)
-{
-	struct traffic_stats *stats;
-
-	if (is_tx)
-		stats = &il->tx_stats;
-	else
-		stats = &il->rx_stats;
-
-	if (ieee80211_is_mgmt(fc)) {
-		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
-		case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
-			stats->mgmt[MANAGEMENT_ASSOC_REQ]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_ASSOC_RESP):
-			stats->mgmt[MANAGEMENT_ASSOC_RESP]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
-			stats->mgmt[MANAGEMENT_REASSOC_REQ]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_REASSOC_RESP):
-			stats->mgmt[MANAGEMENT_REASSOC_RESP]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_PROBE_REQ):
-			stats->mgmt[MANAGEMENT_PROBE_REQ]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_PROBE_RESP):
-			stats->mgmt[MANAGEMENT_PROBE_RESP]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_BEACON):
-			stats->mgmt[MANAGEMENT_BEACON]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_ATIM):
-			stats->mgmt[MANAGEMENT_ATIM]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_DISASSOC):
-			stats->mgmt[MANAGEMENT_DISASSOC]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_AUTH):
-			stats->mgmt[MANAGEMENT_AUTH]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
-			stats->mgmt[MANAGEMENT_DEAUTH]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_ACTION):
-			stats->mgmt[MANAGEMENT_ACTION]++;
-			break;
-		}
-	} else if (ieee80211_is_ctl(fc)) {
-		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
-		case cpu_to_le16(IEEE80211_STYPE_BACK_REQ):
-			stats->ctrl[CONTROL_BACK_REQ]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_BACK):
-			stats->ctrl[CONTROL_BACK]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_PSPOLL):
-			stats->ctrl[CONTROL_PSPOLL]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_RTS):
-			stats->ctrl[CONTROL_RTS]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_CTS):
-			stats->ctrl[CONTROL_CTS]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_ACK):
-			stats->ctrl[CONTROL_ACK]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_CFEND):
-			stats->ctrl[CONTROL_CFEND]++;
-			break;
-		case cpu_to_le16(IEEE80211_STYPE_CFENDACK):
-			stats->ctrl[CONTROL_CFENDACK]++;
-			break;
-		}
-	} else {
-		/* data */
-		stats->data_cnt++;
-		stats->data_bytes += len;
-	}
-}
-EXPORT_SYMBOL(il_update_stats);
-#endif
-
 int
 il_force_reset(struct il_priv *il, bool external)
 {
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 873182e..b2a6e52 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1766,57 +1766,21 @@ int il_alloc_txq_mem(struct il_priv *il);
 void il_txq_mem(struct il_priv *il);
 
 #ifdef CONFIG_IWLEGACY_DEBUGFS
-int il_alloc_traffic_mem(struct il_priv *il);
-void il_free_traffic_mem(struct il_priv *il);
-void il_reset_traffic_log(struct il_priv *il);
-void il_dbg_log_tx_data_frame(struct il_priv *il, u16 length,
-			      struct ieee80211_hdr *header);
-void il_dbg_log_rx_data_frame(struct il_priv *il, u16 length,
-			      struct ieee80211_hdr *header);
-const char *il_get_mgmt_string(int cmd);
-const char *il_get_ctrl_string(int cmd);
-void il_clear_traffic_stats(struct il_priv *il);
-void il_update_stats(struct il_priv *il, bool is_tx, __le16 fc, u16 len);
+extern void il_update_stats(struct il_priv *il, bool is_tx, __le16 fc, u16 len);
 #else
-static inline int
-il_alloc_traffic_mem(struct il_priv *il)
-{
-	return 0;
-}
-
-static inline void
-il_free_traffic_mem(struct il_priv *il)
-{
-}
-
-static inline void
-il_reset_traffic_log(struct il_priv *il)
-{
-}
-
-static inline void
-il_dbg_log_tx_data_frame(struct il_priv *il, u16 length,
-			 struct ieee80211_hdr *header)
-{
-}
-
-static inline void
-il_dbg_log_rx_data_frame(struct il_priv *il, u16 length,
-			 struct ieee80211_hdr *header)
-{
-}
-
 static inline void
 il_update_stats(struct il_priv *il, bool is_tx, __le16 fc, u16 len)
 {
 }
 #endif
+
 /*****************************************************
- * RX handlers.
- * **************************************************/
+ * Handlers
+ ***************************************************/
 void il_hdl_pm_sleep(struct il_priv *il, struct il_rx_buf *rxb);
 void il_hdl_pm_debug_stats(struct il_priv *il, struct il_rx_buf *rxb);
 void il_hdl_error(struct il_priv *il, struct il_rx_buf *rxb);
+void il_hdl_csa(struct il_priv *il, struct il_rx_buf *rxb);
 
 /*****************************************************
 * RX
@@ -1827,13 +1791,10 @@ int il_rx_queue_alloc(struct il_priv *il);
 void il_rx_queue_update_write_ptr(struct il_priv *il, struct il_rx_queue *q);
 int il_rx_queue_space(const struct il_rx_queue *q);
 void il_tx_cmd_complete(struct il_priv *il, struct il_rx_buf *rxb);
-/* Handlers */
+
 void il_hdl_spectrum_measurement(struct il_priv *il, struct il_rx_buf *rxb);
 void il_recover_from_stats(struct il_priv *il, struct il_rx_pkt *pkt);
 void il_chswitch_done(struct il_priv *il, bool is_success);
-void il_hdl_csa(struct il_priv *il, struct il_rx_buf *rxb);
-
-/* TX helpers */
 
 /*****************************************************
 * TX
diff --git a/drivers/net/wireless/iwlegacy/debug.c b/drivers/net/wireless/iwlegacy/debug.c
index be6005d..236dc90 100644
--- a/drivers/net/wireless/iwlegacy/debug.c
+++ b/drivers/net/wireless/iwlegacy/debug.c
@@ -31,6 +31,101 @@
 
 #include "common.h"
 
+void
+il_clear_traffic_stats(struct il_priv *il)
+{
+	memset(&il->tx_stats, 0, sizeof(struct traffic_stats));
+	memset(&il->rx_stats, 0, sizeof(struct traffic_stats));
+}
+
+/*
+ * il_update_stats function record all the MGMT, CTRL and DATA pkt for
+ * both TX and Rx . Use debugfs to display the rx/rx_stats
+ */
+void
+il_update_stats(struct il_priv *il, bool is_tx, __le16 fc, u16 len)
+{
+	struct traffic_stats *stats;
+
+	if (is_tx)
+		stats = &il->tx_stats;
+	else
+		stats = &il->rx_stats;
+
+	if (ieee80211_is_mgmt(fc)) {
+		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
+		case cpu_to_le16(IEEE80211_STYPE_ASSOC_REQ):
+			stats->mgmt[MANAGEMENT_ASSOC_REQ]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_ASSOC_RESP):
+			stats->mgmt[MANAGEMENT_ASSOC_RESP]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_REASSOC_REQ):
+			stats->mgmt[MANAGEMENT_REASSOC_REQ]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_REASSOC_RESP):
+			stats->mgmt[MANAGEMENT_REASSOC_RESP]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_PROBE_REQ):
+			stats->mgmt[MANAGEMENT_PROBE_REQ]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_PROBE_RESP):
+			stats->mgmt[MANAGEMENT_PROBE_RESP]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_BEACON):
+			stats->mgmt[MANAGEMENT_BEACON]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_ATIM):
+			stats->mgmt[MANAGEMENT_ATIM]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_DISASSOC):
+			stats->mgmt[MANAGEMENT_DISASSOC]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_AUTH):
+			stats->mgmt[MANAGEMENT_AUTH]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_DEAUTH):
+			stats->mgmt[MANAGEMENT_DEAUTH]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_ACTION):
+			stats->mgmt[MANAGEMENT_ACTION]++;
+			break;
+		}
+	} else if (ieee80211_is_ctl(fc)) {
+		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)) {
+		case cpu_to_le16(IEEE80211_STYPE_BACK_REQ):
+			stats->ctrl[CONTROL_BACK_REQ]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_BACK):
+			stats->ctrl[CONTROL_BACK]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_PSPOLL):
+			stats->ctrl[CONTROL_PSPOLL]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_RTS):
+			stats->ctrl[CONTROL_RTS]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_CTS):
+			stats->ctrl[CONTROL_CTS]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_ACK):
+			stats->ctrl[CONTROL_ACK]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_CFEND):
+			stats->ctrl[CONTROL_CFEND]++;
+			break;
+		case cpu_to_le16(IEEE80211_STYPE_CFENDACK):
+			stats->ctrl[CONTROL_CFENDACK]++;
+			break;
+		}
+	} else {
+		/* data */
+		stats->data_cnt++;
+		stats->data_bytes += len;
+	}
+}
+EXPORT_SYMBOL(il_update_stats);
+
 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
 	if (!debugfs_create_file(#name, mode, parent, il,		\
@@ -98,6 +193,46 @@ static const struct file_operations il_dbgfs_##name##_ops = {	\
 	.llseek = generic_file_llseek,				\
 };
 
+static const char *
+il_get_mgmt_string(int cmd)
+{
+	switch (cmd) {
+	IL_CMD(MANAGEMENT_ASSOC_REQ);
+	IL_CMD(MANAGEMENT_ASSOC_RESP);
+	IL_CMD(MANAGEMENT_REASSOC_REQ);
+	IL_CMD(MANAGEMENT_REASSOC_RESP);
+	IL_CMD(MANAGEMENT_PROBE_REQ);
+	IL_CMD(MANAGEMENT_PROBE_RESP);
+	IL_CMD(MANAGEMENT_BEACON);
+	IL_CMD(MANAGEMENT_ATIM);
+	IL_CMD(MANAGEMENT_DISASSOC);
+	IL_CMD(MANAGEMENT_AUTH);
+	IL_CMD(MANAGEMENT_DEAUTH);
+	IL_CMD(MANAGEMENT_ACTION);
+	default:
+		return "UNKNOWN";
+
+	}
+}
+
+static const char *
+il_get_ctrl_string(int cmd)
+{
+	switch (cmd) {
+	IL_CMD(CONTROL_BACK_REQ);
+	IL_CMD(CONTROL_BACK);
+	IL_CMD(CONTROL_PSPOLL);
+	IL_CMD(CONTROL_RTS);
+	IL_CMD(CONTROL_CTS);
+	IL_CMD(CONTROL_ACK);
+	IL_CMD(CONTROL_CFEND);
+	IL_CMD(CONTROL_CFENDACK);
+	default:
+		return "UNKNOWN";
+
+	}
+}
+
 static ssize_t
 il_dbgfs_tx_stats_read(struct file *file, char __user *user_buf, size_t count,
 		       loff_t *ppos)
@@ -715,112 +850,6 @@ DEBUGFS_READ_FILE_OPS(qos);
 DEBUGFS_READ_WRITE_FILE_OPS(disable_ht40);
 
 static ssize_t
-il_dbgfs_traffic_log_read(struct file *file, char __user *user_buf,
-			  size_t count, loff_t *ppos)
-{
-	struct il_priv *il = file->private_data;
-	int pos = 0, ofs = 0;
-	int cnt = 0, entry;
-	struct il_tx_queue *txq;
-	struct il_queue *q;
-	struct il_rx_queue *rxq = &il->rxq;
-	char *buf;
-	int bufsz =
-	    ((IL_TRAFFIC_ENTRIES * IL_TRAFFIC_ENTRY_SIZE * 64) * 2) +
-	    (il->cfg->num_of_queues * 32 * 8) + 400;
-	const u8 *ptr;
-	ssize_t ret;
-
-	if (!il->txq) {
-		IL_ERR("txq not ready\n");
-		return -EAGAIN;
-	}
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf) {
-		IL_ERR("Can not allocate buffer\n");
-		return -ENOMEM;
-	}
-	pos += scnprintf(buf + pos, bufsz - pos, "Tx Queue\n");
-	for (cnt = 0; cnt < il->hw_params.max_txq_num; cnt++) {
-		txq = &il->txq[cnt];
-		q = &txq->q;
-		pos +=
-		    scnprintf(buf + pos, bufsz - pos,
-			      "q[%d]: read_ptr: %u, write_ptr: %u\n", cnt,
-			      q->read_ptr, q->write_ptr);
-	}
-	if (il->tx_traffic && (il_debug_level & IL_DL_TX)) {
-		ptr = il->tx_traffic;
-		pos +=
-		    scnprintf(buf + pos, bufsz - pos, "Tx Traffic idx: %u\n",
-			      il->tx_traffic_idx);
-		for (cnt = 0, ofs = 0; cnt < IL_TRAFFIC_ENTRIES; cnt++) {
-			for (entry = 0; entry < IL_TRAFFIC_ENTRY_SIZE / 16;
-			     entry++, ofs += 16) {
-				pos +=
-				    scnprintf(buf + pos, bufsz - pos, "0x%.4x ",
-					      ofs);
-				hex_dump_to_buffer(ptr + ofs, 16, 16, 2,
-						   buf + pos, bufsz - pos, 0);
-				pos += strlen(buf + pos);
-				if (bufsz - pos > 0)
-					buf[pos++] = '\n';
-			}
-		}
-	}
-
-	pos += scnprintf(buf + pos, bufsz - pos, "Rx Queue\n");
-	pos +=
-	    scnprintf(buf + pos, bufsz - pos, "read: %u, write: %u\n",
-		      rxq->read, rxq->write);
-
-	if (il->rx_traffic && (il_debug_level & IL_DL_RX)) {
-		ptr = il->rx_traffic;
-		pos +=
-		    scnprintf(buf + pos, bufsz - pos, "Rx Traffic idx: %u\n",
-			      il->rx_traffic_idx);
-		for (cnt = 0, ofs = 0; cnt < IL_TRAFFIC_ENTRIES; cnt++) {
-			for (entry = 0; entry < IL_TRAFFIC_ENTRY_SIZE / 16;
-			     entry++, ofs += 16) {
-				pos +=
-				    scnprintf(buf + pos, bufsz - pos, "0x%.4x ",
-					      ofs);
-				hex_dump_to_buffer(ptr + ofs, 16, 16, 2,
-						   buf + pos, bufsz - pos, 0);
-				pos += strlen(buf + pos);
-				if (bufsz - pos > 0)
-					buf[pos++] = '\n';
-			}
-		}
-	}
-
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	kfree(buf);
-	return ret;
-}
-
-static ssize_t
-il_dbgfs_traffic_log_write(struct file *file, const char __user *user_buf,
-			   size_t count, loff_t *ppos)
-{
-	struct il_priv *il = file->private_data;
-	char buf[8];
-	int buf_size;
-	int traffic_log;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &traffic_log) != 1)
-		return -EFAULT;
-	if (traffic_log == 0)
-		il_reset_traffic_log(il);
-
-	return count;
-}
-
-static ssize_t
 il_dbgfs_tx_queue_read(struct file *file, char __user *user_buf, size_t count,
 		       loff_t *ppos)
 {
@@ -1303,7 +1332,6 @@ il_dbgfs_wd_timeout_write(struct file *file, const char __user *user_buf,
 
 DEBUGFS_READ_FILE_OPS(rx_stats);
 DEBUGFS_READ_FILE_OPS(tx_stats);
-DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
 DEBUGFS_READ_FILE_OPS(rx_queue);
 DEBUGFS_READ_FILE_OPS(tx_queue);
 DEBUGFS_READ_FILE_OPS(ucode_rx_stats);
@@ -1357,7 +1385,6 @@ il_dbgfs_register(struct il_priv *il, const char *name)
 	DEBUGFS_ADD_FILE(disable_ht40, dir_data, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rx_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_stats, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(traffic_log, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rx_queue, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_queue, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(power_save_status, dir_debug, S_IRUSR);
-- 
1.7.1

