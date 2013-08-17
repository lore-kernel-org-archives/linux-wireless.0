Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46418 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957Ab3HQMJk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 08:09:40 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 1/6] rt2x00: rt2800lib: fix frequency offset boundary calculation
Date: Sat, 17 Aug 2013 14:09:28 +0200
Message-Id: <1376741373-10032-2-git-send-email-juhosg@openwrt.org> (sfid-20130817_140946_026616_08B9C37E)
In-Reply-To: <1376741373-10032-1-git-send-email-juhosg@openwrt.org>
References: <1376741373-10032-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current code in the 'rt2800_adjust_freq_offset'
function limits the device specific frequency offset
value to FREQ_BOUND but ignores the fact that the
uppermost bit is not part of the frequency offset
value. As the result, the driver always uses the
FREQ_BOUND value if the uppermost bit is set.

Update the code to use the correct source value
for calculating the boundary.

Based on the DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

Reference:
  RTMPAdjustFrequencyOffset function in common/rt_rf.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Changes since v1: ---
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 2f64034..de27277 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2496,13 +2496,14 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 
 static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
 {
+	u8 freq_offset;
 	u8 rfcsr;
 
+	freq_offset = rt2x00_get_field8(rt2x00dev->freq_offset, RFCSR17_CODE);
+	freq_offset = min_t(u8, freq_offset, FREQ_OFFSET_BOUND);
+
 	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
-	if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
-		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
-	else
-		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
+	rt2x00_set_field8(&rfcsr, RFCSR17_CODE, freq_offset);
 	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
 }
 
-- 
1.7.10
