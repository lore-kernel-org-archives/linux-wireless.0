Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39975 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737Ab2AUWTv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 17:19:51 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: ralf@linux-mips.org, linux-mips@linux-mips.org
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
	zajec5@gmail.com, linux-wireless@vger.kernel.org, m@bues.ch,
	george@znau.edu.ua, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/7] bcma: add function to check every 10 us if a reg is set
Date: Sat, 21 Jan 2012 23:19:22 +0100
Message-Id: <1327184367-8824-3-git-send-email-hauke@hauke-m.de> (sfid-20120121_232018_496217_AEA06129)
In-Reply-To: <1327184367-8824-1-git-send-email-hauke@hauke-m.de>
References: <1327184367-8824-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function checks if a reg get set or cleared every 10 microseconds.
It is used in bcma_core_set_clockmode() and bcma_core_pll_ctl() to
reduce code duplication. In addition it is needed in the USB host
driver.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/core.c       |   52 ++++++++++++++++++++++++++-------------------
 include/linux/bcma/bcma.h |    3 ++
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/bcma/core.c b/drivers/bcma/core.c
index 893f6e0..f7b7358 100644
--- a/drivers/bcma/core.c
+++ b/drivers/bcma/core.c
@@ -52,11 +52,36 @@ int bcma_core_enable(struct bcma_device *core, u32 flags)
 }
 EXPORT_SYMBOL_GPL(bcma_core_enable);
 
+/* Wait for bitmask in a register to get set or cleared.
+ * timeout is in units of ten-microseconds.
+ */
+int bcma_wait_bits(struct bcma_device *dev, u16 reg, u32 bitmask, int timeout,
+		   int set)
+{
+	int i;
+	u32 val;
+
+	for (i = 0; i < timeout; i++) {
+		val = bcma_read32(dev, reg);
+		if (set) {
+			if ((val & bitmask) == bitmask)
+				return 0;
+		} else {
+			if (!(val & bitmask))
+				return 0;
+		}
+		udelay(10);
+	}
+	pr_err("Timeout waiting for bitmask %08X on register %04X to %s.\n",
+	       bitmask, reg, (set ? "set" : "clear"));
+
+	return -ETIMEDOUT;
+}
+EXPORT_SYMBOL_GPL(bcma_wait_bits);
+
 void bcma_core_set_clockmode(struct bcma_device *core,
 			     enum bcma_clkmode clkmode)
 {
-	u16 i;
-
 	WARN_ON(core->id.id != BCMA_CORE_CHIPCOMMON &&
 		core->id.id != BCMA_CORE_PCIE &&
 		core->id.id != BCMA_CORE_80211);
@@ -65,15 +90,8 @@ void bcma_core_set_clockmode(struct bcma_device *core,
 	case BCMA_CLKMODE_FAST:
 		bcma_set32(core, BCMA_CLKCTLST, BCMA_CLKCTLST_FORCEHT);
 		udelay(64);
-		for (i = 0; i < 1500; i++) {
-			if (bcma_read32(core, BCMA_CLKCTLST) &
-			    BCMA_CLKCTLST_HAVEHT) {
-				i = 0;
-				break;
-			}
-			udelay(10);
-		}
-		if (i)
+		if (bcma_wait_bits(core, BCMA_CLKCTLST, BCMA_CLKCTLST_HAVEHT,
+				   1500, 1))
 			pr_err("HT force timeout\n");
 		break;
 	case BCMA_CLKMODE_DYNAMIC:
@@ -85,22 +103,12 @@ EXPORT_SYMBOL_GPL(bcma_core_set_clockmode);
 
 void bcma_core_pll_ctl(struct bcma_device *core, u32 req, u32 status, bool on)
 {
-	u16 i;
-
 	WARN_ON(req & ~BCMA_CLKCTLST_EXTRESREQ);
 	WARN_ON(status & ~BCMA_CLKCTLST_EXTRESST);
 
 	if (on) {
 		bcma_set32(core, BCMA_CLKCTLST, req);
-		for (i = 0; i < 10000; i++) {
-			if ((bcma_read32(core, BCMA_CLKCTLST) & status) ==
-			    status) {
-				i = 0;
-				break;
-			}
-			udelay(10);
-		}
-		if (i)
+		if (bcma_wait_bits(core, BCMA_CLKCTLST, status, 10000, 1))
 			pr_err("PLL enable timeout\n");
 	} else {
 		pr_warn("Disabling PLL not supported yet!\n");
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 7fe41e1..ebff87c 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -283,6 +283,9 @@ static inline void bcma_maskset16(struct bcma_device *cc,
 	bcma_write16(cc, offset, (bcma_read16(cc, offset) & mask) | set);
 }
 
+extern int bcma_wait_bits(struct bcma_device *dev, u16 reg, u32 bitmask,
+			  int timeout, int set);
+
 extern bool bcma_core_is_enabled(struct bcma_device *core);
 extern void bcma_core_disable(struct bcma_device *core, u32 flags);
 extern int bcma_core_enable(struct bcma_device *core, u32 flags);
-- 
1.7.5.4

