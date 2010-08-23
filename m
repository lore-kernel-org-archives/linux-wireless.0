Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65534 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab0HWR5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 13:57:30 -0400
Received: by bwz11 with SMTP id 11so4114557bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Aug 2010 10:57:29 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 7/8] rt2x00: Fix channel configuration for RF3052
Date: Mon, 23 Aug 2010 19:55:43 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201008231953.40629.IvDoorn@gmail.com> <201008231955.02401.IvDoorn@gmail.com> <201008231955.23348.IvDoorn@gmail.com>
In-Reply-To: <201008231955.23348.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201008231955.44731.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We missed a check for RF3052 in the config_channel
configuration function. As a result the channel is not
properly configured for RF3052 devices. This also
requires rt2800_config_channel_rf3xxx to support 5GHz
channels, so we must apply the TXPOWER_A_TO_DEV and
TXPOWER_G_TO_DEV conversions during rt2800_config_channel()

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 4ad2fe5..8f11f3e 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1244,8 +1244,7 @@ static void rt2800_config_channel_rf2xxx(struct rt2x00_dev *rt2x00dev,
 		if (info->tx_power1 < 0)
 			info->tx_power1 += 7;
 
-		rt2x00_set_field32(&rf->rf3, RF3_TXPOWER_A,
-				   TXPOWER_A_TO_DEV(info->tx_power1));
+		rt2x00_set_field32(&rf->rf3, RF3_TXPOWER_A, info->tx_power1);
 
 		rt2x00_set_field32(&rf->rf4, RF4_TXPOWER_A_7DBM_BOOST,
 				   (info->tx_power2 >= 0));
@@ -1253,13 +1252,10 @@ static void rt2800_config_channel_rf2xxx(struct rt2x00_dev *rt2x00dev,
 		if (info->tx_power2 < 0)
 			info->tx_power2 += 7;
 
-		rt2x00_set_field32(&rf->rf4, RF4_TXPOWER_A,
-				   TXPOWER_A_TO_DEV(info->tx_power2));
+		rt2x00_set_field32(&rf->rf4, RF4_TXPOWER_A, info->tx_power2);
 	} else {
-		rt2x00_set_field32(&rf->rf3, RF3_TXPOWER_G,
-				   TXPOWER_G_TO_DEV(info->tx_power1));
-		rt2x00_set_field32(&rf->rf4, RF4_TXPOWER_G,
-				   TXPOWER_G_TO_DEV(info->tx_power2));
+		rt2x00_set_field32(&rf->rf3, RF3_TXPOWER_G, info->tx_power1);
+		rt2x00_set_field32(&rf->rf4, RF4_TXPOWER_G, info->tx_power2);
 	}
 
 	rt2x00_set_field32(&rf->rf4, RF4_HT40, conf_is_ht40(conf));
@@ -1299,13 +1295,11 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 12, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR12_TX_POWER,
-			  TXPOWER_G_TO_DEV(info->tx_power1));
+	rt2x00_set_field8(&rfcsr, RFCSR12_TX_POWER, info->tx_power1);
 	rt2800_rfcsr_write(rt2x00dev, 12, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 13, &rfcsr);
-	rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER,
-			  TXPOWER_G_TO_DEV(info->tx_power2));
+	rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER, info->tx_power2);
 	rt2800_rfcsr_write(rt2x00dev, 13, rfcsr);
 
 	rt2800_rfcsr_read(rt2x00dev, 23, &rfcsr);
@@ -1329,10 +1323,19 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	unsigned int tx_pin;
 	u8 bbp;
 
+	if (rf->channel <= 14) {
+		info->tx_power1 = TXPOWER_G_TO_DEV(info->tx_power1);
+		info->tx_power2 = TXPOWER_G_TO_DEV(info->tx_power2);
+	} else {
+		info->tx_power1 = TXPOWER_A_TO_DEV(info->tx_power1);
+		info->tx_power2 = TXPOWER_A_TO_DEV(info->tx_power2);
+	}
+
 	if (rt2x00_rf(rt2x00dev, RF2020) ||
 	    rt2x00_rf(rt2x00dev, RF3020) ||
 	    rt2x00_rf(rt2x00dev, RF3021) ||
-	    rt2x00_rf(rt2x00dev, RF3022))
+	    rt2x00_rf(rt2x00dev, RF3022) ||
+	    rt2x00_rf(rt2x00dev, RF3052))
 		rt2800_config_channel_rf3xxx(rt2x00dev, conf, rf, info);
 	else
 		rt2800_config_channel_rf2xxx(rt2x00dev, conf, rf, info);
-- 
1.7.2.1

