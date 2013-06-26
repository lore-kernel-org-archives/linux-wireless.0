Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:41239 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab3FZRzY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 13:55:24 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/5] rt2x00: rt2800lib: introduce rt2800_eeprom_word enum
Date: Wed, 26 Jun 2013 19:55:14 +0200
Message-Id: <1372269318-30233-2-git-send-email-juhosg@openwrt.org> (sfid-20130626_195528_416920_D9C75049)
In-Reply-To: <1372269318-30233-1-git-send-email-juhosg@openwrt.org>
References: <1372269318-30233-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch converts the EEPROM_* word address defines
into new enum values. The new enum type will be used
by new functions which will be introduced in subsequent
changes.

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800.h |   79 +++++++++++++++++-----------------
 1 file changed, 39 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index d78c495..0647039 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2206,28 +2206,59 @@ struct mac_iveiv_entry {
  * The wordsize of the EEPROM is 16 bits.
  */
 
-/*
- * Chip ID
- */
-#define EEPROM_CHIP_ID			0x0000
+enum rt2800_eeprom_word {
+	EEPROM_CHIP_ID		= 0x0000,
+	EEPROM_VERSION		= 0x0001,
+	EEPROM_MAC_ADDR_0	= 0x0002,
+	EEPROM_MAC_ADDR_1	= 0x0003,
+	EEPROM_MAC_ADDR_2	= 0x0004,
+	EEPROM_NIC_CONF0	= 0x001a,
+	EEPROM_NIC_CONF1	= 0x001b,
+	EEPROM_FREQ		= 0x001d,
+	EEPROM_LED_AG_CONF	= 0x001e,
+	EEPROM_LED_ACT_CONF	= 0x001f,
+	EEPROM_LED_POLARITY	= 0x0020,
+	EEPROM_NIC_CONF2	= 0x0021,
+	EEPROM_LNA		= 0x0022,
+	EEPROM_RSSI_BG		= 0x0023,
+	EEPROM_RSSI_BG2		= 0x0024,
+	EEPROM_TXMIXER_GAIN_BG	= 0x0024, /* overlaps with RSSI_BG2 */
+	EEPROM_RSSI_A		= 0x0025,
+	EEPROM_RSSI_A2		= 0x0026,
+	EEPROM_TXMIXER_GAIN_A	= 0x0026, /* overlaps with RSSI_A2 */
+	EEPROM_EIRP_MAX_TX_POWER = 0x0027,
+	EEPROM_TXPOWER_DELTA	= 0x0028,
+	EEPROM_TXPOWER_BG1	= 0x0029,
+	EEPROM_TXPOWER_BG2	= 0x0030,
+	EEPROM_TSSI_BOUND_BG1	= 0x0037,
+	EEPROM_TSSI_BOUND_BG2	= 0x0038,
+	EEPROM_TSSI_BOUND_BG3	= 0x0039,
+	EEPROM_TSSI_BOUND_BG4	= 0x003a,
+	EEPROM_TSSI_BOUND_BG5	= 0x003b,
+	EEPROM_TXPOWER_A1	= 0x003c,
+	EEPROM_TXPOWER_A2	= 0x0053,
+	EEPROM_TSSI_BOUND_A1	= 0x006a,
+	EEPROM_TSSI_BOUND_A2	= 0x006b,
+	EEPROM_TSSI_BOUND_A3	= 0x006c,
+	EEPROM_TSSI_BOUND_A4	= 0x006d,
+	EEPROM_TSSI_BOUND_A5	= 0x006e,
+	EEPROM_TXPOWER_BYRATE	= 0x006f,
+	EEPROM_BBP_START	= 0x0078,
+};
 
 /*
  * EEPROM Version
  */
-#define EEPROM_VERSION			0x0001
 #define EEPROM_VERSION_FAE		FIELD16(0x00ff)
 #define EEPROM_VERSION_VERSION		FIELD16(0xff00)
 
 /*
  * HW MAC address.
  */
-#define EEPROM_MAC_ADDR_0		0x0002
 #define EEPROM_MAC_ADDR_BYTE0		FIELD16(0x00ff)
 #define EEPROM_MAC_ADDR_BYTE1		FIELD16(0xff00)
-#define EEPROM_MAC_ADDR_1		0x0003
 #define EEPROM_MAC_ADDR_BYTE2		FIELD16(0x00ff)
 #define EEPROM_MAC_ADDR_BYTE3		FIELD16(0xff00)
-#define EEPROM_MAC_ADDR_2		0x0004
 #define EEPROM_MAC_ADDR_BYTE4		FIELD16(0x00ff)
 #define EEPROM_MAC_ADDR_BYTE5		FIELD16(0xff00)
 
@@ -2237,7 +2268,6 @@ struct mac_iveiv_entry {
  * TXPATH: 1: 1T, 2: 2T, 3: 3T
  * RF_TYPE: RFIC type
  */
-#define	EEPROM_NIC_CONF0		0x001a
 #define EEPROM_NIC_CONF0_RXPATH		FIELD16(0x000f)
 #define EEPROM_NIC_CONF0_TXPATH		FIELD16(0x00f0)
 #define EEPROM_NIC_CONF0_RF_TYPE		FIELD16(0x0f00)
@@ -2261,7 +2291,6 @@ struct mac_iveiv_entry {
  * BT_COEXIST: 0: disable, 1: enable
  * DAC_TEST: 0: disable, 1: enable
  */
-#define	EEPROM_NIC_CONF1		0x001b
 #define EEPROM_NIC_CONF1_HW_RADIO		FIELD16(0x0001)
 #define EEPROM_NIC_CONF1_EXTERNAL_TX_ALC		FIELD16(0x0002)
 #define EEPROM_NIC_CONF1_EXTERNAL_LNA_2G		FIELD16(0x0004)
@@ -2281,7 +2310,6 @@ struct mac_iveiv_entry {
 /*
  * EEPROM frequency
  */
-#define	EEPROM_FREQ			0x001d
 #define EEPROM_FREQ_OFFSET		FIELD16(0x00ff)
 #define EEPROM_FREQ_LED_MODE		FIELD16(0x7f00)
 #define EEPROM_FREQ_LED_POLARITY	FIELD16(0x1000)
@@ -2298,9 +2326,6 @@ struct mac_iveiv_entry {
  * POLARITY_GPIO_4: Polarity GPIO4 setting.
  * LED_MODE: Led mode.
  */
-#define EEPROM_LED_AG_CONF		0x001e
-#define EEPROM_LED_ACT_CONF		0x001f
-#define EEPROM_LED_POLARITY		0x0020
 #define EEPROM_LED_POLARITY_RDY_BG	FIELD16(0x0001)
 #define EEPROM_LED_POLARITY_RDY_A	FIELD16(0x0002)
 #define EEPROM_LED_POLARITY_ACT		FIELD16(0x0004)
@@ -2317,7 +2342,6 @@ struct mac_iveiv_entry {
  * TX_STREAM: 0: Reserved, 1: 1 Stream, 2: 2 Stream
  * CRYSTAL: 00: Reserved, 01: One crystal, 10: Two crystal, 11: Reserved
  */
-#define EEPROM_NIC_CONF2		0x0021
 #define EEPROM_NIC_CONF2_RX_STREAM		FIELD16(0x000f)
 #define EEPROM_NIC_CONF2_TX_STREAM		FIELD16(0x00f0)
 #define EEPROM_NIC_CONF2_CRYSTAL		FIELD16(0x0600)
@@ -2325,54 +2349,46 @@ struct mac_iveiv_entry {
 /*
  * EEPROM LNA
  */
-#define EEPROM_LNA			0x0022
 #define EEPROM_LNA_BG			FIELD16(0x00ff)
 #define EEPROM_LNA_A0			FIELD16(0xff00)
 
 /*
  * EEPROM RSSI BG offset
  */
-#define EEPROM_RSSI_BG			0x0023
 #define EEPROM_RSSI_BG_OFFSET0		FIELD16(0x00ff)
 #define EEPROM_RSSI_BG_OFFSET1		FIELD16(0xff00)
 
 /*
  * EEPROM RSSI BG2 offset
  */
-#define EEPROM_RSSI_BG2			0x0024
 #define EEPROM_RSSI_BG2_OFFSET2		FIELD16(0x00ff)
 #define EEPROM_RSSI_BG2_LNA_A1		FIELD16(0xff00)
 
 /*
  * EEPROM TXMIXER GAIN BG offset (note overlaps with EEPROM RSSI BG2).
  */
-#define EEPROM_TXMIXER_GAIN_BG		0x0024
 #define EEPROM_TXMIXER_GAIN_BG_VAL	FIELD16(0x0007)
 
 /*
  * EEPROM RSSI A offset
  */
-#define EEPROM_RSSI_A			0x0025
 #define EEPROM_RSSI_A_OFFSET0		FIELD16(0x00ff)
 #define EEPROM_RSSI_A_OFFSET1		FIELD16(0xff00)
 
 /*
  * EEPROM RSSI A2 offset
  */
-#define EEPROM_RSSI_A2			0x0026
 #define EEPROM_RSSI_A2_OFFSET2		FIELD16(0x00ff)
 #define EEPROM_RSSI_A2_LNA_A2		FIELD16(0xff00)
 
 /*
  * EEPROM TXMIXER GAIN A offset (note overlaps with EEPROM RSSI A2).
  */
-#define EEPROM_TXMIXER_GAIN_A		0x0026
 #define EEPROM_TXMIXER_GAIN_A_VAL	FIELD16(0x0007)
 
 /*
  * EEPROM EIRP Maximum TX power values(unit: dbm)
  */
-#define EEPROM_EIRP_MAX_TX_POWER	0x0027
 #define EEPROM_EIRP_MAX_TX_POWER_2GHZ	FIELD16(0x00ff)
 #define EEPROM_EIRP_MAX_TX_POWER_5GHZ	FIELD16(0xff00)
 
@@ -2383,7 +2399,6 @@ struct mac_iveiv_entry {
  * TYPE: 1: Plus the delta value, 0: minus the delta value
  * ENABLE: enable tx power compensation for 40BW
  */
-#define EEPROM_TXPOWER_DELTA		0x0028
 #define EEPROM_TXPOWER_DELTA_VALUE_2G	FIELD16(0x003f)
 #define EEPROM_TXPOWER_DELTA_TYPE_2G	FIELD16(0x0040)
 #define EEPROM_TXPOWER_DELTA_ENABLE_2G	FIELD16(0x0080)
@@ -2394,8 +2409,6 @@ struct mac_iveiv_entry {
 /*
  * EEPROM TXPOWER 802.11BG
  */
-#define	EEPROM_TXPOWER_BG1		0x0029
-#define	EEPROM_TXPOWER_BG2		0x0030
 #define EEPROM_TXPOWER_BG_SIZE		7
 #define EEPROM_TXPOWER_BG_1		FIELD16(0x00ff)
 #define EEPROM_TXPOWER_BG_2		FIELD16(0xff00)
@@ -2407,7 +2420,6 @@ struct mac_iveiv_entry {
  * MINUS3: If the actual TSSI is below this boundary, tx power needs to be
  *         reduced by (agc_step * -3)
  */
-#define EEPROM_TSSI_BOUND_BG1		0x0037
 #define EEPROM_TSSI_BOUND_BG1_MINUS4	FIELD16(0x00ff)
 #define EEPROM_TSSI_BOUND_BG1_MINUS3	FIELD16(0xff00)
 
@@ -2418,7 +2430,6 @@ struct mac_iveiv_entry {
  * MINUS1: If the actual TSSI is below this boundary, tx power needs to be
  *         reduced by (agc_step * -1)
  */
-#define EEPROM_TSSI_BOUND_BG2		0x0038
 #define EEPROM_TSSI_BOUND_BG2_MINUS2	FIELD16(0x00ff)
 #define EEPROM_TSSI_BOUND_BG2_MINUS1	FIELD16(0xff00)
 
@@ -2428,7 +2439,6 @@ struct mac_iveiv_entry {
  * PLUS1: If the actual TSSI is above this boundary, tx power needs to be
  *        increased by (agc_step * 1)
  */
-#define EEPROM_TSSI_BOUND_BG3		0x0039
 #define EEPROM_TSSI_BOUND_BG3_REF	FIELD16(0x00ff)
 #define EEPROM_TSSI_BOUND_BG3_PLUS1	FIELD16(0xff00)
 
@@ -2439,7 +2449,6 @@ struct mac_iveiv_entry {
  * PLUS3: If the actual TSSI is above this boundary, tx power needs to be
  *        increased by (agc_step * 3)
  */
-#define EEPROM_TSSI_BOUND_BG4		0x003a
 #define EEPROM_TSSI_BOUND_BG4_PLUS2	FIELD16(0x00ff)
 #define EEPROM_TSSI_BOUND_BG4_PLUS3	FIELD16(0xff00)
 
@@ -2449,15 +2458,12 @@ struct mac_iveiv_entry {
  *        increased by (agc_step * 4)
  * AGC_STEP: Temperature compensation step.
  */
-#define EEPROM_TSSI_BOUND_BG5		0x003b
 #define EEPROM_TSSI_BOUND_BG5_PLUS4	FIELD16(0x00ff)
 #define EEPROM_TSSI_BOUND_BG5_AGC_STEP	FIELD16(0xff00)
 
 /*
  * EEPROM TXPOWER 802.11A
  */
-#define EEPROM_TXPOWER_A1		0x003c
-#define EEPROM_TXPOWER_A2		0x0053
 #define EEPROM_TXPOWER_A_SIZE		6
 #define EEPROM_TXPOWER_A_1		FIELD16(0x00ff)
 #define EEPROM_TXPOWER_A_2		FIELD16(0xff00)
@@ -2469,7 +2475,6 @@ struct mac_iveiv_entry {
  * MINUS3: If the actual TSSI is below this boundary, tx power needs to be
  *         reduced by (agc_step * -3)
  */
-#define EEPROM_TSSI_BOUND_A1		0x006a
 #define EEPROM_TSSI_BOUND_A1_MINUS4	FIELD16(0x00ff)
 #define EEPROM_TSSI_BOUND_A1_MINUS3	FIELD16(0xff00)
 
@@ -2480,7 +2485,6 @@ struct mac_iveiv_entry {
  * MINUS1: If the actual TSSI is below this boundary, tx power needs to be
  *         reduced by (agc_step * -1)
  */
-#define EEPROM_TSSI_BOUND_A2		0x006b
 #define EEPROM_TSSI_BOUND_A2_MINUS2	FIELD16(0x00ff)
 #define EEPROM_TSSI_BOUND_A2_MINUS1	FIELD16(0xff00)
 
@@ -2490,7 +2494,6 @@ struct mac_iveiv_entry {
  * PLUS1: If the actual TSSI is above this boundary, tx power needs to be
  *        increased by (agc_step * 1)
  */
-#define EEPROM_TSSI_BOUND_A3		0x006c
 #define EEPROM_TSSI_BOUND_A3_REF	FIELD16(0x00ff)
 #define EEPROM_TSSI_BOUND_A3_PLUS1	FIELD16(0xff00)
 
@@ -2501,7 +2504,6 @@ struct mac_iveiv_entry {
  * PLUS3: If the actual TSSI is above this boundary, tx power needs to be
  *        increased by (agc_step * 3)
  */
-#define EEPROM_TSSI_BOUND_A4		0x006d
 #define EEPROM_TSSI_BOUND_A4_PLUS2	FIELD16(0x00ff)
 #define EEPROM_TSSI_BOUND_A4_PLUS3	FIELD16(0xff00)
 
@@ -2511,14 +2513,12 @@ struct mac_iveiv_entry {
  *        increased by (agc_step * 4)
  * AGC_STEP: Temperature compensation step.
  */
-#define EEPROM_TSSI_BOUND_A5		0x006e
 #define EEPROM_TSSI_BOUND_A5_PLUS4	FIELD16(0x00ff)
 #define EEPROM_TSSI_BOUND_A5_AGC_STEP	FIELD16(0xff00)
 
 /*
  * EEPROM TXPOWER by rate: tx power per tx rate for HT20 mode
  */
-#define EEPROM_TXPOWER_BYRATE		0x006f
 #define EEPROM_TXPOWER_BYRATE_SIZE	9
 
 #define EEPROM_TXPOWER_BYRATE_RATE0	FIELD16(0x000f)
@@ -2529,7 +2529,6 @@ struct mac_iveiv_entry {
 /*
  * EEPROM BBP.
  */
-#define	EEPROM_BBP_START		0x0078
 #define EEPROM_BBP_SIZE			16
 #define EEPROM_BBP_VALUE		FIELD16(0x00ff)
 #define EEPROM_BBP_REG_ID		FIELD16(0xff00)
-- 
1.7.10

