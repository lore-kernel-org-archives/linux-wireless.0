Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:60815 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab2GZPog (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 11:44:36 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: fix regression in interrupt assignment on mips
Date: Thu, 26 Jul 2012 17:44:12 +0200
Message-Id: <1343317452-3826-1-git-send-email-hauke@hauke-m.de> (sfid-20120726_174500_299742_A8D1F296)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wrong interrupts where assigned to the cores in
bcma_core_mips_init(). This caused at least my serial console not to
response to any input.

This was caused by this patch which changed the order of the cores in
the list:
commit c334e25c9f3a95f2bd6b79fedc5170f17245b1c7
Author: Rafał Miłecki <zajec5@gmail.com>
Date:   Wed Jul 11 12:37:00 2012 +0200

    bcma: add new cores at the end of list

This should be fixed properly later so that the correct interrupt
numbers are assigned to the cores independently from the ordering of
the list. This patch restores the old behavior again. I will look into
the problem more deeply later.

I also changed the order of the list with the cores and their assigned
interrupt number which gets printed to the log. Now they are printed in
the same order like all the other lists of cores and like it was done
before the patch which changed the order.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_mips.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index ee06dcf..aa8506d 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -131,7 +131,7 @@ static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
 			/* backplane irq line is in use, find out who uses
 			 * it and set user to irq 0
 			 */
-			list_for_each_entry_reverse(core, &bus->cores, list) {
+			list_for_each_entry(core, &bus->cores, list) {
 				if ((1 << bcma_core_mips_irqflag(core)) ==
 				    oldirqflag) {
 					bcma_core_mips_set_irq(core, 0);
@@ -161,7 +161,7 @@ static void bcma_core_mips_dump_irq(struct bcma_bus *bus)
 {
 	struct bcma_device *core;
 
-	list_for_each_entry_reverse(core, &bus->cores, list) {
+	list_for_each_entry(core, &bus->cores, list) {
 		bcma_core_mips_print_irq(core, bcma_core_mips_irq(core));
 	}
 }
@@ -226,7 +226,7 @@ void bcma_core_mips_init(struct bcma_drv_mips *mcore)
 		mcore->assigned_irqs = 1;
 
 	/* Assign IRQs to all cores on the bus */
-	list_for_each_entry_reverse(core, &bus->cores, list) {
+	list_for_each_entry(core, &bus->cores, list) {
 		int mips_irq;
 		if (core->irq)
 			continue;
-- 
1.7.9.5

