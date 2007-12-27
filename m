Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:11025 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751820AbXL0BQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Dec 2007 20:16:05 -0500
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 1/2] rtl8180: sync radio V2 code with vendor reference
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Date: Wed, 26 Dec 2007 20:16:37 -0500
Message-ID: <20071227011637.10445.89261.stgit@tetra.sourmilk.net> (sfid-20071227_011609_314569_0537CD3F)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrea Merello <andreamrl@tiscali.it>

We have to set ofdm register 0x2 to 0x62 (0x64 is for rtl8187). We did this
correctly in init function, but we overwrite it when setting TX power.
As reference code suggest, we still rewrite it, but with right value.

Signed-off-by: Andrea Merello <andreamrl@tiscali.it>
Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/rtl8180_rtl8225.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl8180_rtl8225.c b/drivers/net/wireless/rtl8180_rtl8225.c
index 37ac402..9dab126 100644
--- a/drivers/net/wireless/rtl8180_rtl8225.c
+++ b/drivers/net/wireless/rtl8180_rtl8225.c
@@ -504,7 +504,7 @@ static void rtl8225z2_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
 	ofdm_power = min(ofdm_power, (u8)35);
 	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM, ofdm_power);
 
-	rtl8225_write_phy_ofdm(dev, 2, 0x42);
+	rtl8225_write_phy_ofdm(dev, 2, 0x62);
 	rtl8225_write_phy_ofdm(dev, 5, 0x00);
 	rtl8225_write_phy_ofdm(dev, 6, 0x40);
 	rtl8225_write_phy_ofdm(dev, 7, 0x00);


