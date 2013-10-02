Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-133-188-53.HINET-IP.hinet.net ([220.133.188.53]:61146 "EHLO
	ns.kevlo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752916Ab3JBJrK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 05:47:10 -0400
Message-ID: <524BEB7A.8040508@kevlo.org> (sfid-20131002_114719_133914_97FFF961)
Date: Wed, 02 Oct 2013 17:46:34 +0800
From: Kevin Lo <kevlo@kevlo.org>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2x00: rt2800lib: fix RF registers for RT5390/RT5392
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update rf registers to use the same values that the MediaTek/Ralink
reference driver DPO_RT5572_LinuxSTA_2.6.1.3_20121022 uses.

References:
   RF5390RegTable in chips/rt5390.c
   RF5392RegTable in chips/rt5390.c

Tested on TP-Link TL-WN727N and D-Link DWA-140 Rev.b3 usb wifi dongles.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c 
b/drivers/net/wireless/rt2x00/rt2800lib.c
index f414978..0bbd1b5 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -6449,7 +6449,7 @@ static void rt2800_init_rfcsr_5390(struct 
rt2x00_dev *rt2x00dev)
         rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
         rt2800_rfcsr_write(rt2x00dev, 29, 0x10);

-       rt2800_rfcsr_write(rt2x00dev, 30, 0x00);
+       rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
         rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
         rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
         rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
@@ -6487,7 +6487,7 @@ static void rt2800_init_rfcsr_5390(struct 
rt2x00_dev *rt2x00dev)
         rt2800_rfcsr_write(rt2x00dev, 56, 0x22);
         rt2800_rfcsr_write(rt2x00dev, 57, 0x80);
         rt2800_rfcsr_write(rt2x00dev, 58, 0x7f);
-       rt2800_rfcsr_write(rt2x00dev, 59, 0x63);
+       rt2800_rfcsr_write(rt2x00dev, 59, 0x8f);

         rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
         if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
@@ -6507,7 +6507,6 @@ static void rt2800_init_rfcsr_5392(struct 
rt2x00_dev *rt2x00dev)
         rt2800_rf_init_calibration(rt2x00dev, 2);

         rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
-       rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
         rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
         rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
         rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);

