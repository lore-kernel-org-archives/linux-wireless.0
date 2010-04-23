Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36341 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588Ab0DWSRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 14:17:23 -0400
Date: Fri, 23 Apr 2010 13:17:21 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] ssb: Make bus registration failure not be silent
Message-ID: <4bd1e431.vQNH3R5aTXsSl1FV%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In kernel Bugzilla #15825, a case where routine ssb_bus_pcibus_register()
fails silently is reported. The cause for the failure is still being
investigated; however, the diagnosis would be easier if the failure
had been reported.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch has low priority - 2.6.35. Whatever fixes are needed after the
source of the problem is discovered will likely be 2.6.34 and stable material.

Larry
---

Michael,

Please be aware that the failure in the SSB registration leads to a system
freeze when ssb is unloaded. I did a quick check but could not locate a
routine that fails to tear down all structures on an error return, but that
search will be easier once we know which routine is failing. The OP for the
Bugzilla entry has been given a test patch to further identify the problem.

Larry
---

Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c
+++ wireless-testing/drivers/ssb/main.c
@@ -834,6 +834,9 @@ int ssb_bus_pcibus_register(struct ssb_b
 	if (!err) {
 		ssb_printk(KERN_INFO PFX "Sonics Silicon Backplane found on "
 			   "PCI device %s\n", dev_name(&host_pci->dev));
+	} else {
+		ssb_printk(KERN_ERR PFX "Failed to register PCI version"
+			   " of SSB with error %d\n", err);
 	}
 
 	return err;
