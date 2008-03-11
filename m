Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41682 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbYCKXSN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 19:18:13 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Assaf Krauss <assaf.krauss@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 4/6] iwlwifi: Use eeprom form iwlcore
Date: Tue, 11 Mar 2008 16:17:18 -0700
Message-Id: <1205277440-14323-5-git-send-email-reinette.chatre@intel.com> (sfid-20080311_231833_075671_34F86358)
In-Reply-To: <1205277440-14323-4-git-send-email-reinette.chatre@intel.com>
References: <1205277440-14323-1-git-send-email-reinette.chatre@intel.com>
 <1205277440-14323-2-git-send-email-reinette.chatre@intel.com>
 <1205277440-14323-3-git-send-email-reinette.chatre@intel.com>
 <1205277440-14323-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch puts in use eeprom from iwlcore module

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |  310 ---------------------------
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   45 ++---
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.h     |   10 +
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   84 +-------
 7 files changed, 30 insertions(+), 426 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 6b85cca..59d9c90 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,5 +1,5 @@
 obj-$(CONFIG_IWLCORE)	+= iwlcore.o
-iwlcore-objs 		= iwl-core.o
+iwlcore-objs 		= iwl-core.o iwl-eeprom.o
 
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 4a29b44..c66993e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -92,316 +92,6 @@
 /* RSSI to dBm */
 #define IWL_RSSI_OFFSET	44
 
