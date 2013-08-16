Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:55335 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab3HPWeD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:34:03 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/5] rt2x00: rt2800lib: optimize frequency offset adjustment
Date: Fri, 16 Aug 2013 22:38:15 +0200
Message-Id: <1376685498-5167-3-git-send-email-juhosg@openwrt.org> (sfid-20130817_003415_735726_4AE60911)
In-Reply-To: <1376685498-5167-1-git-send-email-juhosg@openwrt.org>
References: <1376685498-5167-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't write the new value into the register if it is
the same as the old value to avoid unncessary USB bus
traffic with USB devices. The change also saves a few
cycle on MMIO based devices.

Based on the DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

Reference:
  RTMPAdjustFrequencyOffset function in common/rt_rf.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index d4e6dea..c990a27 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2495,13 +2495,17 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
 {
 	u8 freq_offset;
-	u8 rfcsr;
+	u8 rfcsr, prev_rfcsr;
 
 	freq_offset = rt2x00_get_field8(rt2x00dev->freq_offset, RFCSR17_CODE);
 	freq_offset = min_t(u8, freq_offset, FREQ_OFFSET_BOUND);
 
 	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
+	prev_rfcsr = rfcsr;
 	rt2x00_set_field8(&rfcsr, RFCSR17_CODE, freq_offset);
+	if (rfcsr == prev_rfcsr)
+		return;
+
 	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
 }
 
-- 
1.7.10
