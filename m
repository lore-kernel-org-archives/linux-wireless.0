Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59570 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab0DAVOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 17:14:37 -0400
Received: by wyb39 with SMTP id 39so721127wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 14:14:36 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 1 Apr 2010 22:14:36 +0100
Message-ID: <k2g880c1631004011414z59ce4547j1bcea7ad5aff7229@mail.gmail.com>
Subject: [PATCH V3] rt2x00: remove MCU requests for SoC platforms
From: Luis Correia <buga@loide.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ralink SoC platforms do not have an MCU.

Signed-off-by: Luis Correia <luis.f.correia@gmail.com>
---

--- a/drivers/net/wireless/rt2x00/rt2800lib.c   2010-03-26
18:25:50.000000000 +0000
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c   2010-04-01
13:05:18.249747122 +0100
@@ -221,9 +221,9 @@
       u32 reg;

       /*
-        * SOC devices don't support MCU requests.
+        * some devices don't support MCU requests.
        */
-       if (rt2x00_is_soc(rt2x00dev))
+       if (!test_bit(DRIVER_REQUIRE_MCU, &rt2x00dev->flags))
               return;

       mutex_lock(&rt2x00dev->csr_mutex);
--- a/drivers/net/wireless/rt2x00/rt2800pci.c   2010-03-26
18:25:50.000000000 +0000
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c   2010-04-01
13:04:42.453621607 +0100
@@ -59,6 +59,12 @@
 {
       unsigned int i;
       u32 reg;
+
+       /*
+        * some devices don't support MCU requests.
+        */
+       if (!test_bit(DRIVER_REQUIRE_MCU, &rt2x00dev->flags))
+               return;

       for (i = 0; i < 200; i++) {
               rt2800_register_read(rt2x00dev, H2M_MAILBOX_CID, &reg);
@@ -1098,10 +1104,12 @@
       __set_bit(DRIVER_SUPPORT_CONTROL_FILTER_PSPOLL, &rt2x00dev->flags);

       /*
-        * This device requires firmware.
+        * This device requires firmware and MCU access.
        */
-       if (!rt2x00_is_soc(rt2x00dev))
+       if (!rt2x00_is_soc(rt2x00dev)) {
               __set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
+               __set_bit(DRIVER_REQUIRE_MCU, &rt2x00dev->flags);
+       }
       __set_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags);
       __set_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags);
       if (!modparam_nohwcrypt)
--- a/drivers/net/wireless/rt2x00/rt2x00.h      2010-03-26
18:25:50.000000000 +0000
+++ b/drivers/net/wireless/rt2x00/rt2x00.h      2010-04-01
13:01:26.812694036 +0100
@@ -631,6 +631,7 @@
        * Driver requirements
        */
       DRIVER_REQUIRE_FIRMWARE,
+       DRIVER_REQUIRE_MCU,
       DRIVER_REQUIRE_BEACON_GUARD,
       DRIVER_REQUIRE_ATIM_QUEUE,
       DRIVER_REQUIRE_DMA,
