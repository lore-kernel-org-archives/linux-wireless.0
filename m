Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:41687 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab2CMAFl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 20:05:41 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: gregkh@linuxfoundation.org
Cc: stern@rowland.harvard.edu, linux-mips@linux-mips.org,
	ralf@linux-mips.org, m@bues.ch, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH v4 3/7] bcma: scan for extra address space
Date: Tue, 13 Mar 2012 01:04:49 +0100
Message-Id: <1331597093-425-4-git-send-email-hauke@hauke-m.de> (sfid-20120313_010547_578749_F2FC6885)
In-Reply-To: <1331597093-425-1-git-send-email-hauke@hauke-m.de>
References: <1331597093-425-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some cores like the USB core have two address spaces. In the USB host
controller one address space is used for the OHCI and the other for the
EHCI controller interface. The USB controller is the only core I found
with two address spaces. This code is based on the AI scan function
ai_scan() in shared/aiutils.c in the Broadcom SDK.

CC: Rafał Miłecki <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/scan.c       |   19 ++++++++++++++++++-
 include/linux/bcma/bcma.h |    1 +
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 3a2f672..1fa10ed 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -286,6 +286,23 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 			return -EILSEQ;
 	}
 
+	/* First Slave Address Descriptor should be port 0:
+	 * the main register space for the core
+	 */
+	tmp = bcma_erom_get_addr_desc(bus, eromptr, SCAN_ADDR_TYPE_SLAVE, 0);
+	if (tmp <= 0) {
+		/* Try again to see if it is a bridge */
+		tmp = bcma_erom_get_addr_desc(bus, eromptr,
+					      SCAN_ADDR_TYPE_BRIDGE, 0);
+		if (tmp <= 0) {
+			return -EILSEQ;
+		} else {
+			pr_info("Bridge found\n");
+			return -ENXIO;
+		}
+	}
+	core->addr = tmp;
+
 	/* get & parse slave ports */
 	for (i = 0; i < ports[1]; i++) {
 		for (j = 0; ; j++) {
@@ -298,7 +315,7 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
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

