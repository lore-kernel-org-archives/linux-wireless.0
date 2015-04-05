Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37268 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbbDEQjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Apr 2015 12:39:36 -0400
Received: by wiaa2 with SMTP id a2so14545718wia.0
        for <linux-wireless@vger.kernel.org>; Sun, 05 Apr 2015 09:39:35 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Felix Fietkau <nbd@openwrt.org>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
	Larry Finger <larry.finger@lwfinger.net>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: add delay after PCI reset to fix SoC reboots
Date: Sun,  5 Apr 2015 18:39:27 +0200
Message-Id: <1428251967-18066-1-git-send-email-zajec5@gmail.com> (sfid-20150405_183939_954171_75C0899B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Kalle: this bug is there since ever, I guess this patch can be queued for next.
---
 drivers/ssb/driver_pcicore.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index d75b72b..15a7ee3 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -357,6 +357,15 @@ static void ssb_pcicore_init_hostmode(struct ssb_pcicore *pc)
 	pcicore_write32(pc, SSB_PCICORE_SBTOPCI2,
 			SSB_PCICORE_SBTOPCI_MEM | SSB_PCI_DMA);
 
+	/*
+	 * Accessing PCI config without a proper delay after devices reset (not
+	 * GPIO reset) was causing reboots on WRT300N v1.0.
+	 * Tested delay 850 us lowered reboot chance to 50-80%, 1000 us fixed it
+	 * completely. Flushing all writes was also tested but with no luck.
+	 */
+	if (pc->dev->bus->chip_id == 0x4704)
+		usleep_range(1000, 2000);
+
 	/* Enable PCI bridge BAR0 prefetch and burst */
 	val = PCI_COMMAND_MASTER | PCI_COMMAND_MEMORY;
 	ssb_extpci_write_config(pc, 0, 0, 0, PCI_COMMAND, &val, 2);
-- 
1.8.4.5

