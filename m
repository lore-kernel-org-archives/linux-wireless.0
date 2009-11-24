Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55929 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbZKXAmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 19:42:31 -0500
Date: Mon, 23 Nov 2009 18:42:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] b43legacy: Fix problem for PPC architecture noted in Red
 Hat Bugzilla #538523
Message-ID: <4b0b2bfc.wTVOnoPYuzV3oG6G%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For PPC architecture with PHY Revision < 3, a read of the register
B43_MMIO_HWENABLED_LO will cause a CPU fault unless b43legacy_status()
returns a value of 2 (B43legacy_STAT_STARTED); however, one finds that
the driver is unable to associate after resuming from hibernation unless
this routine returns 1. To satisfy both conditions, the routine is rewritten
to return TRUE whenever b43legacy_status() returns a value < 2.

This patch fixes the second problem listed in the postings for Red Hat
Bugzilla #538523.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.org>
---

John,

This is 2.6.32 material.

Larry
---

Index: wireless-testing/drivers/net/wireless/b43legacy/rfkill.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43legacy/rfkill.c
+++ wireless-testing/drivers/net/wireless/b43legacy/rfkill.c
@@ -34,6 +34,13 @@ bool b43legacy_is_hw_radio_enabled(struc
 		      & B43legacy_MMIO_RADIO_HWENABLED_HI_MASK))
 			return 1;
 	} else {
+		/* To prevent CPU fault on PPC, do not read a register
+		 * unless the interface is started; however, on resume
+		 * for hibernation, this routine is entered early. When
+		 * that happens, unconditionally return TRUE.
+		 */
+		if (b43legacy_status(dev) < B43legacy_STAT_STARTED)
+			return 1;
 		if (b43legacy_read16(dev, B43legacy_MMIO_RADIO_HWENABLED_LO)
 		    & B43legacy_MMIO_RADIO_HWENABLED_LO_MASK)
 			return 1;
