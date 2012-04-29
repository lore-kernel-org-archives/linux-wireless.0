Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44632 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755514Ab2D2AFa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:05:30 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	arend@broadcom.com, m@bues.ch, ralf@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 8/8] bcma/ssb: parse new attributes from sprom
Date: Sun, 29 Apr 2012 02:04:13 +0200
Message-Id: <1335657853-23925-9-git-send-email-hauke@hauke-m.de> (sfid-20120429_020534_398599_4459204B)
In-Reply-To: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
References: <1335657853-23925-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These newly added attributes are used by brcmsmac. Now bcma should
parse all attributes used by brcmsmac out of the sprom.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/sprom.c         |   70 ++++++++++++++++++++++++++++++++++++++++++
 drivers/ssb/pci.c            |   69 +++++++++++++++++++++++++++++++++++++++++
 include/linux/ssb/ssb_regs.h |   59 ++++++++++++++++++++++++++++++++---
 3 files changed, 194 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 22c9968..c7f9335 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -185,6 +185,18 @@ static int bcma_sprom_valid(const u16 *sprom)
 	bus->sprom._field = ((((u32)sprom[SPOFF((_offset)+2)] << 16 | \
 				sprom[SPOFF(_offset)]) & (_mask)) >> (_shift))
 
+#define SPEX_ARRAY8(_field, _offset, _mask, _shift)	\
+	do {	\
+		SPEX(_field[0], _offset +  0, _mask, _shift);	\
+		SPEX(_field[1], _offset +  2, _mask, _shift);	\
+		SPEX(_field[2], _offset +  4, _mask, _shift);	\
+		SPEX(_field[3], _offset +  6, _mask, _shift);	\
+		SPEX(_field[4], _offset +  8, _mask, _shift);	\
+		SPEX(_field[5], _offset + 10, _mask, _shift);	\
+		SPEX(_field[6], _offset + 12, _mask, _shift);	\
+		SPEX(_field[7], _offset + 14, _mask, _shift);	\
+	} while (0)
+
 static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 {
 	u16 v, o;
@@ -375,6 +387,64 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 	     SSB_SPROM8_AGAIN2, SSB_SPROM8_AGAIN2_SHIFT);
 	SPEX(antenna_gain.a3, SSB_SPROM8_AGAIN23,
 	     SSB_SPROM8_AGAIN3, SSB_SPROM8_AGAIN3_SHIFT);
