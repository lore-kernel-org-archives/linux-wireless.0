Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40561 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1EMTOE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:14:04 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v3] ssb: fix pcicore build breakage
Date: Fri, 13 May 2011 15:07:01 -0400
Message-Id: <1305313621-7901-1-git-send-email-linville@tuxdriver.com> (sfid-20110513_211408_407867_148D1906)
In-Reply-To: <20110513094657.5d38e959.randy.dunlap@oracle.com>
References: <20110513094657.5d38e959.randy.dunlap@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/ssb/main.c:1336: error: 'SSB_PCICORE_BCAST_ADDR' undeclared (first use in this function)
drivers/ssb/main.c:1337: error: 'SSB_PCICORE_BCAST_DATA' undeclared (first use in this function)
drivers/ssb/main.c:1349: error: 'struct ssb_pcicore' has no member named 'dev'

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/ssb/main.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index ee2937c..f8a13f8 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1332,21 +1332,27 @@ EXPORT_SYMBOL(ssb_bus_powerup);
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
 {
 	struct ssb_device *dev;
 
+#ifdef CONFIG_SSB_DRIVER_PCICORE
 	dev = bus->chipco.dev ? bus->chipco.dev : bus->pcicore.dev;
+#else
+	dev = bus->chipco.dev;
+#endif
 	if (WARN_ON(!dev))
 		return;
 	/* This forces an update of the cached registers. */
-- 
1.7.4.4

