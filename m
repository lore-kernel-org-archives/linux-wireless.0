Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xi.wantstofly.org ([80.101.37.227]:40169 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbZHRDve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 23:51:34 -0400
Date: Tue, 18 Aug 2009 05:51:34 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 04/29] mwl8k: various coding style cleanups
Message-ID: <20090818035134.GI18639@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  130 ++++++++++++++++++-----------------------
 1 files changed, 57 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9fab145..a3b0e19 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1,5 +1,6 @@
 /*
- * drivers/net/wireless/mwl8k.c driver for Marvell TOPDOG 802.11 Wireless cards
+ * drivers/net/wireless/mwl8k.c
+ * Driver for Marvell TOPDOG 802.11 Wireless cards
  *
  * Copyright (C) 2008 Marvell Semiconductor Inc.
  *
@@ -40,12 +41,12 @@ MODULE_DEVICE_TABLE(pci, mwl8k_table);
 
 /* Register definitions */
 #define MWL8K_HIU_GEN_PTR			0x00000c10
-#define  MWL8K_MODE_STA				0x0000005a
-#define  MWL8K_MODE_AP				0x000000a5
+#define  MWL8K_MODE_STA				 0x0000005a
+#define  MWL8K_MODE_AP				 0x000000a5
 #define MWL8K_HIU_INT_CODE			0x00000c14
-#define  MWL8K_FWSTA_READY			0xf0f1f2f4
-#define  MWL8K_FWAP_READY			0xf1f2f4a5
-#define  MWL8K_INT_CODE_CMD_FINISHED		0x00000005
+#define  MWL8K_FWSTA_READY			 0xf0f1f2f4
+#define  MWL8K_FWAP_READY			 0xf1f2f4a5
+#define  MWL8K_INT_CODE_CMD_FINISHED		 0x00000005
 #define MWL8K_HIU_SCRATCH			0x00000c40
 
 /* Host->device communications */
@@ -54,10 +55,10 @@ MODULE_DEVICE_TABLE(pci, mwl8k_table);
 #define MWL8K_HIU_H2A_INTERRUPT_MASK		0x00000c20
 #define MWL8K_HIU_H2A_INTERRUPT_CLEAR_SEL	0x00000c24
 #define MWL8K_HIU_H2A_INTERRUPT_STATUS_MASK	0x00000c28
-#define  MWL8K_H2A_INT_DUMMY			(1 << 20)
-#define  MWL8K_H2A_INT_RESET			(1 << 15)
-#define  MWL8K_H2A_INT_DOORBELL			(1 << 1)
-#define  MWL8K_H2A_INT_PPA_READY		(1 << 0)
+#define  MWL8K_H2A_INT_DUMMY			 (1 << 20)
+#define  MWL8K_H2A_INT_RESET			 (1 << 15)
+#define  MWL8K_H2A_INT_DOORBELL			 (1 << 1)
+#define  MWL8K_H2A_INT_PPA_READY		 (1 << 0)
 
 /* Device->host communications */
 #define MWL8K_HIU_A2H_INTERRUPT_EVENTS		0x00000c2c
@@ -65,16 +66,16 @@ MODULE_DEVICE_TABLE(pci, mwl8k_table);
 #define MWL8K_HIU_A2H_INTERRUPT_MASK		0x00000c34
 #define MWL8K_HIU_A2H_INTERRUPT_CLEAR_SEL	0x00000c38
 #define MWL8K_HIU_A2H_INTERRUPT_STATUS_MASK	0x00000c3c
