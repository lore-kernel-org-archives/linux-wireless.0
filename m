Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40719 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZCKCwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 22:52:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v5 1/4] ath9k: implement IO serialization
Date: Tue, 10 Mar 2009 22:52:30 -0400
Message-Id: <1236739953-17701-2-git-send-email-lrodriguez@atheros.com> (sfid-20090311_035323_043986_25539888)
In-Reply-To: <1236739953-17701-1-git-send-email-lrodriguez@atheros.com>
References: <1236739953-17701-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All 802.11n PCI devices (Cardbus, PCI, mini-PCI) require
serialization of IO when on non-uniprocessor systems. PCI
express devices not not require this.

This should fix our only last standing open ath9k kernel.org
bugzilla bug report:

http://bugzilla.kernel.org/show_bug.cgi?id=12110

A port is probably required to older kernels and I can work on
that.

Tested-by: Adel Gadllah <adel.gadllah@gmail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath9k/ath9k.h |   34 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/hw.c    |   19 +++++++++++++++++++
 drivers/net/wireless/ath9k/hw.h    |    6 ++++--
 drivers/net/wireless/ath9k/main.c  |    1 +
 4 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index f0b105a..050304e 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -579,6 +579,7 @@ struct ath_softc {
 	void __iomem *mem;
 	int irq;
 	spinlock_t sc_resetlock;
+	spinlock_t sc_serial_rw;
 	struct mutex mutex;
 
 	u8 curbssid[ETH_ALEN];
@@ -724,4 +725,37 @@ void ath9k_wiphy_pause_all_forced(struct ath_softc *sc,
 bool ath9k_wiphy_scanning(struct ath_softc *sc);
 void ath9k_wiphy_work(struct work_struct *work);
 
+/*
+ * Read and write, they both share the same lock. We do this to serialize
+ * reads and writes on Atheros 802.11n PCI devices only. This is required
+ * as the FIFO on these devices can only accept sanely 2 requests. After
+ * that the device goes bananas. Serializing the reads/writes prevents this
+ * from happening.
+ */
+
+static inline void ath9k_iowrite32(struct ath_hw *ah, u32 reg_offset, u32 val)
+{
+	if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
+		unsigned long flags;
+		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
+		iowrite32(val, ah->ah_sc->mem + reg_offset);
+		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
+	} else
+		iowrite32(val, ah->ah_sc->mem + reg_offset);
+}
+
+static inline unsigned int ath9k_ioread32(struct ath_hw *ah, u32 reg_offset)
+{
+	u32 val;
+	if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
+		unsigned long flags;
+		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
+		val = ioread32(ah->ah_sc->mem + reg_offset);
+		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
+	} else
+		val = ioread32(ah->ah_sc->mem + reg_offset);
+	return val;
+}
+
+
 #endif /* ATH9K_H */
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index ea550cc..50a44a0 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -391,6 +391,25 @@ static void ath9k_hw_set_defaults(struct ath_hw *ah)
 	}
 
 	ah->config.intr_mitigation = 1;
+
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
+	if (num_possible_cpus() > 1)
+		ah->config.serialize_regmode = SER_REG_MODE_AUTO;
 }
 
 static struct ath_hw *ath9k_hw_newstate(u16 devid, struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 89936a0..43de66d 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -20,6 +20,7 @@
 #include <linux/if_ether.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/spinlock.h>
 
 #include "mac.h"
 #include "ani.h"
@@ -28,6 +29,7 @@
 #include "regd.h"
 #include "reg.h"
 #include "phy.h"
+#include "ath9k.h"
 
 #define ATHEROS_VENDOR_ID	0x168c
 #define AR5416_DEVID_PCI	0x0023
@@ -42,8 +44,8 @@
 #define AR5416_MAGIC		0x19641014
 
 /* Register read/write primitives */
-#define REG_WRITE(_ah, _reg, _val) iowrite32(_val, _ah->ah_sc->mem + _reg)
-#define REG_READ(_ah, _reg) ioread32(_ah->ah_sc->mem + _reg)
+#define REG_WRITE(_ah, _reg, _val) ath9k_iowrite32((_ah), (_reg), (_val))
+#define REG_READ(_ah, _reg) ath9k_ioread32((_ah), (_reg))
 
 #define SM(_v, _f)  (((_v) << _f##_S) & _f)
 #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index a2f5af6..8db75f6 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1370,6 +1370,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 
 	spin_lock_init(&sc->wiphy_lock);
 	spin_lock_init(&sc->sc_resetlock);
+	spin_lock_init(&sc->sc_serial_rw);
 	mutex_init(&sc->mutex);
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
 	tasklet_init(&sc->bcon_tasklet, ath_beacon_tasklet,
-- 
1.6.0.6

