Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56111 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab2GIRfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 13:35:06 -0400
Received: by eeit10 with SMTP id t10so4416043eei.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 10:35:05 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: fix CC driver compilation on MIPS
Date: Mon,  9 Jul 2012 19:34:59 +0200
Message-Id: <1341855299-29661-1-git-send-email-zajec5@gmail.com> (sfid-20120709_193512_070175_1735F3A9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
!!! SORRY !!!
---
 drivers/bcma/driver_chipcommon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 61c19ce..a4c3ebc 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -137,7 +137,7 @@ void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
 				       | BCMA_CC_CORECTL_UARTCLKEN);
 		}
 	} else {
-		bcma_err(bus, "serial not supported on this device ccrev: 0x%x\n", ccrev);
+		bcma_err(cc->core->bus, "serial not supported on this device ccrev: 0x%x\n", ccrev);
 		return;
 	}
 
-- 
1.7.7

