Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:62343 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaCZUAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2014 16:00:38 -0400
Received: by mail-ee0-f42.google.com with SMTP id d17so2080528eek.29
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2014 13:00:37 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: andrea.merello@gmail.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, bernhard@schiffner-limbach.de,
	dan.carpenter@oracle.com
Subject: [PATCH 11/20] rtl8180: add rtl8187se params to eeprom reading
Date: Wed, 26 Mar 2014 21:01:47 +0100
Message-Id: <1395864107-4786-1-git-send-email-andrea.merello@gmail.com> (sfid-20140326_210047_136474_46DA04AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl8187se nees extra parameters to be read from the eeprom.
This patch adds support for it

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c     | 18 +++++++++++++++++-
 drivers/net/wireless/rtl818x/rtl8180/rtl8180.h |  7 +++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 06d3c30..740a583 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -1320,7 +1320,10 @@ static void rtl8180_eeprom_read(struct rtl8180_priv *priv)
 
 	eeprom_93cx6_multiread(&eeprom, 0x7, (__le16 *)priv->mac_addr, 3);
 
-	eeprom_cck_table_adr = 0x10;
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE)
+		eeprom_cck_table_adr = 0x30;
+	else
+		eeprom_cck_table_adr = 0x10;
 
 	/* CCK TX power */
 	for (i = 0; i < 14; i += 2) {
@@ -1348,6 +1351,19 @@ static void rtl8180_eeprom_read(struct rtl8180_priv *priv)
 		eeprom_93cx6_read(&eeprom, 0x19, &priv->rfparam);
 	}
 
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
+		eeprom_93cx6_read(&eeprom, 0x3F, &eeprom_val);
+		priv->antenna_diversity_en = !!(eeprom_val & 0x100);
+		priv->antenna_diversity_default = (eeprom_val & 0xC00) == 0x400;
+
+		eeprom_93cx6_read(&eeprom, 0x7C, &eeprom_val);
+		priv->xtal_out = eeprom_val & 0xF;
+		priv->xtal_in = (eeprom_val & 0xF0) >> 4;
+		priv->xtal_cal = !!(eeprom_val & 0x1000);
+		priv->thermal_meter_val = (eeprom_val & 0xF00) >> 8;
+		priv->thermal_meter_en = !!(eeprom_val & 0x2000);
+	}
+
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
 			RTL818X_EEPROM_CMD_NORMAL);
 }
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
index d64e75d..d8f92de 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
+++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
@@ -132,6 +132,13 @@ struct rtl8180_priv {
 	u8 csthreshold;
 	u8 mac_addr[ETH_ALEN];
 	u8 rf_type;
+	u8 xtal_out;
+	u8 xtal_in;
+	u8 xtal_cal;
+	u8 thermal_meter_val;
+	u8 thermal_meter_en;
+	u8 antenna_diversity_en;
+	u8 antenna_diversity_default;
 	/* sequence # */
 	u16 seqno;
 };
-- 
1.8.3.2

