Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:50477 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab3BZJCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 04:02:30 -0500
Received: by mail-ea0-f171.google.com with SMTP id c13so13020eaa.16
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2013 01:02:29 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: implement disabling PLLs
Date: Tue, 26 Feb 2013 10:02:23 +0100
Message-Id: <1361869343-29862-1-git-send-email-zajec5@gmail.com> (sfid-20130226_100237_797672_D3C13CF9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
index 03bbe10..17b26ce 100644
--- a/drivers/bcma/core.c
+++ b/drivers/bcma/core.c
@@ -104,7 +104,13 @@ void bcma_core_pll_ctl(struct bcma_device *core, u32 req, u32 status, bool on)
 		if (i)
 			bcma_err(core->bus, "PLL enable timeout\n");
 	} else {
-		bcma_warn(core->bus, "Disabling PLL not supported yet!\n");
+		/*
+		 * Mask the PLL but don't wait for it to be disabled. PLL may be
+		 * shared between cores and will be still up if there is another
+		 * core using it.
+		 */
+		bcma_mask32(core, BCMA_CLKCTLST, ~req);
+		bcma_read32(core, BCMA_CLKCTLST);
 	}
 }
 EXPORT_SYMBOL_GPL(bcma_core_pll_ctl);
-- 
1.7.10.4

