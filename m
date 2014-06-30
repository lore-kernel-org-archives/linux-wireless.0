Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:63086 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaF3QTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2014 12:19:38 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so8311070wes.41
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2014 09:19:37 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 6/7] rtl818x_pci: handle broken PIO mapping
Date: Mon, 30 Jun 2014 18:19:27 +0200
Message-Id: <1404145167-16207-1-git-send-email-andrea.merello@gmail.com> (sfid-20140630_181942_201657_09F0140D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All boards supported by this driver could work using PIO or MMIO for accessing
registers.
This driver tries to access HW by using MMIO, and, if this fails for somewhat
reason, the driver tries to fall back to PIO mode.

MMIO-mode is straightforward on all boards.
PIO-mode is straightforward on rtl8180 only.

On rtl8185 and rtl8187se boards not all registers are directly available in PIO
mode (they are paged).

On rtl8185 there are two pages and it is known how to switch page.
PIO mode works, except for only one access to a register out of default page,
recently added by me in the initialization code with patch:
rtl818x_pci: Fix rtl8185 excessive IFS after CTS-to-self
This can be easily fixed to work in both cases (MMIO and PIO).

On rtl8187se, for a number of reasons, there is much more work to do to fix PIO
access.
PIO access is currently broken on rtl8187se, and it never worked.

This patch fixes the said register write for rtl8185 and makes the driver to
fail cleanly if PIO mode is attempted with rtl8187se boards.

While doing this, I converted also a couple of printk(KERN_ERR) to dev_err(), in
order to make checkpatch happy.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c     | 24 ++++++++++++++++++++----
 drivers/net/wireless/rtl818x/rtl8180/rtl8180.h |  1 +
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 5303b8f..68304a9 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -878,7 +878,15 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 		rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | (1 << 2));
 		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 		/* fix eccessive IFS after CTS-to-self */
-		rtl818x_iowrite8(priv, REG_ADDR1(0x1ff), 0x35);
+		if (priv->map_pio) {
+			u8 reg;
+
+			reg = rtl818x_ioread8(priv, &priv->map->PGSELECT);
+			rtl818x_iowrite8(priv, &priv->map->PGSELECT, reg | 1);
+			rtl818x_iowrite8(priv, REG_ADDR1(0xff), 0x35);
+			rtl818x_iowrite8(priv, &priv->map->PGSELECT, reg);
+		} else
+			rtl818x_iowrite8(priv, REG_ADDR1(0x1ff), 0x35);
 	}
 
 	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
@@ -1739,13 +1747,15 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	SET_IEEE80211_DEV(dev, &pdev->dev);
 	pci_set_drvdata(pdev, dev);
 
+	priv->map_pio = false;
 	priv->map = pci_iomap(pdev, 1, mem_len);
-	if (!priv->map)
+	if (!priv->map) {
 		priv->map = pci_iomap(pdev, 0, io_len);
+		priv->map_pio = true;
+	}
 
 	if (!priv->map) {
-		printk(KERN_ERR "%s (rtl8180): Cannot map device memory\n",
-		       pci_name(pdev));
+		dev_err(&pdev->dev, "Cannot map device memory/PIO\n");
 		goto err_free_dev;
 	}
 
@@ -1794,6 +1804,12 @@ static int rtl8180_probe(struct pci_dev *pdev,
 
 	case RTL818X_TX_CONF_RTL8187SE:
 		chip_name = "RTL8187SE";
+		if (priv->map_pio) {
+			dev_err(&pdev->dev,
+				"MMIO failed. PIO not supported on RTL8187SE\n");
+			err = -ENOMEM;
+			goto err_iounmap;
+		}
 		priv->chip_family = RTL818X_CHIP_FAMILY_RTL8187SE;
 		break;
 
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
index 291a559..e8243a4 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
+++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
@@ -107,6 +107,7 @@ struct rtl8180_priv {
 	struct ieee80211_vif *vif;
 
 	/* rtl8180 driver specific */
+	bool map_pio;
 	spinlock_t lock;
 	void *rx_ring;
 	u8 rx_ring_sz;
-- 
1.9.1

