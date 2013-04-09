Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:5641 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932898Ab3DIPEw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 11:04:52 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 06/11] rt2800: move RFCSR6_R2 & LDO_CFG0 setup to 3572 specific rfcsr init
Date: Tue,  9 Apr 2013 17:05:25 +0200
Message-Id: <1365519930-3230-7-git-send-email-stf_xl@wp.pl> (sfid-20130409_170457_029275_7ED80BF1)
In-Reply-To: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   34 +++++++++++++++---------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 83554da..7130040 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4710,6 +4710,9 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
 {
+	u8 rfcsr;
+	u32 reg;
+
 	rt2800_rfcsr_write(rt2x00dev, 0, 0x70);
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x81);
 	rt2800_rfcsr_write(rt2x00dev, 2, 0xf1);
@@ -4741,6 +4744,20 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 29, 0x9b);
 	rt2800_rfcsr_write(rt2x00dev, 30, 0x09);
 	rt2800_rfcsr_write(rt2x00dev, 31, 0x10);
+
+	rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
+	rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
+
+	rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
+	rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
+	rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
+	rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
+	msleep(1);
+	rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
+	rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
+	rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
+	rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
 }
 
 static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
@@ -4990,23 +5007,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		return 0;
 	}
 
-
-	if (rt2x00_rt(rt2x00dev, RT3572)) {
-		rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
-		rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
-
-		rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
-		rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
-		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
-		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
-		msleep(1);
-		rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
-		rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
-		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
-		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
-	}
-
 	/*
 	 * Set RX Filter calibration for 20MHz and 40MHz
 	 */
-- 
1.7.4.4