+
+	SPEX(leddc_on_time, SSB_SPROM8_LEDDC, SSB_SPROM8_LEDDC_ON,
+	     SSB_SPROM8_LEDDC_ON_SHIFT);
+	SPEX(leddc_off_time, SSB_SPROM8_LEDDC, SSB_SPROM8_LEDDC_OFF,
+	     SSB_SPROM8_LEDDC_OFF_SHIFT);
+
+	SPEX(txchain, SSB_SPROM8_TXRXC, SSB_SPROM8_TXRXC_TXCHAIN,
+	     SSB_SPROM8_TXRXC_TXCHAIN_SHIFT);
+	SPEX(rxchain, SSB_SPROM8_TXRXC, SSB_SPROM8_TXRXC_RXCHAIN,
+	     SSB_SPROM8_TXRXC_RXCHAIN_SHIFT);
+	SPEX(antswitch, SSB_SPROM8_TXRXC, SSB_SPROM8_TXRXC_SWITCH,
+	     SSB_SPROM8_TXRXC_SWITCH_SHIFT);
+
+	SPEX(opo, SSB_SPROM8_OFDM2GPO, 0x00ff, 0);
+
+	SPEX_ARRAY8(mcs2gpo, SSB_SPROM8_2G_MCSPO, ~0, 0);
+	SPEX_ARRAY8(mcs5gpo, SSB_SPROM8_5G_MCSPO, ~0, 0);
+	SPEX_ARRAY8(mcs5glpo, SSB_SPROM8_5GL_MCSPO, ~0, 0);
+	SPEX_ARRAY8(mcs5ghpo, SSB_SPROM8_5GH_MCSPO, ~0, 0);
+
+	SPEX(rawtempsense, SSB_SPROM8_RAWTS, SSB_SPROM8_RAWTS_RAWTEMP,
+	     SSB_SPROM8_RAWTS_RAWTEMP_SHIFT);
+	SPEX(measpower, SSB_SPROM8_RAWTS, SSB_SPROM8_RAWTS_MEASPOWER,
+	     SSB_SPROM8_RAWTS_MEASPOWER_SHIFT);
+	SPEX(tempsense_slope, SSB_SPROM8_OPT_CORRX,
+	     SSB_SPROM8_OPT_CORRX_TEMP_SLOPE,
+	     SSB_SPROM8_OPT_CORRX_TEMP_SLOPE_SHIFT);
+	SPEX(tempcorrx, SSB_SPROM8_OPT_CORRX, SSB_SPROM8_OPT_CORRX_TEMPCORRX,
+	     SSB_SPROM8_OPT_CORRX_TEMPCORRX_SHIFT);
+	SPEX(tempsense_option, SSB_SPROM8_OPT_CORRX,
+	     SSB_SPROM8_OPT_CORRX_TEMP_OPTION,
+	     SSB_SPROM8_OPT_CORRX_TEMP_OPTION_SHIFT);
+	SPEX(freqoffset_corr, SSB_SPROM8_HWIQ_IQSWP,
+	     SSB_SPROM8_HWIQ_IQSWP_FREQ_CORR,
+	     SSB_SPROM8_HWIQ_IQSWP_FREQ_CORR_SHIFT);
+	SPEX(iqcal_swp_dis, SSB_SPROM8_HWIQ_IQSWP,
+	     SSB_SPROM8_HWIQ_IQSWP_IQCAL_SWP,
+	     SSB_SPROM8_HWIQ_IQSWP_IQCAL_SWP_SHIFT);
+	SPEX(hw_iqcal_en, SSB_SPROM8_HWIQ_IQSWP, SSB_SPROM8_HWIQ_IQSWP_HW_IQCAL,
+	     SSB_SPROM8_HWIQ_IQSWP_HW_IQCAL_SHIFT);
+
+	SPEX(bw40po, SSB_SPROM8_BW40PO, ~0, 0);
+	SPEX(cddpo, SSB_SPROM8_CDDPO, ~0, 0);
+	SPEX(stbcpo, SSB_SPROM8_STBCPO, ~0, 0);
+	SPEX(bwduppo, SSB_SPROM8_BWDUPPO, ~0, 0);
+
+	SPEX(tempthresh, SSB_SPROM8_THERMAL, SSB_SPROM8_THERMAL_TRESH,
+	     SSB_SPROM8_THERMAL_TRESH_SHIFT);
+	SPEX(tempoffset, SSB_SPROM8_THERMAL, SSB_SPROM8_THERMAL_OFFSET,
+	     SSB_SPROM8_THERMAL_OFFSET_SHIFT);
+	SPEX(phycal_tempdelta, SSB_SPROM8_TEMPDELTA,
+	     SSB_SPROM8_TEMPDELTA_PHYCAL,
+	     SSB_SPROM8_TEMPDELTA_PHYCAL_SHIFT);
+	SPEX(temps_period, SSB_SPROM8_TEMPDELTA, SSB_SPROM8_TEMPDELTA_PERIOD,
+	     SSB_SPROM8_TEMPDELTA_PERIOD_SHIFT);
+	SPEX(temps_hysteresis, SSB_SPROM8_TEMPDELTA,
+	     SSB_SPROM8_TEMPDELTA_HYSTERESIS,
+	     SSB_SPROM8_TEMPDELTA_HYSTERESIS_SHIFT);
 }
 
 /*
diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 2cb604d..e9d9496 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -178,6 +178,18 @@ err_pci:
 #define SPEX(_outvar, _offset, _mask, _shift) \
 	SPEX16(_outvar, _offset, _mask, _shift)
 
+#define SPEX_ARRAY8(_field, _offset, _mask, _shift)	\
+	do {	\
+		SPEX(_field[0], _offset +  0, _mask, _shift);	\
+		SPEX(_field[1], _offset +  2, _mask, _shift);	\
+		SPEX(_field[2], _offset +  4, _mask, _shift);	\
+		SPEX(_field[3], _offset +  6, _mask, _shift);	\
+		SPEX(_field[4], _offset +  8, _mask, _shift);	\
+		SPEX(_field[5], _offset + 10, _mask, _shift);	\
+		SPEX(_field[6], _offset + 12, _mask, _shift);	\
+		SPEX(_field[7], _offset + 14, _mask, _shift);	\
+	} while (0)
+
 
 static inline u8 ssb_crc8(u8 crc, u8 data)
 {
@@ -663,6 +675,63 @@ static void sprom_extract_r8(struct ssb_sprom *out, const u16 *in)
 	SPEX(fem.ghz5.antswlut, SSB_SPROM8_FEM5G,
 		SSB_SROM8_FEM_ANTSWLUT, SSB_SROM8_FEM_ANTSWLUT_SHIFT);
 
+	SPEX(leddc_on_time, SSB_SPROM8_LEDDC, SSB_SPROM8_LEDDC_ON,
+	     SSB_SPROM8_LEDDC_ON_SHIFT);
+	SPEX(leddc_off_time, SSB_SPROM8_LEDDC, SSB_SPROM8_LEDDC_OFF,
+	     SSB_SPROM8_LEDDC_OFF_SHIFT);
+
+	SPEX(txchain, SSB_SPROM8_TXRXC, SSB_SPROM8_TXRXC_TXCHAIN,
+	     SSB_SPROM8_TXRXC_TXCHAIN_SHIFT);
+	SPEX(rxchain, SSB_SPROM8_TXRXC, SSB_SPROM8_TXRXC_RXCHAIN,
+	     SSB_SPROM8_TXRXC_RXCHAIN_SHIFT);
+	SPEX(antswitch, SSB_SPROM8_TXRXC, SSB_SPROM8_TXRXC_SWITCH,
+	     SSB_SPROM8_TXRXC_SWITCH_SHIFT);
+
+	SPEX(opo, SSB_SPROM8_OFDM2GPO, 0x00ff, 0);
+
+	SPEX_ARRAY8(mcs2gpo, SSB_SPROM8_2G_MCSPO, ~0, 0);
+	SPEX_ARRAY8(mcs5gpo, SSB_SPROM8_5G_MCSPO, ~0, 0);
+	SPEX_ARRAY8(mcs5glpo, SSB_SPROM8_5GL_MCSPO, ~0, 0);
+	SPEX_ARRAY8(mcs5ghpo, SSB_SPROM8_5GH_MCSPO, ~0, 0);
+
+	SPEX(rawtempsense, SSB_SPROM8_RAWTS, SSB_SPROM8_RAWTS_RAWTEMP,
+	     SSB_SPROM8_RAWTS_RAWTEMP_SHIFT);
+	SPEX(measpower, SSB_SPROM8_RAWTS, SSB_SPROM8_RAWTS_MEASPOWER,
+	     SSB_SPROM8_RAWTS_MEASPOWER_SHIFT);
+	SPEX(tempsense_slope, SSB_SPROM8_OPT_CORRX,
+	     SSB_SPROM8_OPT_CORRX_TEMP_SLOPE,
+	     SSB_SPROM8_OPT_CORRX_TEMP_SLOPE_SHIFT);
+	SPEX(tempcorrx, SSB_SPROM8_OPT_CORRX, SSB_SPROM8_OPT_CORRX_TEMPCORRX,
+	     SSB_SPROM8_OPT_CORRX_TEMPCORRX_SHIFT);
+	SPEX(tempsense_option, SSB_SPROM8_OPT_CORRX,
+	     SSB_SPROM8_OPT_CORRX_TEMP_OPTION,
+	     SSB_SPROM8_OPT_CORRX_TEMP_OPTION_SHIFT);
+	SPEX(freqoffset_corr, SSB_SPROM8_HWIQ_IQSWP,
+	     SSB_SPROM8_HWIQ_IQSWP_FREQ_CORR,
+	     SSB_SPROM8_HWIQ_IQSWP_FREQ_CORR_SHIFT);
+	SPEX(iqcal_swp_dis, SSB_SPROM8_HWIQ_IQSWP,
+	     SSB_SPROM8_HWIQ_IQSWP_IQCAL_SWP,
+	     SSB_SPROM8_HWIQ_IQSWP_IQCAL_SWP_SHIFT);
+	SPEX(hw_iqcal_en, SSB_SPROM8_HWIQ_IQSWP, SSB_SPROM8_HWIQ_IQSWP_HW_IQCAL,
+	     SSB_SPROM8_HWIQ_IQSWP_HW_IQCAL_SHIFT);
+
+	SPEX(bw40po, SSB_SPROM8_BW40PO, ~0, 0);
+	SPEX(cddpo, SSB_SPROM8_CDDPO, ~0, 0);
+	SPEX(stbcpo, SSB_SPROM8_STBCPO, ~0, 0);
+	SPEX(bwduppo, SSB_SPROM8_BWDUPPO, ~0, 0);
+
+	SPEX(tempthresh, SSB_SPROM8_THERMAL, SSB_SPROM8_THERMAL_TRESH,
+	     SSB_SPROM8_THERMAL_TRESH_SHIFT);
+	SPEX(tempoffset, SSB_SPROM8_THERMAL, SSB_SPROM8_THERMAL_OFFSET,
+	     SSB_SPROM8_THERMAL_OFFSET_SHIFT);
+	SPEX(phycal_tempdelta, SSB_SPROM8_TEMPDELTA,
+	     SSB_SPROM8_TEMPDELTA_PHYCAL,
+	     SSB_SPROM8_TEMPDELTA_PHYCAL_SHIFT);
+	SPEX(temps_period, SSB_SPROM8_TEMPDELTA, SSB_SPROM8_TEMPDELTA_PERIOD,
+	     SSB_SPROM8_TEMPDELTA_PERIOD_SHIFT);
+	SPEX(temps_hysteresis, SSB_SPROM8_TEMPDELTA,
+	     SSB_SPROM8_TEMPDELTA_HYSTERESIS,
+	     SSB_SPROM8_TEMPDELTA_HYSTERESIS_SHIFT);
 	sprom_extract_r458(out, in);
 
 	/* TODO - get remaining rev 8 stuff needed */
