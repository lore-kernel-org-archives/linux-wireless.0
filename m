Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-133-188-53.HINET-IP.hinet.net ([220.133.188.53]:45268 "EHLO
	ns.kevlo.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751965Ab3IRIbH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 04:31:07 -0400
Received: from [127.0.0.1] (mail.kevlo.org [220.133.188.53])
	by ns.kevlo.org (8.14.6/8.14.6) with ESMTP id r8I8KDUc029847
	for <linux-wireless@vger.kernel.org>; Wed, 18 Sep 2013 16:20:14 +0800 (CST)
	(envelope-from kevlo@kevlo.org)
Message-ID: <523962D4.8090506@kevlo.org> (sfid-20130918_103115_342245_7278C838)
Date: Wed, 18 Sep 2013 16:22:44 +0800
From: Kevin Lo <kevlo@kevlo.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH] rt2x00: Fix rf register for RT3070
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix RT3070 chip RF initial value to be similar to the latest Ralink vendor
driver.

Tested on Asus N13 usb wifi dongle.

Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c 
b/drivers/net/wireless/rt2x00/rt2800lib.c
index 95e6e61..3ea35d4 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -5985,7 +5985,7 @@ static void rt2800_init_rfcsr_30xx(struct 
rt2x00_dev *rt2x00dev)
         rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
         rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
         rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
-       rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
+       rt2800_rfcsr_write(rt2x00dev, 25, 0x03);
         rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);

         if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {

