Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:9259 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966244Ab3DQMHh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 08:07:37 -0400
From: stf_xl@wp.pl
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH v2 06/11] rt2800: move RFCSR6_R2 & LDO_CFG0 setup to 3572 specific rfcsr init
Date: Wed, 17 Apr 2013 14:08:15 +0200
Message-Id: <1366200500-4661-7-git-send-email-stf_xl@wp.pl> (sfid-20130417_140749_049502_C7DDF4F3)
In-Reply-To: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
References: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   34 +++++++++++++++---------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 102e50c..6907cd3 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4709,6 +4709,9 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
 {
+	u8 rfcsr;
+	u32 reg;
+
 	rt2800_rf_init_calibration(rt2x00dev, 30);
 
 	rt2800_rfcsr_write(rt2x00dev, 0, 0x70);
@@ -4742,6 +4745,20 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
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
@@ -4994,23 +5011,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
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

