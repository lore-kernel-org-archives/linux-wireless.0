Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35807 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1KYSlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 13:41:07 -0500
Received: by faas1 with SMTP id s1so2343654faa.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 10:41:05 -0800 (PST)
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	nbd@openwrt.org, jirislaby@gmail.com,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH v2 06/12] ath5k: Cleanups v2 + add kerneldoc on all hw functions
Date: Fri, 25 Nov 2011 20:40:25 +0200
Message-Id: <1322246431-10825-7-git-send-email-mickflemm@gmail.com> (sfid-20111125_194128_505325_1EFAE850)
In-Reply-To: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
References: <1322246431-10825-1-git-send-email-mickflemm@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No functional changes

Add kernel doc for all ath5k_hw_* functions and strcucts. Also do some cleanup,
rename ath5k_hw_init_beacon to ath5k_hw_init_beacon_timers, remove an unused
variable from ath5k_hw_pcu_init and a few obsolete macros, mostly related to XR.

Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/ani.c      |   86 +++--
 drivers/net/wireless/ath/ath5k/ani.h      |   32 +-
 drivers/net/wireless/ath/ath5k/ath5k.h    |  531 ++++++++++++++-------
 drivers/net/wireless/ath/ath5k/attach.c   |    9 +-
 drivers/net/wireless/ath/ath5k/base.c     |    3 +-
 drivers/net/wireless/ath/ath5k/desc.c     |  217 +++++++--
 drivers/net/wireless/ath/ath5k/desc.h     |  124 ++++--
 drivers/net/wireless/ath/ath5k/dma.c      |  120 ++---
 drivers/net/wireless/ath/ath5k/gpio.c     |   81 +++-
 drivers/net/wireless/ath/ath5k/initvals.c |   75 ++-
 drivers/net/wireless/ath/ath5k/pcu.c      |  222 ++++++---
 drivers/net/wireless/ath/ath5k/phy.c      |  748 +++++++++++++++++++++++------
 drivers/net/wireless/ath/ath5k/qcu.c      |  124 ++++--
 drivers/net/wireless/ath/ath5k/reset.c    |  216 +++++++--
 drivers/net/wireless/ath/ath5k/rfbuffer.h |   59 ++-
 drivers/net/wireless/ath/ath5k/rfgain.h   |   22 +-
 16 files changed, 1944 insertions(+), 725 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index bea90e6..2dfcf1a 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -27,15 +27,21 @@
  * or reducing sensitivity as necessary.
  *
  * The parameters are:
+ *
  *   - "noise immunity"
+ *
  *   - "spur immunity"
+ *
  *   - "firstep level"
+ *
  *   - "OFDM weak signal detection"
+ *
  *   - "CCK weak signal detection"
  *
  * Basically we look at the amount of ODFM and CCK timing errors we get and then
  * raise or lower immunity accordingly by setting one or more of these
  * parameters.
+ *
  * Newer chipsets have PHY error counters in hardware which will generate a MIB
  * interrupt when they overflow. Older hardware has too enable PHY error frames
  * by setting a RX flag and then count every single PHY error. When a specified
@@ -45,11 +51,13 @@
  */
 
 
-/*** ANI parameter control ***/
+/***********************\
+* ANI parameter control *
+\***********************/
 
 /**
  * ath5k_ani_set_noise_immunity_level() - Set noise immunity level
- *
+ * @ah: The &struct ath5k_hw
  * @level: level between 0 and @ATH5K_ANI_MAX_NOISE_IMM_LVL
  */
 void
@@ -91,12 +99,11 @@ ath5k_ani_set_noise_immunity_level(struct ath5k_hw *ah, int level)
 	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI, "new level %d", level);
 }
 
-
 /**
  * ath5k_ani_set_spur_immunity_level() - Set spur immunity level
- *
+ * @ah: The &struct ath5k_hw
  * @level: level between 0 and @max_spur_level (the maximum level is dependent
- *	on the chip revision).
+ * on the chip revision).
  */
 void
 ath5k_ani_set_spur_immunity_level(struct ath5k_hw *ah, int level)
@@ -117,10 +124,9 @@ ath5k_ani_set_spur_immunity_level(struct ath5k_hw *ah, int level)
 	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI, "new level %d", level);
 }
 
-
 /**
  * ath5k_ani_set_firstep_level() - Set "firstep" level
- *
+ * @ah: The &struct ath5k_hw
  * @level: level between 0 and @ATH5K_ANI_MAX_FIRSTEP_LVL
  */
 void
@@ -140,11 +146,9 @@ ath5k_ani_set_firstep_level(struct ath5k_hw *ah, int level)
 	ATH5K_DBG_UNLIMIT(ah, ATH5K_DEBUG_ANI, "new level %d", level);
 }
 
-
 /**
- * ath5k_ani_set_ofdm_weak_signal_detection() - Control OFDM weak signal
- *						detection
- *
+ * ath5k_ani_set_ofdm_weak_signal_detection() - Set OFDM weak signal detection
+ * @ah: The &struct ath5k_hw
  * @on: turn on or off
  */
 void
@@ -182,10 +186,9 @@ ath5k_ani_set_ofdm_weak_signal_detection(struct ath5k_hw *ah, bool on)
 			  on ? "on" : "off");
 }
 
-
 /**
- * ath5k_ani_set_cck_weak_signal_detection() - control CCK weak signal detection
- *
+ * ath5k_ani_set_cck_weak_signal_detection() - Set CCK weak signal detection
+ * @ah: The &struct ath5k_hw
  * @on: turn on or off
  */
 void
@@ -200,13 +203,16 @@ ath5k_ani_set_cck_weak_signal_detection(struct ath5k_hw *ah, bool on)
 }
 
 
-/*** ANI algorithm ***/
+/***************\
+* ANI algorithm *
+\***************/
 
 /**
  * ath5k_ani_raise_immunity() - Increase noise immunity
- *
+ * @ah: The &struct ath5k_hw
+ * @as: The &struct ath5k_ani_state
  * @ofdm_trigger: If this is true we are called because of too many OFDM errors,
- *	the algorithm will tune more parameters then.
+ * the algorithm will tune more parameters then.
  *
  * Try to raise noise immunity (=decrease sensitivity) in several steps
  * depending on the average RSSI of the beacons we received.
@@ -290,9 +296,10 @@ ath5k_ani_raise_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as,
 	*/
 }
 
-
 /**
  * ath5k_ani_lower_immunity() - Decrease noise immunity
+ * @ah: The &struct ath5k_hw
+ * @as: The &struct ath5k_ani_state
  *
  * Try to lower noise immunity (=increase sensitivity) in several steps
  * depending on the average RSSI of the beacons we received.
@@ -352,9 +359,10 @@ ath5k_ani_lower_immunity(struct ath5k_hw *ah, struct ath5k_ani_state *as)
 	}
 }
 
-
 /**
  * ath5k_hw_ani_get_listen_time() - Update counters and return listening time
+ * @ah: The &struct ath5k_hw
+ * @as: The &struct ath5k_ani_state
  *
  * Return an approximation of the time spent "listening" in milliseconds (ms)
  * since the last call of this function.
@@ -379,9 +387,10 @@ ath5k_hw_ani_get_listen_time(struct ath5k_hw *ah, struct ath5k_ani_state *as)
 	return listen;
 }
 
-
 /**
  * ath5k_ani_save_and_clear_phy_errors() - Clear and save PHY error counters
+ * @ah: The &struct ath5k_hw
+ * @as: The &struct ath5k_ani_state
  *
  * Clear the PHY error counters as soon as possible, since this might be called
  * from a MIB interrupt and we want to make sure we don't get interrupted again.
@@ -429,9 +438,10 @@ ath5k_ani_save_and_clear_phy_errors(struct ath5k_hw *ah,
 	return 1;
 }
 
-
 /**
  * ath5k_ani_period_restart() - Restart ANI period
+ * @ah: The &struct ath5k_hw
+ * @as: The &struct ath5k_ani_state
  *
  * Just reset counters, so they are clear for the next "ani period".
  */
@@ -448,9 +458,9 @@ ath5k_ani_period_restart(struct ath5k_hw *ah, struct ath5k_ani_state *as)
 	as->listen_time = 0;
 }
 
-
 /**
  * ath5k_ani_calibration() - The main ANI calibration function
+ * @ah: The &struct ath5k_hw
  *
  * We count OFDM and CCK errors relative to the time where we did not send or
  * receive ("listen" time) and raise or lower immunity accordingly.
@@ -509,10 +519,13 @@ ath5k_ani_calibration(struct ath5k_hw *ah)
 }
 
 
-/*** INTERRUPT HANDLER ***/
+/*******************\
+* Interrupt handler *
+\*******************/
 
 /**
  * ath5k_ani_mib_intr() - Interrupt handler for ANI MIB counters
+ * @ah: The &struct ath5k_hw
  *
  * Just read & reset the registers quickly, so they don't generate more
  * interrupts, save the counters and schedule the tasklet to decide whether
@@ -549,9 +562,11 @@ ath5k_ani_mib_intr(struct ath5k_hw *ah)
 		tasklet_schedule(&ah->ani_tasklet);
 }
 
-
 /**
- * ath5k_ani_phy_error_report() - Used by older HW to report PHY errors
+ * ath5k_ani_phy_error_report - Used by older HW to report PHY errors
+ *
+ * @ah: The &struct ath5k_hw
+ * @phyerr: One of enum ath5k_phy_error_code
  *
  * This is used by hardware without PHY error counters to report PHY errors
  * on a frame-by-frame basis, instead of the interrupt.
@@ -574,10 +589,13 @@ ath5k_ani_phy_error_report(struct ath5k_hw *ah,
 }
 
 
-/*** INIT ***/
+/****************\
+* Initialization *
+\****************/
 
 /**
  * ath5k_enable_phy_err_counters() - Enable PHY error counters
+ * @ah: The &struct ath5k_hw
  *
  * Enable PHY error counters for OFDM and CCK timing errors.
  */
@@ -596,9 +614,9 @@ ath5k_enable_phy_err_counters(struct ath5k_hw *ah)
 	ath5k_hw_reg_write(ah, 0, AR5K_CCK_FIL_CNT);
 }
 
-
 /**
  * ath5k_disable_phy_err_counters() - Disable PHY error counters
+ * @ah: The &struct ath5k_hw
  *
  * Disable PHY error counters for OFDM and CCK timing errors.
  */
@@ -615,10 +633,10 @@ ath5k_disable_phy_err_counters(struct ath5k_hw *ah)
 	ath5k_hw_reg_write(ah, 0, AR5K_CCK_FIL_CNT);
 }
 
-
 /**
  * ath5k_ani_init() - Initialize ANI
- * @mode: Which mode to use (auto, manual high, manual low, off)
+ * @ah: The &struct ath5k_hw
+ * @mode: One of enum ath5k_ani_mode
  *
  * Initialize ANI according to mode.
  */
@@ -695,10 +713,18 @@ ath5k_ani_init(struct ath5k_hw *ah, enum ath5k_ani_mode mode)
 }
 
 
-/*** DEBUG ***/
+/**************\
+* Debug output *
+\**************/
 
 #ifdef CONFIG_ATH5K_DEBUG
 
