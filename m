Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:18322 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab3ERMCZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 May 2013 08:02:25 -0400
Received: from ip-94-112-188-135.net.upcbroadband.cz (HELO localhost) (stf_xl@wp.pl@[94.112.188.135])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with AES128-SHA encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 18 May 2013 14:02:23 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: users@rt2x00.serialmonkey.com, Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 01/32] rt2800: make rt2800_init_bbp return void
Date: Sat, 18 May 2013 14:03:24 +0200
Message-Id: <1368878635-4455-2-git-send-email-stf_xl@wp.pl> (sfid-20130518_140228_967116_90EB2608)
In-Reply-To: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
References: <1368878635-4455-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

This function can not fail, we always return 0.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index b52d70c..f431dcb 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4027,20 +4027,16 @@ static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 }
 
-static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
+static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 {
 	unsigned int i;
 	u16 eeprom;
 	u8 reg_id;
 	u8 value;
 
-	if (unlikely(rt2800_wait_bbp_rf_ready(rt2x00dev) ||
-		     rt2800_wait_bbp_ready(rt2x00dev)))
-		return -EACCES;
-
 	if (rt2x00_rt(rt2x00dev, RT5592)) {
 		rt2800_init_bbp_5592(rt2x00dev);
-		return 0;
+		return;
 	}
 
 	if (rt2x00_rt(rt2x00dev, RT3352)) {
@@ -4337,8 +4333,6 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 			rt2800_bbp_write(rt2x00dev, reg_id, value);
 		}
 	}
-
-	return 0;
 }
 
 static void rt2800_led_open_drain_enable(struct rt2x00_dev *rt2x00dev)
@@ -5189,9 +5183,11 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
 	}
 	msleep(1);
 
-	if (unlikely(rt2800_init_bbp(rt2x00dev)))
+	if (unlikely(rt2800_wait_bbp_rf_ready(rt2x00dev) ||
+		     rt2800_wait_bbp_ready(rt2x00dev)))
 		return -EIO;
 
+	rt2800_init_bbp(rt2x00dev);
 	rt2800_init_rfcsr(rt2x00dev);
 
 	if (rt2x00_is_usb(rt2x00dev) &&
-- 
1.7.4.4

