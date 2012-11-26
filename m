Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42415 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408Ab2KZXcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 18:32:04 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, m@bues.ch
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] ssb: extif: fix compile errors
Date: Tue, 27 Nov 2012 00:31:55 +0100
Message-Id: <1353972715-28331-1-git-send-email-hauke@hauke-m.de> (sfid-20121127_003208_070811_14CD8ABD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If CONFIG_SSB_EMBEDDED or CONFIG_SSB_DRIVER_MIPS is set and
CONFIG_SSB_DRIVER_EXTIF is not set, it will cause compile problems
because of missing functions. This patch fixes these problems.

The mips driver now also uses ssb_chipco_available() instead of
checking bus->chipco.dev manually.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/ssb/driver_mipscore.c        |   14 ++++++------
 include/linux/ssb/ssb_driver_extif.h |   42 ++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 7 deletions(-)

diff --git a/drivers/ssb/driver_mipscore.c b/drivers/ssb/driver_mipscore.c
index b918ba9..5bd05b1 100644
--- a/drivers/ssb/driver_mipscore.c
+++ b/drivers/ssb/driver_mipscore.c
@@ -178,9 +178,9 @@ static void ssb_mips_serial_init(struct ssb_mipscore *mcore)
 {
 	struct ssb_bus *bus = mcore->dev->bus;
 
-	if (bus->extif.dev)
+	if (ssb_extif_available(&bus->extif))
 		mcore->nr_serial_ports = ssb_extif_serial_init(&bus->extif, mcore->serial_ports);
-	else if (bus->chipco.dev)
+	else if (ssb_chipco_available(&bus->chipco))
 		mcore->nr_serial_ports = ssb_chipco_serial_init(&bus->chipco, mcore->serial_ports);
 	else
 		mcore->nr_serial_ports = 0;
@@ -191,7 +191,7 @@ static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
 	struct ssb_bus *bus = mcore->dev->bus;
 
 	/* When there is no chipcommon on the bus there is 4MB flash */
-	if (!bus->chipco.dev) {
+	if (!ssb_chipco_available(&bus->chipco)) {
 		mcore->pflash.present = true;
 		mcore->pflash.buswidth = 2;
 		mcore->pflash.window = SSB_FLASH1;
@@ -227,9 +227,9 @@ u32 ssb_cpu_clock(struct ssb_mipscore *mcore)
 	if (bus->chipco.capabilities & SSB_CHIPCO_CAP_PMU)
 		return ssb_pmu_get_cpu_clock(&bus->chipco);
 
-	if (bus->extif.dev) {
+	if (ssb_extif_available(&bus->extif)) {
 		ssb_extif_get_clockcontrol(&bus->extif, &pll_type, &n, &m);
-	} else if (bus->chipco.dev) {
+	} else if (ssb_chipco_available(&bus->chipco)) {
 		ssb_chipco_get_clockcpu(&bus->chipco, &pll_type, &n, &m);
 	} else
 		return 0;
@@ -265,9 +265,9 @@ void ssb_mipscore_init(struct ssb_mipscore *mcore)
 		hz = 100000000;
 	ns = 1000000000 / hz;
 
-	if (bus->extif.dev)
+	if (ssb_extif_available(&bus->extif))
 		ssb_extif_timing_init(&bus->extif, ns);
-	else if (bus->chipco.dev)
+	else if (ssb_chipco_available(&bus->chipco))
 		ssb_chipco_timing_init(&bus->chipco, ns);
 
 	/* Assign IRQs to all cores on the bus, start with irq line 2, because serial usually takes 1 */
diff --git a/include/linux/ssb/ssb_driver_extif.h b/include/linux/ssb/ssb_driver_extif.h
index 91161f0..2604efa 100644
--- a/include/linux/ssb/ssb_driver_extif.h
+++ b/include/linux/ssb/ssb_driver_extif.h
@@ -205,10 +205,52 @@ void ssb_extif_get_clockcontrol(struct ssb_extif *extif,
 }
 
 static inline
+void ssb_extif_timing_init(struct ssb_extif *extif, unsigned long ns)
+{
+}
+
+static inline
 void ssb_extif_watchdog_timer_set(struct ssb_extif *extif,
 				  u32 ticks)
 {
 }
 
+static inline u32 ssb_extif_gpio_in(struct ssb_extif *extif, u32 mask)
+{
+	return 0;
+}
+
+static inline u32 ssb_extif_gpio_out(struct ssb_extif *extif, u32 mask,
+				     u32 value)
+{
+	return 0;
+}
+
+static inline u32 ssb_extif_gpio_outen(struct ssb_extif *extif, u32 mask,
+				       u32 value)
+{
+	return 0;
+}
+
+static inline u32 ssb_extif_gpio_polarity(struct ssb_extif *extif, u32 mask,
+					  u32 value)
+{
+	return 0;
+}
+
+static inline u32 ssb_extif_gpio_intmask(struct ssb_extif *extif, u32 mask,
+					 u32 value)
+{
+	return 0;
+}
+
+#ifdef CONFIG_SSB_SERIAL
+static inline int ssb_extif_serial_init(struct ssb_extif *extif,
+					struct ssb_serial_port *ports)
+{
+	return 0;
+}
+#endif /* CONFIG_SSB_SERIAL */
+
 #endif /* CONFIG_SSB_DRIVER_EXTIF */
 #endif /* LINUX_SSB_EXTIFCORE_H_ */
-- 
1.7.10.4

