Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:53399 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223Ab2JELIg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 07:08:36 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	lindner_marek@yahoo.de
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL on AR9003
Date: Fri, 05 Oct 2012 13:08:32 +0200
Message-ID: <2629427.e28b8DS3gI@bentobox> (sfid-20121005_130841_912829_A82F5497)
In-Reply-To: <CAJ-Vmo=bu=j+=z_TAeE3--Sn5oAEbkEG-HDqK=6okR8xmmWpSQ@mail.gmail.com>
References: <1348756862-8788-1-git-send-email-sven@narfation.org> <506B0628.6070201@openwrt.org> <CAJ-Vmo=bu=j+=z_TAeE3--Sn5oAEbkEG-HDqK=6okR8xmmWpSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2256880.mWW5LoDuVR"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart2256880.mWW5LoDuVR
Content-Type: multipart/mixed; boundary="nextPart2545376.cPeHh88Lpo"
Content-Transfer-Encoding: 7Bit


--nextPart2545376.cPeHh88Lpo
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Wednesday 03 October 2012 07:51:28 Adrian Chadd wrote:
> On 2 October 2012 08:20, Felix Fietkau <nbd@openwrt.org> wrote:
> >> This sync cause 0x20 isn't handled anywhere and may be the cause of the
> >> hang/crash. At least this is the symptom which can be fixed without
> >> crashing the system.
> > 
> > I checked the AR933x datasheet, and it says that cause 0x20 is tx
> > descriptor corruption.
> 
> Ah hey, for Hornet they redefined those bits:
> 
> 5: MAC_TXC_CORRUPTION_FLAG_SYNC (TX descriptor integrity flag)
> 6: INVALID_ADDRESS_ACCESS (invalid register access)
> 
> Good catch. That's definitely something in the right direction.

Ok, I've just created a dirty hack to trace some of the register reads/writes. 

I used following test setup: Two Hornets, one is the "internet gateway" (just 
attached using ethernet to a test server) and is running one AP vif with 
standard OpenWRT settings. The other Hornet is placed next to it (only some 
centimeter far away) and is connected to the AP using WiFi.

The client device is just trying to download a large file using HTTP. The 
serial consoles on both devices will now print the "same" log. I already 
searched for the interesting section. It is started in ath_ani_calibrate and 
contains ~42 register access operations.

My best guess is the REG_RMW_FIELD for ATH9K_ANI_MRC_CCK in 
ar9003_hw_ani_control (just checked sync_cause before and after the access).

So, now I need some input again from the guis with the spec. :)

Kind regards,
	Sven
--nextPart2545376.cPeHh88Lpo
Content-Disposition: attachment; filename="999-debug_reg_write.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="999-debug_reg_write.patch"

