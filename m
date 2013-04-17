Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:19759 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966244Ab3DQMHe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 08:07:34 -0400
From: stf_xl@wp.pl
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH v2 05/11] rt2800: move GPIO_SWITCH setup to 3390 specific rfcsr init
Date: Wed, 17 Apr 2013 14:08:14 +0200
Message-Id: <1366200500-4661-6-git-send-email-stf_xl@wp.pl> (sfid-20130417_140748_198200_7153435A)
In-Reply-To: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
References: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 0ad2e9d..102e50c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4665,6 +4665,8 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 {
+	u32 reg;
+
 	rt2800_rf_init_calibration(rt2x00dev, 30);
 
 	rt2800_rfcsr_write(rt2x00dev, 0, 0xa0);
@@ -4699,6 +4701,10 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 29, 0x8f);
 	rt2800_rfcsr_write(rt2x00dev, 30, 0x20);
 	rt2800_rfcsr_write(rt2x00dev, 31, 0x0f);
+
+	rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
+	rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
+	rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
 }
 
 static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
@@ -4989,11 +4995,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	}
 
 
-	if (rt2x00_rt(rt2x00dev, RT3390)) {
-		rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
-		rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
-		rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
-	} else if (rt2x00_rt(rt2x00dev, RT3572)) {
+	if (rt2x00_rt(rt2x00dev, RT3572)) {
 		rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
 		rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
-- 
1.7.4.4

