Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:46999 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932580Ab0JEJzP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 05:55:15 -0400
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-031972509
	for <linux-wireless@vger.kernel.org>; Tue,  5 Oct 2010 18:55:12 +0900 (JST)
Subject: [PATCH 1/5] ath: Add common function for reading cycle counters
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, adrian@freebsd.org,
	vasanth@atheros.com
Date: Tue, 05 Oct 2010 18:55:10 +0900
Message-ID: <20101005095510.3083.46174.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement a common function to access the cycle counters (profile counters) for
use in ath5k and ath9k. This is necessary because we want to access the cycle
counters from different places: ANI uses it in it's algorithm to calculate the
"listen time" and at the same time we want to show it for debugging purposes
and add it to the "survey" command later.

This is a very simple implementation, which resets the HW counters to zero
after every read (to avoid overflows) and currently takes care of two different
counters, one for ANI and one for survey. If additional counters should be
required they would have to be added by hardcoding them in the function. This
is not the most flexible way to deal with this, but it's easy and simple and i
believe should be sufficient.

Users have to hold the lock while accessing the counters.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath.h |   23 +++++++++++++++++++++++
 drivers/net/wireless/ath/hw.c  |   40 ++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/reg.h |   11 +++++++++++
 3 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index dd236c3..699c904 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -97,6 +97,13 @@ enum ath_cipher {
 	ATH_CIPHER_MIC = 127
 };
 
+struct ath_cycle_counters {
+	u32 cycles;
+	u32 rx_busy; /* register is called "rx clear" but it's the inverse */
+	u32 rx_frame;
+	u32 tx_frame;
+};
+
 /**
  * struct ath_ops - Register read/write operations
  *
@@ -148,6 +155,10 @@ struct ath_common {
 	DECLARE_BITMAP(tkip_keymap, ATH_KEYMAX);
 	enum ath_crypt_caps crypt_caps;
 
+	struct ath_cycle_counters cc_ani;
+	struct ath_cycle_counters cc_survey;
+	spinlock_t cc_lock;
+
 	struct ath_regulatory regulatory;
 	const struct ath_ops *ops;
 	const struct ath_bus_ops *bus_ops;
@@ -165,4 +176,16 @@ int ath_key_config(struct ath_common *common,
 			  struct ieee80211_key_conf *key);
 bool ath_hw_keyreset(struct ath_common *common, u16 entry);
 
+void ath_hw_cycle_counters_update(struct ath_common *common);
+
+static inline void ath_hw_cycle_counters_lock(struct ath_common *common)
+{
+	spin_lock_bh(&common->cc_lock);
+}
+
+static inline void ath_hw_cycle_counters_unlock(struct ath_common *common)
+{
+	spin_unlock_bh(&common->cc_lock);
+}
+
 #endif /* ATH_H */
diff --git a/drivers/net/wireless/ath/hw.c b/drivers/net/wireless/ath/hw.c
index a8f81ea..f26730f 100644
--- a/drivers/net/wireless/ath/hw.c
+++ b/drivers/net/wireless/ath/hw.c
@@ -124,3 +124,43 @@ void ath_hw_setbssidmask(struct ath_common *common)
 	REG_WRITE(ah, get_unaligned_le16(common->bssidmask + 4), AR_BSSMSKU);
 }
 EXPORT_SYMBOL(ath_hw_setbssidmask);
+
+/**
+ * ath_hw_cycle_counters_update - common function to update cycle counters
+ *
+ * @common: the ath_common struct for the device.
+ *
+ * This function is used to update all cycle counters in one place.
+ * It has to be called while holding common->cc_lock!
+ */
+void ath_hw_cycle_counters_update(struct ath_common *common)
+{
+	u32 cycles, busy, rx, tx;
+
+	/* freeze */
+	REG_WRITE(common, AR_MIBC_FMC, AR_MIBC);
+	/* read */
+	cycles = REG_READ(common, AR_CCCNT);
+	busy = REG_READ(common, AR_RCCNT);
+	rx = REG_READ(common, AR_RFCNT);
+	tx = REG_READ(common, AR_TFCNT);
+	/* clear */
+	REG_WRITE(common, 0, AR_CCCNT);
+	REG_WRITE(common, 0, AR_RFCNT);
+	REG_WRITE(common, 0, AR_RCCNT);
+	REG_WRITE(common, 0, AR_TFCNT);
+	/* unfreeze */
+	REG_WRITE(common, 0, AR_MIBC);
+
+	/* update all cycle counters here */
+	common->cc_ani.cycles += cycles;
+	common->cc_ani.rx_busy += busy;
+	common->cc_ani.rx_frame += rx;
+	common->cc_ani.tx_frame += tx;
+
+	common->cc_survey.cycles += cycles;
+	common->cc_survey.rx_busy += busy;
+	common->cc_survey.rx_frame += rx;
+	common->cc_survey.tx_frame += tx;
+}
+EXPORT_SYMBOL(ath_hw_cycle_counters_update);
diff --git a/drivers/net/wireless/ath/reg.h b/drivers/net/wireless/ath/reg.h
index e798ef4..298e53f 100644
--- a/drivers/net/wireless/ath/reg.h
+++ b/drivers/net/wireless/ath/reg.h
@@ -17,6 +17,12 @@
 #ifndef ATH_REGISTERS_H
 #define ATH_REGISTERS_H
 
+#define AR_MIBC			0x0040
+#define AR_MIBC_COW		0x00000001
+#define AR_MIBC_FMC		0x00000002
+#define AR_MIBC_CMC		0x00000004
+#define AR_MIBC_MCS		0x00000008
+
 /*
  * BSSID mask registers. See ath_hw_set_bssid_mask()
  * for detailed documentation about these registers.
@@ -24,6 +30,11 @@
 #define AR_BSSMSKL		0x80e0
 #define AR_BSSMSKU		0x80e4
 
+#define AR_TFCNT		0x80ec
+#define AR_RFCNT		0x80f0
+#define AR_RCCNT		0x80f4
+#define AR_CCCNT		0x80f8
+
 #define AR_KEYTABLE_0           0x8800
 #define AR_KEYTABLE(_n)         (AR_KEYTABLE_0 + ((_n)*32))
 #define AR_KEY_CACHE_SIZE       128