diff --git a/include/linux/ssb/ssb_regs.h b/include/linux/ssb/ssb_regs.h
index 543795f..a052501 100644
--- a/include/linux/ssb/ssb_regs.h
+++ b/include/linux/ssb/ssb_regs.h
@@ -391,6 +391,11 @@
 #define  SSB_SPROM8_GPIOB_P2		0x00FF	/* Pin 2 */
 #define  SSB_SPROM8_GPIOB_P3		0xFF00	/* Pin 3 */
 #define  SSB_SPROM8_GPIOB_P3_SHIFT	8
+#define SSB_SPROM8_LEDDC		0x009A
+#define  SSB_SPROM8_LEDDC_ON		0xFF00	/* oncount */
+#define  SSB_SPROM8_LEDDC_ON_SHIFT	8
+#define  SSB_SPROM8_LEDDC_OFF		0x00FF	/* offcount */
+#define  SSB_SPROM8_LEDDC_OFF_SHIFT	0
 #define SSB_SPROM8_ANTAVAIL		0x009C  /* Antenna available bitfields*/
 #define  SSB_SPROM8_ANTAVAIL_A		0xFF00	/* A-PHY bitfield */
 #define  SSB_SPROM8_ANTAVAIL_A_SHIFT	8
@@ -406,6 +411,13 @@
 #define  SSB_SPROM8_AGAIN2_SHIFT	0
 #define  SSB_SPROM8_AGAIN3		0xFF00	/* Antenna 3 */
 #define  SSB_SPROM8_AGAIN3_SHIFT	8
