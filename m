Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:58345 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaEaQaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 12:30:13 -0400
Received: by mail-we0-f171.google.com with SMTP id w62so3349730wes.16
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 09:30:12 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 1/3] rtl818x_pci: make RSSI code more readable
Date: Sat, 31 May 2014 18:29:46 +0200
Message-Id: <1401553786-7603-1-git-send-email-andrea.merello@gmail.com> (sfid-20140531_183024_257678_086DBC45)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove the if-else chains and use switch-case to make code more
readable and avoiding long lines that broke in several lines

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 2c1c02b..c2dd5e6 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -209,7 +209,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 	struct rtl8180_priv *priv = dev->priv;
 	struct rtl818x_rx_cmd_desc *cmd_desc;
 	unsigned int count = 32;
-	u8 signal, agc, sq;
+	u8 agc, sq, signal = 1;
 	dma_addr_t mapping;
 
 	while (count--) {
@@ -266,18 +266,21 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			rx_status.rate_idx = (flags >> 20) & 0xF;
 			agc = (flags2 >> 17) & 0x7F;
 
-			if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185) {
+			switch (priv->chip_family) {
+			case RTL818X_CHIP_FAMILY_RTL8185:
 				if (rx_status.rate_idx > 3)
 					signal = 90 - clamp_t(u8, agc, 25, 90);
 				else
 					signal = 95 - clamp_t(u8, agc, 30, 95);
-			} else if (priv->chip_family ==
-				   RTL818X_CHIP_FAMILY_RTL8180) {
+				break;
+			case RTL818X_CHIP_FAMILY_RTL8180:
 				sq = flags2 & 0xff;
 				signal = priv->rf->calc_rssi(agc, sq);
-			} else {
+				break;
+			case RTL818X_CHIP_FAMILY_RTL8187SE:
 				/* TODO: rtl8187se rssi */
 				signal = 10;
+				break;
 			}
 			rx_status.signal = signal;
 			rx_status.freq = dev->conf.chandef.chan->center_freq;
-- 
1.9.1

