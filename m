Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:55339 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755365Ab3HPWeD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:34:03 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 3/5] rt2x00: rt2800lib: use a MCU command for frequency adjustment on USB devices
Date: Fri, 16 Aug 2013 22:38:16 +0200
Message-Id: <1376685498-5167-4-git-send-email-juhosg@openwrt.org> (sfid-20130817_003410_983699_243A5AAD)
In-Reply-To: <1376685498-5167-1-git-send-email-juhosg@openwrt.org>
References: <1376685498-5167-1-git-send-email-juhosg@openwrt.org>
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
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c990a27..60b4bfe 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2506,7 +2506,11 @@ static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
 	if (rfcsr == prev_rfcsr)
 		return;
 
-	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+	if (rt2x00_is_usb(rt2x00dev))
+		rt2800_mcu_request(rt2x00dev, 0x74, 0xff, freq_offset,
+				   prev_rfcsr);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
 }
 
 static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
-- 
1.7.10
