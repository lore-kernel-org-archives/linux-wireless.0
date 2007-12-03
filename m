Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34002 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbXLCLpO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:45:14 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, yi.zhu@intel.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ben Cahill <ben.m.cahill@intel.com>
Subject: [PATCH 21/34] iwlwifi: document txpower calculations
Date: Mon,  3 Dec 2007 13:43:33 +0200
Message-Id: <11966822311498-git-send-email-tomas.winkler@intel.com> (sfid-20071203_120600_917974_28B0995F)
In-Reply-To: <11966822314158-git-send-email-tomas.winkler@intel.com>
References: <11966822261109-git-send-email-tomas.winkler@intel.com>
 <11966822291406-git-send-email-tomas.winkler@intel.com>
 <1196682229843-git-send-email-tomas.winkler@intel.com>
 <11966822293932-git-send-email-tomas.winkler@intel.com>
 <11966822291956-git-send-email-tomas.winkler@intel.com>
 <119668222978-git-send-email-tomas.winkler@intel.com>
 <11966822293340-git-send-email-tomas.winkler@intel.com>
 <11966822291143-git-send-email-tomas.winkler@intel.com>
 <11966822301152-git-send-email-tomas.winkler@intel.com>
 <11966822302864-git-send-email-tomas.winkler@intel.com>
 <1196682230902-git-send-email-tomas.winkler@intel.com>
 <11966822302932-git-send-email-tomas.winkler@intel.com>
 <11966822302681-git-send-email-tomas.winkler@intel.com>
 <11966822301936-git-send-email-tomas.winkler@intel.com>
 <11966822302007-git-send-email-tomas.winkler@intel.com>
 <1196682230754-git-send-email-tomas.winkler@intel.com>
 <1196682231211-git-send-email-tomas.winkler@intel.com>
 <11966822313647-git-send-email-tomas.winkler@intel.com>
 <11966822312049-git-send-email-tomas.winkler@intel.com>
 <11966822311588-git-send-email-tomas.winkler@intel.com>
 <11966822314158-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Document txpower calculations

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |  575 +++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-4965.h    |    3 -
 2 files changed, 562 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 412becf..e02860c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -647,7 +647,7 @@ static inline int iwl4965_hw_valid_rtc_data_addr(u32 addr)
 
 /********************* START TEMPERATURE *************************************/
 
-/*
+/**
  * 4965 temperature calculation.
  *
  * The driver must calculate the device temperature before calculating
@@ -693,44 +693,593 @@ static inline int iwl4965_hw_valid_rtc_data_addr(u32 addr)
 
 /********************* START TXPOWER *****************************************/
 
-enum {
-	CALIB_CH_GROUP_1 = 0,
-	CALIB_CH_GROUP_2 = 1,
-	CALIB_CH_GROUP_3 = 2,
-	CALIB_CH_GROUP_4 = 3,
-	CALIB_CH_GROUP_5 = 4,
-	CALIB_CH_GROUP_MAX
-};
+/**
+ * 4965 txpower calculations rely on information from three sources:
+ *
+ *     1) EEPROM
+ *     2) "initialize" alive notification
+ *     3) statistics notifications
+ *
+ * EEPROM data consists of:
+ *
+ * 1)  Regulatory information (max txpower and channel usage flags) is provided
+ *     separately for each channel that can possibly supported by 4965.
+ *     40 MHz wide (.11n fat) channels are listed separately from 20 MHz
+ *     (legacy) channels.
+ *
+ *     See struct iwl4965_eeprom_channel for format, and struct iwl4965_eeprom
+ *     for locations in EEPROM.
+ *
+ * 2)  Factory txpower calibration information is provided separately for
+ *     sub-bands of contiguous channels.  2.4GHz has just one sub-band,
+ *     but 5 GHz has several sub-bands.
+ *
+ *     In addition, per-band (2.4 and 5 Ghz) saturation txpowers are provided.
+ *
+ *     See struct iwl4965_eeprom_calib_info (and the tree of structures
+ *     contained within it) for format, and struct iwl4965_eeprom for
+ *     locations in EEPROM.
+ *
+ * "Initialization alive" notification (see struct iwl4965_init_alive_resp)
+ * consists of:
+ *
+ * 1)  Temperature calculation parameters.
+ *
+ * 2)  Power supply voltage measurement.
+ *
+ * 3)  Tx gain compensation to balance 2 transmitters for MIMO use.
+ *
+ * Statistics notifications deliver:
+ *
+ * 1)  Current values for temperature param R4.
+ */
 
