Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43113 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZIXDHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 23:07:01 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 2/4] ath9k: move hw code to its own module
Date: Wed, 23 Sep 2009 23:07:00 -0400
Message-Id: <1253761622-9530-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1253761622-9530-1-git-send-email-lrodriguez@atheros.com>
References: <1253761622-9530-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hw code for Atheros 802.11n hardware is commmon between
different chipsets. This moves this code into a separate
module, the next expected user of this code will be
the ath9k_htc module.

The ath9k/ dir is now selected by ATH9K_HW, an option which
gets selected by either ath9k or ath9k_htc, but remains
invisible for user menuconfig configuration. If either
ath9k or ath9k_htc will be compiled into the kernel
ath9k_hw will also be compiled in.

Cc: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/Makefile       |    2 +-
 drivers/net/wireless/ath/ath9k/Kconfig  |    4 ++
 drivers/net/wireless/ath/ath9k/Makefile |   27 +++++++-------
 drivers/net/wireless/ath/ath9k/ani.c    |    2 +
 drivers/net/wireless/ath/ath9k/btcoex.c |    6 +++
 drivers/net/wireless/ath/ath9k/calib.c  |    3 ++
 drivers/net/wireless/ath/ath9k/hw.c     |   61 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/mac.c    |   30 +++++++++++++++
 8 files changed, 121 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
index 5c8e6b2..8113a50 100644
--- a/drivers/net/wireless/ath/Makefile
+++ b/drivers/net/wireless/ath/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_ATH5K)		+= ath5k/
-obj-$(CONFIG_ATH9K)		+= ath9k/
+obj-$(CONFIG_ATH9K_HW)		+= ath9k/
 obj-$(CONFIG_AR9170_USB)        += ar9170/
 
 obj-$(CONFIG_ATH_COMMON)	+= ath.o
diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index de4aeea..99ce066 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -1,6 +1,10 @@
+config ATH9K_HW
+	tristate
+
 config ATH9K
 	tristate "Atheros 802.11n wireless cards support"
 	depends on PCI && MAC80211 && WLAN_80211
+	select ATH9K_HW
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index f3221af..8caf2a8 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -1,16 +1,4 @@
-ATH9K_HW +=	hw.o \
-		eeprom.o \
-		eeprom_def.o \
-		eeprom_4k.o \
-		eeprom_9287.o \
-		calib.o \
-		ani.o \
-		phy.o \
-		btcoex.o \
-		mac.o \
-
-ath9k-y +=	$(ATH9K_HW) \
-		beacon.o \
+ath9k-y +=	beacon.o \
 		main.o \
 		recv.o \
 		xmit.o \
@@ -22,3 +10,16 @@ ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
 ath9k-$(CONFIG_ATH9K_DEBUG) += debug.o
 
 obj-$(CONFIG_ATH9K) += ath9k.o
+
+ath9k_hw-y:=	hw.o \
+		eeprom.o \
+		eeprom_def.o \
+		eeprom_4k.o \
+		eeprom_9287.o \
+		calib.o \
+		ani.o \
+		phy.o \
+		btcoex.o \
+		mac.o \
+
+obj-$(CONFIG_ATH9K_HW) += ath9k_hw.o
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index ecb23f3..2a0cd64 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -629,6 +629,7 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 		}
 	}
 }
+EXPORT_SYMBOL(ath9k_hw_ani_monitor);
 
 void ath9k_enable_mib_counters(struct ath_hw *ah)
 {
@@ -756,6 +757,7 @@ void ath9k_hw_procmibevent(struct ath_hw *ah)
 		ath9k_ani_restart(ah);
 	}
 }
+EXPORT_SYMBOL(ath9k_hw_procmibevent);
 
 void ath9k_hw_ani_setup(struct ath_hw *ah)
 {
diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 0c54489..fb4ac15 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -95,6 +95,7 @@ void ath9k_hw_init_btcoex_hw(struct ath_hw *ah, int qnum)
 	for (i = 0; i < 32; i++)
 		ah->hw_gen_timers.gen_timer_index[(debruijn32 << i) >> 27] = i;
 }
+EXPORT_SYMBOL(ath9k_hw_init_btcoex_hw);
 
 void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
 {
@@ -116,6 +117,7 @@ void ath9k_hw_btcoex_init_2wire(struct ath_hw *ah)
 	/* Configure the desired gpio port for input */
 	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btactive_gpio);
 }
