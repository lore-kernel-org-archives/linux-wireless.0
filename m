Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48674 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321Ab3GHJ0E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 05:26:04 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 4/5] rt2x00: rt2800lib: introduce rt2800_eeprom_word_index helper
Date: Mon,  8 Jul 2013 11:25:55 +0200
Message-Id: <1373275556-6482-5-git-send-email-juhosg@openwrt.org> (sfid-20130708_112613_317384_AE43F2C0)
In-Reply-To: <1373275556-6482-1-git-send-email-juhosg@openwrt.org>
References: <1373275556-6482-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of assign the offset value to the
enum directly use a new helper function to
convert a rt2800_eeprom_word enum into an
index of the rt2x00_dev->eeprom array.

The patch does not change the existing
behaviour, but makes it possible to add
support for three-chain devices which are
using a different EEPROM layout.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
Changes since v1:
  - use WARN_ONCE and remove the rt2x00_warn calls
---
 drivers/net/wireless/rt2x00/rt2800.h    |   76 ++++++++++++++-------------
 drivers/net/wireless/rt2x00/rt2800lib.c |   87 +++++++++++++++++++++++++++++--
 2 files changed, 122 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 0647039..bc5c695 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2207,43 +2207,45 @@ struct mac_iveiv_entry {
  */
 
 enum rt2800_eeprom_word {
-	EEPROM_CHIP_ID		= 0x0000,
-	EEPROM_VERSION		= 0x0001,
-	EEPROM_MAC_ADDR_0	= 0x0002,
-	EEPROM_MAC_ADDR_1	= 0x0003,
-	EEPROM_MAC_ADDR_2	= 0x0004,
-	EEPROM_NIC_CONF0	= 0x001a,
-	EEPROM_NIC_CONF1	= 0x001b,
-	EEPROM_FREQ		= 0x001d,
-	EEPROM_LED_AG_CONF	= 0x001e,
-	EEPROM_LED_ACT_CONF	= 0x001f,
-	EEPROM_LED_POLARITY	= 0x0020,
-	EEPROM_NIC_CONF2	= 0x0021,
-	EEPROM_LNA		= 0x0022,
-	EEPROM_RSSI_BG		= 0x0023,
-	EEPROM_RSSI_BG2		= 0x0024,
-	EEPROM_TXMIXER_GAIN_BG	= 0x0024, /* overlaps with RSSI_BG2 */
-	EEPROM_RSSI_A		= 0x0025,
-	EEPROM_RSSI_A2		= 0x0026,
-	EEPROM_TXMIXER_GAIN_A	= 0x0026, /* overlaps with RSSI_A2 */
-	EEPROM_EIRP_MAX_TX_POWER = 0x0027,
-	EEPROM_TXPOWER_DELTA	= 0x0028,
-	EEPROM_TXPOWER_BG1	= 0x0029,
-	EEPROM_TXPOWER_BG2	= 0x0030,
-	EEPROM_TSSI_BOUND_BG1	= 0x0037,
-	EEPROM_TSSI_BOUND_BG2	= 0x0038,
-	EEPROM_TSSI_BOUND_BG3	= 0x0039,
-	EEPROM_TSSI_BOUND_BG4	= 0x003a,
-	EEPROM_TSSI_BOUND_BG5	= 0x003b,
-	EEPROM_TXPOWER_A1	= 0x003c,
-	EEPROM_TXPOWER_A2	= 0x0053,
-	EEPROM_TSSI_BOUND_A1	= 0x006a,
-	EEPROM_TSSI_BOUND_A2	= 0x006b,
-	EEPROM_TSSI_BOUND_A3	= 0x006c,
-	EEPROM_TSSI_BOUND_A4	= 0x006d,
-	EEPROM_TSSI_BOUND_A5	= 0x006e,
-	EEPROM_TXPOWER_BYRATE	= 0x006f,
-	EEPROM_BBP_START	= 0x0078,
+	EEPROM_CHIP_ID = 0,
+	EEPROM_VERSION,
+	EEPROM_MAC_ADDR_0,
+	EEPROM_MAC_ADDR_1,
+	EEPROM_MAC_ADDR_2,
+	EEPROM_NIC_CONF0,
+	EEPROM_NIC_CONF1,
+	EEPROM_FREQ,
+	EEPROM_LED_AG_CONF,
+	EEPROM_LED_ACT_CONF,
+	EEPROM_LED_POLARITY,
+	EEPROM_NIC_CONF2,
+	EEPROM_LNA,
+	EEPROM_RSSI_BG,
+	EEPROM_RSSI_BG2,
+	EEPROM_TXMIXER_GAIN_BG,
+	EEPROM_RSSI_A,
+	EEPROM_RSSI_A2,
+	EEPROM_TXMIXER_GAIN_A,
+	EEPROM_EIRP_MAX_TX_POWER,
+	EEPROM_TXPOWER_DELTA,
+	EEPROM_TXPOWER_BG1,
+	EEPROM_TXPOWER_BG2,
+	EEPROM_TSSI_BOUND_BG1,
+	EEPROM_TSSI_BOUND_BG2,
+	EEPROM_TSSI_BOUND_BG3,
+	EEPROM_TSSI_BOUND_BG4,
+	EEPROM_TSSI_BOUND_BG5,
+	EEPROM_TXPOWER_A1,
+	EEPROM_TXPOWER_A2,
+	EEPROM_TSSI_BOUND_A1,
+	EEPROM_TSSI_BOUND_A2,
+	EEPROM_TSSI_BOUND_A3,
+	EEPROM_TSSI_BOUND_A4,
+	EEPROM_TSSI_BOUND_A5,
+	EEPROM_TXPOWER_BYRATE,
+	EEPROM_BBP_START,
+	/* New values must be added before this */
+	EEPROM_WORD_COUNT
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index b59772a..41a34de4a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -221,22 +221,98 @@ static void rt2800_rf_write(struct rt2x00_dev *rt2x00dev,
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
+static const unsigned int rt2800_eeprom_map[EEPROM_WORD_COUNT] = {
+	[EEPROM_CHIP_ID]		= 0x0000,
+	[EEPROM_VERSION]		= 0x0001,
+	[EEPROM_MAC_ADDR_0]		= 0x0002,
+	[EEPROM_MAC_ADDR_1]		= 0x0003,
+	[EEPROM_MAC_ADDR_2]		= 0x0004,
+	[EEPROM_NIC_CONF0]		= 0x001a,
+	[EEPROM_NIC_CONF1]		= 0x001b,
+	[EEPROM_FREQ]			= 0x001d,
+	[EEPROM_LED_AG_CONF]		= 0x001e,
+	[EEPROM_LED_ACT_CONF]		= 0x001f,
+	[EEPROM_LED_POLARITY]		= 0x0020,
+	[EEPROM_NIC_CONF2]		= 0x0021,
+	[EEPROM_LNA]			= 0x0022,
+	[EEPROM_RSSI_BG]		= 0x0023,
+	[EEPROM_RSSI_BG2]		= 0x0024,
+	[EEPROM_TXMIXER_GAIN_BG]	= 0x0024, /* overlaps with RSSI_BG2 */
+	[EEPROM_RSSI_A]			= 0x0025,
+	[EEPROM_RSSI_A2]		= 0x0026,
+	[EEPROM_TXMIXER_GAIN_A]		= 0x0026, /* overlaps with RSSI_A2 */
+	[EEPROM_EIRP_MAX_TX_POWER]	= 0x0027,
+	[EEPROM_TXPOWER_DELTA]		= 0x0028,
+	[EEPROM_TXPOWER_BG1]		= 0x0029,
+	[EEPROM_TXPOWER_BG2]		= 0x0030,
+	[EEPROM_TSSI_BOUND_BG1]		= 0x0037,
+	[EEPROM_TSSI_BOUND_BG2]		= 0x0038,
+	[EEPROM_TSSI_BOUND_BG3]		= 0x0039,
+	[EEPROM_TSSI_BOUND_BG4]		= 0x003a,
+	[EEPROM_TSSI_BOUND_BG5]		= 0x003b,
+	[EEPROM_TXPOWER_A1]		= 0x003c,
+	[EEPROM_TXPOWER_A2]		= 0x0053,
+	[EEPROM_TSSI_BOUND_A1]		= 0x006a,
+	[EEPROM_TSSI_BOUND_A2]		= 0x006b,
+	[EEPROM_TSSI_BOUND_A3]		= 0x006c,
+	[EEPROM_TSSI_BOUND_A4]		= 0x006d,
+	[EEPROM_TSSI_BOUND_A5]		= 0x006e,
+	[EEPROM_TXPOWER_BYRATE]		= 0x006f,
+	[EEPROM_BBP_START]		= 0x0078,
+};
+
+static unsigned int rt2800_eeprom_word_index(struct rt2x00_dev *rt2x00dev,
+					     const enum rt2800_eeprom_word word)
+{
+	const unsigned int *map;
+	unsigned int index;
+
+	if (WARN_ONCE(word >= EEPROM_WORD_COUNT,
+		      "%s: invalid EEPROM word %d\n",
+		      wiphy_name(rt2x00dev->hw->wiphy), word))
+		return 0;
+
+	map = rt2800_eeprom_map;
+	index = map[word];
+
+	/* Index 0 is valid only for EEPROM_CHIP_ID.
+	 * Otherwise it means that the offset of the
+	 * given word is not initialized in the map,
+	 * or that the field is not usable on the
+	 * actual chipset.
+	 */
+	WARN_ONCE(word != EEPROM_CHIP_ID && index == 0,
+		  "%s: invalid access of EEPROM word %d\n",
+		  wiphy_name(rt2x00dev->hw->wiphy), word);
+
+	return index;
+}
+
 static void *rt2800_eeprom_addr(struct rt2x00_dev *rt2x00dev,
 				const enum rt2800_eeprom_word word)
 {
-	return rt2x00_eeprom_addr(rt2x00dev, word);
+	unsigned int index;
+
+	index = rt2800_eeprom_word_index(rt2x00dev, word);
+	return rt2x00_eeprom_addr(rt2x00dev, index);
 }
 
 static void rt2800_eeprom_read(struct rt2x00_dev *rt2x00dev,
 			       const enum rt2800_eeprom_word word, u16 *data)
 {
-	rt2x00_eeprom_read(rt2x00dev, word, data);
+	unsigned int index;
+
+	index = rt2800_eeprom_word_index(rt2x00dev, word);
+	rt2x00_eeprom_read(rt2x00dev, index, data);
 }
 
 static void rt2800_eeprom_write(struct rt2x00_dev *rt2x00dev,
 				const enum rt2800_eeprom_word word, u16 data)
 {
-	rt2x00_eeprom_write(rt2x00dev, word, data);
+	unsigned int index;
+
+	index = rt2800_eeprom_word_index(rt2x00dev, word);
+	rt2x00_eeprom_write(rt2x00dev, index, data);
 }
 
 static void rt2800_eeprom_read_from_array(struct rt2x00_dev *rt2x00dev,
@@ -244,7 +320,10 @@ static void rt2800_eeprom_read_from_array(struct rt2x00_dev *rt2x00dev,
 					  unsigned int offset,
 					  u16 *data)
 {
-	rt2x00_eeprom_read(rt2x00dev, array + offset, data);
+	unsigned int index;
+
+	index = rt2800_eeprom_word_index(rt2x00dev, array);
+	rt2x00_eeprom_read(rt2x00dev, index + offset, data);
 }
 
 static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
-- 
1.7.10

