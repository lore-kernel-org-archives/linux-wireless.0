Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63182 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab1DWQxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Apr 2011 12:53:09 -0400
Received: by bwz15 with SMTP id 15so920863bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Apr 2011 09:53:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] ssb: mark bus as powered up earlier
Date: Sat, 23 Apr 2011 19:30:28 +0200
Message-Id: <1303579829-2478-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ssb_chipco_set_clockmode may want to touch CC registers to control power of the
bus. However touching registers without powered_up set causes warnings.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/main.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index e05ba6e..74aa2cc 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1309,20 +1309,20 @@ EXPORT_SYMBOL(ssb_bus_may_powerdown);
 
 int ssb_bus_powerup(struct ssb_bus *bus, bool dynamic_pctl)
 {
-	struct ssb_chipcommon *cc;
 	int err;
 	enum ssb_clkmode mode;
 
 	err = ssb_pci_xtal(bus, SSB_GPIO_XTAL | SSB_GPIO_PLL, 1);
 	if (err)
 		goto error;
-	cc = &bus->chipco;
-	mode = dynamic_pctl ? SSB_CLKMODE_DYNAMIC : SSB_CLKMODE_FAST;
-	ssb_chipco_set_clockmode(cc, mode);
 
 #ifdef CONFIG_SSB_DEBUG
 	bus->powered_up = 1;
 #endif
+
+	mode = dynamic_pctl ? SSB_CLKMODE_DYNAMIC : SSB_CLKMODE_FAST;
+	ssb_chipco_set_clockmode(&bus->chipco, mode);
+
 	return 0;
 error:
 	ssb_printk(KERN_ERR PFX "Bus powerup failed\n");
-- 
1.7.3.4

