Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2840 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab1JRMD3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 08:03:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/15] brcm80211: cleanup defines in main.c
Date: Tue, 18 Oct 2011 14:02:57 +0200
Message-ID: <1318939391-19495-2-git-send-email-arend@broadcom.com> (sfid-20111018_140349_872066_2374DB87)
In-Reply-To: <1318939391-19495-1-git-send-email-arend@broadcom.com>
References: <1318939391-19495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Signed-off-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |  348 ++++++++++--------------
 1 files changed, 148 insertions(+), 200 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 510e9bb..77261ea 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -35,39 +35,25 @@
  * Indication for txflowcontrol that all priority bits in
  * TXQ_STOP_FOR_PRIOFC_MASK are to be considered.
  */
-#define ALLPRIO		-1
-
-/*
- * 32 SSID chars, max of 4 chars for each SSID char "\xFF", plus NULL.
- */
-#define SSID_FMT_BUF_LEN	((4 * IEEE80211_MAX_SSID_LEN) + 1)
+#define ALLPRIO				-1
 
 /* watchdog timer, in unit of ms */
-#define	TIMER_INTERVAL_WATCHDOG	1000
+#define TIMER_INTERVAL_WATCHDOG		1000
 /* radio monitor timer, in unit of ms */
-#define	TIMER_INTERVAL_RADIOCHK	800
+#define TIMER_INTERVAL_RADIOCHK		800
 
 /* Max MPC timeout, in unit of watchdog */
 #ifndef BRCMS_MPC_MAX_DELAYCNT
-#define	BRCMS_MPC_MAX_DELAYCNT	10
+#define BRCMS_MPC_MAX_DELAYCNT		10
 #endif
 
 /* Min MPC timeout, in unit of watchdog */
-#define	BRCMS_MPC_MIN_DELAYCNT	1
-#define	BRCMS_MPC_THRESHOLD	3	/* MPC count threshold level */
+#define BRCMS_MPC_MIN_DELAYCNT		1
+/* MPC count threshold level */
+#define BRCMS_MPC_THRESHOLD		3
 
 /* beacon interval, in unit of 1024TU */
