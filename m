Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:44860 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112Ab3CALvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 06:51:32 -0500
Date: Fri, 1 Mar 2013 17:12:45 +0530
From: Nishant Sarmukadam <nishants@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>
Subject: [PATCH 1/2] mwl8k: Adding support for 8764 4x4 AP
Message-ID: <20130301114245.GA11071@markyou.marvell.com> (sfid-20130301_125135_297312_6D22A302)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch does the following:-

a Add entry in the PCIe table
b Add firmware support with API versioning
c Reuse most of the 8366 code
d Make 8764 specific changes where 8764 differs
  from 8366 e.g. structure definitions.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 78 +++++++++++++++++++++++++-------------------
 1 file changed, 45 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 091d9a6..e86a31b 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -908,9 +908,9 @@ static void mwl8k_encapsulate_tx_frame(struct mwl8k_priv *priv,
 }
 
 /*
- * Packet reception for 88w8366 AP firmware.
+ * Packet reception for 88w8366/88w8764 AP firmware.
  */
-struct mwl8k_rxd_8366_ap {
+struct mwl8k_rxd_ap {
 	__le16 pkt_len;
 	__u8 sq2;
 	__u8 rate;
@@ -928,30 +928,30 @@ struct mwl8k_rxd_8366_ap {
 	__u8 rx_ctrl;
 } __packed;
 
-#define MWL8K_8366_AP_RATE_INFO_MCS_FORMAT	0x80
-#define MWL8K_8366_AP_RATE_INFO_40MHZ		0x40
-#define MWL8K_8366_AP_RATE_INFO_RATEID(x)	((x) & 0x3f)
+#define MWL8K_AP_RATE_INFO_MCS_FORMAT		0x80
+#define MWL8K_AP_RATE_INFO_40MHZ		0x40
+#define MWL8K_AP_RATE_INFO_RATEID(x)		((x) & 0x3f)
 
-#define MWL8K_8366_AP_RX_CTRL_OWNED_BY_HOST	0x80
+#define MWL8K_AP_RX_CTRL_OWNED_BY_HOST		0x80
 
-/* 8366 AP rx_status bits */
-#define MWL8K_8366_AP_RXSTAT_DECRYPT_ERR_MASK		0x80
-#define MWL8K_8366_AP_RXSTAT_GENERAL_DECRYPT_ERR	0xFF
-#define MWL8K_8366_AP_RXSTAT_TKIP_DECRYPT_MIC_ERR	0x02
-#define MWL8K_8366_AP_RXSTAT_WEP_DECRYPT_ICV_ERR	0x04
-#define MWL8K_8366_AP_RXSTAT_TKIP_DECRYPT_ICV_ERR	0x08
+/* 8366/8764 AP rx_status bits */
+#define MWL8K_AP_RXSTAT_DECRYPT_ERR_MASK		0x80
+#define MWL8K_AP_RXSTAT_GENERAL_DECRYPT_ERR		0xFF
+#define MWL8K_AP_RXSTAT_TKIP_DECRYPT_MIC_ERR		0x02
+#define MWL8K_AP_RXSTAT_WEP_DECRYPT_ICV_ERR		0x04
+#define MWL8K_AP_RXSTAT_TKIP_DECRYPT_ICV_ERR		0x08
 
-static void mwl8k_rxd_8366_ap_init(void *_rxd, dma_addr_t next_dma_addr)
+static void mwl8k_rxd_ap_init(void *_rxd, dma_addr_t next_dma_addr)
 {
-	struct mwl8k_rxd_8366_ap *rxd = _rxd;
+	struct mwl8k_rxd_ap *rxd = _rxd;
 
 	rxd->next_rxd_phys_addr = cpu_to_le32(next_dma_addr);
-	rxd->rx_ctrl = MWL8K_8366_AP_RX_CTRL_OWNED_BY_HOST;
+	rxd->rx_ctrl = MWL8K_AP_RX_CTRL_OWNED_BY_HOST;
 }
 
-static void mwl8k_rxd_8366_ap_refill(void *_rxd, dma_addr_t addr, int len)
+static void mwl8k_rxd_ap_refill(void *_rxd, dma_addr_t addr, int len)
 {
-	struct mwl8k_rxd_8366_ap *rxd = _rxd;
+	struct mwl8k_rxd_ap *rxd = _rxd;
 
 	rxd->pkt_len = cpu_to_le16(len);
 	rxd->pkt_phys_addr = cpu_to_le32(addr);
@@ -960,12 +960,12 @@ static void mwl8k_rxd_8366_ap_refill(void *_rxd, dma_addr_t addr, int len)
 }
 
 static int
-mwl8k_rxd_8366_ap_process(void *_rxd, struct ieee80211_rx_status *status,
-			  __le16 *qos, s8 *noise)
+mwl8k_rxd_ap_process(void *_rxd, struct ieee80211_rx_status *status,
+		     __le16 *qos, s8 *noise)
 {
-	struct mwl8k_rxd_8366_ap *rxd = _rxd;
+	struct mwl8k_rxd_ap *rxd = _rxd;
 
-	if (!(rxd->rx_ctrl & MWL8K_8366_AP_RX_CTRL_OWNED_BY_HOST))
+	if (!(rxd->rx_ctrl & MWL8K_AP_RX_CTRL_OWNED_BY_HOST))
 		return -1;
 	rmb();
 
@@ -974,11 +974,11 @@ mwl8k_rxd_8366_ap_process(void *_rxd, struct ieee80211_rx_status *status,
 	status->signal = -rxd->rssi;
 	*noise = -rxd->noise_floor;
 
-	if (rxd->rate & MWL8K_8366_AP_RATE_INFO_MCS_FORMAT) {
+	if (rxd->rate & MWL8K_AP_RATE_INFO_MCS_FORMAT) {
 		status->flag |= RX_FLAG_HT;
-		if (rxd->rate & MWL8K_8366_AP_RATE_INFO_40MHZ)
+		if (rxd->rate & MWL8K_AP_RATE_INFO_40MHZ)
 			status->flag |= RX_FLAG_40MHZ;
-		status->rate_idx = MWL8K_8366_AP_RATE_INFO_RATEID(rxd->rate);
+		status->rate_idx = MWL8K_AP_RATE_INFO_RATEID(rxd->rate);
 	} else {
 		int i;
 
@@ -1002,19 +1002,19 @@ mwl8k_rxd_8366_ap_process(void *_rxd, struct ieee80211_rx_status *status,
 
 	*qos = rxd->qos_control;
 
-	if ((rxd->rx_status != MWL8K_8366_AP_RXSTAT_GENERAL_DECRYPT_ERR) &&
-	    (rxd->rx_status & MWL8K_8366_AP_RXSTAT_DECRYPT_ERR_MASK) &&
-	    (rxd->rx_status & MWL8K_8366_AP_RXSTAT_TKIP_DECRYPT_MIC_ERR))
+	if ((rxd->rx_status != MWL8K_AP_RXSTAT_GENERAL_DECRYPT_ERR) &&
+	    (rxd->rx_status & MWL8K_AP_RXSTAT_DECRYPT_ERR_MASK) &&
+	    (rxd->rx_status & MWL8K_AP_RXSTAT_TKIP_DECRYPT_MIC_ERR))
 		status->flag |= RX_FLAG_MMIC_ERROR;
 
 	return le16_to_cpu(rxd->pkt_len);
 }
 
-static struct rxd_ops rxd_8366_ap_ops = {
-	.rxd_size	= sizeof(struct mwl8k_rxd_8366_ap),
-	.rxd_init	= mwl8k_rxd_8366_ap_init,
-	.rxd_refill	= mwl8k_rxd_8366_ap_refill,
-	.rxd_process	= mwl8k_rxd_8366_ap_process,
+static struct rxd_ops rxd_ap_ops = {
+	.rxd_size	= sizeof(struct mwl8k_rxd_ap),
+	.rxd_init	= mwl8k_rxd_ap_init,
+	.rxd_refill	= mwl8k_rxd_ap_refill,
+	.rxd_process	= mwl8k_rxd_ap_process,
 };
 
 /*
@@ -5429,12 +5429,17 @@ enum {
 	MWL8363 = 0,
 	MWL8687,
 	MWL8366,
+	MWL8764,
 };
 
 #define MWL8K_8366_AP_FW_API 3
 #define _MWL8K_8366_AP_FW(api) "mwl8k/fmimage_8366_ap-" #api ".fw"
 #define MWL8K_8366_AP_FW(api) _MWL8K_8366_AP_FW(api)
 
+#define MWL8K_8764_AP_FW_API 1
+#define _MWL8K_8764_AP_FW(api) "mwl8k/fmimage_8764_ap-" #api ".fw"
+#define MWL8K_8764_AP_FW(api) _MWL8K_8764_AP_FW(api)
+
 static struct mwl8k_device_info mwl8k_info_tbl[] = {
 	[MWL8363] = {
 		.part_name	= "88w8363",
@@ -5452,7 +5457,13 @@ static struct mwl8k_device_info mwl8k_info_tbl[] = {
 		.fw_image_sta	= "mwl8k/fmimage_8366.fw",
 		.fw_image_ap	= MWL8K_8366_AP_FW(MWL8K_8366_AP_FW_API),
 		.fw_api_ap	= MWL8K_8366_AP_FW_API,
-		.ap_rxd_ops	= &rxd_8366_ap_ops,
+		.ap_rxd_ops	= &rxd_ap_ops,
+	},
+	[MWL8764] = {
+		.part_name	= "88w8764",
+		.fw_image_ap	= MWL8K_8764_AP_FW(MWL8K_8764_AP_FW_API),
+		.fw_api_ap	= MWL8K_8764_AP_FW_API,
+		.ap_rxd_ops	= &rxd_ap_ops,
 	},
 };
 
@@ -5474,6 +5485,7 @@ static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
 	{ PCI_VDEVICE(MARVELL, 0x2a41), .driver_data = MWL8366, },
 	{ PCI_VDEVICE(MARVELL, 0x2a42), .driver_data = MWL8366, },
 	{ PCI_VDEVICE(MARVELL, 0x2a43), .driver_data = MWL8366, },
+	{ PCI_VDEVICE(MARVELL, 0x2b36), .driver_data = MWL8764, },
 	{ },
 };
 MODULE_DEVICE_TABLE(pci, mwl8k_pci_id_table);
-- 
1.8.0.3

