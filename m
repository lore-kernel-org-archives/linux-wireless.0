Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51713 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab3FIQ7w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 12:59:52 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] bcma: activate PCI host option by default
Date: Sun,  9 Jun 2013 18:59:42 +0200
Message-Id: <1370797183-5510-1-git-send-email-hauke@hauke-m.de> (sfid-20130609_185956_220383_E2C85BED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most users are using bcma with a PCIe card, activate support for
this by default.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 8b4221c..380a200 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -26,6 +26,7 @@ config BCMA_HOST_PCI_POSSIBLE
 config BCMA_HOST_PCI
 	bool "Support for BCMA on PCI-host bus"
 	depends on BCMA_HOST_PCI_POSSIBLE
+	default y
 
 config BCMA_DRIVER_PCI_HOSTMODE
 	bool "Driver for PCI core working in hostmode"
-- 
1.7.10.4