-#define	BEACON_INTERVAL_DEFAULT	100
-/* DTIM interval, in unit of beacon interval */
-#define	DTIM_INTERVAL_DEFAULT	3
-
-/* Scale down delays to accommodate QT slow speed */
-/* beacon interval, in unit of 1024TU */
-#define	BEACON_INTERVAL_DEF_QT	20
-/* DTIM interval, in unit of beacon interval */
-#define	DTIM_INTERVAL_DEF_QT	1
-
-#define	TBTT_ALIGN_LEEWAY_US	100	/* min leeway before first TBTT in us */
+#define BEACON_INTERVAL_DEFAULT		100
 
 /* n-mode support capability */
 /* 2x2 includes both 1x1 & 2x2 devices
@@ -78,113 +64,76 @@
 #define WL_11N_3x3			3
 #define WL_11N_4x4			4
 
-/* define 11n feature disable flags */
-#define WLFEATURE_DISABLE_11N		0x00000001
-#define WLFEATURE_DISABLE_11N_STBC_TX	0x00000002
-#define WLFEATURE_DISABLE_11N_STBC_RX	0x00000004
-#define WLFEATURE_DISABLE_11N_SGI_TX	0x00000008
-#define WLFEATURE_DISABLE_11N_SGI_RX	0x00000010
-#define WLFEATURE_DISABLE_11N_AMPDU_TX	0x00000020
-#define WLFEATURE_DISABLE_11N_AMPDU_RX	0x00000040
-#define WLFEATURE_DISABLE_11N_GF	0x00000080
-
-#define EDCF_ACI_MASK                0x60
-#define EDCF_ACI_SHIFT               5
-#define EDCF_ECWMIN_MASK             0x0f
-#define EDCF_ECWMAX_SHIFT            4
-#define EDCF_AIFSN_MASK              0x0f
-#define EDCF_AIFSN_MAX               15
-#define EDCF_ECWMAX_MASK             0xf0
-
-#define EDCF_AC_BE_TXOP_STA          0x0000
-#define EDCF_AC_BK_TXOP_STA          0x0000
-#define EDCF_AC_VO_ACI_STA           0x62
-#define EDCF_AC_VO_ECW_STA           0x32
-#define EDCF_AC_VI_ACI_STA           0x42
-#define EDCF_AC_VI_ECW_STA           0x43
-#define EDCF_AC_BK_ECW_STA           0xA4
-#define EDCF_AC_VI_TXOP_STA          0x005e
-#define EDCF_AC_VO_TXOP_STA          0x002f
-#define EDCF_AC_BE_ACI_STA           0x03
-#define EDCF_AC_BE_ECW_STA           0xA4
-#define EDCF_AC_BK_ACI_STA           0x27
-#define EDCF_AC_VO_TXOP_AP           0x002f
-
-#define EDCF_TXOP2USEC(txop)         ((txop) << 5)
-#define EDCF_ECW2CW(exp)             ((1 << (exp)) - 1)
-
-#define APHY_SYMBOL_TIME	4
-#define APHY_PREAMBLE_TIME	16
-#define APHY_SIGNAL_TIME	4
-#define APHY_SIFS_TIME		16
-#define APHY_SERVICE_NBITS	16
-#define APHY_TAIL_NBITS		6
-#define BPHY_SIFS_TIME		10
-#define BPHY_PLCP_SHORT_TIME	96
-
-#define PREN_PREAMBLE		24
-#define PREN_MM_EXT		12
-#define PREN_PREAMBLE_EXT	4
+#define EDCF_ACI_MASK			0x60
+#define EDCF_ACI_SHIFT			5
+#define EDCF_ECWMIN_MASK		0x0f
+#define EDCF_ECWMAX_SHIFT		4
+#define EDCF_AIFSN_MASK			0x0f
+#define EDCF_AIFSN_MAX			15
+#define EDCF_ECWMAX_MASK		0xf0
+
+#define EDCF_AC_BE_TXOP_STA		0x0000
+#define EDCF_AC_BK_TXOP_STA		0x0000
+#define EDCF_AC_VO_ACI_STA		0x62
+#define EDCF_AC_VO_ECW_STA		0x32
+#define EDCF_AC_VI_ACI_STA		0x42
+#define EDCF_AC_VI_ECW_STA		0x43
+#define EDCF_AC_BK_ECW_STA		0xA4
+#define EDCF_AC_VI_TXOP_STA		0x005e
+#define EDCF_AC_VO_TXOP_STA		0x002f
+#define EDCF_AC_BE_ACI_STA		0x03
+#define EDCF_AC_BE_ECW_STA		0xA4
+#define EDCF_AC_BK_ACI_STA		0x27
+#define EDCF_AC_VO_TXOP_AP		0x002f
+
+#define EDCF_TXOP2USEC(txop)		((txop) << 5)
+#define EDCF_ECW2CW(exp)		((1 << (exp)) - 1)
+
+#define APHY_SYMBOL_TIME		4
+#define APHY_PREAMBLE_TIME		16
+#define APHY_SIGNAL_TIME		4
+#define APHY_SIFS_TIME			16
+#define APHY_SERVICE_NBITS		16
+#define APHY_TAIL_NBITS			6
+#define BPHY_SIFS_TIME			10
+#define BPHY_PLCP_SHORT_TIME		96
+
+#define PREN_PREAMBLE			24
+#define PREN_MM_EXT			12
+#define PREN_PREAMBLE_EXT		4
 
 #define DOT11_MAC_HDR_LEN		24
-#define	DOT11_ACK_LEN		10
-#define DOT11_BA_LEN		4
+#define DOT11_ACK_LEN			10
+#define DOT11_BA_LEN			4
 #define DOT11_OFDM_SIGNAL_EXTENSION	6
 #define DOT11_MIN_FRAG_LEN		256
