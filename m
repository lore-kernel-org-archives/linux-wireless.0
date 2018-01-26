Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:55979 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751395AbeAZJjK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 04:39:10 -0500
From: Sven Joachim <svenjoac@gmx.de>
To: Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org
Cc: James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Paul Burton <paul.burton@mips.com>,
        Matt Redfearn <matt.redfearn@imgtec.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] ssb: Do not disable PCI host on non-Mips
Date: Fri, 26 Jan 2018 10:38:01 +0100
Message-ID: <87vafpq7t2.fsf@turtle.gmx.de> (sfid-20180126_103917_146277_417D44CC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After upgrading an old laptop to 4.15-rc9, I found that the eth0 and
wlan0 interfaces had disappeared.  It turns out that the b43 and b44
drivers require SSB_PCIHOST_POSSIBLE which depends on
PCI_DRIVERS_LEGACY, a config option that only exists on Mips.

Fixes: 58eae1416b80 ("ssb: Disable PCI host for PCI_DRIVERS_GENERIC")
Cc: stable@vger.org
Signed-off-by: Sven Joachim <svenjoac@gmx.de>
---
 drivers/ssb/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index 71c73766ee22..65af12c3bdb2 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -32,7 +32,7 @@ config SSB_BLOCKIO
 
 config SSB_PCIHOST_POSSIBLE
 	bool
-	depends on SSB && (PCI = y || PCI = SSB) && PCI_DRIVERS_LEGACY
+	depends on SSB && (PCI = y || PCI = SSB) && (PCI_DRIVERS_LEGACY || !MIPS)
 	default y
 
 config SSB_PCIHOST
-- 
2.15.1