-/*
- * EEPROM related constants, enums, and structures.
- */
-
-/*
- * EEPROM access time values:
- *
- * Driver initiates EEPROM read by writing byte address << 1 to CSR_EEPROM_REG,
- *   then clearing (with subsequent read/modify/write) CSR_EEPROM_REG bit
- *   CSR_EEPROM_REG_BIT_CMD (0x2).
- * Driver then polls CSR_EEPROM_REG for CSR_EEPROM_REG_READ_VALID_MSK (0x1).
- * When polling, wait 10 uSec between polling loops, up to a maximum 5000 uSec.
- * Driver reads 16-bit value from bits 31-16 of CSR_EEPROM_REG.
- */
-#define IWL_EEPROM_ACCESS_TIMEOUT	5000 /* uSec */
-#define IWL_EEPROM_ACCESS_DELAY		10   /* uSec */
-
-/*
- * Regulatory channel usage flags in EEPROM struct iwl4965_eeprom_channel.flags.
- *
- * IBSS and/or AP operation is allowed *only* on those channels with
- * (VALID && IBSS && ACTIVE && !RADAR).  This restriction is in place because
- * RADAR detection is not supported by the 4965 driver, but is a
- * requirement for establishing a new network for legal operation on channels
- * requiring RADAR detection or restricting ACTIVE scanning.
- *
- * NOTE:  "WIDE" flag does not indicate anything about "FAT" 40 MHz channels.
- *        It only indicates that 20 MHz channel use is supported; FAT channel
- *        usage is indicated by a separate set of regulatory flags for each
- *        FAT channel pair.
- *
- * NOTE:  Using a channel inappropriately will result in a uCode error!
- */
-enum {
-	EEPROM_CHANNEL_VALID = (1 << 0),	/* usable for this SKU/geo */
-	EEPROM_CHANNEL_IBSS = (1 << 1),		/* usable as an IBSS channel */
-	/* Bit 2 Reserved */
-	EEPROM_CHANNEL_ACTIVE = (1 << 3),	/* active scanning allowed */
-	EEPROM_CHANNEL_RADAR = (1 << 4),	/* radar detection required */
-	EEPROM_CHANNEL_WIDE = (1 << 5),		/* 20 MHz channel okay */
-	EEPROM_CHANNEL_NARROW = (1 << 6),	/* 10 MHz channel (not used) */
-	EEPROM_CHANNEL_DFS = (1 << 7),	/* dynamic freq selection candidate */
-};
-
-/* SKU Capabilities */
-#define EEPROM_SKU_CAP_SW_RF_KILL_ENABLE                (1 << 0)
-#define EEPROM_SKU_CAP_HW_RF_KILL_ENABLE                (1 << 1)
-
-/* *regulatory* channel data format in eeprom, one for each channel.
- * There are separate entries for FAT (40 MHz) vs. normal (20 MHz) channels. */
-struct iwl4965_eeprom_channel {
-	u8 flags;		/* EEPROM_CHANNEL_* flags copied from EEPROM */
-	s8 max_power_avg;	/* max power (dBm) on this chnl, limit 31 */
-} __attribute__ ((packed));
-
-/* 4965 has two radio transmitters (and 3 radio receivers) */
-#define EEPROM_TX_POWER_TX_CHAINS      (2)
-
-/* 4965 has room for up to 8 sets of txpower calibration data */
-#define EEPROM_TX_POWER_BANDS          (8)
-
-/* 4965 factory calibration measures txpower gain settings for
- * each of 3 target output levels */
-#define EEPROM_TX_POWER_MEASUREMENTS   (3)
-
-/* 4965 driver does not work with txpower calibration version < 5.
- * Look for this in calib_version member of struct iwl4965_eeprom. */
-#define EEPROM_TX_POWER_VERSION_NEW    (5)
-
-
-/*
- * 4965 factory calibration data for one txpower level, on one channel,
- * measured on one of the 2 tx chains (radio transmitter and associated
- * antenna).  EEPROM contains:
- *
- * 1)  Temperature (degrees Celsius) of device when measurement was made.
- *
- * 2)  Gain table index used to achieve the target measurement power.
- *     This refers to the "well-known" gain tables (see iwl-4965-hw.h).
- *
- * 3)  Actual measured output power, in half-dBm ("34" = 17 dBm).
- *
- * 4)  RF power amplifier detector level measurement (not used).
- */
-struct iwl4965_eeprom_calib_measure {
-	u8 temperature;		/* Device temperature (Celsius) */
-	u8 gain_idx;		/* Index into gain table */
-	u8 actual_pow;		/* Measured RF output power, half-dBm */
-	s8 pa_det;		/* Power amp detector level (not used) */
-} __attribute__ ((packed));
-
-
-/*
- * 4965 measurement set for one channel.  EEPROM contains:
- *
- * 1)  Channel number measured
- *
- * 2)  Measurements for each of 3 power levels for each of 2 radio transmitters
- *     (a.k.a. "tx chains") (6 measurements altogether)
- */
-struct iwl4965_eeprom_calib_ch_info {
-	u8 ch_num;
-	struct iwl4965_eeprom_calib_measure measurements[EEPROM_TX_POWER_TX_CHAINS]
-		[EEPROM_TX_POWER_MEASUREMENTS];
-} __attribute__ ((packed));
-
-/*
- * 4965 txpower subband info.
- *
- * For each frequency subband, EEPROM contains the following:
- *
- * 1)  First and last channels within range of the subband.  "0" values
- *     indicate that this sample set is not being used.
- *
- * 2)  Sample measurement sets for 2 channels close to the range endpoints.
- */
-struct iwl4965_eeprom_calib_subband_info {
-	u8 ch_from;	/* channel number of lowest channel in subband */
-	u8 ch_to;	/* channel number of highest channel in subband */
-	struct iwl4965_eeprom_calib_ch_info ch1;
-	struct iwl4965_eeprom_calib_ch_info ch2;
-} __attribute__ ((packed));
-
-
-/*
- * 4965 txpower calibration info.  EEPROM contains:
- *
- * 1)  Factory-measured saturation power levels (maximum levels at which
- *     tx power amplifier can output a signal without too much distortion).
- *     There is one level for 2.4 GHz band and one for 5 GHz band.  These
- *     values apply to all channels within each of the bands.
- *
- * 2)  Factory-measured power supply voltage level.  This is assumed to be
- *     constant (i.e. same value applies to all channels/bands) while the
- *     factory measurements are being made.
- *
- * 3)  Up to 8 sets of factory-measured txpower calibration values.
- *     These are for different frequency ranges, since txpower gain
- *     characteristics of the analog radio circuitry vary with frequency.
- *
- *     Not all sets need to be filled with data;
- *     struct iwl4965_eeprom_calib_subband_info contains range of channels
- *     (0 if unused) for each set of data.
- */
-struct iwl4965_eeprom_calib_info {
-	u8 saturation_power24;	/* half-dBm (e.g. "34" = 17 dBm) */
-	u8 saturation_power52;	/* half-dBm */
-	s16 voltage;		/* signed */
-	struct iwl4965_eeprom_calib_subband_info band_info[EEPROM_TX_POWER_BANDS];
-} __attribute__ ((packed));
-
-
-/*
- * 4965 EEPROM map
- */
-struct iwl4965_eeprom {
-	u8 reserved0[16];
-#define EEPROM_DEVICE_ID                    (2*0x08)	/* 2 bytes */
-	u16 device_id;		/* abs.ofs: 16 */
-	u8 reserved1[2];
-#define EEPROM_PMC                          (2*0x0A)	/* 2 bytes */
-	u16 pmc;		/* abs.ofs: 20 */
-	u8 reserved2[20];
-#define EEPROM_MAC_ADDRESS                  (2*0x15)	/* 6  bytes */
-	u8 mac_address[6];	/* abs.ofs: 42 */
-	u8 reserved3[58];
-#define EEPROM_BOARD_REVISION               (2*0x35)	/* 2  bytes */
-	u16 board_revision;	/* abs.ofs: 106 */
-	u8 reserved4[11];
-#define EEPROM_BOARD_PBA_NUMBER             (2*0x3B+1)	/* 9  bytes */
-	u8 board_pba_number[9];	/* abs.ofs: 119 */
-	u8 reserved5[8];
-#define EEPROM_VERSION                      (2*0x44)	/* 2  bytes */
-	u16 version;		/* abs.ofs: 136 */
-#define EEPROM_SKU_CAP                      (2*0x45)	/* 1  bytes */
-	u8 sku_cap;		/* abs.ofs: 138 */
-#define EEPROM_LEDS_MODE                    (2*0x45+1)	/* 1  bytes */
-	u8 leds_mode;		/* abs.ofs: 139 */
-#define EEPROM_OEM_MODE                     (2*0x46)	/* 2  bytes */
-	u16 oem_mode;
-#define EEPROM_WOWLAN_MODE                  (2*0x47)	/* 2  bytes */
-	u16 wowlan_mode;	/* abs.ofs: 142 */
-#define EEPROM_LEDS_TIME_INTERVAL           (2*0x48)	/* 2  bytes */
-	u16 leds_time_interval;	/* abs.ofs: 144 */
-#define EEPROM_LEDS_OFF_TIME                (2*0x49)	/* 1  bytes */
-	u8 leds_off_time;	/* abs.ofs: 146 */
-#define EEPROM_LEDS_ON_TIME                 (2*0x49+1)	/* 1  bytes */
-	u8 leds_on_time;	/* abs.ofs: 147 */
-#define EEPROM_ALMGOR_M_VERSION             (2*0x4A)	/* 1  bytes */
-	u8 almgor_m_version;	/* abs.ofs: 148 */
-#define EEPROM_ANTENNA_SWITCH_TYPE          (2*0x4A+1)	/* 1  bytes */
-	u8 antenna_switch_type;	/* abs.ofs: 149 */
-	u8 reserved6[8];
-#define EEPROM_4965_BOARD_REVISION          (2*0x4F)	/* 2 bytes */
-	u16 board_revision_4965;	/* abs.ofs: 158 */
-	u8 reserved7[13];
-#define EEPROM_4965_BOARD_PBA               (2*0x56+1)	/* 9 bytes */
-	u8 board_pba_number_4965[9];	/* abs.ofs: 173 */
-	u8 reserved8[10];
-#define EEPROM_REGULATORY_SKU_ID            (2*0x60)	/* 4  bytes */
-	u8 sku_id[4];		/* abs.ofs: 192 */
-
-/*
- * Per-channel regulatory data.
- *
- * Each channel that *might* be supported by 3945 or 4965 has a fixed location
- * in EEPROM containing EEPROM_CHANNEL_* usage flags (LSB) and max regulatory
- * txpower (MSB).
- *
- * Entries immediately below are for 20 MHz channel width.  FAT (40 MHz)
- * channels (only for 4965, not supported by 3945) appear later in the EEPROM.
- *
- * 2.4 GHz channels 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
- */
-#define EEPROM_REGULATORY_BAND_1            (2*0x62)	/* 2  bytes */
-	u16 band_1_count;	/* abs.ofs: 196 */
-#define EEPROM_REGULATORY_BAND_1_CHANNELS   (2*0x63)	/* 28 bytes */
-	struct iwl4965_eeprom_channel band_1_channels[14]; /* abs.ofs: 196 */
-
-/*
- * 4.9 GHz channels 183, 184, 185, 187, 188, 189, 192, 196,
- * 5.0 GHz channels 7, 8, 11, 12, 16
- * (4915-5080MHz) (none of these is ever supported)
- */
-#define EEPROM_REGULATORY_BAND_2            (2*0x71)	/* 2  bytes */
-	u16 band_2_count;	/* abs.ofs: 226 */
-#define EEPROM_REGULATORY_BAND_2_CHANNELS   (2*0x72)	/* 26 bytes */
-	struct iwl4965_eeprom_channel band_2_channels[13]; /* abs.ofs: 228 */
-
-/*
- * 5.2 GHz channels 34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
- * (5170-5320MHz)
- */
-#define EEPROM_REGULATORY_BAND_3            (2*0x7F)	/* 2  bytes */
-	u16 band_3_count;	/* abs.ofs: 254 */
-#define EEPROM_REGULATORY_BAND_3_CHANNELS   (2*0x80)	/* 24 bytes */
-	struct iwl4965_eeprom_channel band_3_channels[12]; /* abs.ofs: 256 */
-
-/*
- * 5.5 GHz channels 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140
- * (5500-5700MHz)
- */
-#define EEPROM_REGULATORY_BAND_4            (2*0x8C)	/* 2  bytes */
-	u16 band_4_count;	/* abs.ofs: 280 */
-#define EEPROM_REGULATORY_BAND_4_CHANNELS   (2*0x8D)	/* 22 bytes */
-	struct iwl4965_eeprom_channel band_4_channels[11]; /* abs.ofs: 282 */
-
-/*
- * 5.7 GHz channels 145, 149, 153, 157, 161, 165
- * (5725-5825MHz)
- */
-#define EEPROM_REGULATORY_BAND_5            (2*0x98)	/* 2  bytes */
-	u16 band_5_count;	/* abs.ofs: 304 */
-#define EEPROM_REGULATORY_BAND_5_CHANNELS   (2*0x99)	/* 12 bytes */
-	struct iwl4965_eeprom_channel band_5_channels[6]; /* abs.ofs: 306 */
-
-	u8 reserved10[2];
-
-
-/*
- * 2.4 GHz FAT channels 1 (5), 2 (6), 3 (7), 4 (8), 5 (9), 6 (10), 7 (11)
- *
- * The channel listed is the center of the lower 20 MHz half of the channel.
- * The overall center frequency is actually 2 channels (10 MHz) above that,
- * and the upper half of each FAT channel is centered 4 channels (20 MHz) away
- * from the lower half; e.g. the upper half of FAT channel 1 is channel 5,
- * and the overall FAT channel width centers on channel 3.
- *
- * NOTE:  The RXON command uses 20 MHz channel numbers to specify the
- *        control channel to which to tune.  RXON also specifies whether the
- *        control channel is the upper or lower half of a FAT channel.
- *
- * NOTE:  4965 does not support FAT channels on 2.4 GHz.
- */
-#define EEPROM_REGULATORY_BAND_24_FAT_CHANNELS (2*0xA0)	/* 14 bytes */
-	struct iwl4965_eeprom_channel band_24_channels[7]; /* abs.ofs: 320 */
-	u8 reserved11[2];
-
-/*
- * 5.2 GHz FAT channels 36 (40), 44 (48), 52 (56), 60 (64),
- * 100 (104), 108 (112), 116 (120), 124 (128), 132 (136), 149 (153), 157 (161)
- */
-#define EEPROM_REGULATORY_BAND_52_FAT_CHANNELS (2*0xA8)	/* 22 bytes */
-	struct iwl4965_eeprom_channel band_52_channels[11]; /* abs.ofs: 336 */
-	u8 reserved12[6];
-
-/*
- * 4965 driver requires txpower calibration format version 5 or greater.
- * Driver does not work with txpower calibration version < 5.
- * This value is simply a 16-bit number, no major/minor versions here.
- */
-#define EEPROM_CALIB_VERSION_OFFSET            (2*0xB6)	/* 2 bytes */
-	u16 calib_version;	/* abs.ofs: 364 */
-	u8 reserved13[2];
-	u8 reserved14[96];	/* abs.ofs: 368 */
-
-/*
- * 4965 Txpower calibration data.
- */
-#define EEPROM_IWL_CALIB_TXPOWER_OFFSET        (2*0xE8)	/* 48  bytes */
-	struct iwl4965_eeprom_calib_info calib_info;	/* abs.ofs: 464 */
-
-	u8 reserved16[140];	/* fill out to full 1024 byte block */
-
-
-} __attribute__ ((packed));
-
-#define IWL_EEPROM_IMAGE_SIZE 1024
-
-/* End of EEPROM */
 
 #include "iwl-4965-commands.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index a79e8c3..dc55ff2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -38,6 +38,7 @@
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
 
