Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46231 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab1DAKHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 06:07:43 -0400
Received: by wya21 with SMTP id 21so2792516wya.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 03:07:42 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: =?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: trivial: use u8 for chip_rev (it's mask is 0xF)
Date: Fri,  1 Apr 2011 12:06:48 +0200
Message-Id: <1301652408-11216-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/ssb/scan.c      |    2 +-
 include/linux/ssb/ssb.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ssb/scan.c b/drivers/ssb/scan.c
index 29884c0..7dca719 100644
--- a/drivers/ssb/scan.c
+++ b/drivers/ssb/scan.c
@@ -307,7 +307,7 @@ int ssb_bus_scan(struct ssb_bus *bus,
 	} else {
 		if (bus->bustype == SSB_BUSTYPE_PCI) {
 			bus->chip_id = pcidev_to_chipid(bus->host_pci);
-			pci_read_config_word(bus->host_pci, PCI_REVISION_ID,
+			pci_read_config_byte(bus->host_pci, PCI_REVISION_ID,
 					     &bus->chip_rev);
 			bus->chip_package = 0;
 		} else {
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 9659eff..7e99b34 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -308,7 +308,7 @@ struct ssb_bus {
 
 	/* ID information about the Chip. */
 	u16 chip_id;
-	u16 chip_rev;
+	u8 chip_rev;
 	u16 sprom_offset;
 	u16 sprom_size;		/* number of words in sprom */
 	u8 chip_package;
-- 
1.7.1

