Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:38882 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934971Ab3DIPFC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 11:05:02 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 11/11] rt2800: cleanup rt2800_init_rfcsr
Date: Tue,  9 Apr 2013 17:05:30 +0200
Message-Id: <1365519930-3230-12-git-send-email-stf_xl@wp.pl> (sfid-20130409_171304_074544_75EB7B81)
In-Reply-To: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

This procedure is simple switch now and return no error any longer.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   31 ++++++-------------------------
 1 files changed, 6 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f31b9b9..b084e90 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -5100,29 +5100,11 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
 	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
-static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
+static void rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 {
-	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
-	u8 rfcsr;
-	u32 reg;
-
-	if (!rt2x00_rt(rt2x00dev, RT3070) &&
-	    !rt2x00_rt(rt2x00dev, RT3071) &&
-	    !rt2x00_rt(rt2x00dev, RT3090) &&
-	    !rt2x00_rt(rt2x00dev, RT3290) &&
-	    !rt2x00_rt(rt2x00dev, RT3352) &&
-	    !rt2x00_rt(rt2x00dev, RT3390) &&
-	    !rt2x00_rt(rt2x00dev, RT3572) &&
-	    !rt2x00_rt(rt2x00dev, RT5390) &&
-	    !rt2x00_rt(rt2x00dev, RT5392) &&
-	    !rt2x00_rt(rt2x00dev, RT5392) &&
-	    !rt2x00_rt(rt2x00dev, RT5592) &&
-	    !rt2800_is_305x_soc(rt2x00dev))
-		return 0;
-
 	if (rt2800_is_305x_soc(rt2x00dev)) {
 		rt2800_init_rfcsr_305x_soc(rt2x00dev);
-		return 0;
+		return;
 	}
 
 	switch (rt2x00dev->chip.rt) {
@@ -5151,10 +5133,8 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		break;
 	case RT5592:
 		rt2800_init_rfcsr_5592(rt2x00dev);
-		return 0;
+		break;
 	}
-
-	return 0;
 }
 
 int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
@@ -5180,10 +5160,11 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
 	}
 	msleep(1);
 
-	if (unlikely(rt2800_init_bbp(rt2x00dev) ||
-		     rt2800_init_rfcsr(rt2x00dev)))
+	if (unlikely(rt2800_init_bbp(rt2x00dev)))
 		return -EIO;
 
+	rt2800_init_rfcsr(rt2x00dev);
+
 	if (rt2x00_is_usb(rt2x00dev) &&
 	    (rt2x00_rt(rt2x00dev, RT3070) ||
 	     rt2x00_rt(rt2x00dev, RT3071) ||
-- 
1.7.4.4

