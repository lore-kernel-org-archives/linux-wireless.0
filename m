Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63811 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0DAM6X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 08:58:23 -0400
Received: by wwb17 with SMTP id 17so746725wwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Apr 2010 05:58:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201004011451.44204.IvDoorn@gmail.com>
References: <t2yefe7343f1004010548tdb2db0a3h9570da736a269352@mail.gmail.com>
	<201004011451.44204.IvDoorn@gmail.com>
From: Luis Correia <luis.f.correia@gmail.com>
Date: Thu, 1 Apr 2010 13:58:02 +0100
Message-ID: <h2iefe7343f1004010558ze63465bcm5e3bd10e702dea66@mail.gmail.com>
Subject: [PATCH V2] Remove MCU requests for SoC platforms
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ralink SoC platforms do not have an MCU.

Signed-off-by: Luis Correia <luis.f.correia@gmail.com>
---

--- a/drivers/net/wireless/rt2x00/rt2800lib.c	2010-03-26
18:25:50.000000000 +0000
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c	2010-04-01
13:05:18.249747122 +0100
@@ -221,9 +221,9 @@
 	u32 reg;

 	/*
-	 * SOC devices don't support MCU requests.
+	 * some devices don't support MCU requests.
 	 */
-	if (rt2x00_is_soc(rt2x00dev))
+	if (!test_bit(DRIVER_REQUIRE_MCU, &rt2x00dev->flags))
 		return;

 	mutex_lock(&rt2x00dev->csr_mutex);
--- a/drivers/net/wireless/rt2x00/rt2800pci.c	2010-03-26
18:25:50.000000000 +0000
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c	2010-04-01
13:04:42.453621607 +0100
@@ -59,6 +59,12 @@
 {
 	unsigned int i;
 	u32 reg;
+	
+	/*
+	 * some devices don't support MCU requests.
+	 */
+	if (!test_bit(DRIVER_REQUIRE_MCU, &rt2x00dev->flags))
+		return;

 	for (i = 0; i < 200; i++) {
 		rt2800_register_read(rt2x00dev, H2M_MAILBOX_CID, &reg);
@@ -1098,10 +1104,12 @@
 	__set_bit(DRIVER_SUPPORT_CONTROL_FILTER_PSPOLL, &rt2x00dev->flags);

 	/*
-	 * This device requires firmware.
+	 * This device requires firmware and MCU access.
 	 */
-	if (!rt2x00_is_soc(rt2x00dev))
+	if (!rt2x00_is_soc(rt2x00dev)){
 		__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
+		__set_bit(DRIVER_REQUIRE_MCU, &rt2x00dev->flags);
+	}
 	__set_bit(DRIVER_REQUIRE_DMA, &rt2x00dev->flags);
 	__set_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags);
 	if (!modparam_nohwcrypt)
--- a/drivers/net/wireless/rt2x00/rt2x00.h	2010-03-26 18:25:50.000000000 +0000
+++ b/drivers/net/wireless/rt2x00/rt2x00.h	2010-04-01 13:01:26.812694036 +0100
@@ -631,6 +631,7 @@
 	 * Driver requirements
 	 */
 	DRIVER_REQUIRE_FIRMWARE,
+	DRIVER_REQUIRE_MCU,
 	DRIVER_REQUIRE_BEACON_GUARD,
 	DRIVER_REQUIRE_ATIM_QUEUE,
 	DRIVER_REQUIRE_DMA,
