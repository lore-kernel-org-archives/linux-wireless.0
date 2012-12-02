Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:53244 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab2LBOxc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 09:53:32 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 1/2] rt2x00: rt2800lib: fix indentation of some rt2x00_rt calls
Date: Sun,  2 Dec 2012 15:53:28 +0100
Message-Id: <1354460009-28449-2-git-send-email-juhosg@openwrt.org> (sfid-20121202_155338_970311_D19846B3)
In-Reply-To: <1354460009-28449-1-git-send-email-juhosg@openwrt.org>
References: <1354460009-28449-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch contains no functional changes.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c0441a7..3d7b74e 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2173,7 +2173,7 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 				rt2800_rfcsr_write(rt2x00dev, 59,
 						   r59_nonbt_rev[idx]);
 			} else if (rt2x00_rt(rt2x00dev, RT5390) ||
-					   rt2x00_rt(rt2x00dev, RT5392)) {
+				   rt2x00_rt(rt2x00dev, RT5392)) {
 				static const char r59_non_bt[] = {0x8f, 0x8f,
 					0x8f, 0x8f, 0x8f, 0x8f, 0x8f, 0x8d,
 					0x8a, 0x88, 0x88, 0x87, 0x87, 0x86};
@@ -2264,7 +2264,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 
 	if (rf->channel <= 14) {
 		if (!rt2x00_rt(rt2x00dev, RT5390) &&
-			!rt2x00_rt(rt2x00dev, RT5392)) {
+		    !rt2x00_rt(rt2x00dev, RT5392)) {
 			if (test_bit(CAPABILITY_EXTERNAL_LNA_BG,
 				     &rt2x00dev->cap_flags)) {
 				rt2800_bbp_write(rt2x00dev, 82, 0x62);
@@ -3592,8 +3592,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860D))
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
 	else if (rt2x00_rt(rt2x00dev, RT3290) ||
-		     rt2x00_rt(rt2x00dev, RT5390) ||
-		     rt2x00_rt(rt2x00dev, RT5392))
+		 rt2x00_rt(rt2x00dev, RT5390) ||
+		 rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 84, 0x9a);
 	else
 		rt2800_bbp_write(rt2x00dev, 84, 0x99);
@@ -3652,7 +3652,7 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	else if (rt2x00_rt(rt2x00dev, RT3352))
 		rt2800_bbp_write(rt2x00dev, 105, 0x34);
 	else if (rt2x00_rt(rt2x00dev, RT5390) ||
-			 rt2x00_rt(rt2x00dev, RT5392))
+		 rt2x00_rt(rt2x00dev, RT5392))
 		rt2800_bbp_write(rt2x00dev, 105, 0x3c);
 	else
 		rt2800_bbp_write(rt2x00dev, 105, 0x05);
@@ -3746,7 +3746,7 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	}
 
 	if (rt2x00_rt(rt2x00dev, RT5390) ||
-		rt2x00_rt(rt2x00dev, RT5392)) {
+	    rt2x00_rt(rt2x00dev, RT5392)) {
 		int ant, div_mode;
 
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
@@ -4356,7 +4356,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_read(rt2x00dev, 26, &drv_data->bbp26);
 
 	if (!rt2x00_rt(rt2x00dev, RT5390) &&
-		!rt2x00_rt(rt2x00dev, RT5392)) {
+	    !rt2x00_rt(rt2x00dev, RT5392)) {
 		/*
 		 * Set back to initial state
 		 */
@@ -4385,7 +4385,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
 
 	if (!rt2x00_rt(rt2x00dev, RT5390) &&
-		!rt2x00_rt(rt2x00dev, RT5392)) {
+	    !rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
@@ -4457,7 +4457,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	}
 
 	if (rt2x00_rt(rt2x00dev, RT5390) ||
-		rt2x00_rt(rt2x00dev, RT5392)) {
+	    rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_rfcsr_read(rt2x00dev, 38, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR38_RX_LO1_EN, 0);
 		rt2800_rfcsr_write(rt2x00dev, 38, rfcsr);
-- 
1.7.10

