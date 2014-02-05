Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:43728 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbaBEVhq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 16:37:46 -0500
Received: by mail-ea0-f178.google.com with SMTP id a15so508425eae.23
        for <linux-wireless@vger.kernel.org>; Wed, 05 Feb 2014 13:37:45 -0800 (PST)
From: andrea merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	"andrea.merello" <andrea.merello@gmail.com>
Subject: [PATCH 1/4] In rtl8180/rtl8187 drivers, few register bit definitions have misleading names. Fix them
Date: Wed,  5 Feb 2014 22:38:04 +0100
Message-Id: <1391636287-17712-2-git-send-email-andrea.merello@gmail.com> (sfid-20140205_223750_119721_3883C51B)
In-Reply-To: <1391636287-17712-1-git-send-email-andrea.merello@gmail.com>
References: <1391636287-17712-1-git-send-email-andrea.merello@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "andrea.merello" <andrea.merello@gmail.com>

- names of form FOOBAR_SHIFT, suggesting they should be used as
  shift offset, for example
  reg |= (1 << ENABLE_FOO_SHIFT).

  However they are actually defined as (1 << x) and thus they are
  used (correctly) like
  reg |= ENABLE_FOO_SHIFT;

- RTL818X_TX_CONF_HW_SEQNUM  that actually means _disable_ hardware
  sequence number

This patch kills the misleading _SHIFT suffix and changes
RTL818X_TX_CONF_HW_SEQNUM with RTL818X_TX_CONF_SW_SEQNUM

Signed-off-by: andrea.merello <andrea.merello@gmail.com>
Signed-off-by: andrea merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 10 +++++-----
 drivers/net/wireless/rtl818x/rtl8187/dev.c | 16 ++++++++--------
 drivers/net/wireless/rtl818x/rtl818x.h     | 12 ++++++------
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 8ec17aa..79b9398 100644
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
 
@@ -623,7 +623,7 @@ static int rtl8180_start(struct ieee80211_hw *dev)
 	if (priv->r8185)
 		reg &= ~RTL818X_TX_CONF_PROBE_DTS;
 	else
-		reg &= ~RTL818X_TX_CONF_HW_SEQNUM;
+		reg &= ~RTL818X_TX_CONF_SW_SEQNUM;
 
 	/* different meaning, same value on both rtl8185 and rtl8180 */
 	reg &= ~RTL818X_TX_CONF_SAT_HWPLCP;
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index fd78df8..b0b1730 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -785,7 +785,7 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
 	rtl818x_iowrite16(priv, (__le16 *)0xFF34, 0x0FFF);
 
 	reg = rtl818x_ioread8(priv, &priv->map->CW_CONF);
-	reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;
+	reg |= RTL818X_CW_CONF_PERPACKET_RETRY;
 	rtl818x_iowrite8(priv, &priv->map->CW_CONF, reg);
 
 	/* Auto Rate Fallback Register (ARFR): 1M-54M setting */
@@ -943,13 +943,13 @@ static int rtl8187_start(struct ieee80211_hw *dev)
 		rtl818x_iowrite32(priv, &priv->map->RX_CONF, reg);
 
 		reg = rtl818x_ioread8(priv, &priv->map->TX_AGC_CTL);
-		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT;
-		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT;
+		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN;
+		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL;
 		reg &= ~RTL818X_TX_AGC_CTL_FEEDBACK_ANT;
 		rtl818x_iowrite8(priv, &priv->map->TX_AGC_CTL, reg);
 
 		rtl818x_iowrite32(priv, &priv->map->TX_CONF,
-				  RTL818X_TX_CONF_HW_SEQNUM |
+				  RTL818X_TX_CONF_SW_SEQNUM |
 				  RTL818X_TX_CONF_DISREQQSIZE |
 				  (RETRY_COUNT << 8  /* short retry limit */) |
 				  (RETRY_COUNT << 0  /* long retry limit */) |
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
index ce23dfd..89fe1d3 100644
--- a/drivers/net/wireless/rtl818x/rtl818x.h
+++ b/drivers/net/wireless/rtl818x/rtl818x.h
@@ -71,7 +71,7 @@ struct rtl818x_csr {
 #define RTL818X_TX_CONF_HWVER_MASK	(7 << 25)
 #define RTL818X_TX_CONF_DISREQQSIZE	(1 << 28)
 #define RTL818X_TX_CONF_PROBE_DTS	(1 << 29)
-#define RTL818X_TX_CONF_HW_SEQNUM	(1 << 30)
+#define RTL818X_TX_CONF_SW_SEQNUM	(1 << 30)
 #define RTL818X_TX_CONF_CW_MIN		(1 << 31)
 	__le32	RX_CONF;
 #define RTL818X_RX_CONF_MONITOR		(1 <<  0)
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

