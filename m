Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:9164 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966244Ab3DQMHl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 08:07:41 -0400
From: stf_xl@wp.pl
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH v2 08/11] rt2800: move RF_R27 setup to individual rfcsr init subroutines
Date: Wed, 17 Apr 2013 14:08:17 +0200
Message-Id: <1366200500-4661-9-git-send-email-stf_xl@wp.pl> (sfid-20130417_140750_579825_29DDB0E6)
In-Reply-To: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
References: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index ad83bcd..cf757ca 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4583,6 +4583,11 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
 	}
 
 	rt2800_rx_filter_calibration(rt2x00dev);
+
+	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F) ||
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E))
+		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 }
 
 static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
@@ -4758,6 +4763,9 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
 
 	rt2800_rx_filter_calibration(rt2x00dev);
+
+	if (rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E))
+		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 }
 
 static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
@@ -5008,6 +5016,9 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 
 	rt2800_normal_mode_setup_5xxx(rt2x00dev);
+
+	if (rt2x00_rt_rev_lt(rt2x00dev, RT5592, REV_RT5592C))
+		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 }
 
 static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
@@ -5066,13 +5077,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
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