+#define SSB_SPROM8_TXRXC		0x00A2
+#define  SSB_SPROM8_TXRXC_TXCHAIN	0x000f
+#define  SSB_SPROM8_TXRXC_TXCHAIN_SHIFT	0
+#define  SSB_SPROM8_TXRXC_RXCHAIN	0x00f0
+#define  SSB_SPROM8_TXRXC_RXCHAIN_SHIFT	4
+#define  SSB_SPROM8_TXRXC_SWITCH	0xff00
+#define  SSB_SPROM8_TXRXC_SWITCH_SHIFT	8
 #define SSB_SPROM8_RSSIPARM2G		0x00A4	/* RSSI params for 2GHz */
 #define  SSB_SPROM8_RSSISMF2G		0x000F
 #define  SSB_SPROM8_RSSISMC2G		0x00F0
@@ -432,6 +444,7 @@
 #define  SSB_SPROM8_TRI5GH_SHIFT	8
 #define SSB_SPROM8_RXPO			0x00AC  /* RX power offsets */
 #define  SSB_SPROM8_RXPO2G		0x00FF	/* 2GHz RX power offset */
+#define  SSB_SPROM8_RXPO2G_SHIFT	0
 #define  SSB_SPROM8_RXPO5G		0xFF00	/* 5GHz RX power offset */
 #define  SSB_SPROM8_RXPO5G_SHIFT	8
 #define SSB_SPROM8_FEM2G		0x00AE
@@ -447,10 +460,38 @@
 #define  SSB_SROM8_FEM_ANTSWLUT		0xF800
 #define  SSB_SROM8_FEM_ANTSWLUT_SHIFT	11
 #define SSB_SPROM8_THERMAL		0x00B2
