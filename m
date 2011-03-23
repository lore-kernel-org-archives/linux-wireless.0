Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44608 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932839Ab1CWT5k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 15:57:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 01/10] ath9k_hw: embed the ath_ops callbacks in the ath_hw struct
Date: Wed, 23 Mar 2011 20:57:24 +0100
Message-Id: <1300910253-28189-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With this change, loading the address to a register read/write function
costs only one pointer dereference instead of two. On MIPS this reduces
ath9k_hw binary size from 326k down to 321k.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   15 ++++++---------
 drivers/net/wireless/ath/ath9k/hw.h           |   16 +++++++++-------
 drivers/net/wireless/ath/ath9k/init.c         |    9 +++------
 3 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index fc67c93..4e26946 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -430,14 +430,6 @@ static void ath9k_regwrite_flush(void *hw_priv)
 	mutex_unlock(&priv->wmi->multi_write_mutex);
 }
 
-static const struct ath_ops ath9k_common_ops = {
-	.read = ath9k_regread,
-	.multi_read = ath9k_multi_regread,
-	.write = ath9k_regwrite,
-	.enable_write_buffer = ath9k_enable_regwrite_buffer,
-	.write_flush = ath9k_regwrite_flush,
-};
-
 static void ath_usb_read_cachesize(struct ath_common *common, int *csz)
 {
 	*csz = L1_CACHE_BYTES >> 2;
@@ -658,10 +650,15 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	ah->hw_version.subsysid = 0; /* FIXME */
 	ah->hw_version.usbdev = drv_info;
 	ah->ah_flags |= AH_USE_EEPROM;
+	ah->reg_ops.read = ath9k_regread;
+	ah->reg_ops.multi_read = ath9k_multi_regread;
+	ah->reg_ops.write = ath9k_regwrite;
+	ah->reg_ops.enable_write_buffer = ath9k_enable_regwrite_buffer;
+	ah->reg_ops.write_flush = ath9k_regwrite_flush;
 	priv->ah = ah;
 
 	common = ath9k_hw_common(ah);
-	common->ops = &ath9k_common_ops;
+	common->ops = &ah->reg_ops;
 	common->bus_ops = &ath9k_usb_bus_ops;
 	common->ah = ah;
 	common->hw = priv->hw;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c819973..ef387a2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -65,24 +65,24 @@
 
 /* Register read/write primitives */
 #define REG_WRITE(_ah, _reg, _val) \
-	ath9k_hw_common(_ah)->ops->write((_ah), (_val), (_reg))
+	(_ah)->reg_ops.write((_ah), (_val), (_reg))
 
 #define REG_READ(_ah, _reg) \
-	ath9k_hw_common(_ah)->ops->read((_ah), (_reg))
+	(_ah)->reg_ops.read((_ah), (_reg))
 
 #define REG_READ_MULTI(_ah, _addr, _val, _cnt)		\
-	ath9k_hw_common(_ah)->ops->multi_read((_ah), (_addr), (_val), (_cnt))
+	(_ah)->reg_ops.multi_read((_ah), (_addr), (_val), (_cnt))
 
 #define ENABLE_REGWRITE_BUFFER(_ah)					\
 	do {								\
-		if (ath9k_hw_common(_ah)->ops->enable_write_buffer)	\
-			ath9k_hw_common(_ah)->ops->enable_write_buffer((_ah)); \
+		if ((_ah)->reg_ops.enable_write_buffer)	\
+			(_ah)->reg_ops.enable_write_buffer((_ah)); \
 	} while (0)
 
 #define REGWRITE_BUFFER_FLUSH(_ah)					\
 	do {								\
-		if (ath9k_hw_common(_ah)->ops->write_flush)		\
-			ath9k_hw_common(_ah)->ops->write_flush((_ah));	\
+		if ((_ah)->reg_ops.write_flush)		\
+			(_ah)->reg_ops.write_flush((_ah));	\
 	} while (0)
 
 #define SM(_v, _f)  (((_v) << _f##_S) & _f)
@@ -657,6 +657,8 @@ struct ath_nf_limits {
 #define AH_UNPLUGGED    0x2 /* The card has been physically removed. */
 
 struct ath_hw {
+	struct ath_ops reg_ops;
+
 	struct ieee80211_hw *hw;
 	struct ath_common common;
 	struct ath9k_hw_version hw_version;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index cdb0f1c..b45fd3f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -196,11 +196,6 @@ static unsigned int ath9k_ioread32(void *hw_priv, u32 reg_offset)
 	return val;
 }
 
-static const struct ath_ops ath9k_common_ops = {
-	.read = ath9k_ioread32,
-	.write = ath9k_iowrite32,
-};
-
 /**************************/
 /*     Initialization     */
 /**************************/
@@ -551,6 +546,8 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	ah->hw = sc->hw;
 	ah->hw_version.devid = devid;
 	ah->hw_version.subsysid = subsysid;
+	ah->reg_ops.read = ath9k_ioread32;
+	ah->reg_ops.write = ath9k_iowrite32;
 	sc->sc_ah = ah;
 
 	if (!pdata) {
@@ -563,7 +560,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	}
 
 	common = ath9k_hw_common(ah);
-	common->ops = &ath9k_common_ops;
+	common->ops = &ah->reg_ops;
 	common->bus_ops = bus_ops;
 	common->ah = ah;
 	common->hw = sc->hw;
-- 
1.7.3.2

