Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:52213 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbaBEVhu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 16:37:50 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so503939eei.7
        for <linux-wireless@vger.kernel.org>; Wed, 05 Feb 2014 13:37:48 -0800 (PST)
From: andrea merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"andrea.merello" <andrea.merello@gmail.com>
Subject: [PATCH 3/4] Add error check for pci_map_single return value in rtl8180 TX path
Date: Wed,  5 Feb 2014 22:38:06 +0100
Message-Id: <1391636287-17712-4-git-send-email-andrea.merello@gmail.com> (sfid-20140205_223756_210752_373A508B)
In-Reply-To: <1391636287-17712-1-git-send-email-andrea.merello@gmail.com>
References: <1391636287-17712-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "andrea.merello" <andrea.merello@gmail.com>

Orignal code will not detect a DMA mapping failure, causing the HW
to attempt a DMA from an invalid address.

This patch add the error check and eventually simply drops the TX
packet if we can't map it for DMA.

Signed-off-by: andrea.merello <andrea.merello@gmail.com>
Signed-off-by: andrea merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 1c6ac25..9645ed2 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -276,6 +276,13 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
 	mapping = pci_map_single(priv->pdev, skb->data,
 				 skb->len, PCI_DMA_TODEVICE);
 
+	if (pci_dma_mapping_error(priv->pdev, mapping)) {
+		kfree_skb(skb);
+		dev_err(&priv->pdev->dev, "TX DMA mapping error\n");
+		return;
+
+	}
+
 	tx_flags = RTL818X_TX_DESC_FLAG_OWN | RTL818X_TX_DESC_FLAG_FS |
 		   RTL818X_TX_DESC_FLAG_LS |
 		   (ieee80211_get_tx_rate(dev, info)->hw_value << 24) |
-- 
1.8.3.2

