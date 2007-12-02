Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:53426 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750718AbXLBWLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2007 17:11:13 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 3/8] rtl818x: update register struct
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Sun, 02 Dec 2007 17:17:51 -0500
Message-ID: <20071202221751.7347.52982.stgit@tetra.sourmilk.net> (sfid-20071202_221121_748676_0A4541D8)
In-Reply-To: <20071202221751.7347.54891.stgit@tetra.sourmilk.net>
References: <20071202221751.7347.54891.stgit@tetra.sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrea Merello <andreamrl@tiscali.it>

Add the SECURITY and CARRIER_SENSE_COUNTER registers.
Change PGSELECT length from 16 to 8 bits.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Andrea Merello <andreamrl@tiscali.it>
---

 drivers/net/wireless/rtl8187_dev.c |   12 ++++++------
 drivers/net/wireless/rtl818x.h     |    6 ++++--
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
index e454ae8..859235f 100644
--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -393,12 +393,12 @@ static int rtl8187_init_hw(struct ieee80211_hw *dev)
 	priv->rf_init(dev);
 
 	rtl818x_iowrite16(priv, &priv->map->BRSR, 0x01F3);
-	reg = rtl818x_ioread16(priv, &priv->map->PGSELECT) & 0xfffe;
-	rtl818x_iowrite16(priv, &priv->map->PGSELECT, reg | 0x1);
+	reg = rtl818x_ioread8(priv, &priv->map->PGSELECT) & ~1;
+	rtl818x_iowrite8(priv, &priv->map->PGSELECT, reg | 1);
 	rtl818x_iowrite16(priv, (__le16 *)0xFFFE, 0x10);
 	rtl818x_iowrite8(priv, &priv->map->TALLY_SEL, 0x80);
 	rtl818x_iowrite8(priv, (u8 *)0xFFFF, 0x60);
-	rtl818x_iowrite16(priv, &priv->map->PGSELECT, reg);
+	rtl818x_iowrite8(priv, &priv->map->PGSELECT, reg);
 
 	return 0;
 }
@@ -750,13 +750,13 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	eeprom_93cx6_read(&eeprom, RTL8187_EEPROM_TXPWR_BASE,
 			  &priv->txpwr_base);
 
-	reg = rtl818x_ioread16(priv, &priv->map->PGSELECT) & ~1;
-	rtl818x_iowrite16(priv, &priv->map->PGSELECT, reg | 1);
+	reg = rtl818x_ioread8(priv, &priv->map->PGSELECT) & ~1;
+	rtl818x_iowrite8(priv, &priv->map->PGSELECT, reg | 1);
 	/* 0 means asic B-cut, we should use SW 3 wire
 	 * bit-by-bit banging for radio. 1 means we can use
 	 * USB specific request to write radio registers */
 	priv->asic_rev = rtl818x_ioread8(priv, (u8 *)0xFFFE) & 0x3;
-	rtl818x_iowrite16(priv, &priv->map->PGSELECT, reg);
+	rtl818x_iowrite8(priv, &priv->map->PGSELECT, reg);
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 
 	rtl8225_write(dev, 0, 0x1B7);
diff --git a/drivers/net/wireless/rtl818x.h b/drivers/net/wireless/rtl818x.h
index 99b8b1b..1322f6a 100644
--- a/drivers/net/wireless/rtl818x.h
+++ b/drivers/net/wireless/rtl818x.h
@@ -113,14 +113,16 @@ struct rtl818x_csr {
 #define RTL818X_CONFIG4_VCOOFF		(1 << 7)
 	u8	TESTR;
 	u8	reserved_9[2];
-	__le16	PGSELECT;
+	u8	PGSELECT;
+	u8	SECURITY;
 	__le32	ANAPARAM2;
 	u8	reserved_10[12];
 	__le16	BEACON_INTERVAL;
 	__le16	ATIM_WND;
 	__le16	BEACON_INTERVAL_TIME;
 	__le16	ATIMTR_INTERVAL;
-	__le16	PHY_DELAY;
+	u8	PHY_DELAY;
+	u8	CARRIER_SENSE_COUNTER;
 	u8	reserved_11[2];
 	u8	PHY[4];
 	__le16	RFPinsOutput;