--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -283,4 +283,8 @@ void _ath_dbg(struct ath_common *common,
 /** Returns string describing opmode, or NULL if unknown mode. */
 const char *ath_opmode_to_string(enum nl80211_iftype opmode);
 
+void debug_reg_access_add(const char *file, size_t line, const char *function,
+			  const char *op, void *ah, u32 reg, u32 val);
+void debug_reg_access_print(void);
+
 #endif /* ATH_H */
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -182,6 +182,7 @@ static bool ar9003_hw_get_isr(struct ath
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 sync_cause = 0, async_cause, async_mask = AR_INTR_MAC_IRQ;
+	bool fatal_int;
 
 	if (ath9k_hw_mci_is_enabled(ah))
 		async_mask |= AR_INTR_ASYNC_MASK_MCI;
@@ -308,6 +309,21 @@ static bool ar9003_hw_get_isr(struct ath
 
 	if (sync_cause) {
 		ath9k_debug_sync_cause(common, sync_cause);
+		fatal_int = (sync_cause & (BIT(5) | BIT(6))) ? true : false;
+
+		if (fatal_int) {
+			if (sync_cause & BIT(5)) {
+				printk(
+					"received MAC_TXC_CORRUPTION_FLAG_SYNC\n");
+				debug_reg_access_print();
+				*masked |= ATH9K_INT_FATAL;
+			}
+			if (sync_cause & BIT(6)) {
+				printk(
+					"received INVALID_ADDRESS_ACCESS\n");
+				debug_reg_access_print();
+			}
+		}
 
 		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
 			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -22,9 +22,24 @@
 #include "ath9k.h"
 
 #define REG_WRITE_D(_ah, _reg, _val) \
-	ath9k_hw_common(_ah)->ops->write((_ah), (_val), (_reg))
+	do { \
+		typeof(_ah) _t_ah = (_ah); \
+		typeof(_reg) _t_reg = (_reg); \
+		typeof(_val) _t_val = (_val); \
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__, \
+				     "W", _t_ah, _t_reg, _t_val); \
+		ath9k_hw_common(_t_ah)->ops->write((_t_ah), (_t_val), \
+						   (_t_reg)); \
+	} while (0)
+
 #define REG_READ_D(_ah, _reg) \
-	ath9k_hw_common(_ah)->ops->read((_ah), (_reg))
+	({ \
+		typeof(_ah) _t_ah = (_ah); \
+		typeof(_reg) _t_reg = (_reg); \
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__, \
+				     "R", _t_ah, _t_reg, 0); \
+		ath9k_hw_common(_t_ah)->ops->read((_t_ah), (_t_reg)); \
+	})
 
 
 static ssize_t ath9k_debugfs_read_buf(struct file *file, char __user *user_buf,
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -70,28 +70,59 @@
 #define ATH9K_NUM_CHANNELS	38
 
 /* Register read/write primitives */
+
 #define REG_WRITE(_ah, _reg, _val) \
-	(_ah)->reg_ops.write((_ah), (_val), (_reg))
+	do { \
+		typeof(_ah) _t_ah = (_ah); \
+		typeof(_reg) _t_reg = (_reg); \
+		typeof(_val) _t_val = (_val); \
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__, \
+				     "W", _t_ah, _t_reg, _t_val); \
+		(_t_ah)->reg_ops.write((_t_ah), (_t_val), (_t_reg)); \
+	} while (0)
 
 #define REG_READ(_ah, _reg) \
-	(_ah)->reg_ops.read((_ah), (_reg))
+	({ \
+		typeof(_ah) _t_ah = (_ah); \
+		typeof(_reg) _t_reg = (_reg); \
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__, \
+				     "R", _t_ah, _t_reg, 0); \
+		(_t_ah)->reg_ops.read((_t_ah), (_t_reg)); \
+	})
 
 #define REG_READ_MULTI(_ah, _addr, _val, _cnt)		\
-	(_ah)->reg_ops.multi_read((_ah), (_addr), (_val), (_cnt))
+	do { \
+		typeof(_ah) _t_ah = (_ah); \
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__, \
+				     "REG_READ_MULTI", _t_ah, 0, 0); \
+		(_t_ah)->reg_ops.multi_read((_t_ah), (_addr), (_val), (_cnt)); \
+	} while (0)
 
 #define REG_RMW(_ah, _reg, _set, _clr) \
-	(_ah)->reg_ops.rmw((_ah), (_reg), (_set), (_clr))
+	({ \
+		typeof(_ah) _t_ah = (_ah); \
+		typeof(_reg) _t_reg = (_reg); \
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__, \
+				     "RMW", _t_ah, _t_reg, 0); \
+		(_t_ah)->reg_ops.rmw((_t_ah), (_reg), (_set), (_clr)); \
+	})
 
 #define ENABLE_REGWRITE_BUFFER(_ah)					\
 	do {								\
-		if ((_ah)->reg_ops.enable_write_buffer)	\
-			(_ah)->reg_ops.enable_write_buffer((_ah)); \
+		typeof(_ah) _t_ah = (_ah); \
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__, \
+				     "ENABLE_REGWRITE_BUFFER", _t_ah, 0, 0); \
+		if ((_t_ah)->reg_ops.enable_write_buffer)      \
+			(_t_ah)->reg_ops.enable_write_buffer((_t_ah)); \
 	} while (0)
 
 #define REGWRITE_BUFFER_FLUSH(_ah)					\
 	do {								\
-		if ((_ah)->reg_ops.write_flush)		\
-			(_ah)->reg_ops.write_flush((_ah));	\
+		typeof(_ah) _t_ah = (_ah); \
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__, \
+				     "REGWRITE_BUFFER_FLUSH", _t_ah, 0, 0); \
+		if ((_t_ah)->reg_ops.write_flush)		\
+			(_t_ah)->reg_ops.write_flush((_t_ah));	\
 	} while (0)
 
 #define PR_EEP(_s, _val)						\
--- a/drivers/net/wireless/ath/hw.c
+++ b/drivers/net/wireless/ath/hw.c
@@ -20,8 +20,99 @@
 #include "ath.h"
 #include "reg.h"
 
