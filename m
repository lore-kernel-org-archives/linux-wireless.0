Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38708 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003Ab3ACXvw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 18:51:52 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	nlhintz@hotmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/6] bcma: mips: remove assigned_irqs from structure
Date: Fri,  4 Jan 2013 00:51:24 +0100
Message-Id: <1357257085-11822-6-git-send-email-hauke@hauke-m.de> (sfid-20130104_005155_355144_04B45BD7)
In-Reply-To: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
References: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This member is not needed any more.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_mips.c            |    2 --
 include/linux/bcma/bcma_driver_mips.h |    1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 6981507..c6d7be3 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -263,8 +263,6 @@ void bcma_core_mips_init(struct bcma_drv_mips *mcore)
 
 	bcma_core_mips_early_init(mcore);
 
-	mcore->assigned_irqs = 1;
-
 	switch (bus->chipinfo.id) {
 	case BCMA_CHIP_ID_BCM4716:
 	case BCMA_CHIP_ID_BCM4748:
diff --git a/include/linux/bcma/bcma_driver_mips.h b/include/linux/bcma/bcma_driver_mips.h
index 0baf8a5..6495579 100644
--- a/include/linux/bcma/bcma_driver_mips.h
+++ b/include/linux/bcma/bcma_driver_mips.h
@@ -36,7 +36,6 @@ struct bcma_drv_mips {
 	struct bcma_device *core;
 	u8 setup_done:1;
 	u8 early_setup_done:1;
-	unsigned int assigned_irqs;
 };
 
 #ifdef CONFIG_BCMA_DRIVER_MIPS
-- 
1.7.10.4

