Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:32867 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750852AbXLSGRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 01:17:16 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 1/6] rtl8180: Initialize RF 3-wire registers before trying to
	identify RF version
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Wed, 19 Dec 2007 01:17:35 -0500
Message-ID: <20071219061735.4885.1535.stgit@tetra.sourmilk.net> (sfid-20071219_061720_215768_957B98B3)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrea Merello <andreamrl@tiscali.it>

The RF version can be identified by writing and reading some RF chip
registers.
However 3-wire registers are initialized in the RF initialization
function, that is different for radio V1 and V2.
This caused write to RF chip with unitialized 3-wire bus, causing
sometimes malfunctions in following RF initialization code.
This patch add 3-wire bus registers initialization in the RF
identification function.

Signed-off-by: Andrea Merello <andreamrl@tiscali.it>
Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8180_rtl8225.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl8180_rtl8225.c b/drivers/net/wireless/rtl8180_rtl8225.c
index 3bcdb9e..1c4fd33 100644
--- a/drivers/net/wireless/rtl8180_rtl8225.c
+++ b/drivers/net/wireless/rtl8180_rtl8225.c
@@ -305,10 +305,16 @@ static void rtl8225_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
 
 int rtl8225_is_z2(struct ieee80211_hw *dev)
 {
+	struct rtl8180_priv *priv = dev->priv;
 	int z2 = 0;
 
+	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
+	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x0488);
+	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
+	rtl818x_ioread8(priv, &priv->map->EEPROM_CMD);
+	msleep(100);
+	
 	rtl8225_write(dev, 0, 0x1B7);
-	rtl8225_read(dev, 0);
 
 	if (rtl8225_read(dev, 8) == 0x588 && rtl8225_read(dev, 9) == 0x700)
 		z2 = 1;