+EXPORT_SYMBOL(ath9k_hw_btcoex_init_2wire);
 
 void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 {
@@ -141,6 +143,7 @@ void ath9k_hw_btcoex_init_3wire(struct ath_hw *ah)
 	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btactive_gpio);
 	ath9k_hw_cfg_gpio_input(ah, btcoex_hw->btpriority_gpio);
 }
+EXPORT_SYMBOL(ath9k_hw_btcoex_init_3wire);
 
 static void ath9k_hw_btcoex_enable_2wire(struct ath_hw *ah)
 {
@@ -160,6 +163,7 @@ void ath9k_hw_btcoex_set_weight(struct ath_hw *ah,
 	btcoex_hw->bt_coex_weights = SM(bt_weight, AR_BTCOEX_BT_WGHT) |
 				     SM(wlan_weight, AR_BTCOEX_WL_WGHT);
 }
+EXPORT_SYMBOL(ath9k_hw_btcoex_set_weight);
 
 static void ath9k_hw_btcoex_enable_3wire(struct ath_hw *ah)
 {
@@ -201,6 +205,7 @@ void ath9k_hw_btcoex_enable(struct ath_hw *ah)
 
 	ah->btcoex_hw.enabled = true;
 }
+EXPORT_SYMBOL(ath9k_hw_btcoex_enable);
 
 void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 {
@@ -219,3 +224,4 @@ void ath9k_hw_btcoex_disable(struct ath_hw *ah)
 
 	ah->btcoex_hw.enabled = false;
 }
+EXPORT_SYMBOL(ath9k_hw_btcoex_disable);
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index d347ea7..f46bd05 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -594,6 +594,7 @@ bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 
 	return false;
 }
+EXPORT_SYMBOL(ath9k_hw_reset_calvalid);
 
 void ath9k_hw_start_nfcal(struct ath_hw *ah)
 {
@@ -746,6 +747,7 @@ s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	return nf;
 }
+EXPORT_SYMBOL(ath9k_hw_getchan_noise);
 
 static void ath9k_olc_temp_compensation_9287(struct ath_hw *ah)
 {
@@ -1066,6 +1068,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	return iscaldone;
 }
+EXPORT_SYMBOL(ath9k_hw_calibrate);
 
 static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7a4de3d..7d167a1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -33,6 +33,23 @@ static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
 static void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
 static void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
 
+MODULE_AUTHOR("Atheros Communications");
+MODULE_DESCRIPTION("Support for Atheros 802.11n wireless LAN cards.");
+MODULE_SUPPORTED_DEVICE("Atheros 802.11n WLAN cards");
+MODULE_LICENSE("Dual BSD/GPL");
+
+static int __init ath9k_init(void)
+{
+	return 0;
+}
+module_init(ath9k_init);
+
+static void __exit ath9k_exit(void)
+{
+	return;
+}
+module_exit(ath9k_exit);
+
 /********************/
 /* Helper Functions */
 /********************/
@@ -99,6 +116,7 @@ bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout)
 
 	return false;
 }
+EXPORT_SYMBOL(ath9k_hw_wait);
 
 u32 ath9k_hw_reverse_bits(u32 val, u32 n)
 {
@@ -186,6 +204,7 @@ u16 ath9k_hw_computetxtime(struct ath_hw *ah,
 
 	return txTime;
 }
+EXPORT_SYMBOL(ath9k_hw_computetxtime);
 
 void ath9k_hw_get_channel_centers(struct ath_hw *ah,
 				  struct ath9k_channel *chan,
@@ -402,6 +421,7 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	if (num_possible_cpus() > 1)
 		ah->config.serialize_regmode = SER_REG_MODE_AUTO;
 }
+EXPORT_SYMBOL(ath9k_hw_init);
 
 static void ath9k_hw_init_defaults(struct ath_hw *ah)
 {
@@ -1223,6 +1243,7 @@ void ath9k_hw_detach(struct ath_hw *ah)
 	kfree(ah);
 	ah = NULL;
 }
+EXPORT_SYMBOL(ath9k_hw_detach);
 
 /*******/
 /* INI */
@@ -2561,6 +2582,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	return 0;
 }