-#define  MWL8K_A2H_INT_DUMMY			(1 << 20)
-#define  MWL8K_A2H_INT_CHNL_SWITCHED		(1 << 11)
-#define  MWL8K_A2H_INT_QUEUE_EMPTY		(1 << 10)
-#define  MWL8K_A2H_INT_RADAR_DETECT		(1 << 7)
-#define  MWL8K_A2H_INT_RADIO_ON			(1 << 6)
-#define  MWL8K_A2H_INT_RADIO_OFF		(1 << 5)
-#define  MWL8K_A2H_INT_MAC_EVENT		(1 << 3)
-#define  MWL8K_A2H_INT_OPC_DONE			(1 << 2)
-#define  MWL8K_A2H_INT_RX_READY			(1 << 1)
-#define  MWL8K_A2H_INT_TX_DONE			(1 << 0)
+#define  MWL8K_A2H_INT_DUMMY			 (1 << 20)
+#define  MWL8K_A2H_INT_CHNL_SWITCHED		 (1 << 11)
+#define  MWL8K_A2H_INT_QUEUE_EMPTY		 (1 << 10)
+#define  MWL8K_A2H_INT_RADAR_DETECT		 (1 << 7)
+#define  MWL8K_A2H_INT_RADIO_ON			 (1 << 6)
+#define  MWL8K_A2H_INT_RADIO_OFF		 (1 << 5)
+#define  MWL8K_A2H_INT_MAC_EVENT		 (1 << 3)
+#define  MWL8K_A2H_INT_OPC_DONE			 (1 << 2)
+#define  MWL8K_A2H_INT_RX_READY			 (1 << 1)
+#define  MWL8K_A2H_INT_TX_DONE			 (1 << 0)
 
 #define MWL8K_A2H_EVENTS	(MWL8K_A2H_INT_DUMMY | \
 				 MWL8K_A2H_INT_CHNL_SWITCHED | \
@@ -331,7 +332,7 @@ static const char *mwl8k_cmd_name(u16 cmd, char *buf, int bufsize)
 					snprintf(buf, bufsize, "%s", #x);\
 					return buf;\
 					} while (0)
-	switch (cmd & (~0x8000)) {
+	switch (cmd & ~0x8000) {
 		MWL8K_CMDNAME(CODE_DNLD);
 		MWL8K_CMDNAME(GET_HW_SPEC);
 		MWL8K_CMDNAME(MAC_MULTICAST_ADR);
@@ -1078,8 +1079,7 @@ static int mwl8k_txq_init(struct ieee80211_hw *hw, int index)
 	int size;
 	int i;
 
-	memset(&txq->tx_stats, 0,
-		sizeof(struct ieee80211_tx_queue_stats));
+	memset(&txq->tx_stats, 0, sizeof(struct ieee80211_tx_queue_stats));
 	txq->tx_stats.limit = MWL8K_TX_DESCS;
 	txq->tx_head = 0;
 	txq->tx_tail = 0;
@@ -1181,10 +1181,10 @@ static int mwl8k_scan_tx_ring(struct mwl8k_priv *priv,
 
 static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw, u32 delay_ms)
 {
-	u32 count = 0;
-	unsigned long timeout = 0;
 	struct mwl8k_priv *priv = hw->priv;
 	DECLARE_COMPLETION_ONSTACK(cmd_wait);
+	u32 count;
+	unsigned long timeout;
 
 	might_sleep();
 
@@ -1219,7 +1219,7 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw, u32 delay_ms)
 		       __func__, __LINE__, delay_ms, count, newcount);
 
 		mwl8k_scan_tx_ring(priv, txinfo, 4);
-		for (index = 0 ; index < 4; index++)
+		for (index = 0; index < 4; index++)
 			printk(KERN_ERR
 				"TXQ:%u L:%u H:%u T:%u FW:%u DRV:%u U:%u\n",
 					index,
@@ -1229,6 +1229,7 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw, u32 delay_ms)
 					txinfo[index].fw_owned,
 					txinfo[index].drv_owned,
 					txinfo[index].unused);
+
 		return -ETIMEDOUT;
 	}
 
@@ -1251,7 +1252,7 @@ static void mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int force)
 		int rc;
 		struct mwl8k_tx_desc *tx_desc;
 		unsigned long addr;
