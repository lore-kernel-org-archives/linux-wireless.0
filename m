Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-133-188-53.HINET-IP.hinet.net ([220.133.188.53]:60755 "EHLO
	ns.kevlo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752364Ab3JUHnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 03:43:37 -0400
Date: Mon, 21 Oct 2013 15:38:31 +0800
From: Kevin Lo <kevlo@kevlo.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH] rt2x00: rt2800lib: Update BBP register initialization for
 RT53xx
Message-ID: <20131021073831.GA87643@ns.kevlo.org> (sfid-20131021_094353_259125_42A23A14)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update bbp register initialization for RT53xx chips to match with the
latest MediaTek/Ralink driver.

Based on: NICInitRT5390BbpRegisters()
From: DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rt5390.c

Signed-off-by: Kevin Lo <kevlo.org>
---

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c5738f1..eae635a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -5462,15 +5462,14 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 68, 0x0b);
 
-	rt2800_bbp_write(rt2x00dev, 69, 0x12);
+	rt2800_bbp_write(rt2x00dev, 69, 0x0d);
+	rt2800_bbp_write(rt2x00dev, 70, 0x06);
 	rt2800_bbp_write(rt2x00dev, 73, 0x13);
 	rt2800_bbp_write(rt2x00dev, 75, 0x46);
 	rt2800_bbp_write(rt2x00dev, 76, 0x28);
 
 	rt2800_bbp_write(rt2x00dev, 77, 0x59);
 
-	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
-
 	rt2800_bbp_write(rt2x00dev, 79, 0x13);
 	rt2800_bbp_write(rt2x00dev, 80, 0x05);
 	rt2800_bbp_write(rt2x00dev, 81, 0x33);
@@ -5513,6 +5512,7 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_bbp_write(rt2x00dev, 134, 0xd0);
 		rt2800_bbp_write(rt2x00dev, 135, 0xf6);
+		rt2800_bbp_write(rt2x00dev, 148, 0x84);
 	}
 
 	rt2800_disable_unused_dac_adc(rt2x00dev);