-#define IWL_TX_POWER_MIMO_REGULATORY_COMPENSATION (6)
+/**
+ * To calculate a txpower setting for a given desired target txpower, channel,
+ * modulation bit rate, and transmitter chain (4965 has 2 transmitters to
+ * support MIMO and transmit diversity), driver must do the following:
+ *
+ * 1)  Compare desired txpower vs. (EEPROM) regulatory limit for this channel.
+ *     Do not exceed regulatory limit; reduce target txpower if necessary.
+ *
+ *     If setting up txpowers for MIMO rates (rate indexes 8-15, 24-31),
+ *     2 transmitters will be used simultaneously; driver must reduce the
+ *     regulatory limit by 3 dB (half-power) for each transmitter, so the
+ *     combined total output of the 2 transmitters is within regulatory limits.
+ *
+ *
+ * 2)  Compare target txpower vs. (EEPROM) saturation txpower *reduced by
+ *     backoff for this bit rate*.  Do not exceed (saturation - backoff[rate]);
+ *     reduce target txpower if necessary.
+ *
+ *     Backoff values below are in 1/2 dB units (equivalent to steps in
+ *     txpower gain tables):
+ *
+ *     OFDM 6 - 36 MBit:  10 steps (5 dB)
+ *     OFDM 48 MBit:      15 steps (7.5 dB)
+ *     OFDM 54 MBit:      17 steps (8.5 dB)
+ *     OFDM 60 MBit:      20 steps (10 dB)
+ *     CCK all rates:     10 steps (5 dB)
+ *
+ *     Backoff values apply to saturation txpower on a per-transmitter basis;
+ *     when using MIMO (2 transmitters), each transmitter uses the same
+ *     saturation level provided in EEPROM, and the same backoff values;
+ *     no reduction (such as with regulatory txpower limits) is required.
+ *
+ *     Saturation and Backoff values apply equally to 20 Mhz (legacy) channel
+ *     widths and 40 Mhz (.11n fat) channel widths; there is no separate
+ *     factory measurement for fat channels.
+ *
+ *     The result of this step is the final target txpower.  The rest of
+ *     the steps figure out the proper settings for the device to achieve
+ *     that target txpower.
+ *
+ *
+ * 3)  Determine (EEPROM) calibration subband for the target channel, by
+ *     comparing against first and last channels in each subband
+ *     (see struct iwl4965_eeprom_calib_subband_info).
+ *
+ *
+ * 4)  Linearly interpolate (EEPROM) factory calibration measurement sets,
+ *     referencing the 2 factory-measured (sample) channels within the subband.
+ *
+ *     Interpolation is based on difference between target channel's frequency
+ *     and the sample channels' frequencies.  Since channel numbers are based
+ *     on frequency (5 MHz between each channel number), this is equivalent
+ *     to interpolating based on channel number differences.
+ *
+ *     Note that the sample channels may or may not be the channels at the
+ *     edges of the subband.  The target channel may be "outside" of the
+ *     span of the sampled channels.
+ *
+ *     Driver may choose the pair (for 2 Tx chains) of measurements (see
+ *     struct iwl4965_eeprom_calib_ch_info) for which the actual measured
+ *     txpower comes closest to the desired txpower.  Usually, though,
+ *     the middle set of measurements is closest to the regulatory limits,
+ *     and is therefore a good choice for all txpower calculations (this
+ *     assumes that high accuracy is needed for maximizing legal txpower,
+ *     while lower txpower configurations do not need as much accuracy).
+ *
+ *     Driver should interpolate both members of the chosen measurement pair,
+ *     i.e. for both Tx chains (radio transmitters), unless the driver knows
+ *     that only one of the chains will be used (e.g. only one tx antenna
+ *     connected, but this should be unusual).  The rate scaling algorithm
+ *     switches antennas to find best performance, so both Tx chains will
+ *     be used (although only one at a time) even for non-MIMO transmissions.
+ *
+ *     Driver should interpolate factory values for temperature, gain table
+ *     index, and actual power.  The power amplifier detector values are
+ *     not used by the driver.
+ *
+ *     Sanity check:  If the target channel happens to be one of the sample
+ *     channels, the results should agree with the sample channel's
+ *     measurements!
+ *
+ *
+ * 5)  Find difference between desired txpower and (interpolated)
+ *     factory-measured txpower.  Using (interpolated) factory gain table index
+ *     (shown elsewhere) as a starting point, adjust this index lower to
+ *     increase txpower, or higher to decrease txpower, until the target
+ *     txpower is reached.  Each step in the gain table is 1/2 dB.
+ *
+ *     For example, if factory measured txpower is 16 dBm, and target txpower
+ *     is 13 dBm, add 6 steps to the factory gain index to reduce txpower
+ *     by 3 dB.
+ *
+ *
+ * 6)  Find difference between current device temperature and (interpolated)
+ *     factory-measured temperature for sub-band.  Factory values are in
+ *     degrees Celsius.  To calculate current temperature, see comments for
+ *     "4965 temperature calculation".
+ *
+ *     If current temperature is higher than factory temperature, driver must
+ *     increase gain (lower gain table index), and vice versa.
+ *
+ *     Temperature affects gain differently for different channels:
+ *
+ *     2.4 GHz all channels:  3.5 degrees per half-dB step
+ *     5 GHz channels 34-43:  4.5 degrees per half-dB step
+ *     5 GHz channels >= 44:  4.0 degrees per half-dB step
+ *
+ *     NOTE:  Temperature can increase rapidly when transmitting, especially
+ *            with heavy traffic at high txpowers.  Driver should update
+ *            temperature calculations often under these conditions to
+ *            maintain strong txpower in the face of rising temperature.
+ *
+ *
+ * 7)  Find difference between current power supply voltage indicator
+ *     (from "initialize alive") and factory-measured power supply voltage
+ *     indicator (EEPROM).
+ *
+ *     If the current voltage is higher (indicator is lower) than factory
+ *     voltage, gain should be reduced (gain table index increased) by:
+ *
+ *     (eeprom - current) / 7
+ *
+ *     If the current voltage is lower (indicator is higher) than factory
+ *     voltage, gain should be increased (gain table index decreased) by:
+ *
+ *     2 * (current - eeprom) / 7
+ *
+ *     If number of index steps in either direction turns out to be > 2,
+ *     something is wrong ... just use 0.
+ *
+ *     NOTE:  Voltage compensation is independent of band/channel.
+ *
+ *     NOTE:  "Initialize" uCode measures current voltage, which is assumed
+ *            to be constant after this initial measurement.  Voltage
+ *            compensation for txpower (number of steps in gain table)
+ *            may be calculated once and used until the next uCode bootload.
+ *
+ *
+ * 8)  If setting up txpowers for MIMO rates (rate indexes 8-15, 24-31),
+ *     adjust txpower for each transmitter chain, so txpower is balanced
+ *     between the two chains.  There are 5 pairs of tx_atten[group][chain]
+ *     values in "initialize alive", one pair for each of 5 channel ranges:
+ *
+ *     Group 0:  5 GHz channel 34-43
+ *     Group 1:  5 GHz channel 44-70
+ *     Group 2:  5 GHz channel 71-124
+ *     Group 3:  5 GHz channel 125-200
+ *     Group 4:  2.4 GHz all channels
+ *
+ *     Add the tx_atten[group][chain] value to the index for the target chain.
+ *     The values are signed, but are in pairs of 0 and a non-negative number,
+ *     so as to reduce gain (if necessary) of the "hotter" channel.  This
+ *     avoids any need to double-check for regulatory compliance after
+ *     this step.
+ *
+ *
+ * 9)  If setting up for a CCK rate, lower the gain by adding a CCK compensation
+ *     value to the index:
+ *
+ *     Hardware rev B:  9 steps (4.5 dB)
+ *     Hardware rev C:  5 steps (2.5 dB)
+ *
+ *     Hardware rev for 4965 can be determined by reading CSR_HW_REV_WA_REG,
+ *     bits [3:2], 1 = B, 2 = C.
+ *
+ *     NOTE:  This compensation is in addition to any saturation backoff that
+ *            might have been applied in an earlier step.
+ *
+ *
+ * 10) Select the gain table, based on band (2.4 vs 5 GHz).
+ *
+ *     Limit the adjusted index to stay within the table!
+ *
+ *
+ * 11) Read gain table entries for DSP and radio gain, place into appropriate
+ *     location(s) in command (struct iwl4965_txpowertable_cmd).
+ */
 
