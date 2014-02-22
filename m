Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:35731 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaBVQ4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 11:56:52 -0500
Received: by mail-ea0-f180.google.com with SMTP id o10so2212615eaj.39
        for <linux-wireless@vger.kernel.org>; Sat, 22 Feb 2014 08:56:51 -0800 (PST)
From: Andrea Merello <andrea.merello@gmail.com>
To: dan.carpenter@oracle.com, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de,
	andrea merello <andrea.merello@gmail.com>
Subject: [PATCH 3/7 V2] rtl818x: check for pci_map_single() success when initializing RX ring
Date: Sat, 22 Feb 2014 17:57:23 +0100
Message-Id: <1393088243-22740-1-git-send-email-andrea.merello@gmail.com> (sfid-20140222_175702_109464_FBD77EAA)
In-Reply-To: <CAN8YU5OK8MLc0y0NaMJSJLOnh1K2FjLmEQiJ4fGd=Nyi5neUeQ@mail.gmail.com>
References: <CAN8YU5OK8MLc0y0NaMJSJLOnh1K2FjLmEQiJ4fGd=Nyi5neUeQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: andrea merello <andrea.merello@gmail.com>

During initialization a number of RX skbs are allocated and mapped
for DMA.
Currently if pci_map_single() fails, it will result in passing to the
HW a wrong DMA address (to write to!).

This patch adds check for this condition and eventually causes the
driver not to initialize, avoiding at least dangerous DMAs.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index bf59ff9..0102da2 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -483,6 +483,13 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
 		mapping = (dma_addr_t *)skb->cb;
 		*mapping = pci_map_single(priv->pdev, skb_tail_pointer(skb),
 					  MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
+
+		if (pci_dma_mapping_error(priv->pdev, *mapping)) {
+			kfree_skb(skb);
+			wiphy_err(dev->wiphy, "Cannot map DMA for RX skb\n");
+			return -ENOMEM;
+		}
+
 		entry->rx_buf = cpu_to_le32(*mapping);
 		entry->flags = cpu_to_le32(RTL818X_RX_DESC_FLAG_OWN |
 					   MAX_RX_SIZE);
-- 
1.8.3.2