-#define	DOT11_RTS_LEN		16
-#define	DOT11_CTS_LEN		10
+#define DOT11_RTS_LEN			16
+#define DOT11_CTS_LEN			10
 #define DOT11_BA_BITMAP_LEN		128
 #define DOT11_MIN_BEACON_PERIOD		1
 #define DOT11_MAX_BEACON_PERIOD		0xFFFF
-#define	DOT11_MAXNUMFRAGS	16
+#define DOT11_MAXNUMFRAGS		16
 #define DOT11_MAX_FRAG_LEN		2346
 
-#define BPHY_PLCP_TIME		192
-#define RIFS_11N_TIME		2
-
-#define WME_VER			1
-#define WME_SUBTYPE_PARAM_IE	1
-#define WME_TYPE		2
-#define WME_OUI			"\x00\x50\xf2"
+#define BPHY_PLCP_TIME			192
+#define RIFS_11N_TIME			2
 
-#define AC_BE			0
-#define AC_BK			1
-#define AC_VI			2
-#define AC_VO			3
+#define AC_BE				0
+#define AC_BK				1
+#define AC_VI				2
+#define AC_VO				3
 
-#define	BCN_TMPL_LEN		512	/* length of the BCN template area */
+/* length of the BCN template area */
+#define BCN_TMPL_LEN			512
 
 /* brcms_bss_info flag bit values */
-#define BRCMS_BSS_HT		0x0020	/* BSS is HT (MIMO) capable */
+#define BRCMS_BSS_HT			0x0020	/* BSS is HT (MIMO) capable */
 
-/* Flags used in brcms_c_txq_info.stopped */
-/* per prio flow control bits */
-#define TXQ_STOP_FOR_PRIOFC_MASK	0x000000FF
-/* stop txq enqueue for packet drain */
-#define TXQ_STOP_FOR_PKT_DRAIN		0x00000100
-/* stop txq enqueue for ampdu flow control */
-#define TXQ_STOP_FOR_AMPDU_FLOW_CNTRL	0x00000200
-
-#define	BRCMS_HWRXOFF		38	/* chip rx buffer offset */
-
-/* Find basic rate for a given rate */
-static u8 brcms_basic_rate(struct brcms_c_info *wlc, u32 rspec)
-{
-	if (is_mcs_rate(rspec))
-		return wlc->band->basic_rate[mcs_table[rspec & RSPEC_RATE_MASK]
-		       .leg_ofdm];
-	return wlc->band->basic_rate[rspec & RSPEC_RATE_MASK];
-}
-
-static u16 frametype(u32 rspec, u8 mimoframe)
-{
-	if (is_mcs_rate(rspec))
-		return mimoframe;
-	return is_cck_rate(rspec) ? FT_CCK : FT_OFDM;
-}
+/* chip rx buffer offset */
+#define BRCMS_HWRXOFF			38
 
 /* rfdisable delay timer 500 ms, runs of ALP clock */
-#define RFDISABLE_DEFAULT	10000000
+#define RFDISABLE_DEFAULT		10000000
 
 #define BRCMS_TEMPSENSE_PERIOD		10	/* 10 second timeout */
 
@@ -194,87 +143,83 @@ static u16 frametype(u32 rspec, u8 mimoframe)
  * These constants are used ONLY by wlc_prio2prec_map.  Do not use them
  * elsewhere.
  */
