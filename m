Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:59903 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbYFMIsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 04:48:13 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix for incorrect Subsystem and PCI Product IDs on rev 4 SPROMs
Date: Fri, 13 Jun 2008 10:47:33 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200806131047.33710.mb@bu3sch.de> (sfid-20080613_104817_502644_61970F6F)
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Larry.Finger@lwfinger.net

In current ssb-sprom code, the Subsystem and Product ID's are wrong for rev 4
SPROM's.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
---

John, this is a bugfix for 2.6.26.


Index: ssb_sprom/ssb_sprom.h
===================================================================
--- ssb_sprom.orig/ssb_sprom.h
+++ ssb_sprom/ssb_sprom.h
@@ -33,10 +33,10 @@
 
 /* byte offsets */
 #define SPROM_SUBP		(0x02 * 2)
-#define SPROM4_SUBP		(0x00 * 2)
+#define SPROM4_SUBP		(0x02 * 2)
 #define SPROM_SUBV		(0x03 * 2)
 #define SPROM_PPID		(0x04 * 2)
-#define SPROM4_PPID		(0x02 * 2)
+#define SPROM4_PPID		(0x04 * 2)
 #define SPROM_BFLHI		(0x1C * 2)
 #define SPROM_IL0MACADDR	(0x24 * 2)
 #define SPROM_ET0MACADDR	(0x27 * 2)

-- 
Greetings Michael.
