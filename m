Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:52945 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966257Ab3DQMHb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 08:07:31 -0400
From: stf_xl@wp.pl
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH v2 03/11] rt2800: move RFCSR29_RSSI_GAIN to 3290 specific rfcsr init
Date: Wed, 17 Apr 2013 14:08:12 +0200
Message-Id: <1366200500-4661-4-git-send-email-stf_xl@wp.pl> (sfid-20130417_140746_361510_8A909E99)
In-Reply-To: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
References: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6e9ca3e..40a37fe 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4504,6 +4504,8 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
 
 static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
 {
+	u8 rfcsr;
+
 	rt2800_rf_init_calibration(rt2x00dev, 2);
 
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x0f);
@@ -4552,6 +4554,10 @@ static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 59, 0x09);
 	rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
 	rt2800_rfcsr_write(rt2x00dev, 61, 0xc1);
+
+	rt2800_rfcsr_read(rt2x00dev, 29, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR29_RSSI_GAIN, 3);
+	rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
 }
 
 static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
@@ -5119,12 +5125,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 27, rfcsr);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3290)) {
-		rt2800_rfcsr_read(rt2x00dev, 29, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR29_RSSI_GAIN, 3);
-		rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
-	}
-
 	return 0;
 }
 
-- 
1.7.4.4

