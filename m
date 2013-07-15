Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55252 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab3GOLPZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 07:15:25 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/5] bcma: make it possible to select SoC support without mips
Date: Mon, 15 Jul 2013 13:15:05 +0200
Message-Id: <1373886908-4460-3-git-send-email-hauke@hauke-m.de> (sfid-20130715_131529_682075_2F836A38)
In-Reply-To: <1373886908-4460-1-git-send-email-hauke@hauke-m.de>
References: <1373886908-4460-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To make it possible to use the SoC host interface with ARM SoCs do not
depend on the MIPS driver any more.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/Kconfig |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 380a200..7c081b3 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -35,8 +35,14 @@ config BCMA_DRIVER_PCI_HOSTMODE
 	  PCI core hostmode operation (external PCI bus).
 
 config BCMA_HOST_SOC
-	bool
-	depends on BCMA_DRIVER_MIPS
+	bool "Support for BCMA in a SoC"
+	depends on BCMA
+	help
+	  Host interface for a Broadcom AIX bus directly mapped into
+	  the memory. This only works with the Broadcom SoCs from the
+	  BCM47XX line.
+
+	  If unsure, say N
 
 config BCMA_DRIVER_MIPS
 	bool "BCMA Broadcom MIPS core driver"
-- 
1.7.10.4