-#define	_BRCMS_PREC_NONE		0	/* None = - */
-#define	_BRCMS_PREC_BK		2	/* BK - Background */
-#define	_BRCMS_PREC_BE		4	/* BE - Best-effort */
-#define	_BRCMS_PREC_EE		6	/* EE - Excellent-effort */
-#define	_BRCMS_PREC_CL		8	/* CL - Controlled Load */
-#define	_BRCMS_PREC_VI		10	/* Vi - Video */
-#define	_BRCMS_PREC_VO		12	/* Vo - Voice */
-#define	_BRCMS_PREC_NC		14	/* NC - Network Control */
-
-/* The BSS is generating beacons in HW */
-#define BRCMS_BSSCFG_HW_BCN	0x20
-
-#define	SYNTHPU_DLY_APHY_US	3700	/* a phy synthpu_dly time in us */
-#define	SYNTHPU_DLY_BPHY_US	1050	/* b/g phy synthpu_dly time in us */
-#define	SYNTHPU_DLY_NPHY_US	2048	/* n phy REV3 synthpu_dly time in us */
-#define	SYNTHPU_DLY_LPPHY_US	300	/* lpphy synthpu_dly time in us */
-
-#define	SYNTHPU_DLY_PHY_US_QT	100	/* QT synthpu_dly time in us */
-
-#define	ANTCNT			10	/* vanilla M_MAX_ANTCNT value */
+#define _BRCMS_PREC_NONE		0	/* None = - */
+#define _BRCMS_PREC_BK			2	/* BK - Background */
+#define _BRCMS_PREC_BE			4	/* BE - Best-effort */
+#define _BRCMS_PREC_EE			6	/* EE - Excellent-effort */
+#define _BRCMS_PREC_CL			8	/* CL - Controlled Load */
+#define _BRCMS_PREC_VI			10	/* Vi - Video */
+#define _BRCMS_PREC_VO			12	/* Vo - Voice */
+#define _BRCMS_PREC_NC			14	/* NC - Network Control */
+
+/* synthpu_dly times in us */
+#define SYNTHPU_DLY_APHY_US		3700
+#define SYNTHPU_DLY_BPHY_US		1050
+#define SYNTHPU_DLY_NPHY_US		2048
+#define SYNTHPU_DLY_LPPHY_US		300
+
+#define ANTCNT				10	/* vanilla M_MAX_ANTCNT val */
 
 /* Per-AC retry limit register definitions; uses defs.h bitfield macros */
-#define EDCF_SHORT_S            0
-#define EDCF_SFB_S              4
-#define EDCF_LONG_S             8
-#define EDCF_LFB_S              12
-#define EDCF_SHORT_M            BITFIELD_MASK(4)
-#define EDCF_SFB_M              BITFIELD_MASK(4)
-#define EDCF_LONG_M             BITFIELD_MASK(4)
-#define EDCF_LFB_M              BITFIELD_MASK(4)
+#define EDCF_SHORT_S			0
+#define EDCF_SFB_S			4
+#define EDCF_LONG_S			8
+#define EDCF_LFB_S			12
+#define EDCF_SHORT_M			BITFIELD_MASK(4)
+#define EDCF_SFB_M			BITFIELD_MASK(4)
+#define EDCF_LONG_M			BITFIELD_MASK(4)
+#define EDCF_LFB_M			BITFIELD_MASK(4)
 
-#define	RETRY_SHORT_DEF			7	/* Default Short retry Limit */
-#define	RETRY_SHORT_MAX			255	/* Maximum Short retry Limit */
-#define	RETRY_LONG_DEF			4	/* Default Long retry count */
-#define	RETRY_SHORT_FB			3 /* Short count for fallback rate */
-#define	RETRY_LONG_FB			2 /* Long count for fallback rate */
+#define RETRY_SHORT_DEF			7	/* Default Short retry Limit */
+#define RETRY_SHORT_MAX			255	/* Maximum Short retry Limit */
+#define RETRY_LONG_DEF			4	/* Default Long retry count */
+#define RETRY_SHORT_FB			3	/* Short count for fb rate */
+#define RETRY_LONG_FB			2	/* Long count for fb rate */
 
-#define	APHY_CWMIN		15
-#define PHY_CWMAX		1023
+#define APHY_CWMIN			15
+#define PHY_CWMAX			1023
 
-#define EDCF_AIFSN_MIN               1
+#define EDCF_AIFSN_MIN			1
 
-#define FRAGNUM_MASK		0xF
+#define FRAGNUM_MASK			0xF
 
-#define APHY_SLOT_TIME		9
-#define BPHY_SLOT_TIME		20
+#define APHY_SLOT_TIME			9
+#define BPHY_SLOT_TIME			20
 
