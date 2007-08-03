Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:49811 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761907AbXHCV1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 17:27:01 -0400
Date: Fri, 03 Aug 2007 16:26:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx-mac80211: Set antenna gains if not in sprom
Message-ID: <46b39d7d.4kGviB6QZBFl2jfv%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the sprom for bcm43xx devices, any unprogrammed values are set to all ones.
In the case of antenna gains, the specs indicate that a gain of 2 dBm should
be set if no value is stored. This patch implements that provision.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_main.c
@@ -3805,6 +3805,12 @@ static void bcm43xx_sprom_fixup(struct s
 	    bus->boardinfo.rev > 0x40)
 		bus->sprom.r1.boardflags_lo |= BCM43xx_BFL_PACTRL;
 
+	/* Handle case when gain is not set in sprom */
+	if (bus->sprom.r1.antenna_gain_a == 0xFF)
+		bus->sprom.r1.antenna_gain_a = 2;
+	if (bus->sprom.r1.antenna_gain_bg == 0xFF)
+		bus->sprom.r1.antenna_gain_bg = 2;
+
 	/* Convert Antennagain values to Q5.2 */
 	bus->sprom.r1.antenna_gain_a <<= 2;
 	bus->sprom.r1.antenna_gain_bg <<= 2;
