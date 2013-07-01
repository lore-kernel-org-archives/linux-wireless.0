Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:47512 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab3GAHs0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 03:48:26 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 09/20] rt2x00: rt2800lib: fix default TX power values for RT3593
Date: Mon,  1 Jul 2013 09:47:48 +0200
Message-Id: <1372664879-18474-10-git-send-email-juhosg@openwrt.org> (sfid-20130701_094830_386185_D8A18B29)
In-Reply-To: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
References: <1372664879-18474-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX power values in the EEPROM are using
a different format for the RT3593 chip. The
default TX power value uses bits 0..4 only.
Bits 5..8 contains value for fine grained
power control. Additionally, the lower and
upper limits of the TX power values are the
same for both bands.

Improve the rt2800_txpower_to_dev function,
in order to compute the correct default power
values for the RT3593 chip as well.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    7 +++++++
 drivers/net/wireless/rt2x00/rt2800lib.c |    7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index d3e8f6d..69749ba5 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2603,6 +2603,10 @@ enum rt2800_eeprom_word {
 #define EEPROM_TXPOWER_A_1		FIELD16(0x00ff)
 #define EEPROM_TXPOWER_A_2		FIELD16(0xff00)
 
+/* EEPROM_TXPOWER_{A,G} fields for RT3593 */
+#define EEPROM_TXPOWER_ALC		FIELD8(0x1f)
+#define EEPROM_TXPOWER_FINE_CTRL	FIELD8(0xe0)
+
 /*
  * EEPROM temperature compensation boundaries 802.11A
  * MINUS4: If the actual TSSI is below this boundary, tx power needs to be
@@ -2884,6 +2888,9 @@ enum rt2800_eeprom_word {
 #define MAX_A_TXPOWER	15
 #define DEFAULT_TXPOWER	5
 
+#define MIN_A_TXPOWER_3593	0
+#define MAX_A_TXPOWER_3593	31
+
 #define TXPOWER_G_FROM_DEV(__txpower) \
 	((__txpower) > MAX_G_TXPOWER) ? DEFAULT_TXPOWER : (__txpower)
 
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9d05273..cbc3dc3 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2729,8 +2729,15 @@ static char rt2800_txpower_to_dev(struct rt2x00_dev *rt2x00dev,
 				  unsigned int channel,
 				  char txpower)
 {
+	if (rt2x00_rt(rt2x00dev, RT3593))
+		txpower = rt2x00_get_field8(txpower, EEPROM_TXPOWER_ALC);
+
 	if (channel <= 14)
 		return clamp_t(char, txpower, MIN_G_TXPOWER, MAX_G_TXPOWER);
+
+	if (rt2x00_rt(rt2x00dev, RT3593))
+		return clamp_t(char, txpower, MIN_A_TXPOWER_3593,
+			       MAX_A_TXPOWER_3593);
 	else
 		return clamp_t(char, txpower, MIN_A_TXPOWER, MAX_A_TXPOWER);
 }
-- 
1.7.10

