Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59117 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448Ab2I2SiQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2012 14:38:16 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: use fallback sprom if sprom on card was not valid
Date: Sat, 29 Sep 2012 20:38:11 +0200
Message-Id: <1348943891-23352-1-git-send-email-hauke@hauke-m.de> (sfid-20120929_203819_413512_68EEC4D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sometimes the PCIe card indicates that it has a sprom somewhere and we
are able to read the memory region, but it is empty and not valid. In
these cases we should try to use the fallback sprom as a last chance.

This is the case for the PCIe cards in my ASUS RT-N66U (BCM4706 + 2
times BCM4331) and I have heard of someone having the same problem with
an other PCIe card connected to an other Broadcom SoC.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/sprom.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 0d546b6..4adf9ef9 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -595,8 +595,11 @@ int bcma_sprom_get(struct bcma_bus *bus)
 		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, true);
 
 	err = bcma_sprom_valid(sprom);
-	if (err)
+	if (err) {
+		bcma_warn(bus, "invalid sprom read from the PCIe card, try to use fallback sprom\n");
+		err = bcma_fill_sprom_with_fallback(bus, &bus->sprom);
 		goto out;
+	}
 
 	bcma_sprom_extract_r8(bus, sprom);
 
-- 
1.7.9.5

