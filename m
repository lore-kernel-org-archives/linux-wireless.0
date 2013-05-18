Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:12287 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab3ERMDU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:03:20 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:03:18 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 31/32] rt2800: move 3290 specific bbp initialization
Date: Sat, 18 May 2013 14:03:54 +0200
Message-Id: <1368878635-4455-32-git-send-email-stf_xl@wp.pl> (sfid-20130518_142936_775281_073DEE41)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   46 +++++++++++++++---------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index ad191d5..1e58180 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4084,6 +4084,8 @@ static void rt2800_init_bbp_30xx(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 {
+	u8 value;
+
 	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
 
 	rt2800_bbp_write(rt2x00dev, 31, 0x08);
@@ -4128,6 +4130,27 @@ static void rt2800_init_bbp_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 106, 0x03);
 
 	rt2800_bbp_write(rt2x00dev, 128, 0x12);
+
+	rt2800_bbp_write(rt2x00dev, 67, 0x24);
+	rt2800_bbp_write(rt2x00dev, 143, 0x04);
+	rt2800_bbp_write(rt2x00dev, 142, 0x99);
+	rt2800_bbp_write(rt2x00dev, 150, 0x30);
+	rt2800_bbp_write(rt2x00dev, 151, 0x2e);
+	rt2800_bbp_write(rt2x00dev, 152, 0x20);
+	rt2800_bbp_write(rt2x00dev, 153, 0x34);
+	rt2800_bbp_write(rt2x00dev, 154, 0x40);
+	rt2800_bbp_write(rt2x00dev, 155, 0x3b);
+	rt2800_bbp_write(rt2x00dev, 253, 0x04);
+
+	rt2800_bbp_read(rt2x00dev, 47, &value);
+	rt2x00_set_field8(&value, BBP47_TSSI_ADC6, 1);
+	rt2800_bbp_write(rt2x00dev, 47, value);
+
+	/* Use 5-bit ADC for Acquisition and 8-bit ADC for data */
+	rt2800_bbp_read(rt2x00dev, 3, &value);
+	rt2x00_set_field8(&value, BBP3_ADC_MODE_SWITCH, 1);
+	rt2x00_set_field8(&value, BBP3_ADC_INIT_MODE, 1);
+	rt2800_bbp_write(rt2x00dev, 3, value);
 }
 
 static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
@@ -4462,29 +4485,6 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		return;
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3290)) {
-		rt2800_bbp_write(rt2x00dev, 67, 0x24);
-		rt2800_bbp_write(rt2x00dev, 143, 0x04);
-		rt2800_bbp_write(rt2x00dev, 142, 0x99);
-		rt2800_bbp_write(rt2x00dev, 150, 0x30);
-		rt2800_bbp_write(rt2x00dev, 151, 0x2e);
-		rt2800_bbp_write(rt2x00dev, 152, 0x20);
-		rt2800_bbp_write(rt2x00dev, 153, 0x34);
-		rt2800_bbp_write(rt2x00dev, 154, 0x40);
-		rt2800_bbp_write(rt2x00dev, 155, 0x3b);
-		rt2800_bbp_write(rt2x00dev, 253, 0x04);
-
-		rt2800_bbp_read(rt2x00dev, 47, &value);
-		rt2x00_set_field8(&value, BBP47_TSSI_ADC6, 1);
-		rt2800_bbp_write(rt2x00dev, 47, value);
-
-		/* Use 5-bit ADC for Acquisition and 8-bit ADC for data */
-		rt2800_bbp_read(rt2x00dev, 3, &value);
-		rt2x00_set_field8(&value, BBP3_ADC_MODE_SWITCH, 1);
-		rt2x00_set_field8(&value, BBP3_ADC_INIT_MODE, 1);
-		rt2800_bbp_write(rt2x00dev, 3, value);
-	}
-
 	if (rt2x00_rt(rt2x00dev, RT5390) ||
 	    rt2x00_rt(rt2x00dev, RT5392)) {
 		int ant, div_mode;
-- 
1.7.4.4

