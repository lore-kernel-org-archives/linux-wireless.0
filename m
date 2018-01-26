Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shrek-s3.podlesie.net ([85.14.110.209]:53589 "EHLO
        shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbeA0AEb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 19:04:31 -0500
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Hogan <jhogan@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH] ssb: Reenable PCI host on !MIPS
Date: Sat, 27 Jan 2018 00:58:49 +0100
Message-Id: <20180126235849.3177-1-krzysiek@podlesie.net> (sfid-20180127_010435_225397_7672E977)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit 58eae1416b804d900014d84feadda7195007cc30
("ssb: Disable PCI host for PCI_DRIVERS_GENERIC") disabled
CONFIG_SSB_PCIHOST and CONFIG_SSB_B43_PCI_BRIDGE, which are
required for SSB-based b43 PCI cards, on everything except MIPS
with PCI_DRIVERS_LEGACY, including x86 (only MIPS defines
that config option). Reenable it.

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
---
 drivers/ssb/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index 71c73766ee22..3dc57414e06b 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -32,7 +32,7 @@ config SSB_BLOCKIO
 
 config SSB_PCIHOST_POSSIBLE
 	bool
-	depends on SSB && (PCI = y || PCI = SSB) && PCI_DRIVERS_LEGACY
+	depends on SSB && (PCI = y || PCI = SSB) && (!MIPS || PCI_DRIVERS_LEGACY)
 	default y
 
 config SSB_PCIHOST
-- 
2.16.0.rc1.238.g530d649a7
