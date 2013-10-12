Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-133-188-53.HINET-IP.hinet.net ([220.133.188.53]:42965 "EHLO
	ns.kevlo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752034Ab3JLPaK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Oct 2013 11:30:10 -0400
Date: Sat, 12 Oct 2013 23:25:23 +0800
From: Kevin Lo <kevlo@kevlo.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH v2] rt2x00: rt2800lib: fix RF registers for RT5390/RT5392
Message-ID: <20131012152523.GA4156@ns.kevlo.org> (sfid-20131012_173015_037455_EFFA07B8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update rf registers to use the same values that the MediaTek/Ralink
reference driver DPO_RT5572_LinuxSTA_2.6.1.3_20121022 uses.

References:
  RF5390RegTable in chips/rt5390.c
  RF5392RegTable in chips/rt5390.c

Tested on TP-Link TL-WN727N and D-Link DWA-140 Rev.b3 usb wifi dongles.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v1:
  - the previous patch was malformed
  - add Stanislaw's Acked-by tag
--- 

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a114cab..373efde 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -6476,7 +6476,7 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
 	rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
 
-	rt2800_rfcsr_write(rt2x00dev, 30, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
 	rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
 	rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
 	rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
@@ -6514,7 +6514,7 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 56, 0x22);
 	rt2800_rfcsr_write(rt2x00dev, 57, 0x80);
 	rt2800_rfcsr_write(rt2x00dev, 58, 0x7f);
-	rt2800_rfcsr_write(rt2x00dev, 59, 0x63);
+	rt2800_rfcsr_write(rt2x00dev, 59, 0x8f);
 
 	rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
 	if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
@@ -6534,7 +6534,6 @@ static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
 	rt2800_rf_init_calibration(rt2x00dev, 2);
 
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
-	rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
 	rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
 	rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
 	rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
