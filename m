Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smarthost1.greenhost.nl ([195.190.28.78]:46382 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab1AHLgg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Jan 2011 06:36:36 -0500
Message-ID: <50516d36d926af475ea7fdc9d3a7c6d2.squirrel@webmail.greenhost.nl>
Date: Sat, 8 Jan 2011 12:17:27 +0100 (CET)
Subject: [PATCH] ipw2200: Check for -1 INTA in tasklet too.
From: "Indan Zupancic" <indan@nul.nu>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an attempt to fix a long standing open bug:
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1334

The interrupt handler checks for INTA being -1, apparently that means that the
hardware is gone. But the interrupt handler defers actual interrupt processing
to a tasklet. By the time the tasklet is run and checks INTA again, the
hardware might be gone and INTA be -1, which confuses the driver because all
event bits are set.

The patch applies to 2.6.37.

Signed-off-by: Indan Zupancic <indan@nul.nu>

---

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c
b/drivers/net/wireless/ipw2x00/ipw2200.c
index 8d6ed5f..ae438ed 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -1973,6 +1973,13 @@ static void ipw_irq_tasklet(struct ipw_priv *priv)

 	inta = ipw_read32(priv, IPW_INTA_RW);
 	inta_mask = ipw_read32(priv, IPW_INTA_MASK_R);
+
+	if (inta == 0xFFFFFFFF) {
+		/* Hardware disappeared */
+		IPW_WARNING("TASKLET INTA == 0xFFFFFFFF\n");
+		/* Only handle the cached INTA values */
+		inta = 0;
+	}
 	inta &= (IPW_INTA_MASK_ALL & inta_mask);

 	/* Add any cached INTA values that need to be handled */


