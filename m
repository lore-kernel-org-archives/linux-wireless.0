Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:49941 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111AbZIEJUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Sep 2009 05:20:33 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] ssb: Fail ssb modinit, if attach of the buses failed.
Date: Sat, 5 Sep 2009 11:18:47 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909051118.49489.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

SSB modinit should not succeed, if busattach failed.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---
 drivers/ssb/main.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/ssb/main.c
+++ wireless-testing/drivers/ssb/main.c
@@ -1358,8 +1358,10 @@ static int __init ssb_modinit(void)
 	ssb_buses_lock();
 	err = ssb_attach_queued_buses();
 	ssb_buses_unlock();
-	if (err)
+	if (err) {
 		bus_unregister(&ssb_bustype);
+		goto out;
+	}
 
 	err = b43_pci_ssb_bridge_init();
 	if (err) {
@@ -1375,7 +1377,7 @@ static int __init ssb_modinit(void)
 		/* don't fail SSB init because of this */
 		err = 0;
 	}
-
+out:
 	return err;
 }
 /* ssb must be initialized after PCI but before the ssb drivers.

-- 
Greetings, Michael.