+/**
+ * ath5k_ani_print_counters() - Print ANI counters
+ * @ah: The &struct ath5k_hw
+ *
+ * Used for debugging ANI
+ */
 void
 ath5k_ani_print_counters(struct ath5k_hw *ah)
 {
diff --git a/drivers/net/wireless/ath/ath5k/ani.h b/drivers/net/wireless/ath/ath5k/ani.h
index 7358b6c..21aa355 100644
--- a/drivers/net/wireless/ath/ath5k/ani.h
+++ b/drivers/net/wireless/ath/ath5k/ani.h
@@ -40,13 +40,13 @@ enum ath5k_phy_error_code;
  * enum ath5k_ani_mode - mode for ANI / noise sensitivity
  *
  * @ATH5K_ANI_MODE_OFF: Turn ANI off. This can be useful to just stop the ANI
- *	algorithm after it has been on auto mode.
- * ATH5K_ANI_MODE_MANUAL_LOW: Manually set all immunity parameters to low,
- *	maximizing sensitivity. ANI will not run.
- * ATH5K_ANI_MODE_MANUAL_HIGH: Manually set all immunity parameters to high,
- *	minimizing sensitivity. ANI will not run.
- * ATH5K_ANI_MODE_AUTO: Automatically control immunity parameters based on the
- *	amount of OFDM and CCK frame errors (default).
+ *			algorithm after it has been on auto mode.
+ * @ATH5K_ANI_MODE_MANUAL_LOW: Manually set all immunity parameters to low,
+ *			maximizing sensitivity. ANI will not run.
+ * @ATH5K_ANI_MODE_MANUAL_HIGH: Manually set all immunity parameters to high,
+ *			minimizing sensitivity. ANI will not run.
+ * @ATH5K_ANI_MODE_AUTO: Automatically control immunity parameters based on the
+ *			amount of OFDM and CCK frame errors (default).
  */
 enum ath5k_ani_mode {
 	ATH5K_ANI_MODE_OFF		= 0,
@@ -58,8 +58,22 @@ enum ath5k_ani_mode {
 
 /**
  * struct ath5k_ani_state - ANI state and associated counters
- *
- * @max_spur_level: the maximum spur level is chip dependent
+ * @ani_mode: One of enum ath5k_ani_mode
+ * @noise_imm_level: Noise immunity level
+ * @spur_level: Spur immunity level
+ * @firstep_level: FIRstep level
+ * @ofdm_weak_sig: OFDM weak signal detection state (on/off)
+ * @cck_weak_sig: CCK weak signal detection state (on/off)
+ * @max_spur_level: Max spur immunity level (chip specific)
+ * @listen_time: Listen time
+ * @ofdm_errors: OFDM timing error count
+ * @cck_errors: CCK timing error count
+ * @last_cc: The &struct ath_cycle_counters (for stats)
+ * @last_listen: Listen time from previous run (for stats)
+ * @last_ofdm_errors: OFDM timing error count from previous run (for tats)
+ * @last_cck_errors: CCK timing error count from previous run (for stats)
+ * @sum_ofdm_errors: Sum of OFDM timing errors (for stats)
+ * @sum_cck_errors: Sum of all CCK timing errors (for stats)
  */
 struct ath5k_ani_state {
 	enum ath5k_ani_mode	ani_mode;
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 3e75d02..819c4db5 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -261,16 +261,34 @@
 #define	AR5K_AGC_SETTLING_TURBO			37
 
 
-/* GENERIC CHIPSET DEFINITIONS */
 
-/* MAC Chips */
+/*****************************\
+* GENERIC CHIPSET DEFINITIONS *
+\*****************************/
+
+/**
+ * enum ath5k_version - MAC Chips
+ * @AR5K_AR5210: AR5210 (Crete)
+ * @AR5K_AR5211: AR5211 (Oahu/Maui)
+ * @AR5K_AR5212: AR5212 (Venice) and newer
+ */
 enum ath5k_version {
 	AR5K_AR5210	= 0,
 	AR5K_AR5211	= 1,
 	AR5K_AR5212	= 2,
 };
 
-/* PHY Chips */
+/**
+ * enum ath5k_radio - PHY Chips
+ * @AR5K_RF5110: RF5110 (Fez)
+ * @AR5K_RF5111: RF5111 (Sombrero)
+ * @AR5K_RF5112: RF2112/5112(A) (Derby/Derby2)
+ * @AR5K_RF2413: RF2413/2414 (Griffin/Griffin-Lite)
+ * @AR5K_RF5413: RF5413/5414/5424 (Eagle/Condor)
+ * @AR5K_RF2316: RF2315/2316 (Cobra SoC)
+ * @AR5K_RF2317: RF2317 (Spider SoC)
+ * @AR5K_RF2425: RF2425/2417 (Swan/Nalla)
+ */
 enum ath5k_radio {
 	AR5K_RF5110	= 0,
 	AR5K_RF5111	= 1,
@@ -302,11 +320,11 @@ enum ath5k_radio {
 #define AR5K_SREV_AR5213A	0x59 /* Hainan */
 #define AR5K_SREV_AR2413	0x78 /* Griffin lite */
 #define AR5K_SREV_AR2414	0x70 /* Griffin */
-#define AR5K_SREV_AR2315_R6 0x86 /* AP51-Light */
-#define AR5K_SREV_AR2315_R7 0x87 /* AP51-Full */
+#define AR5K_SREV_AR2315_R6	0x86 /* AP51-Light */
+#define AR5K_SREV_AR2315_R7	0x87 /* AP51-Full */
 #define AR5K_SREV_AR5424	0x90 /* Condor */
-#define AR5K_SREV_AR2317_R1 0x90 /* AP61-Light */
-#define AR5K_SREV_AR2317_R2 0x91 /* AP61-Full */
+#define AR5K_SREV_AR2317_R1	0x90 /* AP61-Light */
+#define AR5K_SREV_AR2317_R2	0x91 /* AP61-Full */
 #define AR5K_SREV_AR5413	0xa4 /* Eagle lite */
 #define AR5K_SREV_AR5414	0xa0 /* Eagle */
 #define AR5K_SREV_AR2415	0xb0 /* Talon */
@@ -343,32 +361,40 @@ enum ath5k_radio {
 
 /* TODO add support to mac80211 for vendor-specific rates and modes */
 
-/*
+/**
+ * DOC: Atheros XR
+ *
  * Some of this information is based on Documentation from:
  *
  * http://madwifi-project.org/wiki/ChipsetFeatures/SuperAG
  *
- * Modulation for Atheros' eXtended Range - range enhancing extension that is
- * supposed to double the distance an Atheros client device can keep a
- * connection with an Atheros access point. This is achieved by increasing
- * the receiver sensitivity up to, -105dBm, which is about 20dB above what
- * the 802.11 specifications demand. In addition, new (proprietary) data rates
- * are introduced: 3, 2, 1, 0.5 and 0.25 MBit/s.
+ * Atheros' eXtended Range - range enhancing extension is a modulation scheme
+ * that is supposed to double the link distance between an Atheros XR-enabled
+ * client device with an Atheros XR-enabled access point. This is achieved
+ * by increasing the receiver sensitivity up to, -105dBm, which is about 20dB
+ * above what the 802.11 specifications demand. In addition, new (proprietary)
+ * data rates are introduced: 3, 2, 1, 0.5 and 0.25 MBit/s.
  *
  * Please note that can you either use XR or TURBO but you cannot use both,
  * they are exclusive.
  *
+ * Also note that we do not plan to support XR mode at least for now. You can
+ * get a mode similar to XR by using 5MHz bwmode.
  */
-#define MODULATION_XR		0x00000200
-/*
- * Modulation for Atheros' Turbo G and Turbo A, its supposed to provide a
- * throughput transmission speed up to 40Mbit/s-60Mbit/s at a 108Mbit/s
- * signaling rate achieved through the bonding of two 54Mbit/s 802.11g
- * channels. To use this feature your Access Point must also support it.
+
+
+/**
+ * DOC: Atheros SuperAG
+ *
+ * In addition to XR we have another modulation scheme called TURBO mode
+ * that is supposed to provide a throughput transmission speed up to 40Mbit/s
+ * -60Mbit/s at a 108Mbit/s signaling rate achieved through the bonding of two
+ * 54Mbit/s 802.11g channels. To use this feature both ends must support it.
  * There is also a distinction between "static" and "dynamic" turbo modes:
  *
  * - Static: is the dumb version: devices set to this mode stick to it until
  *     the mode is turned off.
+ *
  * - Dynamic: is the intelligent version, the network decides itself if it
  *     is ok to use turbo. As soon as traffic is detected on adjacent channels
  *     (which would get used in turbo mode), or when a non-turbo station joins
@@ -382,24 +408,39 @@ enum ath5k_radio {
  *
  * http://www.pcworld.com/article/id,113428-page,1/article.html
  *
- * The channel bonding seems to be driver specific though. In addition to
- * deciding what channels will be used, these "Turbo" modes are accomplished
- * by also enabling the following features:
+ * The channel bonding seems to be driver specific though.
+ *
+ * In addition to TURBO modes we also have the following features for even
+ * greater speed-up:
  *
  * - Bursting: allows multiple frames to be sent at once, rather than pausing
  *     after each frame. Bursting is a standards-compliant feature that can be
  *     used with any Access Point.
+ *
  * - Fast frames: increases the amount of information that can be sent per
  *     frame, also resulting in a reduction of transmission overhead. It is a
  *     proprietary feature that needs to be supported by the Access Point.
+ *
  * - Compression: data frames are compressed in real time using a Lempel Ziv
  *     algorithm. This is done transparently. Once this feature is enabled,
  *     compression and decompression takes place inside the chipset, without
  *     putting additional load on the host CPU.
  *
+ * As with XR we also don't plan to support SuperAG features for now. You can
+ * get a mode similar to TURBO by using 40MHz bwmode.
  */
-#define MODULATION_TURBO	0x00000080
 
+
+/**
+ * enum ath5k_driver_mode - PHY operation mode
+ * @AR5K_MODE_11A: 802.11a
+ * @AR5K_MODE_11B: 802.11b
+ * @AR5K_MODE_11G: 801.11g
+ * @AR5K_MODE_MAX: Used for boundary checks
+ *
+ * Do not change the order here, we use these as
+ * array indices and it also maps EEPROM structures.
+ */
 enum ath5k_driver_mode {
 	AR5K_MODE_11A		=	0,
 	AR5K_MODE_11B		=	1,
@@ -407,30 +448,64 @@ enum ath5k_driver_mode {
 	AR5K_MODE_MAX		=	3
 };
 
+/**
+ * enum ath5k_ant_mode - Antenna operation mode
+ * @AR5K_ANTMODE_DEFAULT: Default antenna setup
+ * @AR5K_ANTMODE_FIXED_A: Only antenna A is present
+ * @AR5K_ANTMODE_FIXED_B: Only antenna B is present
+ * @AR5K_ANTMODE_SINGLE_AP: STA locked on a single ap
+ * @AR5K_ANTMODE_SECTOR_AP: AP with tx antenna set on tx desc
+ * @AR5K_ANTMODE_SECTOR_STA: STA with tx antenna set on tx desc
+ * @AR5K_ANTMODE_DEBUG: Debug mode -A -> Rx, B-> Tx-
+ * @AR5K_ANTMODE_MAX: Used for boundary checks
+ *
+ * For more infos on antenna control check out phy.c
+ */
 enum ath5k_ant_mode {
-	AR5K_ANTMODE_DEFAULT	= 0,	/* default antenna setup */
-	AR5K_ANTMODE_FIXED_A	= 1,	/* only antenna A is present */
-	AR5K_ANTMODE_FIXED_B	= 2,	/* only antenna B is present */
-	AR5K_ANTMODE_SINGLE_AP	= 3,	/* sta locked on a single ap */
-	AR5K_ANTMODE_SECTOR_AP	= 4,	/* AP with tx antenna set on tx desc */
-	AR5K_ANTMODE_SECTOR_STA	= 5,	/* STA with tx antenna set on tx desc */
-	AR5K_ANTMODE_DEBUG	= 6,	/* Debug mode -A -> Rx, B-> Tx- */
+	AR5K_ANTMODE_DEFAULT	= 0,
+	AR5K_ANTMODE_FIXED_A	= 1,
+	AR5K_ANTMODE_FIXED_B	= 2,
+	AR5K_ANTMODE_SINGLE_AP	= 3,
+	AR5K_ANTMODE_SECTOR_AP	= 4,
+	AR5K_ANTMODE_SECTOR_STA	= 5,
+	AR5K_ANTMODE_DEBUG	= 6,
 	AR5K_ANTMODE_MAX,
 };
 
+/**
+ * enum ath5k_bw_mode - Bandwidth operation mode
+ * @AR5K_BWMODE_DEFAULT: 20MHz, default operation
+ * @AR5K_BWMODE_5MHZ: Quarter rate
+ * @AR5K_BWMODE_10MHZ: Half rate
+ * @AR5K_BWMODE_40MHZ: Turbo
+ */
 enum ath5k_bw_mode {
-	AR5K_BWMODE_DEFAULT	= 0,	/* 20MHz, default operation */
-	AR5K_BWMODE_5MHZ	= 1,	/* Quarter rate */
-	AR5K_BWMODE_10MHZ	= 2,	/* Half rate */
-	AR5K_BWMODE_40MHZ	= 3	/* Turbo */
+	AR5K_BWMODE_DEFAULT	= 0,
+	AR5K_BWMODE_5MHZ	= 1,
+	AR5K_BWMODE_10MHZ	= 2,
+	AR5K_BWMODE_40MHZ	= 3
 };
 
+
+
 /****************\
   TX DEFINITIONS
 \****************/
 
-/*
- * TX Status descriptor
+/**
+ * struct ath5k_tx_status - TX Status descriptor
+ * @ts_seqnum: Sequence number
+ * @ts_tstamp: Timestamp
+ * @ts_status: Status code
+ * @ts_final_idx: Final transmission series index
+ * @ts_final_retry: Final retry count
+ * @ts_rssi: RSSI for received ACK
+ * @ts_shortretry: Short retry count
+ * @ts_virtcol: Virtual collision count
+ * @ts_antenna: Antenna used
+ *
+ * TX status descriptor gets filled by the hw
+ * on each transmission attempt.
  */
 struct ath5k_tx_status {
 	u16	ts_seqnum;
@@ -453,7 +528,6 @@ struct ath5k_tx_status {
  * enum ath5k_tx_queue - Queue types used to classify tx queues.
  * @AR5K_TX_QUEUE_INACTIVE: q is unused -- see ath5k_hw_release_tx_queue
  * @AR5K_TX_QUEUE_DATA: A normal data queue
- * @AR5K_TX_QUEUE_XR_DATA: An XR-data queue
  * @AR5K_TX_QUEUE_BEACON: The beacon queue
  * @AR5K_TX_QUEUE_CAB: The after-beacon queue
  * @AR5K_TX_QUEUE_UAPSD: Unscheduled Automatic Power Save Delivery queue
@@ -461,7 +535,6 @@ struct ath5k_tx_status {
 enum ath5k_tx_queue {
 	AR5K_TX_QUEUE_INACTIVE = 0,
 	AR5K_TX_QUEUE_DATA,
-	AR5K_TX_QUEUE_XR_DATA,
 	AR5K_TX_QUEUE_BEACON,
 	AR5K_TX_QUEUE_CAB,
 	AR5K_TX_QUEUE_UAPSD,
@@ -470,36 +543,48 @@ enum ath5k_tx_queue {
 #define	AR5K_NUM_TX_QUEUES		10
 #define	AR5K_NUM_TX_QUEUES_NOQCU	2
 
-/*
- * Queue syb-types to classify normal data queues.
+/**
+ * enum ath5k_tx_queue_subtype - Queue sub-types to classify normal data queues
+ * @AR5K_WME_AC_BK: Background traffic
+ * @AR5K_WME_AC_BE: Best-effort (normal) traffic
+ * @AR5K_WME_AC_VI: Video traffic
+ * @AR5K_WME_AC_VO: Voice traffic
+ *
  * These are the 4 Access Categories as defined in
  * WME spec. 0 is the lowest priority and 4 is the
  * highest. Normal data that hasn't been classified
  * goes to the Best Effort AC.
  */
 enum ath5k_tx_queue_subtype {
-	AR5K_WME_AC_BK = 0,	/*Background traffic*/
-	AR5K_WME_AC_BE,		/*Best-effort (normal) traffic*/
-	AR5K_WME_AC_VI,		/*Video traffic*/
-	AR5K_WME_AC_VO,		/*Voice traffic*/
+	AR5K_WME_AC_BK = 0,
+	AR5K_WME_AC_BE,
+	AR5K_WME_AC_VI,
+	AR5K_WME_AC_VO,
 };
 
-/*
- * Queue ID numbers as returned by the hw functions, each number
- * represents a hw queue. If hw does not support hw queues
+/**
+ * enum ath5k_tx_queue_id - Queue ID numbers as returned by the hw functions
+ * @AR5K_TX_QUEUE_ID_NOQCU_DATA: Data queue on AR5210 (no QCU available)
+ * @AR5K_TX_QUEUE_ID_NOQCU_BEACON: Beacon queue on AR5210 (no QCU available)
+ * @AR5K_TX_QUEUE_ID_DATA_MIN: Data queue min index
+ * @AR5K_TX_QUEUE_ID_DATA_MAX: Data queue max index
+ * @AR5K_TX_QUEUE_ID_CAB: Content after beacon queue
+ * @AR5K_TX_QUEUE_ID_BEACON: Beacon queue
+ * @AR5K_TX_QUEUE_ID_UAPSD: Urgent Automatic Power Save Delivery,
+ * @AR5K_TX_QUEUE_ID_XR_DATA: XR Data queue
+ *
+ * Each number represents a hw queue. If hw does not support hw queues
  * (eg 5210) all data goes in one queue. These match
- * d80211 definitions (net80211/MadWiFi don't use them).
+ * mac80211 definitions.
  */
 enum ath5k_tx_queue_id {
 	AR5K_TX_QUEUE_ID_NOQCU_DATA	= 0,
 	AR5K_TX_QUEUE_ID_NOQCU_BEACON	= 1,
-	AR5K_TX_QUEUE_ID_DATA_MIN	= 0, /*IEEE80211_TX_QUEUE_DATA0*/
-	AR5K_TX_QUEUE_ID_DATA_MAX	= 3, /*IEEE80211_TX_QUEUE_DATA3*/
-	AR5K_TX_QUEUE_ID_DATA_SVP	= 5, /*IEEE80211_TX_QUEUE_SVP - Spectralink Voice Protocol*/
-	AR5K_TX_QUEUE_ID_CAB		= 6, /*IEEE80211_TX_QUEUE_AFTER_BEACON*/
-	AR5K_TX_QUEUE_ID_BEACON		= 7, /*IEEE80211_TX_QUEUE_BEACON*/
+	AR5K_TX_QUEUE_ID_DATA_MIN	= 0,
+	AR5K_TX_QUEUE_ID_DATA_MAX	= 3,
+	AR5K_TX_QUEUE_ID_CAB		= 6,
+	AR5K_TX_QUEUE_ID_BEACON		= 7,
 	AR5K_TX_QUEUE_ID_UAPSD		= 8,
-	AR5K_TX_QUEUE_ID_XR_DATA	= 9,
 };
 
 /*
@@ -520,46 +605,70 @@ enum ath5k_tx_queue_id {
 #define AR5K_TXQ_FLAG_POST_FR_BKOFF_DIS		0x1000	/* Disable backoff while bursting */
 #define AR5K_TXQ_FLAG_COMPRESSION_ENABLE	0x2000	/* Enable hw compression -not implemented-*/
 
-/*
- * Data transmit queue state.  One of these exists for each
- * hardware transmit queue.  Packets sent to us from above
- * are assigned to queues based on their priority.  Not all
- * devices support a complete set of hardware transmit queues.
- * For those devices the array sc_ac2q will map multiple
- * priorities to fewer hardware queues (typically all to one
- * hardware queue).
+/**
+ * struct ath5k_txq - Transmit queue state
+ * @qnum: Hardware q number
+ * @link: Link ptr in last TX desc
+ * @q: Transmit queue (&struct list_head)
+ * @lock: Lock on q and link
+ * @setup: Is the queue configured
+ * @txq_len:Number of queued buffers
+ * @txq_max: Max allowed num of queued buffers
+ * @txq_poll_mark: Used to check if queue got stuck
+ * @txq_stuck: Queue stuck counter
+ *
+ * One of these exists for each hardware transmit queue.
+ * Packets sent to us from above are assigned to queues based
+ * on their priority.  Not all devices support a complete set
+ * of hardware transmit queues. For those devices the array
+ * sc_ac2q will map multiple priorities to fewer hardware queues
+ * (typically all to one hardware queue).
  */
 struct ath5k_txq {
-	unsigned int		qnum;	/* hardware q number */
-	u32			*link;	/* link ptr in last TX desc */
-	struct list_head	q;	/* transmit queue */
-	spinlock_t		lock;	/* lock on q and link */
+	unsigned int		qnum;
+	u32			*link;
+	struct list_head	q;
+	spinlock_t		lock;
 	bool			setup;
-	int			txq_len; /* number of queued buffers */
-	int			txq_max; /* max allowed num of queued buffers */
+	int			txq_len;
+	int			txq_max;
 	bool			txq_poll_mark;
-	unsigned int		txq_stuck;	/* informational counter */
+	unsigned int		txq_stuck;
 };
 
-/*
- * A struct to hold tx queue's parameters
+/**
+ * struct ath5k_txq_info - A struct to hold TX queue's parameters
+ * @tqi_type: One of enum ath5k_tx_queue
+ * @tqi_subtype: One of enum ath5k_tx_queue_subtype
+ * @tqi_flags: TX queue flags (see above)
+ * @tqi_aifs: Arbitrated Inter-frame Space
+ * @tqi_cw_min: Minimum Contention Window
+ * @tqi_cw_max: Maximum Contention Window
+ * @tqi_cbr_period: Constant bit rate period
+ * @tqi_ready_time: Time queue waits after an event when RDYTIME is enabled
  */
 struct ath5k_txq_info {
 	enum ath5k_tx_queue tqi_type;
 	enum ath5k_tx_queue_subtype tqi_subtype;
-	u16	tqi_flags;	/* Tx queue flags (see above) */
-	u8	tqi_aifs;	/* Arbitrated Interframe Space */
-	u16	tqi_cw_min;	/* Minimum Contention Window */
-	u16	tqi_cw_max;	/* Maximum Contention Window */
-	u32	tqi_cbr_period; /* Constant bit rate period */
+	u16	tqi_flags;
+	u8	tqi_aifs;
+	u16	tqi_cw_min;
+	u16	tqi_cw_max;
+	u32	tqi_cbr_period;
 	u32	tqi_cbr_overflow_limit;
 	u32	tqi_burst_time;
-	u32	tqi_ready_time; /* Time queue waits after an event */
+	u32	tqi_ready_time;
 };
 
-/*
- * Transmit packet types.
- * used on tx control descriptor
+/**
+ * enum ath5k_pkt_type - Transmit packet types
+ * @AR5K_PKT_TYPE_NORMAL: Normal data
+ * @AR5K_PKT_TYPE_ATIM: ATIM
+ * @AR5K_PKT_TYPE_PSPOLL: PS-Poll
+ * @AR5K_PKT_TYPE_BEACON: Beacon
+ * @AR5K_PKT_TYPE_PROBE_RESP: Probe response
+ * @AR5K_PKT_TYPE_PIFS: PIFS
+ * Used on tx control descriptor
  */
 enum ath5k_pkt_type {
 	AR5K_PKT_TYPE_NORMAL		= 0,
@@ -582,27 +691,23 @@ enum ath5k_pkt_type {
 	(ah->ah_txpower.txp_rates_power_table[(_r)] & 0x3f) << (_v)	\
 )
 
-/*
- * DMA size definitions (2^(n+2))
- */
-enum ath5k_dmasize {
-	AR5K_DMASIZE_4B	= 0,
-	AR5K_DMASIZE_8B,
-	AR5K_DMASIZE_16B,
-	AR5K_DMASIZE_32B,
-	AR5K_DMASIZE_64B,
-	AR5K_DMASIZE_128B,
-	AR5K_DMASIZE_256B,
-	AR5K_DMASIZE_512B
-};
 
 
 /****************\
   RX DEFINITIONS
 \****************/
 
-/*
- * RX Status descriptor
+/**
+ * struct ath5k_rx_status - RX Status descriptor
+ * @rs_datalen: Data length
+ * @rs_tstamp: Timestamp
+ * @rs_status: Status code
+ * @rs_phyerr: PHY error mask
+ * @rs_rssi: RSSI in 0.5dbm units
+ * @rs_keyix: Index to the key used for decrypting
+ * @rs_rate: Rate used to decode the frame
+ * @rs_antenna: Antenna used to receive the frame
+ * @rs_more: Indicates this is a frame fragment (Fast frames)
  */
 struct ath5k_rx_status {
 	u16	rs_datalen;
@@ -644,10 +749,18 @@ struct ath5k_rx_status {
 #define TSF_TO_TU(_tsf) (u32)((_tsf) >> 10)
 
 
+
 /*******************************\
   GAIN OPTIMIZATION DEFINITIONS
 \*******************************/
 
+/**
+ * enum ath5k_rfgain - RF Gain optimization engine state
+ * @AR5K_RFGAIN_INACTIVE: Engine disabled
+ * @AR5K_RFGAIN_ACTIVE: Probe active
+ * @AR5K_RFGAIN_READ_REQUESTED: Probe requested
+ * @AR5K_RFGAIN_NEED_CHANGE: Gain_F needs change
+ */
 enum ath5k_rfgain {
 	AR5K_RFGAIN_INACTIVE = 0,
 	AR5K_RFGAIN_ACTIVE,
@@ -655,6 +768,16 @@ enum ath5k_rfgain {
 	AR5K_RFGAIN_NEED_CHANGE,
 };
 
+/**
+ * struct ath5k_gain - RF Gain optimization engine state data
+ * @g_step_idx: Current step index
+ * @g_current: Current gain
+ * @g_target: Target gain
+ * @g_low: Low gain boundary
+ * @g_high: High gain boundary
+ * @g_f_corr: Gain_F correction
+ * @g_state: One of enum ath5k_rfgain
+ */
 struct ath5k_gain {
 	u8			g_step_idx;
 	u8			g_current;
@@ -665,6 +788,8 @@ struct ath5k_gain {
 	u8			g_state;
 };
 
+
+
 /********************\
   COMMON DEFINITIONS
 \********************/
@@ -673,9 +798,14 @@ struct ath5k_gain {
 #define AR5K_SLOT_TIME_20	880
 #define AR5K_SLOT_TIME_MAX	0xffff
 
-/*
- * The following structure is used to map 2GHz channels to
- * 5GHz Atheros channels.
+/**
+ * struct ath5k_athchan_2ghz - 2GHz to 5GHZ map for RF5111
+ * @a2_flags: Channel flags (internal)
+ * @a2_athchan: HW channel number (internal)
+ *
+ * This structure is used to map 2GHz channels to
+ * 5GHz Atheros channels on 2111 frequency converter
+ * that comes together with RF5111
  * TODO: Clean up
  */
 struct ath5k_athchan_2ghz {
@@ -683,36 +813,80 @@ struct ath5k_athchan_2ghz {
 	u16	a2_athchan;
 };
 
+/**
+ * enum ath5k_dmasize -  DMA size definitions (2^(n+2))
+ * @AR5K_DMASIZE_4B: 4Bytes
+ * @AR5K_DMASIZE_8B: 8Bytes
+ * @AR5K_DMASIZE_16B: 16Bytes
+ * @AR5K_DMASIZE_32B: 32Bytes
+ * @AR5K_DMASIZE_64B: 64Bytes (Default)
+ * @AR5K_DMASIZE_128B: 128Bytes
+ * @AR5K_DMASIZE_256B: 256Bytes
+ * @AR5K_DMASIZE_512B: 512Bytes
+ *
+ * These are used to set DMA burst size on hw
+ *
+ * Note: Some platforms can't handle more than 4Bytes
+ * be careful on embedded boards.
+ */
+enum ath5k_dmasize {
+	AR5K_DMASIZE_4B	= 0,
+	AR5K_DMASIZE_8B,
+	AR5K_DMASIZE_16B,
+	AR5K_DMASIZE_32B,
+	AR5K_DMASIZE_64B,
+	AR5K_DMASIZE_128B,
+	AR5K_DMASIZE_256B,
+	AR5K_DMASIZE_512B
+};
+
+
 
 /******************\
   RATE DEFINITIONS
 \******************/
 
 /**
+ * DOC: Rate codes
+ *
  * Seems the ar5xxx hardware supports up to 32 rates, indexed by 1-32.
  *
  * The rate code is used to get the RX rate or set the TX rate on the
  * hardware descriptors. It is also used for internal modulation control
  * and settings.
  *
- * This is the hardware rate map we are aware of:
- *
- * rate_code   0x01    0x02    0x03    0x04    0x05    0x06    0x07    0x08
- * rate_kbps   3000    1000    ?       ?       ?       2000    500     48000
- *
- * rate_code   0x09    0x0A    0x0B    0x0C    0x0D    0x0E    0x0F    0x10
- * rate_kbps   24000   12000   6000    54000   36000   18000   9000    ?
+ * This is the hardware rate map we are aware of (html unfriendly):
  *
- * rate_code   17      18      19      20      21      22      23      24
- * rate_kbps   ?       ?       ?       ?       ?       ?       ?       11000
+ * Rate code	Rate (Kbps)
+ * ---------	-----------
+ * 0x01		 3000 (XR)
+ * 0x02		 1000 (XR)
+ * 0x03		  250 (XR)
+ * 0x04 - 05	-Reserved-
+ * 0x06		 2000 (XR)
+ * 0x07		  500 (XR)
+ * 0x08		48000 (OFDM)
+ * 0x09		24000 (OFDM)
+ * 0x0A		12000 (OFDM)
+ * 0x0B		 6000 (OFDM)
+ * 0x0C		54000 (OFDM)
+ * 0x0D		36000 (OFDM)
+ * 0x0E		18000 (OFDM)
+ * 0x0F		 9000 (OFDM)
+ * 0x10 - 17	-Reserved-
+ * 0x18		11000L (CCK)
+ * 0x19		 5500L (CCK)
+ * 0x1A		 2000L (CCK)
+ * 0x1B		 1000L (CCK)
+ * 0x1C		11000S (CCK)
+ * 0x1D		 5500S (CCK)
+ * 0x1E		 2000S (CCK)
+ * 0x1F		-Reserved-
  *
- * rate_code   25      26      27      28      29      30      31      32
- * rate_kbps   5500    2000    1000    11000S  5500S   2000S   ?       ?
- *
- * "S" indicates CCK rates with short preamble.
+ * "S" indicates CCK rates with short preamble and "L" with long preamble.
  *
  * AR5211 has different rate codes for CCK (802.11B) rates. It only uses the
- * lowest 4 bits, so they are the same as below with a 0xF mask.
+ * lowest 4 bits, so they are the same as above with a 0xF mask.
  * (0xB, 0xA, 0x9 and 0x8 for 1M, 2M, 5.5M and 11M).
  * We handle this in ath5k_setup_bands().
  */
@@ -732,13 +906,9 @@ struct ath5k_athchan_2ghz {
 #define ATH5K_RATE_CODE_36M	0x0D
 #define ATH5K_RATE_CODE_48M	0x08
 #define ATH5K_RATE_CODE_54M	0x0C
-/* XR */
-#define ATH5K_RATE_CODE_XR_500K	0x07
-#define ATH5K_RATE_CODE_XR_1M	0x02
-#define ATH5K_RATE_CODE_XR_2M	0x06
-#define ATH5K_RATE_CODE_XR_3M	0x01
 
-/* adding this flag to rate_code enables short preamble */
+/* Adding this flag to rate_code on B rates
+ * enables short preamble */
 #define AR5K_SET_SHORT_PREAMBLE 0x04
 
 /*
@@ -768,49 +938,65 @@ extern int ath5k_modparam_nohwcrypt;
 
 /**
  * enum ath5k_int - Hardware interrupt masks helpers
+ * @AR5K_INT_RXOK: Frame successfully received
+ * @AR5K_INT_RXDESC: Request RX descriptor/Read RX descriptor
+ * @AR5K_INT_RXERR: Frame reception failed
+ * @AR5K_INT_RXNOFRM: No frame received within a specified time period
+ * @AR5K_INT_RXEOL: Reached "End Of List", means we need more RX descriptors
+ * @AR5K_INT_RXORN: Indicates we got RX FIFO overrun. Note that Rx overrun is
+ *		not always fatal, on some chips we can continue operation
+ *		without resetting the card, that's why %AR5K_INT_FATAL is not
+ *		common for all chips.
+ * @AR5K_INT_RX_ALL: Mask to identify all RX related interrupts
+ *
+ * @AR5K_INT_TXOK: Frame transmission success
+ * @AR5K_INT_TXDESC: Request TX descriptor/Read TX status descriptor
+ * @AR5K_INT_TXERR: Frame transmission failure
+ * @AR5K_INT_TXEOL: Received End Of List for VEOL (Virtual End Of List). The
+ *		Queue Control Unit (QCU) signals an EOL interrupt only if a
+ *		descriptor's LinkPtr is NULL. For more details, refer to:
+ *		"http://www.freepatentsonline.com/20030225739.html"
+ * @AR5K_INT_TXNOFRM: No frame was transmitted within a specified time period
+ * @AR5K_INT_TXURN: Indicates we got TX FIFO underrun. In such case we should
+ *		increase the TX trigger threshold.
+ * @AR5K_INT_TX_ALL: Mask to identify all TX related interrupts
  *
- * @AR5K_INT_RX: mask to identify received frame interrupts, of type
- *	AR5K_ISR_RXOK or AR5K_ISR_RXERR
- * @AR5K_INT_RXDESC: Request RX descriptor/Read RX descriptor (?)
- * @AR5K_INT_RXNOFRM: No frame received (?)
- * @AR5K_INT_RXEOL: received End Of List for VEOL (Virtual End Of List). The
- *	Queue Control Unit (QCU) signals an EOL interrupt only if a descriptor's
- *	LinkPtr is NULL. For more details, refer to:
- *	http://www.freepatentsonline.com/20030225739.html
- * @AR5K_INT_RXORN: Indicates we got RX overrun (eg. no more descriptors).
- *	Note that Rx overrun is not always fatal, on some chips we can continue
- *	operation without resetting the card, that's why int_fatal is not
- *	common for all chips.
- * @AR5K_INT_TX: mask to identify received frame interrupts, of type
- *	AR5K_ISR_TXOK or AR5K_ISR_TXERR
- * @AR5K_INT_TXDESC: Request TX descriptor/Read TX status descriptor (?)
- * @AR5K_INT_TXURN: received when we should increase the TX trigger threshold
- *	We currently do increments on interrupt by
- *	(AR5K_TUNE_MAX_TX_FIFO_THRES - current_trigger_level) / 2
  * @AR5K_INT_MIB: Indicates the either Management Information Base counters or
- *	one of the PHY error counters reached the maximum value and should be
- *	read and cleared.
+ *		one of the PHY error counters reached the maximum value and
+ *		should be read and cleared.
+ * @AR5K_INT_SWI: Software triggered interrupt.
  * @AR5K_INT_RXPHY: RX PHY Error
  * @AR5K_INT_RXKCM: RX Key cache miss
  * @AR5K_INT_SWBA: SoftWare Beacon Alert - indicates its time to send a
- *	beacon that must be handled in software. The alternative is if you
- *	have VEOL support, in that case you let the hardware deal with things.
+ *		beacon that must be handled in software. The alternative is if
+ *		you have VEOL support, in that case you let the hardware deal
+ *		with things.
+ * @AR5K_INT_BRSSI: Beacon received with an RSSI value below our threshold
  * @AR5K_INT_BMISS: If in STA mode this indicates we have stopped seeing
- *	beacons from the AP have associated with, we should probably try to
- *	reassociate. When in IBSS mode this might mean we have not received
- *	any beacons from any local stations. Note that every station in an
- *	IBSS schedules to send beacons at the Target Beacon Transmission Time
- *	(TBTT) with a random backoff.
- * @AR5K_INT_BNR: Beacon Not Ready interrupt - ??
- * @AR5K_INT_GPIO: GPIO interrupt is used for RF Kill, disabled for now
- *	until properly handled
- * @AR5K_INT_FATAL: Fatal errors were encountered, typically caused by DMA
- *	errors. These types of errors we can enable seem to be of type
- *	AR5K_SIMR2_MCABT, AR5K_SIMR2_SSERR and AR5K_SIMR2_DPERR.
+ *		beacons from the AP have associated with, we should probably
+ *		try to reassociate. When in IBSS mode this might mean we have
+ *		not received any beacons from any local stations. Note that
+ *		every station in an IBSS schedules to send beacons at the
+ *		Target Beacon Transmission Time (TBTT) with a random backoff.
+ * @AR5K_INT_BNR: Beacon queue got triggered (DMA beacon alert) while empty.
+ * @AR5K_INT_TIM: Beacon with local station's TIM bit set
+ * @AR5K_INT_DTIM: Beacon with DTIM bit and zero DTIM count received
+ * @AR5K_INT_DTIM_SYNC: DTIM sync lost
+ * @AR5K_INT_GPIO: GPIO interrupt is used for RF Kill switches connected to
+ *		our GPIO pins.
+ * @AR5K_INT_BCN_TIMEOUT: Beacon timeout, we waited after TBTT but got noting
+ * @AR5K_INT_CAB_TIMEOUT: We waited for CAB traffic after the beacon but got
+ *		nothing or an incomplete CAB frame sequence.
+ * @AR5K_INT_QCBRORN: A queue got it's CBR counter expired
+ * @AR5K_INT_QCBRURN: A queue got triggered wile empty
+ * @AR5K_INT_QTRIG: A queue got triggered
+ *
+ * @AR5K_INT_FATAL: Fatal errors were encountered, typically caused by bus/DMA
+ *		errors. Indicates we need to reset the card.
  * @AR5K_INT_GLOBAL: Used to clear and set the IER
- * @AR5K_INT_NOCARD: signals the card has been removed
- * @AR5K_INT_COMMON: common interrupts shared among MACs with the same
- *	bit value
+ * @AR5K_INT_NOCARD: Signals the card has been removed
+ * @AR5K_INT_COMMON: Common interrupts shared among MACs with the same
+ *		bit value
  *
  * These are mapped to take advantage of some common bits
  * between the MACs, to be able to set intr properties
@@ -846,10 +1032,9 @@ enum ath5k_int {
 	AR5K_INT_GPIO	=	0x01000000,
 	AR5K_INT_BCN_TIMEOUT =	0x02000000, /* Non common */
 	AR5K_INT_CAB_TIMEOUT =	0x04000000, /* Non common */
-	AR5K_INT_RX_DOPPLER =	0x08000000, /* Non common */
-	AR5K_INT_QCBRORN =	0x10000000, /* Non common */
-	AR5K_INT_QCBRURN =	0x20000000, /* Non common */
-	AR5K_INT_QTRIG	=	0x40000000, /* Non common */
+	AR5K_INT_QCBRORN =	0x08000000, /* Non common */
+	AR5K_INT_QCBRURN =	0x10000000, /* Non common */
+	AR5K_INT_QTRIG	=	0x20000000, /* Non common */
 	AR5K_INT_GLOBAL =	0x80000000,
 
 	AR5K_INT_TX_ALL = AR5K_INT_TXOK
@@ -891,7 +1076,13 @@ enum ath5k_int {
 	AR5K_INT_NOCARD	= 0xffffffff
 };
 
-/* mask which calibration is active at the moment */
+/**
+ * enum ath5k_calibration_mask - Mask which calibration is active at the moment
+ * @AR5K_CALIBRATION_FULL: Full calibration (AGC + SHORT)
+ * @AR5K_CALIBRATION_SHORT: Short calibration (NF + I/Q)
+ * @AR5K_CALIBRATION_NF: Noise Floor calibration
+ * @AR5K_CALIBRATION_ANI: Adaptive Noise Immunity
+ */
 enum ath5k_calibration_mask {
 	AR5K_CALIBRATION_FULL = 0x01,
 	AR5K_CALIBRATION_SHORT = 0x02,
@@ -899,8 +1090,18 @@ enum ath5k_calibration_mask {
 	AR5K_CALIBRATION_ANI = 0x08,
 };
 
-/*
- * Power management
+/**
+ * enum ath5k_power_mode - Power management modes
+ * @AR5K_PM_UNDEFINED: Undefined
+ * @AR5K_PM_AUTO: Allow card to sleep if possible
+ * @AR5K_PM_AWAKE: Force card to wake up
+ * @AR5K_PM_FULL_SLEEP: Force card to full sleep (DANGEROUS)
+ * @AR5K_PM_NETWORK_SLEEP: Allow to sleep for a specified duration
+ *
+ * Currently only PM_AWAKE is used, FULL_SLEEP and NETWORK_SLEEP/AUTO
+ * are also known to have problems on some cards. This is not a big
+ * problem though because we can have almost the same effect as
+ * FULL_SLEEP by putting card on warm reset (it's almost powered down).
  */
 enum ath5k_power_mode {
 	AR5K_PM_UNDEFINED = 0,
@@ -1344,11 +1545,11 @@ void ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah);
 u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah);
 void ath5k_hw_set_tsf64(struct ath5k_hw *ah, u64 tsf64);
 void ath5k_hw_reset_tsf(struct ath5k_hw *ah);
-void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval);
+void ath5k_hw_init_beacon_timers(struct ath5k_hw *ah, u32 next_beacon,
+							u32 interval);
 bool ath5k_hw_check_beacon_timers(struct ath5k_hw *ah, int intval);
 /* Init function */
-void ath5k_hw_pcu_init(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
-								u8 mode);
+void ath5k_hw_pcu_init(struct ath5k_hw *ah, enum nl80211_iftype op_mode);
 
 /* Queue Control Unit, DFS Control Unit Functions */
 int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 49fdc93..b69e057 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -27,8 +27,7 @@
 #include "debug.h"
 
 /**
- * ath5k_hw_post - Power On Self Test helper function
- *
+ * ath5k_hw_post() - Power On Self Test helper function
  * @ah: The &struct ath5k_hw
  */
 static int ath5k_hw_post(struct ath5k_hw *ah)
@@ -92,8 +91,7 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
 }
 
 /**
- * ath5k_hw_init - Check if hw is supported and init the needed structs
- *
+ * ath5k_hw_init() - Check if hw is supported and init the needed structs
  * @ah: The &struct ath5k_hw associated with the device
  *
  * Check if the device is supported, perform a POST and initialize the needed
@@ -349,8 +347,7 @@ err:
 }
 
 /**
- * ath5k_hw_deinit - Free the ath5k_hw struct
- *
+ * ath5k_hw_deinit() - Free the &struct ath5k_hw
  * @ah: The &struct ath5k_hw
  */
 void ath5k_hw_deinit(struct ath5k_hw *ah)
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a8cb1c7..9bb40b0 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -183,7 +183,6 @@ static const struct ieee80211_rate ath5k_rates[] = {
 	{ .bitrate = 540,
 	  .hw_value = ATH5K_RATE_CODE_54M,
 	  .flags = 0 },
-	/* XR missing */
 };
 
 static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
@@ -2005,7 +2004,7 @@ ath5k_beacon_update_timers(struct ath5k_hw *ah, u64 bc_tsf)
 	ah->nexttbtt = nexttbtt;
 
 	intval |= AR5K_BEACON_ENA;
-	ath5k_hw_init_beacon(ah, nexttbtt, intval);
+	ath5k_hw_init_beacon_timers(ah, nexttbtt, intval);
 
 	/*
 	 * debugging output last in order to preserve the time critical aspect
diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index 7e88dda..f8bfa3a 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -26,20 +26,61 @@
 #include "debug.h"
 
 
+/**
+ * DOC: Hardware descriptor functions
+ *
+ * Here we handle the processing of the low-level hw descriptors
+ * that hw reads and writes via DMA for each TX and RX attempt (that means
+ * we can also have descriptors for failed TX/RX tries). We have two kind of
+ * descriptors for RX and TX, control descriptors tell the hw how to send or
+ * receive a packet where to read/write it from/to etc and status descriptors
+ * that contain information about how the packet was sent or received (errors
+ * included).
+ *
+ * Descriptor format is not exactly the same for each MAC chip version so we
+ * have function pointers on &struct ath5k_hw we initialize at runtime based on
+ * the chip used.
+ */
+
+
 /************************\
 * TX Control descriptors *
 \************************/
 
-/*
- * Initialize the 2-word tx control descriptor on 5210/5211
+/**
+ * ath5k_hw_setup_2word_tx_desc() - Initialize a 2-word tx control descriptor
+ * @ah: The &struct ath5k_hw
+ * @desc: The &struct ath5k_desc
+ * @pkt_len: Frame length in bytes
+ * @hdr_len: Header length in bytes (only used on AR5210)
+ * @padsize: Any padding we've added to the frame length
+ * @type: One of enum ath5k_pkt_type
+ * @tx_power: Tx power in 0.5dB steps
+ * @tx_rate0: HW idx for transmission rate
+ * @tx_tries0: Max number of retransmissions
+ * @key_index: Index on key table to use for encryption
+ * @antenna_mode: Which antenna to use (0 for auto)
+ * @flags: One of AR5K_TXDESC_* flags (desc.h)
+ * @rtscts_rate: HW idx for RTS/CTS transmission rate
+ * @rtscts_duration: What to put on duration field on the header of RTS/CTS
+ *
+ * Internal function to initialize a 2-Word TX control descriptor
+ * found on AR5210 and AR5211 MACs chips.
+ *
+ * Returns 0 on success or -EINVAL on false input
  */
 static int
-ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
-	unsigned int pkt_len, unsigned int hdr_len, int padsize,
-	enum ath5k_pkt_type type,
-	unsigned int tx_power, unsigned int tx_rate0, unsigned int tx_tries0,
-	unsigned int key_index, unsigned int antenna_mode, unsigned int flags,
-	unsigned int rtscts_rate, unsigned int rtscts_duration)
+ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah,
+			struct ath5k_desc *desc,
+			unsigned int pkt_len, unsigned int hdr_len,
+			int padsize,
+			enum ath5k_pkt_type type,
+			unsigned int tx_power,
+			unsigned int tx_rate0, unsigned int tx_tries0,
+			unsigned int key_index,
+			unsigned int antenna_mode,
+			unsigned int flags,
+			unsigned int rtscts_rate, unsigned int rtscts_duration)
 {
 	u32 frame_type;
 	struct ath5k_hw_2w_tx_ctl *tx_ctl;
@@ -172,17 +213,40 @@ ath5k_hw_setup_2word_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	return 0;
 }
 
-/*
- * Initialize the 4-word tx control descriptor on 5212
+/**
+ * ath5k_hw_setup_4word_tx_desc() - Initialize a 4-word tx control descriptor
+ * @ah: The &struct ath5k_hw
+ * @desc: The &struct ath5k_desc
+ * @pkt_len: Frame length in bytes
+ * @hdr_len: Header length in bytes (only used on AR5210)
+ * @padsize: Any padding we've added to the frame length
+ * @type: One of enum ath5k_pkt_type
+ * @tx_power: Tx power in 0.5dB steps
+ * @tx_rate0: HW idx for transmission rate
+ * @tx_tries0: Max number of retransmissions
+ * @key_index: Index on key table to use for encryption
+ * @antenna_mode: Which antenna to use (0 for auto)
+ * @flags: One of AR5K_TXDESC_* flags (desc.h)
+ * @rtscts_rate: HW idx for RTS/CTS transmission rate
+ * @rtscts_duration: What to put on duration field on the header of RTS/CTS
+ *
+ * Internal function to initialize a 4-Word TX control descriptor
+ * found on AR5212 and later MACs chips.
+ *
+ * Returns 0 on success or -EINVAL on false input
  */
-static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
-	struct ath5k_desc *desc, unsigned int pkt_len, unsigned int hdr_len,
-	int padsize,
-	enum ath5k_pkt_type type, unsigned int tx_power, unsigned int tx_rate0,
-	unsigned int tx_tries0, unsigned int key_index,
-	unsigned int antenna_mode, unsigned int flags,
-	unsigned int rtscts_rate,
-	unsigned int rtscts_duration)
+static int
+ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
+			struct ath5k_desc *desc,
+			unsigned int pkt_len, unsigned int hdr_len,
+			int padsize,
+			enum ath5k_pkt_type type,
+			unsigned int tx_power,
+			unsigned int tx_rate0, unsigned int tx_tries0,
+			unsigned int key_index,
+			unsigned int antenna_mode,
+			unsigned int flags,
+			unsigned int rtscts_rate, unsigned int rtscts_duration)
 {
 	struct ath5k_hw_4w_tx_ctl *tx_ctl;
 	unsigned int frame_len;
@@ -292,13 +356,29 @@ static int ath5k_hw_setup_4word_tx_desc(struct ath5k_hw *ah,
 	return 0;
 }
 
-/*
- * Initialize a 4-word multi rate retry tx control descriptor on 5212
+/**
+ * ath5k_hw_setup_mrr_tx_desc() - Initialize an MRR tx control descriptor
+ * @ah: The &struct ath5k_hw
+ * @desc: The &struct ath5k_desc
+ * @tx_rate1: HW idx for rate used on transmission series 1
+ * @tx_tries1: Max number of retransmissions for transmission series 1
+ * @tx_rate2: HW idx for rate used on transmission series 2
+ * @tx_tries2: Max number of retransmissions for transmission series 2
+ * @tx_rate3: HW idx for rate used on transmission series 3
+ * @tx_tries3: Max number of retransmissions for transmission series 3
+ *
+ * Multi rate retry (MRR) tx control descriptors are available only on AR5212
+ * MACs, they are part of the normal 4-word tx control descriptor (see above)
+ * but we handle them through a separate function for better abstraction.
+ *
+ * Returns 0 on success or -EINVAL on invalid input
  */
 int
-ath5k_hw_setup_mrr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
-	unsigned int tx_rate1, u_int tx_tries1, u_int tx_rate2,
-	u_int tx_tries2, unsigned int tx_rate3, u_int tx_tries3)
+ath5k_hw_setup_mrr_tx_desc(struct ath5k_hw *ah,
+			struct ath5k_desc *desc,
+			u_int tx_rate1, u_int tx_tries1,
+			u_int tx_rate2, u_int tx_tries2,
+			u_int tx_rate3, u_int tx_tries3)
 {
 	struct ath5k_hw_4w_tx_ctl *tx_ctl;
 
@@ -350,11 +430,16 @@ ath5k_hw_setup_mrr_tx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 * TX Status descriptors *
 \***********************/
 
-/*
- * Process the tx status descriptor on 5210/5211
+/**
+ * ath5k_hw_proc_2word_tx_status() - Process a tx status descriptor on 5210/1
+ * @ah: The &struct ath5k_hw
+ * @desc: The &struct ath5k_desc
+ * @ts: The &struct ath5k_tx_status
  */
-static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
-		struct ath5k_desc *desc, struct ath5k_tx_status *ts)
+static int
+ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
+				struct ath5k_desc *desc,
+				struct ath5k_tx_status *ts)
 {
 	struct ath5k_hw_2w_tx_ctl *tx_ctl;
 	struct ath5k_hw_tx_status *tx_status;
@@ -399,11 +484,16 @@ static int ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
 	return 0;
 }
 
-/*
- * Process a tx status descriptor on 5212
+/**
+ * ath5k_hw_proc_4word_tx_status() - Process a tx status descriptor on 5212
+ * @ah: The &struct ath5k_hw
+ * @desc: The &struct ath5k_desc
+ * @ts: The &struct ath5k_tx_status
  */
-static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
-		struct ath5k_desc *desc, struct ath5k_tx_status *ts)
+static int
+ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
+				struct ath5k_desc *desc,
+				struct ath5k_tx_status *ts)
 {
 	struct ath5k_hw_4w_tx_ctl *tx_ctl;
 	struct ath5k_hw_tx_status *tx_status;
@@ -460,11 +550,17 @@ static int ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 * RX Descriptors *
 \****************/
 
-/*
- * Initialize an rx control descriptor
+/**
+ * ath5k_hw_setup_rx_desc() - Initialize an rx control descriptor
+ * @ah: The &struct ath5k_hw
+ * @desc: The &struct ath5k_desc
+ * @size: RX buffer length in bytes
+ * @flags: One of AR5K_RXDESC_* flags
  */
-int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
-			   u32 size, unsigned int flags)
+int
+ath5k_hw_setup_rx_desc(struct ath5k_hw *ah,
+			struct ath5k_desc *desc,
+			u32 size, unsigned int flags)
 {
 	struct ath5k_hw_rx_ctl *rx_ctl;
 
@@ -491,11 +587,22 @@ int ath5k_hw_setup_rx_desc(struct ath5k_hw *ah, struct ath5k_desc *desc,
 	return 0;
 }
 
-/*
- * Process the rx status descriptor on 5210/5211
+/**
+ * ath5k_hw_proc_5210_rx_status() - Process the rx status descriptor on 5210/1
+ * @ah: The &struct ath5k_hw
+ * @desc: The &struct ath5k_desc
+ * @rs: The &struct ath5k_rx_status
+ *
+ * Internal function used to process an RX status descriptor
+ * on AR5210/5211 MAC.
+ *
+ * Returns 0 on success or -EINPROGRESS in case we haven't received the who;e
+ * frame yet.
  */
-static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
-		struct ath5k_desc *desc, struct ath5k_rx_status *rs)
+static int
+ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
+				struct ath5k_desc *desc,
+				struct ath5k_rx_status *rs)
 {
 	struct ath5k_hw_rx_status *rx_status;
 
@@ -574,12 +681,22 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 	return 0;
 }
 
-/*
- * Process the rx status descriptor on 5212
+/**
+ * ath5k_hw_proc_5212_rx_status() - Process the rx status descriptor on 5212
+ * @ah: The &struct ath5k_hw
+ * @desc: The &struct ath5k_desc
+ * @rs: The &struct ath5k_rx_status
+ *
+ * Internal function used to process an RX status descriptor
+ * on AR5212 and later MAC.
+ *
+ * Returns 0 on success or -EINPROGRESS in case we haven't received the who;e
+ * frame yet.
  */
-static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
-					struct ath5k_desc *desc,
-					struct ath5k_rx_status *rs)
+static int
+ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
+				struct ath5k_desc *desc,
+				struct ath5k_rx_status *rs)
 {
 	struct ath5k_hw_rx_status *rx_status;
 	u32 rxstat0, rxstat1;
@@ -646,10 +763,16 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 * Attach *
 \********/
 
-/*
- * Init function pointers inside ath5k_hw struct
+/**
+ * ath5k_hw_init_desc_functions() - Init function pointers inside ah
+ * @ah: The &struct ath5k_hw
+ *
+ * Maps the internal descriptor functions to the function pointers on ah, used
+ * from above. This is used as an abstraction layer to handle the various chips
+ * the same way.
  */
-int ath5k_hw_init_desc_functions(struct ath5k_hw *ah)
+int
+ath5k_hw_init_desc_functions(struct ath5k_hw *ah)
 {
 	if (ah->ah_version == AR5K_AR5212) {
 		ah->ah_setup_tx_desc = ath5k_hw_setup_4word_tx_desc;
diff --git a/drivers/net/wireless/ath/ath5k/desc.h b/drivers/net/wireless/ath/ath5k/desc.h
index cfd529b5..8d6c01a 100644
--- a/drivers/net/wireless/ath/ath5k/desc.h
+++ b/drivers/net/wireless/ath/ath5k/desc.h
@@ -20,25 +20,30 @@
  * RX/TX descriptor structures
  */
 
-/*
- * Common hardware RX control descriptor
+/**
+ * struct ath5k_hw_rx_ctl - Common hardware RX control descriptor
+ * @rx_control_0: RX control word 0
+ * @rx_control_1: RX control word 1
  */
 struct ath5k_hw_rx_ctl {
-	u32	rx_control_0; /* RX control word 0 */
-	u32	rx_control_1; /* RX control word 1 */
+	u32	rx_control_0;
+	u32	rx_control_1;
 } __packed __aligned(4);
 
 /* RX control word 1 fields/flags */
 #define AR5K_DESC_RX_CTL1_BUF_LEN		0x00000fff /* data buffer length */
 #define AR5K_DESC_RX_CTL1_INTREQ		0x00002000 /* RX interrupt request */
 
-/*
- * Common hardware RX status descriptor
+/**
+ * struct ath5k_hw_rx_status - Common hardware RX status descriptor
+ * @rx_status_0: RX status word 0
+ * @rx_status_1: RX status word 1
+ *
  * 5210, 5211 and 5212 differ only in the fields and flags defined below
  */
 struct ath5k_hw_rx_status {
-	u32	rx_status_0; /* RX status word 0 */
-	u32	rx_status_1; /* RX status word 1 */
+	u32	rx_status_0;
+	u32	rx_status_1;
 } __packed __aligned(4);
 
 /* 5210/5211 */
@@ -98,17 +103,36 @@ struct ath5k_hw_rx_status {
 
 /**
  * enum ath5k_phy_error_code - PHY Error codes
+ * @AR5K_RX_PHY_ERROR_UNDERRUN: Transmit underrun, [5210] No error
+ * @AR5K_RX_PHY_ERROR_TIMING: Timing error
+ * @AR5K_RX_PHY_ERROR_PARITY: Illegal parity
+ * @AR5K_RX_PHY_ERROR_RATE: Illegal rate
+ * @AR5K_RX_PHY_ERROR_LENGTH: Illegal length
+ * @AR5K_RX_PHY_ERROR_RADAR: Radar detect, [5210] 64 QAM rate
+ * @AR5K_RX_PHY_ERROR_SERVICE: Illegal service
+ * @AR5K_RX_PHY_ERROR_TOR: Transmit override receive
+ * @AR5K_RX_PHY_ERROR_OFDM_TIMING: OFDM Timing error [5212+]
+ * @AR5K_RX_PHY_ERROR_OFDM_SIGNAL_PARITY: OFDM Signal parity error [5212+]
+ * @AR5K_RX_PHY_ERROR_OFDM_RATE_ILLEGAL: OFDM Illegal rate [5212+]
+ * @AR5K_RX_PHY_ERROR_OFDM_LENGTH_ILLEGAL: OFDM Illegal length [5212+]
+ * @AR5K_RX_PHY_ERROR_OFDM_POWER_DROP: OFDM Power drop [5212+]
+ * @AR5K_RX_PHY_ERROR_OFDM_SERVICE: OFDM Service (?) [5212+]
+ * @AR5K_RX_PHY_ERROR_OFDM_RESTART: OFDM Restart (?) [5212+]
+ * @AR5K_RX_PHY_ERROR_CCK_TIMING: CCK Timing error [5212+]
+ * @AR5K_RX_PHY_ERROR_CCK_HEADER_CRC: Header CRC error [5212+]
+ * @AR5K_RX_PHY_ERROR_CCK_RATE_ILLEGAL: Illegal rate [5212+]
+ * @AR5K_RX_PHY_ERROR_CCK_SERVICE: CCK Service (?) [5212+]
+ * @AR5K_RX_PHY_ERROR_CCK_RESTART: CCK Restart (?) [5212+]
  */
 enum ath5k_phy_error_code {
-	AR5K_RX_PHY_ERROR_UNDERRUN		= 0,	/* Transmit underrun, [5210] No error */
-	AR5K_RX_PHY_ERROR_TIMING		= 1,	/* Timing error */
-	AR5K_RX_PHY_ERROR_PARITY		= 2,	/* Illegal parity */
-	AR5K_RX_PHY_ERROR_RATE			= 3,	/* Illegal rate */
-	AR5K_RX_PHY_ERROR_LENGTH		= 4,	/* Illegal length */
-	AR5K_RX_PHY_ERROR_RADAR			= 5,	/* Radar detect, [5210] 64 QAM rate */
-	AR5K_RX_PHY_ERROR_SERVICE		= 6,	/* Illegal service */
-	AR5K_RX_PHY_ERROR_TOR			= 7,	/* Transmit override receive */
-	/* these are specific to the 5212 */
+	AR5K_RX_PHY_ERROR_UNDERRUN		= 0,
+	AR5K_RX_PHY_ERROR_TIMING		= 1,
+	AR5K_RX_PHY_ERROR_PARITY		= 2,
+	AR5K_RX_PHY_ERROR_RATE			= 3,
+	AR5K_RX_PHY_ERROR_LENGTH		= 4,
+	AR5K_RX_PHY_ERROR_RADAR			= 5,
+	AR5K_RX_PHY_ERROR_SERVICE		= 6,
+	AR5K_RX_PHY_ERROR_TOR			= 7,
 	AR5K_RX_PHY_ERROR_OFDM_TIMING		= 17,
 	AR5K_RX_PHY_ERROR_OFDM_SIGNAL_PARITY	= 18,
 	AR5K_RX_PHY_ERROR_OFDM_RATE_ILLEGAL	= 19,
@@ -123,12 +147,14 @@ enum ath5k_phy_error_code {
 	AR5K_RX_PHY_ERROR_CCK_RESTART		= 31,
 };
 
-/*
- * 5210/5211 hardware 2-word TX control descriptor
+/**
+ * struct ath5k_hw_2w_tx_ctl  - 5210/5211 hardware 2-word TX control descriptor
+ * @tx_control_0: TX control word 0
+ * @tx_control_1: TX control word 1
  */
 struct ath5k_hw_2w_tx_ctl {
-	u32	tx_control_0; /* TX control word 0 */
-	u32	tx_control_1; /* TX control word 1 */
+	u32	tx_control_0;
+	u32	tx_control_1;
 } __packed __aligned(4);
 
 /* TX control word 0 fields/flags */
@@ -177,14 +203,18 @@ struct ath5k_hw_2w_tx_ctl {
 #define AR5K_AR5210_TX_DESC_FRAME_TYPE_PIFS	4
 #define AR5K_AR5211_TX_DESC_FRAME_TYPE_PRESP	4
 
-/*
- * 5212 hardware 4-word TX control descriptor
+/**
+ * struct ath5k_hw_4w_tx_ctl - 5212 hardware 4-word TX control descriptor
+ * @tx_control_0: TX control word 0
+ * @tx_control_1: TX control word 1
+ * @tx_control_2: TX control word 2
+ * @tx_control_3: TX control word 3
  */
 struct ath5k_hw_4w_tx_ctl {
-	u32	tx_control_0; /* TX control word 0 */
-	u32	tx_control_1; /* TX control word 1 */
-	u32	tx_control_2; /* TX control word 2 */
-	u32	tx_control_3; /* TX control word 3 */
+	u32	tx_control_0;
+	u32	tx_control_1;
+	u32	tx_control_2;
+	u32	tx_control_3;
 } __packed __aligned(4);
 
 /* TX control word 0 fields/flags */
@@ -238,12 +268,14 @@ struct ath5k_hw_4w_tx_ctl {
 #define AR5K_4W_TX_DESC_CTL3_RTS_CTS_RATE	0x01f00000 /* RTS or CTS rate */
 #define AR5K_4W_TX_DESC_CTL3_RTS_CTS_RATE_S	20
 
-/*
- * Common TX status descriptor
+/**
+ * struct ath5k_hw_tx_status - Common TX status descriptor
+ * @tx_status_0: TX status word 0
+ * @tx_status_1: TX status word 1
  */
 struct ath5k_hw_tx_status {
-	u32	tx_status_0; /* TX status word 0 */
-	u32	tx_status_1; /* TX status word 1 */
+	u32	tx_status_0;
+	u32	tx_status_1;
 } __packed __aligned(4);
 
 /* TX status word 0 fields/flags */
@@ -276,37 +308,47 @@ struct ath5k_hw_tx_status {
 #define AR5K_DESC_TX_STATUS1_COMP_SUCCESS_5212	0x00800000 /* [5212] compression status */
 #define AR5K_DESC_TX_STATUS1_XMIT_ANTENNA_5212	0x01000000 /* [5212] transmit antenna */
 
-/*
- * 5210/5211 hardware TX descriptor
+/**
+ * struct ath5k_hw_5210_tx_desc - 5210/5211 hardware TX descriptor
+ * @tx_ctl: The &struct ath5k_hw_2w_tx_ctl
+ * @tx_stat: The &struct ath5k_hw_tx_status
  */
 struct ath5k_hw_5210_tx_desc {
 	struct ath5k_hw_2w_tx_ctl	tx_ctl;
 	struct ath5k_hw_tx_status	tx_stat;
 } __packed __aligned(4);
 
-/*
- * 5212 hardware TX descriptor
+/**
+ * struct ath5k_hw_5212_tx_desc - 5212 hardware TX descriptor
+ * @tx_ctl: The &struct ath5k_hw_4w_tx_ctl
+ * @tx_stat: The &struct ath5k_hw_tx_status
  */
 struct ath5k_hw_5212_tx_desc {
 	struct ath5k_hw_4w_tx_ctl	tx_ctl;
 	struct ath5k_hw_tx_status	tx_stat;
 } __packed __aligned(4);
 
-/*
- * Common hardware RX descriptor
+/**
+ * struct ath5k_hw_all_rx_desc - Common hardware RX descriptor
+ * @rx_ctl: The &struct ath5k_hw_rx_ctl
+ * @rx_stat: The &struct ath5k_hw_rx_status
  */
 struct ath5k_hw_all_rx_desc {
 	struct ath5k_hw_rx_ctl		rx_ctl;
 	struct ath5k_hw_rx_status	rx_stat;
 } __packed __aligned(4);
 
-/*
- * Atheros hardware DMA descriptor
+/**
+ * struct ath5k_desc - Atheros hardware DMA descriptor
+ * @ds_link: Physical address of the next descriptor
+ * @ds_data: Physical address of data buffer (skb)
+ * @ud: Union containing hw_5xxx_tx_desc structs and hw_all_rx_desc
+ *
  * This is read and written to by the hardware
  */
 struct ath5k_desc {
-	u32	ds_link;	/* physical address of the next descriptor */
-	u32	ds_data;	/* physical address of data buffer (skb) */
+	u32	ds_link;
+	u32	ds_data;
 
 	union {
 		struct ath5k_hw_5210_tx_desc	ds_tx5210;
diff --git a/drivers/net/wireless/ath/ath5k/dma.c b/drivers/net/wireless/ath/ath5k/dma.c
index 97864d8..5cc9aa8 100644
--- a/drivers/net/wireless/ath/ath5k/dma.c
+++ b/drivers/net/wireless/ath/ath5k/dma.c
@@ -20,16 +20,13 @@
 * DMA and interrupt masking functions *
 \*************************************/
 
-/*
- * dma.c - DMA and interrupt masking functions
+/**
+ * DOC: DMA and interrupt masking functions
  *
  * Here we setup descriptor pointers (rxdp/txdp) start/stop dma engine and
  * handle queue setup for 5210 chipset (rest are handled on qcu.c).
  * Also we setup interrupt mask register (IMR) and read the various interrupt
  * status registers (ISR).
- *
- * TODO: Handle SISR on 5211+ and introduce a function to return the queue
- * number that resulted the interrupt.
  */
 
 #include "ath5k.h"
@@ -42,22 +39,22 @@
 \*********/
 
 /**
- * ath5k_hw_start_rx_dma - Start DMA receive
- *
+ * ath5k_hw_start_rx_dma() - Start DMA receive
  * @ah:	The &struct ath5k_hw
  */
-void ath5k_hw_start_rx_dma(struct ath5k_hw *ah)
+void
+ath5k_hw_start_rx_dma(struct ath5k_hw *ah)
 {
 	ath5k_hw_reg_write(ah, AR5K_CR_RXE, AR5K_CR);
 	ath5k_hw_reg_read(ah, AR5K_CR);
 }
 
 /**
- * ath5k_hw_stop_rx_dma - Stop DMA receive
- *
+ * ath5k_hw_stop_rx_dma() - Stop DMA receive
  * @ah:	The &struct ath5k_hw
  */
-static int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
+static int
+ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
 {
 	unsigned int i;
 
@@ -79,24 +76,24 @@ static int ath5k_hw_stop_rx_dma(struct ath5k_hw *ah)
 }
 
 /**
- * ath5k_hw_get_rxdp - Get RX Descriptor's address
- *
+ * ath5k_hw_get_rxdp() - Get RX Descriptor's address
  * @ah: The &struct ath5k_hw
  */
-u32 ath5k_hw_get_rxdp(struct ath5k_hw *ah)
+u32
+ath5k_hw_get_rxdp(struct ath5k_hw *ah)
 {
 	return ath5k_hw_reg_read(ah, AR5K_RXDP);
 }
 
 /**
- * ath5k_hw_set_rxdp - Set RX Descriptor's address
- *
+ * ath5k_hw_set_rxdp() - Set RX Descriptor's address
  * @ah: The &struct ath5k_hw
  * @phys_addr: RX descriptor address
  *
  * Returns -EIO if rx is active
  */
-int ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr)
+int
+ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr)
 {
 	if (ath5k_hw_reg_read(ah, AR5K_CR) & AR5K_CR_RXE) {
 		ATH5K_DBG(ah, ATH5K_DEBUG_DMA,
@@ -114,8 +111,7 @@ int ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr)
 \**********/
 
 /**
- * ath5k_hw_start_tx_dma - Start DMA transmit for a specific queue
- *
+ * ath5k_hw_start_tx_dma() - Start DMA transmit for a specific queue
  * @ah: The &struct ath5k_hw
  * @queue: The hw queue number
  *
@@ -128,7 +124,8 @@ int ath5k_hw_set_rxdp(struct ath5k_hw *ah, u32 phys_addr)
  * NOTE: Must be called after setting up tx control descriptor for that
  * queue (see below).
  */
-int ath5k_hw_start_tx_dma(struct ath5k_hw *ah, unsigned int queue)
+int
+ath5k_hw_start_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 {
 	u32 tx_queue;
 
@@ -177,17 +174,16 @@ int ath5k_hw_start_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 }
 
 /**
- * ath5k_hw_stop_tx_dma - Stop DMA transmit on a specific queue
- *
+ * ath5k_hw_stop_tx_dma() - Stop DMA transmit on a specific queue
  * @ah: The &struct ath5k_hw
  * @queue: The hw queue number
  *
  * Stop DMA transmit on a specific hw queue and drain queue so we don't
  * have any pending frames. Returns -EBUSY if we still have pending frames,
  * -EINVAL if queue number is out of range or inactive.
- *
  */
-static int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
+static int
+ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 {
 	unsigned int i = 40;
 	u32 tx_queue, pending;
@@ -320,14 +316,14 @@ static int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
 }
 
 /**
- * ath5k_hw_stop_beacon_queue - Stop beacon queue
- *
- * @ah The &struct ath5k_hw
- * @queue The queue number
+ * ath5k_hw_stop_beacon_queue() - Stop beacon queue
+ * @ah: The &struct ath5k_hw
+ * @queue: The queue number
  *
  * Returns -EIO if queue didn't stop
  */
-int ath5k_hw_stop_beacon_queue(struct ath5k_hw *ah, unsigned int queue)
+int
+ath5k_hw_stop_beacon_queue(struct ath5k_hw *ah, unsigned int queue)
 {
 	int ret;
 	ret = ath5k_hw_stop_tx_dma(ah, queue);
@@ -340,8 +336,7 @@ int ath5k_hw_stop_beacon_queue(struct ath5k_hw *ah, unsigned int queue)
 }
 
 /**
- * ath5k_hw_get_txdp - Get TX Descriptor's address for a specific queue
- *
+ * ath5k_hw_get_txdp() - Get TX Descriptor's address for a specific queue
  * @ah: The &struct ath5k_hw
  * @queue: The hw queue number
  *
@@ -352,7 +347,8 @@ int ath5k_hw_stop_beacon_queue(struct ath5k_hw *ah, unsigned int queue)
  *
  * XXX: Is TXDP read and clear ?
  */
-u32 ath5k_hw_get_txdp(struct ath5k_hw *ah, unsigned int queue)
+u32
+ath5k_hw_get_txdp(struct ath5k_hw *ah, unsigned int queue)
 {
 	u16 tx_reg;
 
@@ -382,10 +378,10 @@ u32 ath5k_hw_get_txdp(struct ath5k_hw *ah, unsigned int queue)
 }
 
 /**
- * ath5k_hw_set_txdp - Set TX Descriptor's address for a specific queue
- *
+ * ath5k_hw_set_txdp() - Set TX Descriptor's address for a specific queue
  * @ah: The &struct ath5k_hw
  * @queue: The hw queue number
+ * @phys_addr: The physical address
  *
  * Set TX descriptor's address for a specific queue. For 5210 we ignore
  * the queue number and we use tx queue type since we only have 2 queues
@@ -394,7 +390,8 @@ u32 ath5k_hw_get_txdp(struct ath5k_hw *ah, unsigned int queue)
  * Returns -EINVAL if queue type is invalid for 5210 and -EIO if queue is still
  * active.
  */
-int ath5k_hw_set_txdp(struct ath5k_hw *ah, unsigned int queue, u32 phys_addr)
+int
+ath5k_hw_set_txdp(struct ath5k_hw *ah, unsigned int queue, u32 phys_addr)
 {
 	u16 tx_reg;
 
@@ -435,8 +432,7 @@ int ath5k_hw_set_txdp(struct ath5k_hw *ah, unsigned int queue, u32 phys_addr)
 }
 
 /**
- * ath5k_hw_update_tx_triglevel - Update tx trigger level
- *
+ * ath5k_hw_update_tx_triglevel() - Update tx trigger level
  * @ah: The &struct ath5k_hw
  * @increase: Flag to force increase of trigger level
  *
@@ -444,14 +440,15 @@ int ath5k_hw_set_txdp(struct ath5k_hw *ah, unsigned int queue, u32 phys_addr)
  * buffer (aka FIFO threshold) that is used to indicate when PCU flushes
  * the buffer and transmits its data. Lowering this results sending small
  * frames more quickly but can lead to tx underruns, raising it a lot can
- * result other problems (i think bmiss is related). Right now we start with
- * the lowest possible (64Bytes) and if we get tx underrun we increase it using
- * the increase flag. Returns -EIO if we have reached maximum/minimum.
+ * result other problems. Right now we start with the lowest possible
+ * (64Bytes) and if we get tx underrun we increase it using the increase
+ * flag. Returns -EIO if we have reached maximum/minimum.
  *
  * XXX: Link this with tx DMA size ?
- * XXX: Use it to save interrupts ?
+ * XXX2: Use it to save interrupts ?
  */
-int ath5k_hw_update_tx_triglevel(struct ath5k_hw *ah, bool increase)
+int
+ath5k_hw_update_tx_triglevel(struct ath5k_hw *ah, bool increase)
 {
 	u32 trigger_level, imr;
 	int ret = -EIO;
@@ -497,21 +494,20 @@ done:
 \*******************/
 
 /**
- * ath5k_hw_is_intr_pending - Check if we have pending interrupts
- *
+ * ath5k_hw_is_intr_pending() - Check if we have pending interrupts
  * @ah: The &struct ath5k_hw
  *
  * Check if we have pending interrupts to process. Returns 1 if we
  * have pending interrupts and 0 if we haven't.
  */
-bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah)
+bool
+ath5k_hw_is_intr_pending(struct ath5k_hw *ah)
 {
 	return ath5k_hw_reg_read(ah, AR5K_INTPEND) == 1 ? 1 : 0;
 }
 
 /**
- * ath5k_hw_get_isr - Get interrupt status
- *
+ * ath5k_hw_get_isr() - Get interrupt status
  * @ah: The @struct ath5k_hw
  * @interrupt_mask: Driver's interrupt mask used to filter out
  * interrupts in sw.
@@ -525,7 +521,8 @@ bool ath5k_hw_is_intr_pending(struct ath5k_hw *ah)
  * NOTE: We do write-to-clear, so the active PISR/SISR bits at the time this
  * function gets called are cleared on return.
  */
-int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
+int
+ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 {
 	u32 data = 0;
 
@@ -696,15 +693,10 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 		if (unlikely(pisr & (AR5K_ISR_HIUERR)))
 			*interrupt_mask |= AR5K_INT_FATAL;
 
-
 		/*Beacon Not Ready*/
 		if (unlikely(pisr & (AR5K_ISR_BNR)))
 			*interrupt_mask |= AR5K_INT_BNR;
 
-		/* Doppler chirp received */
-		if (unlikely(pisr & (AR5K_ISR_RXDOPPLER)))
-			*interrupt_mask |= AR5K_INT_RX_DOPPLER;
-
 		/* A queue got CBR overrun */
 		if (unlikely(pisr & (AR5K_ISR_QCBRORN))) {
 			*interrupt_mask |= AR5K_INT_QCBRORN;
@@ -740,8 +732,7 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
 }
 
 /**
- * ath5k_hw_set_imr - Set interrupt mask
- *
+ * ath5k_hw_set_imr() - Set interrupt mask
  * @ah: The &struct ath5k_hw
  * @new_mask: The new interrupt mask to be set
  *
@@ -749,7 +740,8 @@ int ath5k_hw_get_isr(struct ath5k_hw *ah, enum ath5k_int *interrupt_mask)
  * ath5k_int bits to hw-specific bits to remove abstraction and writing
  * Interrupt Mask Register.
  */
-enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask)
+enum ath5k_int
+ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask)
 {
 	enum ath5k_int old_mask, int_mask;
 
@@ -802,10 +794,6 @@ enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask)
 		if (new_mask & AR5K_INT_BNR)
 			int_mask |= AR5K_INT_BNR;
 
-		/* RX doppler chirp */
-		if (new_mask & AR5K_INT_RX_DOPPLER)
-			int_mask |= AR5K_IMR_RXDOPPLER;
-
 		/* Note: Per queue interrupt masks
 		 * are set via ath5k_hw_reset_tx_queue() (qcu.c) */
 		ath5k_hw_reg_write(ah, int_mask, AR5K_PIMR);
@@ -844,8 +832,7 @@ enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask)
 \********************/
 
 /**
- * ath5k_hw_dma_init - Initialize DMA unit
- *
+ * ath5k_hw_dma_init() - Initialize DMA unit
  * @ah: The &struct ath5k_hw
  *
  * Set DMA size and pre-enable interrupts
@@ -854,7 +841,8 @@ enum ath5k_int ath5k_hw_set_imr(struct ath5k_hw *ah, enum ath5k_int new_mask)
  *
  * XXX: Save/restore RXDP/TXDP registers ?
  */
-void ath5k_hw_dma_init(struct ath5k_hw *ah)
+void
+ath5k_hw_dma_init(struct ath5k_hw *ah)
 {
 	/*
 	 * Set Rx/Tx DMA Configuration
@@ -883,8 +871,7 @@ void ath5k_hw_dma_init(struct ath5k_hw *ah)
 }
 
 /**
- * ath5k_hw_dma_stop - stop DMA unit
- *
+ * ath5k_hw_dma_stop() - stop DMA unit
  * @ah: The &struct ath5k_hw
  *
  * Stop tx/rx DMA and interrupts. Returns
@@ -894,7 +881,8 @@ void ath5k_hw_dma_init(struct ath5k_hw *ah)
  * stuck frames on tx queues, only a reset
  * can fix that.
  */
-int ath5k_hw_dma_stop(struct ath5k_hw *ah)
+int
+ath5k_hw_dma_stop(struct ath5k_hw *ah)
 {
 	int i, qmax, err;
 	err = 0;
diff --git a/drivers/net/wireless/ath/ath5k/gpio.c b/drivers/net/wireless/ath/ath5k/gpio.c
index 8592978..73d3dd8 100644
--- a/drivers/net/wireless/ath/ath5k/gpio.c
+++ b/drivers/net/wireless/ath/ath5k/gpio.c
@@ -24,10 +24,33 @@
 #include "reg.h"
 #include "debug.h"
 
-/*
- * Set led state
+
+/**
+ * DOC: GPIO/LED functions
+ *
+ * Here we control the 6 bidirectional GPIO pins provided by the hw.
+ * We can set a GPIO pin to be an input or an output pin on GPIO control
+ * register and then read or set its status from GPIO data input/output
+ * registers.
+ *
+ * We also control the two LED pins provided by the hw, LED_0 is our
+ * "power" LED and LED_1 is our "network activity" LED but many scenarios
+ * are available from hw. Vendors might also provide LEDs connected to the
+ * GPIO pins, we handle them through the LED subsystem on led.c
+ */
+
+
+/**
+ * ath5k_hw_set_ledstate() - Set led state
+ * @ah: The &struct ath5k_hw
+ * @state: One of AR5K_LED_*
+ *
+ * Used to set the LED blinking state. This only
+ * works for the LED connected to the LED_0, LED_1 pins,
+ * not the GPIO based.
  */
-void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state)
+void
+ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state)
 {
 	u32 led;
 	/*5210 has different led mode handling*/
@@ -74,10 +97,13 @@ void ath5k_hw_set_ledstate(struct ath5k_hw *ah, unsigned int state)
 		AR5K_REG_ENABLE_BITS(ah, AR5K_PCICFG, led_5210);
 }
 
-/*
- * Set GPIO inputs
+/**
+ * ath5k_hw_set_gpio_input() - Set GPIO inputs
+ * @ah: The &struct ath5k_hw
+ * @gpio: GPIO pin to set as input
  */
-int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio)
+int
+ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio)
 {
 	if (gpio >= AR5K_NUM_GPIO)
 		return -EINVAL;
@@ -89,10 +115,13 @@ int ath5k_hw_set_gpio_input(struct ath5k_hw *ah, u32 gpio)
 	return 0;
 }
 
-/*
- * Set GPIO outputs
+/**
+ * ath5k_hw_set_gpio_output() - Set GPIO outputs
+ * @ah: The &struct ath5k_hw
+ * @gpio: The GPIO pin to set as output
  */
-int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio)
+int
+ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio)
 {
 	if (gpio >= AR5K_NUM_GPIO)
 		return -EINVAL;
@@ -104,10 +133,13 @@ int ath5k_hw_set_gpio_output(struct ath5k_hw *ah, u32 gpio)
 	return 0;
 }
 
-/*
- * Get GPIO state
+/**
+ * ath5k_hw_get_gpio() - Get GPIO state
+ * @ah: The &struct ath5k_hw
+ * @gpio: The GPIO pin to read
  */
-u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio)
+u32
+ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio)
 {
 	if (gpio >= AR5K_NUM_GPIO)
 		return 0xffffffff;
@@ -117,10 +149,14 @@ u32 ath5k_hw_get_gpio(struct ath5k_hw *ah, u32 gpio)
 		0x1;
 }
 
-/*
- * Set GPIO state
+/**
+ * ath5k_hw_set_gpio() - Set GPIO state
+ * @ah: The &struct ath5k_hw
+ * @gpio: The GPIO pin to set
+ * @val: Value to set (boolean)
  */
-int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val)
+int
+ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val)
 {
 	u32 data;
 
@@ -138,10 +174,19 @@ int ath5k_hw_set_gpio(struct ath5k_hw *ah, u32 gpio, u32 val)
 	return 0;
 }
 
-/*
- * Initialize the GPIO interrupt (RFKill switch)
+/**
+ * ath5k_hw_set_gpio_intr() - Initialize the GPIO interrupt (RFKill switch)
+ * @ah: The &struct ath5k_hw
+ * @gpio: The GPIO pin to use
+ * @interrupt_level: True to generate interrupt on active pin (high)
+ *
+ * This function is used to set up the GPIO interrupt for the hw RFKill switch.
+ * That switch is connected to a GPIO pin and it's number is stored on EEPROM.
+ * It can either open or close the circuit to indicate that we should disable
+ * RF/Wireless to save power (we also get that from EEPROM).
  */
-void ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio,
+void
+ath5k_hw_set_gpio_intr(struct ath5k_hw *ah, unsigned int gpio,
 		u32 interrupt_level)
 {
 	u32 data;
diff --git a/drivers/net/wireless/ath/ath5k/initvals.c b/drivers/net/wireless/ath/ath5k/initvals.c
index 1ffecc0..a1ea78e 100644
--- a/drivers/net/wireless/ath/ath5k/initvals.c
+++ b/drivers/net/wireless/ath/ath5k/initvals.c
@@ -23,24 +23,27 @@
 #include "reg.h"
 #include "debug.h"
 
-/*
- * Mode-independent initial register writes
+/**
+ * struct ath5k_ini - Mode-independent initial register writes
+ * @ini_register: Register address
+ * @ini_value: Default value
+ * @ini_mode: 0 to write 1 to read (and clear)
  */
-
 struct ath5k_ini {
 	u16	ini_register;
 	u32	ini_value;
 
 	enum {
 		AR5K_INI_WRITE = 0,	/* Default */
-		AR5K_INI_READ = 1,	/* Cleared on read */
+		AR5K_INI_READ = 1,
 	} ini_mode;
 };
 
-/*
- * Mode specific initial register values
+/**
+ * struct ath5k_ini_mode - Mode specific initial register values
+ * @mode_register: Register address
+ * @mode_value: Set of values for each enum ath5k_driver_mode
  */
-
 struct ath5k_ini_mode {
 	u16	mode_register;
 	u32	mode_value[3];
@@ -386,11 +389,10 @@ static const struct ath5k_ini ar5211_ini[] = {
 
 /* Initial mode-specific settings for AR5211
  * 5211 supports OFDM-only g (draft g) but we
- * need to test it !
- */
+ * need to test it ! */
 static const struct ath5k_ini_mode ar5211_ini_mode[] = {
 	{ AR5K_TXCFG,
-	/*	A/XR          B           G       */
+	/*	A          B           G       */
 	   { 0x00000015, 0x0000001d, 0x00000015 } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(0),
 	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
@@ -460,7 +462,7 @@ static const struct ath5k_ini_mode ar5211_ini_mode[] = {
 	   { 0x00000010, 0x00000010, 0x00000010 } },
 };
 
-/* Initial register settings for AR5212 */
+/* Initial register settings for AR5212 and newer chips */
 static const struct ath5k_ini ar5212_ini_common_start[] = {
 	{ AR5K_RXDP,		0x00000000 },
 	{ AR5K_RXCFG,		0x00000005 },
@@ -724,7 +726,8 @@ static const struct ath5k_ini_mode ar5212_ini_mode_start[] = {
 	   { 0x00000000, 0x00000000, 0x00000108 } },
 };
 
-/* Initial mode-specific settings for AR5212 + RF5111 (Written after ar5212_ini) */
+/* Initial mode-specific settings for AR5212 + RF5111
+ * (Written after ar5212_ini) */
 static const struct ath5k_ini_mode rf5111_ini_mode_end[] = {
 	{ AR5K_TXCFG,
 	/*	A/XR          B           G       */
@@ -757,6 +760,7 @@ static const struct ath5k_ini_mode rf5111_ini_mode_end[] = {
 	   { 0x1883800a, 0x1873800a, 0x1883800a } },
 };
 
+/* Common for all modes */
 static const struct ath5k_ini rf5111_ini_common_end[] = {
 	{ AR5K_DCU_FP,		0x00000000 },
 	{ AR5K_PHY_AGC,		0x00000000 },
@@ -774,7 +778,9 @@ static const struct ath5k_ini rf5111_ini_common_end[] = {
 	{ 0xa23c,		0x13c889af },
 };
 
-/* Initial mode-specific settings for AR5212 + RF5112 (Written after ar5212_ini) */
+
+/* Initial mode-specific settings for AR5212 + RF5112
+ * (Written after ar5212_ini) */
 static const struct ath5k_ini_mode rf5112_ini_mode_end[] = {
 	{ AR5K_TXCFG,
 	/*	A/XR          B           G       */
@@ -825,7 +831,9 @@ static const struct ath5k_ini rf5112_ini_common_end[] = {
 	{ 0xa23c,		0x13c889af },
 };
 
-/* Initial mode-specific settings for RF5413/5414 (Written after ar5212_ini) */
+
+/* Initial mode-specific settings for RF5413/5414
+ * (Written after ar5212_ini) */
 static const struct ath5k_ini_mode rf5413_ini_mode_end[] = {
 	{ AR5K_TXCFG,
 	/*	A/XR          B           G       */
@@ -963,7 +971,8 @@ static const struct ath5k_ini rf5413_ini_common_end[] = {
 	{ 0xa384, 0xf3307ff0 },
 };
 
-/* Initial mode-specific settings for RF2413/2414 (Written after ar5212_ini) */
+/* Initial mode-specific settings for RF2413/2414
+ * (Written after ar5212_ini) */
 /* XXX: a mode ? */
 static const struct ath5k_ini_mode rf2413_ini_mode_end[] = {
 	{ AR5K_TXCFG,
@@ -1085,7 +1094,8 @@ static const struct ath5k_ini rf2413_ini_common_end[] = {
 	{ 0xa384, 0xf3307ff0 },
 };
 
-/* Initial mode-specific settings for RF2425 (Written after ar5212_ini) */
+/* Initial mode-specific settings for RF2425
+ * (Written after ar5212_ini) */
 /* XXX: a mode ? */
 static const struct ath5k_ini_mode rf2425_ini_mode_end[] = {
 	{ AR5K_TXCFG,
@@ -1357,10 +1367,15 @@ static const struct ath5k_ini rf5112_ini_bbgain[] = {
 };
 
 
-/*
- * Write initial register dump
+/**
+ * ath5k_hw_ini_registers() - Write initial register dump common for all modes
+ * @ah: The &struct ath5k_hw
+ * @size: Dump size
+ * @ini_regs: The array of &struct ath5k_ini
+ * @skip_pcu: Skip PCU registers
  */
-static void ath5k_hw_ini_registers(struct ath5k_hw *ah, unsigned int size,
+static void
+ath5k_hw_ini_registers(struct ath5k_hw *ah, unsigned int size,
 		const struct ath5k_ini *ini_regs, bool skip_pcu)
 {
 	unsigned int i;
@@ -1388,7 +1403,15 @@ static void ath5k_hw_ini_registers(struct ath5k_hw *ah, unsigned int size,
 	}
 }
 
-static void ath5k_hw_ini_mode_registers(struct ath5k_hw *ah,
+/**
+ * ath5k_hw_ini_mode_registers() - Write initial mode-specific register dump
+ * @ah: The &struct ath5k_hw
+ * @size: Dump size
+ * @ini_mode: The array of &struct ath5k_ini_mode
+ * @mode: One of enum ath5k_driver_mode
+ */
+static void
+ath5k_hw_ini_mode_registers(struct ath5k_hw *ah,
 		unsigned int size, const struct ath5k_ini_mode *ini_mode,
 		u8 mode)
 {
@@ -1402,7 +1425,17 @@ static void ath5k_hw_ini_mode_registers(struct ath5k_hw *ah,
 
 }
 
-int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool skip_pcu)
+/**
+ * ath5k_hw_write_initvals() - Write initial chip-specific register dump
+ * @ah: The &struct ath5k_hw
+ * @mode: One of enum ath5k_driver_mode
+ * @skip_pcu: Skip PCU registers
+ *
+ * Write initial chip-specific register dump, to get the chipset on a
+ * clean and ready-to-work state after warm reset.
+ */
+int
+ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool skip_pcu)
 {
 	/*
 	 * Write initial register settings
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index a7eafa3..cebfd6f 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -30,11 +30,47 @@
 #include "reg.h"
 #include "debug.h"
 
-/*
+/**
+ * DOC: Protocol Control Unit (PCU) functions
+ *
+ * Protocol control unit is responsible to maintain various protocol
+ * properties before a frame is send and after a frame is received to/from
+ * baseband. To be more specific, PCU handles:
+ *
+ * - Buffering of RX and TX frames (after QCU/DCUs)
+ *
+ * - Encrypting and decrypting (using the built-in engine)
+ *
+ * - Generating ACKs, RTS/CTS frames
+ *
+ * - Maintaining TSF
+ *
+ * - FCS
+ *
+ * - Updating beacon data (with TSF etc)
+ *
+ * - Generating virtual CCA
+ *
+ * - RX/Multicast filtering
+ *
+ * - BSSID filtering
+ *
+ * - Various statistics
+ *
+ * -Different operating modes: AP, STA, IBSS
+ *
+ * Note: Most of these functions can be tweaked/bypassed so you can do
+ * them on sw above for debugging or research. For more infos check out PCU
+ * registers on reg.h.
+ */
+
+/**
+ * DOC: ACK rates
+ *
  * AR5212+ can use higher rates for ack transmission
  * based on current tx rate instead of the base rate.
  * It does this to better utilize channel usage.
- * This is a mapping between G rates (that cover both
+ * There is a mapping between G rates (that cover both
  * CCK and OFDM) and ack rates that we use when setting
  * rate -> duration table. This mapping is hw-based so
  * don't change anything.
@@ -63,17 +99,18 @@ static const unsigned int ack_rates_high[] =
 \*******************/
 
 /**
- * ath5k_hw_get_frame_duration - Get tx time of a frame
- *
+ * ath5k_hw_get_frame_duration() - Get tx time of a frame
  * @ah: The &struct ath5k_hw
  * @len: Frame's length in bytes
  * @rate: The @struct ieee80211_rate
+ * @shortpre: Indicate short preample
  *
  * Calculate tx duration of a frame given it's rate and length
  * It extends ieee80211_generic_frame_duration for non standard
  * bwmodes.
  */
-int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
+int
+ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
 		int len, struct ieee80211_rate *rate, bool shortpre)
 {
 	int sifs, preamble, plcp_bits, sym_time;
@@ -129,11 +166,11 @@ int ath5k_hw_get_frame_duration(struct ath5k_hw *ah,
 }
 
 /**
- * ath5k_hw_get_default_slottime - Get the default slot time for current mode
- *
+ * ath5k_hw_get_default_slottime() - Get the default slot time for current mode
  * @ah: The &struct ath5k_hw
  */
-unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
+unsigned int
+ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
 	unsigned int slot_time;
@@ -160,11 +197,11 @@ unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
 }
 
 /**
- * ath5k_hw_get_default_sifs - Get the default SIFS for current mode
- *
+ * ath5k_hw_get_default_sifs() - Get the default SIFS for current mode
  * @ah: The &struct ath5k_hw
  */
-unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
+unsigned int
+ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
 	unsigned int sifs;
@@ -191,17 +228,17 @@ unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
 }
 
 /**
- * ath5k_hw_update_mib_counters - Update MIB counters (mac layer statistics)
- *
+ * ath5k_hw_update_mib_counters() - Update MIB counters (mac layer statistics)
  * @ah: The &struct ath5k_hw
  *
  * Reads MIB counters from PCU and updates sw statistics. Is called after a
  * MIB interrupt, because one of these counters might have reached their maximum
  * and triggered the MIB interrupt, to let us read and clear the counter.
  *
- * Is called in interrupt context!
+ * NOTE: Is called in interrupt context!
  */
-void ath5k_hw_update_mib_counters(struct ath5k_hw *ah)
+void
+ath5k_hw_update_mib_counters(struct ath5k_hw *ah)
 {
 	struct ath5k_statistics *stats = &ah->stats;
 
@@ -219,10 +256,8 @@ void ath5k_hw_update_mib_counters(struct ath5k_hw *ah)
 \******************/
 
 /**
- * ath5k_hw_write_rate_duration - fill rate code to duration table
- *
- * @ah: the &struct ath5k_hw
- * @mode: one of enum ath5k_driver_mode
+ * ath5k_hw_write_rate_duration() - Fill rate code to duration table
+ * @ah: The &struct ath5k_hw
  *
  * Write the rate code to duration table upon hw reset. This is a helper for
  * ath5k_hw_pcu_init(). It seems all this is doing is setting an ACK timeout on
@@ -236,7 +271,8 @@ void ath5k_hw_update_mib_counters(struct ath5k_hw *ah)
  * that include all OFDM and CCK rates.
  *
  */
-static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah)
+static inline void
+ath5k_hw_write_rate_duration(struct ath5k_hw *ah)
 {
 	struct ieee80211_rate *rate;
 	unsigned int i;
@@ -280,12 +316,12 @@ static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah)
 }
 
 /**
- * ath5k_hw_set_ack_timeout - Set ACK timeout on PCU
- *
+ * ath5k_hw_set_ack_timeout() - Set ACK timeout on PCU
  * @ah: The &struct ath5k_hw
  * @timeout: Timeout in usec
  */
-static int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
+static int
+ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
 {
 	if (ath5k_hw_clocktoh(ah, AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_ACK))
 			<= timeout)
@@ -298,12 +334,12 @@ static int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
 }
 
 /**
- * ath5k_hw_set_cts_timeout - Set CTS timeout on PCU
- *
+ * ath5k_hw_set_cts_timeout() - Set CTS timeout on PCU
  * @ah: The &struct ath5k_hw
  * @timeout: Timeout in usec
  */
-static int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
+static int
+ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
 {
 	if (ath5k_hw_clocktoh(ah, AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_CTS))
 			<= timeout)
@@ -321,14 +357,14 @@ static int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
 \*******************/
 
 /**
- * ath5k_hw_set_lladdr - Set station id
- *
+ * ath5k_hw_set_lladdr() - Set station id
  * @ah: The &struct ath5k_hw
- * @mac: The card's mac address
+ * @mac: The card's mac address (array of octets)
  *
  * Set station id on hw using the provided mac address
  */
-int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
+int
+ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
 	u32 low_id, high_id;
@@ -349,14 +385,14 @@ int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
 }
 
 /**
- * ath5k_hw_set_bssid - Set current BSSID on hw
- *
+ * ath5k_hw_set_bssid() - Set current BSSID on hw
  * @ah: The &struct ath5k_hw
  *
  * Sets the current BSSID and BSSID mask we have from the
  * common struct into the hardware
  */
-void ath5k_hw_set_bssid(struct ath5k_hw *ah)
+void
+ath5k_hw_set_bssid(struct ath5k_hw *ah)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
 	u16 tim_offset = 0;
@@ -389,7 +425,23 @@ void ath5k_hw_set_bssid(struct ath5k_hw *ah)
 	ath5k_hw_enable_pspoll(ah, NULL, 0);
 }
 
-void ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
+/**
+ * ath5k_hw_set_bssid_mask() - Filter out bssids we listen
+ * @ah: The &struct ath5k_hw
+ * @mask: The BSSID mask to set (array of octets)
+ *
+ * BSSID masking is a method used by AR5212 and newer hardware to inform PCU
+ * which bits of the interface's MAC address should be looked at when trying
+ * to decide which packets to ACK. In station mode and AP mode with a single
+ * BSS every bit matters since we lock to only one BSS. In AP mode with
+ * multiple BSSes (virtual interfaces) not every bit matters because hw must
+ * accept frames for all BSSes and so we tweak some bits of our mac address
+ * in order to have multiple BSSes.
+ *
+ * For more information check out ../hw.c of the common ath module.
+ */
+void
+ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
 
@@ -400,18 +452,21 @@ void ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
 		ath_hw_setbssidmask(common);
 }
 
-/*
- * Set multicast filter
+/**
+ * ath5k_hw_set_mcast_filter() - Set multicast filter
+ * @ah: The &struct ath5k_hw
+ * @filter0: Lower 32bits of muticast filter
+ * @filter1: Higher 16bits of multicast filter
  */
-void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1)
+void
+ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1)
 {
 	ath5k_hw_reg_write(ah, filter0, AR5K_MCAST_FILTER0);
 	ath5k_hw_reg_write(ah, filter1, AR5K_MCAST_FILTER1);
 }
 
 /**
- * ath5k_hw_get_rx_filter - Get current rx filter
- *
+ * ath5k_hw_get_rx_filter() - Get current rx filter
  * @ah: The &struct ath5k_hw
  *
  * Returns the RX filter by reading rx filter and
@@ -420,7 +475,8 @@ void ath5k_hw_set_mcast_filter(struct ath5k_hw *ah, u32 filter0, u32 filter1)
  * and pass to the driver. For a list of frame types
  * check out reg.h.
  */
-u32 ath5k_hw_get_rx_filter(struct ath5k_hw *ah)
+u32
+ath5k_hw_get_rx_filter(struct ath5k_hw *ah)
 {
 	u32 data, filter = 0;
 
@@ -440,8 +496,7 @@ u32 ath5k_hw_get_rx_filter(struct ath5k_hw *ah)
 }
 
 /**
- * ath5k_hw_set_rx_filter - Set rx filter
- *
+ * ath5k_hw_set_rx_filter() - Set rx filter
  * @ah: The &struct ath5k_hw
  * @filter: RX filter mask (see reg.h)
  *
@@ -449,7 +504,8 @@ u32 ath5k_hw_get_rx_filter(struct ath5k_hw *ah)
  * register on 5212 and newer chips so that we have proper PHY
  * error reporting.
  */
-void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter)
+void
+ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter)
 {
 	u32 data = 0;
 
@@ -493,13 +549,13 @@ void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter)
 #define ATH5K_MAX_TSF_READ 10
 
 /**
- * ath5k_hw_get_tsf64 - Get the full 64bit TSF
- *
+ * ath5k_hw_get_tsf64() - Get the full 64bit TSF
  * @ah: The &struct ath5k_hw
  *
  * Returns the current TSF
  */
-u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
+u64
+ath5k_hw_get_tsf64(struct ath5k_hw *ah)
 {
 	u32 tsf_lower, tsf_upper1, tsf_upper2;
 	int i;
@@ -536,28 +592,30 @@ u64 ath5k_hw_get_tsf64(struct ath5k_hw *ah)
 	return ((u64)tsf_upper1 << 32) | tsf_lower;
 }
 
+#undef ATH5K_MAX_TSF_READ
+
 /**
- * ath5k_hw_set_tsf64 - Set a new 64bit TSF
- *
+ * ath5k_hw_set_tsf64() - Set a new 64bit TSF
  * @ah: The &struct ath5k_hw
  * @tsf64: The new 64bit TSF
  *
  * Sets the new TSF
  */
-void ath5k_hw_set_tsf64(struct ath5k_hw *ah, u64 tsf64)
+void
+ath5k_hw_set_tsf64(struct ath5k_hw *ah, u64 tsf64)
 {
 	ath5k_hw_reg_write(ah, tsf64 & 0xffffffff, AR5K_TSF_L32);
 	ath5k_hw_reg_write(ah, (tsf64 >> 32) & 0xffffffff, AR5K_TSF_U32);
 }
 
 /**
- * ath5k_hw_reset_tsf - Force a TSF reset
- *
+ * ath5k_hw_reset_tsf() - Force a TSF reset
  * @ah: The &struct ath5k_hw
  *
  * Forces a TSF reset on PCU
  */
-void ath5k_hw_reset_tsf(struct ath5k_hw *ah)
+void
+ath5k_hw_reset_tsf(struct ath5k_hw *ah)
 {
 	u32 val;
 
@@ -573,10 +631,17 @@ void ath5k_hw_reset_tsf(struct ath5k_hw *ah)
 	ath5k_hw_reg_write(ah, val, AR5K_BEACON);
 }
 
-/*
- * Initialize beacon timers
+/**
+ * ath5k_hw_init_beacon_timers() - Initialize beacon timers
+ * @ah: The &struct ath5k_hw
+ * @next_beacon: Next TBTT
+ * @interval: Current beacon interval
+ *
+ * This function is used to initialize beacon timers based on current
+ * operation mode and settings.
  */
-void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
+void
+ath5k_hw_init_beacon_timers(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 {
 	u32 timer1, timer2, timer3;
 
@@ -655,8 +720,7 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 }
 
 /**
- * ath5k_check_timer_win - Check if timer B is timer A + window
- *
+ * ath5k_check_timer_win() - Check if timer B is timer A + window
  * @a: timer a (before b)
  * @b: timer b (after a)
  * @window: difference between a and b
@@ -686,12 +750,11 @@ ath5k_check_timer_win(int a, int b, int window, int intval)
 }
 
 /**
- * ath5k_hw_check_beacon_timers - Check if the beacon timers are correct
- *
+ * ath5k_hw_check_beacon_timers() - Check if the beacon timers are correct
  * @ah: The &struct ath5k_hw
  * @intval: beacon interval
  *
- * This is a workaround for IBSS mode:
+ * This is a workaround for IBSS mode
  *
  * The need for this function arises from the fact that we have 4 separate
  * HW timer registers (TIMER0 - TIMER3), which are closely related to the
@@ -746,14 +809,14 @@ ath5k_hw_check_beacon_timers(struct ath5k_hw *ah, int intval)
 }
 
 /**
- * ath5k_hw_set_coverage_class - Set IEEE 802.11 coverage class
- *
+ * ath5k_hw_set_coverage_class() - Set IEEE 802.11 coverage class
  * @ah: The &struct ath5k_hw
  * @coverage_class: IEEE 802.11 coverage class number
  *
  * Sets IFS intervals and ACK/CTS timeouts for given coverage class.
  */
-void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class)
+void
+ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class)
 {
 	/* As defined by IEEE 802.11-2007 17.3.8.6 */
 	int slot_time = ath5k_hw_get_default_slottime(ah) + 3 * coverage_class;
@@ -772,8 +835,7 @@ void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class)
 \***************************/
 
 /**
- * ath5k_hw_start_rx_pcu - Start RX engine
- *
+ * ath5k_hw_start_rx_pcu() - Start RX engine
  * @ah: The &struct ath5k_hw
  *
  * Starts RX engine on PCU so that hw can process RXed frames
@@ -781,32 +843,33 @@ void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class)
  *
  * NOTE: RX DMA should be already enabled using ath5k_hw_start_rx_dma
  */
-void ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
+void
+ath5k_hw_start_rx_pcu(struct ath5k_hw *ah)
 {
 	AR5K_REG_DISABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
 }
 
 /**
- * at5k_hw_stop_rx_pcu - Stop RX engine
- *
+ * at5k_hw_stop_rx_pcu() - Stop RX engine
  * @ah: The &struct ath5k_hw
  *
  * Stops RX engine on PCU
  */
-void ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah)
+void
+ath5k_hw_stop_rx_pcu(struct ath5k_hw *ah)
 {
 	AR5K_REG_ENABLE_BITS(ah, AR5K_DIAG_SW, AR5K_DIAG_SW_DIS_RX);
 }
 
 /**
- * ath5k_hw_set_opmode - Set PCU operating mode
- *
+ * ath5k_hw_set_opmode() - Set PCU operating mode
  * @ah: The &struct ath5k_hw
- * @op_mode: &enum nl80211_iftype operating mode
+ * @op_mode: One of enum nl80211_iftype
  *
  * Configure PCU for the various operating modes (AP/STA etc)
  */
-int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
+int
+ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
 	u32 pcu_reg, beacon_reg, low_id, high_id;
@@ -873,8 +936,17 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
 	return 0;
 }
 
-void ath5k_hw_pcu_init(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
-								u8 mode)
+/**
+ * ath5k_hw_pcu_init() - Initialize PCU
+ * @ah: The &struct ath5k_hw
+ * @op_mode: One of enum nl80211_iftype
+ * @mode: One of enum ath5k_driver_mode
+ *
+ * This function is used to initialize PCU by setting current
+ * operation mode and various other settings.
+ */
+void
+ath5k_hw_pcu_init(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
 {
 	/* Set bssid and bssid mask */
 	ath5k_hw_set_bssid(ah);
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index bf097b1..a635441 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1,6 +1,4 @@
 /*
- * PHY functions
- *
  * Copyright (c) 2004-2007 Reyk Floeter <reyk@openbsd.org>
  * Copyright (c) 2006-2009 Nick Kossifidis <mickflemm@gmail.com>
  * Copyright (c) 2007-2008 Jiri Slaby <jirislaby@gmail.com>
@@ -20,6 +18,10 @@
  *
  */
 
+/***********************\
+* PHY related functions *
+\***********************/
+
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <asm/unaligned.h>
@@ -31,14 +33,53 @@
 #include "../regd.h"
 
 
+/**
+ * DOC: PHY related functions
+ *
+ * Here we handle the low-level functions related to baseband
+ * and analog frontend (RF) parts. This is by far the most complex
+ * part of the hw code so make sure you know what you are doing.
+ *
+ * Here is a list of what this is all about:
+ *
+ * - Channel setting/switching
+ *
+ * - Automatic Gain Control (AGC) calibration
+ *
+ * - Noise Floor calibration
+ *
+ * - I/Q imbalance calibration (QAM correction)
+ *
+ * - Calibration due to thermal changes (gain_F)
+ *
+ * - Spur noise mitigation
+ *
+ * - RF/PHY initialization for the various operating modes and bwmodes
+ *
+ * - Antenna control
+ *
+ * - TX power control per channel/rate/packet type
+ *
+ * Also have in mind we never got documentation for most of these
+ * functions, what we have comes mostly from Atheros's code, reverse
+ * engineering and patent docs/presentations etc.
+ */
+
+
 /******************\
 * Helper functions *
 \******************/
 
-/*
- * Get the PHY Chip revision
+/**
+ * ath5k_hw_radio_revision() - Get the PHY Chip revision
+ * @ah: The &struct ath5k_hw
+ * @band: One of enum ieee80211_band
+ *
+ * Returns the revision number of a 2GHz, 5GHz or single chip
+ * radio.
  */
-u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, enum ieee80211_band band)
+u16
+ath5k_hw_radio_revision(struct ath5k_hw *ah, enum ieee80211_band band)
 {
 	unsigned int i;
 	u32 srev;
@@ -81,10 +122,16 @@ u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, enum ieee80211_band band)
 	return ret;
 }
 
-/*
- * Check if a channel is supported
+/**
+ * ath5k_channel_ok() - Check if a channel is supported by the hw
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ *
+ * Note: We don't do any regulatory domain checks here, it's just
+ * a sanity check.
  */
-bool ath5k_channel_ok(struct ath5k_hw *ah, struct ieee80211_channel *channel)
+bool
+ath5k_channel_ok(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 {
 	u16 freq = channel->center_freq;
 
@@ -101,7 +148,13 @@ bool ath5k_channel_ok(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 	return false;
 }
 
-bool ath5k_hw_chan_has_spur_noise(struct ath5k_hw *ah,
+/**
+ * ath5k_hw_chan_has_spur_noise() - Check if channel is sensitive to spur noise
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ */
+bool
+ath5k_hw_chan_has_spur_noise(struct ath5k_hw *ah,
 				struct ieee80211_channel *channel)
 {
 	u8 refclk_freq;
@@ -122,11 +175,20 @@ bool ath5k_hw_chan_has_spur_noise(struct ath5k_hw *ah,
 		return false;
 }
 
-/*
- * Used to modify RF Banks before writing them to AR5K_RF_BUFFER
+/**
+ * ath5k_hw_rfb_op() - Perform an operation on the given RF Buffer
+ * @ah: The &struct ath5k_hw
+ * @rf_regs: The struct ath5k_rf_reg
+ * @val: New value
+ * @reg_id: RF register ID
+ * @set: Indicate we need to swap data
+ *
+ * This is an internal function used to modify RF Banks before
+ * writing them to AR5K_RF_BUFFER. Check out rfbuffer.h for more
+ * infos.
  */
-static unsigned int ath5k_hw_rfb_op(struct ath5k_hw *ah,
-					const struct ath5k_rf_reg *rf_regs,
+static unsigned int
+ath5k_hw_rfb_op(struct ath5k_hw *ah, const struct ath5k_rf_reg *rf_regs,
 					u32 val, u8 reg_id, bool set)
 {
 	const struct ath5k_rf_reg *rfreg = NULL;
@@ -204,8 +266,7 @@ static unsigned int ath5k_hw_rfb_op(struct ath5k_hw *ah,
 }
 
 /**
- * ath5k_hw_write_ofdm_timings - set OFDM timings on AR5212
- *
+ * ath5k_hw_write_ofdm_timings() - set OFDM timings on AR5212
  * @ah: the &struct ath5k_hw
  * @channel: the currently set channel upon reset
  *
@@ -216,10 +277,11 @@ static unsigned int ath5k_hw_rfb_op(struct ath5k_hw *ah,
  * mantissa and provide these values on hw.
  *
  * For more infos i think this patent is related
- * http://www.freepatentsonline.com/7184495.html
+ * "http://www.freepatentsonline.com/7184495.html"
  */
-static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
-	struct ieee80211_channel *channel)
+static inline int
+ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
+				struct ieee80211_channel *channel)
 {
 	/* Get exponent and mantissa and set it */
 	u32 coef_scaled, coef_exp, coef_man,
@@ -278,6 +340,10 @@ static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
 	return 0;
 }
 
+/**
+ * ath5k_hw_phy_disable() - Disable PHY
+ * @ah: The &struct ath5k_hw
+ */
 int ath5k_hw_phy_disable(struct ath5k_hw *ah)
 {
 	/*Just a try M.F.*/
@@ -286,10 +352,13 @@ int ath5k_hw_phy_disable(struct ath5k_hw *ah)
 	return 0;
 }
 
-/*
- * Wait for synth to settle
+/**
+ * ath5k_hw_wait_for_synth() - Wait for synth to settle
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
  */
-static void ath5k_hw_wait_for_synth(struct ath5k_hw *ah,
+static void
+ath5k_hw_wait_for_synth(struct ath5k_hw *ah,
 			struct ieee80211_channel *channel)
 {
 	/*
@@ -319,7 +388,9 @@ static void ath5k_hw_wait_for_synth(struct ath5k_hw *ah,
 * RF Gain optimization *
 \**********************/
 
-/*
+/**
+ * DOC: RF Gain optimization
+ *
  * This code is used to optimize RF gain on different environments
  * (temperature mostly) based on feedback from a power detector.
  *
@@ -328,19 +399,22 @@ static void ath5k_hw_wait_for_synth(struct ath5k_hw *ah,
  * no gain optimization ladder-.
  *
  * For more infos check out this patent doc
- * http://www.freepatentsonline.com/7400691.html
+ * "http://www.freepatentsonline.com/7400691.html"
  *
  * This paper describes power drops as seen on the receiver due to
  * probe packets
- * http://www.cnri.dit.ie/publications/ICT08%20-%20Practical%20Issues
- * %20of%20Power%20Control.pdf
+ * "http://www.cnri.dit.ie/publications/ICT08%20-%20Practical%20Issues
+ * %20of%20Power%20Control.pdf"
  *
  * And this is the MadWiFi bug entry related to the above
- * http://madwifi-project.org/ticket/1659
+ * "http://madwifi-project.org/ticket/1659"
  * with various measurements and diagrams
  */
 
-/* Initialize ah_gain during attach */
+/**
+ * ath5k_hw_rfgain_opt_init() - Initialize ah_gain during attach
+ * @ah: The &struct ath5k_hw
+ */
 int ath5k_hw_rfgain_opt_init(struct ath5k_hw *ah)
 {
 	/* Initialize the gain optimization values */
@@ -364,7 +438,11 @@ int ath5k_hw_rfgain_opt_init(struct ath5k_hw *ah)
 	return 0;
 }
 
-/* Schedule a gain probe check on the next transmitted packet.
+/**
+ * ath5k_hw_request_rfgain_probe() - Request a PAPD probe packet
+ * @ah: The &struct ath5k_hw
+ *
+ * Schedules a gain probe check on the next transmitted packet.
  * That means our next packet is going to be sent with lower
  * tx power and a Peak to Average Power Detector (PAPD) will try
  * to measure the gain.
@@ -373,7 +451,8 @@ int ath5k_hw_rfgain_opt_init(struct ath5k_hw *ah)
  * just after we enable the probe so that we don't mess with
  * standard traffic.
  */
-static void ath5k_hw_request_rfgain_probe(struct ath5k_hw *ah)
+static void
+ath5k_hw_request_rfgain_probe(struct ath5k_hw *ah)
 {
 
 	/* Skip if gain calibration is inactive or
@@ -391,9 +470,15 @@ static void ath5k_hw_request_rfgain_probe(struct ath5k_hw *ah)
 
 }
 
-/* Calculate gain_F measurement correction
- * based on the current step for RF5112 rev. 2 */
-static u32 ath5k_hw_rf_gainf_corr(struct ath5k_hw *ah)
+/**
+ * ath5k_hw_rf_gainf_corr() - Calculate Gain_F measurement correction
+ * @ah: The &struct ath5k_hw
+ *
+ * Calculate Gain_F measurement correction
+ * based on the current step for RF5112 rev. 2
+ */
+static u32
+ath5k_hw_rf_gainf_corr(struct ath5k_hw *ah)
 {
 	u32 mix, step;
 	u32 *rf;
@@ -446,11 +531,19 @@ static u32 ath5k_hw_rf_gainf_corr(struct ath5k_hw *ah)
 	return ah->ah_gain.g_f_corr;
 }
 
-/* Check if current gain_F measurement is in the range of our
+/**
+ * ath5k_hw_rf_check_gainf_readback() - Validate Gain_F feedback from detector
+ * @ah: The &struct ath5k_hw
+ *
+ * Check if current gain_F measurement is in the range of our
  * power detector windows. If we get a measurement outside range
  * we know it's not accurate (detectors can't measure anything outside
- * their detection window) so we must ignore it */
-static bool ath5k_hw_rf_check_gainf_readback(struct ath5k_hw *ah)
+ * their detection window) so we must ignore it.
+ *
+ * Returns true if readback was O.K. or false on failure
+ */
+static bool
+ath5k_hw_rf_check_gainf_readback(struct ath5k_hw *ah)
 {
 	const struct ath5k_rf_reg *rf_regs;
 	u32 step, mix_ovr, level[4];
@@ -502,9 +595,15 @@ static bool ath5k_hw_rf_check_gainf_readback(struct ath5k_hw *ah)
 			ah->ah_gain.g_current <= level[3]);
 }
 
-/* Perform gain_F adjustment by choosing the right set
- * of parameters from RF gain optimization ladder */
-static s8 ath5k_hw_rf_gainf_adjust(struct ath5k_hw *ah)
+/**
+ * ath5k_hw_rf_gainf_adjust() - Perform Gain_F adjustment
+ * @ah: The &struct ath5k_hw
+ *
+ * Choose the right target gain based on current gain
+ * and RF gain optimization ladder
+ */
+static s8
+ath5k_hw_rf_gainf_adjust(struct ath5k_hw *ah)
 {
 	const struct ath5k_gain_opt *go;
 	const struct ath5k_gain_opt_step *g_step;
@@ -568,11 +667,18 @@ done:
 	return ret;
 }
 
-/* Main callback for thermal RF gain calibration engine
+/**
+ * ath5k_hw_gainf_calibrate() - Do a gain_F calibration
+ * @ah: The &struct ath5k_hw
+ *
+ * Main callback for thermal RF gain calibration engine
  * Check for a new gain reading and schedule an adjustment
  * if needed.
+ *
+ * Returns one of enum ath5k_rfgain codes
  */
-enum ath5k_rfgain ath5k_hw_gainf_calibrate(struct ath5k_hw *ah)
+enum ath5k_rfgain
+ath5k_hw_gainf_calibrate(struct ath5k_hw *ah)
 {
 	u32 data, type;
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
@@ -632,10 +738,18 @@ done:
 	return ah->ah_gain.g_state;
 }
 
-/* Write initial RF gain table to set the RF sensitivity
- * this one works on all RF chips and has nothing to do
- * with gain_F calibration */
-static int ath5k_hw_rfgain_init(struct ath5k_hw *ah, enum ieee80211_band band)
+/**
+ * ath5k_hw_rfgain_init() - Write initial RF gain settings to hw
+ * @ah: The &struct ath5k_hw
+ * @band: One of enum ieee80211_band
+ *
+ * Write initial RF gain table to set the RF sensitivity.
+ *
+ * NOTE: This one works on all RF chips and has nothing to do
+ * with Gain_F calibration
+ */
+static int
+ath5k_hw_rfgain_init(struct ath5k_hw *ah, enum ieee80211_band band)
 {
 	const struct ath5k_ini_rfgain *ath5k_rfg;
 	unsigned int i, size, index;
@@ -682,16 +796,23 @@ static int ath5k_hw_rfgain_init(struct ath5k_hw *ah, enum ieee80211_band band)
 }
 
 
-
 /********************\
 * RF Registers setup *
 \********************/
 
-/*
- * Setup RF registers by writing RF buffer on hw
+/**
+ * ath5k_hw_rfregs_init() - Initialize RF register settings
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ * @mode: One of enum ath5k_driver_mode
+ *
+ * Setup RF registers by writing RF buffer on hw. For
+ * more infos on this, check out rfbuffer.h
  */
-static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
-	struct ieee80211_channel *channel, unsigned int mode)
+static int
+ath5k_hw_rfregs_init(struct ath5k_hw *ah,
+			struct ieee80211_channel *channel,
+			unsigned int mode)
 {
 	const struct ath5k_rf_reg *rf_regs;
 	const struct ath5k_ini_rfbuffer *ini_rfb;
@@ -1049,19 +1170,18 @@ static int ath5k_hw_rfregs_init(struct ath5k_hw *ah,
   PHY/RF channel functions
 \**************************/
 
-/*
- * Conversion needed for RF5110
+/**
+ * ath5k_hw_rf5110_chan2athchan() - Convert channel freq on RF5110
+ * @channel: The &struct ieee80211_channel
+ *
+ * Map channel frequency to IEEE channel number and convert it
+ * to an internal channel value used by the RF5110 chipset.
  */
-static u32 ath5k_hw_rf5110_chan2athchan(struct ieee80211_channel *channel)
+static u32
+ath5k_hw_rf5110_chan2athchan(struct ieee80211_channel *channel)
 {
 	u32 athchan;
 
-	/*
-	 * Convert IEEE channel/MHz to an internal channel value used
-	 * by the AR5210 chipset. This has not been verified with
-	 * newer chipsets like the AR5212A who have a completely
-	 * different RF/PHY part.
-	 */
 	athchan = (ath5k_hw_bitswap(
 			(ieee80211_frequency_to_channel(
 				channel->center_freq) - 24) / 2, 5)
@@ -1069,10 +1189,13 @@ static u32 ath5k_hw_rf5110_chan2athchan(struct ieee80211_channel *channel)
 	return athchan;
 }
 
-/*
- * Set channel on RF5110
+/**
+ * ath5k_hw_rf5110_channel() - Set channel frequency on RF5110
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
  */
-static int ath5k_hw_rf5110_channel(struct ath5k_hw *ah,
+static int
+ath5k_hw_rf5110_channel(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	u32 data;
@@ -1088,10 +1211,18 @@ static int ath5k_hw_rf5110_channel(struct ath5k_hw *ah,
 	return 0;
 }
 
-/*
- * Conversion needed for 5111
+/**
+ * ath5k_hw_rf5111_chan2athchan() - Handle 2GHz channels on RF5111/2111
+ * @ieee: IEEE channel number
+ * @athchan: The &struct ath5k_athchan_2ghz
+ *
+ * In order to enable the RF2111 frequency converter on RF5111/2111 setups
+ * we need to add some offsets and extra flags to the data values we pass
+ * on to the PHY. So for every 2GHz channel this function gets called
+ * to do the conversion.
  */
-static int ath5k_hw_rf5111_chan2athchan(unsigned int ieee,
+static int
+ath5k_hw_rf5111_chan2athchan(unsigned int ieee,
 		struct ath5k_athchan_2ghz *athchan)
 {
 	int channel;
@@ -1117,10 +1248,13 @@ static int ath5k_hw_rf5111_chan2athchan(unsigned int ieee,
 	return 0;
 }
 
-/*
- * Set channel on 5111
+/**
+ * ath5k_hw_rf5111_channel() - Set channel frequency on RF5111/2111
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
  */
-static int ath5k_hw_rf5111_channel(struct ath5k_hw *ah,
+static int
+ath5k_hw_rf5111_channel(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	struct ath5k_athchan_2ghz ath5k_channel_2ghz;
@@ -1165,10 +1299,20 @@ static int ath5k_hw_rf5111_channel(struct ath5k_hw *ah,
 	return 0;
 }
 
-/*
- * Set channel on 5112 and newer
+/**
+ * ath5k_hw_rf5112_channel() - Set channel frequency on 5112 and newer
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ *
+ * On RF5112/2112 and newer we don't need to do any conversion.
+ * We pass the frequency value after a few modifications to the
+ * chip directly.
+ *
+ * NOTE: Make sure channel frequency given is within our range or else
+ * we might damage the chip ! Use ath5k_channel_ok before calling this one.
  */
-static int ath5k_hw_rf5112_channel(struct ath5k_hw *ah,
+static int
+ath5k_hw_rf5112_channel(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	u32 data, data0, data1, data2;
@@ -1177,17 +1321,37 @@ static int ath5k_hw_rf5112_channel(struct ath5k_hw *ah,
 	data = data0 = data1 = data2 = 0;
 	c = channel->center_freq;
 
+	/* My guess based on code:
+	 * 2GHz RF has 2 synth modes, one with a Local Oscillator
+	 * at 2224Hz and one with a LO at 2192Hz. IF is 1520Hz
+	 * (3040/2). data0 is used to set the PLL divider and data1
+	 * selects synth mode. */
 	if (c < 4800) {
+		/* Channel 14 and all frequencies with 2Hz spacing
+		 * below/above (non-standard channels) */
 		if (!((c - 2224) % 5)) {
+			/* Same as (c - 2224) / 5 */
 			data0 = ((2 * (c - 704)) - 3040) / 10;
 			data1 = 1;
+		/* Channel 1 and all frequencies with 5Hz spacing
+		 * below/above (standard channels without channel 14) */
 		} else if (!((c - 2192) % 5)) {
+			/* Same as (c - 2192) / 5 */
 			data0 = ((2 * (c - 672)) - 3040) / 10;
 			data1 = 0;
 		} else
 			return -EINVAL;
 
 		data0 = ath5k_hw_bitswap((data0 << 2) & 0xff, 8);
+	/* This is more complex, we have a single synthesizer with
+	 * 4 reference clock settings (?) based on frequency spacing
+	 * and set using data2. LO is at 4800Hz and data0 is again used
+	 * to set some divider.
+	 *
+	 * NOTE: There is an old atheros presentation at Stanford
+	 * that mentions a method called dual direct conversion
+	 * with 1GHz sliding IF for RF5110. Maybe that's what we
+	 * have here, or an updated version. */
 	} else if ((c % 5) != 2 || c > 5435) {
 		if (!(c % 20) && c >= 5120) {
 			data0 = ath5k_hw_bitswap(((c - 4800) / 20 << 2), 8);
@@ -1213,10 +1377,16 @@ static int ath5k_hw_rf5112_channel(struct ath5k_hw *ah,
 	return 0;
 }
 
-/*
- * Set the channel on the RF2425
+/**
+ * ath5k_hw_rf2425_channel() - Set channel frequency on RF2425
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ *
+ * AR2425/2417 have a different 2GHz RF so code changes
+ * a little bit from RF5112.
  */
-static int ath5k_hw_rf2425_channel(struct ath5k_hw *ah,
+static int
+ath5k_hw_rf2425_channel(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	u32 data, data0, data2;
@@ -1252,10 +1422,16 @@ static int ath5k_hw_rf2425_channel(struct ath5k_hw *ah,
 	return 0;
 }
 
-/*
- * Set a channel on the radio chip
+/**
+ * ath5k_hw_channel() - Set a channel on the radio chip
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ *
+ * This is the main function called to set a channel on the
+ * radio chip based on the radio chip version.
  */
-static int ath5k_hw_channel(struct ath5k_hw *ah,
+static int
+ath5k_hw_channel(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	int ret;
@@ -1307,11 +1483,46 @@ static int ath5k_hw_channel(struct ath5k_hw *ah,
 	return 0;
 }
 
+
 /*****************\
   PHY calibration
 \*****************/
 
-static s32 ath5k_hw_read_measured_noise_floor(struct ath5k_hw *ah)
+/**
+ * DOC: PHY Calibration routines
+ *
+ * Noise floor calibration: When we tell the hardware to
+ * perform a noise floor calibration by setting the
+ * AR5K_PHY_AGCCTL_NF bit on AR5K_PHY_AGCCTL, it will periodically
+ * sample-and-hold the minimum noise level seen at the antennas.
+ * This value is then stored in a ring buffer of recently measured
+ * noise floor values so we have a moving window of the last few
+ * samples. The median of the values in the history is then loaded
+ * into the hardware for its own use for RSSI and CCA measurements.
+ * This type of calibration doesn't interfere with traffic.
+ *
+ * AGC calibration: When we tell the hardware to perform
+ * an AGC (Automatic Gain Control) calibration by setting the
+ * AR5K_PHY_AGCCTL_CAL, hw disconnects the antennas and does
+ * a calibration on the DC offsets of ADCs. During this period
+ * rx/tx gets disabled so we have to deal with it on the driver
+ * part.
+ *
+ * I/Q calibration: When we tell the hardware to perform
+ * an I/Q calibration, it tries to correct I/Q imbalance and
+ * fix QAM constellation by sampling data from rxed frames.
+ * It doesn't interfere with traffic.
+ *
+ * For more infos on AGC and I/Q calibration check out patent doc
+ * #03/094463.
+ */
+
+/**
+ * ath5k_hw_read_measured_noise_floor() - Read measured NF from hw
+ * @ah: The &struct ath5k_hw
+ */
+static s32
+ath5k_hw_read_measured_noise_floor(struct ath5k_hw *ah)
 {
 	s32 val;
 
@@ -1319,7 +1530,12 @@ static s32 ath5k_hw_read_measured_noise_floor(struct ath5k_hw *ah)
 	return sign_extend32(AR5K_REG_MS(val, AR5K_PHY_NF_MINCCA_PWR), 8);
 }
 
-void ath5k_hw_init_nfcal_hist(struct ath5k_hw *ah)
+/**
+ * ath5k_hw_init_nfcal_hist() - Initialize NF calibration history buffer
+ * @ah: The &struct ath5k_hw
+ */
+void
+ath5k_hw_init_nfcal_hist(struct ath5k_hw *ah)
 {
 	int i;
 
@@ -1328,6 +1544,11 @@ void ath5k_hw_init_nfcal_hist(struct ath5k_hw *ah)
 		ah->ah_nfcal_hist.nfval[i] = AR5K_TUNE_CCA_MAX_GOOD_VALUE;
 }
 
+/**
+ * ath5k_hw_update_nfcal_hist() - Update NF calibration history buffer
+ * @ah: The &struct ath5k_hw
+ * @noise_floor: The NF we got from hw
+ */
 static void ath5k_hw_update_nfcal_hist(struct ath5k_hw *ah, s16 noise_floor)
 {
 	struct ath5k_nfcal_hist *hist = &ah->ah_nfcal_hist;
@@ -1335,7 +1556,12 @@ static void ath5k_hw_update_nfcal_hist(struct ath5k_hw *ah, s16 noise_floor)
 	hist->nfval[hist->index] = noise_floor;
 }
 
-static s16 ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
+/**
+ * ath5k_hw_get_median_noise_floor() - Get median NF from history buffer
+ * @ah: The &struct ath5k_hw
+ */
+static s16
+ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
 {
 	s16 sort[ATH5K_NF_CAL_HIST_MAX];
 	s16 tmp;
@@ -1358,18 +1584,16 @@ static s16 ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
 	return sort[(ATH5K_NF_CAL_HIST_MAX - 1) / 2];
 }
 
-/*
- * When we tell the hardware to perform a noise floor calibration
- * by setting the AR5K_PHY_AGCCTL_NF bit, it will periodically
- * sample-and-hold the minimum noise level seen at the antennas.
- * This value is then stored in a ring buffer of recently measured
- * noise floor values so we have a moving window of the last few
- * samples.
+/**
+ * ath5k_hw_update_noise_floor() - Update NF on hardware
+ * @ah: The &struct ath5k_hw
  *
- * The median of the values in the history is then loaded into the
- * hardware for its own use for RSSI and CCA measurements.
+ * This is the main function we call to perform a NF calibration,
+ * it reads NF from hardware, calculates the median and updates
+ * NF on hw.
  */
-void ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
+void
+ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 val;
@@ -1436,11 +1660,15 @@ void ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
 		"noise floor calibrated: %d\n", nf);
 }
 
-/*
- * Perform a PHY calibration on RF5110
- * -Fix BPSK/QAM Constellation (I/Q correction)
+/**
+ * ath5k_hw_rf5110_calibrate() - Perform a PHY calibration on RF5110
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ *
+ * Do a complete PHY calibration (AGC + NF + I/Q) on RF5110
  */
-static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
+static int
+ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	u32 phy_sig, phy_agc, phy_sat, beacon;
@@ -1535,8 +1763,9 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 	return 0;
 }
 
-/*
- * Perform I/Q calibration on RF5111/5112 and newer chips
+/**
+ * ath5k_hw_rf511x_iq_calibrate() - Perform I/Q calibration on RF5111 and newer
+ * @ah: The &struct ath5k_hw
  */
 static int
 ath5k_hw_rf511x_iq_calibrate(struct ath5k_hw *ah)
@@ -1610,10 +1839,17 @@ ath5k_hw_rf511x_iq_calibrate(struct ath5k_hw *ah)
 	return 0;
 }
 
-/*
- * Perform a PHY calibration
+/**
+ * ath5k_hw_phy_calibrate() - Perform a PHY calibration
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ *
+ * The main function we call from above to perform
+ * a short or full PHY calibration based on RF chip
+ * and current channel
  */
-int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
+int
+ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	int ret;
@@ -1668,6 +1904,16 @@ int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
 * Spur mitigation functions *
 \***************************/
 
+/**
+ * ath5k_hw_set_spur_mitigation_filter() - Configure SPUR filter
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ *
+ * This function gets called during PHY initialization to
+ * configure the spur filter for the given channel. Spur is noise
+ * generated due to "reflection" effects, for more information on this
+ * method check out patent US7643810
+ */
 static void
 ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 				struct ieee80211_channel *channel)
@@ -1907,15 +2153,73 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 * Antenna control *
 \*****************/
 
-static void /*TODO:Boundary check*/
+/**
+ * DOC: Antenna control
+ *
+ * Hw supports up to 14 antennas ! I haven't found any card that implements
+ * that. The maximum number of antennas I've seen is up to 4 (2 for 2GHz and 2
+ * for 5GHz). Antenna 1 (MAIN) should be omnidirectional, 2 (AUX)
+ * omnidirectional or sectorial and antennas 3-14 sectorial (or directional).
+ *
+ * We can have a single antenna for RX and multiple antennas for TX.
+ * RX antenna is our "default" antenna (usually antenna 1) set on
+ * DEFAULT_ANTENNA register and TX antenna is set on each TX control descriptor
+ * (0 for automatic selection, 1 - 14 antenna number).
+ *
+ * We can let hw do all the work doing fast antenna diversity for both
+ * tx and rx or we can do things manually. Here are the options we have
+ * (all are bits of STA_ID1 register):
+ *
+ * AR5K_STA_ID1_DEFAULT_ANTENNA -> When 0 is set as the TX antenna on TX
+ * control descriptor, use the default antenna to transmit or else use the last
+ * antenna on which we received an ACK.
+ *
+ * AR5K_STA_ID1_DESC_ANTENNA -> Update default antenna after each TX frame to
+ * the antenna on which we got the ACK for that frame.
+ *
+ * AR5K_STA_ID1_RTS_DEF_ANTENNA -> Use default antenna for RTS or else use the
+ * one on the TX descriptor.
+ *
+ * AR5K_STA_ID1_SELFGEN_DEF_ANT -> Use default antenna for self generated frames
+ * (ACKs etc), or else use current antenna (the one we just used for TX).
+ *
+ * Using the above we support the following scenarios:
+ *
+ * AR5K_ANTMODE_DEFAULT -> Hw handles antenna diversity etc automatically
+ *
+ * AR5K_ANTMODE_FIXED_A	-> Only antenna A (MAIN) is present
+ *
+ * AR5K_ANTMODE_FIXED_B	-> Only antenna B (AUX) is present
+ *
+ * AR5K_ANTMODE_SINGLE_AP -> Sta locked on a single ap
+ *
+ * AR5K_ANTMODE_SECTOR_AP -> AP with tx antenna set on tx desc
+ *
+ * AR5K_ANTMODE_SECTOR_STA -> STA with tx antenna set on tx desc
+ *
+ * AR5K_ANTMODE_DEBUG Debug mode -A -> Rx, B-> Tx-
+ *
+ * Also note that when setting antenna to F on tx descriptor card inverts
+ * current tx antenna.
+ */
+
+/**
+ * ath5k_hw_set_def_antenna() - Set default rx antenna on AR5211/5212 and newer
+ * @ah: The &struct ath5k_hw
+ * @ant: Antenna number
+ */
+static void
 ath5k_hw_set_def_antenna(struct ath5k_hw *ah, u8 ant)
 {
 	if (ah->ah_version != AR5K_AR5210)
 		ath5k_hw_reg_write(ah, ant & 0x7, AR5K_DEFAULT_ANTENNA);
 }
 
-/*
- * Enable/disable fast rx antenna diversity
+/**
+ * ath5k_hw_set_fast_div() -  Enable/disable fast rx antenna diversity
+ * @ah: The &struct ath5k_hw
+ * @ee_mode: One of enum ath5k_driver_mode
+ * @enable: True to enable, false to disable
  */
 static void
 ath5k_hw_set_fast_div(struct ath5k_hw *ah, u8 ee_mode, bool enable)
@@ -1955,6 +2259,14 @@ ath5k_hw_set_fast_div(struct ath5k_hw *ah, u8 ee_mode, bool enable)
 	}
 }
 
+/**
+ * ath5k_hw_set_antenna_switch() - Set up antenna switch table
+ * @ah: The &struct ath5k_hw
+ * @ee_mode: One of enum ath5k_driver_mode
+ *
+ * Switch table comes from EEPROM and includes information on controlling
+ * the 2 antenna RX attenuators
+ */
 void
 ath5k_hw_set_antenna_switch(struct ath5k_hw *ah, u8 ee_mode)
 {
@@ -1986,8 +2298,10 @@ ath5k_hw_set_antenna_switch(struct ath5k_hw *ah, u8 ee_mode)
 		AR5K_PHY_ANT_SWITCH_TABLE_1);
 }
 
-/*
- * Set antenna operating mode
+/**
+ * ath5k_hw_set_antenna_mode() -  Set antenna operating mode
+ * @ah: The &struct ath5k_hw
+ * @ant_mode: One of enum ath5k_ant_mode
  */
 void
 ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
@@ -2110,8 +2424,13 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
  * Helper functions
  */
 
-/*
- * Do linear interpolation between two given (x, y) points
+/**
+ * ath5k_get_interpolated_value() - Get interpolated Y val between two points
+ * @target: X value of the middle point
+ * @x_left: X value of the left point
+ * @x_right: X value of the right point
+ * @y_left: Y value of the left point
+ * @y_right: Y value of the right point
  */
 static s16
 ath5k_get_interpolated_value(s16 target, s16 x_left, s16 x_right,
@@ -2138,13 +2457,18 @@ ath5k_get_interpolated_value(s16 target, s16 x_left, s16 x_right,
 	return result;
 }
 
-/*
- * Find vertical boundary (min pwr) for the linear PCDAC curve.
+/**
+ * ath5k_get_linear_pcdac_min() - Find vertical boundary (min pwr) for the
+ * linear PCDAC curve
+ * @stepL: Left array with y values (pcdac steps)
+ * @stepR: Right array with y values (pcdac steps)
+ * @pwrL: Left array with x values (power steps)
+ * @pwrR: Right array with x values (power steps)
  *
  * Since we have the top of the curve and we draw the line below
  * until we reach 1 (1 pcdac step) we need to know which point
- * (x value) that is so that we don't go below y axis and have negative
- * pcdac values when creating the curve, or fill the table with zeroes.
+ * (x value) that is so that we don't go below x axis and have negative
+ * pcdac values when creating the curve, or fill the table with zeros.
  */
 static s16
 ath5k_get_linear_pcdac_min(const u8 *stepL, const u8 *stepR,
@@ -2190,7 +2514,16 @@ ath5k_get_linear_pcdac_min(const u8 *stepL, const u8 *stepR,
 	return max(min_pwrL, min_pwrR);
 }
 
-/*
+/**
+ * ath5k_create_power_curve() - Create a Power to PDADC or PCDAC curve
+ * @pmin: Minimum power value (xmin)
+ * @pmax: Maximum power value (xmax)
+ * @pwr: Array of power steps (x values)
+ * @vpd: Array of matching PCDAC/PDADC steps (y values)
+ * @num_points: Number of provided points
+ * @vpd_table: Array to fill with the full PCDAC/PDADC values (y values)
+ * @type: One of enum ath5k_powertable_type (eeprom.h)
+ *
  * Interpolate (pwr,vpd) points to create a Power to PDADC or a
  * Power to PCDAC curve.
  *
@@ -2248,7 +2581,14 @@ ath5k_create_power_curve(s16 pmin, s16 pmax,
 	}
 }
 
-/*
+/**
+ * ath5k_get_chan_pcal_surrounding_piers() - Get surrounding calibration piers
+ * for a given channel.
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ * @pcinfo_l: The &struct ath5k_chan_pcal_info to put the left cal. pier
+ * @pcinfo_r: The &struct ath5k_chan_pcal_info to put the right cal. pier
+ *
  * Get the surrounding per-channel power calibration piers
  * for a given frequency so that we can interpolate between
  * them and come up with an appropriate dataset for our current
@@ -2331,11 +2671,17 @@ done:
 	*pcinfo_r = &pcinfo[idx_r];
 }
 
-/*
+/**
+ * ath5k_get_rate_pcal_data() - Get the interpolated per-rate power
+ * calibration data
+ * @ah: The &struct ath5k_hw *ah,
+ * @channel: The &struct ieee80211_channel
+ * @rates: The &struct ath5k_rate_pcal_info to fill
+ *
  * Get the surrounding per-rate power calibration data
  * for a given frequency and interpolate between power
  * values to set max target power supported by hw for
- * each rate.
+ * each rate on this frequency.
  */
 static void
 ath5k_get_rate_pcal_data(struct ath5k_hw *ah,
@@ -2423,7 +2769,11 @@ done:
 					rpinfo[idx_r].target_power_54);
 }
 
-/*
+/**
+ * ath5k_get_max_ctl_power() - Get max edge power for a given frequency
+ * @ah: the &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ *
  * Get the max edge power for this channel if
  * we have such data from EEPROM's Conformance Test
  * Limits (CTL), and limit max power if needed.
@@ -2503,8 +2853,39 @@ ath5k_get_max_ctl_power(struct ath5k_hw *ah,
  * Power to PCDAC table functions
  */
 
-/*
- * Fill Power to PCDAC table on RF5111
+/**
+ * DOC: Power to PCDAC table functions
+ *
+ * For RF5111 we have an XPD -eXternal Power Detector- curve
+ * for each calibrated channel. Each curve has 0,5dB Power steps
+ * on x axis and PCDAC steps (offsets) on y axis and looks like an
+ * exponential function. To recreate the curve we read 11 points
+ * from eeprom (eeprom.c) and interpolate here.
+ *
+ * For RF5112 we have 4 XPD -eXternal Power Detector- curves
+ * for each calibrated channel on 0, -6, -12 and -18dBm but we only
+ * use the higher (3) and the lower (0) curves. Each curve again has 0.5dB
+ * power steps on x axis and PCDAC steps on y axis and looks like a
+ * linear function. To recreate the curve and pass the power values
+ * on hw, we get 4 points for xpd 0 (lower gain -> max power)
+ * and 3 points for xpd 3 (higher gain -> lower power) from eeprom (eeprom.c)
+ * and interpolate here.
+ *
+ * For a given channel we get the calibrated points (piers) for it or
+ * -if we don't have calibration data for this specific channel- from the
+ * available surrounding channels we have calibration data for, after we do a
+ * linear interpolation between them. Then since we have our calibrated points
+ * for this channel, we do again a linear interpolation between them to get the
+ * whole curve.
+ *
+ * We finally write the Y values of the curve(s) (the PCDAC values) on hw
+ */
+
+/**
+ * ath5k_fill_pwr_to_pcdac_table() - Fill Power to PCDAC table on RF5111
+ * @ah: The &struct ath5k_hw
+ * @table_min: Minimum power (x min)
+ * @table_max: Maximum power (x max)
  *
  * No further processing is needed for RF5111, the only thing we have to
  * do is fill the values below and above calibration range since eeprom data
@@ -2545,10 +2926,14 @@ ath5k_fill_pwr_to_pcdac_table(struct ath5k_hw *ah, s16* table_min,
 
 }
 
-/*
- * Combine available XPD Curves and fill Linear Power to PCDAC table
- * on RF5112
+/**
+ * ath5k_combine_linear_pcdac_curves() - Combine available PCDAC Curves
+ * @ah: The &struct ath5k_hw
+ * @table_min: Minimum power (x min)
+ * @table_max: Maximum power (x max)
+ * @pdcurves: Number of pd curves
  *
+ * Combine available XPD Curves and fill Linear Power to PCDAC table on RF5112
  * RFX112 can have up to 2 curves (one for low txpower range and one for
  * higher txpower range). We need to put them both on pcdac_out and place
  * them in the correct location. In case we only have one curve available
@@ -2650,7 +3035,10 @@ ath5k_combine_linear_pcdac_curves(struct ath5k_hw *ah, s16* table_min,
 	}
 }
 
-/* Write PCDAC values on hw */
+/**
+ * ath5k_write_pcdac_table() - Write the PCDAC values on hw
+ * @ah: The &struct ath5k_hw
+ */
 static void
 ath5k_write_pcdac_table(struct ath5k_hw *ah)
 {
@@ -2673,9 +3061,32 @@ ath5k_write_pcdac_table(struct ath5k_hw *ah)
  * Power to PDADC table functions
  */
 
-/*
- * Set the gain boundaries and create final Power to PDADC table
+/**
+ * DOC: Power to PDADC table functions
+ *
+ * For RF2413 and later we have a Power to PDADC table (Power Detector)
+ * instead of a PCDAC (Power Control) and 4 pd gain curves for each
+ * calibrated channel. Each curve has power on x axis in 0.5 db steps and
+ * PDADC steps on y axis and looks like an exponential function like the
+ * RF5111 curve.
+ *
+ * To recreate the curves we read the points from eeprom (eeprom.c)
+ * and interpolate here. Note that in most cases only 2 (higher and lower)
+ * curves are used (like RF5112) but vendors have the opportunity to include
+ * all 4 curves on eeprom. The final curve (higher power) has an extra
+ * point for better accuracy like RF5112.
  *
+ * The process is similar to what we do above for RF5111/5112
+ */
+
+/**
+ * ath5k_combine_pwr_to_pdadc_curves() - Combine the various PDADC curves
+ * @ah: The &struct ath5k_hw
+ * @pwr_min: Minimum power (x min)
+ * @pwr_max: Maximum power (x max)
+ * @pdcurves: Number of available curves
+ *
+ * Combine the various pd curves and create the final Power to PDADC table
  * We can have up to 4 pd curves, we need to do a similar process
  * as we do for RF5112. This time we don't have an edge_flag but we
  * set the gain boundaries on a separate register.
@@ -2799,7 +3210,11 @@ ath5k_combine_pwr_to_pdadc_curves(struct ath5k_hw *ah,
 
 }
 
-/* Write PDADC values on hw */
+/**
+ * ath5k_write_pwr_to_pdadc_table() - Write the PDADC values on hw
+ * @ah: The &struct ath5k_hw
+ * @ee_mode: One of enum ath5k_driver_mode
+ */
 static void
 ath5k_write_pwr_to_pdadc_table(struct ath5k_hw *ah, u8 ee_mode)
 {
@@ -2856,7 +3271,13 @@ ath5k_write_pwr_to_pdadc_table(struct ath5k_hw *ah, u8 ee_mode)
  * Common code for PCDAC/PDADC tables
  */
 
-/*
+/**
+ * ath5k_setup_channel_powertable() - Set up power table for this channel
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ * @ee_mode: One of enum ath5k_driver_mode
+ * @type: One of enum ath5k_powertable_type (eeprom.h)
+ *
  * This is the main function that uses all of the above
  * to set PCDAC/PDADC table on hw for the current channel.
  * This table is used for tx power calibration on the baseband,
@@ -3054,7 +3475,12 @@ ath5k_setup_channel_powertable(struct ath5k_hw *ah,
 	return 0;
 }
 
-/* Write power table for current channel to hw */
+/**
+ * ath5k_write_channel_powertable() - Set power table for current channel on hw
+ * @ah: The &struct ath5k_hw
+ * @ee_mode: One of enum ath5k_driver_mode
+ * @type: One of enum ath5k_powertable_type (eeprom.h)
+ */
 static void
 ath5k_write_channel_powertable(struct ath5k_hw *ah, u8 ee_mode, u8 type)
 {
@@ -3064,28 +3490,36 @@ ath5k_write_channel_powertable(struct ath5k_hw *ah, u8 ee_mode, u8 type)
 		ath5k_write_pcdac_table(ah);
 }
 
-/*
- * Per-rate tx power setting
+
+/**
+ * DOC: Per-rate tx power setting
  *
- * This is the code that sets the desired tx power (below
+ * This is the code that sets the desired tx power limit (below
  * maximum) on hw for each rate (we also have TPC that sets
- * power per packet). We do that by providing an index on the
- * PCDAC/PDADC table we set up.
- */
-
-/*
- * Set rate power table
+ * power per packet type). We do that by providing an index on the
+ * PCDAC/PDADC table we set up above, for each rate.
  *
  * For now we only limit txpower based on maximum tx power
- * supported by hw (what's inside rate_info). We need to limit
- * this even more, based on regulatory domain etc.
+ * supported by hw (what's inside rate_info) + conformance test
+ * limits. We need to limit this even more, based on regulatory domain
+ * etc to be safe. Normally this is done from above so we don't care
+ * here, all we care is that the tx power we set will be O.K.
+ * for the hw (e.g. won't create noise on PA etc).
  *
- * Rate power table contains indices to PCDAC/PDADC table (0.5dB steps)
- * and is indexed as follows:
+ * Rate power table contains indices to PCDAC/PDADC table (0.5dB steps -
+ * x values) and is indexed as follows:
  * rates[0] - rates[7] -> OFDM rates
  * rates[8] - rates[14] -> CCK rates
  * rates[15] -> XR rates (they all have the same power)
  */
+
+/**
+ * ath5k_setup_rate_powertable() - Set up rate power table for a given tx power
+ * @ah: The &struct ath5k_hw
+ * @max_pwr: The maximum tx power requested in 0.5dB steps
+ * @rate_info: The &struct ath5k_rate_pcal_info to fill
+ * @ee_mode: One of enum ath5k_driver_mode
+ */
 static void
 ath5k_setup_rate_powertable(struct ath5k_hw *ah, u16 max_pwr,
 			struct ath5k_rate_pcal_info *rate_info,
@@ -3156,8 +3590,14 @@ ath5k_setup_rate_powertable(struct ath5k_hw *ah, u16 max_pwr,
 }
 
 
-/*
- * Set transmission power
+/**
+ * ath5k_hw_txpower() - Set transmission power limit for a given channel
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ * @txpower: Requested tx power in 0.5dB steps
+ *
+ * Combines all of the above to set the requested tx power limit
+ * on hw.
  */
 static int
 ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
@@ -3275,7 +3715,16 @@ ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	return 0;
 }
 
-int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
+/**
+ * ath5k_hw_set_txpower_limit() - Set txpower limit for the current channel
+ * @ah: The &struct ath5k_hw
+ * @txpower: The requested tx power limit in 0.5dB steps
+ *
+ * This function provides access to ath5k_hw_txpower to the driver in
+ * case user or an application changes it while PHY is running.
+ */
+int
+ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
 {
 	ATH5K_DBG(ah, ATH5K_DEBUG_TXPOWER,
 		"changing txpower to %d\n", txpower);
@@ -3283,11 +3732,26 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
 	return ath5k_hw_txpower(ah, ah->ah_current_channel, txpower);
 }
 
+
 /*************\
  Init function
 \*************/
 
-int ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
+/**
+ * ath5k_hw_phy_init() - Initialize PHY
+ * @ah: The &struct ath5k_hw
+ * @channel: The @struct ieee80211_channel
+ * @mode: One of enum ath5k_driver_mode
+ * @fast: Try a fast channel switch instead
+ *
+ * This is the main function used during reset to initialize PHY
+ * or do a fast channel change if possible.
+ *
+ * NOTE: Do not call this one from the driver, it assumes PHY is in a
+ * warm reset state !
+ */
+int
+ath5k_hw_phy_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 		      u8 mode, bool fast)
 {
 	struct ieee80211_channel *curr_channel;
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index 7766542..31924c3 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -17,23 +17,47 @@
  */
 
 /********************************************\
-Queue Control Unit, DFS Control Unit Functions
+Queue Control Unit, DCF Control Unit Functions
 \********************************************/
 
 #include "ath5k.h"
 #include "reg.h"
 #include "debug.h"
 
+/**
+ * DOC: Queue Control Unit (QCU)/DCF Control Unit (DCU) functions
+ *
+ * Here we setup parameters for the 12 available TX queues. Note that
+ * on the various registers we can usually only map the first 10 of them so
+ * basically we have 10 queues to play with. Each queue has a matching
+ * QCU that controls when the queue will get triggered and multiple QCUs
+ * can be mapped to a single DCU that controls the various DFS parameters
+ * for the various queues. In our setup we have a 1:1 mapping between QCUs
+ * and DCUs allowing us to have different DFS settings for each queue.
+ *
+ * When a frame goes into a TX queue, QCU decides when it'll trigger a
+ * transmission based on various criteria (such as how many data we have inside
+ * it's buffer or -if it's a beacon queue- if it's time to fire up the queue
+ * based on TSF etc), DCU adds backoff, IFSes etc and then a scheduler
+ * (arbitrator) decides the priority of each QCU based on it's configuration
+ * (e.g. beacons are always transmitted when they leave DCU bypassing all other
+ * frames from other queues waiting to be transmitted). After a frame leaves
+ * the DCU it goes to PCU for further processing and then to PHY for
+ * the actual transmission.
+ */
+
 
 /******************\
 * Helper functions *
 \******************/
 
-/*
- * Get number of pending frames
- * for a specific queue [5211+]
+/**
+ * ath5k_hw_num_tx_pending() - Get number of pending frames for a  given queue
+ * @ah: The &struct ath5k_hw
+ * @queue: The hw queue number
  */
-u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue)
+u32
+ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue)
 {
 	u32 pending;
 	AR5K_ASSERT_ENTRY(queue, ah->ah_capabilities.cap_queues.q_tx_num);
@@ -58,10 +82,13 @@ u32 ath5k_hw_num_tx_pending(struct ath5k_hw *ah, unsigned int queue)
 	return pending;
 }
 
-/*
- * Set a transmit queue inactive
+/**
+ * ath5k_hw_release_tx_queue() - Set a transmit queue inactive
+ * @ah: The &struct ath5k_hw
+ * @queue: The hw queue number
  */
-void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue)
+void
+ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 {
 	if (WARN_ON(queue >= ah->ah_capabilities.cap_queues.q_tx_num))
 		return;
@@ -72,10 +99,14 @@ void ath5k_hw_release_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 	AR5K_Q_DISABLE_BITS(ah->ah_txq_status, queue);
 }
 
-/*
+/**
+ * ath5k_cw_validate() - Make sure the given cw is valid
+ * @cw_req: The contention window value to check
+ *
  * Make sure cw is a power of 2 minus 1 and smaller than 1024
  */
-static u16 ath5k_cw_validate(u16 cw_req)
+static u16
+ath5k_cw_validate(u16 cw_req)
 {
 	u32 cw = 1;
 	cw_req = min(cw_req, (u16)1023);
@@ -86,20 +117,30 @@ static u16 ath5k_cw_validate(u16 cw_req)
 	return cw;
 }
 
-/*
- * Get properties for a transmit queue
+/**
+ * ath5k_hw_get_tx_queueprops() - Get properties for a transmit queue
+ * @ah: The &struct ath5k_hw
+ * @queue: The hw queue number
+ * @queue_info: The &struct ath5k_txq_info to fill
  */
-int ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
+int
+ath5k_hw_get_tx_queueprops(struct ath5k_hw *ah, int queue,
 		struct ath5k_txq_info *queue_info)
 {
 	memcpy(queue_info, &ah->ah_txq[queue], sizeof(struct ath5k_txq_info));
 	return 0;
 }
 
-/*
- * Set properties for a transmit queue
+/**
+ * ath5k_hw_set_tx_queueprops() - Set properties for a transmit queue
+ * @ah: The &struct ath5k_hw
+ * @queue: The hw queue number
+ * @qinfo: The &struct ath5k_txq_info to use
+ *
+ * Returns 0 on success or -EIO if queue is inactive
  */
-int ath5k_hw_set_tx_queueprops(struct ath5k_hw *ah, int queue,
+int
+ath5k_hw_set_tx_queueprops(struct ath5k_hw *ah, int queue,
 				const struct ath5k_txq_info *qinfo)
 {
 	struct ath5k_txq_info *qi;
@@ -139,10 +180,16 @@ int ath5k_hw_set_tx_queueprops(struct ath5k_hw *ah, int queue,
 	return 0;
 }
 
-/*
- * Initialize a transmit queue
+/**
+ * ath5k_hw_setup_tx_queue() - Initialize a transmit queue
+ * @ah: The &struct ath5k_hw
+ * @queue_type: One of enum ath5k_tx_queue
+ * @queue_info: The &struct ath5k_txq_info to use
+ *
+ * Returns 0 on success, -EINVAL on invalid arguments
  */
-int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
+int
+ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 		struct ath5k_txq_info *queue_info)
 {
 	unsigned int queue;
@@ -217,10 +264,16 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 * Single QCU/DCU initialization *
 \*******************************/
 
-/*
- * Set tx retry limits on DCU
+/**
+ * ath5k_hw_set_tx_retry_limits() - Set tx retry limits on DCU
+ * @ah: The &struct ath5k_hw
+ * @queue: The hw queue number
+ *
+ * This function is used when initializing a queue, to set
+ * retry limits based on ah->ah_retry_* and the chipset used.
  */
-void ath5k_hw_set_tx_retry_limits(struct ath5k_hw *ah,
+void
+ath5k_hw_set_tx_retry_limits(struct ath5k_hw *ah,
 				  unsigned int queue)
 {
 	/* Single data queue on AR5210 */
@@ -255,15 +308,15 @@ void ath5k_hw_set_tx_retry_limits(struct ath5k_hw *ah,
 }
 
 /**
- * ath5k_hw_reset_tx_queue - Initialize a single hw queue
- *
- * @ah The &struct ath5k_hw
- * @queue The hw queue number
+ * ath5k_hw_reset_tx_queue() - Initialize a single hw queue
+ * @ah: The &struct ath5k_hw
+ * @queue: The hw queue number
  *
  * Set DFS properties for the given transmit queue on DCU
  * and configures all queue-specific parameters.
  */
-int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
+int
+ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 {
 	struct ath5k_txq_info *tq = &ah->ah_txq[queue];
 
@@ -491,10 +544,9 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 \**************************/
 
 /**
- * ath5k_hw_set_ifs_intervals  - Set global inter-frame spaces on DCU
- *
- * @ah The &struct ath5k_hw
- * @slot_time Slot time in us
+ * ath5k_hw_set_ifs_intervals()  - Set global inter-frame spaces on DCU
+ * @ah: The &struct ath5k_hw
+ * @slot_time: Slot time in us
  *
  * Sets the global IFS intervals on DCU (also works on AR5210) for
  * the given slot time and the current bwmode.
@@ -597,7 +649,15 @@ int ath5k_hw_set_ifs_intervals(struct ath5k_hw *ah, unsigned int slot_time)
 }
 
 
-int ath5k_hw_init_queues(struct ath5k_hw *ah)
+/**
+ * ath5k_hw_init_queues() - Initialize tx queues
+ * @ah: The &struct ath5k_hw
+ *
+ * Initializes all tx queues based on information on
+ * ah->ah_txq* set by the driver
+ */
+int
+ath5k_hw_init_queues(struct ath5k_hw *ah)
 {
 	int i, ret;
 
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index de28be4..4aed3a3 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -19,9 +19,9 @@
  *
  */
 
-/*****************************\
-  Reset functions and helpers
-\*****************************/
+/****************************\
+  Reset function and helpers
+\****************************/
 
 #include <asm/unaligned.h>
 
@@ -33,14 +33,36 @@
 #include "debug.h"
 
 
+/**
+ * DOC: Reset function and helpers
+ *
+ * Here we implement the main reset routine, used to bring the card
+ * to a working state and ready to receive. We also handle routines
+ * that don't fit on other places such as clock, sleep and power control
+ */
+
+
 /******************\
 * Helper functions *
 \******************/
 
-/*
- * Check if a register write has been completed
+/**
+ * ath5k_hw_register_timeout() - Poll a register for a flag/field change
+ * @ah: The &struct ath5k_hw
+ * @reg: The register to read
+ * @flag: The flag/field to check on the register
+ * @val: The field value we expect (if we check a field)
+ * @is_set: Instead of checking if the flag got cleared, check if it got set
+ *
+ * Some registers contain flags that indicate that an operation is
+ * running. We use this function to poll these registers and check
+ * if these flags get cleared. We also use it to poll a register
+ * field (containing multiple flags) until it gets a specific value.
+ *
+ * Returns -EAGAIN if we exceeded AR5K_TUNE_REGISTER_TIMEOUT * 15us or 0
  */
-int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag, u32 val,
+int
+ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag, u32 val,
 			      bool is_set)
 {
 	int i;
@@ -64,35 +86,48 @@ int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag, u32 val,
 \*************************/
 
 /**
- * ath5k_hw_htoclock - Translate usec to hw clock units
- *
+ * ath5k_hw_htoclock() - Translate usec to hw clock units
  * @ah: The &struct ath5k_hw
  * @usec: value in microseconds
+ *
+ * Translate usecs to hw clock units based on the current
+ * hw clock rate.
+ *
+ * Returns number of clock units
  */
-unsigned int ath5k_hw_htoclock(struct ath5k_hw *ah, unsigned int usec)
+unsigned int
+ath5k_hw_htoclock(struct ath5k_hw *ah, unsigned int usec)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
 	return usec * common->clockrate;
 }
 
 /**
- * ath5k_hw_clocktoh - Translate hw clock units to usec
+ * ath5k_hw_clocktoh() - Translate hw clock units to usec
+ * @ah: The &struct ath5k_hw
  * @clock: value in hw clock units
+ *
+ * Translate hw clock units to usecs based on the current
+ * hw clock rate.
+ *
+ * Returns number of usecs
  */
-unsigned int ath5k_hw_clocktoh(struct ath5k_hw *ah, unsigned int clock)
+unsigned int
+ath5k_hw_clocktoh(struct ath5k_hw *ah, unsigned int clock)
 {
 	struct ath_common *common = ath5k_hw_common(ah);
 	return clock / common->clockrate;
 }
 
 /**
- * ath5k_hw_init_core_clock - Initialize core clock
- *
- * @ah The &struct ath5k_hw
+ * ath5k_hw_init_core_clock() - Initialize core clock
+ * @ah: The &struct ath5k_hw
  *
- * Initialize core clock parameters (usec, usec32, latencies etc).
+ * Initialize core clock parameters (usec, usec32, latencies etc),
+ * based on current bwmode and chipset properties.
  */
-static void ath5k_hw_init_core_clock(struct ath5k_hw *ah)
+static void
+ath5k_hw_init_core_clock(struct ath5k_hw *ah)
 {
 	struct ieee80211_channel *channel = ah->ah_current_channel;
 	struct ath_common *common = ath5k_hw_common(ah);
@@ -227,16 +262,21 @@ static void ath5k_hw_init_core_clock(struct ath5k_hw *ah)
 	}
 }
 
-/*
+/**
+ * ath5k_hw_set_sleep_clock() - Setup sleep clock operation
+ * @ah: The &struct ath5k_hw
+ * @enable: Enable sleep clock operation (false to disable)
+ *
  * If there is an external 32KHz crystal available, use it
  * as ref. clock instead of 32/40MHz clock and baseband clocks
  * to save power during sleep or restore normal 32/40MHz
  * operation.
  *
- * XXX: When operating on 32KHz certain PHY registers (27 - 31,
- *	123 - 127) require delay on access.
+ * NOTE: When operating on 32KHz certain PHY registers (27 - 31,
+ * 123 - 127) require delay on access.
  */
-static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
+static void
+ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 scal, spending, sclock;
@@ -340,10 +380,19 @@ static void ath5k_hw_set_sleep_clock(struct ath5k_hw *ah, bool enable)
 * Reset/Sleep control *
 \*********************/
 
-/*
- * Reset chipset
+/**
+ * ath5k_hw_nic_reset() - Reset the various chipset units
+ * @ah: The &struct ath5k_hw
+ * @val: Mask to indicate what units to reset
+ *
+ * To reset the various chipset units we need to write
+ * the mask to AR5K_RESET_CTL and poll the register until
+ * all flags are cleared.
+ *
+ * Returns 0 if we are O.K. or -EAGAIN (from athk5_hw_register_timeout)
  */
-static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
+static int
+ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
 {
 	int ret;
 	u32 mask = val ? val : ~0U;
@@ -382,12 +431,17 @@ static int ath5k_hw_nic_reset(struct ath5k_hw *ah, u32 val)
 	return ret;
 }
 
-/*
- * Reset AHB chipset
- * AR5K_RESET_CTL_PCU flag resets WMAC
- * AR5K_RESET_CTL_BASEBAND flag resets WBB
+/**
+ * ath5k_hw_wisoc_reset() -  Reset AHB chipset
+ * @ah: The &struct ath5k_hw
+ * @flags: Mask to indicate what units to reset
+ *
+ * Same as ath5k_hw_nic_reset but for AHB based devices
+ *
+ * Returns 0 if we are O.K. or -EAGAIN (from athk5_hw_register_timeout)
  */
-static int ath5k_hw_wisoc_reset(struct ath5k_hw *ah, u32 flags)
+static int
+ath5k_hw_wisoc_reset(struct ath5k_hw *ah, u32 flags)
 {
 	u32 mask = flags ? flags : ~0U;
 	u32 __iomem *reg;
@@ -439,11 +493,23 @@ static int ath5k_hw_wisoc_reset(struct ath5k_hw *ah, u32 flags)
 	return 0;
 }
 
-
-/*
- * Sleep control
+/**
+ * ath5k_hw_set_power_mode() - Set power mode
+ * @ah: The &struct ath5k_hw
+ * @mode: One of enum ath5k_power_mode
+ * @set_chip: Set to true to write sleep control register
+ * @sleep_duration: How much time the device is allowed to sleep
+ * when sleep logic is enabled (in 128 microsecond increments).
+ *
+ * This function is used to configure sleep policy and allowed
+ * sleep modes. For more information check out the sleep control
+ * register on reg.h and STA_ID1.
+ *
+ * Returns 0 on success, -EIO if chip didn't wake up or -EINVAL if an invalid
+ * mode is requested.
  */
-static int ath5k_hw_set_power(struct ath5k_hw *ah, enum ath5k_power_mode mode,
+static int
+ath5k_hw_set_power_mode(struct ath5k_hw *ah, enum ath5k_power_mode mode,
 			      bool set_chip, u16 sleep_duration)
 {
 	unsigned int i;
@@ -523,17 +589,20 @@ commit:
 	return 0;
 }
 
-/*
- * Put device on hold
+/**
+ * ath5k_hw_on_hold() - Put device on hold
+ * @ah: The &struct ath5k_hw
  *
- * Put MAC and Baseband on warm reset and
- * keep that state (don't clean sleep control
- * register). After this MAC and Baseband are
- * disabled and a full reset is needed to come
- * back. This way we save as much power as possible
+ * Put MAC and Baseband on warm reset and keep that state
+ * (don't clean sleep control register). After this MAC
+ * and Baseband are disabled and a full reset is needed
+ * to come back. This way we save as much power as possible
  * without putting the card on full sleep.
+ *
+ * Returns 0 on success or -EIO on error
  */
-int ath5k_hw_on_hold(struct ath5k_hw *ah)
+int
+ath5k_hw_on_hold(struct ath5k_hw *ah)
 {
 	struct pci_dev *pdev = ah->pdev;
 	u32 bus_flags;
@@ -543,7 +612,7 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 		return 0;
 
 	/* Make sure device is awake */
-	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
+	ret = ath5k_hw_set_power_mode(ah, AR5K_PM_AWAKE, true, 0);
 	if (ret) {
 		ATH5K_ERR(ah, "failed to wakeup the MAC Chip\n");
 		return ret;
@@ -575,7 +644,7 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 	}
 
 	/* ...wakeup again!*/
-	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
+	ret = ath5k_hw_set_power_mode(ah, AR5K_PM_AWAKE, true, 0);
 	if (ret) {
 		ATH5K_ERR(ah, "failed to put device on hold\n");
 		return ret;
@@ -584,11 +653,18 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 	return ret;
 }
 
-/*
+/**
+ * ath5k_hw_nic_wakeup() - Force card out of sleep
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ *
  * Bring up MAC + PHY Chips and program PLL
- * Channel is NULL for the initial wakeup.
+ * NOTE: Channel is NULL for the initial wakeup.
+ *
+ * Returns 0 on success, -EIO on hw failure or -EINVAL for false channel infos
  */
-int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, struct ieee80211_channel *channel)
+int
+ath5k_hw_nic_wakeup(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 {
 	struct pci_dev *pdev = ah->pdev;
 	u32 turbo, mode, clock, bus_flags;
@@ -600,7 +676,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 
 	if ((ath5k_get_bus_type(ah) != ATH_AHB) || channel) {
 		/* Wakeup the device */
-		ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
+		ret = ath5k_hw_set_power_mode(ah, AR5K_PM_AWAKE, true, 0);
 		if (ret) {
 			ATH5K_ERR(ah, "failed to wakeup the MAC Chip\n");
 			return ret;
@@ -637,7 +713,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 	}
 
 	/* ...wakeup again!...*/
-	ret = ath5k_hw_set_power(ah, AR5K_PM_AWAKE, true, 0);
+	ret = ath5k_hw_set_power_mode(ah, AR5K_PM_AWAKE, true, 0);
 	if (ret) {
 		ATH5K_ERR(ah, "failed to resume the MAC Chip\n");
 		return ret;
@@ -755,8 +831,19 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 * Post-initvals register modifications *
 \**************************************/
 
-/* TODO: Half/Quarter rate */
-static void ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
+/**
+ * ath5k_hw_tweak_initval_settings() - Tweak initial settings
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ *
+ * Some settings are not handled on initvals, e.g. bwmode
+ * settings, some phy settings, workarounds etc that in general
+ * don't fit anywhere else or are too small to introduce a separate
+ * function for each one. So we have this function to handle
+ * them all during reset and complete card's initialization.
+ */
+static void
+ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
 				struct ieee80211_channel *channel)
 {
 	if (ah->ah_version == AR5K_AR5212 &&
@@ -875,7 +962,16 @@ static void ath5k_hw_tweak_initval_settings(struct ath5k_hw *ah,
 	}
 }
 
-static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
+/**
+ * ath5k_hw_commit_eeprom_settings() - Commit settings from EEPROM
+ * @ah: The &struct ath5k_hw
+ * @channel: The &struct ieee80211_channel
+ *
+ * Use settings stored on EEPROM to properly initialize the card
+ * based on various infos and per-mode calibration data.
+ */
+static void
+ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
@@ -1029,7 +1125,23 @@ static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 * Main reset function *
 \*********************/
 
-int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
+/**
+ * ath5k_hw_reset() - The main reset function
+ * @ah: The &struct ath5k_hw
+ * @op_mode: One of enum nl80211_iftype
+ * @channel: The &struct ieee80211_channel
+ * @fast: Enable fast channel switching
+ * @skip_pcu: Skip pcu initialization
+ *
+ * This is the function we call each time we want to (re)initialize the
+ * card and pass new settings to hw. We also call it when hw runs into
+ * trouble to make it come back to a working state.
+ *
+ * Returns 0 on success, -EINVAL on false op_mode or channel infos, or -EIO
+ * on failure.
+ */
+int
+ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		struct ieee80211_channel *channel, bool fast, bool skip_pcu)
 {
 	u32 s_seq[10], s_led[3], tsf_up, tsf_lo;
@@ -1242,7 +1354,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	/*
 	 * Initialize PCU
 	 */
-	ath5k_hw_pcu_init(ah, op_mode, mode);
+	ath5k_hw_pcu_init(ah, op_mode);
 
 	/*
 	 * Initialize PHY
diff --git a/drivers/net/wireless/ath/ath5k/rfbuffer.h b/drivers/net/wireless/ath/ath5k/rfbuffer.h
index 5d11c23..aed34d9 100644
--- a/drivers/net/wireless/ath/ath5k/rfbuffer.h
+++ b/drivers/net/wireless/ath/ath5k/rfbuffer.h
@@ -18,7 +18,9 @@
  */
 
 
-/*
+/**
+ * DOC: RF Buffer registers
+ *
  * There are some special registers on the RF chip
  * that control various operation settings related mostly to
  * the analog parts (channel, gain adjustment etc).
@@ -44,40 +46,63 @@
  */
 
 
-/*
+/**
+ * struct ath5k_ini_rfbuffer - Initial RF Buffer settings
+ * @rfb_bank: RF Bank number
+ * @rfb_ctrl_register: RF Buffer control register
+ * @rfb_mode_data: RF Buffer data for each mode
+ *
  * Struct to hold default mode specific RF
- * register values (RF Banks)
+ * register values (RF Banks) for each chip.
  */
 struct ath5k_ini_rfbuffer {
-	u8	rfb_bank;		/* RF Bank number */
-	u16	rfb_ctrl_register;	/* RF Buffer control register */
-	u32	rfb_mode_data[3];	/* RF Buffer data for each mode */
+	u8	rfb_bank;
+	u16	rfb_ctrl_register;
+	u32	rfb_mode_data[3];
 };
 
-/*
+/**
+ * struct ath5k_rfb_field - An RF Buffer field (register/value)
+ * @len: Field length
+ * @pos: Offset on the raw packet
+ * @col: Used for shifting
+ *
  * Struct to hold RF Buffer field
  * infos used to access certain RF
  * analog registers
  */
 struct ath5k_rfb_field {
-	u8	len;	/* Field length */
-	u16	pos;	/* Offset on the raw packet */
-	u8	col;	/* Column -used for shifting */
+	u8	len;
+	u16	pos;
+	u8	col;
 };
 
-/*
- * RF analog register definition
+/**
+ * struct ath5k_rf_reg - RF analog register definition
+ * @bank: RF Buffer Bank number
+ * @index: Register's index on ath5k_rf_regx_idx
+ * @field: The &struct ath5k_rfb_field
+ *
+ * We use this struct to define the set of RF registers
+ * on each chip that we want to tweak. Some RF registers
+ * are common between different chip versions so this saves
+ * us space and complexity because we can refer to an rf
+ * register by it's index no matter what chip we work with
+ * as long as it has that register.
  */
 struct ath5k_rf_reg {
-	u8			bank;	/* RF Buffer Bank number */
-	u8			index;	/* Register's index on rf_regs_idx */
-	struct ath5k_rfb_field	field;	/* RF Buffer field for this register */
+	u8			bank;
+	u8			index;
+	struct ath5k_rfb_field	field;
 };
 
-/* Map RF registers to indexes
+/**
+ * enum ath5k_rf_regs_idx - Map RF registers to indexes
+ *
  * We do this to handle common bits and make our
  * life easier by using an index for each register
- * instead of a full rfb_field */
+ * instead of a full rfb_field
+ */
 enum ath5k_rf_regs_idx {
 	/* BANK 2 */
 	AR5K_RF_TURBO = 0,
diff --git a/drivers/net/wireless/ath/ath5k/rfgain.h b/drivers/net/wireless/ath/ath5k/rfgain.h
index ebfae05..4d21df0 100644
--- a/drivers/net/wireless/ath/ath5k/rfgain.h
+++ b/drivers/net/wireless/ath/ath5k/rfgain.h
@@ -18,13 +18,17 @@
  *
  */
 
-/*
+/**
+ * struct ath5k_ini_rfgain - RF Gain table
+ * @rfg_register: RF Gain register address
+ * @rfg_value: Register value for 5 and 2GHz
+ *
  * Mode-specific RF Gain table (64bytes) for RF5111/5112
  * (RF5110 only comes with AR5210 and only supports a/turbo a mode so initial
  * RF Gain values are included in AR5K_AR5210_INI)
  */
 struct ath5k_ini_rfgain {
-	u16	rfg_register;	/* RF Gain register address */
+	u16	rfg_register;
 	u32	rfg_value[2];	/* [freq (see below)] */
 };
 
@@ -455,18 +459,31 @@ static const struct ath5k_ini_rfgain rfgain_2425[] = {
 #define AR5K_GAIN_CHECK_ADJUST(_g)		\
 	((_g)->g_current <= (_g)->g_low || (_g)->g_current >= (_g)->g_high)
 
+/**
+ * struct ath5k_gain_opt_step - An RF gain optimization step
+ * @gos_param: Set of parameters
+ * @gos_gain: Gain
+ */
 struct ath5k_gain_opt_step {
 	s8				gos_param[AR5K_GAIN_CRN_MAX_FIX_BITS];
 	s8				gos_gain;
 };
 
+/**
+ * struct ath5k_gain_opt - RF Gain optimization ladder
+ * @go_default: The default step
+ * @go_steps_count: How many optimization steps
+ * @go_step: Array of &struct ath5k_gain_opt_step
+ */
 struct ath5k_gain_opt {
 	u8				go_default;
 	u8				go_steps_count;
 	const struct ath5k_gain_opt_step	go_step[AR5K_GAIN_STEP_COUNT];
 };
 
+
 /*
+ * RF5111
  * Parameters on gos_param:
  * 1) Tx clip PHY register
  * 2) PWD 90 RF register
@@ -490,6 +507,7 @@ static const struct ath5k_gain_opt rfgain_opt_5111 = {
 };
 
 /*
+ * RF5112
  * Parameters on gos_param:
  * 1) Mixgain ovr RF register
  * 2) PWD 138 RF register
-- 
1.7.8.rc3