+#include "iwl-eeprom.h"
 #include "iwl-core.h"
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
@@ -4824,10 +4825,23 @@ void iwl4965_hw_cancel_deferred_work(struct iwl4965_priv *priv)
 	cancel_delayed_work(&priv->init_alive_start);
 }
 
+static struct iwl_lib_ops iwl4965_lib = {
+	.eeprom_ops = {
+		.verify_signature  = iwlcore_eeprom_verify_signature,
+		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
+		.release_semaphore = iwlcore_eeprom_release_semaphore,
+	},
+};
+
+static struct iwl_ops iwl4965_ops = {
+	.lib = &iwl4965_lib,
+};
+
 static struct iwl_cfg iwl4965_agn_cfg = {
 	.name = "4965AGN",
 	.fw_name = "iwlwifi-4965" IWL4965_UCODE_API ".ucode",
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl4965_ops,
 };
 
 struct pci_device_id iwl4965_hw_card_ids[] = {
@@ -4836,35 +4850,4 @@ struct pci_device_id iwl4965_hw_card_ids[] = {
 	{0}
 };
 
-/*
- * The device's EEPROM semaphore prevents conflicts between driver and uCode
- * when accessing the EEPROM; each access is a series of pulses to/from the
- * EEPROM chip, not a single event, so even reads could conflict if they
- * weren't arbitrated by the semaphore.
- */
-int iwl4965_eeprom_acquire_semaphore(struct iwl4965_priv *priv)
-{
-	u16 count;
-	int rc;
-
-	for (count = 0; count < EEPROM_SEM_RETRY_LIMIT; count++) {
-		/* Request semaphore */
-		iwl4965_set_bit(priv, CSR_HW_IF_CONFIG_REG,
-			CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
-
-		/* See if we got it */
-		rc = iwl4965_poll_bit(priv, CSR_HW_IF_CONFIG_REG,
-					CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
-					CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM,
-					EEPROM_SEM_TIMEOUT);
-		if (rc >= 0) {
-			IWL_DEBUG_IO("Acquired semaphore after %d tries.\n",
-				count+1);
-			return rc;
-		}
-	}
-
-	return rc;
-}
-
 MODULE_DEVICE_TABLE(pci, iwl4965_hw_card_ids);
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 6ce4081..f4e395f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -40,6 +40,7 @@
 extern struct pci_device_id iwl4965_hw_card_ids[];
 
 #define DRV_NAME        "iwl4965"
+#include "iwl-eeprom.h"
 #include "iwl-4965-hw.h"
 #include "iwl-csr.h"
 #include "iwl-prph.h"
@@ -640,7 +641,6 @@ extern u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr,
 extern int iwl4965_is_network_packet(struct iwl4965_priv *priv,
 				 struct ieee80211_hdr *header);
 extern int iwl4965_power_init_handle(struct iwl4965_priv *priv);
-extern int iwl4965_eeprom_init(struct iwl4965_priv *priv);
 extern void iwl4965_handle_data_packet_monitor(struct iwl4965_priv *priv,
 					   struct iwl4965_rx_mem_buffer *rxb,
 					   void *data, short len,
@@ -746,8 +746,6 @@ struct iwl4965_priv;
 /*
  * Forward declare iwl-4965.c functions for iwl-base.c
  */
-extern int iwl4965_eeprom_acquire_semaphore(struct iwl4965_priv *priv);
-
 extern int iwl4965_tx_queue_update_wr_ptr(struct iwl4965_priv *priv,
 					  struct iwl4965_tx_queue *txq,
 					  u16 byte_cnt);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index b8383c8..9ca5398 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -31,6 +31,7 @@
 #include <linux/version.h>
 
 #include "iwl-4965-debug.h"
+#include "iwl-eeprom.h"
 #include "iwl-core.h"
 
 MODULE_DESCRIPTION("iwl core");
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index bdd32f8..88fd49a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -75,10 +75,20 @@
 #define IWL_SKU_A       0x2
 #define IWL_SKU_N       0x8
 
+struct iwl_lib_ops {
+	/* eeprom operations (as defined in iwl-eeprom.h) */
+	struct iwl_eeprom_ops eeprom_ops;
+};
+
+struct iwl_ops {
+	const struct iwl_lib_ops *lib;
+};
+
 struct iwl_cfg {
 	const char *name;
 	const char *fw_name;
 	unsigned int sku;
+	const struct iwl_ops *ops;
 };
 
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 090df36..7dd1548 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -45,6 +45,7 @@
 
 #include <asm/div64.h>
 
+#include "iwl-eeprom.h"
 #include "iwl-core.h"
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
@@ -1562,85 +1563,6 @@ static int iwl4965_send_beacon_cmd(struct iwl4965_priv *priv)
 
 /******************************************************************************
  *
- * EEPROM related functions
- *
- ******************************************************************************/
-
-static void get_eeprom_mac(struct iwl4965_priv *priv, u8 *mac)
-{
-	memcpy(mac, priv->eeprom.mac_address, 6);
-}
-
-static inline void iwl4965_eeprom_release_semaphore(struct iwl4965_priv *priv)
-{
-	iwl4965_clear_bit(priv, CSR_HW_IF_CONFIG_REG,
-		CSR_HW_IF_CONFIG_REG_BIT_EEPROM_OWN_SEM);
-}
-
-/**
- * iwl4965_eeprom_init - read EEPROM contents
- *
- * Load the EEPROM contents from adapter into priv->eeprom
- *
- * NOTE:  This routine uses the non-debug IO access functions.
- */
-int iwl4965_eeprom_init(struct iwl4965_priv *priv)
-{
-	u16 *e = (u16 *)&priv->eeprom;
-	u32 gp = iwl4965_read32(priv, CSR_EEPROM_GP);
-	u32 r;
-	int sz = sizeof(priv->eeprom);
-	int rc;
-	int i;
-	u16 addr;
-
-	/* The EEPROM structure has several padding buffers within it
-	 * and when adding new EEPROM maps is subject to programmer errors
-	 * which may be very difficult to identify without explicitly
-	 * checking the resulting size of the eeprom map. */
-	BUILD_BUG_ON(sizeof(priv->eeprom) != IWL_EEPROM_IMAGE_SIZE);
-
-	if ((gp & CSR_EEPROM_GP_VALID_MSK) == CSR_EEPROM_GP_BAD_SIGNATURE) {
-		IWL_ERROR("EEPROM not found, EEPROM_GP=0x%08x", gp);
-		return -ENOENT;
-	}
-
-	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
-	rc = iwl4965_eeprom_acquire_semaphore(priv);
-	if (rc < 0) {
-		IWL_ERROR("Failed to acquire EEPROM semaphore.\n");
-		return -ENOENT;
-	}
-
-	/* eeprom is an array of 16bit values */
-	for (addr = 0; addr < sz; addr += sizeof(u16)) {
-		_iwl4965_write32(priv, CSR_EEPROM_REG, addr << 1);
-		_iwl4965_clear_bit(priv, CSR_EEPROM_REG, CSR_EEPROM_REG_BIT_CMD);
-
-		for (i = 0; i < IWL_EEPROM_ACCESS_TIMEOUT;
-					i += IWL_EEPROM_ACCESS_DELAY) {
-			r = _iwl4965_read_direct32(priv, CSR_EEPROM_REG);
-			if (r & CSR_EEPROM_REG_READ_VALID_MSK)
-				break;
-			udelay(IWL_EEPROM_ACCESS_DELAY);
-		}
-
-		if (!(r & CSR_EEPROM_REG_READ_VALID_MSK)) {
-			IWL_ERROR("Time out reading EEPROM[%d]", addr);
-			rc = -ETIMEDOUT;
-			goto done;
-		}
-		e[addr / 2] = le16_to_cpu((__force __le16)(r >> 16));
-	}
-	rc = 0;
-
-done:
-	iwl4965_eeprom_release_semaphore(priv);
-	return rc;
-}
-
-/******************************************************************************
- *
  * Misc. internal state and helper functions
  *
  ******************************************************************************/
@@ -8770,13 +8692,13 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 		goto out_remove_sysfs;
         }
 	/* Read the EEPROM */
-	err = iwl4965_eeprom_init(priv);
+	err = iwl_eeprom_init(priv);
 	if (err) {
 		IWL_ERROR("Unable to init EEPROM\n");
 		goto out_remove_sysfs;
 	}
 	/* MAC Address location in EEPROM same for 3945/4965 */
-	get_eeprom_mac(priv, priv->mac_addr);
+	iwl_eeprom_get_mac(priv, priv->mac_addr);
 	IWL_DEBUG_INFO("MAC address: %s\n", print_mac(mac, priv->mac_addr));
 	SET_IEEE80211_PERM_ADDR(priv->hw, priv->mac_addr);
 
-- 
1.5.3.4

