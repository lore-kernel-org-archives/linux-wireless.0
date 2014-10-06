Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:54789 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaJFSYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 14:24:34 -0400
Received: by mail-wg0-f52.google.com with SMTP id a1so7276172wgh.35
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2014 11:24:33 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	xose.vazquez@gmail.com, ralf@czekalla.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH] rtl818x_pci: fix response rate may be incorrect.
Date: Mon,  6 Oct 2014 20:23:55 +0200
Message-Id: <1412619835-12038-1-git-send-email-andrea.merello@gmail.com> (sfid-20141006_202437_615626_FF5D87C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the allowed "respose rate" set (rates for HW generated frames
like ACKs) is the same as the basic rate set.

The HW will use the higher allowed response rate that is lower than the
rate of the received frame.

This is more or less what IEEE80211 mandates, but I missed the fact
that IEEE80211 also says that whenever it happens that for a modulation
class there is no any rate in the basic rates set, then the response rate
set shall include also all the mandatory rates for that modulation class.

This patch adds mandatory OFDM rates to the allowed response rate set if
no OFDM rate is included in the basic rate set.

Depending by the AP, I faced cases in which this patch seems to cause a
noticeable perfomance improvement.

- With my usual test AP there is no particular perfomance difference.
- With a prism54/hostapd AP this patch causes RX thoughput increase from
  about 5Mbps to about 20Mbps.

Hopefully this patch may help people that faced performance regression wrt
the old staging driver.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 36 +++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index ded967a..706b844 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -742,35 +742,49 @@ static void rtl8180_int_disable(struct ieee80211_hw *dev)
 }
 
 static void rtl8180_conf_basic_rates(struct ieee80211_hw *dev,
-			    u32 rates_mask)
+			    u32 basic_mask)
 {
 	struct rtl8180_priv *priv = dev->priv;
-
-	u8 max, min;
 	u16 reg;
-
-	max = fls(rates_mask) - 1;
-	min = ffs(rates_mask) - 1;
+	u32 resp_mask;
+	u8 basic_max;
+	u8 resp_max, resp_min;
+
+	resp_mask = basic_mask;
+	/* IEEE80211 says the response rate should be equal to the highest basic
+	 * rate that is not faster than received frame. But it says also that if
+	 * the basic rate set does not contains any rate for the current
+	 * modulation class then mandatory rate set must be used for that
+	 * modulation class. Eventually add OFDM mandatory rates..
+	 */
+	if ((resp_mask & 0xf) == resp_mask)
+		resp_mask |= 0x150; /* 6, 12, 24Mbps */
 
 	switch (priv->chip_family) {
 
 	case RTL818X_CHIP_FAMILY_RTL8180:
 		/* in 8180 this is NOT a BITMAP */
+		basic_max = fls(basic_mask) - 1;
 		reg = rtl818x_ioread16(priv, &priv->map->BRSR);
 		reg &= ~3;
-		reg |= max;
+		reg |= basic_max;
 		rtl818x_iowrite16(priv, &priv->map->BRSR, reg);
 		break;
 
 	case RTL818X_CHIP_FAMILY_RTL8185:
+		resp_max = fls(resp_mask) - 1;
+		resp_min = ffs(resp_mask) - 1;
 		/* in 8185 this is a BITMAP */
-		rtl818x_iowrite16(priv, &priv->map->BRSR, rates_mask);
-		rtl818x_iowrite8(priv, &priv->map->RESP_RATE, (max << 4) | min);
+		rtl818x_iowrite16(priv, &priv->map->BRSR, basic_mask);
+		rtl818x_iowrite8(priv, &priv->map->RESP_RATE, (resp_max << 4) |
+				resp_min);
 		break;
 
 	case RTL818X_CHIP_FAMILY_RTL8187SE:
-		/* in 8187se this is a BITMAP */
-		rtl818x_iowrite16(priv, &priv->map->BRSR_8187SE, rates_mask);
+		/* in 8187se this is a BITMAP. BRSR reg actually sets
+		 * response rates.
+		 */
+		rtl818x_iowrite16(priv, &priv->map->BRSR_8187SE, resp_mask);
 		break;
 	}
 }
-- 
1.9.1

