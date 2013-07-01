Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:47512 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab3GAHsZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 03:48:25 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 08/20] rt2x00: rt2800lib: add rt2800_txpower_to_dev helper
Date: Mon,  1 Jul 2013 09:47:47 +0200
Message-Id: <1372664879-18474-9-git-send-email-juhosg@openwrt.org> (sfid-20130701_094829_109466_43E62757)
In-Reply-To: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce a new helper function for converting
the default TX power values from EEPROM into
mac80211 values.

The change improves the readability and it makes
it easier to add support for other chipsets.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
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
index fa5bbae..9d05273 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2725,6 +2725,16 @@ static void rt2800_iq_calibrate(struct rt2x00_dev *rt2x00dev, int channel)
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
@@ -2734,13 +2744,10 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
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

