Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48287 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab3GHOIw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:08:52 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 08/20] rt2x00: rt2800lib: add rt2800_txpower_to_dev helper
Date: Mon,  8 Jul 2013 16:08:23 +0200
Message-Id: <1373292515-21332-9-git-send-email-juhosg@openwrt.org> (sfid-20130708_160856_309524_7D9D73C8)
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce a new helper function for converting
the default TX power values from EEPROM into
mac80211 values.

The change improves the readability and it makes
it easier to add support for other chipsets.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v2: ---
---
 drivers/net/wireless/rt2x00/rt2800.h    |    6 ------
 drivers/net/wireless/rt2x00/rt2800lib.c |   21 ++++++++++++++-------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 7b7caeb..d3e8f6d 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2887,15 +2887,9 @@ enum rt2800_eeprom_word {
 #define TXPOWER_G_FROM_DEV(__txpower) \
 	((__txpower) > MAX_G_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
 
-#define TXPOWER_G_TO_DEV(__txpower) \
-	clamp_t(char, __txpower, MIN_G_TXPOWER, MAX_G_TXPOWER)
-
 #define TXPOWER_A_FROM_DEV(__txpower) \
 	((__txpower) > MAX_A_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
 
-#define TXPOWER_A_TO_DEV(__txpower) \
-	clamp_t(char, __txpower, MIN_A_TXPOWER, MAX_A_TXPOWER)
-
 /*
  *  Board's maximun TX power limitation
  */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 958215c..1738a9d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2724,6 +2724,16 @@ static void rt2800_iq_calibrate(struct rt2x00_dev *rt2x00dev, int channel)
 	rt2800_bbp_write(rt2x00dev, 159, cal != 0xff ? cal : 0);
 }
 
+static char rt2800_txpower_to_dev(struct rt2x00_dev *rt2x00dev,
+				  unsigned int channel,
+				  char txpower)
+{
+	if (channel <= 14)
+		return clamp_t(char, txpower, MIN_G_TXPOWER, MAX_G_TXPOWER);
+	else
+		return clamp_t(char, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
+}
+
 static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 				  struct ieee80211_conf *conf,
 				  struct rf_channel *rf,
@@ -2733,13 +2743,10 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	unsigned int tx_pin;
 	u8 bbp, rfcsr;
 
-	if (rf->channel <= 14) {
-		info->default_power1 = TXPOWER_G_TO_DEV(info->default_power1);
-		info->default_power2 = TXPOWER_G_TO_DEV(info->default_power2);
-	} else {
-		info->default_power1 = TXPOWER_A_TO_DEV(info->default_power1);
-		info->default_power2 = TXPOWER_A_TO_DEV(info->default_power2);
-	}
+	info->default_power1 = rt2800_txpower_to_dev(rt2x00dev, rf->channel,
+						     info->default_power1);
+	info->default_power2 = rt2800_txpower_to_dev(rt2x00dev, rf->channel,
+						     info->default_power2);
 
 	switch (rt2x00dev->chip.rf) {
 	case RF2020:
-- 
1.7.10

