Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40140 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab1EMOaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 10:30:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2] ssb: fix pcicore build breakage
Date: Fri, 13 May 2011 10:22:50 -0400
Message-Id: <1305296570-23671-1-git-send-email-linville@tuxdriver.com> (sfid-20110513_163058_592326_7DFEF362)
In-Reply-To: <1305294214.12573.3.camel@maggie>
References: <1305294214.12573.3.camel@maggie>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/ssb/main.c:1336: error: 'SSB_PCICORE_BCAST_ADDR' undeclared (first use in this function)
drivers/ssb/main.c:1337: error: 'SSB_PCICORE_BCAST_DATA' undeclared (first use in this function)
drivers/ssb/main.c:1349: error: 'struct ssb_pcicore' has no member named 'dev'

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
Use CHIPCO definitions since they should always(?) be valid...

 drivers/ssb/main.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index ee2937c..b2abd0f 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1332,14 +1332,16 @@ EXPORT_SYMBOL(ssb_bus_powerup);
 static void ssb_broadcast_value(struct ssb_device *dev,
 				u32 address, u32 data)
 {
+#ifdef CONFIG_SSB_DRIVER_PCICORE
 	/* This is used for both, PCI and ChipCommon core, so be careful. */
 	BUILD_BUG_ON(SSB_PCICORE_BCAST_ADDR != SSB_CHIPCO_BCAST_ADDR);
 	BUILD_BUG_ON(SSB_PCICORE_BCAST_DATA != SSB_CHIPCO_BCAST_DATA);
+#endif
 
-	ssb_write32(dev, SSB_PCICORE_BCAST_ADDR, address);
-	ssb_read32(dev, SSB_PCICORE_BCAST_ADDR); /* flush */
-	ssb_write32(dev, SSB_PCICORE_BCAST_DATA, data);
-	ssb_read32(dev, SSB_PCICORE_BCAST_DATA); /* flush */
+	ssb_write32(dev, SSB_CHIPCO_BCAST_ADDR, address);
+	ssb_read32(dev, SSB_CHIPCO_BCAST_ADDR); /* flush */
+	ssb_write32(dev, SSB_CHIPCO_BCAST_DATA, data);
+	ssb_read32(dev, SSB_CHIPCO_BCAST_DATA); /* flush */
 }
 
 void ssb_commit_settings(struct ssb_bus *bus)
-- 
1.7.4.4

