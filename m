Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59616 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZJVSxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 14:53:48 -0400
Date: Thu, 22 Oct 2009 20:21:48 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 28/28] mwl8k: add support for the 88w8366
Message-ID: <20091022182148.GD1583@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for the 88w8366 firmware receive descriptor format,
and add the 88w8366 PCI ID.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   95 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 94 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 8e4631a..40075d4 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -755,7 +755,89 @@ static inline void mwl8k_add_dma_header(struct sk_buff *skb)
 
 
 /*
- * Packet reception.
+ * Packet reception for 88w8366.
+ */
+struct mwl8k_rxd_8366 {
+	__le16 pkt_len;
+	__u8 sq2;
+	__u8 rate;
+	__le32 pkt_phys_addr;
+	__le32 next_rxd_phys_addr;
+	__le16 qos_control;
+	__le16 htsig2;
+	__le32 hw_rssi_info;
+	__le32 hw_noise_floor_info;
+	__u8 noise_floor;
+	__u8 pad0[3];
+	__u8 rssi;
+	__u8 rx_status;
+	__u8 channel;
+	__u8 rx_ctrl;
+} __attribute__((packed));
+
+#define MWL8K_8366_RX_CTRL_OWNED_BY_HOST	0x80
+
+static void mwl8k_rxd_8366_init(void *_rxd, dma_addr_t next_dma_addr)
+{
+	struct mwl8k_rxd_8366 *rxd = _rxd;
+
+	rxd->next_rxd_phys_addr = cpu_to_le32(next_dma_addr);
+	rxd->rx_ctrl = MWL8K_8366_RX_CTRL_OWNED_BY_HOST;
+}
+
+static void mwl8k_rxd_8366_refill(void *_rxd, dma_addr_t addr, int len)
+{
+	struct mwl8k_rxd_8366 *rxd = _rxd;
+
+	rxd->pkt_len = cpu_to_le16(len);
+	rxd->pkt_phys_addr = cpu_to_le32(addr);
+	wmb();
+	rxd->rx_ctrl = 0;
+}
+
+static int
+mwl8k_rxd_8366_process(void *_rxd, struct ieee80211_rx_status *status)
+{
+	struct mwl8k_rxd_8366 *rxd = _rxd;
+
+	if (!(rxd->rx_ctrl & MWL8K_8366_RX_CTRL_OWNED_BY_HOST))
+		return -1;
+	rmb();
+
+	memset(status, 0, sizeof(*status));
+
+	status->signal = -rxd->rssi;
+	status->noise = -rxd->noise_floor;
+
+	if (rxd->rate & 0x80) {
+		status->flag |= RX_FLAG_HT;
+		status->rate_idx = rxd->rate & 0x7f;
+	} else {
+		int i;
+
+		for (i = 0; i < ARRAY_SIZE(mwl8k_rates); i++) {
+			if (mwl8k_rates[i].hw_value == rxd->rate) {
+				status->rate_idx = i;
+				break;
+			}
+		}
+	}
+
+	status->band = IEEE80211_BAND_2GHZ;
+	status->freq = ieee80211_channel_to_frequency(rxd->channel);
+
+	return le16_to_cpu(rxd->pkt_len);
+}
+
+static struct rxd_ops rxd_8366_ops = {
+	.rxd_size	= sizeof(struct mwl8k_rxd_8366),
+	.rxd_init	= mwl8k_rxd_8366_init,
+	.rxd_refill	= mwl8k_rxd_8366_refill,
+	.rxd_process	= mwl8k_rxd_8366_process,
+};
+
+/*
+ * Packet reception for 88w8687.
  */
 struct mwl8k_rxd_8687 {
 	__le16 pkt_len;
@@ -3225,6 +3307,14 @@ static void mwl8k_finalize_join_worker(struct work_struct *work)
 	priv->beacon_skb = NULL;
 }
 
+static struct mwl8k_device_info di_8366 = {
+	.part_name	= "88w8366",
+	.helper_image	= "mwl8k/helper_8366.fw",
+	.fw_image	= "mwl8k/fmimage_8366.fw",
+	.rxd_ops	= &rxd_8366_ops,
+	.modes		= 0,
+};
+
 static struct mwl8k_device_info di_8687 = {
 	.part_name	= "88w8687",
 	.helper_image	= "mwl8k/helper_8687.fw",
@@ -3241,6 +3331,9 @@ static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
 		PCI_VDEVICE(MARVELL, 0x2a30),
 		.driver_data = (unsigned long)&di_8687,
 	}, {
+		PCI_VDEVICE(MARVELL, 0x2a40),
+		.driver_data = (unsigned long)&di_8366,
+	}, {
 	},
 };
 MODULE_DEVICE_TABLE(pci, mwl8k_pci_id_table);
-- 
1.5.6.4
