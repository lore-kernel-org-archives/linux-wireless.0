Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:39660 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750962AbXLBWLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2007 17:11:14 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 5/8] rtl8180: Add full support for rtl8180
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Sun, 02 Dec 2007 17:17:51 -0500
Message-ID: <20071202221751.7347.28831.stgit@tetra.sourmilk.net> (sfid-20071202_221123_519431_D9742F5B)
In-Reply-To: <20071202221751.7347.54891.stgit@tetra.sourmilk.net>
References: <20071202221751.7347.54891.stgit@tetra.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrea Merello <andreamrl@tiscali.it>

This patch makes the driver fully support the rtl8180 mac. However, no
radio tuning is added so this won't work without patches adding support
for specific radios.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Andrea Merello <andreamrl@tiscali.it>
---

 drivers/net/wireless/rtl8180.h     |   16 +++++++++++++++-
 drivers/net/wireless/rtl8180_dev.c |   26 ++++++++++++++++++++------
 2 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rtl8180.h b/drivers/net/wireless/rtl8180.h
index 28431ac..8051054 100644
--- a/drivers/net/wireless/rtl8180.h
+++ b/drivers/net/wireless/rtl8180.h
@@ -5,11 +5,25 @@
 
 #define MAX_RX_SIZE IEEE80211_MAX_RTS_THRESHOLD
 
-#define RF_PARAM_DIGPHY		(1 << 0)
+#define RF_PARAM_ANALOGPHY	(1 << 0)
 #define RF_PARAM_ANTBDEFAULT	(1 << 1)
 #define RF_PARAM_CARRIERSENSE1	(1 << 2)
 #define RF_PARAM_CARRIERSENSE2	(1 << 3)
 
+#define BB_ANTATTEN_CHAN14	0x0C
+#define BB_ANTENNA_B 		0x40
+
+#define BB_HOST_BANG 		(1 << 30)
+#define BB_HOST_BANG_EN 	(1 << 2)
+#define BB_HOST_BANG_CLK 	(1 << 1)
+#define BB_HOST_BANG_DATA	1
+
+#define ANAPARAM_TXDACOFF_SHIFT	27
+#define ANAPARAM_PWR0_SHIFT	28
+#define ANAPARAM_PWR0_MASK 	(0x07 << ANAPARAM_PWR0_SHIFT)
+#define ANAPARAM_PWR1_SHIFT	20
+#define ANAPARAM_PWR1_MASK	(0x7F << ANAPARAM_PWR1_SHIFT)
+
 enum rtl8180_tx_desc_flags {
 	RTL8180_TX_DESC_FLAG_NO_ENC	= (1 << 15),
 	RTL8180_TX_DESC_FLAG_TX_OK	= (1 << 15),
diff --git a/drivers/net/wireless/rtl8180_dev.c b/drivers/net/wireless/rtl8180_dev.c
index 54f9c31..7508eee 100644
--- a/drivers/net/wireless/rtl8180_dev.c
+++ b/drivers/net/wireless/rtl8180_dev.c
@@ -223,10 +223,21 @@ static int rtl8180_tx(struct ieee80211_hw *dev, struct sk_buff *skb,
 	spin_lock_irqsave(&priv->lock, flags);
 	idx = (ring->idx + skb_queue_len(&ring->queue)) % ring->entries;
 	entry = &ring->desc[idx];
-	/* TODO: calculate PLCP length - needed for rtl8180 */
+
 	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
 		entry->rts_duration =
 			ieee80211_rts_duration(dev, priv->if_id, skb->len, control);
+
+	if (!priv->r8185) {
+		unsigned int remainder;
+
+		entry->plcp_len =
+			DIV_ROUND_UP(16 * (skb->len + 4), (control->rate->rate * 2) / 10);
+		remainder = (16 * (skb->len + 4)) % ((control->rate->rate * 2) / 10);
+		if (remainder > 0 && remainder <= 6)
+			entry->plcp_len |= 1 << 15;
+	}
+
 	entry->tx_buf = cpu_to_le32(mapping);
 	entry->frame_len = cpu_to_le32(skb->len);
 	entry->flags2 = control->alt_retry_rate != -1 ?
@@ -328,12 +339,9 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 		rtl818x_iowrite8(priv, &priv->map->WPA_CONF, 0);
 		rtl818x_iowrite8(priv, &priv->map->RATE_FALLBACK, 0x81);
 		rtl818x_iowrite8(priv, &priv->map->RESP_RATE, (8 << 4) | 0);
-	}
 
-	/* TODO: fix for rtl8180 */
-	rtl818x_iowrite16(priv, &priv->map->BRSR, 0x01F3);
+		rtl818x_iowrite16(priv, &priv->map->BRSR, 0x01F3);
 
-	if (priv->r8185) {
 		/* TODO: set ClkRun enable? necessary? */
 		reg = rtl818x_ioread8(priv, &priv->map->GP_ENABLE);
 		rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, reg & ~(1 << 6));
@@ -341,6 +349,12 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 		reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
 		rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | (1 << 2));
 		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
+	} else {
+		rtl818x_iowrite16(priv, &priv->map->BRSR, 0x1);
+		rtl818x_iowrite8(priv, &priv->map->SECURITY, 0);
+
+		rtl818x_iowrite8(priv, &priv->map->PHY_DELAY, 0x6);
+		rtl818x_iowrite8(priv, &priv->map->CARRIER_SENSE_COUNTER, 0x4C);
 	}
 
 	priv->rf_init(dev);
@@ -901,13 +915,13 @@ static int __devinit rtl8180_probe(struct pci_dev *pdev,
 		goto err_iounmap;
 	}
 
-	eeprom_93cx6_read(&eeprom, 0x19, &priv->rfparam);
 	eeprom_93cx6_read(&eeprom, 0x17, &eeprom_val);
 	priv->csthreshold = eeprom_val >> 8;
 	if (!priv->r8185) {
 		__le32 anaparam;
 		eeprom_93cx6_multiread(&eeprom, 0xD, (__le16 *)&anaparam, 2);
 		priv->anaparam = le32_to_cpu(anaparam);
+		eeprom_93cx6_read(&eeprom, 0x19, &priv->rfparam);
 	}
 
 	eeprom_93cx6_multiread(&eeprom, 0x7, (__le16 *)dev->wiphy->perm_addr, 3);


