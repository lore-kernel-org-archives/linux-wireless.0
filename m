Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailf.rambler.ru ([81.19.66.214]:46350 "EHLO mailf.rambler.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516Ab3DOD3y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 23:29:54 -0400
From: minimumlaw@rambler.ru
To: linux-wireless@vger.kernel.org
Cc: "Alex A. Mihaylov" <minimumlaw@rambler.ru>, stable@vger.kernel.org
Subject: [PATCH v2] rt2x00: Fix transmit power troubles on some Ralink RT30xx cards
Date: Mon, 15 Apr 2013 07:29:35 +0400
Message-Id: <1365996575-18989-1-git-send-email-minimumlaw@rambler.ru> (sfid-20130415_052958_154240_10A89A14)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Alex A. Mihaylov" <minimumlaw@rambler.ru>

Some cards on Ralink RT30xx chipset not have correctly TX_MIXER_GAIN
value in them EEPROM/EFUSE. In this case, we must use default value,
but always used EEPROM/EFUSE value. As result we have tranmitt power
range from -10dBm to +6dBm instead 0dBm to +16dBm.

Correctly value in EEPROM/EFUSE is one or more for RT3070 and two or
more for other RT30xx chips.

Tested on Canyon CNP-WF518N1 usb Wi-Fi dongle and Jorjin WN8020 usb
embedded Wi-Fi module.

Signed-off-by: Alex A. Mihaylov <minimumlaw@rambler.ru>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/rt2x00/rt2800lib.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a658b4b..92849e5 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4436,6 +4436,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 
 	if (!rt2x00_rt(rt2x00dev, RT5390) &&
 	    !rt2x00_rt(rt2x00dev, RT5392)) {
+		u8 min_gain = rt2x00_rt(rt2x00dev, RT3070) ? 1 : 2;
+
 		rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
@@ -4446,8 +4448,10 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 				      &rt2x00dev->cap_flags))
 				rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
 		}
-		rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
-				  drv_data->txmixer_gain_24g);
+		if (drv_data->txmixer_gain_24g >= min_gain) {
+			rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
+					  drv_data->txmixer_gain_24g);
+		}
 		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
 	}
 
-- 
1.8.1.5

