Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34465 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbZKGR4U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 12:56:20 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43-pio: Fix RX error path for rev>=8 devices
Date: Sat, 7 Nov 2009 18:54:22 +0100
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911071854.22748.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the RX error path for rev>=8 devices.
The wrong register size and definitions were used.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Index: wireless-testing/drivers/net/wireless/b43/pio.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/pio.c	2009-11-01 13:58:48.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/pio.c	2009-11-07 18:46:11.000000000 +0100
@@ -762,7 +762,11 @@ data_ready:
 rx_error:
 	if (err_msg)
 		b43dbg(q->dev->wl, "PIO RX error: %s\n", err_msg);
-	b43_piorx_write16(q, B43_PIO_RXCTL, B43_PIO_RXCTL_DATARDY);
+	if (q->rev >= 8)
+		b43_piorx_write32(q, B43_PIO8_RXCTL, B43_PIO8_RXCTL_DATARDY);
+	else
+		b43_piorx_write16(q, B43_PIO_RXCTL, B43_PIO_RXCTL_DATARDY);
+
 	return 1;
 }
 

-- 
Greetings, Michael.