-#define	WL_SPURAVOID_OFF	0
-#define	WL_SPURAVOID_ON1	1
-#define	WL_SPURAVOID_ON2	2
+#define WL_SPURAVOID_OFF		0
+#define WL_SPURAVOID_ON1		1
+#define WL_SPURAVOID_ON2		2
 
 /* invalid core flags, use the saved coreflags */
-#define BRCMS_USE_COREFLAGS	0xffffffff
+#define BRCMS_USE_COREFLAGS		0xffffffff
 
 /* values for PLCPHdr_override */
-#define BRCMS_PLCP_AUTO	-1
-#define BRCMS_PLCP_SHORT	0
-#define BRCMS_PLCP_LONG	1
+#define BRCMS_PLCP_AUTO			-1
+#define BRCMS_PLCP_SHORT		0
+#define BRCMS_PLCP_LONG			1
 
 /* values for g_protection_override and n_protection_override */
 #define BRCMS_PROTECTION_AUTO		-1
 #define BRCMS_PROTECTION_OFF		0
 #define BRCMS_PROTECTION_ON		1
 #define BRCMS_PROTECTION_MMHDR_ONLY	2
-#define BRCMS_PROTECTION_CTS_ONLY		3
+#define BRCMS_PROTECTION_CTS_ONLY	3
 
 /* values for g_protection_control and n_protection_control */
-#define BRCMS_PROTECTION_CTL_OFF		0
+#define BRCMS_PROTECTION_CTL_OFF	0
 #define BRCMS_PROTECTION_CTL_LOCAL	1
 #define BRCMS_PROTECTION_CTL_OVERLAP	2
 
 /* values for n_protection */
 #define BRCMS_N_PROTECTION_OFF		0
 #define BRCMS_N_PROTECTION_OPTIONAL	1
-#define BRCMS_N_PROTECTION_20IN40		2
+#define BRCMS_N_PROTECTION_20IN40	2
 #define BRCMS_N_PROTECTION_MIXEDMODE	3
 
 /* values for band specific 40MHz capabilities */
-#define BRCMS_N_BW_20ALL			0
-#define BRCMS_N_BW_40ALL			1
-#define BRCMS_N_BW_20IN2G_40IN5G		2
+#define BRCMS_N_BW_20ALL		0
+#define BRCMS_N_BW_40ALL		1
+#define BRCMS_N_BW_20IN2G_40IN5G	2
 
 /* bitflags for SGI support (sgi_rx iovar) */
 #define BRCMS_N_SGI_20			0x01
@@ -282,48 +227,42 @@ static u16 frametype(u32 rspec, u8 mimoframe)
 
 /* defines used by the nrate iovar */
 /* MSC in use,indicates b0-6 holds an mcs */
-#define NRATE_MCS_INUSE	0x00000080
+#define NRATE_MCS_INUSE			0x00000080
 /* rate/mcs value */
-#define NRATE_RATE_MASK 0x0000007f
+#define NRATE_RATE_MASK			0x0000007f
 /* stf mode mask: siso, cdd, stbc, sdm */
-#define NRATE_STF_MASK	0x0000ff00
+#define NRATE_STF_MASK			0x0000ff00
 /* stf mode shift */
-#define NRATE_STF_SHIFT	8
-/* bit indicates override both rate & mode */
-#define NRATE_OVERRIDE	0x80000000
+#define NRATE_STF_SHIFT			8
 /* bit indicate to override mcs only */
-#define NRATE_OVERRIDE_MCS_ONLY 0x40000000
-#define NRATE_SGI_MASK  0x00800000	/* sgi mode */
-#define NRATE_SGI_SHIFT 23	/* sgi mode */
-#define NRATE_LDPC_CODING 0x00400000	/* bit indicates adv coding in use */
-#define NRATE_LDPC_SHIFT 22	/* ldpc shift */
+#define NRATE_OVERRIDE_MCS_ONLY		0x40000000
+#define NRATE_SGI_MASK			0x00800000	/* sgi mode */
+#define NRATE_SGI_SHIFT			23		/* sgi mode */
+#define NRATE_LDPC_CODING		0x00400000	/* adv coding in use */
+#define NRATE_LDPC_SHIFT		22		/* ldpc shift */
 
