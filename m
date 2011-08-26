Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4817 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab1HZNT5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:57 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 12/13] staging: brcm80211: removed unused #ifdef
 sections
Date: Fri, 26 Aug 2011 15:19:39 +0200
Message-ID: <1314364780-9462-13-git-send-email-rvossen@broadcom.com> (sfid-20110826_152021_611729_272A8048)
In-Reply-To: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
References: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    4 --
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   16 ---------
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h    |    5 ---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   22 -------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |    6 ---
 drivers/staging/brcm80211/brcmsmac/aiutils.c      |    1 +
 drivers/staging/brcm80211/brcmsmac/aiutils.h      |   17 ----------
 drivers/staging/brcm80211/brcmsmac/channel.c      |   12 -------
 drivers/staging/brcm80211/brcmsmac/d11.h          |    4 --
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h  |    3 --
 drivers/staging/brcm80211/brcmsmac/main.c         |   35 ++-------------------
 drivers/staging/brcm80211/brcmsmac/pub.h          |   16 +---------
 drivers/staging/brcm80211/brcmsmac/types.h        |    8 -----
 drivers/staging/brcm80211/include/brcmu_utils.h   |    6 ---
 drivers/staging/brcm80211/include/defs.h          |    6 ---
 drivers/staging/brcm80211/include/soc.h           |    4 --
 16 files changed, 5 insertions(+), 160 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 0b92cef..a15765b 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -34,15 +34,11 @@
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
 
-#if !defined(SDIO_VENDOR_ID_BROADCOM)
 #define SDIO_VENDOR_ID_BROADCOM		0x02d0
-#endif				/* !defined(SDIO_VENDOR_ID_BROADCOM) */
 
 #define DMA_ALIGN_MASK	0x03
 
-#if !defined(SDIO_DEVICE_ID_BROADCOM_4329)
 #define SDIO_DEVICE_ID_BROADCOM_4329	0x4329