-#define SSB_SPROM8_MPWR_RAWTS		0x00B4
-#define SSB_SPROM8_TS_SLP_OPT_CORRX	0x00B6
-#define SSB_SPROM8_FOC_HWIQ_IQSWP	0x00B8
-#define SSB_SPROM8_PHYCAL_TEMPDELTA	0x00BA
+#define  SSB_SPROM8_THERMAL_OFFSET	0x00ff
+#define  SSB_SPROM8_THERMAL_OFFSET_SHIFT	0
+#define  SSB_SPROM8_THERMAL_TRESH	0xff00
+#define  SSB_SPROM8_THERMAL_TRESH_SHIFT	8
+/* Temp sense related entries */
+#define SSB_SPROM8_RAWTS		0x00B4
+#define  SSB_SPROM8_RAWTS_RAWTEMP	0x01ff
+#define  SSB_SPROM8_RAWTS_RAWTEMP_SHIFT	0
+#define  SSB_SPROM8_RAWTS_MEASPOWER	0xfe00
+#define  SSB_SPROM8_RAWTS_MEASPOWER_SHIFT	9
+#define SSB_SPROM8_OPT_CORRX		0x00B6
+#define  SSB_SPROM8_OPT_CORRX_TEMP_SLOPE	0x00ff
+#define  SSB_SPROM8_OPT_CORRX_TEMP_SLOPE_SHIFT	0
+#define  SSB_SPROM8_OPT_CORRX_TEMPCORRX	0xfc00
+#define  SSB_SPROM8_OPT_CORRX_TEMPCORRX_SHIFT	10
+#define  SSB_SPROM8_OPT_CORRX_TEMP_OPTION	0x0300
+#define  SSB_SPROM8_OPT_CORRX_TEMP_OPTION_SHIFT	8
+/* FOC: freiquency offset correction, HWIQ: H/W IOCAL enable, IQSWP: IQ CAL swap disable */
+#define SSB_SPROM8_HWIQ_IQSWP		0x00B8
+#define  SSB_SPROM8_HWIQ_IQSWP_FREQ_CORR	0x000f
+#define  SSB_SPROM8_HWIQ_IQSWP_FREQ_CORR_SHIFT	0
+#define  SSB_SPROM8_HWIQ_IQSWP_IQCAL_SWP	0x0010
+#define  SSB_SPROM8_HWIQ_IQSWP_IQCAL_SWP_SHIFT	4
+#define  SSB_SPROM8_HWIQ_IQSWP_HW_IQCAL	0x0020
+#define  SSB_SPROM8_HWIQ_IQSWP_HW_IQCAL_SHIFT	5
+#define SSB_SPROM8_TEMPDELTA		0x00BA
+#define  SSB_SPROM8_TEMPDELTA_PHYCAL	0x00ff
+#define  SSB_SPROM8_TEMPDELTA_PHYCAL_SHIFT	0
+#define  SSB_SPROM8_TEMPDELTA_PERIOD	0x0f00
+#define  SSB_SPROM8_TEMPDELTA_PERIOD_SHIFT	8
+#define  SSB_SPROM8_TEMPDELTA_HYSTERESIS	0xf000
+#define  SSB_SPROM8_TEMPDELTA_HYSTERESIS_SHIFT	12
 
 /* There are 4 blocks with power info sharing the same layout */
 #define SSB_SROM8_PWR_INFO_CORE0	0x00C0
@@ -515,6 +556,16 @@
 #define SSB_SPROM8_OFDM5GLPO		0x014A	/* 5.2GHz OFDM power offset */
 #define SSB_SPROM8_OFDM5GHPO		0x014E	/* 5.8GHz OFDM power offset */
 
+#define SSB_SPROM8_2G_MCSPO		0x0152
+#define SSB_SPROM8_5G_MCSPO		0x0162
+#define SSB_SPROM8_5GL_MCSPO		0x0172
+#define SSB_SPROM8_5GH_MCSPO		0x0182
+
+#define SSB_SPROM8_CDDPO		0x0192
+#define SSB_SPROM8_STBCPO		0x0194
+#define SSB_SPROM8_BW40PO		0x0196
+#define SSB_SPROM8_BWDUPPO		0x0198
+
 /* Values for boardflags_lo read from SPROM */
 #define SSB_BFL_BTCOEXIST		0x0001	/* implements Bluetooth coexistance */
 #define SSB_BFL_PACTRL			0x0002	/* GPIO 9 controlling the PA */
-- 
1.7.9.5

