Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50227 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbaCOR3B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 13:29:01 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so2531254eei.33
        for <linux-wireless@vger.kernel.org>; Sat, 15 Mar 2014 10:29:00 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	andrea.merello@gmail.com
Subject: [PATCH 2/4] rtl8180: support for BSS_CHANGED_BASIC_RATES
Date: Sat, 15 Mar 2014 18:29:36 +0100
Message-Id: <1394904578-5279-3-git-send-email-andrea.merello@gmail.com> (sfid-20140315_182905_847689_AD1822B3)
In-Reply-To: <1394904578-5279-1-git-send-email-andrea.merello@gmail.com>
References: <1394904578-5279-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Basic rates setting is done with hardcoded register write with
fixed settings.

This patch introduces a new function that makes it possible to
configure basic rates and it add a check for mac80211
BSS_CHANGED_BASIC_RATES flag in order to eventually invoke that
function when needed.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 51 ++++++++++++++++++++++++++----
 1 file changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 3c2b784..ede8fee 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -371,6 +371,36 @@ void rtl8180_set_anaparam(struct rtl8180_priv *priv, u32 anaparam)
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 }
 
+static void rtl8180_conf_basic_rates(struct ieee80211_hw *dev,
+			    u32 rates_mask)
+{
+	struct rtl8180_priv *priv = dev->priv;
+
+	u8 max, min;
+	u16 reg;
+
+	max = fls(rates_mask) - 1;
+	min = ffs(rates_mask) - 1;
+
+	switch (priv->chip_family) {
+
+	case RTL818X_CHIP_FAMILY_RTL8180:
+		/* in 8180 this is NOT a BITMAP */
+		reg = rtl818x_ioread16(priv, &priv->map->BRSR);
+		reg &= ~3;
+		reg |= max;
+		rtl818x_iowrite16(priv, &priv->map->BRSR, reg);
+
+		break;
+
+	case RTL818X_CHIP_FAMILY_RTL8185:
+		/* in 8185 this is a BITMAP */
+		rtl818x_iowrite16(priv, &priv->map->BRSR, rates_mask);
+		rtl818x_iowrite8(priv, &priv->map->RESP_RATE, (max << 4) | min);
+		break;
+	}
+}
+
 static int rtl8180_init_hw(struct ieee80211_hw *dev)
 {
 	struct rtl8180_priv *priv = dev->priv;
@@ -441,9 +471,6 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180) {
 		rtl818x_iowrite8(priv, &priv->map->WPA_CONF, 0);
 		rtl818x_iowrite8(priv, &priv->map->RATE_FALLBACK, 0x81);
-		rtl818x_iowrite8(priv, &priv->map->RESP_RATE, (8 << 4) | 0);
-
-		rtl818x_iowrite16(priv, &priv->map->BRSR, 0x01F3);
 
 		/* TODO: set ClkRun enable? necessary? */
 		reg = rtl818x_ioread8(priv, &priv->map->GP_ENABLE);
@@ -453,7 +480,6 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 		rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | (1 << 2));
 		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
 	} else {
-		rtl818x_iowrite16(priv, &priv->map->BRSR, 0x1);
 		rtl818x_iowrite8(priv, &priv->map->SECURITY, 0);
 
 		rtl818x_iowrite8(priv, &priv->map->PHY_DELAY, 0x6);
@@ -461,8 +487,18 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
 	}
 
 	priv->rf->init(dev);
-	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185)
-		rtl818x_iowrite16(priv, &priv->map->BRSR, 0x01F3);
+
+	/* default basic rates are 1,2 Mbps for rtl8180. 1,2,6,9,12,18,24 Mbps
+	 * otherwise. bitmask 0x3 and 0x01f3 respectively.
+	 * NOTE: currenty rtl8225 RF code changes basic rates, so we need to do
+	 * this after rf init.
+	 * TODO: try to find out whether RF code really needs to do this..
+	 */
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8180)
+		rtl8180_conf_basic_rates(dev, 0x3);
+	else
+		rtl8180_conf_basic_rates(dev, 0x1f3);
+
 	return 0;
 }
 
@@ -857,6 +893,9 @@ static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
 		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
 	}
 
+	if (changed & BSS_CHANGED_BASIC_RATES)
+		rtl8180_conf_basic_rates(dev, info->basic_rates);
+
 	if (changed & BSS_CHANGED_ERP_SLOT && priv->rf->conf_erp)
 		priv->rf->conf_erp(dev, info);
 
-- 
1.8.3.2