+EXPORT_SYMBOL(ath9k_hw_reset);
 
 /************************/
 /* Key Cache Management */
@@ -2599,6 +2621,7 @@ bool ath9k_hw_keyreset(struct ath_hw *ah, u16 entry)
 
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_keyreset);
 
 bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
 {
@@ -2627,6 +2650,7 @@ bool ath9k_hw_keysetmac(struct ath_hw *ah, u16 entry, const u8 *mac)
 
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_keysetmac);
 
 bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 				 const struct ath9k_keyval *k,
@@ -2825,6 +2849,7 @@ bool ath9k_hw_set_keycache_entry(struct ath_hw *ah, u16 entry,
 
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_set_keycache_entry);
 
 bool ath9k_hw_keyisvalid(struct ath_hw *ah, u16 entry)
 {
@@ -2835,6 +2860,7 @@ bool ath9k_hw_keyisvalid(struct ath_hw *ah, u16 entry)
 	}
 	return false;
 }
+EXPORT_SYMBOL(ath9k_hw_keyisvalid);
 
 /******************************/
 /* Power Management (Chipset) */
@@ -2951,6 +2977,7 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 
 	return status;
 }
+EXPORT_SYMBOL(ath9k_hw_setpower);
 
 /*
  * Helper for ASPM support.
@@ -3083,6 +3110,7 @@ void ath9k_hw_configpcipowersave(struct ath_hw *ah, int restore, int power_off)
 		}
 	}
 }
+EXPORT_SYMBOL(ath9k_hw_configpcipowersave);
 
 /**********************/
 /* Interrupt Handling */
@@ -3106,6 +3134,7 @@ bool ath9k_hw_intrpend(struct ath_hw *ah)
 
 	return false;
 }
+EXPORT_SYMBOL(ath9k_hw_intrpend);
 
 bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 {
@@ -3258,6 +3287,7 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_getisr);
 
 enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 {
@@ -3365,6 +3395,7 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 
 	return omask;
 }
+EXPORT_SYMBOL(ath9k_hw_set_interrupts);
 
 /*******************/
 /* Beacon Handling */
@@ -3426,6 +3457,7 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period)
 
 	REG_SET_BIT(ah, AR_TIMER_MODE, flags);
 }
+EXPORT_SYMBOL(ath9k_hw_beaconinit);
 
 void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs)
@@ -3489,6 +3521,7 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 	/* TSF Out of Range Threshold */
 	REG_WRITE(ah, AR_TSFOOR_THRESHOLD, bs->bs_tsfoor_threshold);
 }
+EXPORT_SYMBOL(ath9k_hw_set_sta_beacon_timers);
 
 /*******************/
 /* HW Capabilities */
@@ -3756,6 +3789,7 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 		return false;
 	}
 }
+EXPORT_SYMBOL(ath9k_hw_getcapability);
 
 bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 setting, int *status)
@@ -3789,6 +3823,7 @@ bool ath9k_hw_setcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 		return false;
 	}
 }
+EXPORT_SYMBOL(ath9k_hw_setcapability);
 
 /****************************/
 /* GPIO / RFKILL / Antennae */
@@ -3835,6 +3870,7 @@ void ath9k_hw_cfg_gpio_input(struct ath_hw *ah, u32 gpio)
 		(AR_GPIO_OE_OUT_DRV_NO << gpio_shift),
 		(AR_GPIO_OE_OUT_DRV << gpio_shift));
 }
+EXPORT_SYMBOL(ath9k_hw_cfg_gpio_input);
 
 u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
 {
@@ -3853,6 +3889,7 @@ u32 ath9k_hw_gpio_get(struct ath_hw *ah, u32 gpio)
 	else
 		return MS_REG_READ(AR, gpio) != 0;
 }
+EXPORT_SYMBOL(ath9k_hw_gpio_get);
 
 void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
 			 u32 ah_signal_type)
@@ -3868,22 +3905,26 @@ void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
 		(AR_GPIO_OE_OUT_DRV_ALL << gpio_shift),
 		(AR_GPIO_OE_OUT_DRV << gpio_shift));
 }
+EXPORT_SYMBOL(ath9k_hw_cfg_output);
 
 void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val)
 {
 	REG_RMW(ah, AR_GPIO_IN_OUT, ((val & 1) << gpio),
 		AR_GPIO_BIT(gpio));
 }