-		size_t size;
+		int size;
 		struct sk_buff *skb;
 		struct ieee80211_tx_info *info;
 		u32 status;
@@ -1275,7 +1276,7 @@ static void mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int force)
 		priv->pending_tx_pkts--;
 
 		addr = le32_to_cpu(tx_desc->pkt_phys_addr);
-		size = (u32)(le16_to_cpu(tx_desc->pkt_len));
+		size = le16_to_cpu(tx_desc->pkt_len);
 		skb = txq->tx_skb[tx].skb;
 		txq->tx_skb[tx].skb = NULL;
 
@@ -1312,12 +1313,8 @@ static void mwl8k_txq_reclaim(struct ieee80211_hw *hw, int index, int force)
 
 		info = IEEE80211_SKB_CB(skb);
 		ieee80211_tx_info_clear_status(info);
-
-		/* Convert firmware status stuff into tx_status */
-		if (MWL8K_TXD_SUCCESS(status)) {
-			/* Transmit OK */
+		if (MWL8K_TXD_SUCCESS(status))
 			info->flags |= IEEE80211_TX_STAT_ACK;
-		}
 
 		ieee80211_tx_status_irqsafe(hw, skb);
 
@@ -1522,7 +1519,6 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 	dma_addr_t dma_addr;
 	unsigned int dma_size;
 	int rc;
-	u16 __iomem *result;
 	unsigned long timeout = 0;
 	u8 buf[32];
 
@@ -1551,7 +1547,6 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 	pci_unmap_single(priv->pdev, dma_addr, dma_size,
 					PCI_DMA_BIDIRECTIONAL);
 
-	result = &cmd->result;
 	if (!timeout) {
 		spin_lock_irq(&priv->fw_lock);
 		priv->hostcmd_wait = NULL;
@@ -1562,12 +1557,12 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 		       MWL8K_CMD_TIMEOUT_MS);
 		rc = -ETIMEDOUT;
 	} else {
-		rc = *result ? -EINVAL : 0;
+		rc = cmd->result ? -EINVAL : 0;
 		if (rc)
 			printk(KERN_ERR "%s: Command %s error 0x%x\n",
 			       priv->name,
 			       mwl8k_cmd_name(cmd->code, buf, sizeof(buf)),
-			       *result);
+			       cmd->result);
 	}
 
 	return rc;
@@ -1638,10 +1633,11 @@ struct mwl8k_cmd_mac_multicast_adr {
 	struct mwl8k_cmd_pkt header;
 	__le16 action;
 	__le16 numaddr;
-	__u8 addr[1][ETH_ALEN];
+	__u8 addr[0][ETH_ALEN];
 };
 
 #define MWL8K_ENABLE_RX_MULTICAST 0x000F
+
 static int mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw,
 					int mc_count,
 					struct dev_addr_list *mclist)
@@ -1649,7 +1645,8 @@ static int mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw,
 	struct mwl8k_cmd_mac_multicast_adr *cmd;
 	int index = 0;
 	int rc;
