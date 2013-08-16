Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:55337 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364Ab3HPWeD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 18:34:03 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 4/5] rt2x00: rt2800lib: move rt2800_adjust_freq_offset function
Date: Fri, 16 Aug 2013 22:38:17 +0200
Message-Id: <1376685498-5167-5-git-send-email-juhosg@openwrt.org> (sfid-20130817_003413_148724_A419AAEA)
In-Reply-To: <1376685498-5167-1-git-send-email-juhosg@openwrt.org>
References: <1376685498-5167-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the rt2800_adjust_freq_offset function before
the channel configuration functions to make it usable
from those without a forward declaration.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   45 ++++++++++++++++---------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 60b4bfe..9b4d836 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1873,6 +1873,29 @@ static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->lna_gain = lna_gain;
 }
 
+#define FREQ_OFFSET_BOUND	0x5f
+
+static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
+{
+	u8 freq_offset;
+	u8 rfcsr, prev_rfcsr;
+
+	freq_offset = rt2x00_get_field8(rt2x00dev->freq_offset, RFCSR17_CODE);
+	freq_offset = min_t(u8, freq_offset, FREQ_OFFSET_BOUND);
+
+	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
+	prev_rfcsr = rfcsr;
+	rt2x00_set_field8(&rfcsr, RFCSR17_CODE, freq_offset);
+	if (rfcsr == prev_rfcsr)
+		return;
+
+	if (rt2x00_is_usb(rt2x00dev))
+		rt2800_mcu_request(rt2x00dev, 0x74, 0xff, freq_offset,
+				   prev_rfcsr);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+}
+
 static void rt2800_config_channel_rf2xxx(struct rt2x00_dev *rt2x00dev,
 					 struct ieee80211_conf *conf,
 					 struct rf_channel *rf,
@@ -2490,28 +2513,6 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 
 #define POWER_BOUND		0x27
 #define POWER_BOUND_5G		0x2b
-#define FREQ_OFFSET_BOUND	0x5f
-
-static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
-{
-	u8 freq_offset;
-	u8 rfcsr, prev_rfcsr;
-
-	freq_offset = rt2x00_get_field8(rt2x00dev->freq_offset, RFCSR17_CODE);
-	freq_offset = min_t(u8, freq_offset, FREQ_OFFSET_BOUND);
-
-	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
-	prev_rfcsr = rfcsr;
-	rt2x00_set_field8(&rfcsr, RFCSR17_CODE, freq_offset);
-	if (rfcsr == prev_rfcsr)
-		return;
-
-	if (rt2x00_is_usb(rt2x00dev))
-		rt2800_mcu_request(rt2x00dev, 0x74, 0xff, freq_offset,
-				   prev_rfcsr);
-	else
-		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
-}
 
 static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
 					 struct ieee80211_conf *conf,
-- 
1.7.10
