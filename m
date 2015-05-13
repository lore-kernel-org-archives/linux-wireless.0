Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34831 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbbEMFhQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2015 01:37:16 -0400
Received: by widdi4 with SMTP id di4so182588058wid.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2015 22:37:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH FIX] ssb: extend fix for PCI related silent reboots to all chipsets
Date: Wed, 13 May 2015 07:36:38 +0200
Message-Id: <1431495398-15238-1-git-send-email-zajec5@gmail.com> (sfid-20150513_073721_044011_CD118037)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent fix for BCM4704 reboots has to be extended as the same problem
affects Linksys WRT350N v1 (BCM4705).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Reported-by: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
---
Kalle: it's quite trivial, you may consider taking it for 4.1.
---
 drivers/ssb/driver_pcicore.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 15a7ee3..5fe1c22 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -359,12 +359,13 @@ static void ssb_pcicore_init_hostmode(struct ssb_pcicore *pc)
 
 	/*
 	 * Accessing PCI config without a proper delay after devices reset (not
-	 * GPIO reset) was causing reboots on WRT300N v1.0.
+	 * GPIO reset) was causing reboots on WRT300N v1.0 (BCM4704).
 	 * Tested delay 850 us lowered reboot chance to 50-80%, 1000 us fixed it
 	 * completely. Flushing all writes was also tested but with no luck.
+	 * The same problem was reported for WRT350N v1 (BCM4705), so we just
+	 * sleep here unconditionally.
 	 */
-	if (pc->dev->bus->chip_id == 0x4704)
-		usleep_range(1000, 2000);
+	usleep_range(1000, 2000);
 
 	/* Enable PCI bridge BAR0 prefetch and burst */
 	val = PCI_COMMAND_MASTER | PCI_COMMAND_MEMORY;
-- 
1.8.4.5