+EXPORT_SYMBOL(ath9k_hw_set_gpio);
 
 u32 ath9k_hw_getdefantenna(struct ath_hw *ah)
 {
 	return REG_READ(ah, AR_DEF_ANTENNA) & 0x7;
 }
+EXPORT_SYMBOL(ath9k_hw_getdefantenna);
 
 void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna)
 {
 	REG_WRITE(ah, AR_DEF_ANTENNA, (antenna & 0x7));
 }
+EXPORT_SYMBOL(ath9k_hw_setantenna);
 
 bool ath9k_hw_setantennaswitch(struct ath_hw *ah,
 			       enum ath9k_ant_setting settings,
@@ -3946,6 +3987,7 @@ u32 ath9k_hw_getrxfilter(struct ath_hw *ah)
 
 	return bits;
 }
+EXPORT_SYMBOL(ath9k_hw_getrxfilter);
 
 void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 {
@@ -3967,6 +4009,7 @@ void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits)
 		REG_WRITE(ah, AR_RXCFG,
 			  REG_READ(ah, AR_RXCFG) & ~AR_RXCFG_ZLFDMA);
 }
+EXPORT_SYMBOL(ath9k_hw_setrxfilter);
 
 bool ath9k_hw_phy_disable(struct ath_hw *ah)
 {
@@ -3976,6 +4019,7 @@ bool ath9k_hw_phy_disable(struct ath_hw *ah)
 	ath9k_hw_init_pll(ah, NULL);
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_phy_disable);
 
 bool ath9k_hw_disable(struct ath_hw *ah)
 {
@@ -3988,6 +4032,7 @@ bool ath9k_hw_disable(struct ath_hw *ah)
 	ath9k_hw_init_pll(ah, NULL);
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_disable);
 
 void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
 {
@@ -4004,22 +4049,26 @@ void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
 				 min((u32) MAX_RATE_POWER,
 				 (u32) regulatory->power_limit));
 }
+EXPORT_SYMBOL(ath9k_hw_set_txpowerlimit);
 
 void ath9k_hw_setmac(struct ath_hw *ah, const u8 *mac)
 {
 	memcpy(ath9k_hw_common(ah)->macaddr, mac, ETH_ALEN);
 }
+EXPORT_SYMBOL(ath9k_hw_setmac);
 
 void ath9k_hw_setopmode(struct ath_hw *ah)
 {
 	ath9k_hw_set_operating_mode(ah, ah->opmode);
 }
+EXPORT_SYMBOL(ath9k_hw_setopmode);
 
 void ath9k_hw_setmcastfilter(struct ath_hw *ah, u32 filter0, u32 filter1)
 {
 	REG_WRITE(ah, AR_MCAST_FIL0, filter0);
 	REG_WRITE(ah, AR_MCAST_FIL1, filter1);
 }
+EXPORT_SYMBOL(ath9k_hw_setmcastfilter);
 
 void ath9k_hw_write_associd(struct ath_hw *ah)
 {
@@ -4029,6 +4078,7 @@ void ath9k_hw_write_associd(struct ath_hw *ah)
 	REG_WRITE(ah, AR_BSS_ID1, get_unaligned_le16(common->curbssid + 4) |
 		  ((common->curaid & 0x3fff) << AR_BSS_ID1_AID_S));
 }
+EXPORT_SYMBOL(ath9k_hw_write_associd);
 
 u64 ath9k_hw_gettsf64(struct ath_hw *ah)
 {
@@ -4039,12 +4089,14 @@ u64 ath9k_hw_gettsf64(struct ath_hw *ah)
 
 	return tsf;
 }
+EXPORT_SYMBOL(ath9k_hw_gettsf64);
 
 void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64)
 {
 	REG_WRITE(ah, AR_TSF_L32, tsf64 & 0xffffffff);
 	REG_WRITE(ah, AR_TSF_U32, (tsf64 >> 32) & 0xffffffff);
 }
+EXPORT_SYMBOL(ath9k_hw_settsf64);
 
 void ath9k_hw_reset_tsf(struct ath_hw *ah)
 {
@@ -4055,6 +4107,7 @@ void ath9k_hw_reset_tsf(struct ath_hw *ah)
 
 	REG_WRITE(ah, AR_RESET_TSF, AR_RESET_TSF_ONCE);
 }
