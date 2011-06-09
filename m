Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4684 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab1FIOpT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:19 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 01/21] staging: brcm80211: moved typedefs to decrease
 header file dependencies
Date: Thu, 9 Jun 2011 16:44:41 +0200
Message-ID: <1307630701-9170-2-git-send-email-rvossen@broadcom.com> (sfid-20110609_164550_924299_279F3383)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Moved the typedefs to brcmsmac/types.h for source files that
only require opaque pointer definitions. Next patches will decrease the
number of #includes for each file.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |   10 ++-
 drivers/staging/brcm80211/brcmsmac/bmac.h          |    4 +-
 drivers/staging/brcm80211/brcmsmac/channel.h       |   12 +--
 drivers/staging/brcm80211/brcmsmac/d11.h           |   51 +++++-------
 drivers/staging/brcm80211/brcmsmac/dma.h           |   16 ++--
 drivers/staging/brcm80211/brcmsmac/main.h          |   11 +--
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h   |   23 ++---
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |   88 +++++++++-----------
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.h    |    6 +-
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h  |    2 -
 drivers/staging/brcm80211/brcmsmac/phy_shim.h      |    1 -
 drivers/staging/brcm80211/brcmsmac/pub.h           |   20 ++--
 drivers/staging/brcm80211/brcmsmac/rate.h          |    6 +-
 drivers/staging/brcm80211/brcmsmac/scb.h           |    8 +-
 drivers/staging/brcm80211/brcmsmac/types.h         |   79 ++++++++++++++++++
 15 files changed, 193 insertions(+), 144 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index b007fac..85c39af 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -17,6 +17,8 @@
 #ifndef	_BRCM_AIUTILS_H_
 #define	_BRCM_AIUTILS_H_
 
+#include "types.h"
+
 /*
  * SOC Interconnect Address Map.
  * All regions may not exist on all chips.
@@ -448,16 +450,16 @@ typedef u32(*si_intrsoff_t) (void *intr_arg);
 typedef void (*si_intrsrestore_t) (void *intr_arg, u32 arg);
 typedef bool(*si_intrsenabled_t) (void *intr_arg);
 
-typedef struct gpioh_item {
+struct gpioh_item {
 	void *arg;
 	bool level;
 	gpio_handler_t handler;
 	u32 event;
 	struct gpioh_item *next;
-} gpioh_item_t;
+};
 
 /* misc si info needed by some of the routines */
