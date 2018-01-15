Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750740AbeAOVTF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 16:19:05 -0500
From: James Hogan <jhogan@kernel.org>
To: Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>,
        Paul Burton <paul.burton@mips.com>,
        Matt Redfearn <matt.redfearn@imgtec.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH for-4.15] ssb: Disable PCI host for PCI_DRIVERS_GENERIC
Date: Mon, 15 Jan 2018 21:17:14 +0000
Message-Id: <20180115211714.24009-1-jhogan@kernel.org> (sfid-20180115_221909_008222_5FF4C985)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit d41e6858ba58 ("MIPS: Kconfig: Set default MIPS system type
as generic") changed the default MIPS platform to the "generic"
platform, which uses PCI_DRIVERS_GENERIC instead of PCI_DRIVERS_LEGACY,
various files in drivers/ssb/ have failed to build.

This is particularly due to the existence of struct pci_controller being
dependent on PCI_DRIVERS_LEGACY since commit c5611df96804 ("MIPS: PCI:
Introduce CONFIG_PCI_DRIVERS_LEGACY"), so add that dependency to Kconfig
to prevent these files being built for the "generic" platform including
all{yes,mod}config builds.

Fixes: c5611df96804 ("MIPS: PCI: Introduce CONFIG_PCI_DRIVERS_LEGACY")
Signed-off-by: James Hogan <jhogan@kernel.org>
Cc: Michael Buesch <m@bues.ch>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paul.burton@mips.com>
Cc: Matt Redfearn <matt.redfearn@imgtec.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-wireless@vger.kernel.org
Cc: linux-mips@linux-mips.org
---
 drivers/ssb/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index d8e4219c2324..71c73766ee22 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -32,7 +32,7 @@ config SSB_BLOCKIO
 
 config SSB_PCIHOST_POSSIBLE
 	bool
-	depends on SSB && (PCI = y || PCI = SSB)
+	depends on SSB && (PCI = y || PCI = SSB) && PCI_DRIVERS_LEGACY
 	default y
 
 config SSB_PCIHOST
-- 
2.13.6