+EXPORT_SYMBOL(ath9k_hw_reset_tsf);
 
 void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
 {
@@ -4063,6 +4116,7 @@ void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
 	else
 		ah->misc_mode &= ~AR_PCU_TX_ADD_TSF;
 }
+EXPORT_SYMBOL(ath9k_hw_set_tsfadjust);
 
 bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
 {
@@ -4077,6 +4131,7 @@ bool ath9k_hw_setslottime(struct ath_hw *ah, u32 us)
 		return true;
 	}
 }
+EXPORT_SYMBOL(ath9k_hw_setslottime);
 
 void ath9k_hw_set11nmac2040(struct ath_hw *ah)
 {
@@ -4140,6 +4195,7 @@ u32 ath9k_hw_gettsf32(struct ath_hw *ah)
 {
 	return REG_READ(ah, AR_TSF_L32);
 }
+EXPORT_SYMBOL(ath9k_hw_gettsf32);
 
 struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 					  void (*trigger)(void *),
@@ -4168,6 +4224,7 @@ struct ath_gen_timer *ath_gen_timer_alloc(struct ath_hw *ah,
 
 	return timer;
 }
+EXPORT_SYMBOL(ath_gen_timer_alloc);
 
 void ath9k_hw_gen_timer_start(struct ath_hw *ah,
 			      struct ath_gen_timer *timer,
@@ -4209,6 +4266,7 @@ void ath9k_hw_gen_timer_start(struct ath_hw *ah,
 		(SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_THRESH) |
 		SM(AR_GENTMR_BIT(timer->index), AR_IMR_S5_GENTIMER_TRIG)));
 }
+EXPORT_SYMBOL(ath9k_hw_gen_timer_start);
 
 void ath9k_hw_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 {
@@ -4230,6 +4288,7 @@ void ath9k_hw_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 
 	clear_bit(timer->index, &timer_table->timer_mask.timer_bits);
 }
+EXPORT_SYMBOL(ath9k_hw_gen_timer_stop);
 
 void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer)
 {
@@ -4239,6 +4298,7 @@ void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer)
 	timer_table->timers[timer->index] = NULL;
 	kfree(timer);
 }
