Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44614 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868Ab1CWT5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 15:57:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 02/10] ath9k_hw: add a new register op for read-mask-write
Date: Wed, 23 Mar 2011 20:57:25 +0100
Message-Id: <1300910253-28189-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1300910253-28189-1-git-send-email-nbd@openwrt.org>
References: <1300910253-28189-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reduces the number of calls to register ops. On MIPS this reduces the
ath9k_hw binary size from 321k down to 310k

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath.h                |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   12 ++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h           |   12 ++++++------
 drivers/net/wireless/ath/ath9k/init.c         |   23 +++++++++++++++++++++++
 4 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index a6c6a46..6d7105b 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -119,6 +119,7 @@ struct ath_ops {
 	void (*write)(void *, u32 val, u32 reg_offset);
 	void (*enable_write_buffer)(void *);
 	void (*write_flush) (void *);
+	u32 (*rmw)(void *, u32 reg_offset, u32 set, u32 clr);
 };
 
 struct ath_common;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 4e26946..ca69e7c 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -430,6 +430,17 @@ static void ath9k_regwrite_flush(void *hw_priv)
 	mutex_unlock(&priv->wmi->multi_write_mutex);
 }
 
+static u32 ath9k_reg_rmw(void *hw_priv, u32 reg_offset, u32 set, u32 clr)
+{
+	u32 val;
+
+	val = ath9k_regread(hw_priv, reg_offset);
+	val &= ~clr;
+	val |= set;
+	ath9k_regwrite(hw_priv, val, reg_offset);
+	return val;
+}
+
 static void ath_usb_read_cachesize(struct ath_common *common, int *csz)
 {
 	*csz = L1_CACHE_BYTES >> 2;
@@ -655,6 +666,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	ah->reg_ops.write = ath9k_regwrite;
 	ah->reg_ops.enable_write_buffer = ath9k_enable_regwrite_buffer;
 	ah->reg_ops.write_flush = ath9k_regwrite_flush;
+	ah->reg_ops.rmw = ath9k_reg_rmw;
 	priv->ah = ah;
 
 	common = ath9k_hw_common(ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ef387a2..e256658 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -73,6 +73,9 @@
 #define REG_READ_MULTI(_ah, _addr, _val, _cnt)		\
 	(_ah)->reg_ops.multi_read((_ah), (_addr), (_val), (_cnt))
 
+#define REG_RMW(_ah, _reg, _set, _clr) \
+	(_ah)->reg_ops.rmw((_ah), (_reg), (_set), (_clr))
+
 #define ENABLE_REGWRITE_BUFFER(_ah)					\
 	do {								\
 		if ((_ah)->reg_ops.enable_write_buffer)	\
@@ -87,17 +90,14 @@
 
 #define SM(_v, _f)  (((_v) << _f##_S) & _f)
 #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
-#define REG_RMW(_a, _r, _set, _clr)    \
-	REG_WRITE(_a, _r, (REG_READ(_a, _r) & ~(_clr)) | (_set))
 #define REG_RMW_FIELD(_a, _r, _f, _v) \
-	REG_WRITE(_a, _r, \
-	(REG_READ(_a, _r) & ~_f) | (((_v) << _f##_S) & _f))
+	REG_RMW(_a, _r, (((_v) << _f##_S) & _f), (_f))
 #define REG_READ_FIELD(_a, _r, _f) \
 	(((REG_READ(_a, _r) & _f) >> _f##_S))
 #define REG_SET_BIT(_a, _r, _f) \
-	REG_WRITE(_a, _r, REG_READ(_a, _r) | (_f))
+	REG_RMW(_a, _r, (_f), 0)
 #define REG_CLR_BIT(_a, _r, _f) \
-	REG_WRITE(_a, _r, REG_READ(_a, _r) & ~(_f))
+	REG_RMW(_a, _r, 0, (_f))
 
 #define DO_DELAY(x) do {					\
 		if (((++(x) % 64) == 0) &&			\
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index b45fd3f..9790636a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -196,6 +196,28 @@ static unsigned int ath9k_ioread32(void *hw_priv, u32 reg_offset)
 	return val;
 }
 
+static unsigned int ath9k_reg_rmw(void *hw_priv, u32 reg_offset, u32 set, u32 clr)
+{
+	struct ath_hw *ah = (struct ath_hw *) hw_priv;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
+	unsigned long uninitialized_var(flags);
+	u32 val;
+
+	if (ah->config.serialize_regmode == SER_REG_MODE_ON)
+		spin_lock_irqsave(&sc->sc_serial_rw, flags);
+
+	val = ioread32(sc->mem + reg_offset);
+	val &= ~clr;
+	val |= set;
+	iowrite32(val, sc->mem + reg_offset);
+
+	if (ah->config.serialize_regmode == SER_REG_MODE_ON)
+		spin_unlock_irqrestore(&sc->sc_serial_rw, flags);
+
+	return val;
+}
+
 /**************************/
 /*     Initialization     */
 /**************************/
@@ -548,6 +570,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	ah->hw_version.subsysid = subsysid;
 	ah->reg_ops.read = ath9k_ioread32;
 	ah->reg_ops.write = ath9k_iowrite32;
+	ah->reg_ops.rmw = ath9k_reg_rmw;
 	sc->sc_ah = ah;
 
 	if (!pdata) {
-- 
1.7.3.2

