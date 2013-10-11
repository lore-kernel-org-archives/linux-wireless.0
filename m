Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:42270 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175Ab3JKLTT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 07:19:19 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 3/5] rt2x00: rt2800lib: use rt2x00_has_cap_* helpers
Date: Fri, 11 Oct 2013 13:18:42 +0200
Message-Id: <1381490324-14746-3-git-send-email-juhosg@openwrt.org> (sfid-20131011_131922_485345_9E77F329)
In-Reply-To: <1381490324-14746-1-git-send-email-juhosg@openwrt.org>
References: <1381490324-14746-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the appropriate helper functions instead of
directly accessing the rt2x00dev->cap_flags field
to check device capability flags.

This improves readability of the code a bit.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a114cab..78b31e3 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1780,7 +1780,7 @@ void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 	rt2800_bbp_read(rt2x00dev, 3, &r3);
 
 	if (rt2x00_rt(rt2x00dev, RT3572) &&
-	    test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags))
+	    rt2x00_has_cap_bt_coexist(rt2x00dev))
 		rt2800_config_3572bt_ant(rt2x00dev);
 
 	/*
@@ -1792,7 +1792,7 @@ void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 		break;
 	case 2:
 		if (rt2x00_rt(rt2x00dev, RT3572) &&
-		    test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags))
+		    rt2x00_has_cap_bt_coexist(rt2x00dev))
 			rt2x00_set_field8(&r1, BBP1_TX_ANTENNA, 1);
 		else
 			rt2x00_set_field8(&r1, BBP1_TX_ANTENNA, 2);
@@ -1822,7 +1822,7 @@ void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 		break;
 	case 2:
 		if (rt2x00_rt(rt2x00dev, RT3572) &&
-		    test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags)) {
+		    rt2x00_has_cap_bt_coexist(rt2x00dev)) {
 			rt2x00_set_field8(&r3, BBP3_RX_ADC, 1);
 			rt2x00_set_field8(&r3, BBP3_RX_ANTENNA,
 				rt2x00dev->curr_band == IEEE80211_BAND_5GHZ);
@@ -2131,7 +2131,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 0);
 	rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 0);
 	rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 0);
-	if (test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags)) {
+	if (rt2x00_has_cap_bt_coexist(rt2x00dev)) {
 		if (rf->channel <= 14) {
 			rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
 			rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
@@ -2664,7 +2664,7 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 	if (rf->channel <= 14) {
 		int idx = rf->channel-1;
 
-		if (test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags)) {
+		if (rt2x00_has_cap_bt_coexist(rt2x00dev)) {
 			if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
 				/* r55/r59 value array of channel 1~14 */
 				static const char r55_bt_rev[] = {0x83, 0x83,
@@ -3210,8 +3210,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	if (rf->channel <= 14) {
 		if (!rt2x00_rt(rt2x00dev, RT5390) &&
 		    !rt2x00_rt(rt2x00dev, RT5392)) {
-			if (test_bit(CAPABILITY_EXTERNAL_LNA_BG,
-				     &rt2x00dev->cap_flags)) {
+			if (rt2x00_has_cap_external_lna_bg(rt2x00dev)) {
 				rt2800_bbp_write(rt2x00dev, 82, 0x62);
 				rt2800_bbp_write(rt2x00dev, 75, 0x46);
 			} else {
@@ -3236,7 +3235,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		if (rt2x00_rt(rt2x00dev, RT3593))
 			rt2800_bbp_write(rt2x00dev, 83, 0x9a);
 
-		if (test_bit(CAPABILITY_EXTERNAL_LNA_A, &rt2x00dev->cap_flags))
+		if (rt2x00_has_cap_external_lna_a(rt2x00dev))
 			rt2800_bbp_write(rt2x00dev, 75, 0x46);
 		else
 			rt2800_bbp_write(rt2x00dev, 75, 0x50);
@@ -3272,7 +3271,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		/* Turn on primary PAs */
 		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN,
 				   rf->channel > 14);
-		if (test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags))
+		if (rt2x00_has_cap_bt_coexist(rt2x00dev))
 			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN, 1);
 		else
 			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G0_EN,
@@ -3574,7 +3573,7 @@ static int rt2800_get_txpower_reg_delta(struct rt2x00_dev *rt2x00dev,
 {
 	int delta;
 
-	if (test_bit(CAPABILITY_POWER_LIMIT, &rt2x00dev->cap_flags))
+	if (rt2x00_has_cap_power_limit(rt2x00dev))
 		return 0;
 
 	/*
@@ -3603,7 +3602,7 @@ static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
 	if (rt2x00_rt(rt2x00dev, RT3593))
 		return min_t(u8, txpower, 0xc);
 
-	if (test_bit(CAPABILITY_POWER_LIMIT, &rt2x00dev->cap_flags)) {
+	if (rt2x00_has_cap_power_limit(rt2x00dev)) {
 		/*
 		 * Check if eirp txpower exceed txpower_limit.
 		 * We use OFDM 6M as criterion and its eirp txpower
@@ -5524,7 +5523,7 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 	ant = (div_mode == 3) ? 1 : 0;
 
 	/* check if this is a Bluetooth combo card */
-	if (test_bit(CAPABILITY_BT_COEXIST, &rt2x00dev->cap_flags)) {
+	if (rt2x00_has_cap_bt_coexist(rt2x00dev)) {
 		u32 reg;
 
 		rt2800_register_read(rt2x00dev, GPIO_CTRL, &reg);
@@ -5833,7 +5832,7 @@ static void rt2800_normal_mode_setup_3xxx(struct rt2x00_dev *rt2x00dev)
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
-		if (!test_bit(CAPABILITY_EXTERNAL_LNA_BG, &rt2x00dev->cap_flags))
+		if (!rt2x00_has_cap_external_lna_bg(rt2x00dev))
 			rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
 	}
 
-- 
1.7.10
