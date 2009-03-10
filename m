Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33673 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbZCJCHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:07:06 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/4] ath9k: add cpu notifier to enhance device configuration
Date: Mon,  9 Mar 2009 22:07:03 -0400
Message-Id: <1236650824-9568-4-git-send-email-lrodriguez@atheros.com> (sfid-20090310_030715_072673_9BFB5191)
In-Reply-To: <1236650824-9568-1-git-send-email-lrodriguez@atheros.com>
References: <1236650824-9568-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon CPU Hotplug the number of CPUs can change and we can tweak
our driver configuration as such. Keep in mind CPU hotplug also
occurs during suspend/resume.

Since we have a notifier now we can rely on num_present_cpus()
rather than num_possible_cpus() to enable/disable serialization.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    7 +++++
 drivers/net/wireless/ath9k/hw.c    |   49 ++++++++++++++++++++++-------------
 drivers/net/wireless/ath9k/hw.h    |    3 ++
 drivers/net/wireless/ath9k/main.c  |   29 +++++++++++++++++++++
 drivers/net/wireless/ath9k/pci.c   |    4 +++
 5 files changed, 74 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 90ee2e3..a2e9b1e 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -22,6 +22,7 @@
 #include <net/mac80211.h>
 #include <linux/leds.h>
 #include <linux/rfkill.h>
+#include <linux/cpu.h>
 
 #include "hw.h"
 #include "rc.h"
@@ -554,6 +555,9 @@ struct ath_bus_ops {
 
 struct ath_wiphy;
 
+int ath9k_cpu_callback(struct notifier_block *nfb,
+		       unsigned long action, void *hcpu);
+
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
@@ -573,6 +577,9 @@ struct ath_softc {
 	unsigned long wiphy_scheduler_int;
 	int wiphy_scheduler_index;
 
+	/* This should or _needs_ to be __cpuinit (?) */
+	struct notifier_block cpu_notifer;
+
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
 	struct ath_hw *sc_ah;
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 05df570..3bbc257 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -16,6 +16,7 @@
 
 #include <linux/io.h>
 #include <asm/unaligned.h>
+#include <linux/cpu.h>
 
 #include "ath9k.h"
 #include "initvals.h"
@@ -385,6 +386,35 @@ static const char *ath9k_hw_devname(u16 devid)
 	return NULL;
 }
 
+/*
+ * We can slap on to here things we need to tune depending
+ * on the number of CPUs. This will happen on CPU hotplug
+ * which is also used for suspend/resume.
+ */
+void ath9k_hw_config_for_cpus(struct ath_hw *ah)
+{
+	/*
+	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
+	 * _and_ if on non-uniprocessor systems (Multiprocessor/HT).
+	 * This means we use it for all AR5416 devices, and the few
+	 * minor PCI AR9280 devices out there.
+	 *
+	 * Serialization is required because these devices do not handle
+	 * well the case of two concurrent reads/writes due to the latency
+	 * involved. During one read/write another read/write can be issued
+	 * on another CPU while the previous read/write may still be working
+	 * on our hardware, if we hit this case the hardware poops in a loop.
+	 * We prevent this by serializing reads and writes.
+	 *
+	 * This issue is not present on PCI-Express devices or pre-AR5416
+	 * devices (legacy, 802.11abg).
+	 */
+	if (num_present_cpus() > 1)
+		ah->config.serialize_regmode = SER_REG_MODE_AUTO;
+	else
+		ah->config.serialize_regmode = SER_REG_MODE_OFF;
+}
+
 static void ath9k_hw_set_defaults(struct ath_hw *ah)
 {
 	int i;
@@ -424,24 +454,7 @@ static void ath9k_hw_set_defaults(struct ath_hw *ah)
 
 	ah->config.intr_mitigation = 1;
 
-	/*
-	 * We need this for PCI devices only (Cardbus, PCI, miniPCI)
-	 * _and_ if on non-uniprocessor systems (Multiprocessor/HT).
-	 * This means we use it for all AR5416 devices, and the few
-	 * minor PCI AR9280 devices out there.
-	 *
-	 * Serialization is required because these devices do not handle
-	 * well the case of two concurrent reads/writes due to the latency
-	 * involved. During one read/write another read/write can be issued
-	 * on another CPU while the previous read/write may still be working
-	 * on our hardware, if we hit this case the hardware poops in a loop.
-	 * We prevent this by serializing reads and writes.
-	 *
-	 * This issue is not present on PCI-Express devices or pre-AR5416
-	 * devices (legacy, 802.11abg).
-	 */
-	if (num_possible_cpus() > 1)
-		ah->config.serialize_regmode = SER_REG_MODE_AUTO;
+	ath9k_hw_config_for_cpus(ah);
 }
 
 static struct ath_hw *ath9k_hw_newstate(u16 devid, struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 790bfa9..c2d32bb 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -570,6 +570,9 @@ struct ath_hw {
 void ath9k_iowrite32(struct ath_hw *ah, u32 reg_offset, u32 val);
 unsigned int ath9k_ioread32(struct ath_hw *ah, u32 reg_offset);
 
+/* Lets us tweak the device per CPU changes */
+void ath9k_hw_config_for_cpus(struct ath_hw *ah);
+
 /* Attach, Detach, Reset */
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_detach(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 2ad6414..94ea72a 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2787,6 +2787,35 @@ struct ieee80211_ops ath9k_ops = {
 	.sw_scan_complete   = ath9k_sw_scan_complete,
 };
 
+int ath9k_cpu_callback(struct notifier_block *nfb,
+		       unsigned long action, void *hcpu)
+{
+	struct ath_softc *sc = container_of(nfb, struct ath_softc, cpu_notifer);
+	int old_serial_mode;
+
+	old_serial_mode = sc->sc_ah->config.serialize_regmode;
+
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		ath9k_hw_config_for_cpus(sc->sc_ah);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		ath9k_hw_config_for_cpus(sc->sc_ah);
+		break;
+	}
+
+	if (unlikely(old_serial_mode != sc->sc_ah->config.serialize_regmode)) {
+		DPRINTF(sc, ATH_DBG_RESET,
+			"serialize_regmode has changed due to CPU "
+			"count to %d\n",
+			sc->sc_ah->config.serialize_regmode);
+	}
+
+	return NOTIFY_OK;
+}
+
 static struct {
 	u32 version;
 	const char * name;
diff --git a/drivers/net/wireless/ath9k/pci.c b/drivers/net/wireless/ath9k/pci.c
index 9a58baa..c1ba207 100644
--- a/drivers/net/wireless/ath9k/pci.c
+++ b/drivers/net/wireless/ath9k/pci.c
@@ -181,6 +181,9 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto bad3;
 	}
 
+	sc->cpu_notifer.notifier_call = ath9k_cpu_callback;
+	register_hotcpu_notifier(&sc->cpu_notifer);
+
 	/* setup interrupt service routine */
 
 	if (request_irq(pdev->irq, ath_isr, IRQF_SHARED, "ath", sc)) {
@@ -223,6 +226,7 @@ static void ath_pci_remove(struct pci_dev *pdev)
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 
+	unregister_hotcpu_notifier(&sc->cpu_notifer);
 	ath_cleanup(sc);
 }
 
-- 
1.6.0.6

