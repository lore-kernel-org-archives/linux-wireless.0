Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:42279 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932163Ab3JKLTU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 07:19:20 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 4/5] rt2x00: rt61pci: use rt2x00_has_cap_* helpers
Date: Fri, 11 Oct 2013 13:18:43 +0200
Message-Id: <1381490324-14746-4-git-send-email-juhosg@openwrt.org> (sfid-20131011_131924_604042_720DE068)
In-Reply-To: <1381490324-14746-1-git-send-email-juhosg@openwrt.org>
References: <1381490324-14746-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the appropriate helper functions instead of
directly accessing the rt2x00dev->cap_flags field
to check device capability flags.

This improves readability of the code a bit.

Compile tested only.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt61pci.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 54d3ddf..a5b69cb 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -685,7 +685,7 @@ static void rt61pci_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, rt2x00_rf(rt2x00dev, RF2529));
 	rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-			  !test_bit(CAPABILITY_FRAME_TYPE, &rt2x00dev->cap_flags));
+			  !rt2x00_has_cap_frame_type(rt2x00dev));
 
 	/*
 	 * Configure the RX antenna.
@@ -813,10 +813,10 @@ static void rt61pci_config_ant(struct rt2x00_dev *rt2x00dev,
 
 	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
 		sel = antenna_sel_a;
-		lna = test_bit(CAPABILITY_EXTERNAL_LNA_A, &rt2x00dev->cap_flags);
+		lna = rt2x00_has_cap_external_lna_a(rt2x00dev);
 	} else {
 		sel = antenna_sel_bg;
-		lna = test_bit(CAPABILITY_EXTERNAL_LNA_BG, &rt2x00dev->cap_flags);
+		lna = rt2x00_has_cap_external_lna_bg(rt2x00dev);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(antenna_sel_a); i++)
@@ -836,7 +836,7 @@ static void rt61pci_config_ant(struct rt2x00_dev *rt2x00dev,
 	else if (rt2x00_rf(rt2x00dev, RF2527))
 		rt61pci_config_antenna_2x(rt2x00dev, ant);
 	else if (rt2x00_rf(rt2x00dev, RF2529)) {
-		if (test_bit(CAPABILITY_DOUBLE_ANTENNA, &rt2x00dev->cap_flags))
+		if (rt2x00_has_cap_double_antenna(rt2x00dev))
 			rt61pci_config_antenna_2x(rt2x00dev, ant);
 		else
 			rt61pci_config_antenna_2529(rt2x00dev, ant);
@@ -850,13 +850,13 @@ static void rt61pci_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 	short lna_gain = 0;
 
 	if (libconf->conf->chandef.chan->band == IEEE80211_BAND_2GHZ) {
-		if (test_bit(CAPABILITY_EXTERNAL_LNA_BG, &rt2x00dev->cap_flags))
+		if (rt2x00_has_cap_external_lna_bg(rt2x00dev))
 			lna_gain += 14;
 
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_OFFSET_BG, &eeprom);
 		lna_gain -= rt2x00_get_field16(eeprom, EEPROM_RSSI_OFFSET_BG_1);
 	} else {
-		if (test_bit(CAPABILITY_EXTERNAL_LNA_A, &rt2x00dev->cap_flags))
+		if (rt2x00_has_cap_external_lna_a(rt2x00dev))
 			lna_gain += 14;
 
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_OFFSET_A, &eeprom);
@@ -1054,14 +1054,14 @@ static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
 		low_bound = 0x28;
 		up_bound = 0x48;
-		if (test_bit(CAPABILITY_EXTERNAL_LNA_A, &rt2x00dev->cap_flags)) {
+		if (rt2x00_has_cap_external_lna_a(rt2x00dev)) {
 			low_bound += 0x10;
 			up_bound += 0x10;
 		}
 	} else {
 		low_bound = 0x20;
 		up_bound = 0x40;
-		if (test_bit(CAPABILITY_EXTERNAL_LNA_BG, &rt2x00dev->cap_flags)) {
+		if (rt2x00_has_cap_external_lna_bg(rt2x00dev)) {
 			low_bound += 0x10;
 			up_bound += 0x10;
 		}
@@ -2578,7 +2578,7 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * eeprom word.
 	 */
 	if (rt2x00_rf(rt2x00dev, RF2529) &&
-	    !test_bit(CAPABILITY_DOUBLE_ANTENNA, &rt2x00dev->cap_flags)) {
+	    !rt2x00_has_cap_double_antenna(rt2x00dev)) {
 		rt2x00dev->default_ant.rx =
 		    ANTENNA_A + rt2x00_get_field16(eeprom, EEPROM_NIC_RX_FIXED);
 		rt2x00dev->default_ant.tx =
@@ -2793,7 +2793,7 @@ static int rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->supported_bands = SUPPORT_BAND_2GHZ;
 	spec->supported_rates = SUPPORT_RATE_CCK | SUPPORT_RATE_OFDM;
 
-	if (!test_bit(CAPABILITY_RF_SEQUENCE, &rt2x00dev->cap_flags)) {
+	if (!rt2x00_has_cap_rf_sequence(rt2x00dev)) {
 		spec->num_channels = 14;
 		spec->channels = rf_vals_noseq;
 	} else {
-- 
1.7.10