+/* Limit range of txpower output target to be between these values */
 #define IWL_TX_POWER_TARGET_POWER_MIN       (0)	/* 0 dBm = 1 milliwatt */
 #define IWL_TX_POWER_TARGET_POWER_MAX      (16)	/* 16 dBm */
 
-#define MIN_TX_GAIN_INDEX		(0)
-#define MIN_TX_GAIN_INDEX_52GHZ_EXT	(-9)
+/**
+ * When MIMO is used (2 transmitters operating simultaneously), driver should
+ * limit each transmitter to deliver a max of 3 dB below the regulatory limit
+ * for the device.  That is, use half power for each transmitter, so total
+ * txpower is within regulatory limits.
+ *
+ * The value "6" represents number of steps in gain table to reduce power 3 dB.
+ * Each step is 1/2 dB.
+ */
+#define IWL_TX_POWER_MIMO_REGULATORY_COMPENSATION (6)
+
+/**
+ * CCK gain compensation.
+ *
+ * When calculating txpowers for CCK, after making sure that the target power
+ * is within regulatory and saturation limits, driver must additionally
+ * back off gain by adding these values to the gain table index.
+ *
+ * Hardware rev for 4965 can be determined by reading CSR_HW_REV_WA_REG,
+ * bits [3:2], 1 = B, 2 = C.
+ */
+#define IWL_TX_POWER_CCK_COMPENSATION_B_STEP (9)
+#define IWL_TX_POWER_CCK_COMPENSATION_C_STEP (5)
+
+/*
+ * 4965 power supply voltage compensation for txpower
+ */
+#define TX_POWER_IWL_VOLTAGE_CODES_PER_03V   (7)
+
+/**
+ * Gain tables.
+ *
+ * The following tables contain pair of values for setting txpower, i.e.
+ * gain settings for the output of the device's digital signal processor (DSP),
+ * and for the analog gain structure of the transmitter.
+ *
+ * Each entry in the gain tables represents a step of 1/2 dB.  Note that these
+ * are *relative* steps, not indications of absolute output power.  Output
+ * power varies with temperature, voltage, and channel frequency, and also
+ * requires consideration of average power (to satisfy regulatory constraints),
+ * and peak power (to avoid distortion of the output signal).
+ *
+ * Each entry contains two values:
+ * 1)  DSP gain (or sometimes called DSP attenuation).  This is a fine-grained
+ *     linear value that multiplies the output of the digital signal processor,
+ *     before being sent to the analog radio.
+ * 2)  Radio gain.  This sets the analog gain of the radio Tx path.
+ *     It is a coarser setting, and behaves in a logarithmic (dB) fashion.
+ *
+ * EEPROM contains factory calibration data for txpower.  This maps actual
+ * measured txpower levels to gain settings in the "well known" tables
+ * below ("well-known" means here that both factory calibration *and* the
+ * driver work with the same table).
+ *
+ * There are separate tables for 2.4 GHz and 5 GHz bands.  The 5 GHz table
+ * has an extension (into negative indexes), in case the driver needs to
+ * boost power setting for high device temperatures (higher than would be
+ * present during factory calibration).  A 5 Ghz EEPROM index of "40"
+ * corresponds to the 49th entry in the table used by the driver.
+ */
+#define MIN_TX_GAIN_INDEX		(0)  /* highest gain, lowest idx, 2.4 */
+#define MIN_TX_GAIN_INDEX_52GHZ_EXT	(-9) /* highest gain, lowest idx, 5 */
+
+/**
+ * 2.4 GHz gain table
+ *
+ * Index    Dsp gain   Radio gain
+ *   0        110         0x3f      (highest gain)
+ *   1        104         0x3f
+ *   2         98         0x3f
+ *   3        110         0x3e
+ *   4        104         0x3e
+ *   5         98         0x3e
+ *   6        110         0x3d
+ *   7        104         0x3d
+ *   8         98         0x3d
+ *   9        110         0x3c
+ *  10        104         0x3c
+ *  11         98         0x3c
+ *  12        110         0x3b
+ *  13        104         0x3b
+ *  14         98         0x3b
+ *  15        110         0x3a
+ *  16        104         0x3a
+ *  17         98         0x3a
+ *  18        110         0x39
+ *  19        104         0x39
+ *  20         98         0x39
+ *  21        110         0x38
+ *  22        104         0x38
+ *  23         98         0x38
+ *  24        110         0x37
+ *  25        104         0x37
+ *  26         98         0x37
+ *  27        110         0x36
+ *  28        104         0x36
+ *  29         98         0x36
+ *  30        110         0x35
+ *  31        104         0x35
+ *  32         98         0x35
+ *  33        110         0x34
+ *  34        104         0x34
+ *  35         98         0x34
+ *  36        110         0x33
+ *  37        104         0x33
+ *  38         98         0x33
+ *  39        110         0x32
+ *  40        104         0x32
+ *  41         98         0x32
+ *  42        110         0x31
+ *  43        104         0x31
+ *  44         98         0x31
+ *  45        110         0x30
+ *  46        104         0x30
+ *  47         98         0x30
+ *  48        110          0x6
+ *  49        104          0x6
+ *  50         98          0x6
+ *  51        110          0x5
+ *  52        104          0x5
+ *  53         98          0x5
+ *  54        110          0x4
+ *  55        104          0x4
+ *  56         98          0x4
+ *  57        110          0x3
+ *  58        104          0x3
+ *  59         98          0x3
+ *  60        110          0x2
+ *  61        104          0x2
+ *  62         98          0x2
+ *  63        110          0x1
+ *  64        104          0x1
+ *  65         98          0x1
+ *  66        110          0x0
+ *  67        104          0x0
+ *  68         98          0x0
+ *  69         97            0
+ *  70         96            0
+ *  71         95            0
+ *  72         94            0
+ *  73         93            0
+ *  74         92            0
+ *  75         91            0
+ *  76         90            0
+ *  77         89            0
+ *  78         88            0
+ *  79         87            0
+ *  80         86            0
+ *  81         85            0
+ *  82         84            0
+ *  83         83            0
+ *  84         82            0
+ *  85         81            0
+ *  86         80            0
+ *  87         79            0
+ *  88         78            0
+ *  89         77            0
+ *  90         76            0
+ *  91         75            0
+ *  92         74            0
+ *  93         73            0
+ *  94         72            0
+ *  95         71            0
+ *  96         70            0
+ *  97         69            0
+ *  98         68            0
+ */
+
+/**
+ * 5 GHz gain table
+ *
+ * Index    Dsp gain   Radio gain
+ *  -9 	      123         0x3F      (highest gain)
+ *  -8 	      117         0x3F
+ *  -7        110         0x3F
+ *  -6        104         0x3F
+ *  -5         98         0x3F
+ *  -4        110         0x3E
+ *  -3        104         0x3E
+ *  -2         98         0x3E
+ *  -1        110         0x3D
+ *   0        104         0x3D
+ *   1         98         0x3D
+ *   2        110         0x3C
+ *   3        104         0x3C
+ *   4         98         0x3C
+ *   5        110         0x3B
+ *   6        104         0x3B
+ *   7         98         0x3B
+ *   8        110         0x3A
+ *   9        104         0x3A
+ *  10         98         0x3A
+ *  11        110         0x39
+ *  12        104         0x39
+ *  13         98         0x39
+ *  14        110         0x38
+ *  15        104         0x38
+ *  16         98         0x38
+ *  17        110         0x37
+ *  18        104         0x37
+ *  19         98         0x37
+ *  20        110         0x36
+ *  21        104         0x36
+ *  22         98         0x36
+ *  23        110         0x35
+ *  24        104         0x35
+ *  25         98         0x35
+ *  26        110         0x34
+ *  27        104         0x34
+ *  28         98         0x34
+ *  29        110         0x33
+ *  30        104         0x33
+ *  31         98         0x33
+ *  32        110         0x32
+ *  33        104         0x32
+ *  34         98         0x32
+ *  35        110         0x31
+ *  36        104         0x31
+ *  37         98         0x31
+ *  38        110         0x30
+ *  39        104         0x30
+ *  40         98         0x30
+ *  41        110         0x25
+ *  42        104         0x25
+ *  43         98         0x25
+ *  44        110         0x24
+ *  45        104         0x24
+ *  46         98         0x24
+ *  47        110         0x23
+ *  48        104         0x23
+ *  49         98         0x23
+ *  50        110         0x22
+ *  51        104         0x18
+ *  52         98         0x18
+ *  53        110         0x17
+ *  54        104         0x17
+ *  55         98         0x17
+ *  56        110         0x16
+ *  57        104         0x16
+ *  58         98         0x16
+ *  59        110         0x15
+ *  60        104         0x15
+ *  61         98         0x15
+ *  62        110         0x14
+ *  63        104         0x14
+ *  64         98         0x14
+ *  65        110         0x13
+ *  66        104         0x13
+ *  67         98         0x13
+ *  68        110         0x12
+ *  69        104         0x08
+ *  70         98         0x08
+ *  71        110         0x07
+ *  72        104         0x07
+ *  73         98         0x07
+ *  74        110         0x06
+ *  75        104         0x06
+ *  76         98         0x06
+ *  77        110         0x05
+ *  78        104         0x05
+ *  79         98         0x05
+ *  80        110         0x04
+ *  81        104         0x04
+ *  82         98         0x04
+ *  83        110         0x03
+ *  84        104         0x03
+ *  85         98         0x03
+ *  86        110         0x02
+ *  87        104         0x02
+ *  88         98         0x02
+ *  89        110         0x01
+ *  90        104         0x01
+ *  91         98         0x01
+ *  92        110         0x00
+ *  93        104         0x00
+ *  94         98         0x00
+ *  95         93         0x00
+ *  96         88         0x00
+ *  97         83         0x00
+ *  98         78         0x00
+ */
 