-#endif		/* !defined(SDIO_DEVICE_ID_BROADCOM_4329) */
 
 static int brcmf_sdioh_get_cisaddr(struct brcmf_sdio_dev *sdiodev, u32 regaddr);
 static int brcmf_ops_sdio_probe(struct sdio_func *func,
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 2c633fa..46f75b7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -120,18 +120,6 @@ uint brcmf_radio_up = 1;
 char iface_name[IFNAMSIZ] = "wlan";
 module_param_string(iface_name, iface_name, IFNAMSIZ, 0);
 
-/* The following are specific to the SDIO dongle */
-
-#ifdef SDTEST
-/* Echo packet generator (pkts/s) */
-uint brcmf_pktgen;
-module_param(brcmf_pktgen, uint, 0);
-
-/* Echo packet len (0 => sawtooth, max 2040) */
-uint brcmf_pktgen_len;
-module_param(brcmf_pktgen_len, uint, 0);
-#endif
-
 static int brcmf_toe_get(struct brcmf_info *drvr_priv, int idx, u32 *toe_ol);
 static int brcmf_toe_set(struct brcmf_info *drvr_priv, int idx, u32 toe_ol);
 static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx,
@@ -1065,7 +1053,6 @@ done:
 
 static int brcmf_netdev_stop(struct net_device *net)
 {
-#if !defined(IGNORE_ETH0_DOWN)
 	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(net);
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -1076,9 +1063,6 @@ static int brcmf_netdev_stop(struct net_device *net)
 	/* Set state and stop OS transmissions */
 	drvr_priv->pub.up = 0;
 	netif_stop_queue(net);
-#else
-	brcmf_dbg(ERROR, "BYPASSed due to BRCM compilation: under investigation\n");
-#endif				/* !defined(IGNORE_ETH0_DOWN) */
 
 	return 0;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index ff788b3..2ce5fea 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -17,13 +17,8 @@
 #ifndef _BRCMF_PROTO_H_
 #define _BRCMF_PROTO_H_
 
-#ifndef IOCTL_RESP_TIMEOUT
 #define IOCTL_RESP_TIMEOUT  2000	/* In milli second */
-#endif
-
-#ifndef IOCTL_CHIP_ACTIVE_TIMEOUT
 #define IOCTL_CHIP_ACTIVE_TIMEOUT  10	/* In milli second */
-#endif
 
 /*
  * Exported from the brcmf protocol module (brcmf_cdc)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 9b41891..c1647eb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -368,10 +368,8 @@ struct rte_console {
  * for HT availability, it could take a couple hundred ms more, so
  * max out at a 1 second (1000000us).
  */
-#if (PMU_MAX_TRANSITION_DLY <= 1000000)
 #undef PMU_MAX_TRANSITION_DLY
 #define PMU_MAX_TRANSITION_DLY 1000000
-#endif
 
 /* Value for ChipClockCSR during initial setup */
 #define BRCMF_INIT_CLKCTL1	(SBSDIO_FORCE_HW_CLKREQ_OFF |	\
@@ -3145,19 +3143,6 @@ int brcmf_sdbrcm_bus_init(struct brcmf_pub *drvr, bool enforce_mutex)
 	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 			       SBSDIO_FUNC1_CHIPCLKCSR, saveclk, &err);
 
-#if defined(OOB_INTR_ONLY)
-	/* Host registration for OOB interrupt */
-	if (brcmf_sdio_register_oob_intr(bus->dhd)) {
-		brcmf_sdbrcm_wd_timer(bus, 0);
-		brcmf_dbg(ERROR, "Host failed to resgister for OOB\n");
-		ret = -ENODEV;
-		goto exit;
-	}
-
-	/* Enable oob at firmware */
-	brcmf_sdbrcm_enable_oob_intr(bus, true);
-#endif		/* defined(OOB_INTR_ONLY) */
-
 	/* If we didn't come up, turn off backplane clock */
 	if (drvr->busstate != BRCMF_BUS_DATA)
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
@@ -4533,15 +4518,8 @@ void brcmf_sdbrcm_isr(void *arg)
 	if (!bus->intr)
 		brcmf_dbg(ERROR, "isr w/o interrupt configured!\n");
 
-#if defined(SDIO_ISR_THREAD)
-	brcmf_dbg(TRACE, "Calling brcmf_sdbrcm_dpc()\n");
-	while (brcmf_sdbrcm_dpc(bus))
-		;
-#else
 	bus->dpc_sched = true;
 	brcmf_sdbrcm_sched_dpc(bus);
-#endif
-
 }
 
 extern bool brcmf_sdbrcm_bus_watchdog(struct brcmf_pub *drvr)
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 4f7b081..9010ce7 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2337,14 +2337,10 @@ static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
 	wdev->wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
 	wdev->wiphy->cipher_suites = __wl_cipher_suites;
 	wdev->wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
-#ifndef WL_POWERSAVE_DISABLED
 	wdev->wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;	/* enable power
 								 * save mode
 								 * by default
 								 */
