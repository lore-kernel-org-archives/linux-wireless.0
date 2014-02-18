Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:58130 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaBRBKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 20:10:38 -0500
Received: by mail-ea0-f170.google.com with SMTP id g15so5779627eak.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 17:10:37 -0800 (PST)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	liuhq11@mails.tsinghua.edu.cn,
	andrea merello <andrea.merello@gmail.com>
Subject: [PATCH 3/7] rtl818x: check for pci_map_single() success when initializing RX ring
Date: Tue, 18 Feb 2014 02:10:42 +0100
Message-Id: <1392685846-10116-4-git-send-email-andrea.merello@gmail.com> (sfid-20140218_021043_051927_A2BBACFF)
In-Reply-To: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
References: <1392685846-10116-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: andrea merello <andrea.merello@gmail.com>

During initialization a number of RX skbs are allocated and mapped
for DMA.
Currently if pci_map_single() fails, it will result in passing to the
HW a wrong DMA address (to write to!).

This patch detects this condition, eventually it tries to get a more
luky skb, and if it finally fails to get things right, it makes the
driver not to initialize, avoiding at least dangerous DMAs.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index bf59ff9..848ea59 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -458,6 +458,7 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	struct rtl8180_rx_desc *entry;
+	int dma_map_fail_count = 0;
 	int i;
 
 	priv->rx_ring = pci_alloc_consistent(priv->pdev,
@@ -483,6 +484,19 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
 		mapping = (dma_addr_t *)skb->cb;
 		*mapping = pci_map_single(priv->pdev, skb_tail_pointer(skb),
 					  MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+
+		if (pci_dma_mapping_error(priv->pdev, *mapping)) {
+			kfree_skb(skb);
+			if (dma_map_fail_count++ > 32) {
+				wiphy_err(dev->wiphy, "Cannot map DMA for RX skb\n");
+				return -ENOMEM;
+			}
+
+			i--;
+			continue;
+		}
+
+
 		entry->rx_buf = cpu_to_le32(*mapping);
 		entry->flags = cpu_to_le32(RTL818X_RX_DESC_FLAG_OWN |
 					   MAX_RX_SIZE);
-- 
1.8.3.2

