Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41503
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbXJ0NPB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 09:15:01 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Fix initcall ordering
Date: Sat, 27 Oct 2007 15:14:39 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Christian Casteyde <casteyde.christian@free.fr>
MIME-Version: 1.0
Message-Id: <200710271514.40056.mb@bu3sch.de> (sfid-20071027_141505_669105_33177161)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ssb must init after PCI but before the ssb drivers.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Christian Casteyde <casteyde.christian@free.fr>
Fixes-bug: #9219

Index: wireless-2.6/drivers/ssb/main.c
===================================================================
--- wireless-2.6.orig/drivers/ssb/main.c	2007-10-27 14:54:40.000000000 +0200
+++ wireless-2.6/drivers/ssb/main.c	2007-10-27 14:57:15.000000000 +0200
@@ -1147,7 +1147,10 @@ static int __init ssb_modinit(void)
 
 	return err;
 }
-subsys_initcall(ssb_modinit);
+/* ssb must be initialized after PCI but before the ssb drivers.
+ * That means we must use some initcall between subsys_initcall
+ * and device_initcall. */
+fs_initcall(ssb_modinit);
 
 static void __exit ssb_modexit(void)
 {