-#else
-	wdev->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
-#endif				/* !WL_POWERSAVE_DISABLED */
 	err = wiphy_register(wdev->wiphy);
 	if (unlikely(err < 0)) {
 		WL_ERR("Couldn not register wiphy device (%d)\n", err);
@@ -3409,9 +3405,7 @@ static s32 wl_init_priv(struct brcmf_cfg80211_priv *cfg_priv)
 	s32 err = 0;
 
 	cfg_priv->scan_request = NULL;
-#ifndef WL_POWERSAVE_DISABLED
 	cfg_priv->pwr_save = true;
-#endif /* WL_POWERSAVE_DISABLED */
 	cfg_priv->iscan_on = true;	/* iscan on & off switch.
 				 we enable iscan per default */
 	cfg_priv->roam_on = true;	/* roam on & off switch.
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index c9c41a5..62186b7 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -23,6 +23,7 @@
 #include <chipcommon.h>
 #include <brcmu_utils.h>
 #include <brcm_hw_ids.h>
+#include <soc.h>
 #include "types.h"
 #include "pub.h"
 #include "pmu.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 375c06f..5dee80f 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -33,12 +33,6 @@
 /* Region 2 for sdram (512 MB) */
 #define SI_SDRAM_R2		0x80000000
 
-#ifdef SI_ENUM_BASE_VARIABLE
-#define SI_ENUM_BASE		(sii->pub.si_enum_base)
-#else
-#define SI_ENUM_BASE		0x18000000	/* Enumeration space base */
-#endif				/* SI_ENUM_BASE_VARIABLE */
-
 /* Wrapper space base */
 #define SI_WRAP_BASE		0x18100000
 /* each core gets 4Kbytes for registers */
@@ -337,10 +331,8 @@
 #define DEFAULT_GPIO_ONTIME	10	/* Default: 10% on */
 #define DEFAULT_GPIO_OFFTIME	90	/* Default: 10% on */
 
-#ifndef DEFAULT_GPIOTIMERVAL
 #define DEFAULT_GPIOTIMERVAL \
 	((DEFAULT_GPIO_ONTIME << GPIO_ONTIME_SHIFT) | DEFAULT_GPIO_OFFTIME)
-#endif
 
 /*
  * Data structure to export all chip specific common variables
@@ -412,20 +404,11 @@ struct si_pub {
 #define SI_PCIUP	3
 
 /* PMU clock/power control */
-#if defined(BCMPMUCTL)
-#define PMUCTL_ENAB(sih)	(BCMPMUCTL)
-#else
 #define PMUCTL_ENAB(sih)	((sih)->cccaps & CC_CAP_PMU)
-#endif
 
 /* chipcommon clock/power control (exclusive with PMU's) */
-#if defined(BCMPMUCTL) && BCMPMUCTL
-#define CCCTL_ENAB(sih)		(0)
-#define CCPLL_ENAB(sih)		(0)
-#else
 #define CCCTL_ENAB(sih)		((sih)->cccaps & CC_CAP_PWR_CTL)
 #define CCPLL_ENAB(sih)		((sih)->cccaps & CC_CAP_PLL_MASK)
-#endif
 
 /* External PA enable mask */
 #define GPIO_CTRL_EPA_EN_MASK 0x40
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 1aad680..89d8fa7 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -107,9 +107,6 @@ static const struct locale_mimo_info *brcms_c_get_mimo_2g(u8 locale_idx);
 static const struct locale_mimo_info *brcms_c_get_mimo_5g(u8 locale_idx);
 
 /* QDB() macro takes a dB value and converts to a quarter dB value */
-#ifdef QDB
-#undef QDB
-#endif
 #define QDB(n) ((n) * BRCMS_TXPWR_DB_FACTOR)
 
 /* Regulatory Matrix Spreadsheet (CLM) MIMO v3.7.9 */
@@ -489,19 +486,10 @@ static const struct locale_mimo_info *g_mimo_5g_table[] = {
 	&locale_11n
 };
 
-#ifdef LC
-#undef LC
-#endif
 #define LC(id)	LOCALE_MIMO_IDX_ ## id
 
-#ifdef LC_2G
-#undef LC_2G
-#endif
 #define LC_2G(id)	LOCALE_2G_IDX_ ## id
 
-#ifdef LC_5G
-#undef LC_5G
-#endif
 #define LC_5G(id)	LOCALE_5G_IDX_ ## id
 
 #define LOCALES(band2, band5, mimo2, mimo5) \
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index 96f487a..f0c3f5a 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -47,11 +47,7 @@
 #define	TX_DATA_FIFO		TX_AC_BE_FIFO
 #define	TX_CTL_FIFO		TX_AC_VO_FIFO
 
-#ifndef WL_RSSI_ANT_MAX
 #define WL_RSSI_ANT_MAX		4	/* max possible rx antennas */
-#elif WL_RSSI_ANT_MAX != 4
-#error "WL_RSSI_ANT_MAX does not match"
-#endif
 
 struct intctrlregs {
 	u32 intstatus;
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index 7f290d7..1d52803 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -75,9 +75,6 @@ struct brcms_info {
 
 	struct tasklet_struct tasklet;	/* dpc tasklet */
 	bool resched;		/* dpc needs to be and is rescheduled */
-#ifdef LINUXSTA_PS
-	u32 pci_psstate[16];	/* pci ps-state save/restore */
-#endif
 	struct brcms_firmware fw;
 	struct wiphy *wiphy;
 };
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 339ab28..3aa0309 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -3540,11 +3540,6 @@ void brcms_c_set_bssid(struct brcms_bss_cfg *cfg)
 	/* if primary config, we need to update BSSID in RXE match registers */
 	if (cfg == wlc->cfg)
 		brcms_c_set_addrmatch(wlc, RCM_BSSID_OFFSET, cfg->BSSID);
-#ifdef SUPPORT_HWKEYS
-	else if (BSSCFG_STA(cfg) && cfg->BSS)
-		brcms_c_rcmta_add_bssid(wlc, cfg);
-
-#endif
 }
 
 void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw, bool shortslot)