+EXPORT_SYMBOL(ath_gen_timer_free);
 
 /*
  * Generic Timer Interrupts handling
@@ -4276,3 +4336,4 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 		timer->trigger(timer->arg);
 	}
 }
+EXPORT_SYMBOL(ath_gen_timer_isr);
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 3be658d..e2c1ba3 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -39,11 +39,13 @@ u32 ath9k_hw_gettxbuf(struct ath_hw *ah, u32 q)
 {
 	return REG_READ(ah, AR_QTXDP(q));
 }
+EXPORT_SYMBOL(ath9k_hw_gettxbuf);
 
 void ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp)
 {
 	REG_WRITE(ah, AR_QTXDP(q), txdp);
 }
+EXPORT_SYMBOL(ath9k_hw_puttxbuf);
 
 void ath9k_hw_txstart(struct ath_hw *ah, u32 q)
 {
@@ -51,6 +53,7 @@ void ath9k_hw_txstart(struct ath_hw *ah, u32 q)
 		  "Enable TXE on queue: %u\n", q);
 	REG_WRITE(ah, AR_Q_TXE, 1 << q);
 }
+EXPORT_SYMBOL(ath9k_hw_txstart);
 
 u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q)
 {
@@ -65,6 +68,7 @@ u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q)
 
 	return npend;
 }
+EXPORT_SYMBOL(ath9k_hw_numtxpending);
 
 bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
 {
@@ -94,6 +98,7 @@ bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
 
 	return newLevel != curLevel;
 }
+EXPORT_SYMBOL(ath9k_hw_updatetxtriglevel);
 
 bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 {
@@ -173,6 +178,7 @@ bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 #undef ATH9K_TX_STOP_DMA_TIMEOUT
 #undef ATH9K_TIME_QUANTUM
 }
+EXPORT_SYMBOL(ath9k_hw_stoptxdma);
 
 void ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			 u32 segLen, bool firstSeg,
@@ -199,6 +205,7 @@ void ath9k_hw_filltxdesc(struct ath_hw *ah, struct ath_desc *ds,
 	ads->ds_txstatus6 = ads->ds_txstatus7 = 0;
 	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
 }
+EXPORT_SYMBOL(ath9k_hw_filltxdesc);
 
 void ath9k_hw_cleartxdesc(struct ath_hw *ah, struct ath_desc *ds)
 {
@@ -210,6 +217,7 @@ void ath9k_hw_cleartxdesc(struct ath_hw *ah, struct ath_desc *ds)
 	ads->ds_txstatus6 = ads->ds_txstatus7 = 0;
 	ads->ds_txstatus8 = ads->ds_txstatus9 = 0;
 }
+EXPORT_SYMBOL(ath9k_hw_cleartxdesc);
 
 int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds)
 {
@@ -285,6 +293,7 @@ int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds)
 
 	return 0;
 }
+EXPORT_SYMBOL(ath9k_hw_txprocdesc);
 
 void ath9k_hw_set11n_txdesc(struct ath_hw *ah, struct ath_desc *ds,
 			    u32 pktLen, enum ath9k_pkt_type type, u32 txPower,
@@ -320,6 +329,7 @@ void ath9k_hw_set11n_txdesc(struct ath_hw *ah, struct ath_desc *ds,
 		ads->ds_ctl11 = 0;
 	}
 }
+EXPORT_SYMBOL(ath9k_hw_set11n_txdesc);
 
 void ath9k_hw_set11n_ratescenario(struct ath_hw *ah, struct ath_desc *ds,
 				  struct ath_desc *lastds,
@@ -375,6 +385,7 @@ void ath9k_hw_set11n_ratescenario(struct ath_hw *ah, struct ath_desc *ds,
 	last_ads->ds_ctl2 = ads->ds_ctl2;
 	last_ads->ds_ctl3 = ads->ds_ctl3;
 }
+EXPORT_SYMBOL(ath9k_hw_set11n_ratescenario);
 
 void ath9k_hw_set11n_aggr_first(struct ath_hw *ah, struct ath_desc *ds,
 				u32 aggrLen)
@@ -385,6 +396,7 @@ void ath9k_hw_set11n_aggr_first(struct ath_hw *ah, struct ath_desc *ds,
 	ads->ds_ctl6 &= ~AR_AggrLen;
 	ads->ds_ctl6 |= SM(aggrLen, AR_AggrLen);
 }
+EXPORT_SYMBOL(ath9k_hw_set11n_aggr_first);
 
 void ath9k_hw_set11n_aggr_middle(struct ath_hw *ah, struct ath_desc *ds,
 				 u32 numDelims)
@@ -399,6 +411,7 @@ void ath9k_hw_set11n_aggr_middle(struct ath_hw *ah, struct ath_desc *ds,
 	ctl6 |= SM(numDelims, AR_PadDelim);
 	ads->ds_ctl6 = ctl6;
 }
+EXPORT_SYMBOL(ath9k_hw_set11n_aggr_middle);
 
 void ath9k_hw_set11n_aggr_last(struct ath_hw *ah, struct ath_desc *ds)
 {
@@ -408,6 +421,7 @@ void ath9k_hw_set11n_aggr_last(struct ath_hw *ah, struct ath_desc *ds)
 	ads->ds_ctl1 &= ~AR_MoreAggr;
 	ads->ds_ctl6 &= ~AR_PadDelim;
 }
+EXPORT_SYMBOL(ath9k_hw_set11n_aggr_last);
 
 void ath9k_hw_clr11n_aggr(struct ath_hw *ah, struct ath_desc *ds)
 {
@@ -415,6 +429,7 @@ void ath9k_hw_clr11n_aggr(struct ath_hw *ah, struct ath_desc *ds)
 
 	ads->ds_ctl1 &= (~AR_IsAggr & ~AR_MoreAggr);
 }
+EXPORT_SYMBOL(ath9k_hw_clr11n_aggr);
 
 void ath9k_hw_set11n_burstduration(struct ath_hw *ah, struct ath_desc *ds,
 				   u32 burstDuration)
@@ -424,6 +439,7 @@ void ath9k_hw_set11n_burstduration(struct ath_hw *ah, struct ath_desc *ds,
 	ads->ds_ctl2 &= ~AR_BurstDur;
 	ads->ds_ctl2 |= SM(burstDuration, AR_BurstDur);
 }
+EXPORT_SYMBOL(ath9k_hw_set11n_burstduration);
 
 void ath9k_hw_set11n_virtualmorefrag(struct ath_hw *ah, struct ath_desc *ds,
 				     u32 vmf)
@@ -441,6 +457,7 @@ void ath9k_hw_gettxintrtxqs(struct ath_hw *ah, u32 *txqs)
 	*txqs &= ah->intr_txqs;
 	ah->intr_txqs &= ~(*txqs);
 }
+EXPORT_SYMBOL(ath9k_hw_gettxintrtxqs);
 
 bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 			    const struct ath9k_tx_queue_info *qinfo)
@@ -512,6 +529,7 @@ bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_set_txq_props);
 
 bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
 			    struct ath9k_tx_queue_info *qinfo)
@@ -550,6 +568,7 @@ bool ath9k_hw_get_txq_props(struct ath_hw *ah, int q,
 
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_get_txq_props);
 
 int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 			  const struct ath9k_tx_queue_info *qinfo)
@@ -617,6 +636,7 @@ int ath9k_hw_setuptxqueue(struct ath_hw *ah, enum ath9k_tx_queue type,
 
 	return q;
 }
+EXPORT_SYMBOL(ath9k_hw_setuptxqueue);
 
 bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 {
@@ -648,6 +668,7 @@ bool ath9k_hw_releasetxqueue(struct ath_hw *ah, u32 q)
 
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_releasetxqueue);
 
 bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 {
@@ -805,6 +826,7 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_resettxqueue);
 
 int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 			u32 pa, struct ath_desc *nds, u64 tsf)
@@ -886,6 +908,7 @@ int ath9k_hw_rxprocdesc(struct ath_hw *ah, struct ath_desc *ds,
 
 	return 0;
 }
+EXPORT_SYMBOL(ath9k_hw_rxprocdesc);
 
 void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 			  u32 size, u32 flags)
@@ -901,6 +924,7 @@ void ath9k_hw_setuprxdesc(struct ath_hw *ah, struct ath_desc *ds,
 	if (!(pCap->hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
 		memset(&(ads->u), 0, sizeof(ads->u));
 }
+EXPORT_SYMBOL(ath9k_hw_setuprxdesc);
 
 bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set)
 {
@@ -930,16 +954,19 @@ bool ath9k_hw_setrxabort(struct ath_hw *ah, bool set)
 
 	return true;
 }
+EXPORT_SYMBOL(ath9k_hw_setrxabort);
 
 void ath9k_hw_putrxbuf(struct ath_hw *ah, u32 rxdp)
 {
 	REG_WRITE(ah, AR_RXDP, rxdp);
 }
+EXPORT_SYMBOL(ath9k_hw_putrxbuf);
 
 void ath9k_hw_rxena(struct ath_hw *ah)
 {
 	REG_WRITE(ah, AR_CR, AR_CR_RXE);
 }
+EXPORT_SYMBOL(ath9k_hw_rxena);
 
 void ath9k_hw_startpcureceive(struct ath_hw *ah)
 {
@@ -949,6 +976,7 @@ void ath9k_hw_startpcureceive(struct ath_hw *ah)
 
 	REG_CLR_BIT(ah, AR_DIAG_SW, (AR_DIAG_RX_DIS | AR_DIAG_RX_ABORT));
 }
+EXPORT_SYMBOL(ath9k_hw_startpcureceive);
 
 void ath9k_hw_stoppcurecv(struct ath_hw *ah)
 {
@@ -956,6 +984,7 @@ void ath9k_hw_stoppcurecv(struct ath_hw *ah)
 
 	ath9k_hw_disable_mib_counters(ah);
 }
+EXPORT_SYMBOL(ath9k_hw_stoppcurecv);
 
 bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
 {
@@ -988,3 +1017,4 @@ bool ath9k_hw_stopdmarecv(struct ath_hw *ah)
 #undef AH_RX_TIME_QUANTUM
 #undef AH_RX_STOP_DMA_TIMEOUT
 }
+EXPORT_SYMBOL(ath9k_hw_stopdmarecv);
-- 
1.6.3.3

