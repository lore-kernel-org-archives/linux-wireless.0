Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:43360 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477AbbCER2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 12:28:25 -0500
Received: by wesu56 with SMTP id u56so54393065wes.10
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2015 09:28:24 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Arnd Bergmann <arnd@arndb.de>,
	Chen Gang <xili_gchen_5257@hotmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] Revert "bcma: Kconfig: Let it depend on PCI"
Date: Thu,  5 Mar 2015 18:25:12 +0100
Message-Id: <1425576312-2779-3-git-send-email-zajec5@gmail.com> (sfid-20150305_182835_112430_236A660A)
In-Reply-To: <1425576312-2779-1-git-send-email-zajec5@gmail.com>
References: <1425576312-2779-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit b09f5ec18b16b82f4db8a735e453332db7514275.

Now that we have fully working BCMA_DRIVER_PCI symbol (in can be safely
disabled), there is no risk bcma will try to use PCI code without PCI
available.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 1500b71..fc6ffcf 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -1,6 +1,6 @@
 config BCMA_POSSIBLE
 	bool
-	depends on HAS_IOMEM && HAS_DMA && PCI
+	depends on HAS_IOMEM && HAS_DMA
 	default y
 
 menu "Broadcom specific AMBA"
-- 
1.8.4.5