@@ -3774,7 +3769,7 @@ u32 brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
 			break;
 		}
 	}
-#if NCONF
+
 	/*
 	 * pick siso/cdd as default for OFDM (note no basic
 	 * rate MCSs are supported yet)
@@ -3782,8 +3777,6 @@ u32 brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
 	if (IS_OFDM(lowest_basic_rspec))
 		lowest_basic_rspec |= (wlc->stf->ss_opmode << RSPEC_STF_SHIFT);
 
-#endif
-
 	return lowest_basic_rspec;
 }
 
@@ -4236,12 +4229,6 @@ void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 
 	/* WME QoS mode is Auto by default */
 	wlc->pub->_wme = AUTO;
-
-#ifdef BCMSDIODEV_ENABLED
-	/* enable priority flow control for sdio dongle */
-	wlc->pub->_priofc = true;
-#endif
-
 	wlc->pub->_ampdu = AMPDU_AGG_HOST;
 	wlc->pub->bcmerror = 0;
 	wlc->pub->_coex = ON;
@@ -7457,16 +7444,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			else
 				rspec[k] |= (mimo_ctlchbw << RSPEC_BW_SHIFT);
 
-			/* Set Short GI */
-#ifdef NOSGIYET
-			if (IS_MCS(rspec[k])
-			    && (txrate[k]->flags & IEEE80211_TX_RC_SHORT_GI))
-				rspec[k] |= RSPEC_SHORT_GI;
-			else if (!(txrate[k]->flags & IEEE80211_TX_RC_SHORT_GI))
-				rspec[k] &= ~RSPEC_SHORT_GI;
-#else
+			/* Disable short GI, not supported yet */
 			rspec[k] &= ~RSPEC_SHORT_GI;
-#endif
 
 			mimo_preamble_type = BRCMS_MM_PREAMBLE;
 			if (txrate[k]->flags & IEEE80211_TX_RC_GREEN_FIELD)
@@ -9582,15 +9561,7 @@ static void
 brcms_c_txflowcontrol_signal(struct brcms_c_info *wlc,
 			     struct brcms_txq_info *qi, bool on, int prio)
 {
-#ifdef NON_FUNCTIONAL
-	/* wlcif_list is never filled so this function is not functional */
-	struct brcms_c_if *wlcif;
-
-	for (wlcif = wlc->wlcif_list; wlcif != NULL; wlcif = wlcif->next) {
-		if (wlcif->qi == qi && wlcif->flags & BRCMS_IF_LINKED)
-			brcms_txflowcontrol(wlc->wl, wlcif->wlif, on, prio);
-	}
-#endif
+	/* wlcif_list is never filled so this function is not functional yet */
 }
 
 static struct brcms_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc)
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index c2ab1a3..f4e47e8 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -113,10 +113,8 @@
 #define ANTSWITCH_TYPE_3	3
 
 #define RXBUFSZ		PKTBUFSZ
-#ifndef AIDMAPSZ
 /* aid bitmap size in bytes */
 #define AIDMAPSZ	(roundup(MAXSCB, NBBY)/NBBY)
-#endif				/* AIDMAPSZ */
 
 #define MAX_STREAMS_SUPPORTED	4	/* max number of streams supported */
 
