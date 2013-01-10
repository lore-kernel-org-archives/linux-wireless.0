Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58819 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755135Ab3AJQwu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 11:52:50 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: fix compile error
Date: Thu, 10 Jan 2013 17:52:38 +0100
Message-Id: <1357836758-12422-1-git-send-email-hauke@hauke-m.de> (sfid-20130110_175305_049885_A0B23AF4)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This error was introduced in:
commit e3f05a42faac627d8704c76c1927e09b22443b7b
Author: Hauke Mehrtens <hauke@hauke-m.de>
Date:   Fri Jan 4 00:51:21 2013 +0100

    bcma: mips: explicit assign IRQ numbers

  CC      drivers/bcma/driver_mips.o
drivers/bcma/driver_mips.c: In function 'bcma_core_mips_init':
drivers/bcma/driver_mips.c:302:4: error: implicit declaration of
function 'bcma_core_irq' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[6]: *** [drivers/bcma/driver_mips.o] Error 1

Reported-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_mips.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 8a51c79..90f20a2 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -299,7 +299,7 @@ void bcma_core_mips_init(struct bcma_drv_mips *mcore)
 		break;
 	default:
 		list_for_each_entry(core, &bus->cores, list) {
-			core->irq = bcma_core_irq(core);
+			core->irq = bcma_core_mips_irq(core) + 2;
 		}
 		bcma_err(bus,
 			 "Unknown device (0x%x) found, can not configure IRQs\n",
-- 
1.7.10.4

