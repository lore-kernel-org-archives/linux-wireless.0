Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46587 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab3HQMJn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 08:09:43 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 4/6] rt2x00: rt2800lib: use step-by-step frequency offset adjustment on MMIO devices
Date: Sat, 17 Aug 2013 14:09:31 +0200
Message-Id: <1376741373-10032-5-git-send-email-juhosg@openwrt.org> (sfid-20130817_140948_298361_B54332AC)
In-Reply-To: <1376741373-10032-1-git-send-email-juhosg@openwrt.org>
References: <1376741373-10032-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver, the RFCSR17 register can't be programmed in
one step on devices which are using the frequency
offset adjustment code.

Update the code to use step-by-step adjustment.

Reference:
  RT30xxWriteRFRegister function in common/rt_rf.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Changes since v1:
  - new patch
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index bebc56f..623ad9d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2496,7 +2496,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 
 static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
 {
-	u8 freq_offset;
+	u8 freq_offset, prev_freq_offset;
 	u8 rfcsr, prev_rfcsr;
 
 	freq_offset = rt2x00_get_field8(rt2x00dev->freq_offset, RFCSR17_CODE);
@@ -2509,11 +2509,24 @@ static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
 	if (rfcsr == prev_rfcsr)
 		return;
 
-	if (rt2x00_is_usb(rt2x00dev))
+	if (rt2x00_is_usb(rt2x00dev)) {
 		rt2800_mcu_request(rt2x00dev, MCU_FREQ_OFFSET, 0xff,
 				   freq_offset, prev_rfcsr);
-	else
+		return;
+	}
+
+	prev_freq_offset = rt2x00_get_field8(prev_rfcsr, RFCSR17_CODE);
+	while (prev_freq_offset != freq_offset) {
+		if (prev_freq_offset < freq_offset)
+			prev_freq_offset++;
+		else
+			prev_freq_offset--;
+
+		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, prev_freq_offset);
 		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+
+		usleep_range(1000, 1500);
+	}
 }
 
 static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
-- 
1.7.10
