Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:47782 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369AbaCZT65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 15:58:57 -0400
Received: by mail-ee0-f44.google.com with SMTP id e49so2068439eek.31
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 12:58:56 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 06/20] rtl8180: add ISR for rtl8187se
Date: Wed, 26 Mar 2014 21:00:06 +0100
Message-Id: <1395864006-4575-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_205906_022275_D035A55B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl8187se has more queues and different ISR flags.
This patch adds a separated ISR handler for rtl8187se

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 57 +++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 867ec07..242a4bc 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -264,6 +264,55 @@ static void rtl8180_handle_tx(struct ieee80211_hw *dev, unsigned int prio)
 	}
 }
 
+static irqreturn_t rtl8187se_interrupt(int irq, void *dev_id)
+{
+	struct ieee80211_hw *dev = dev_id;
+	struct rtl8180_priv *priv = dev->priv;
+	u32 reg;
+	unsigned long flags;
+	static int desc_err;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	/* Note: 32-bit interrupt status */
+	reg = rtl818x_ioread32(priv, &priv->map->INT_STATUS_SE);
+	if (unlikely(reg == 0xFFFFFFFF)) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return IRQ_HANDLED;
+	}
+
+	rtl818x_iowrite32(priv, &priv->map->INT_STATUS_SE, reg);
+
+	if (reg & IMR_TIMEOUT1)
+		rtl818x_iowrite32(priv, &priv->map->INT_TIMEOUT, 0);
+
+	if (reg & (IMR_TBDOK | IMR_TBDER))
+		rtl8180_handle_tx(dev, 4);
+
+	if (reg & (IMR_TVODOK | IMR_TVODER))
+		rtl8180_handle_tx(dev, 0);
+
+	if (reg & (IMR_TVIDOK | IMR_TVIDER))
+		rtl8180_handle_tx(dev, 1);
+
+	if (reg & (IMR_TBEDOK | IMR_TBEDER))
+		rtl8180_handle_tx(dev, 2);
+
+	if (reg & (IMR_TBKDOK | IMR_TBKDER))
+		rtl8180_handle_tx(dev, 3);
+
+	if (reg & (IMR_ROK | IMR_RER | RTL818X_INT_SE_RX_DU | IMR_RQOSOK))
+		rtl8180_handle_rx(dev);
+	/* The interface sometimes generates several RX DMA descriptor errors
+	 * at startup. Do not report these.
+	 */
+	if ((reg & RTL818X_INT_SE_RX_DU) && desc_err++ > 2)
+		if (net_ratelimit())
+			wiphy_err(dev->wiphy, "No RX DMA Descriptor avail\n");
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t rtl8180_interrupt(int irq, void *dev_id)
 {
 	struct ieee80211_hw *dev = dev_id;
@@ -685,8 +734,14 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 	if (ret)
 		goto err_free_rings;
 
-	ret = request_irq(priv->pdev->irq, rtl8180_interrupt,
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
+		ret = request_irq(priv->pdev->irq, rtl8187se_interrupt,
 			  IRQF_SHARED, KBUILD_MODNAME, dev);
+	} else {
+		ret = request_irq(priv->pdev->irq, rtl8180_interrupt,
+			  IRQF_SHARED, KBUILD_MODNAME, dev);
+	}
+
 	if (ret) {
 		wiphy_err(dev->wiphy, "failed to register IRQ handler\n");
 		goto err_free_rings;
-- 
1.8.3.2