-typedef struct si_info {
+struct si_info {
 	struct si_pub pub;	/* back plane public state (must be first) */
 	void *pbus;		/* handle to bus (pci/sdio/..) */
 	uint dev_coreid;	/* the core provides driver functions */
@@ -494,7 +496,7 @@ typedef struct si_info {
 	u32 cia[SI_MAXCORES];	/* erom cia entry for each core */
 	u32 cib[SI_MAXCORES];	/* erom cia entry for each core */
 	u32 oob_router;	/* oob router registers for axi */
-} si_info_t;
+};
 
 /* AMBA Interconnect exported externs */
 extern void ai_scan(struct si_pub *sih, void *regs, uint devid);
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.h b/drivers/staging/brcm80211/brcmsmac/bmac.h
index af8af69..de8b809 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.h
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.h
@@ -18,10 +18,10 @@
 
 /* dup state between BMAC(struct wlc_hw_info) and HIGH(struct wlc_info)
    driver */
-typedef struct wlc_bmac_state {
+struct wlc_bmac_state {
 	u32 machwcap;	/* mac hw capibility */
 	u32 preamble_ovr;	/* preamble override */
-} wlc_bmac_state_t;
+};
 
 enum {
 	IOV_BMAC_DIAG,
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.h b/drivers/staging/brcm80211/brcmsmac/channel.h
index 3017839..dd0149a 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.h
+++ b/drivers/staging/brcm80211/brcmsmac/channel.h
@@ -58,7 +58,7 @@ struct wlc_info;
 #define IS_SINGLEBAND_5G(device)	0
 
 /* locale channel and power info. */
-typedef struct {
+struct locale_info {
 	u32 valid_channels;
 	u8 radar_channels;	/* List of radar sensitive channels */
 	u8 restricted_channels;	/* List of channels used only if APs are detected */
@@ -67,7 +67,7 @@ typedef struct {
 						 * per sub-band
 						 */
 	u8 flags;
-} locale_info_t;
+};
 
 /* bits for locale_info flags */
 #define WLC_PEAK_CONDUCTED	0x00	/* Peak for locals */
@@ -86,11 +86,11 @@ typedef struct {
  * maxpwr arrays are index by channel for 2.4 GHz limits, and
  * by sub-band for 5 GHz limits using CHANNEL_POWER_IDX_5G(channel)
  */
-typedef struct {
+struct locale_mimo_info {
 	s8 maxpwr20[WLC_MAXPWR_MIMO_TBL_SIZE];	/* tx 20 MHz power limits, qdBm units */
 	s8 maxpwr40[WLC_MAXPWR_MIMO_TBL_SIZE];	/* tx 40 MHz power limits, qdBm units */
 	u8 flags;
-} locale_mimo_info_t;
+};
 
 extern const chanvec_t chanvec_all_2G;
 extern const chanvec_t chanvec_all_5G;
@@ -105,10 +105,6 @@ struct country_info {
 	const u8 locale_mimo_5G;	/* 5G mimo info */
 };
 
-typedef struct country_info country_info_t;
-
-typedef struct wlc_cm_info wlc_cm_info_t;
-
 extern wlc_cm_info_t *wlc_channel_mgr_attach(struct wlc_info *wlc);
 extern void wlc_channel_mgr_detach(wlc_cm_info_t *wlc_cm);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index 855f1d3..1b03039 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -49,10 +49,10 @@
 #error "WL_RSSI_ANT_MAX does not match"
 #endif
 
-typedef volatile struct {
+struct intctrlregs {
 	u32 intstatus;
 	u32 intmask;
-} intctrlregs_t;
+};
 
 /* PIO structure,
  *  support two PIO format: 2 bytes access and 4 bytes access
@@ -60,53 +60,53 @@ typedef volatile struct {
  *  a pair of channels is defined for convenience
  */
 /* 2byte-wide pio register set per channel(xmt or rcv) */
-typedef volatile struct {
+struct pio2regs {
 	u16 fifocontrol;
 	u16 fifodata;
 	u16 fifofree;	/* only valid in xmt channel, not in rcv channel */
 	u16 PAD;
-} pio2regs_t;
+};
 
 /* a pair of pio channels(tx and rx) */
-typedef volatile struct {
+struct pio2regp {
 	pio2regs_t tx;
 	pio2regs_t rx;
-} pio2regp_t;
+};
 
 /* 4byte-wide pio register set per channel(xmt or rcv) */
-typedef volatile struct {
+struct pio4regs {
 	u32 fifocontrol;
 	u32 fifodata;
-} pio4regs_t;
+};
 
 /* a pair of pio channels(tx and rx) */
-typedef volatile struct {
+struct pio4regp {
 	pio4regs_t tx;
 	pio4regs_t rx;
-} pio4regp_t;
+};
 
 /* read: 32-bit register that can be read as 32-bit or as 2 16-bit
  * write: only low 16b-it half can be written
  */
-typedef volatile union {
+union pmqreg {
 	u32 pmqhostdata;	/* read only! */
 	struct {
 		u16 pmqctrlstatus;	/* read/write */
 		u16 PAD;
 	} w;
-} pmqreg_t;
+};
 
-typedef volatile struct {
+struct fifo64 {
 	dma64regs_t dmaxmt;	/* dma tx */
 	pio4regs_t piotx;	/* pio tx */
 	dma64regs_t dmarcv;	/* dma rx */
 	pio4regs_t piorx;	/* pio rx */
-} fifo64_t;
+};
 
 /*
  * Host Interface Registers
  */
-typedef volatile struct _d11regs {
+struct d11regs {
 	/* Device Control ("semi-standard host registers") */
 	u32 PAD[3];		/* 0x0 - 0x8 */
 	u32 biststatus;	/* 0xC */
@@ -430,7 +430,7 @@ typedef volatile struct _d11regs {
 
 	/* SHM *//* 0x800 - 0xEFE */
 	u16 PAD[0x380];	/* 0x800 - 0xEFE */
-} d11regs_t;
+};
 
 #define	PIHR_BASE	0x0400	/* byte address of packed IHR region */
 
@@ -617,7 +617,6 @@ typedef volatile struct _d11regs {
 #define	ANA_11N_013		5
 
 /* 802.11a PLCP header def */
-typedef struct ofdm_phy_hdr ofdm_phy_hdr_t;
 struct ofdm_phy_hdr {
 	u8 rlpt[3];		/* rate, length, parity, tail */
 	u16 service;
@@ -652,7 +651,6 @@ struct ofdm_phy_hdr {
 #define	D11A_PHY_PREHDR_TIME	(D11A_PHY_PRE_TIME + D11A_PHY_HDR_TIME)
 
 /* 802.11b PLCP header def */
-typedef struct cck_phy_hdr cck_phy_hdr_t;
 struct cck_phy_hdr {
 	u8 signal;
 	u8 service;
@@ -698,7 +696,6 @@ struct cck_phy_hdr {
 #define	D11_PHY_HDR_LEN	6
 
 /* TX DMA buffer header */
-typedef struct d11txh d11txh_t;
 struct d11txh {
 	u16 MacTxControlLow;	/* 0x0 */
 	u16 MacTxControlHigh;	/* 0x1 */
@@ -842,7 +839,6 @@ struct d11txh {
 #define ABI_MAS_MRT_ANT_PTN_MASK	0x000f
 
 /* tx status packet */
-typedef struct tx_status tx_status_t;
 struct tx_status {
 	u16 framelen;
 	u16 PAD;
@@ -1235,7 +1231,6 @@ struct tx_status {
 #define MIMO_ANTSEL_WAIT	50	/* 50us wait */
 #define MIMO_ANTSEL_OVERRIDE	0x8000	/* flag */
 
-typedef struct shm_acparams shm_acparams_t;
 struct shm_acparams {
 	u16 txop;
 	u16 cwmin;
@@ -1294,7 +1289,6 @@ struct shm_acparams {
 #define	PHY_NOISE_MASK		0x00ff
 
 /* Receive Frame Data Header for 802.11b DCF-only frames */
-typedef struct d11rxhdr d11rxhdr_t;
 struct d11rxhdr {
 	u16 RxFrameSize;	/* Actual byte length of the frame data received */
 	u16 PAD;
@@ -1313,7 +1307,6 @@ struct d11rxhdr {
 #define	RXHDR_LEN		24	/* sizeof d11rxhdr_t */
 #define	FRAMELEN(h)		((h)->RxFrameSize)
 
-typedef struct wlc_d11rxhdr wlc_d11rxhdr_t;
 struct wlc_d11rxhdr {
 	d11rxhdr_t rxhdr;
 	u32 tsf_l;		/* TSF_L reading */
@@ -1461,7 +1454,7 @@ struct wlc_d11rxhdr {
 #define	DBGST_ASLEEP		4	/* asleep (PS mode) */
 
 /* Scratch Reg defs */
-typedef enum {
+enum _ePsmScratchPadRegDefinitions {
 	S_RSV0 = 0,
 	S_RSV1,
 	S_RSV2,
@@ -1539,7 +1532,7 @@ typedef enum {
 	S_MFGTEST_TMP0,		/* Temp register used for RX test calculations  0x3D */
 	S_RXESN,		/* Received end sequence number for A-MPDU BA   0x3E */
 	S_STREG6,		/* 0x3F */
-} ePsmScratchPadRegDefinitions;
+};
 
 #define S_BEACON_INDX	S_OLD_BREM
 #define S_PRS_INDX	S_OLD_CWWIN
@@ -1551,7 +1544,7 @@ typedef enum {
 #define SLOW_CTRL_FD		(1 << 8)
 
 /* ucode mac statistic counters in shared memory */
-typedef struct macstat {
+struct macstat {
 	u16 txallfrm;	/* 0x80 */
 	u16 txrtsfrm;	/* 0x82 */
 	u16 txctsfrm;	/* 0x84 */
@@ -1609,7 +1602,7 @@ typedef struct macstat {
 	u16 phywatchdog;	/* 0xfa # of phy watchdog events */
 	u16 PAD;
 	u16 bphy_badplcp;	/* bphy bad plcp */
-} macstat_t;
+};
 
 /* dot11 core-specific control flags */
 #define	SICF_PCLKE		0x0004	/* PHY clock enable */
@@ -1758,7 +1751,7 @@ typedef struct macstat {
 #define SHM_BYT_CNT	0x2	/* IHR location */
 #define MAX_BYT_CNT	0x600	/* Maximum frame len */
 
-typedef struct d11cnt {
+struct d11cnt {
 	u32 txfrag;
 	u32 txmulti;
 	u32 txfail;
@@ -1773,6 +1766,6 @@ typedef struct d11cnt {
 	u32 rxcrc;
 	u32 txfrmsnt;
 	u32 rxundec;
-} d11cnt_t;
+};
 
 #endif				/* _BRCM_D11_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index 70c9ad6..20991f0 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -32,24 +32,24 @@ struct dma_pub;
 
 /* 32 bits addressing */
 
-typedef volatile struct {	/* diag access */
+struct dma32diag {	/* diag access */
 	u32 fifoaddr;	/* diag address */
 	u32 fifodatalow;	/* low 32bits of data */
 	u32 fifodatahigh;	/* high 32bits of data */
 	u32 pad;		/* reserved */
-} dma32diag_t;
+};
 
 /* 64 bits addressing */
 
 /* dma registers per channel(xmt or rcv) */
-typedef volatile struct {
+struct dma64regs {
 	u32 control;		/* enable, et al */
 	u32 ptr;		/* last descriptor posted to chip */
 	u32 addrlow;		/* descriptor ring base address low 32-bits (8K aligned) */
 	u32 addrhigh;	/* descriptor ring base address bits 63:32 (8K aligned) */
 	u32 status0;		/* current descriptor, xmt state */
 	u32 status1;		/* active descriptor, xmt error */
-} dma64regs_t;
+};
 
 /* map/unmap direction */
 #define	DMA_TX	1		/* TX direction for DMA */
@@ -57,11 +57,11 @@ typedef volatile struct {
 #define BUS_SWAP32(v)		(v)
 
 /* range param for dma_getnexttxp() and dma_txreclaim */
-typedef enum txd_range {
+enum txd_range {
 	DMA_RANGE_ALL = 1,
 	DMA_RANGE_TRANSMITTED,
 	DMA_RANGE_TRANSFERED
-} txd_range_t;
+};
 
 /* dma function type */
 typedef void (*di_detach_t) (struct dma_pub *dmah);
@@ -114,7 +114,7 @@ typedef uint(*di_txpending_t) (struct dma_pub *dmah);
 typedef uint(*di_txcommitted_t) (struct dma_pub *dmah);
 
 /* dma opsvec */
-typedef struct di_fcn_s {
+struct di_fcn_s {
 	di_detach_t detach;
 	di_txinit_t txinit;
 	di_txreset_t txreset;
@@ -159,7 +159,7 @@ typedef struct di_fcn_s {
 	di_txpending_t txpending;
 	di_txcommitted_t txcommitted;
 	uint endnum;
-} di_fcn_t;
+};
 
 /*
  * Exported data structure (read-only)
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index c41205a..0065a40 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -314,14 +314,14 @@ struct wlc_stf {
 /* number of 802.11 default (non-paired, group keys) */
 #define WSEC_MAX_DEFAULT_KEYS	4	/* # of default keys */
 
-typedef struct wsec_iv {
+struct wsec_iv {
 	u32 hi;		/* upper 32 bits of IV */
 	u16 lo;		/* lower 16 bits of IV */
-} wsec_iv_t;
+};
 
 #define WLC_NUMRXIVS	16	/* # rx IVs (one per 802.11e TID) */
 
-typedef struct wsec_key {
+struct wsec_key {
 	u8 ea[ETH_ALEN];	/* per station */
 	u8 idx;		/* key index in wsec_keys array */
 	u8 id;		/* key ID [0-3] */
@@ -337,8 +337,7 @@ typedef struct wsec_key {
 	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
 	wsec_iv_t rxiv[WLC_NUMRXIVS];	/* Rx IV (one per TID) */
 	wsec_iv_t txiv;		/* Tx IV */
-
-} wsec_key_t;
+};
 
 /*
  * core state (mac)
@@ -424,7 +423,6 @@ struct edcf_acparam {
 	u8 ECW;
 	u16 TXOP;
 } __attribute__((packed));
-typedef struct edcf_acparam edcf_acparam_t;
 
 struct wme_param_ie {
 	u8 oui[3];
@@ -435,7 +433,6 @@ struct wme_param_ie {
 	u8 rsvd;
 	edcf_acparam_t acparam[AC_COUNT];
 } __attribute__((packed));
-typedef struct wme_param_ie wme_param_ie_t;
 
 /* virtual interface */
 struct wlc_if {
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index 8bd0d13..587a545 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -105,7 +105,7 @@
 
 #define	WLC_RSSI_INVALID	 0	/* invalid RSSI value */
 
-typedef struct txpwr_limits {
+struct txpwr_limits {
 	u8 cck[WLC_NUM_RATES_CCK];
 	u8 ofdm[WLC_NUM_RATES_OFDM];
 
@@ -124,9 +124,9 @@ typedef struct txpwr_limits {
 	u8 mcs_40_stbc[WLC_NUM_RATES_MCS_1_STREAM];
 	u8 mcs_40_mimo[WLC_NUM_RATES_MCS_2_STREAM];
 	u8 mcs32;
-} txpwr_limits_t;
+};
 
-typedef struct {
+struct tx_power {
 	u32 flags;
 	chanspec_t chanspec;	/* txpwr report for this channel */
 	chanspec_t local_chanspec;	/* channel on which we are associated */
@@ -145,25 +145,22 @@ typedef struct {
 	u8 reg_limit[WL_TX_POWER_RATES];	/* Regulatory power limit */
 	u8 board_limit[WL_TX_POWER_RATES];	/* Max power board can support (SROM) */
 	u8 target[WL_TX_POWER_RATES];	/* Latest target power */
-} tx_power_t;
+};
 
-typedef struct tx_inst_power {
+struct tx_inst_power {
 	u8 txpwr_est_Pout[2];	/* Latest estimate for 2.4 and 5 Ghz */
 	u8 txpwr_est_Pout_gofdm;	/* Pwr estimate for 2.4 OFDM */
-} tx_inst_power_t;
+};
 
-typedef struct {
+struct chanvec {
 	u8 vec[MAXCHANNEL / NBBY];
-} chanvec_t;
+};
 
 struct rpc_info;
-typedef struct shared_phy shared_phy_t;
 
 struct phy_pub;
 
-typedef struct phy_pub wlc_phy_t;
-
-typedef struct shared_phy_params {
+struct shared_phy_params {
 	struct si_pub *sih;
 	void *physhim;
 	uint unit;
@@ -182,7 +179,7 @@ typedef struct shared_phy_params {
 	uint boardvendor;
 	u32 boardflags;
 	u32 boardflags2;
-} shared_phy_params_t;
+};
 
 
 extern shared_phy_t *wlc_phy_shared_attach(shared_phy_params_t *shp);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index f3fddfc..48149a7 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -43,16 +43,15 @@ extern u32 phyhal_msg_level;
 
 #define LCNXN_BASEREV		16
 
-typedef struct {
+struct wlc_phy_srom_fem {
 	u8 tssipos;		/* TSSI positive slope, 1: positive, 0: negative */
 	u8 extpagain;	/* Ext PA gain-type: full-gain: 0, pa-lite: 1, no_pa: 2 */
 	u8 pdetrange;	/* support 32 combinations of different Pdet dynamic ranges */
 	u8 triso;		/* TR switch isolation */
 	u8 antswctrllut;	/* antswctrl lookup table configuration: 32 possible choices */
-} wlc_phy_srom_fem_t;
+};
 
 struct wlc_hw_info;
-typedef struct phy_info phy_info_t;
 typedef void (*initfn_t) (phy_info_t *);
 typedef void (*chansetfn_t) (phy_info_t *, chanspec_t);
 typedef int (*longtrnfn_t) (phy_info_t *, int);
@@ -224,7 +223,7 @@ enum {
 	MPHASE_CAL_STATE_IDLETSSI
 };
 
-typedef enum {
+enum phy_cal_mode {
 	CAL_FULL,
 	CAL_RECAL,
 	CAL_CURRECAL,
@@ -232,7 +231,7 @@ typedef enum {
 	CAL_GCTRL,
 	CAL_SOFT,
 	CAL_DIGLO
-} phy_cal_mode_t;
+};
 
 #define RDR_NTIERS  1
 #define RDR_TIER_SIZE 64
@@ -294,21 +293,21 @@ typedef enum {
 #define PHY_LTRN_LIST_LEN	64
 extern u16 ltrn_list[PHY_LTRN_LIST_LEN];
 
-typedef struct _phy_table_info {
+struct phy_table_info {
 	uint table;
 	int q;
 	uint max;
-} phy_table_info_t;
+};
 
-typedef struct phytbl_info {
+struct phytbl_info {
 	const void *tbl_ptr;
 	u32 tbl_len;
 	u32 tbl_id;
 	u32 tbl_offset;
 	u32 tbl_width;
-} phytbl_info_t;
+};
 
-typedef struct {
+struct interference_info {
 	u8 curr_home_channel;
 	u16 crsminpwrthld_40_stored;
 	u16 crsminpwrthld_20L_stored;
@@ -378,10 +377,9 @@ typedef struct {
 	u16 radio_2057_core2_rssi_wb2_gc_stored;
 	u16 radio_2057_core1_rssi_nb_gc_stored;
 	u16 radio_2057_core2_rssi_nb_gc_stored;
+};
 
-} interference_info_t;
-
-typedef struct {
+struct aci_save_gphy {
 	u16 rc_cal_ovr;
 	u16 phycrsth1;
 	u16 phycrsth2;
@@ -415,21 +413,21 @@ typedef struct {
 	u16 div_srch_gn_back;
 	u16 ant_dwell;
 	u16 ant_wr_settle;
-} aci_save_gphy_t;
+};
 
-typedef struct _lo_complex_t {
+struct lo_complex_abgphy_info {
 	s8 i;
 	s8 q;
-} lo_complex_abgphy_info_t;
+};
 
-typedef struct _nphy_iq_comp {
+struct nphy_iq_comp {
 	s16 a0;
 	s16 b0;
 	s16 a1;
 	s16 b1;
-} nphy_iq_comp_t;
+};
 
-typedef struct _nphy_txpwrindex {
+struct nphy_txpwrindex {
 	s8 index;
 	s8 index_internal;
 	s8 index_internal_save;
@@ -440,9 +438,9 @@ typedef struct _nphy_txpwrindex {
 	u16 iqcomp_a;
 	u16 iqcomp_b;
 	u16 locomp;
-} phy_txpwrindex_t;
+};
 
-typedef struct {
+struct txiqcal_cache {
 
 	u16 txcal_coeffs_2G[8];
 	u16 txcal_radio_regs_2G[8];
@@ -451,9 +449,9 @@ typedef struct {
 	u16 txcal_coeffs_5G[8];
 	u16 txcal_radio_regs_5G[8];
 	nphy_iq_comp_t rxcal_coeffs_5G;
-} txiqcal_cache_t;
+};
 
-typedef struct _nphy_pwrctrl {
+struct nphy_pwrctrl {
 	s8 max_pwr_2g;
 	s8 idle_targ_2g;
 	s16 pwrdet_2g_a1;
@@ -480,34 +478,34 @@ typedef struct _nphy_pwrctrl {
 	s16 a1;
 	s16 b0;
 	s16 b1;
-} phy_pwrctrl_t;
+};
 
-typedef struct _nphy_txgains {
+struct nphy_txgains {
 	u16 txlpf[2];
 	u16 txgm[2];
 	u16 pga[2];
 	u16 pad[2];
 	u16 ipa[2];
-} nphy_txgains_t;
+};
 
 #define PHY_NOISEVAR_BUFSIZE 10
 
-typedef struct _nphy_noisevar_buf {
+struct nphy_noisevar_buf {
 	int bufcount;
 	int tone_id[PHY_NOISEVAR_BUFSIZE];
 	u32 noise_vars[PHY_NOISEVAR_BUFSIZE];
 	u32 min_noise_vars[PHY_NOISEVAR_BUFSIZE];
-} phy_noisevar_buf_t;
+};
 
-typedef struct {
+struct rssical_cache {
 	u16 rssical_radio_regs_2G[2];
 	u16 rssical_phyregs_2G[12];
 
 	u16 rssical_radio_regs_5G[2];
 	u16 rssical_phyregs_5G[12];
-} rssical_cache_t;
+};
 
-typedef struct {
+struct lcnphy_cal_results {
 
 	u16 txiqlocal_a;
 	u16 txiqlocal_b;
@@ -531,7 +529,7 @@ typedef struct {
 
 	u16 rxiqcal_coeff_a0;
 	u16 rxiqcal_coeff_b0;
-} lcnphy_cal_results_t;
+};
 
 struct shared_phy {
 	struct phy_info *phy_head;
@@ -584,10 +582,7 @@ struct phy_pub {
 };
 
 struct phy_info_nphy;
-typedef struct phy_info_nphy phy_info_nphy_t;
-
 struct phy_info_lcnphy;
-typedef struct phy_info_lcnphy phy_info_lcnphy_t;
 
 struct phy_func_ptr {
 	initfn_t init;
@@ -603,7 +598,6 @@ struct phy_func_ptr {
 	rxsigpwrfn_t rxsigpwr;
 	detachfn_t detach;
 };
-typedef struct phy_func_ptr phy_func_ptr_t;
 
 struct phy_info {
 	wlc_phy_t pubpi_ro;
@@ -948,34 +942,32 @@ struct phy_info {
 	struct wiphy *wiphy;
 };
 
-typedef s32 fixed;
-
-typedef struct _cs32 {
+struct _cs32 {
 	fixed q;
 	fixed i;
-} cs32;
+};
 
-typedef struct radio_regs {
+struct radio_regs {
 	u16 address;
 	u32 init_a;
 	u32 init_g;
 	u8 do_init_a;
 	u8 do_init_g;
-} radio_regs_t;
+};
 
-typedef struct radio_20xx_regs {
+struct radio_20xx_regs {
 	u16 address;
 	u8 init;
 	u8 do_init;
-} radio_20xx_regs_t;
+};
 
-typedef struct lcnphy_radio_regs {
+struct lcnphy_radio_regs {
 	u16 address;
 	u8 init_a;
 	u8 init_g;
 	u8 do_init_a;
 	u8 do_init_g;
-} lcnphy_radio_regs_t;
+};
 
 extern lcnphy_radio_regs_t lcnphy_radio_regs_2064[];
 extern lcnphy_radio_regs_t lcnphy_radio_regs_2066[];
@@ -1137,11 +1129,11 @@ extern s32 wlc_lcnphy_rx_signal_power(phy_info_t *pi, s32 gain_index);
 #define NPHY_MAX_HPVGA1_INDEX		10
 #define NPHY_DEF_HPVGA1_INDEXLIMIT	7
 
-typedef struct _phy_iq_est {
+struct phy_iq_est {
 	s32 iq_prod;
 	u32 i_pwr;
 	u32 q_pwr;
-} phy_iq_est_t;
+};
 
 extern void wlc_phy_stay_in_carriersearch_nphy(phy_info_t *pi, bool enable);
 extern void wlc_nphy_deaf_mode(phy_info_t *pi, bool mode);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h
index 5a64a98..97cab33 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h
@@ -14,8 +14,6 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-typedef phytbl_info_t dot11lcnphytbl_info_t;
-
 extern const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_rev0[];
 extern const u32 dot11lcnphytbl_rx_gain_info_sz_rev0;
 extern const dot11lcnphytbl_info_t dot11lcn_sw_ctrl_tbl_info_4313;
@@ -35,13 +33,13 @@ extern const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_extlna_2G_rev2[];
 
 extern const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_extlna_5G_rev2[];
 
-typedef struct {
+struct _lcnphy_tx_gain_tbl_entry {
 	unsigned char gm;
 	unsigned char pga;
 	unsigned char pad;
 	unsigned char dac;
 	unsigned char bb_mult;
-} lcnphy_tx_gain_tbl_entry;
+};
 
 extern const lcnphy_tx_gain_tbl_entry dot11lcnphy_2GHz_gaintable_rev0[];
 extern const lcnphy_tx_gain_tbl_entry dot11lcnphy_2GHz_extPA_gaintable_rev0[];
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
index 396122f..5033c9f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
@@ -16,8 +16,6 @@
 
 #define ANT_SWCTRL_TBL_REV3_IDX (0)
 
-typedef phytbl_info_t mimophytbl_info_t;
-
 extern const mimophytbl_info_t mimophytbl_info_rev0[],
     mimophytbl_info_rev0_volatile[];
 extern const u32 mimophytbl_info_sz_rev0, mimophytbl_info_sz_rev0_volatile;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index 1677df2..dddae81 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -108,7 +108,6 @@
 
 /* Forward declarations */
 struct wlc_hw_info;
-typedef struct wlc_phy_shim_info wlc_phy_shim_info_t;
 
 extern wlc_phy_shim_info_t *wlc_phy_shim_attach(struct wlc_hw_info *wlc_hw,
 						void *wl, void *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index e5f24b0..3c10a02 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -107,7 +107,7 @@
 
 struct ieee80211_tx_queue_params;
 
-typedef struct wlc_tunables {
+struct wlc_tunables {
 	int ntxd;		/* size of tx descriptor table */
 	int nrxd;		/* size of rx descriptor table */
 	int rxbufsz;		/* size of rx buffers to post */
@@ -123,14 +123,14 @@ typedef struct wlc_tunables {
 	int rxbnd;		/* max # of rx bufs to process before deferring to dpc */
 	int txsbnd;		/* max # tx status to process in wlc_txstatus() */
 	int memreserved;	/* memory reserved for BMAC's USB dma rx */
-} wlc_tunables_t;
+};
 
-typedef struct wlc_rateset {
+struct wlc_rateset {
 	uint count;		/* number of rates in rates[] */
 	u8 rates[WLC_NUMRATES];	/* rates in 500kbps units w/hi bit set if basic */
 	u8 htphy_membership;	/* HT PHY Membership */
 	u8 mcs[MCSSET_LEN];	/* supported mcs index bit map */
-} wlc_rateset_t;
+};
 
 struct rsn_parms {
 	u8 flags;		/* misc booleans (e.g., supported) */
@@ -161,7 +161,7 @@ struct rsn_parms {
 	IEEE80211_HT_CAP_MAX_AMSDU | IEEE80211_HT_CAP_DSSSCCK40)
 
 /* wlc internal bss_info */
-typedef struct wlc_bss_info {
+struct wlc_bss_info {
 	u8 BSSID[ETH_ALEN];	/* network BSSID */
 	u16 flags;		/* flags for internal attributes */
 	u8 SSID_len;		/* the length of SSID */
@@ -184,7 +184,7 @@ typedef struct wlc_bss_info {
 	u8 qbss_load_chan_free;	/* indicates how free the channel is */
 	u8 mcipher;		/* multicast cipher */
 	u8 wpacfg;		/* wpa config index */
-} wlc_bss_info_t;
+};
 
 /* forward declarations */
 struct wlc_if;
@@ -326,7 +326,7 @@ struct wlc_pub {
 };
 
 /* wl_monitor rx status per packet */
-typedef struct wl_rxsts {
+struct wl_rxsts {
 	uint pkterror;		/* error flags per pkt */
 	uint phytype;		/* 802.11 A/B/G ... */
 	uint channel;		/* channel */
@@ -341,7 +341,7 @@ typedef struct wl_rxsts {
 	uint encoding;		/* Unknown, CCK, PBCC, OFDM */
 	uint nfrmtype;		/* special 802.11n frames(AMPDU, AMSDU) */
 	struct brcms_if *wlif;	/* wl interface */
-} wl_rxsts_t;
+};
 
 /* status per error RX pkt */
 #define WL_RXS_CRC_ERROR		0x00000001	/* CRC Error in packet */
@@ -582,10 +582,10 @@ extern const u8 wme_fifo2ac[];
 
 #define HIGHEST_SINGLE_STREAM_MCS	7	/* MCS values greater than this enable multiple streams */
 
-typedef struct {
+struct wlc_antselcfg {
 	u8 ant_config[ANT_SELCFG_MAX];	/* antenna configuration */
 	u8 num_antcfg;	/* number of available antenna configurations */
-} wlc_antselcfg_t;
+};
 
 /* common functions for every port */
 extern void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device,
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.h b/drivers/staging/brcm80211/brcmsmac/rate.h
index 5575e83..421f04d 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/rate.h
@@ -27,14 +27,14 @@ extern const struct wlc_rateset gphy_legacy_rates;
 extern const struct wlc_rateset wlc_lrs_rates;
 extern const struct wlc_rateset rate_limit_1_2;
 
-typedef struct mcs_info {
+struct mcs_info {
 	u32 phy_rate_20;	/* phy rate in kbps [20Mhz] */
 	u32 phy_rate_40;	/* phy rate in kbps [40Mhz] */
 	u32 phy_rate_20_sgi;	/* phy rate in kbps [20Mhz] with SGI */
 	u32 phy_rate_40_sgi;	/* phy rate in kbps [40Mhz] with SGI */
 	u8 tx_phy_ctl3;	/* phy ctl byte 3, code rate, modulation type, # of streams */
 	u8 leg_ofdm;		/* matching legacy ofdm rate in 500bkps */
-} mcs_info_t;
+};
 
 #define WLC_MAXMCS	32	/* max valid mcs index */
 #define MCS_TABLE_SIZE	33	/* Number of mcs entries in the table */
@@ -62,7 +62,6 @@ extern const mcs_info_t mcs_table[];
 /* rate spec : holds rate and mode specific information required to generate a tx frame. */
 /* Legacy CCK and OFDM information is held in the same manner as was done in the past    */
 /* (in the lower byte) the upper 3 bytes primarily hold MIMO specific information        */
-typedef u32 ratespec_t;
 
 /* rate spec bit fields */
 #define RSPEC_RATE_MASK		0x0000007F	/* Either 500Kbps units or MIMO MCS idx */
@@ -137,7 +136,6 @@ extern const u8 ofdm_rate_lookup[];
 #define WLC_RATES_CCK		1
 #define WLC_RATES_OFDM		2
 
-/* use the stuct form instead of typedef to fix dependency problems */
 struct wlc_rateset;
 
 /* sanitize, and sort a rateset with the basic bit(s) preserved, validate rateset */
diff --git a/drivers/staging/brcm80211/brcmsmac/scb.h b/drivers/staging/brcm80211/brcmsmac/scb.h
index edd471b..2e3b5f4 100644
--- a/drivers/staging/brcm80211/brcmsmac/scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/scb.h
@@ -22,17 +22,17 @@
 
 #define AMPDU_TX_BA_MAX_WSIZE	64	/* max Tx ba window size (in pdu) */
 /* structure to store per-tid state for the ampdu initiator */
-typedef struct scb_ampdu_tid_ini {
+struct scb_ampdu_tid_ini {
 	u32 magic;
 	u8 tx_in_transit;	/* number of pending mpdus in transit in driver */
 	u8 tid;		/* initiator tid for easy lookup */
 	u8 txretry[AMPDU_TX_BA_MAX_WSIZE];	/* tx retry count; indexed by seq modulo */
 	struct scb *scb;	/* backptr for easy lookup */
-} scb_ampdu_tid_ini_t;
+};
 
 #define AMPDU_MAX_SCB_TID	NUMPRIO
 
-typedef struct scb_ampdu {
+struct scb_ampdu {
 	struct scb *scb;	/* back pointer for easy reference */
 	u8 mpdu_density;	/* mpdu density */
 	u8 max_pdu;		/* max pdus allowed in ampdu */
@@ -46,7 +46,7 @@ typedef struct scb_ampdu {
 	 * static.
 	 */
 	scb_ampdu_tid_ini_t ini[AMPDU_MAX_SCB_TID];	/* initiator info - per tid (NUMPRIO) */
-} scb_ampdu_t;
+};
 
 #define SCB_MAGIC 	0xbeefcafe
 #define INI_MAGIC 	0xabcd1234
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index e907990..0de99d5 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -360,6 +360,85 @@ struct wlc_bsscfg;
 struct brcmu_strbuf;
 struct si_pub;
 
+typedef struct gpioh_item gpioh_item_t;
+typedef struct si_info si_info_t;
+typedef struct wlc_bmac_state wlc_bmac_state_t;
+typedef struct locale_info locale_info_t;
+typedef struct locale_mimo_info locale_mimo_info_t;
+typedef struct country_info country_info_t;
+typedef struct wlc_cm_info wlc_cm_info_t;
+typedef volatile struct intctrlregs intctrlregs_t;
+typedef volatile struct pio2regs pio2regs_t;
+typedef volatile struct pio2regp pio2regp_t;
+typedef struct ofdm_phy_hdr ofdm_phy_hdr_t;
+typedef struct cck_phy_hdr cck_phy_hdr_t;
+typedef struct d11txh d11txh_t;
+typedef struct tx_status tx_status_t;
+typedef struct shm_acparams shm_acparams_t;
+typedef struct d11rxhdr d11rxhdr_t;
+typedef struct wlc_d11rxhdr wlc_d11rxhdr_t;
+typedef volatile struct pio4regs pio4regs_t;
+typedef volatile struct pio4regp pio4regp_t;
+typedef volatile struct fifo64 fifo64_t;
+typedef volatile struct d11regs d11regs_t;
+typedef struct macstat macstat_t;
+typedef struct d11cnt d11cnt_t;
+typedef volatile struct dma32diag dma32diag_t;
+typedef volatile struct dma64regs dma64regs_t;
+typedef enum txd_range txd_range_t;
+typedef struct di_fcn_s di_fcn_t;
+typedef struct wsec_iv wsec_iv_t;
+typedef struct wsec_key wsec_key_t;
+typedef struct edcf_acparam edcf_acparam_t;
+typedef struct wme_param_ie wme_param_ie_t;
+typedef struct wlc_phy_shim_info wlc_phy_shim_info_t;
+typedef struct wlc_tunables wlc_tunables_t;
+typedef struct wlc_rateset wlc_rateset_t;
+typedef struct wlc_bss_info  wlc_bss_info_t;
+typedef struct wl_rxsts wl_rxsts_t;
+typedef struct wlc_antselcfg wlc_antselcfg_t;
+typedef struct mcs_info mcs_info_t;
+typedef u32 ratespec_t;
+typedef struct scb_ampdu_tid_ini scb_ampdu_tid_ini_t;
+typedef struct scb_ampdu scb_ampdu_t;
+typedef struct txpwr_limits txpwr_limits_t;
+typedef struct tx_power tx_power_t;
+typedef struct tx_inst_power tx_inst_power_t;
+typedef struct chanvec chanvec_t;
+typedef struct shared_phy shared_phy_t;
+typedef struct shared_phy_params shared_phy_params_t;
+typedef struct phy_pub wlc_phy_t;
+typedef struct wlc_phy_srom_fem wlc_phy_srom_fem_t;
+typedef struct phy_info phy_info_t;
+typedef enum phy_cal_mode phy_cal_mode_t;
+typedef struct phy_table_info phy_table_info_t;
+typedef struct phytbl_info phytbl_info_t;
+typedef struct interference_info interference_info_t;
+typedef struct aci_save_gphy  aci_save_gphy_t;
+typedef struct lo_complex_abgphy_info lo_complex_abgphy_info_t;
+typedef struct nphy_iq_comp nphy_iq_comp_t;
+typedef struct nphy_txpwrindex phy_txpwrindex_t;
+typedef struct txiqcal_cache txiqcal_cache_t;
+typedef struct nphy_pwrctrl  phy_pwrctrl_t;
+typedef struct nphy_txgains nphy_txgains_t;
+typedef struct nphy_noisevar_buf phy_noisevar_buf_t;
+typedef struct rssical_cache rssical_cache_t;
+typedef struct lcnphy_cal_results lcnphy_cal_results_t;
+typedef struct phy_info_nphy phy_info_nphy_t;
+typedef struct phy_info_lcnphy phy_info_lcnphy_t;
+typedef struct phy_func_ptr phy_func_ptr_t;
+typedef s32 fixed;
+typedef struct _cs32 cs32;
+typedef struct radio_regs radio_regs_t;
+typedef struct radio_20xx_regs radio_20xx_regs_t;
+typedef struct lcnphy_radio_regs lcnphy_radio_regs_t;
+typedef struct phy_iq_est phy_iq_est_t;
+typedef phytbl_info_t dot11lcnphytbl_info_t;
+typedef struct _lcnphy_tx_gain_tbl_entry lcnphy_tx_gain_tbl_entry;
+typedef phytbl_info_t mimophytbl_info_t;
+typedef volatile union pmqreg pmqreg_t;
+typedef enum _ePsmScratchPadRegDefinitions  ePsmScratchPadRegDefinitions;
+
 /* brcm_msg_level is a bit vector with defs in defs.h */
 extern u32 brcm_msg_level;
 
-- 
1.7.4.1