@@ -353,22 +351,10 @@ enum wlc_par_id {
 #define SUPPORT_11N	(ENAB_1x1|ENAB_2x2)
 #define SUPPORT_HT	(ENAB_1x1|ENAB_2x2|ENAB_3x3)
 /* WL11N Support */
-#if ((defined(NCONF) && (NCONF != 0)) || \
-	(defined(LCNCONF) && (LCNCONF != 0)) || \
-	(defined(HTCONF) && (HTCONF != 0)) || \
-	(defined(SSLPNCONF) && (SSLPNCONF != 0)))
 #define N_ENAB(pub) ((pub)->_n_enab & SUPPORT_11N)
 #define N_REQD(pub) ((pub)->_n_reqd)
-#else
-#define N_ENAB(pub)	0
-#define N_REQD(pub)	0
-#endif
-
-#if (defined(HTCONF) && (HTCONF != 0))
-#define HT_ENAB(pub) (((pub)->_n_enab & SUPPORT_HT) == SUPPORT_HT)
-#else
+
 #define HT_ENAB(pub) 0
-#endif
 
 #define AMPDU_AGG_HOST	1
 #define AMPDU_ENAB(pub) ((pub)->_ampdu)
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index d44db56..6d17d7f 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -20,14 +20,6 @@
 #include <linux/types.h>
 #include <linux/io.h>
 
-#if 0
-/* Bus types */
-#define SDIO_BUS		3	/* SDIO target */
-#define USB_BUS			5	/* USB (does not support R/W REG) */
-#define SPI_BUS			6	/* gSPI target */
-#define RPC_BUS			7	/* RPC target */
-#endif
-
 #define WL_CHAN_FREQ_RANGE_2G      0
 #define WL_CHAN_FREQ_RANGE_5GL     1
 #define WL_CHAN_FREQ_RANGE_5GM     2
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index ff8f363..de627c2 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -45,12 +45,8 @@ struct brcmu_strbuf {
 }
 
 /* osl multi-precedence packet queue */
-#ifndef PKTQ_LEN_DEFAULT
 #define PKTQ_LEN_DEFAULT        128	/* Max 128 packets */
-#endif
-#ifndef PKTQ_MAX_PREC
 #define PKTQ_MAX_PREC           16	/* Maximum precedence levels */
-#endif
 
 struct pktq_prec {
 	struct sk_buff *head;	/* first packet to dequeue */
@@ -192,9 +188,7 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 
 #define BCME_STRLEN		64	/* Max string length for BCM errors */
 
-#ifndef ABS
 #define	ABS(a)			(((a) < 0) ? -(a) : (a))
-#endif				/* ABS */
 
 #define CEIL(x, y)		(((x) + ((y)-1)) / (y))
 #define	ISPOWEROF2(x)		((((x)-1)&(x)) == 0)
diff --git a/drivers/staging/brcm80211/include/defs.h b/drivers/staging/brcm80211/include/defs.h
index 8e0c559..c745b7e 100644
--- a/drivers/staging/brcm80211/include/defs.h
+++ b/drivers/staging/brcm80211/include/defs.h
@@ -27,14 +27,8 @@
 #define USB_BUS			5
 #define SPI_BUS			6
 
-#ifndef OFF
 #define	OFF	0
-#endif
-
-#ifndef ON
 #define	ON	1		/* ON = 1 */
-#endif
-
 #define	AUTO	(-1)		/* Auto = -1 */
 
 /*
diff --git a/drivers/staging/brcm80211/include/soc.h b/drivers/staging/brcm80211/include/soc.h
index f23edc5..4fcb956 100644
--- a/drivers/staging/brcm80211/include/soc.h
+++ b/drivers/staging/brcm80211/include/soc.h
@@ -17,11 +17,7 @@
 #ifndef	_BRCM_SOC_H
 #define	_BRCM_SOC_H
 
-#ifdef SI_ENUM_BASE_VARIABLE
-#define SI_ENUM_BASE		(sii->pub.si_enum_base)
-#else
 #define SI_ENUM_BASE		0x18000000	/* Enumeration space base */
-#endif				/* SI_ENUM_BASE_VARIABLE */
 
 /* core codes */
 #define	NODEV_CORE_ID		0x700	/* Invalid coreid */
-- 
1.7.4.1


