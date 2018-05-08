Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:37257 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754457AbeEHJcA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 05:32:00 -0400
Received: by mail-lf0-f65.google.com with SMTP id r2-v6so8698890lff.4
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2018 02:32:00 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Joe Perches <joe@perches.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 4.17] bcma: fix buffer size caused crash in bcma_core_mips_print_irq()
Date: Tue,  8 May 2018 11:31:04 +0200
Message-Id: <20180508093104.27018-1-zajec5@gmail.com> (sfid-20180508_113205_145918_90D0C2D2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

Used buffer wasn't big enough to hold whole strings. Example output of
this function is:
[    0.180892] bcma: bus0: core 0x0800, irq: 2(S)* 3  4  5  6  D  I
[    0.180948] bcma: bus0: core 0x0812, irq: 2(S)  3* 4  5  6  D  I
[    0.180998] bcma: bus0: core 0x082d, irq: 2(S)  3  4* 5  6  D  I
[    0.181046] bcma: bus0: core 0x082c, irq: 2(S)  3  4  5  6  D  I*
which means we need to store up to 24 chars.

Fixes: 758f7e06063a8 ("bcma: Use bcma_debug and not pr_cont in MIPS driver")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Cc: stable@vger.kernel.org # v4.15+
---
 drivers/bcma/driver_mips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index f040aba48d50..27e9686b6d3a 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -184,7 +184,7 @@ static void bcma_core_mips_print_irq(struct bcma_device *dev, unsigned int irq)
 {
 	int i;
 	static const char *irq_name[] = {"2(S)", "3", "4", "5", "6", "D", "I"};
-	char interrupts[20];
+	char interrupts[25];
 	char *ints = interrupts;
 
 	for (i = 0; i < ARRAY_SIZE(irq_name); i++)
-- 
2.13.6
