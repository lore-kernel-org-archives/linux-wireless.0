Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:30988 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764934Ab3DIPE4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 11:04:56 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 08/11] rt2800: move RF_R27 setup to individual rfcsr init subroutines
Date: Tue,  9 Apr 2013 17:05:27 +0200
Message-Id: <1365519930-3230-9-git-send-email-stf_xl@wp.pl> (sfid-20130409_170501_366813_40C2861D)
In-Reply-To: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index df8760f..fe0df88 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4588,6 +4588,11 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
 	}
 
 	rt2800_rx_filter_calibration(rt2x00dev);
+
+	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F) ||
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E))
+		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 }
 
 static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
@@ -4761,6 +4766,9 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
 
 	rt2800_rx_filter_calibration(rt2x00dev);
+
+	if (rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E))
+		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 }
 
 static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
@@ -5007,6 +5015,9 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 
 	rt2800_normal_mode_setup_5xxx(rt2x00dev);
+
+	if (rt2x00_rt_rev_lt(rt2x00dev, RT5592, REV_RT5592C))
+		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 }
 
 static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
@@ -5063,13 +5074,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		return 0;
 	}
 
-	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F) ||
-	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
-	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
-	    rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E) ||
-	    rt2x00_rt_rev_lt(rt2x00dev, RT5592, REV_RT5592C))
-		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
-
 	rt2800_register_read(rt2x00dev, OPT_14_CSR, &reg);
 	rt2x00_set_field32(&reg, OPT_14_CSR_BIT0, 1);
 	rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
-- 
1.7.4.4

