Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47722 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbZKWTzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 14:55:03 -0500
Date: Mon, 23 Nov 2009 13:55:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: casteyde.christian@free.fr, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [RFC] b43: Fix regression from Bug #14538
Message-ID: <4b0ae89a.w9I5fcNpeuH/GfsI%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The routine b43_is_hw_radio_enabled() has long been a problem.
For PPC architecture with PHY Revision < 3, a read of the register
B43_MMIO_HWENABLED_LO will cause a CPU fault unless b43_status()
returns a value of 2 (B43_STAT_STARTED) (BUG 14181). Fixing that
results in Bug 14538 in which the driver is unable to reassociate
after resuming from hibernation because b43_status() returns 0.

The correct fix would be to determine why the status is 0; however,
I have not yet found why that happens. The correct value is found for
my device, which has PHY revision >= 3.

Returning TRUE when the PHY revision < 3 and b43_status() returns 0 fixes
the regression for 2.6.32.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Christian Casteyde <casteyde.christian@free.fr>
---

Index: wireless-testing/drivers/net/wireless/b43/rfkill.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/rfkill.c
+++ wireless-testing/drivers/net/wireless/b43/rfkill.c
@@ -33,9 +33,16 @@ bool b43_is_hw_radio_enabled(struct b43_
 		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
 			return 1;
 	} else {
-		if (b43_status(dev) >= B43_STAT_STARTED &&
-		    b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
-		    & B43_MMIO_RADIO_HWENABLED_LO_MASK)
+		/* To prevent CPU fault on PPC, do not read a register
+		 * unless the interface is started; however, on resume
+		 * for hibernation, this routine is entered early. When
+		 * that happens, unconditionally return TRUE.
+		 */
+		if (b43_status(dev) >= B43_STAT_STARTED) {
+			if (b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
+			    & B43_MMIO_RADIO_HWENABLED_LO_MASK)
+				return 1;
+		} else
 			return 1;
 	}
 	return 0;

