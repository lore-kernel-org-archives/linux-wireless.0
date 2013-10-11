Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:42270 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175Ab3JKLTV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 07:19:21 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 5/5] rt2x00: rt73usb: use rt2x00_has_cap_* helpers
Date: Fri, 11 Oct 2013 13:18:44 +0200
Message-Id: <1381490324-14746-5-git-send-email-juhosg@openwrt.org> (sfid-20131011_131926_685876_EAD11A20)
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
 drivers/net/wireless/rt2x00/rt73usb.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 1d3880e..1baf9c8 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -595,8 +595,8 @@ static void rt73usb_config_antenna_5x(struct rt2x00_dev *rt2x00dev,
 	switch (ant->rx) {
 	case ANTENNA_HW_DIVERSITY:
 		rt2x00_set_field8(&r4, BBP_R4_RX_ANTENNA_CONTROL, 2);
-		temp = !test_bit(CAPABILITY_FRAME_TYPE, &rt2x00dev->cap_flags)
-		       && (rt2x00dev->curr_band != IEEE80211_BAND_5GHZ);
+		temp = !rt2x00_has_cap_frame_type(rt2x00dev) &&
+		       (rt2x00dev->curr_band != IEEE80211_BAND_5GHZ);
 		rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END, temp);
 		break;
 	case ANTENNA_A:
@@ -636,7 +636,7 @@ static void rt73usb_config_antenna_2x(struct rt2x00_dev *rt2x00dev,
 
 	rt2x00_set_field8(&r3, BBP_R3_SMART_MODE, 0);
 	rt2x00_set_field8(&r4, BBP_R4_RX_FRAME_END,
-			  !test_bit(CAPABILITY_FRAME_TYPE, &rt2x00dev->cap_flags));
+			  !rt2x00_has_cap_frame_type(rt2x00dev));
 
 	/*
 	 * Configure the RX antenna.
@@ -709,10 +709,10 @@ static void rt73usb_config_ant(struct rt2x00_dev *rt2x00dev,
 
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
@@ -740,7 +740,7 @@ static void rt73usb_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 	short lna_gain = 0;
 
 	if (libconf->conf->chandef.chan->band == IEEE80211_BAND_2GHZ) {
-		if (test_bit(CAPABILITY_EXTERNAL_LNA_BG, &rt2x00dev->cap_flags))
+		if (rt2x00_has_cap_external_lna_bg(rt2x00dev))
 			lna_gain += 14;
 
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_OFFSET_BG, &eeprom);
@@ -930,7 +930,7 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev,
 		low_bound = 0x28;
 		up_bound = 0x48;
 
-		if (test_bit(CAPABILITY_EXTERNAL_LNA_A, &rt2x00dev->cap_flags)) {
+		if (rt2x00_has_cap_external_lna_a(rt2x00dev)) {
 			low_bound += 0x10;
 			up_bound += 0x10;
 		}
@@ -946,7 +946,7 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev,
 			up_bound = 0x1c;
 		}
 
-		if (test_bit(CAPABILITY_EXTERNAL_LNA_BG, &rt2x00dev->cap_flags)) {
+		if (rt2x00_has_cap_external_lna_bg(rt2x00dev)) {
 			low_bound += 0x14;
 			up_bound += 0x10;
 		}
@@ -1661,7 +1661,7 @@ static int rt73usb_agc_to_rssi(struct rt2x00_dev *rt2x00dev, int rxd_w1)
 	}
 
 	if (rt2x00dev->curr_band == IEEE80211_BAND_5GHZ) {
-		if (test_bit(CAPABILITY_EXTERNAL_LNA_A, &rt2x00dev->cap_flags)) {
+		if (rt2x00_has_cap_external_lna_a(rt2x00dev)) {
 			if (lna == 3 || lna == 2)
 				offset += 10;
 		} else {
-- 
1.7.10
