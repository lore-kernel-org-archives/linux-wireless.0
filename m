Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51537 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932191AbbJMNmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2015 09:42:21 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Luis de Bethencourt <luisbg@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcma: mips: Allow build if COMPILE_TEST is enabled
Date: Tue, 13 Oct 2015 15:41:58 +0200
Message-Id: <1444743718-15056-1-git-send-email-javier@osg.samsung.com> (sfid-20151013_154237_783266_907EE47E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver only has a runtime but no build time dependencies so can be
built for testing purposes if the Kconfig COMPILE_TEST option is enabled.

This is useful to have more build coverage and make sure that the driver
is not affected by changes that could cause a build regression.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/bcma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 023d448ed3fa..22114995dfbf 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -63,7 +63,7 @@ config BCMA_DRIVER_PCI_HOSTMODE
 
 config BCMA_DRIVER_MIPS
 	bool "BCMA Broadcom MIPS core driver"
-	depends on BCMA && MIPS
+	depends on BCMA && (MIPS || COMPILE_TEST)
 	help
 	  Driver for the Broadcom MIPS core attached to Broadcom specific
 	  Advanced Microcontroller Bus.
-- 
2.4.3