+
+/**
+ * Sanity checks and default values for EEPROM regulatory levels.
+ * If EEPROM values fall outside MIN/MAX range, use default values.
+ *
+ * Regulatory limits refer to the maximum average txpower allowed by
+ * regulatory agencies in the geographies in which the device is meant
+ * to be operated.  These limits are SKU-specific (i.e. geography-specific),
+ * and channel-specific; each channel has an individual regulatory limit
+ * listed in the EEPROM.
+ *
+ * Units are in half-dBm (i.e. "34" means 17 dBm).
+ */
 #define IWL_TX_POWER_DEFAULT_REGULATORY_24   (34)
 #define IWL_TX_POWER_DEFAULT_REGULATORY_52   (34)
 #define IWL_TX_POWER_REGULATORY_MIN          (0)
 #define IWL_TX_POWER_REGULATORY_MAX          (34)
+
+/**
+ * Sanity checks and default values for EEPROM saturation levels.
+ * If EEPROM values fall outside MIN/MAX range, use default values.
+ *
+ * Saturation is the highest level that the output power amplifier can produce
+ * without significant clipping distortion.  This is a "peak" power level.
+ * Different types of modulation (i.e. various "rates", and OFDM vs. CCK)
+ * require differing amounts of backoff, relative to their average power output,
+ * in order to avoid clipping distortion.
+ *
+ * Driver must make sure that it is violating neither the saturation limit,
+ * nor the regulatory limit, when calculating Tx power settings for various
+ * rates.
+ *
+ * Units are in half-dBm (i.e. "38" means 19 dBm).
+ */
 #define IWL_TX_POWER_DEFAULT_SATURATION_24   (38)
 #define IWL_TX_POWER_DEFAULT_SATURATION_52   (38)
 #define IWL_TX_POWER_SATURATION_MIN          (20)
 #define IWL_TX_POWER_SATURATION_MAX          (50)
 
