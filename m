Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:41652 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab2FAONX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 10:13:23 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend@broadcom.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] bcma: add ext PA workaround for BCM4331 and BCM43431
Date: Fri,  1 Jun 2012 09:13:17 -0500
Message-Id: <1338559997-4356-1-git-send-email-seth.forshee@canonical.com> (sfid-20120601_161327_753574_FF6029BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MacBook Pro models with BCM4331 wireless have been found to have the ext
PA lines disabled after resuming from S3 without external power attach.
This causes them to be unable to transmit. Add a workaround to ensure
that the ext PA lines are enabled on BCM4331. Also extend all handling
of ext PA line muxing to BCM43431 as is done in the Broadcom SDK.

BugLink: http://bugs.launchpad.net/bugs/925577
Cc: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: stable@vger.kernel.org
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/bcma/driver_chipcommon_pmu.c |    4 +++-
 drivers/bcma/sprom.c                 |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index a058842..61ce405 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -139,7 +139,9 @@ void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 		bcma_chipco_chipctl_maskset(cc, 0, ~0, 0x7);
 		break;
 	case 0x4331:
-		/* BCM4331 workaround is SPROM-related, we put it in sprom.c */
+	case 43431:
+		/* Ext PA lines must be enabled for tx on BCM4331 */
+		bcma_chipco_bcm4331_ext_pa_lines_ctl(cc, true);
 		break;
 	case 43224:
 		if (bus->chipinfo.rev == 0) {
diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index c7f9335..f16f42d 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -579,13 +579,13 @@ int bcma_sprom_get(struct bcma_bus *bus)
 	if (!sprom)
 		return -ENOMEM;
 
-	if (bus->chipinfo.id == 0x4331)
+	if (bus->chipinfo.id == 0x4331 || bus->chipinfo.id == 43431)
 		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, false);
 
 	pr_debug("SPROM offset 0x%x\n", offset);
 	bcma_sprom_read(bus, offset, sprom);
 
-	if (bus->chipinfo.id == 0x4331)
+	if (bus->chipinfo.id == 0x4331 || bus->chipinfo.id == 43431)
 		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, true);
 
 	err = bcma_sprom_valid(sprom);
-- 
1.7.9.5

