Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:42155 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab3JDUHN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Oct 2013 16:07:13 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] rt2x00: rt2800lib: fix default VGC values for RT3572 for the 5GHz band
Date: Fri,  4 Oct 2013 22:07:09 +0200
Message-Id: <1380917229-13269-1-git-send-email-juhosg@openwrt.org> (sfid-20131004_220718_181092_75A8E0B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rt2x00 driver uses 0x22 as a default VGC value
in VGC adjustment for the RT3572 chipset. In the
Ralink DPO_RT5572_LinuxSTA_2.6.1.3_20121022 driver,
this value is only used for initialization. During
VGC adjustment, the reference driver uses different
values.

Update the 'rt2800_get_default_vgc' function to
synchronize the values with the reference driver.
Also add the missing AGC initialization code into
the 'rt2800_config_channel' function.

References:
  RT35xx_SetAGCInitValue in chip/rt35xx.c
  RT35xx_ChipAGCAdjust in chip/rt35xx.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 95c18dc..7508729 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3310,9 +3310,18 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 
 	rt2800_register_write(rt2x00dev, TX_PIN_CFG, tx_pin);
 
-	if (rt2x00_rt(rt2x00dev, RT3572))
+	if (rt2x00_rt(rt2x00dev, RT3572)) {
 		rt2800_rfcsr_write(rt2x00dev, 8, 0x80);
 
+		/* AGC init */
+		if (rf->channel <= 14)
+			reg = 0x1c + (2 * rt2x00dev->lna_gain);
+		else
+			reg = 0x22 + ((rt2x00dev->lna_gain * 5) / 3);
+
+		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);
+	}
+
 	if (rt2x00_rt(rt2x00dev, RT3593)) {
 		rt2800_register_read(rt2x00dev, GPIO_CTRL, &reg);
 
@@ -4421,9 +4430,7 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 		else
 			vgc = 0x2e + rt2x00dev->lna_gain;
 	} else { /* 5GHZ band */
-		if (rt2x00_rt(rt2x00dev, RT3572))
-			vgc = 0x22 + (rt2x00dev->lna_gain * 5) / 3;
-		else if (rt2x00_rt(rt2x00dev, RT3593))
+		if (rt2x00_rt(rt2x00dev, RT3593))
 			vgc = 0x20 + (rt2x00dev->lna_gain * 5) / 3;
 		else if (rt2x00_rt(rt2x00dev, RT5592))
 			vgc = 0x24 + (2 * rt2x00dev->lna_gain);
-- 
1.7.10
