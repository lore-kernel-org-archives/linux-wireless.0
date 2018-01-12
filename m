Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 9pmail.ess.barracuda.com ([64.235.154.210]:41581 "EHLO
        9pmail.ess.barracuda.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933895AbeALO22 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jan 2018 09:28:28 -0500
From: Matt Redfearn <matt.redfearn@mips.com>
To: Michael Buesch <m@bues.ch>
CC: <linux-wireless@vger.kernel.org>,
        Matt Redfearn <matt.redfearn@mips.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ssb: Prevent build of PCI host features in module
Date: Fri, 12 Jan 2018 14:25:59 +0000
Message-ID: <1515767159-17226-1-git-send-email-matt.redfearn@mips.com> (sfid-20180112_152843_914842_FA74A6B7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Attempting to build ssb.ko with CONFIG_SSB_DRIVER_PCICORE=y results in
a build error due to use of symbols not exported from vmlinux:

ERROR: "pcibios_enable_device" [drivers/ssb/ssb.ko] undefined!
ERROR: "register_pci_controller" [drivers/ssb/ssb.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:92: __modpost] Error 1

To prevent this, don't allow the host mode feature to be built if
CONFIG_SSB=m

Signed-off-by: Matt Redfearn <matt.redfearn@mips.com>
---

 drivers/ssb/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index d8e4219c2324..3e1c814e7331 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -118,7 +118,7 @@ config SSB_SERIAL
 
 config SSB_DRIVER_PCICORE_POSSIBLE
 	bool
-	depends on SSB_PCIHOST
+	depends on SSB_PCIHOST && SSB = y
 	default y
 
 config SSB_DRIVER_PCICORE
-- 
2.7.4
