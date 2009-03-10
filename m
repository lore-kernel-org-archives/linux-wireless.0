Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33669 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbZCJCHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 22:07:06 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/4] ath9k: implement IO serialization
Date: Mon,  9 Mar 2009 22:07:01 -0400
Message-Id: <1236650824-9568-2-git-send-email-lrodriguez@atheros.com> (sfid-20090310_030711_971870_E038CD47)
In-Reply-To: <1236650824-9568-1-git-send-email-lrodriguez@atheros.com>
References: <1236650824-9568-1-git-send-email-lrodriguez@atheros.com>
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
---
 drivers/net/wireless/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath9k/hw.c    |   51 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/hw.h    |    8 ++++-
 drivers/net/wireless/ath9k/main.c  |    1 +
 4 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index f0b105a..90ee2e3 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -579,6 +579,7 @@ struct ath_softc {
 	void __iomem *mem;
 	int irq;
 	spinlock_t sc_resetlock;
+	spinlock_t sc_serial_rw;
 	struct mutex mutex;
 
 	u8 curbssid[ETH_ALEN];
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index c10b33b..c6e6899 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -37,6 +37,38 @@ static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
 static void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
 static void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
 
+/*
+ * Read and write, they both share the same lock. We do this to serialize
+ * reads and writes on Atheros 802.11n PCI devices only. This is required
+ * as the FIFO on these devices can only accept sanely 2 requests. After
+ * that the device goes bananas. Serializing the reads/writes prevents this
+ * from happening.
+ */
+
+void ath9k_iowrite32(struct ath_hw *ah, u32 reg_offset, u32 val)
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
+unsigned int ath9k_ioread32(struct ath_hw *ah, u32 reg_offset)
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
 /********************/
 /* Helper Functions */
 /********************/
@@ -391,6 +423,25 @@ static void ath9k_hw_set_defaults(struct ath_hw *ah)
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
index 89936a0..790bfa9 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -42,8 +42,8 @@
 #define AR5416_MAGIC		0x19641014
 
 /* Register read/write primitives */
-#define REG_WRITE(_ah, _reg, _val) iowrite32(_val, _ah->ah_sc->mem + _reg)
-#define REG_READ(_ah, _reg) ioread32(_ah->ah_sc->mem + _reg)
+#define REG_WRITE(_ah, _reg, _val) ath9k_iowrite32(_ah, _reg, _val)
+#define REG_READ(_ah, _reg) ath9k_ioread32(_ah, _reg)
 
 #define SM(_v, _f)  (((_v) << _f##_S) & _f)
 #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
@@ -566,6 +566,10 @@ struct ath_hw {
 	struct ar5416IniArray iniModesTxGain;
 };
 
+/* Read and write */
+void ath9k_iowrite32(struct ath_hw *ah, u32 reg_offset, u32 val);
+unsigned int ath9k_ioread32(struct ath_hw *ah, u32 reg_offset);
+
 /* Attach, Detach, Reset */
 const char *ath9k_hw_probe(u16 vendorid, u16 devid);
 void ath9k_hw_detach(struct ath_hw *ah);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 5268697..2ad6414 100644
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

