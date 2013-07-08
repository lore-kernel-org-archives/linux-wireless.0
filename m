Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48349 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab3GHOJA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:09:00 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 09/20] rt2x00: rt2800lib: fix default TX power values for RT3593
Date: Mon,  8 Jul 2013 16:08:24 +0200
Message-Id: <1373292515-21332-10-git-send-email-juhosg@openwrt.org> (sfid-20130708_162043_321159_0B495185)
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
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
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v2: ---
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
index 1738a9d..b11f0b0 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2728,8 +2728,15 @@ static char rt2800_txpower_to_dev(struct rt2x00_dev *rt2x00dev,
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

