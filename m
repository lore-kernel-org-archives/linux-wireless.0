Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:41258 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab3FZRz1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 13:55:27 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 5/5] rt2x00: rt2800lib: add EEPROM map for the RT3593 chipset
Date: Wed, 26 Jun 2013 19:55:18 +0200
Message-Id: <1372269318-30233-6-git-send-email-juhosg@openwrt.org> (sfid-20130626_195532_688208_2C30AAD5)
In-Reply-To: <1372269318-30233-1-git-send-email-juhosg@openwrt.org>
References: <1372269318-30233-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Three-chain devices are using a different
EEPROM layout than the rest of the chipsets.
Add a new map which describes the new layout
and use that for the RT3593 chipset.

The index values has been computed from the
EEPROM_EXT_* defines, which can be found in
the 'include/chip/rt3593.h' file in the
Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800.h    |    6 ++++
 drivers/net/wireless/rt2x00/rt2800lib.c |   48 ++++++++++++++++++++++++++++++-
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index bc5c695..9216834 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2244,6 +2244,12 @@ enum rt2800_eeprom_word {
 	EEPROM_TSSI_BOUND_A5,
 	EEPROM_TXPOWER_BYRATE,
 	EEPROM_BBP_START,
+
+	/* IDs for extended EEPROM format used by three-chain devices */
+	EEPROM_EXT_LNA2,
+	EEPROM_EXT_TXPOWER_BG3,
+	EEPROM_EXT_TXPOWER_A3,
+
 	/* New values must be added before this */
 	EEPROM_WORD_COUNT
 };
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9ff62b0..7b216f9 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -261,6 +261,48 @@ static const unsigned int rt2800_eeprom_map[EEPROM_WORD_COUNT] = {
 	[EEPROM_BBP_START]		= 0x0078,
 };
 
+static const unsigned int rt2800_eeprom_map_ext[EEPROM_WORD_COUNT] = {
+	[EEPROM_CHIP_ID]		= 0x0000,
+	[EEPROM_VERSION]		= 0x0001,
+	[EEPROM_MAC_ADDR_0]		= 0x0002,
+	[EEPROM_MAC_ADDR_1]		= 0x0003,
+	[EEPROM_MAC_ADDR_2]		= 0x0004,
+	[EEPROM_NIC_CONF0]		= 0x001a,
+	[EEPROM_NIC_CONF1]		= 0x001b,
+	[EEPROM_NIC_CONF2]		= 0x001c,
+	[EEPROM_EIRP_MAX_TX_POWER]	= 0x0020,
+	[EEPROM_FREQ]			= 0x0022,
+	[EEPROM_LED_AG_CONF]		= 0x0023,
+	[EEPROM_LED_ACT_CONF]		= 0x0024,
+	[EEPROM_LED_POLARITY]		= 0x0025,
+	[EEPROM_LNA]			= 0x0026,
+	[EEPROM_EXT_LNA2]		= 0x0027,
+	[EEPROM_RSSI_BG]		= 0x0028,
+	[EEPROM_TXPOWER_DELTA]		= 0x0028, /* Overlaps with RSSI_BG */
+	[EEPROM_RSSI_BG2]		= 0x0029,
+	[EEPROM_TXMIXER_GAIN_BG]	= 0x0029, /* Overlaps with RSSI_BG2 */
+	[EEPROM_RSSI_A]			= 0x002a,
+	[EEPROM_RSSI_A2]		= 0x002b,
+	[EEPROM_TXMIXER_GAIN_A]		= 0x002b, /* Overlaps with RSSI_A2 */
+	[EEPROM_TXPOWER_BG1]		= 0x0030,
+	[EEPROM_TXPOWER_BG2]		= 0x0037,
+	[EEPROM_EXT_TXPOWER_BG3]	= 0x003e,
+	[EEPROM_TSSI_BOUND_BG1]		= 0x0045,
+	[EEPROM_TSSI_BOUND_BG2]		= 0x0046,
+	[EEPROM_TSSI_BOUND_BG3]		= 0x0047,
+	[EEPROM_TSSI_BOUND_BG4]		= 0x0048,
+	[EEPROM_TSSI_BOUND_BG5]		= 0x0049,
+	[EEPROM_TXPOWER_A1]		= 0x004b,
+	[EEPROM_TXPOWER_A2]		= 0x0065,
+	[EEPROM_EXT_TXPOWER_A3]		= 0x007f,
+	[EEPROM_TSSI_BOUND_A1]		= 0x009a,
+	[EEPROM_TSSI_BOUND_A2]		= 0x009b,
+	[EEPROM_TSSI_BOUND_A3]		= 0x009c,
+	[EEPROM_TSSI_BOUND_A4]		= 0x009d,
+	[EEPROM_TSSI_BOUND_A5]		= 0x009e,
+	[EEPROM_TXPOWER_BYRATE]		= 0x00a0,
+};
+
 static unsigned int rt2800_eeprom_word_index(struct rt2x00_dev *rt2x00dev,
 					     const enum rt2800_eeprom_word word)
 {
@@ -272,7 +314,11 @@ static unsigned int rt2800_eeprom_word_index(struct rt2x00_dev *rt2x00dev,
 		return 0;
 	}
 
-	map = rt2800_eeprom_map;
+	if (rt2x00_rt(rt2x00dev, RT3593))
+		map = rt2800_eeprom_map_ext;
+	else
+		map = rt2800_eeprom_map;
+
 	index = map[word];
 
 	if (WARN_ON(word != EEPROM_CHIP_ID && index == 0)) {
-- 
1.7.10

