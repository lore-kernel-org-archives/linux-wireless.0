Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:64747 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaAUTQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 14:16:38 -0500
Received: by mail-ee0-f54.google.com with SMTP id e53so3543532eek.27
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jan 2014 11:16:37 -0800 (PST)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	andrea merello <andrea.merello@gmail.com>
Subject: [PATCH] rtl818x: change misleading names for few register bit definitions
Date: Tue, 21 Jan 2014 20:16:43 +0100
Message-Id: <1390331803-3672-1-git-send-email-andrea.merello@gmail.com> (sfid-20140121_201642_530242_9DB1C857)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: andrea merello <andrea.merello@gmail.com>

In rtl8180/rtl8187 drivers, few register bit definitions have
names of form FOOBAR_SHIFT, suggesting they should be used as
shift offset, for example
reg |= (1 << ENABLE_FOO_SHIFT).

However they are actually defined as (1 << x) and thus they are
used (correctly) like
reg |= ENABLE_FOO_SHIFT;

This patch kills the misleading _SHIFT suffix.

Signed-off-by: andrea merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c |  8 ++++----
 drivers/net/wireless/rtl818x/rtl8187/dev.c | 14 +++++++-------
 drivers/net/wireless/rtl818x/rtl818x.h     | 10 +++++-----
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 8ec17aa..9bc843e 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -602,13 +602,13 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 
 	if (priv->r8185) {
 		reg = rtl818x_ioread8(priv, &priv->map->CW_CONF);
-		reg &= ~RTL818X_CW_CONF_PERPACKET_CW_SHIFT;
-		reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;
+		reg &= ~RTL818X_CW_CONF_PERPACKET_CW;
+		reg |= RTL818X_CW_CONF_PERPACKET_RETRY;
 		rtl818x_iowrite8(priv, &priv->map->CW_CONF, reg);
 
 		reg = rtl818x_ioread8(priv, &priv->map->TX_AGC_CTL);
-		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT;
-		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT;
+		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN;
+		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL;
 		reg |=  RTL818X_TX_AGC_CTL_FEEDBACK_ANT;
 		rtl818x_iowrite8(priv, &priv->map->TX_AGC_CTL, reg);
 
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index fd78df8..c981bcf 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -785,7 +785,7 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	rtl818x_iowrite16(priv, (__le16 *)0xFF34, 0x0FFF);
 
 	reg = rtl818x_ioread8(priv, &priv->map->CW_CONF);
-	reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;
+	reg |= RTL818X_CW_CONF_PERPACKET_RETRY;
 	rtl818x_iowrite8(priv, &priv->map->CW_CONF, reg);
 
 	/* Auto Rate Fallback Register (ARFR): 1M-54M setting */
@@ -943,8 +943,8 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 		rtl818x_iowrite32(priv, &priv->map->RX_CONF, reg);
 
 		reg = rtl818x_ioread8(priv, &priv->map->TX_AGC_CTL);
-		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT;
-		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT;
+		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN;
+		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL;
 		reg &= ~RTL818X_TX_AGC_CTL_FEEDBACK_ANT;
 		rtl818x_iowrite8(priv, &priv->map->TX_AGC_CTL, reg);
 
@@ -986,13 +986,13 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 	rtl818x_iowrite32(priv, &priv->map->RX_CONF, reg);
 
 	reg = rtl818x_ioread8(priv, &priv->map->CW_CONF);
-	reg &= ~RTL818X_CW_CONF_PERPACKET_CW_SHIFT;
-	reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;
+	reg &= ~RTL818X_CW_CONF_PERPACKET_CW;
+	reg |= RTL818X_CW_CONF_PERPACKET_RETRY;
 	rtl818x_iowrite8(priv, &priv->map->CW_CONF, reg);
 
 	reg = rtl818x_ioread8(priv, &priv->map->TX_AGC_CTL);
-	reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT;
-	reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT;
+	reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN;
+	reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL;
 	reg &= ~RTL818X_TX_AGC_CTL_FEEDBACK_ANT;
 	rtl818x_iowrite8(priv, &priv->map->TX_AGC_CTL, reg);
 
diff --git a/drivers/net/wireless/rtl818x/rtl818x.h b/drivers/net/wireless/rtl818x/rtl818x.h
index ce23dfd..fa7f7f6 100644
--- a/drivers/net/wireless/rtl818x/rtl818x.h
+++ b/drivers/net/wireless/rtl818x/rtl818x.h
@@ -144,9 +144,9 @@ struct rtl818x_csr {
 	__le32	HSSI_PARA;
 	u8	reserved_13[4];
 	u8	TX_AGC_CTL;
-#define RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT		(1 << 0)
-#define RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT	(1 << 1)
-#define RTL818X_TX_AGC_CTL_FEEDBACK_ANT			(1 << 2)
+#define RTL818X_TX_AGC_CTL_PERPACKET_GAIN	(1 << 0)
+#define RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL	(1 << 1)
+#define RTL818X_TX_AGC_CTL_FEEDBACK_ANT		(1 << 2)
 	u8	TX_GAIN_CCK;
 	u8	TX_GAIN_OFDM;
 	u8	TX_ANTENNA;
@@ -158,8 +158,8 @@ struct rtl818x_csr {
 	u8	SLOT;
 	u8	reserved_16[5];
 	u8	CW_CONF;
-#define RTL818X_CW_CONF_PERPACKET_CW_SHIFT	(1 << 0)
-#define RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT	(1 << 1)
+#define RTL818X_CW_CONF_PERPACKET_CW	(1 << 0)
+#define RTL818X_CW_CONF_PERPACKET_RETRY	(1 << 1)
 	u8	CW_VAL;
 	u8	RATE_FALLBACK;
 #define RTL818X_RATE_FALLBACK_ENABLE	(1 << 7)
-- 
1.8.3.2