-#define REG_READ	(common->ops->read)
-#define REG_WRITE	(common->ops->write)
+#define REG_WRITE(_ah, _val, _reg) \
+	do { \
+		typeof(_ah) _t_ah = (_ah); \
+		typeof(_reg) _t_reg = (_reg); \
+		typeof(_val) _t_val = (_val); \
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__, \
+				     "W", _t_ah, _t_reg, _t_val); \
+		(common->ops->write)((_t_ah), (_t_val), (_t_reg)); \
+	} while (0)
+
+#define REG_READ(_ah, _reg) \
+	({ \
+		typeof(_ah) _t_ah = (_ah); \
+		typeof(_reg) _t_reg = (_reg); \
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__, \
+				     "R", _t_ah, _t_reg, 0); \
+		(common->ops->read)((_t_ah), (_t_reg)); \
+	})
+
+struct debug_reg_access {
+	const char *file;
+	size_t line;
+	const char *function;
+	const char *op;
+	void *ah;
+	u32 reg;
+	u32 val;
+};
+
+static size_t debug_reg_access_pos;
+static struct debug_reg_access debug_reg_access_db[128];
+static spinlock_t debug_reg_access_lock;
+
+static int __init debug_reg_access_init(void)
+{
+	printk("Init debug_reg_access\n");
+	memset(debug_reg_access_db, 0, sizeof(debug_reg_access_db));
+	debug_reg_access_pos = 0;
+	spin_lock_init(&debug_reg_access_lock);
+
+	return 0;
+}
+
+EXPORT_SYMBOL(debug_reg_access_add);
+void debug_reg_access_add(const char *file, size_t line, const char *function,
+			  const char *op, void *ah, u32 reg, u32 val)
+{
+	unsigned long flags;
+	struct debug_reg_access *entry;
+
+	spin_lock_irqsave(&debug_reg_access_lock, flags);
+
+	entry = &debug_reg_access_db[debug_reg_access_pos];
+	entry->file = file;
+	entry->line = line;
+	entry->function = function;
+	entry->op = op;
+	entry->ah = ah;
+	entry->reg = reg;
+	entry->val = val;
+
+	debug_reg_access_pos++;
+	debug_reg_access_pos %= ARRAY_SIZE(debug_reg_access_db);
+
+	spin_unlock_irqrestore(&debug_reg_access_lock, flags);
+}
+
+EXPORT_SYMBOL(debug_reg_access_print);
+void debug_reg_access_print(void)
+{
+	unsigned long flags;
+	size_t i, pos;
+	struct debug_reg_access *entry;
+
+	spin_lock_irqsave(&debug_reg_access_lock, flags);
+	printk("=================== cut here (start) ===================\n");
+	for (i = 0; i < ARRAY_SIZE(debug_reg_access_db); i++) {
+		pos = (i + debug_reg_access_pos);
+		pos %= ARRAY_SIZE(debug_reg_access_db);
+		entry = &debug_reg_access_db[pos];
+
+		if (!entry->file)
+			continue;
+
+		printk("%s:%zu (%s); %s, ah %p, reg %zu, val %zu\n",
+		       entry->file, entry->line, entry->function, entry->op,
+		       entry->ah, entry->reg, entry->val);
+	}
+	printk("==================== cut here (end) ====================\n");
+	spin_unlock_irqrestore(&debug_reg_access_lock, flags);
+}
+
+module_init(debug_reg_access_init);
 
 /**
  * ath_hw_set_bssid_mask - filter out bssids we listen
--- a/drivers/net/wireless/ath/key.c
+++ b/drivers/net/wireless/ath/key.c
@@ -22,16 +22,42 @@
 #include "ath.h"
 #include "reg.h"
 
-#define REG_READ			(common->ops->read)
-#define REG_WRITE(_ah, _reg, _val)	(common->ops->write)(_ah, _val, _reg)
+#define REG_WRITE(_ah, _reg, _val) \
+	do { \
+		typeof(_ah) _t_ah = (_ah); \
+		typeof(_reg) _t_reg = (_reg); \
+		typeof(_val) _t_val = (_val); \
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__, \
+				     "W", _t_ah, _t_reg, _t_val); \
+		(common->ops->write)((_t_ah), (_t_val), (_t_reg)); \
+	} while (0)
+
+#define REG_READ(_ah, _reg) \
+	({ \
+		typeof(_ah) _t_ah = (_ah); \
+		typeof(_reg) _t_reg = (_reg); \
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__, \
+				     "R", _t_ah, _t_reg, 0); \
+		(common->ops->read)((_t_ah), (_reg)); \
+	})
+
 #define ENABLE_REGWRITE_BUFFER(_ah)			\
-	if (common->ops->enable_write_buffer)		\
-		common->ops->enable_write_buffer((_ah));
+	do {\
+		typeof(_ah) _t_ah = (_ah); \
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__, \
+				     "ENABLE_REGWRITE_BUFFER", _t_ah, 0, 0); \
+		if (common->ops->enable_write_buffer)		\
+			common->ops->enable_write_buffer((_t_ah)); \
+	} while (0)
 
 #define REGWRITE_BUFFER_FLUSH(_ah)			\
-	if (common->ops->write_flush)			\
-		common->ops->write_flush((_ah));
-
+	do {\
+		typeof(_ah) _t_ah = (_ah); \
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__, \
+				     "REGWRITE_BUFFER_FLUSH", _t_ah, 0, 0); \
+		if (common->ops->write_flush)			\
+			common->ops->write_flush((_t_ah)); \
+	} while (0)
 
 #define IEEE80211_WEP_NKID      4       /* number of key ids */
 
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -387,10 +387,18 @@ void ath_ani_calibrate(unsigned long dat
 
 	/* Call ANI routine if necessary */
 	if (aniflag) {
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__,
+				     "PRE_IRQLOCK", NULL, 0, 0);
 		spin_lock_irqsave(&common->cc_lock, flags);
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__,
+				     "POST_IRQLOCK", NULL, 0, 0);
 		ath9k_hw_ani_monitor(ah, ah->curchan);
 		ath_update_survey_stats(sc);
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__,
+				     "PRE_IRQUNLOCK", NULL, 0, 0);
 		spin_unlock_irqrestore(&common->cc_lock, flags);
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__,
+				     "POST_IRQUNLOCK", NULL, 0, 0);
 	}
 
 	/* Perform calibration if necessary */
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -866,6 +866,7 @@ static bool ar9003_hw_ani_control(struct
 	struct ath9k_channel *chan = ah->curchan;
 	struct ar5416AniState *aniState = &chan->ani;
 	s32 value, value2;
+	u32 sync_cause = 0;
 
 	switch (cmd & ah->ani_function) {
 	case ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION:{
@@ -1035,10 +1036,19 @@ static bool ar9003_hw_ani_control(struct
 		 * is_on == 0 means MRC CCK is OFF (more noise imm)
 		 */
 		bool is_on = param ? 1 : 0;
+		sync_cause = (ah)->reg_ops.read((ah), (AR_INTR_SYNC_CAUSE)) & AR_INTR_SYNC_DEFAULT;
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__,
+				     "sync_cause 0", NULL, 0, sync_cause);
 		REG_RMW_FIELD(ah, AR_PHY_MRC_CCK_CTRL,
 			      AR_PHY_MRC_CCK_ENABLE, is_on);
+		sync_cause = (ah)->reg_ops.read((ah), (AR_INTR_SYNC_CAUSE)) & AR_INTR_SYNC_DEFAULT;
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__,
+				     "sync_cause 1", NULL, 0, sync_cause);
 		REG_RMW_FIELD(ah, AR_PHY_MRC_CCK_CTRL,
 			      AR_PHY_MRC_CCK_MUX_REG, is_on);
+		sync_cause = (ah)->reg_ops.read((ah), (AR_INTR_SYNC_CAUSE)) & AR_INTR_SYNC_DEFAULT;
+		debug_reg_access_add(__FILE__, __LINE__, __FUNCTION__,
+				     "sync_cause 2", NULL, 0, sync_cause);
 		if (is_on != aniState->mrcCCK) {
 			ath_dbg(common, ANI, "** ch %d: MRC CCK: %s=>%s\n",
 				chan->channel,

--nextPart2545376.cPeHh88Lpo
Content-Disposition: attachment; filename="invalid_register_access.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="UTF-8"; name="invalid_register_access.log"

[  148.380000] received INVALID_ADDRESS_ACCESS
[  148.380000] =================== cut here (start) ===================
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:770 (ath9k_hw_intrpend); R, ah 830f8000, reg 16440, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:190 (ar9003_hw_get_isr); R, ah 830f8000, reg 16440, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:193 (ar9003_hw_get_isr); R, ah 830f8000, reg 28740, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:195 (ar9003_hw_get_isr); R, ah 830f8000, reg 128, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:199 (ar9003_hw_get_isr); R, ah 830f8000, reg 16424, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:235 (ar9003_hw_get_isr); R, ah 830f8000, reg 192, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:791 (ath9k_hw_kill_interrupts); W, ah 830f8000, reg 36, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:792 (ath9k_hw_kill_interrupts); R, ah 830f8000, reg 36, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:794 (ath9k_hw_kill_interrupts); W, ah 830f8000, reg 16444, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:795 (ath9k_hw_kill_interrupts); R, ah 830f8000, reg 16444, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:797 (ath9k_hw_kill_interrupts); W, ah 830f8000, reg 16428, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:798 (ath9k_hw_kill_interrupts); R, ah 830f8000, reg 16428, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:54 (ath9k_hw_puttxbuf); W, ah 830f8000, reg 2056, val 62798208
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:838 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 36, val 1
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:840 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 16444, val 2
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:841 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 16432, val 2
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:843 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 16428, val 147296
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:844 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 16436, val 147296
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:770 (ath9k_hw_intrpend); R, ah 830f8000, reg 16440, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:190 (ar9003_hw_get_isr); R, ah 830f8000, reg 16440, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:193 (ar9003_hw_get_isr); R, ah 830f8000, reg 28740, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:195 (ar9003_hw_get_isr); R, ah 830f8000, reg 128, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:199 (ar9003_hw_get_isr); R, ah 830f8000, reg 16424, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:235 (ar9003_hw_get_isr); R, ah 830f8000, reg 192, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:69 (ath9k_hw_numtxpending); R, ah 830f8000, reg 2596, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:72 (ath9k_hw_numtxpending); R, ah 830f8000, reg 2112, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/hw.c:2900 (ath9k_hw_gettsf64); R, ah 830f8000, reg 32848, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/hw.c:2902 (ath9k_hw_gettsf64); R, ah 830f8000, reg 32844, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/hw.c:2903 (ath9k_hw_gettsf64); R, ah 830f8000, reg 32848, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:770 (ath9k_hw_intrpend); R, ah 830f8000, reg 16440, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:190 (ar9003_hw_get_isr); R, ah 830f8000, reg 16440, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:193 (ar9003_hw_get_isr); R, ah 830f8000, reg 28740, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:195 (ar9003_hw_get_isr); R, ah 830f8000, reg 128, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:199 (ar9003_hw_get_isr); R, ah 830f8000, reg 16424, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:235 (ar9003_hw_get_isr); R, ah 830f8000, reg 192, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:791 (ath9k_hw_kill_interrupts); W, ah 830f8000, reg 36, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:792 (ath9k_hw_kill_interrupts); R, ah 830f8000, reg 36, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:794 (ath9k_hw_kill_interrupts); W, ah 830f8000, reg 16444, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:795 (ath9k_hw_kill_interrupts); R, ah 830f8000, reg 16444, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:797 (ath9k_hw_kill_interrupts); W, ah 830f8000, reg 16428, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:798 (ath9k_hw_kill_interrupts); R, ah 830f8000, reg 16428, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:54 (ath9k_hw_puttxbuf); W, ah 830f8000, reg 2056, val 62797696
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:838 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 36, val 1
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:840 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 16444, val 2
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:841 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 16432, val 2
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:843 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 16428, val 147296
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:844 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 16436, val 147296
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:770 (ath9k_hw_intrpend); R, ah 830f8000, reg 16440, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:190 (ar9003_hw_get_isr); R, ah 830f8000, reg 16440, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:193 (ar9003_hw_get_isr); R, ah 830f8000, reg 28740, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:195 (ar9003_hw_get_isr); R, ah 830f8000, reg 128, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:199 (ar9003_hw_get_isr); R, ah 830f8000, reg 16424, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:235 (ar9003_hw_get_isr); R, ah 830f8000, reg 192, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:69 (ath9k_hw_numtxpending); R, ah 830f8000, reg 2596, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:72 (ath9k_hw_numtxpending); R, ah 830f8000, reg 2112, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/hw.c:2900 (ath9k_hw_gettsf64); R, ah 830f8000, reg 32848, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/hw.c:2902 (ath9k_hw_gettsf64); R, ah 830f8000, reg 32844, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/hw.c:2903 (ath9k_hw_gettsf64); R, ah 830f8000, reg 32848, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:770 (ath9k_hw_intrpend); R, ah 830f8000, reg 16440, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:190 (ar9003_hw_get_isr); R, ah 830f8000, reg 16440, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:193 (ar9003_hw_get_isr); R, ah 830f8000, reg 28740, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:195 (ar9003_hw_get_isr); R, ah 830f8000, reg 128, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:199 (ar9003_hw_get_isr); R, ah 830f8000, reg 16424, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:235 (ar9003_hw_get_isr); R, ah 830f8000, reg 192, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:791 (ath9k_hw_kill_interrupts); W, ah 830f8000, reg 36, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:792 (ath9k_hw_kill_interrupts); R, ah 830f8000, reg 36, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:794 (ath9k_hw_kill_interrupts); W, ah 830f8000, reg 16444, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:795 (ath9k_hw_kill_interrupts); R, ah 830f8000, reg 16444, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:797 (ath9k_hw_kill_interrupts); W, ah 830f8000, reg 16428, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:798 (ath9k_hw_kill_interrupts); R, ah 830f8000, reg 16428, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:54 (ath9k_hw_puttxbuf); W, ah 830f8000, reg 2056, val 62797568
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:838 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 36, val 1
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:840 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 16444, val 2
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:841 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 16432, val 2
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:843 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 16428, val 147296
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:844 (ath9k_hw_enable_interrupts); W, ah 830f8000, reg 16436, val 147296




[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/link.c:390 (ath_ani_calibrate); PRE_IRQLOCK, ah   (null), reg 0, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/link.c:393 (ath_ani_calibrate); POST_IRQLOCK, ah   (null), reg 0, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:233 (ath_hw_cycle_counters_update); W, ah 830f8000, reg 64, val 2
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:236 (ath_hw_cycle_counters_update); R, ah 830f8000, reg 33016, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:237 (ath_hw_cycle_counters_update); R, ah 830f8000, reg 33012, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:238 (ath_hw_cycle_counters_update); R, ah 830f8000, reg 33008, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:239 (ath_hw_cycle_counters_update); R, ah 830f8000, reg 33004, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:242 (ath_hw_cycle_counters_update); W, ah 830f8000, reg 33016, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:243 (ath_hw_cycle_counters_update); W, ah 830f8000, reg 33008, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:244 (ath_hw_cycle_counters_update); W, ah 830f8000, reg 33012, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:245 (ath_hw_cycle_counters_update); W, ah 830f8000, reg 33004, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:248 (ath_hw_cycle_counters_update); W, ah 830f8000, reg 64, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:110 (ath9k_hw_update_mibstats); R, ah 830f8000, reg 32912, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:111 (ath9k_hw_update_mibstats); R, ah 830f8000, reg 32908, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:112 (ath9k_hw_update_mibstats); R, ah 830f8000, reg 32916, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:113 (ath9k_hw_update_mibstats); R, ah 830f8000, reg 32904, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:114 (ath9k_hw_update_mibstats); R, ah 830f8000, reg 32920, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:399 (ath9k_hw_ani_read_counters); R, ah 830f8000, reg 33068, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:400 (ath9k_hw_ani_read_counters); R, ah 830f8000, reg 33076, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_phy.c:927 (ar9003_hw_ani_control); RMW, ah 830f8000, reg 40464, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_phy.c:942 (ar9003_hw_ani_control); RMW, ah 830f8000, reg 38944, val 0

[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_phy.c:1040 (ar9003_hw_ani_control); sync_cause 0, ah   (null), reg 0, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_phy.c:1043 (ar9003_hw_ani_control); RMW, ah 830f8000, reg 40912, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_phy.c:1045 (ar9003_hw_ani_control); sync_cause 1, ah   (null), reg 0, val 64
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_phy.c:1048 (ar9003_hw_ani_control); RMW, ah 830f8000, reg 40912, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_phy.c:1050 (ar9003_hw_ani_control); sync_cause 2, ah   (null), reg 0, val 64
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:127 (ath9k_ani_restart); ENABLE_REGWRITE_BUFFER, ah 830f8000, reg 0, val 0

[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:129 (ath9k_ani_restart); W, ah 830f8000, reg 33068, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:130 (ath9k_ani_restart); W, ah 830f8000, reg 33076, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:131 (ath9k_ani_restart); W, ah 830f8000, reg 33072, val 131072
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:132 (ath9k_ani_restart); W, ah 830f8000, reg 33080, val 33554432
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:134 (ath9k_ani_restart); REGWRITE_BUFFER_FLUSH, ah 830f8000, reg 0, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:110 (ath9k_hw_update_mibstats); R, ah 830f8000, reg 32912, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:111 (ath9k_hw_update_mibstats); R, ah 830f8000, reg 32908, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:112 (ath9k_hw_update_mibstats); R, ah 830f8000, reg 32916, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:113 (ath9k_hw_update_mibstats); R, ah 830f8000, reg 32904, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ani.c:114 (ath9k_hw_update_mibstats); R, ah 830f8000, reg 32920, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:233 (ath_hw_cycle_counters_update); W, ah 830f8000, reg 64, val 2
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:236 (ath_hw_cycle_counters_update); R, ah 830f8000, reg 33016, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:237 (ath_hw_cycle_counters_update); R, ah 830f8000, reg 33012, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:238 (ath_hw_cycle_counters_update); R, ah 830f8000, reg 33008, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:239 (ath_hw_cycle_counters_update); R, ah 830f8000, reg 33004, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:242 (ath_hw_cycle_counters_update); W, ah 830f8000, reg 33016, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:243 (ath_hw_cycle_counters_update); W, ah 830f8000, reg 33008, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:244 (ath_hw_cycle_counters_update); W, ah 830f8000, reg 33012, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:245 (ath_hw_cycle_counters_update); W, ah 830f8000, reg 33004, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/hw.c:248 (ath_hw_cycle_counters_update); W, ah 830f8000, reg 64, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/link.c:397 (ath_ani_calibrate); PRE_IRQUNLOCK, ah   (null), reg 0, val 0



[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:770 (ath9k_hw_intrpend); R, ah 830f8000, reg 16440, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/mac.c:777 (ath9k_hw_intrpend); R, ah 830f8000, reg 16424, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:190 (ar9003_hw_get_isr); R, ah 830f8000, reg 16440, val 0
[  148.380000] /home/sven/projekte/siwu/openwrt_sta/build_dir/linux-ar71xx_generic/compat-wireless-2012-09-07/drivers/net/wireless/ath/ath9k/ar9003_mac.c:199 (ar9003_hw_get_isr); R, ah 830f8000, reg 16424, val 0
[  148.380000] ==================== cut here (end) ====================
--nextPart2545376.cPeHh88Lpo--

--nextPart2256880.mWW5LoDuVR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQbr+wAAoJEF2HCgfBJntGmAAP/2e+wCMbfGigvJp3Xxd0p5Wo
HNwPmwauuWeYY7ITsVl1QwbXzZy0dgsoCLCkPU3z3ZMoEtXJfNCtbLe93LSAF4Ih
uThRzcusxUrLhKmGFPtC2gYtiQTZfyovpM8NzDhV+o/aAtCSD31ioK1sJIrTT4u6
qPjUBOprDhkD2g7KlwAWJL+8f0UqFWJLtod7tNPRPInckjUnzCvCnqf0pw16BOWZ
/09vKMjbmQzSrrzEkisMIitB0S7m57/vlutc2GRHZIglRHrjfNaorLvfQ/o6Co0e
iG+i/7bme4FUe8HtUJPU56kL9A8mBV2QnfzRs31Z2A970dyCFHATJstLaFRWwJNV
reHiIi9jgMKa9E9WlQLoYztc7Qu1IhdgrNM9jpsYWg+CBJ2FQBDLzCrZ1lnLqK3V
F4EMIEyVVlpEEYJ8hb1oe9Tm9pEZTLQeEzAzPZhVOqrQ34QaOmq6Bb/ieOZZTVVh
De+irPcEZpc/HiuV9+3VsdDtTQTTph+cwNmr+Gh3Nfr6KzgbzoWn0FIFs5Np/9gh
9hAAZ91wzLBL2rTwDadcnH3i5iETgbF99z3kjKHNygww2zB2xjjLMY3A+AgnF7pc
Y+x4Lky9ghbJdyEtVgS7suH3Rn58Ndsxv8o2m6Gt4ljJPhOvrqQaU11O9CltqbAB
R9YC+31fckiQNaauy3vI
=r3C6
-----END PGP SIGNATURE-----

--nextPart2256880.mWW5LoDuVR--

