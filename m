Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39960 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab2AUWTt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 17:19:49 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: ralf@linux-mips.org, linux-mips@linux-mips.org
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
	zajec5@gmail.com, linux-wireless@vger.kernel.org, m@bues.ch,
	george@znau.edu.ua, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/7] bcma: scan for extra address space
Date: Sat, 21 Jan 2012 23:19:21 +0100
Message-Id: <1327184367-8824-2-git-send-email-hauke@hauke-m.de> (sfid-20120121_232016_755434_998FF425)
In-Reply-To: <1327184367-8824-1-git-send-email-hauke@hauke-m.de>
References: <1327184367-8824-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some cores like the USB core have two address spaces. In the USB host
controller one address space is used for the OHCI and the other for the
EHCI controller interface. The USB controller is the only core I found
with two address spaces. This code is based on the AI scan function
ai_scan() in shared/aiutils.c i the Broadcom SDK.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/scan.c       |   18 +++++++++++++++++-
 include/linux/bcma/bcma.h |    1 +
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index cad9948..c12a7fe 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -286,6 +286,22 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 			return -EILSEQ;
 	}
 
+
+	/* First Slave Address Descriptor should be port 0:
+	 * the main register space for the core
+	 */
+	tmp = bcma_erom_get_addr_desc(bus, eromptr, SCAN_ADDR_TYPE_SLAVE, 0);
+	if (tmp <= 0) {
+		/* Try again to see if it is a bridge */
+		tmp = bcma_erom_get_addr_desc(bus, eromptr,
+					      SCAN_ADDR_TYPE_BRIDGE, 0);
+		if (tmp > 0) {
+			pr_info("found bridge\n");
+			return -ENXIO;
+		}
+	}
+	core->addr = tmp;
+
 	/* get & parse slave ports */
 	for (i = 0; i < ports[1]; i++) {
 		for (j = 0; ; j++) {
@@ -298,7 +314,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 				break;
 			} else {
 				if (i == 0 && j == 0)
-					core->addr = tmp;
+					core->addr1 = tmp;
 			}
 		}
 	}
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 83c209f..7fe41e1 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -138,6 +138,7 @@ struct bcma_device {
 	u8 core_index;
 
 	u32 addr;
+	u32 addr1;
 	u32 wrap;
 
 	void __iomem *io_addr;
-- 
1.7.5.4

