Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:46619 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab3HQMJo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 08:09:44 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 5/6] rt2x00: rt2800lib: move rt2800_adjust_freq_offset function
Date: Sat, 17 Aug 2013 14:09:32 +0200
Message-Id: <1376741373-10032-6-git-send-email-juhosg@openwrt.org> (sfid-20130817_140949_796892_5A767CF5)
In-Reply-To: <1376741373-10032-1-git-send-email-juhosg@openwrt.org>
References: <1376741373-10032-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the rt2800_adjust_freq_offset function before
the channel configuration functions to make it usable
from those without a forward declaration.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Changes since v1: ---
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   73 ++++++++++++++++---------------
 1 file changed, 37 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 623ad9d..1b81fc9 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1875,6 +1875,43 @@ static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->lna_gain = lna_gain;
 }
 
+#define FREQ_OFFSET_BOUND	0x5f
+
+static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
+{
+	u8 freq_offset, prev_freq_offset;
+	u8 rfcsr, prev_rfcsr;
+
+	freq_offset = rt2x00_get_field8(rt2x00dev->freq_offset, RFCSR17_CODE);
+	freq_offset = min_t(u8, freq_offset, FREQ_OFFSET_BOUND);
+
+	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
+	prev_rfcsr = rfcsr;
+
+	rt2x00_set_field8(&rfcsr, RFCSR17_CODE, freq_offset);
+	if (rfcsr == prev_rfcsr)
+		return;
+
+	if (rt2x00_is_usb(rt2x00dev)) {
+		rt2800_mcu_request(rt2x00dev, MCU_FREQ_OFFSET, 0xff,
+				   freq_offset, prev_rfcsr);
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
+		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+
+		usleep_range(1000, 1500);
+	}
+}
+
 static void rt2800_config_channel_rf2xxx(struct rt2x00_dev *rt2x00dev,
 					 struct ieee80211_conf *conf,
 					 struct rf_channel *rf,
@@ -2492,42 +2529,6 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 
 #define POWER_BOUND		0x27
 #define POWER_BOUND_5G		0x2b
-#define FREQ_OFFSET_BOUND	0x5f
-
-static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
-{
-	u8 freq_offset, prev_freq_offset;
-	u8 rfcsr, prev_rfcsr;
-
-	freq_offset = rt2x00_get_field8(rt2x00dev->freq_offset, RFCSR17_CODE);
-	freq_offset = min_t(u8, freq_offset, FREQ_OFFSET_BOUND);
-
-	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
-	prev_rfcsr = rfcsr;
-
-	rt2x00_set_field8(&rfcsr, RFCSR17_CODE, freq_offset);
-	if (rfcsr == prev_rfcsr)
-		return;
-
-	if (rt2x00_is_usb(rt2x00dev)) {
-		rt2800_mcu_request(rt2x00dev, MCU_FREQ_OFFSET, 0xff,
-				   freq_offset, prev_rfcsr);
-		return;
-	}
-
-	prev_freq_offset = rt2x00_get_field8(prev_rfcsr, RFCSR17_CODE);
-	while (prev_freq_offset != freq_offset) {
-		if (prev_freq_offset < freq_offset)
-			prev_freq_offset++;
-		else
-			prev_freq_offset--;
-
-		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, prev_freq_offset);
-		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
-
-		usleep_range(1000, 1500);
-	}
-}
 
 static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
 					 struct ieee80211_conf *conf,
-- 
1.7.10
