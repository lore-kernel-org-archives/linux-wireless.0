Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45422 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbZK3Rct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:32:49 -0500
Date: Mon, 30 Nov 2009 18:32:54 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 09/11] mwl8k: fix up AP vs. STA firmware image receive descriptor handling
Message-ID: <20091130173254.GY20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The receive descriptor ops that are currently marked as being for
8687 only are actually used for all STA firmware images, whereas the
receive descriptor ops marked as 8366 are only used on 8366 when an
AP firmware image is in use.

Rename the receive descriptor ops to reflect this, use the STA ops
unconditionally if the firmware image loaded reported the STA ready
code, and rename the mwl8k_device_info::rxd_ops member to ap_rxd_ops
to indicate that it should only be used if we are running on AP
firmware.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |  124 ++++++++++++++++++++----------------------
 1 files changed, 60 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9f74dca..36c826c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -93,8 +93,7 @@ struct mwl8k_device_info {
 	char *part_name;
 	char *helper_image;
 	char *fw_image;
-	struct rxd_ops *rxd_ops;
-	u16 modes;
+	struct rxd_ops *ap_rxd_ops;
 };
 
 struct mwl8k_rx_queue {
@@ -581,10 +580,7 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 		return rc;
 	}
 
-	if (priv->device_info->modes & BIT(NL80211_IFTYPE_AP))
-		iowrite32(MWL8K_MODE_AP, priv->regs + MWL8K_HIU_GEN_PTR);
-	else
-		iowrite32(MWL8K_MODE_STA, priv->regs + MWL8K_HIU_GEN_PTR);
+	iowrite32(MWL8K_MODE_STA, priv->regs + MWL8K_HIU_GEN_PTR);
 
 	loops = 500000;
 	do {
@@ -721,9 +717,9 @@ static inline void mwl8k_add_dma_header(struct sk_buff *skb)
 
 
 /*
- * Packet reception for 88w8366.
+ * Packet reception for 88w8366 AP firmware.
  */
-struct mwl8k_rxd_8366 {
+struct mwl8k_rxd_8366_ap {
 	__le16 pkt_len;
 	__u8 sq2;
 	__u8 rate;
@@ -741,23 +737,23 @@ struct mwl8k_rxd_8366 {
 	__u8 rx_ctrl;
 } __attribute__((packed));
 
-#define MWL8K_8366_RATE_INFO_MCS_FORMAT		0x80
-#define MWL8K_8366_RATE_INFO_40MHZ		0x40
-#define MWL8K_8366_RATE_INFO_RATEID(x)		((x) & 0x3f)
+#define MWL8K_8366_AP_RATE_INFO_MCS_FORMAT	0x80
+#define MWL8K_8366_AP_RATE_INFO_40MHZ		0x40
+#define MWL8K_8366_AP_RATE_INFO_RATEID(x)	((x) & 0x3f)
 
-#define MWL8K_8366_RX_CTRL_OWNED_BY_HOST	0x80
+#define MWL8K_8366_AP_RX_CTRL_OWNED_BY_HOST	0x80
 
-static void mwl8k_rxd_8366_init(void *_rxd, dma_addr_t next_dma_addr)
+static void mwl8k_rxd_8366_ap_init(void *_rxd, dma_addr_t next_dma_addr)
 {
-	struct mwl8k_rxd_8366 *rxd = _rxd;
+	struct mwl8k_rxd_8366_ap *rxd = _rxd;
 
 	rxd->next_rxd_phys_addr = cpu_to_le32(next_dma_addr);
-	rxd->rx_ctrl = MWL8K_8366_RX_CTRL_OWNED_BY_HOST;
+	rxd->rx_ctrl = MWL8K_8366_AP_RX_CTRL_OWNED_BY_HOST;
 }
 
-static void mwl8k_rxd_8366_refill(void *_rxd, dma_addr_t addr, int len)
+static void mwl8k_rxd_8366_ap_refill(void *_rxd, dma_addr_t addr, int len)
 {
-	struct mwl8k_rxd_8366 *rxd = _rxd;
+	struct mwl8k_rxd_8366_ap *rxd = _rxd;
 
 	rxd->pkt_len = cpu_to_le16(len);
 	rxd->pkt_phys_addr = cpu_to_le32(addr);
@@ -766,12 +762,12 @@ static void mwl8k_rxd_8366_refill(void *_rxd, dma_addr_t addr, int len)
 }
 
 static int
-mwl8k_rxd_8366_process(void *_rxd, struct ieee80211_rx_status *status,
-		       __le16 *qos)
+mwl8k_rxd_8366_ap_process(void *_rxd, struct ieee80211_rx_status *status,
+			  __le16 *qos)
 {
-	struct mwl8k_rxd_8366 *rxd = _rxd;
+	struct mwl8k_rxd_8366_ap *rxd = _rxd;
 
-	if (!(rxd->rx_ctrl & MWL8K_8366_RX_CTRL_OWNED_BY_HOST))
+	if (!(rxd->rx_ctrl & MWL8K_8366_AP_RX_CTRL_OWNED_BY_HOST))
 		return -1;
 	rmb();
 
@@ -780,11 +776,11 @@ mwl8k_rxd_8366_process(void *_rxd, struct ieee80211_rx_status *status,
 	status->signal = -rxd->rssi;
 	status->noise = -rxd->noise_floor;
 
-	if (rxd->rate & MWL8K_8366_RATE_INFO_MCS_FORMAT) {
+	if (rxd->rate & MWL8K_8366_AP_RATE_INFO_MCS_FORMAT) {
 		status->flag |= RX_FLAG_HT;
-		if (rxd->rate & MWL8K_8366_RATE_INFO_40MHZ)
+		if (rxd->rate & MWL8K_8366_AP_RATE_INFO_40MHZ)
 			status->flag |= RX_FLAG_40MHZ;
-		status->rate_idx = MWL8K_8366_RATE_INFO_RATEID(rxd->rate);
+		status->rate_idx = MWL8K_8366_AP_RATE_INFO_RATEID(rxd->rate);
 	} else {
 		int i;
 
@@ -804,17 +800,17 @@ mwl8k_rxd_8366_process(void *_rxd, struct ieee80211_rx_status *status,
 	return le16_to_cpu(rxd->pkt_len);
 }
 
-static struct rxd_ops rxd_8366_ops = {
-	.rxd_size	= sizeof(struct mwl8k_rxd_8366),
-	.rxd_init	= mwl8k_rxd_8366_init,
-	.rxd_refill	= mwl8k_rxd_8366_refill,
-	.rxd_process	= mwl8k_rxd_8366_process,
+static struct rxd_ops rxd_8366_ap_ops = {
+	.rxd_size	= sizeof(struct mwl8k_rxd_8366_ap),
+	.rxd_init	= mwl8k_rxd_8366_ap_init,
+	.rxd_refill	= mwl8k_rxd_8366_ap_refill,
+	.rxd_process	= mwl8k_rxd_8366_ap_process,
 };
 
 /*
- * Packet reception for 88w8687.
+ * Packet reception for STA firmware.
  */
-struct mwl8k_rxd_8687 {
+struct mwl8k_rxd_sta {
 	__le16 pkt_len;
 	__u8 link_quality;
 	__u8 noise_level;
@@ -831,26 +827,26 @@ struct mwl8k_rxd_8687 {
 	__u8 pad2[2];
 } __attribute__((packed));
 
-#define MWL8K_8687_RATE_INFO_SHORTPRE		0x8000
-#define MWL8K_8687_RATE_INFO_ANTSELECT(x)	(((x) >> 11) & 0x3)
-#define MWL8K_8687_RATE_INFO_RATEID(x)		(((x) >> 3) & 0x3f)
-#define MWL8K_8687_RATE_INFO_40MHZ		0x0004
-#define MWL8K_8687_RATE_INFO_SHORTGI		0x0002
-#define MWL8K_8687_RATE_INFO_MCS_FORMAT		0x0001
+#define MWL8K_STA_RATE_INFO_SHORTPRE		0x8000
+#define MWL8K_STA_RATE_INFO_ANTSELECT(x)	(((x) >> 11) & 0x3)
+#define MWL8K_STA_RATE_INFO_RATEID(x)		(((x) >> 3) & 0x3f)
+#define MWL8K_STA_RATE_INFO_40MHZ		0x0004
+#define MWL8K_STA_RATE_INFO_SHORTGI		0x0002
+#define MWL8K_STA_RATE_INFO_MCS_FORMAT		0x0001
 
-#define MWL8K_8687_RX_CTRL_OWNED_BY_HOST	0x02
+#define MWL8K_STA_RX_CTRL_OWNED_BY_HOST		0x02
 
-static void mwl8k_rxd_8687_init(void *_rxd, dma_addr_t next_dma_addr)
+static void mwl8k_rxd_sta_init(void *_rxd, dma_addr_t next_dma_addr)
 {
-	struct mwl8k_rxd_8687 *rxd = _rxd;
+	struct mwl8k_rxd_sta *rxd = _rxd;
 
 	rxd->next_rxd_phys_addr = cpu_to_le32(next_dma_addr);
-	rxd->rx_ctrl = MWL8K_8687_RX_CTRL_OWNED_BY_HOST;
+	rxd->rx_ctrl = MWL8K_STA_RX_CTRL_OWNED_BY_HOST;
 }
 
-static void mwl8k_rxd_8687_refill(void *_rxd, dma_addr_t addr, int len)
+static void mwl8k_rxd_sta_refill(void *_rxd, dma_addr_t addr, int len)
 {
-	struct mwl8k_rxd_8687 *rxd = _rxd;
+	struct mwl8k_rxd_sta *rxd = _rxd;
 
 	rxd->pkt_len = cpu_to_le16(len);
 	rxd->pkt_phys_addr = cpu_to_le32(addr);
@@ -859,13 +855,13 @@ static void mwl8k_rxd_8687_refill(void *_rxd, dma_addr_t addr, int len)
 }
 
 static int
-mwl8k_rxd_8687_process(void *_rxd, struct ieee80211_rx_status *status,
+mwl8k_rxd_sta_process(void *_rxd, struct ieee80211_rx_status *status,
 		       __le16 *qos)
 {
-	struct mwl8k_rxd_8687 *rxd = _rxd;
+	struct mwl8k_rxd_sta *rxd = _rxd;
 	u16 rate_info;
 
-	if (!(rxd->rx_ctrl & MWL8K_8687_RX_CTRL_OWNED_BY_HOST))
+	if (!(rxd->rx_ctrl & MWL8K_STA_RX_CTRL_OWNED_BY_HOST))
 		return -1;
 	rmb();
 
@@ -875,16 +871,16 @@ mwl8k_rxd_8687_process(void *_rxd, struct ieee80211_rx_status *status,
 
 	status->signal = -rxd->rssi;
 	status->noise = -rxd->noise_level;
-	status->antenna = MWL8K_8687_RATE_INFO_ANTSELECT(rate_info);
-	status->rate_idx = MWL8K_8687_RATE_INFO_RATEID(rate_info);
+	status->antenna = MWL8K_STA_RATE_INFO_ANTSELECT(rate_info);
+	status->rate_idx = MWL8K_STA_RATE_INFO_RATEID(rate_info);
 
-	if (rate_info & MWL8K_8687_RATE_INFO_SHORTPRE)
+	if (rate_info & MWL8K_STA_RATE_INFO_SHORTPRE)
 		status->flag |= RX_FLAG_SHORTPRE;
-	if (rate_info & MWL8K_8687_RATE_INFO_40MHZ)
+	if (rate_info & MWL8K_STA_RATE_INFO_40MHZ)
 		status->flag |= RX_FLAG_40MHZ;
-	if (rate_info & MWL8K_8687_RATE_INFO_SHORTGI)
+	if (rate_info & MWL8K_STA_RATE_INFO_SHORTGI)
 		status->flag |= RX_FLAG_SHORT_GI;
-	if (rate_info & MWL8K_8687_RATE_INFO_MCS_FORMAT)
+	if (rate_info & MWL8K_STA_RATE_INFO_MCS_FORMAT)
 		status->flag |= RX_FLAG_HT;
 
 	status->band = IEEE80211_BAND_2GHZ;
@@ -895,11 +891,11 @@ mwl8k_rxd_8687_process(void *_rxd, struct ieee80211_rx_status *status,
 	return le16_to_cpu(rxd->pkt_len);
 }
 
-static struct rxd_ops rxd_8687_ops = {
-	.rxd_size	= sizeof(struct mwl8k_rxd_8687),
-	.rxd_init	= mwl8k_rxd_8687_init,
-	.rxd_refill	= mwl8k_rxd_8687_refill,
-	.rxd_process	= mwl8k_rxd_8687_process,
+static struct rxd_ops rxd_sta_ops = {
+	.rxd_size	= sizeof(struct mwl8k_rxd_sta),
+	.rxd_init	= mwl8k_rxd_sta_init,
+	.rxd_refill	= mwl8k_rxd_sta_refill,
+	.rxd_process	= mwl8k_rxd_sta_process,
 };
 
 
@@ -3268,15 +3264,12 @@ static struct mwl8k_device_info mwl8k_info_tbl[] __devinitdata = {
 		.part_name	= "88w8687",
 		.helper_image	= "mwl8k/helper_8687.fw",
 		.fw_image	= "mwl8k/fmimage_8687.fw",
-		.rxd_ops	= &rxd_8687_ops,
-		.modes		= BIT(NL80211_IFTYPE_STATION),
 	},
 	[MWL8366] = {
 		.part_name	= "88w8366",
 		.helper_image	= "mwl8k/helper_8366.fw",
 		.fw_image	= "mwl8k/fmimage_8366.fw",
-		.rxd_ops	= &rxd_8366_ops,
-		.modes		= 0,
+		.ap_rxd_ops	= &rxd_8366_ap_ops,
 	},
 };
 
@@ -3381,7 +3374,10 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 	mwl8k_release_firmware(priv);
 
 
-	priv->rxd_ops = priv->device_info->rxd_ops;
+	if (priv->ap_fw)
+		priv->rxd_ops = priv->device_info->ap_rxd_ops;
+	else
+		priv->rxd_ops = &rxd_sta_ops;
 
 	priv->sniffer_enabled = false;
 	priv->wmm_enabled = false;
@@ -3410,8 +3406,6 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 
 	hw->queues = MWL8K_TX_QUEUES;
 
-	hw->wiphy->interface_modes = priv->device_info->modes;
-
 	/* Set rssi and noise values to dBm */
 	hw->flags |= IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_NOISE_DBM;
 	hw->vif_data_size = sizeof(struct mwl8k_vif);
@@ -3481,6 +3475,8 @@ static int __devinit mwl8k_probe(struct pci_dev *pdev,
 			rc = mwl8k_cmd_set_hw_spec(hw);
 	} else {
 		rc = mwl8k_cmd_get_hw_spec_sta(hw);
+
+		hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	}
 	if (rc) {
 		printk(KERN_ERR "%s: Cannot initialise firmware\n",
-- 
1.5.6.4
