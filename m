Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46545 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab3HQMJm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 08:09:42 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 3/6] rt2x00: rt2800lib: use a MCU command for frequency adjustment on USB devices
Date: Sat, 17 Aug 2013 14:09:30 +0200
Message-Id: <1376741373-10032-4-git-send-email-juhosg@openwrt.org> (sfid-20130817_140953_071669_865F6498)
In-Reply-To: <1376741373-10032-1-git-send-email-juhosg@openwrt.org>
References: <1376741373-10032-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the Ralink driver, there is an MCU
command which can be used to send the frequency
offset value directly to the USB device without
going through the RFCSR writing sequence.

Based on the DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

Reference:
  RTMPAdjustFrequencyOffset function in common/rt_rf.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Changes since v1:
  - add a MCU_FREQ_OFFSET constant and use that instead
    of a hardcoded number
---
 drivers/net/wireless/rt2x00/rt2800.h    |    1 +
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 6e69b96..e25e5bf 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2794,6 +2794,7 @@ enum rt2800_eeprom_word {
 #define MCU_RADAR			0x60
 #define MCU_BOOT_SIGNAL			0x72
 #define MCU_ANT_SELECT			0X73
+#define MCU_FREQ_OFFSET			0x74
 #define MCU_BBP_SIGNAL			0x80
 #define MCU_POWER_SAVE			0x83
 #define MCU_BAND_SELECT		0x91
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 3407ac9..bebc56f 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2509,7 +2509,11 @@ static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
 	if (rfcsr == prev_rfcsr)
 		return;
 
-	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+	if (rt2x00_is_usb(rt2x00dev))
+		rt2800_mcu_request(rt2x00dev, MCU_FREQ_OFFSET, 0xff,
+				   freq_offset, prev_rfcsr);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
 }
 
 static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
-- 
1.7.10