-/* First and last channels of all groups */
+/**
+ * Channel groups used for Tx Attenuation calibration (MIMO tx channel balance)
+ * and thermal Txpower calibration.
+ *
+ * When calculating txpower, driver must compensate for current device
+ * temperature; higher temperature requires higher gain.  Driver must calculate
+ * current temperature (see "4965 temperature calculation"), then compare vs.
+ * factory calibration temperature in EEPROM; if current temperature is higher
+ * than factory temperature, driver must *increase* gain by proportions shown
+ * in table below.  If current temperature is lower than factory, driver must
+ * *decrease* gain.
+ *
+ * Different frequency ranges require different compensation, as shown below.
+ */
+/* Group 0, 5.2 GHz ch 34-43:  4.5 degrees per 1/2 dB. */
 #define CALIB_IWL_TX_ATTEN_GR1_FCH 34
 #define CALIB_IWL_TX_ATTEN_GR1_LCH 43
+
+/* Group 1, 5.3 GHz ch 44-70:  4.0 degrees per 1/2 dB. */
 #define CALIB_IWL_TX_ATTEN_GR2_FCH 44
 #define CALIB_IWL_TX_ATTEN_GR2_LCH 70
+
+/* Group 2, 5.5 GHz ch 71-124:  4.0 degrees per 1/2 dB. */
 #define CALIB_IWL_TX_ATTEN_GR3_FCH 71
 #define CALIB_IWL_TX_ATTEN_GR3_LCH 124
