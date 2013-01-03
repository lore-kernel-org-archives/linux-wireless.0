Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38723 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab3ACXv5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 18:51:57 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	nlhintz@hotmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6/6] bcma: mips: rename oldirqflag to irqinitmask
Date: Fri,  4 Jan 2013 00:51:25 +0100
Message-Id: <1357257085-11822-7-git-send-email-hauke@hauke-m.de> (sfid-20130104_005200_247207_DF5C8827)
In-Reply-To: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
References: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new name better matches the use of this variable.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_mips.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index c6d7be3..8a51c79 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -130,9 +130,9 @@ static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
 			    bcma_read32(mdev, BCMA_MIPS_MIPS74K_INTMASK(0)) |
 			    (1 << irqflag));
 	} else {
-		u32 oldirqflag = bcma_read32(mdev,
-					     BCMA_MIPS_MIPS74K_INTMASK(irq));
-		if (oldirqflag) {
+		u32 irqinitmask = bcma_read32(mdev,
+					      BCMA_MIPS_MIPS74K_INTMASK(irq));
+		if (irqinitmask) {
 			struct bcma_device *core;
 
 			/* backplane irq line is in use, find out who uses
@@ -140,7 +140,7 @@ static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
 			 */
 			list_for_each_entry(core, &bus->cores, list) {
 				if ((1 << bcma_core_mips_irqflag(core)) ==
-				    oldirqflag) {
+				    irqinitmask) {
 					bcma_core_mips_set_irq(core, 0);
 					break;
 				}
-- 
1.7.10.4