-#define NRATE_STF_SISO	0	/* stf mode SISO */
-#define NRATE_STF_CDD	1	/* stf mode CDD */
-#define NRATE_STF_STBC	2	/* stf mode STBC */
-#define NRATE_STF_SDM	3	/* stf mode SDM */
+#define NRATE_STF_SISO			0		/* stf mode SISO */
+#define NRATE_STF_CDD			1		/* stf mode CDD */
+#define NRATE_STF_STBC			2		/* stf mode STBC */
+#define NRATE_STF_SDM			3		/* stf mode SDM */
 
-#define MAX_DMA_SEGS 4
+#define MAX_DMA_SEGS			4
 
 /* Max # of entries in Tx FIFO based on 4kb page size */
-#define NTXD		256
+#define NTXD				256
 /* Max # of entries in Rx FIFO based on 4kb page size */
-#define NRXD		256
+#define NRXD				256
 
 /* try to keep this # rbufs posted to the chip */
-#define	NRXBUFPOST	32
+#define NRXBUFPOST			32
 
 /* data msg txq hiwat mark */
-#define BRCMS_DATAHIWAT		50
+#define BRCMS_DATAHIWAT			50
 
-/* bounded rx loops */
-#define RXBND		8 /* max # frames to process in brcms_c_recv() */
-#define TXSBND		8 /* max # tx status to process in wlc_txstatus() */
-
-/*
- * 32 SSID chars, max of 4 chars for each SSID char "\xFF", plus NULL.
- */
-#define SSID_FMT_BUF_LEN	((4 * IEEE80211_MAX_SSID_LEN) + 1)
+/* max # frames to process in brcms_c_recv() */
+#define RXBND				8
+/* max # tx status to process in wlc_txstatus() */
+#define TXSBND				8
 
 /* brcmu_format_flags() bit description structure */
 struct brcms_c_bit_desc {
@@ -405,13 +344,6 @@ static const u16 xmtfifo_sz[][NFIFO] = {
 	{9, 58, 22, 14, 14, 5},
 };
 
-static const u8 acbitmap2maxprio[] = {
-	PRIO_8021D_BE, PRIO_8021D_BE, PRIO_8021D_BK, PRIO_8021D_BK,
-	PRIO_8021D_VI, PRIO_8021D_VI, PRIO_8021D_VI, PRIO_8021D_VI,
-	PRIO_8021D_VO, PRIO_8021D_VO, PRIO_8021D_VO, PRIO_8021D_VO,
-	PRIO_8021D_VO, PRIO_8021D_VO, PRIO_8021D_VO, PRIO_8021D_VO
-};
-
 #ifdef BCMDBG
 static const char * const fifo_names[] = {
 	"AC_BK", "AC_BE", "AC_VI", "AC_VO", "BCMC", "ATIM" };
@@ -424,6 +356,22 @@ static const char fifo_names[6][0];
 static struct brcms_c_info *wlc_info_dbg = (struct brcms_c_info *) (NULL);
 #endif
 
+/* Find basic rate for a given rate */
+static u8 brcms_basic_rate(struct brcms_c_info *wlc, u32 rspec)
+{
+	if (is_mcs_rate(rspec))
+		return wlc->band->basic_rate[mcs_table[rspec & RSPEC_RATE_MASK]
+		       .leg_ofdm];
+	return wlc->band->basic_rate[rspec & RSPEC_RATE_MASK];
+}
+
+static u16 frametype(u32 rspec, u8 mimoframe)
+{
+	if (is_mcs_rate(rspec))
+		return mimoframe;
+	return is_cck_rate(rspec) ? FT_CCK : FT_OFDM;
+}
+
 /* currently the best mechanism for determining SIFS is the band in use */
 static u16 get_sifs(struct brcms_band *band)
 {
-- 
1.7.4.1