-	int size = sizeof(*cmd) + ((mc_count - 1) * ETH_ALEN);
+	int size = sizeof(*cmd) + mc_count * ETH_ALEN;
+
 	cmd = kzalloc(size, GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
@@ -1658,13 +1655,13 @@ static int mwl8k_cmd_mac_multicast_adr(struct ieee80211_hw *hw,
 	cmd->header.length = cpu_to_le16(size);
 	cmd->action = cpu_to_le16(MWL8K_ENABLE_RX_MULTICAST);
 	cmd->numaddr = cpu_to_le16(mc_count);
-	while ((index < mc_count) && mclist) {
+
+	while (index < mc_count && mclist) {
 		if (mclist->da_addrlen != ETH_ALEN) {
 			rc = -EINVAL;
 			goto mwl8k_cmd_mac_multicast_adr_exit;
 		}
-		memcpy(cmd->addr[index], mclist->da_addr, ETH_ALEN);
-		index++;
+		memcpy(cmd->addr[index++], mclist->da_addr, ETH_ALEN);
 		mclist = mclist->next;
 	}
 
@@ -1846,7 +1843,7 @@ struct mwl8k_cmd_set_post_scan {
 } __attribute__((packed));
 
 static int
-mwl8k_cmd_set_post_scan(struct ieee80211_hw *hw, __u8 mac[ETH_ALEN])
+mwl8k_cmd_set_post_scan(struct ieee80211_hw *hw, __u8 *mac)
 {
 	struct mwl8k_cmd_set_post_scan *cmd;
 	int rc;
@@ -1980,7 +1977,7 @@ static int mwl8k_enable_sniffer(struct ieee80211_hw *hw, bool enable)
 
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_ENABLE_SNIFFER);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-	cmd->action = enable ? cpu_to_le32((u32)MWL8K_CMD_SET) : 0;
+	cmd->action = cpu_to_le32(!!enable);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -1989,7 +1986,7 @@ static int mwl8k_enable_sniffer(struct ieee80211_hw *hw, bool enable)
 }
 
 /*
- * CMD_SET_RATE_ADAPT_MODE.
+ * CMD_SET_RATEADAPT_MODE.
  */
 struct mwl8k_cmd_set_rate_adapt_mode {
 	struct mwl8k_cmd_pkt header;
@@ -2117,22 +2114,18 @@ mwl8k_set_edca_params(struct ieee80211_hw *hw, __u8 qnum,
 		__u8 aifs, __u16 txop)
 {
 	struct mwl8k_cmd_set_edca_params *cmd;
-	u32 log_cw_min, log_cw_max;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
 		return -ENOMEM;
 
-	log_cw_min = ilog2(cw_min+1);
-	log_cw_max = ilog2(cw_max+1);
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_EDCA_PARAMS);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-
 	cmd->action = cpu_to_le16(MWL8K_SET_EDCA_ALL);
 	cmd->txop = cpu_to_le16(txop);
-	cmd->log_cw_max = (u8)log_cw_max;
-	cmd->log_cw_min = (u8)log_cw_min;
+	cmd->log_cw_max = (u8)ilog2(cw_max + 1);
+	cmd->log_cw_min = (u8)ilog2(cw_min + 1);
 	cmd->aifs = aifs;
 	cmd->txq = qnum;
 
@@ -2173,11 +2166,7 @@ static int mwl8k_finalize_join(struct ieee80211_hw *hw, void *frame,
 
 	cmd->header.code = cpu_to_le16(MWL8K_CMD_SET_FINALIZE_JOIN);
 	cmd->header.length = cpu_to_le16(sizeof(*cmd));
-
-	if (dtim)
-		cmd->sleep_interval = cpu_to_le32(dtim);
-	else
-		cmd->sleep_interval = cpu_to_le32(1);
+	cmd->sleep_interval = cpu_to_le32(dtim ? dtim : 1);
 
 	hdrlen = ieee80211_hdrlen(payload->frame_control);
 
@@ -2189,8 +2178,8 @@ static int mwl8k_finalize_join(struct ieee80211_hw *hw, void *frame,
 			"sent to firmware. Sz=%u MAX=%u\n", __func__,
 			payload_len, MWL8K_FJ_BEACON_MAXLEN);
 
-	payload_len = payload_len > MWL8K_FJ_BEACON_MAXLEN ?
-				MWL8K_FJ_BEACON_MAXLEN : payload_len;
+	if (payload_len > MWL8K_FJ_BEACON_MAXLEN)
+		payload_len = MWL8K_FJ_BEACON_MAXLEN;
 
 	if (payload && payload_len)
 		memcpy(cmd->beacon_data, &payload->u.beacon, payload_len);
@@ -2250,7 +2239,7 @@ static int mwl8k_cmd_update_sta_db(struct ieee80211_hw *hw,
 		peer_info->amsdu_enabled = 0;
 
 		rates = peer_info->legacy_rates;
-		for (count = 0 ; count < mv_vif->legacy_nrates; count++)
+		for (count = 0; count < mv_vif->legacy_nrates; count++)
 			rates[count] = bitrates[count].hw_value;
 
 		rc = mwl8k_post_cmd(hw, &cmd->header);
@@ -2313,8 +2302,6 @@ static int mwl8k_cmd_set_aid(struct ieee80211_hw *hw,
 
 	memcpy(cmd->bssid, mv_vif->bssid, ETH_ALEN);
 
-	prot_mode = MWL8K_FRAME_PROT_DISABLED;
-
 	if (info->use_cts_prot) {
 		prot_mode = MWL8K_FRAME_PROT_11G;
 	} else {
@@ -2331,7 +2318,6 @@ static int mwl8k_cmd_set_aid(struct ieee80211_hw *hw,
 			break;
 		}
 	}
-
 	cmd->protection_mode = cpu_to_le16(prot_mode);
 
 	for (count = 0; count < mv_vif->legacy_nrates; count++)
@@ -2934,7 +2920,7 @@ static int mwl8k_add_interface(struct ieee80211_hw *hw,
 	mwl8k_vif->priv = priv;
 
 	/* Setup initial PHY parameters */
-	memcpy(mwl8k_vif->legacy_rates ,
+	memcpy(mwl8k_vif->legacy_rates,
 		priv->rates, sizeof(mwl8k_vif->legacy_rates));
 	mwl8k_vif->legacy_nrates = ARRAY_SIZE(priv->rates);
 
@@ -3178,8 +3164,9 @@ static int mwl8k_configure_filter_wt(struct work_struct *wt)
 	if (rc)
 		goto mwl8k_configure_filter_exit;
 	if (mc_count) {
-		mc_count = mc_count < priv->num_mcaddrs ?
-				mc_count : priv->num_mcaddrs;
+		if (mc_count > priv->num_mcaddrs)
+			mc_count = priv->num_mcaddrs;
+
 		rc = mwl8k_cmd_mac_multicast_adr(hw, mc_count, mclist);
 		if (rc)
 			printk(KERN_ERR
@@ -3398,12 +3385,9 @@ static void mwl8k_tx_reclaim_handler(unsigned long data)
 	for (i = 0; i < MWL8K_TX_QUEUES; i++)
 		mwl8k_txq_reclaim(hw, i, 0);
 
-	if (priv->tx_wait != NULL) {
-		int count = mwl8k_txq_busy(priv);
-		if (count == 0) {
-			complete(priv->tx_wait);
-			priv->tx_wait = NULL;
-		}
+	if (priv->tx_wait != NULL && mwl8k_txq_busy(priv) == 0) {
+		complete(priv->tx_wait);
+		priv->tx_wait = NULL;
 	}
 	spin_unlock_bh(&priv->tx_lock);
 }
@@ -3413,7 +3397,7 @@ static void mwl8k_finalize_join_worker(struct work_struct *work)
 	struct mwl8k_priv *priv =
 		container_of(work, struct mwl8k_priv, finalize_join_worker);
 	struct sk_buff *skb = priv->beacon_skb;
-	u8 dtim = (MWL8K_VIF(priv->vif))->bss_info.dtim_period;
+	u8 dtim = MWL8K_VIF(priv->vif)->bss_info.dtim_period;
 
 	mwl8k_finalize_join(priv->hw, skb->data, skb->len, dtim);
 	dev_kfree_skb(skb);
@@ -3500,7 +3484,7 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 		BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_MONITOR);
 
 	/* Set rssi and noise values to dBm */
-	hw->flags |= (IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_NOISE_DBM);
+	hw->flags |= IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_NOISE_DBM;
 	hw->vif_data_size = sizeof(struct mwl8k_vif);
 	priv->vif = NULL;
 
-- 
1.5.6.4
