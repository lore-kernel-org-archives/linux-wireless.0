Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39929 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbbAYNjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 08:39:46 -0500
Received: by mail-wi0-f171.google.com with SMTP id l15so5233195wiw.4
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2015 05:39:45 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: support bcma core reset on AC-PHY hardware
Date: Sun, 25 Jan 2015 14:39:34 +0100
Message-Id: <1422193174-16908-1-git-send-email-zajec5@gmail.com> (sfid-20150125_143950_310587_A8E1688E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AC-PHY hardware includes new control 0x3 bits that need to be set to the
0x1 by default.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/b43.h  |  2 ++
 drivers/net/wireless/b43/main.c | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index bb12586..ed403ed 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -500,6 +500,8 @@ enum {
 #define  B43_BCMA_IOCTL_PHY_BW_10MHZ	0x00000000	/* 10 MHz bandwidth, 40 MHz PHY */
 #define  B43_BCMA_IOCTL_PHY_BW_20MHZ	0x00000040	/* 20 MHz bandwidth, 80 MHz PHY */
 #define  B43_BCMA_IOCTL_PHY_BW_40MHZ	0x00000080	/* 40 MHz bandwidth, 160 MHz PHY */
+#define  B43_BCMA_IOCTL_PHY_BW_80MHZ	0x000000C0	/* 80 MHz bandwidth */
+#define B43_BCMA_IOCTL_DAC		0x00000300	/* Highspeed DAC mode control field */
 #define B43_BCMA_IOCTL_GMODE		0x00002000	/* G Mode Enable */
 
 /* BCMA 802.11 core specific IO status (BCMA_IOST) flags */
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 58a2e88..753e9b0 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1262,6 +1262,23 @@ static void b43_bcma_wireless_core_reset(struct b43_wldev *dev, bool gmode)
 		flags |= B43_BCMA_IOCTL_GMODE;
 	b43_device_enable(dev, flags);
 
+	if (dev->phy.type == B43_PHYTYPE_AC) {
+		u16 tmp;
+
+		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOCTL);
+		tmp &= ~B43_BCMA_IOCTL_DAC;
+		tmp |= 0x100;
+		bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, tmp);
+
+		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOCTL);
+		tmp &= ~B43_BCMA_IOCTL_PHY_CLKEN;
+		bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, tmp);
+
+		tmp = bcma_aread32(dev->dev->bdev, BCMA_IOCTL);
+		tmp |= B43_BCMA_IOCTL_PHY_CLKEN;
+		bcma_awrite32(dev->dev->bdev, BCMA_IOCTL, tmp);
+	}
+
 	bcma_core_set_clockmode(dev->dev->bdev, BCMA_CLKMODE_FAST);
 	b43_bcma_phy_reset(dev);
 	bcma_core_pll_ctl(dev->dev->bdev, req, status, true);
-- 
1.8.4.5

