Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39705 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295Ab1LHXFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:05:54 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: stable@vger.kernel.org, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Michael Buesch <m@bues.ch>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH v2] ssb: fix init regression with SoCs
Date: Fri,  9 Dec 2011 00:05:20 +0100
Message-Id: <1323385520-5933-1-git-send-email-hauke@hauke-m.de> (sfid-20111209_000557_938318_134A55E4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a Data bus error on some SoCs. The first fix for this
problem did not solve it on all devices.
    commit 6ae8ec27868bfdbb815287bee8146acbefaee867
    Author: Rafał Miłecki <zajec5@gmail.com>
    Date:   Tue Jul 5 17:25:32 2011 +0200
        ssb: fix init regression of hostmode PCI core

In ssb_pcicore_fix_sprom_core_index() the sprom on the PCI core is
accessed, but the sprom only exists when the ssb bus is connected over
a PCI bus to the rest of the system and not when the SSB Bus is the
main system bus. SoCs sometimes have a PCI host controller and there
this code will not be executed, but there are some old SoCs with an PCI
controller in client mode around and ssb_pcicore_fix_sprom_core_index()
should not be called on these devices too. The PCI controller on these
devices are unused, but without this fix it results in an Data bus
error when it gets initialized.

Cc: stable@vger.kernel.org # Kernel >= 3.0
Cc: Michael Buesch <m@bues.ch>
Cc: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_pcicore.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 84c934c..2cefe14 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -517,7 +517,8 @@ static void ssb_pcicore_pcie_setup_workarounds(struct ssb_pcicore *pc)
 
 static void __devinit ssb_pcicore_init_clientmode(struct ssb_pcicore *pc)
 {
-	ssb_pcicore_fix_sprom_core_index(pc);
+	if (pc->dev->bus->bustype == SSB_BUSTYPE_PCI)
+		ssb_pcicore_fix_sprom_core_index(pc);
 
 	/* Disable PCI interrupts. */
 	ssb_write32(pc->dev, SSB_INTVEC, 0);
-- 
1.7.5.4