+
+/* Group 3, 5.7 GHz ch 125-200:  4.0 degrees per 1/2 dB. */
 #define CALIB_IWL_TX_ATTEN_GR4_FCH 125
 #define CALIB_IWL_TX_ATTEN_GR4_LCH 200
+
+/* Group 4, 2.4 GHz all channels:  3.5 degrees per 1/2 dB. */
 #define CALIB_IWL_TX_ATTEN_GR5_FCH 1
 #define CALIB_IWL_TX_ATTEN_GR5_LCH 20
 
+enum {
+	CALIB_CH_GROUP_1 = 0,
+	CALIB_CH_GROUP_2 = 1,
+	CALIB_CH_GROUP_3 = 2,
+	CALIB_CH_GROUP_4 = 3,
+	CALIB_CH_GROUP_5 = 4,
+	CALIB_CH_GROUP_MAX
+};
+
 /********************* END TXPOWER *****************************************/
 
 /* Flow Handler Definitions */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 3f16bd8..dd62db6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -861,9 +861,6 @@ struct iwl4965_kw {
 #define NUM_RX_CHAINS           (3)
 
 #define TX_POWER_IWL_ILLEGAL_VOLTAGE -10000
-#define TX_POWER_IWL_VOLTAGE_CODES_PER_03V       7
-#define IWL_TX_POWER_CCK_COMPENSATION_B_STEP (9)
-#define IWL_TX_POWER_CCK_COMPENSATION_C_STEP (5)
 
 struct iwl4965_traffic_load {
 	unsigned long time_stamp;
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
