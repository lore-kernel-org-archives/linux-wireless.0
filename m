Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2415 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758864Ab1FALqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:40 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 80/83] staging: brcm80211: deleted brcmsmac/cfg.h and
 brcmsmac/bsscfg.h
Date: Wed, 1 Jun 2011 13:46:05 +0200
Message-ID: <1306928768-7501-80-git-send-email-rvossen@broadcom.com> (sfid-20110601_134838_166708_CD3EA982)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Moved used sections to other source files.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/alloc.c       |    2 -
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |    1 -
 drivers/staging/brcm80211/brcmsmac/antsel.c      |    2 -
 drivers/staging/brcm80211/brcmsmac/bottom_mac.c  |    1 -
 drivers/staging/brcm80211/brcmsmac/bsscfg.h      |  135 -----------
 drivers/staging/brcm80211/brcmsmac/cfg.h         |  280 ----------------------
 drivers/staging/brcm80211/brcmsmac/channel.c     |    1 -
 drivers/staging/brcm80211/brcmsmac/channel.h     |    7 +
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    1 -
 drivers/staging/brcm80211/brcmsmac/main.c        |   30 +++-
 drivers/staging/brcm80211/brcmsmac/main.h        |   80 ++++++
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    2 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |    1 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |    1 -
 drivers/staging/brcm80211/brcmsmac/phy_shim.c    |    1 -
 drivers/staging/brcm80211/brcmsmac/rate.c        |    1 -
 drivers/staging/brcm80211/brcmsmac/stf.c         |    1 -
 drivers/staging/brcm80211/brcmsmac/types.h       |  171 +++++++++++++
 18 files changed, 286 insertions(+), 432 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/bsscfg.h
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/cfg.h

diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index 1758640..e5573bc 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -23,13 +23,11 @@
 
 #include "d11.h"
 #include "types.h"
-#include "cfg.h"
 #include "scb.h"
 #include "pub.h"
 #include "key.h"
 #include "alloc.h"
 #include "rate.h"
-#include "bsscfg.h"
 #include "phy/phy_hal.h"
 #include "channel.h"
 #include "main.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index ab6c496..38662ab 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -23,7 +23,6 @@
 #include <d11.h>
 
 #include "types.h"
-#include "cfg.h"
 #include "rate.h"
 #include "scb.h"
 #include "pub.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index 31bc7c4..fbe8e0b 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -14,8 +14,6 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <cfg.h>
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/bottom_mac.c b/drivers/staging/brcm80211/brcmsmac/bottom_mac.c
index 719df41..da6a2a3 100644
--- a/drivers/staging/brcm80211/brcmsmac/bottom_mac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bottom_mac.c
@@ -35,7 +35,6 @@
 #include "types.h"
 #include "pmu.h"
 #include "d11.h"
-#include "cfg.h"
 #include "rate.h"
 #include "scb.h"
 #include "pub.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/bsscfg.h b/drivers/staging/brcm80211/brcmsmac/bsscfg.h
deleted file mode 100644
index 49c30cd..0000000
--- a/drivers/staging/brcm80211/brcmsmac/bsscfg.h
+++ /dev/null
@@ -1,135 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef _BRCM_BSSCFG_H_
-#define _BRCM_BSSCFG_H_
-
-/* Check if a particular BSS config is AP or STA */
-#define BSSCFG_AP(cfg)		(0)
-#define BSSCFG_STA(cfg)		(1)
-
-#define BSSCFG_IBSS(cfg)	(!(cfg)->BSS)
-
-#define NTXRATE			64	/* # tx MPDUs rate is reported for */
-#define MAXMACLIST		64	/* max # source MAC matches */
-#define BCN_TEMPLATE_COUNT 	2
-
-/* Iterator for "associated" STA bss configs:
-   (struct wlc_info *wlc, int idx, struct wlc_bsscfg *cfg) */
-#define FOREACH_AS_STA(wlc, idx, cfg) \
-	for (idx = 0; (int) idx < WLC_MAXBSSCFG; idx++) \
-		if ((cfg = (wlc)->bsscfg[idx]) && BSSCFG_STA(cfg) && cfg->associated)
-
-/* As above for all non-NULL BSS configs */
-#define FOREACH_BSS(wlc, idx, cfg) \
-	for (idx = 0; (int) idx < WLC_MAXBSSCFG; idx++) \
-		if ((cfg = (wlc)->bsscfg[idx]))
-
-/* BSS configuration state */
-struct wlc_bsscfg {
-	struct wlc_info *wlc;	/* wlc to which this bsscfg belongs to. */
-	bool up;		/* is this configuration up operational */
-	bool enable;		/* is this configuration enabled */
-	bool associated;	/* is BSS in ASSOCIATED state */
-	bool BSS;		/* infraustructure or adhac */
-	bool dtim_programmed;
-
-	u8 SSID_len;		/* the length of SSID */
-	u8 SSID[IEEE80211_MAX_SSID_LEN]; /* SSID string */
-	struct scb *bcmc_scb[MAXBANDS];	/* one bcmc_scb per band */
-	s8 _idx;		/* the index of this bsscfg,
-				 * assigned at wlc_bsscfg_alloc()
-				 */
-	/* MAC filter */
-	uint nmac;		/* # of entries on maclist array */
-	int macmode;		/* allow/deny stations on maclist array */
-	struct ether_addr *maclist;	/* list of source MAC addrs to match */
-
-	/* security */
-	u32 wsec;		/* wireless security bitvec */
-	s16 auth;		/* 802.11 authentication: Open, Shared Key, WPA */
-	s16 openshared;	/* try Open auth first, then Shared Key */
-	bool wsec_restrict;	/* drop unencrypted packets if wsec is enabled */
-	bool eap_restrict;	/* restrict data until 802.1X auth succeeds */
-	u16 WPA_auth;	/* WPA: authenticated key management */
-	bool wpa2_preauth;	/* default is true, wpa_cap sets value */
-	bool wsec_portopen;	/* indicates keys are plumbed */
-	wsec_iv_t wpa_none_txiv;	/* global txiv for WPA_NONE, tkip and aes */
-	int wsec_index;		/* 0-3: default tx key, -1: not set */
-	wsec_key_t *bss_def_keys[WLC_DEFAULT_KEYS];	/* default key storage */
-
-	/* TKIP countermeasures */
-	bool tkip_countermeasures;	/* flags TKIP no-assoc period */
-	u32 tk_cm_dt;	/* detect timer */
-	u32 tk_cm_bt;	/* blocking timer */
-	u32 tk_cm_bt_tmstmp;	/* Timestamp when TKIP BT is activated */
-	bool tk_cm_activate;	/* activate countermeasures after EAPOL-Key sent */
-
-	u8 BSSID[ETH_ALEN];	/* BSSID (associated) */
-	u8 cur_etheraddr[ETH_ALEN];	/* h/w address */
-	u16 bcmc_fid;	/* the last BCMC FID queued to TX_BCMC_FIFO */
-	u16 bcmc_fid_shm;	/* the last BCMC FID written to shared mem */
-
-	u32 flags;		/* WLC_BSSCFG flags; see below */
-
-	u8 *bcn;		/* AP beacon */
-	uint bcn_len;		/* AP beacon length */
-	bool ar_disassoc;	/* disassociated in associated recreation */
-
-	int auth_atmptd;	/* auth type (open/shared) attempted */
-
-	pmkid_cand_t pmkid_cand[MAXPMKID];	/* PMKID candidate list */
-	uint npmkid_cand;	/* num PMKID candidates */
-	pmkid_t pmkid[MAXPMKID];	/* PMKID cache */
-	uint npmkid;		/* num cached PMKIDs */
-
-	wlc_bss_info_t *current_bss;	/* BSS parms in ASSOCIATED state */
-
-	/* PM states */
-	bool PMawakebcn;	/* bcn recvd during current waking state */
-	bool PMpending;		/* waiting for tx status with PM indicated set */
-	bool priorPMstate;	/* Detecting PM state transitions */
-	bool PSpoll;		/* whether there is an outstanding PS-Poll frame */
-
-	/* BSSID entry in RCMTA, use the wsec key management infrastructure to
-	 * manage the RCMTA entries.
-	 */
-	wsec_key_t *rcmta;
-
-	/* 'unique' ID of this bsscfg, assigned at bsscfg allocation */
-	u16 ID;
-
-	uint txrspecidx;	/* index into tx rate circular buffer */
-	ratespec_t txrspec[NTXRATE][2];	/* circular buffer of prev MPDUs tx rates */
-};
-
-#define WLC_BSSCFG_11N_DISABLE	0x1000	/* Do not advertise .11n IEs for this BSS */
-#define WLC_BSSCFG_HW_BCN	0x20	/* The BSS is generating beacons in HW */
-
-#define HWBCN_ENAB(cfg)		(((cfg)->flags & WLC_BSSCFG_HW_BCN) != 0)
-#define HWPRB_ENAB(cfg)		(((cfg)->flags & WLC_BSSCFG_HW_PRB) != 0)
-
-/* Extend N_ENAB to per-BSS */
-#define BSS_N_ENAB(wlc, cfg) \
-	(N_ENAB((wlc)->pub) && !((cfg)->flags & WLC_BSSCFG_11N_DISABLE))
-
-#define MBSS_BCN_ENAB(cfg)       0
-#define MBSS_PRB_ENAB(cfg)       0
-#define SOFTBCN_ENAB(pub)    (0)
-#define SOFTPRB_ENAB(pub)    (0)
-#define wlc_bsscfg_tx_check(a) do { } while (0);
-
-#endif				/* _BRCM_BSSCFG_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/cfg.h b/drivers/staging/brcm80211/brcmsmac/cfg.h
deleted file mode 100644
index 534c536..0000000
--- a/drivers/staging/brcm80211/brcmsmac/cfg.h
+++ /dev/null
@@ -1,280 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef _BRCM_CFG_H_
-#define _BRCM_CFG_H_
-
-#define NBANDS(wlc) ((wlc)->pub->_nbands)
-#define NBANDS_PUB(pub) ((pub)->_nbands)
-#define NBANDS_HW(hw) ((hw)->_nbands)
-
-#define IS_SINGLEBAND_5G(device)	0
-
-/* **** Core type/rev defaults **** */
-#define D11_DEFAULT	0x0fffffb0	/* Supported  D11 revs: 4, 5, 7-27
-					 * also need to update wlc.h MAXCOREREV
-					 */
-
-#define NPHY_DEFAULT	0x000001ff	/* Supported nphy revs:
-					 *      0       4321a0
-					 *      1       4321a1
-					 *      2       4321b0/b1/c0/c1
-					 *      3       4322a0
-					 *      4       4322a1
-					 *      5       4716a0
-					 *      6       43222a0, 43224a0
-					 *      7       43226a0
-					 *      8       5357a0, 43236a0
-					 */
-
-#define LCNPHY_DEFAULT	0x00000007	/* Supported lcnphy revs:
-					 *      0       4313a0, 4336a0, 4330a0
-					 *      1
-					 *      2       4330a0
-					 */
-
-#define SSLPNPHY_DEFAULT 0x0000000f	/* Supported sslpnphy revs:
-					 *      0       4329a0/k0
-					 *      1       4329b0/4329C0
-					 *      2       4319a0
-					 *      3       5356a0
-					 */
-
-
-/* For undefined values, use defaults */
-#ifndef D11CONF
-#define D11CONF	D11_DEFAULT
-#endif
-#ifndef NCONF
-#define NCONF	NPHY_DEFAULT
-#endif
-#ifndef LCNCONF
-#define LCNCONF	LCNPHY_DEFAULT
-#endif
-
-#ifndef SSLPNCONF
-#define SSLPNCONF	SSLPNPHY_DEFAULT
-#endif
-
-/********************************************************************
- * Phy/Core Configuration.  Defines macros to to check core phy/rev *
- * compile-time configuration.  Defines default core support.       *
- * ******************************************************************
- */
-
-/* Basic macros to check a configuration bitmask */
-
-#define CONF_HAS(config, val)	((config) & (1 << (val)))
-#define CONF_MSK(config, mask)	((config) & (mask))
-#define MSK_RANGE(low, hi)	((1 << ((hi)+1)) - (1 << (low)))
-#define CONF_RANGE(config, low, hi) (CONF_MSK(config, MSK_RANGE(low, high)))
-
-#define CONF_IS(config, val)	((config) == (1 << (val)))
-#define CONF_GE(config, val)	((config) & (0-(1 << (val))))
-#define CONF_GT(config, val)	((config) & (0-2*(1 << (val))))
-#define CONF_LT(config, val)	((config) & ((1 << (val))-1))
-#define CONF_LE(config, val)	((config) & (2*(1 << (val))-1))
-
-/* Wrappers for some of the above, specific to config constants */
-
-#define NCONF_HAS(val)	CONF_HAS(NCONF, val)
-#define NCONF_MSK(mask)	CONF_MSK(NCONF, mask)
-#define NCONF_IS(val)	CONF_IS(NCONF, val)
-#define NCONF_GE(val)	CONF_GE(NCONF, val)
-#define NCONF_GT(val)	CONF_GT(NCONF, val)
-#define NCONF_LT(val)	CONF_LT(NCONF, val)
-#define NCONF_LE(val)	CONF_LE(NCONF, val)
-
-#define LCNCONF_HAS(val)	CONF_HAS(LCNCONF, val)
-#define LCNCONF_MSK(mask)	CONF_MSK(LCNCONF, mask)
-#define LCNCONF_IS(val)		CONF_IS(LCNCONF, val)
-#define LCNCONF_GE(val)		CONF_GE(LCNCONF, val)
-#define LCNCONF_GT(val)		CONF_GT(LCNCONF, val)
-#define LCNCONF_LT(val)		CONF_LT(LCNCONF, val)
-#define LCNCONF_LE(val)		CONF_LE(LCNCONF, val)
-
-#define D11CONF_HAS(val) CONF_HAS(D11CONF, val)
-#define D11CONF_MSK(mask) CONF_MSK(D11CONF, mask)
-#define D11CONF_IS(val)	CONF_IS(D11CONF, val)
-#define D11CONF_GE(val)	CONF_GE(D11CONF, val)
-#define D11CONF_GT(val)	CONF_GT(D11CONF, val)
-#define D11CONF_LT(val)	CONF_LT(D11CONF, val)
-#define D11CONF_LE(val)	CONF_LE(D11CONF, val)
-
-#define PHYCONF_HAS(val) CONF_HAS(PHYTYPE, val)
-#define PHYCONF_IS(val)	CONF_IS(PHYTYPE, val)
-
-#define NREV_IS(var, val)	(NCONF_HAS(val) && (NCONF_IS(val) || ((var) == (val))))
-#define NREV_GE(var, val)	(NCONF_GE(val) && (!NCONF_LT(val) || ((var) >= (val))))
-#define NREV_GT(var, val)	(NCONF_GT(val) && (!NCONF_LE(val) || ((var) > (val))))
-#define NREV_LT(var, val)	(NCONF_LT(val) && (!NCONF_GE(val) || ((var) < (val))))
-#define NREV_LE(var, val)	(NCONF_LE(val) && (!NCONF_GT(val) || ((var) <= (val))))
-
-#define LCNREV_IS(var, val)	(LCNCONF_HAS(val) && (LCNCONF_IS(val) || ((var) == (val))))
-#define LCNREV_GE(var, val)	(LCNCONF_GE(val) && (!LCNCONF_LT(val) || ((var) >= (val))))
-#define LCNREV_GT(var, val)	(LCNCONF_GT(val) && (!LCNCONF_LE(val) || ((var) > (val))))
-#define LCNREV_LT(var, val)	(LCNCONF_LT(val) && (!LCNCONF_GE(val) || ((var) < (val))))
-#define LCNREV_LE(var, val)	(LCNCONF_LE(val) && (!LCNCONF_GT(val) || ((var) <= (val))))
-
-#define D11REV_IS(var, val)	(D11CONF_HAS(val) && (D11CONF_IS(val) || ((var) == (val))))
-#define D11REV_GE(var, val)	(D11CONF_GE(val) && (!D11CONF_LT(val) || ((var) >= (val))))
-#define D11REV_GT(var, val)	(D11CONF_GT(val) && (!D11CONF_LE(val) || ((var) > (val))))
-#define D11REV_LT(var, val)	(D11CONF_LT(val) && (!D11CONF_GE(val) || ((var) < (val))))
-#define D11REV_LE(var, val)	(D11CONF_LE(val) && (!D11CONF_GT(val) || ((var) <= (val))))
-
-#define PHYTYPE_IS(var, val)	(PHYCONF_HAS(val) && (PHYCONF_IS(val) || ((var) == (val))))
-
-/* Finally, early-exit from switch case if anyone wants it... */
-
-#define CASECHECK(config, val)	if (!(CONF_HAS(config, val))) break
-#define CASEMSK(config, mask)	if (!(CONF_MSK(config, mask))) break
-
-#if (D11CONF ^ (D11CONF & D11_DEFAULT))
-#error "Unsupported MAC revision configured"
-#endif
-#if (NCONF ^ (NCONF & NPHY_DEFAULT))
-#error "Unsupported NPHY revision configured"
-#endif
-#if (LCNCONF ^ (LCNCONF & LCNPHY_DEFAULT))
-#error "Unsupported LPPHY revision configured"
-#endif
-
-/* *** Consistency checks *** */
-#if !D11CONF
-#error "No MAC revisions configured!"
-#endif
-
-#if !NCONF && !LCNCONF && !SSLPNCONF
-#error "No PHY configured!"
-#endif
-
-/* Set up PHYTYPE automatically: (depends on PHY_TYPE_X, from d11.h) */
-
-#define _PHYCONF_N (1 << PHY_TYPE_N)
-
-#if LCNCONF
-#define _PHYCONF_LCN (1 << PHY_TYPE_LCN)
-#else
-#define _PHYCONF_LCN 0
-#endif				/* LCNCONF */
-
-#if SSLPNCONF
-#define _PHYCONF_SSLPN (1 << PHY_TYPE_SSN)
-#else
-#define _PHYCONF_SSLPN 0
-#endif				/* SSLPNCONF */
-
-#define PHYTYPE (_PHYCONF_N | _PHYCONF_LCN | _PHYCONF_SSLPN)
-
-/* Utility macro to identify 802.11n (HT) capable PHYs */
-#define PHYTYPE_11N_CAP(phytype) \
-	(PHYTYPE_IS(phytype, PHY_TYPE_N) ||	\
-	 PHYTYPE_IS(phytype, PHY_TYPE_LCN) || \
-	 PHYTYPE_IS(phytype, PHY_TYPE_SSN))
-
-/* Last but not least: shorter wlc-specific var checks */
-#define WLCISNPHY(band)		PHYTYPE_IS((band)->phytype, PHY_TYPE_N)
-#define WLCISLCNPHY(band)	PHYTYPE_IS((band)->phytype, PHY_TYPE_LCN)
-#define WLCISSSLPNPHY(band)	PHYTYPE_IS((band)->phytype, PHY_TYPE_SSN)
-
-#define WLC_PHY_11N_CAP(band)	PHYTYPE_11N_CAP((band)->phytype)
-
-/**********************************************************************
- * ------------- End of Core phy/rev configuration. ----------------- *
- * ********************************************************************
- */
-
-/*************************************************
- * Defaults for tunables (e.g. sizing constants)
- *
- * For each new tunable, add a member to the end
- * of wlc_tunables_t in wlc_pub.h to enable
- * runtime checks of tunable values. (Directly
- * using the macros in code invalidates ROM code)
- *
- * ***********************************************
- */
-#ifndef NTXD
-#define NTXD		256	/* Max # of entries in Tx FIFO based on 4kb page size */
-#endif				/* NTXD */
-#ifndef NRXD
-#define NRXD		256	/* Max # of entries in Rx FIFO based on 4kb page size */
-#endif				/* NRXD */
-
-#ifndef NRXBUFPOST
-#define	NRXBUFPOST	32	/* try to keep this # rbufs posted to the chip */
-#endif				/* NRXBUFPOST */
-
-#ifndef MAXSCB			/* station control blocks in cache */
-#define MAXSCB		32	/* Maximum SCBs in cache for STA */
-#endif				/* MAXSCB */
-
-#ifndef AMPDU_NUM_MPDU
-#define AMPDU_NUM_MPDU		16	/* max allowed number of mpdus in an ampdu (2 streams) */
-#endif				/* AMPDU_NUM_MPDU */
-
-#ifndef AMPDU_NUM_MPDU_3STREAMS
-#define AMPDU_NUM_MPDU_3STREAMS	32	/* max allowed number of mpdus in an ampdu for 3+ streams */
-#endif				/* AMPDU_NUM_MPDU_3STREAMS */
-
-/* Count of packet callback structures. either of following
- * 1. Set to the number of SCBs since a STA
- * can queue up a rate callback for each IBSS STA it knows about, and an AP can
- * queue up an "are you there?" Null Data callback for each associated STA
- * 2. controlled by tunable config file
- */
-#ifndef MAXPKTCB
-#define MAXPKTCB	MAXSCB	/* Max number of packet callbacks */
-#endif				/* MAXPKTCB */
-
-#ifndef CTFPOOLSZ
-#define CTFPOOLSZ       128
-#endif				/* CTFPOOLSZ */
-
-/* NetBSD also needs to keep track of this */
-#define WLC_MAX_UCODE_BSS	(16)	/* Number of BSS handled in ucode bcn/prb */
-#define WLC_MAX_UCODE_BSS4	(4)	/* Number of BSS handled in sw bcn/prb */
-#ifndef WLC_MAXBSSCFG
-#define WLC_MAXBSSCFG		(1)	/* max # BSS configs */
-#endif				/* WLC_MAXBSSCFG */
-
-#ifndef MAXBSS
-#define MAXBSS		64	/* max # available networks */
-#endif				/* MAXBSS */
-
-#ifndef WLC_DATAHIWAT
-#define WLC_DATAHIWAT		50	/* data msg txq hiwat mark */
-#endif				/* WLC_DATAHIWAT */
-
-#ifndef WLC_AMPDUDATAHIWAT
-#define WLC_AMPDUDATAHIWAT 255
-#endif				/* WLC_AMPDUDATAHIWAT */
-
-/* bounded rx loops */
-#ifndef RXBND
-#define RXBND		8	/* max # frames to process in wlc_recv() */
-#endif				/* RXBND */
-#ifndef TXSBND
-#define TXSBND		8	/* max # tx status to process in wlc_txstatus() */
-#endif				/* TXSBND */
-
-#define BAND_5G(bt)	((bt) == WLC_BAND_5G)
-#define BAND_2G(bt)	((bt) == WLC_BAND_2G)
-
-#define WLBANDINITDATA(_data)	_data
-#define WLBANDINITFN(_fn)	_fn
-
-#endif				/* _BRCM_CFG_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 5dce267..ffeaedf 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -26,7 +26,6 @@
 
 #include "types.h"
 #include "d11.h"
-#include "cfg.h"
 #include "scb.h"
 #include "pub.h"
 #include "key.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.h b/drivers/staging/brcm80211/brcmsmac/channel.h
index f50a66e..3017839 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.h
+++ b/drivers/staging/brcm80211/brcmsmac/channel.h
@@ -19,6 +19,7 @@
 
 #define WLC_TXPWR_DB_FACTOR 4	/* conversion for phy txpwr cacluations that use .25 dB units */
 
+
 struct wlc_info;
 
 /* maxpwr mapping to 5GHz band channels:
@@ -50,6 +51,12 @@ struct wlc_info;
 #define WLC_MAXPWR_TBL_SIZE		6	/* max of BAND_5G_PWR_LVLS and 6 for 2.4 GHz */
 #define WLC_MAXPWR_MIMO_TBL_SIZE	14	/* max of BAND_5G_PWR_LVLS and 14 for 2.4 GHz */
 
+#define NBANDS(wlc) ((wlc)->pub->_nbands)
+#define NBANDS_PUB(pub) ((pub)->_nbands)
+#define NBANDS_HW(hw) ((hw)->_nbands)
+
+#define IS_SINGLEBAND_5G(device)	0
+
 /* locale channel and power info. */
 typedef struct {
 	u32 valid_channels;
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 1029392..e85a456 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -34,7 +34,6 @@
 #include "phy/phy_int.h"
 #include "d11.h"
 #include "types.h"
-#include "cfg.h"
 #include "key.h"
 #include "channel.h"
 #include "scb.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index fc3d71d..e2ea9b4 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -30,12 +30,10 @@
 #include "pmu.h"
 #include "d11.h"
 #include "types.h"
-#include "cfg.h"
 #include "rate.h"
 #include "scb.h"
 #include "pub.h"
 #include "key.h"
-#include "bsscfg.h"
 #include "phy/phy_hal.h"
 #include "channel.h"
 #include "main.h"
@@ -239,6 +237,18 @@ const u8 prio2fifo[NUMPRIO] = {
 #define	_WLC_PREC_VO		12	/* Vo - Voice */
 #define	_WLC_PREC_NC		14	/* NC - Network Control */
 
+#define MAXMACLIST		64	/* max # source MAC matches */
+#define BCN_TEMPLATE_COUNT 	2
+
+#define WLC_BSSCFG_HW_BCN	0x20	/* The BSS is generating beacons in HW */
+
+#define HWBCN_ENAB(cfg)		(((cfg)->flags & WLC_BSSCFG_HW_BCN) != 0)
+#define HWPRB_ENAB(cfg)		(((cfg)->flags & WLC_BSSCFG_HW_PRB) != 0)
+
+#define MBSS_BCN_ENAB(cfg)       0
+#define MBSS_PRB_ENAB(cfg)       0
+#define SOFTBCN_ENAB(pub)    (0)
+
 /* 802.1D Priority to precedence queue mapping */
 const u8 wlc_prio2prec_map[] = {
 	_WLC_PREC_BE,		/* 0 BE - Best-effort */
@@ -251,6 +261,22 @@ const u8 wlc_prio2prec_map[] = {
 	_WLC_PREC_NC,		/* 7 NC - Network Control */
 };
 
+/* Check if a particular BSS config is AP or STA */
+#define BSSCFG_AP(cfg)		(0)
+#define BSSCFG_STA(cfg)		(1)
+#define BSSCFG_IBSS(cfg)	(!(cfg)->BSS)
+
+/* Iterator for "associated" STA bss configs:
+   (struct wlc_info *wlc, int idx, struct wlc_bsscfg *cfg) */
+#define FOREACH_AS_STA(wlc, idx, cfg) \
+	for (idx = 0; (int) idx < WLC_MAXBSSCFG; idx++) \
+		if ((cfg = (wlc)->bsscfg[idx]) && BSSCFG_STA(cfg) && cfg->associated)
+
+/* As above for all non-NULL BSS configs */
+#define FOREACH_BSS(wlc, idx, cfg) \
+	for (idx = 0; (int) idx < WLC_MAXBSSCFG; idx++) \
+		if ((cfg = (wlc)->bsscfg[idx]))
+
 /* Sanity check for tx_prec_map and fifo synchup
  * Either there are some packets pending for the fifo, else if fifo is empty then
  * all the corresponding precmap bits should be set
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index f556faf..201c644 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -33,6 +33,8 @@
 #define EDCF_AIFSN_MIN               1
 #define FRAGNUM_MASK		0xF
 
+#define NTXRATE			64	/* # tx MPDUs rate is reported for */
+
 #define WLC_BITSCNT(x)	brcmu_bitcount((u8 *)&(x), sizeof(u8))
 
 /* Maximum wait time for a MAC suspend */
@@ -719,6 +721,84 @@ struct antsel_info {
 	wlc_antselcfg_t antcfg_cur;	/* current antenna config (auto) */
 };
 
+/* BSS configuration state */
+struct wlc_bsscfg {
+	struct wlc_info *wlc;	/* wlc to which this bsscfg belongs to. */
+	bool up;		/* is this configuration up operational */
+	bool enable;		/* is this configuration enabled */
+	bool associated;	/* is BSS in ASSOCIATED state */
+	bool BSS;		/* infraustructure or adhac */
+	bool dtim_programmed;
+
+	u8 SSID_len;		/* the length of SSID */
+	u8 SSID[IEEE80211_MAX_SSID_LEN]; /* SSID string */
+	struct scb *bcmc_scb[MAXBANDS];	/* one bcmc_scb per band */
+	s8 _idx;		/* the index of this bsscfg,
+				 * assigned at wlc_bsscfg_alloc()
+				 */
+	/* MAC filter */
+	uint nmac;		/* # of entries on maclist array */
+	int macmode;		/* allow/deny stations on maclist array */
+	struct ether_addr *maclist;	/* list of source MAC addrs to match */
+
+	/* security */
+	u32 wsec;		/* wireless security bitvec */
+	s16 auth;		/* 802.11 authentication: Open, Shared Key, WPA */
+	s16 openshared;	/* try Open auth first, then Shared Key */
+	bool wsec_restrict;	/* drop unencrypted packets if wsec is enabled */
+	bool eap_restrict;	/* restrict data until 802.1X auth succeeds */
+	u16 WPA_auth;	/* WPA: authenticated key management */
+	bool wpa2_preauth;	/* default is true, wpa_cap sets value */
+	bool wsec_portopen;	/* indicates keys are plumbed */
+	wsec_iv_t wpa_none_txiv;	/* global txiv for WPA_NONE, tkip and aes */
+	int wsec_index;		/* 0-3: default tx key, -1: not set */
+	wsec_key_t *bss_def_keys[WLC_DEFAULT_KEYS];	/* default key storage */
+
+	/* TKIP countermeasures */
+	bool tkip_countermeasures;	/* flags TKIP no-assoc period */
+	u32 tk_cm_dt;	/* detect timer */
+	u32 tk_cm_bt;	/* blocking timer */
+	u32 tk_cm_bt_tmstmp;	/* Timestamp when TKIP BT is activated */
+	bool tk_cm_activate;	/* activate countermeasures after EAPOL-Key sent */
+
+	u8 BSSID[ETH_ALEN];	/* BSSID (associated) */
+	u8 cur_etheraddr[ETH_ALEN];	/* h/w address */
+	u16 bcmc_fid;	/* the last BCMC FID queued to TX_BCMC_FIFO */
+	u16 bcmc_fid_shm;	/* the last BCMC FID written to shared mem */
+
+	u32 flags;		/* WLC_BSSCFG flags; see below */
+
+	u8 *bcn;		/* AP beacon */
+	uint bcn_len;		/* AP beacon length */
+	bool ar_disassoc;	/* disassociated in associated recreation */
+
+	int auth_atmptd;	/* auth type (open/shared) attempted */
+
+	pmkid_cand_t pmkid_cand[MAXPMKID];	/* PMKID candidate list */
+	uint npmkid_cand;	/* num PMKID candidates */
+	pmkid_t pmkid[MAXPMKID];	/* PMKID cache */
+	uint npmkid;		/* num cached PMKIDs */
+
+	wlc_bss_info_t *current_bss;	/* BSS parms in ASSOCIATED state */
+
+	/* PM states */
+	bool PMawakebcn;	/* bcn recvd during current waking state */
+	bool PMpending;		/* waiting for tx status with PM indicated set */
+	bool priorPMstate;	/* Detecting PM state transitions */
+	bool PSpoll;		/* whether there is an outstanding PS-Poll frame */
+
+	/* BSSID entry in RCMTA, use the wsec key management infrastructure to
+	 * manage the RCMTA entries.
+	 */
+	wsec_key_t *rcmta;
+
+	/* 'unique' ID of this bsscfg, assigned at bsscfg allocation */
+	u16 ID;
+
+	uint txrspecidx;	/* index into tx rate circular buffer */
+	ratespec_t txrspec[NTXRATE][2];	/* circular buffer of prev MPDUs tx rates */
+};
+
 #define	CHANNEL_BANDUNIT(wlc, ch) (((ch) <= CH_MAX_2G_CHANNEL) ? BAND_2G_INDEX : BAND_5G_INDEX)
 #define	OTHERBANDUNIT(wlc)	((uint)((wlc)->band->bandunit ? BAND_2G_INDEX : BAND_5G_INDEX))
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index c67bf8b..0185788 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -14,8 +14,6 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <cfg.h>
-
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/bitops.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index de301aad..84d50c2 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -18,7 +18,6 @@
 #include <linux/string.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
-#include <cfg.h>
 #include <linux/pci.h>
 #include <brcmu_utils.h>
 #include <aiutils.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 0dc614a..e10f98d 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -17,7 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <defs.h>
-#include <cfg.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <aiutils.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index 8b891f4..d8dec65 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -33,7 +33,6 @@
 #include <pmu.h>
 
 #include "types.h"
-#include "cfg.h"
 #include "d11.h"
 #include "rate.h"
 #include "scb.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.c b/drivers/staging/brcm80211/brcmsmac/rate.c
index 807c0f6..5162ec2 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/rate.c
@@ -23,7 +23,6 @@
 
 #include "types.h"
 #include "d11.h"
-#include "cfg.h"
 #include "scb.h"
 #include "pub.h"
 #include "rate.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index a0abef3..9b0f335 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -25,7 +25,6 @@
 
 #include "types.h"
 #include "d11.h"
-#include "cfg.h"
 #include "rate.h"
 #include "scb.h"
 #include "pub.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 526d3e3..e907990 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -71,6 +71,176 @@
 #define BOARD_GPIO_12		0x1000	/* gpio 12 */
 #define BOARD_GPIO_13		0x2000	/* gpio 13 */
 
+/* **** Core type/rev defaults **** */
+#define D11CONF		0x0fffffb0	/* Supported  D11 revs: 4, 5, 7-27
+					 * also need to update wlc.h MAXCOREREV
+					 */
+
+#define NCONF		0x000001ff	/* Supported nphy revs:
+					 *      0       4321a0
+					 *      1       4321a1
+					 *      2       4321b0/b1/c0/c1
+					 *      3       4322a0
+					 *      4       4322a1
+					 *      5       4716a0
+					 *      6       43222a0, 43224a0
+					 *      7       43226a0
+					 *      8       5357a0, 43236a0
+					 */
+
+#define LCNCONF		0x00000007	/* Supported lcnphy revs:
+					 *      0       4313a0, 4336a0, 4330a0
+					 *      1
+					 *      2       4330a0
+					 */
+
+#define SSLPNCONF 	0x0000000f	/* Supported sslpnphy revs:
+					 *      0       4329a0/k0
+					 *      1       4329b0/4329C0
+					 *      2       4319a0
+					 *      3       5356a0
+					 */
+
+/********************************************************************
+ * Phy/Core Configuration.  Defines macros to to check core phy/rev *
+ * compile-time configuration.  Defines default core support.       *
+ * ******************************************************************
+ */
+
+/* Basic macros to check a configuration bitmask */
+
+#define CONF_HAS(config, val)	((config) & (1 << (val)))
+#define CONF_MSK(config, mask)	((config) & (mask))
+#define MSK_RANGE(low, hi)	((1 << ((hi)+1)) - (1 << (low)))
+#define CONF_RANGE(config, low, hi) (CONF_MSK(config, MSK_RANGE(low, high)))
+
+#define CONF_IS(config, val)	((config) == (1 << (val)))
+#define CONF_GE(config, val)	((config) & (0-(1 << (val))))
+#define CONF_GT(config, val)	((config) & (0-2*(1 << (val))))
+#define CONF_LT(config, val)	((config) & ((1 << (val))-1))
+#define CONF_LE(config, val)	((config) & (2*(1 << (val))-1))
+
+/* Wrappers for some of the above, specific to config constants */
+
+#define NCONF_HAS(val)	CONF_HAS(NCONF, val)
+#define NCONF_MSK(mask)	CONF_MSK(NCONF, mask)
+#define NCONF_IS(val)	CONF_IS(NCONF, val)
+#define NCONF_GE(val)	CONF_GE(NCONF, val)
+#define NCONF_GT(val)	CONF_GT(NCONF, val)
+#define NCONF_LT(val)	CONF_LT(NCONF, val)
+#define NCONF_LE(val)	CONF_LE(NCONF, val)
+
+#define LCNCONF_HAS(val)	CONF_HAS(LCNCONF, val)
+#define LCNCONF_MSK(mask)	CONF_MSK(LCNCONF, mask)
+#define LCNCONF_IS(val)		CONF_IS(LCNCONF, val)
+#define LCNCONF_GE(val)		CONF_GE(LCNCONF, val)
+#define LCNCONF_GT(val)		CONF_GT(LCNCONF, val)
+#define LCNCONF_LT(val)		CONF_LT(LCNCONF, val)
+#define LCNCONF_LE(val)		CONF_LE(LCNCONF, val)
+
+#define D11CONF_HAS(val) CONF_HAS(D11CONF, val)
+#define D11CONF_MSK(mask) CONF_MSK(D11CONF, mask)
+#define D11CONF_IS(val)	CONF_IS(D11CONF, val)
+#define D11CONF_GE(val)	CONF_GE(D11CONF, val)
+#define D11CONF_GT(val)	CONF_GT(D11CONF, val)
+#define D11CONF_LT(val)	CONF_LT(D11CONF, val)
+#define D11CONF_LE(val)	CONF_LE(D11CONF, val)
+
+#define PHYCONF_HAS(val) CONF_HAS(PHYTYPE, val)
+#define PHYCONF_IS(val)	CONF_IS(PHYTYPE, val)
+
+#define NREV_IS(var, val)	(NCONF_HAS(val) && (NCONF_IS(val) || ((var) == (val))))
+#define NREV_GE(var, val)	(NCONF_GE(val) && (!NCONF_LT(val) || ((var) >= (val))))
+#define NREV_GT(var, val)	(NCONF_GT(val) && (!NCONF_LE(val) || ((var) > (val))))
+#define NREV_LT(var, val)	(NCONF_LT(val) && (!NCONF_GE(val) || ((var) < (val))))
+#define NREV_LE(var, val)	(NCONF_LE(val) && (!NCONF_GT(val) || ((var) <= (val))))
+
+#define LCNREV_IS(var, val)	(LCNCONF_HAS(val) && (LCNCONF_IS(val) || ((var) == (val))))
+#define LCNREV_GE(var, val)	(LCNCONF_GE(val) && (!LCNCONF_LT(val) || ((var) >= (val))))
+#define LCNREV_GT(var, val)	(LCNCONF_GT(val) && (!LCNCONF_LE(val) || ((var) > (val))))
+#define LCNREV_LT(var, val)	(LCNCONF_LT(val) && (!LCNCONF_GE(val) || ((var) < (val))))
+#define LCNREV_LE(var, val)	(LCNCONF_LE(val) && (!LCNCONF_GT(val) || ((var) <= (val))))
+
+#define D11REV_IS(var, val)	(D11CONF_HAS(val) && (D11CONF_IS(val) || ((var) == (val))))
+#define D11REV_GE(var, val)	(D11CONF_GE(val) && (!D11CONF_LT(val) || ((var) >= (val))))
+#define D11REV_GT(var, val)	(D11CONF_GT(val) && (!D11CONF_LE(val) || ((var) > (val))))
+#define D11REV_LT(var, val)	(D11CONF_LT(val) && (!D11CONF_GE(val) || ((var) < (val))))
+#define D11REV_LE(var, val)	(D11CONF_LE(val) && (!D11CONF_GT(val) || ((var) <= (val))))
+
+#define PHYTYPE_IS(var, val)	(PHYCONF_HAS(val) && (PHYCONF_IS(val) || ((var) == (val))))
+
+/* Finally, early-exit from switch case if anyone wants it... */
+
+#define CASECHECK(config, val)	if (!(CONF_HAS(config, val))) break
+#define CASEMSK(config, mask)	if (!(CONF_MSK(config, mask))) break
+
+/* Set up PHYTYPE automatically: (depends on PHY_TYPE_X, from d11.h) */
+
+#define _PHYCONF_N (1 << PHY_TYPE_N)
+#define _PHYCONF_LCN (1 << PHY_TYPE_LCN)
+#define _PHYCONF_SSLPN (1 << PHY_TYPE_SSN)
+
+#define PHYTYPE (_PHYCONF_N | _PHYCONF_LCN | _PHYCONF_SSLPN)
+
+/* Utility macro to identify 802.11n (HT) capable PHYs */
+#define PHYTYPE_11N_CAP(phytype) \
+	(PHYTYPE_IS(phytype, PHY_TYPE_N) ||	\
+	 PHYTYPE_IS(phytype, PHY_TYPE_LCN) || \
+	 PHYTYPE_IS(phytype, PHY_TYPE_SSN))
+
+/* Last but not least: shorter wlc-specific var checks */
+#define WLCISNPHY(band)		PHYTYPE_IS((band)->phytype, PHY_TYPE_N)
+#define WLCISLCNPHY(band)	PHYTYPE_IS((band)->phytype, PHY_TYPE_LCN)
+#define WLCISSSLPNPHY(band)	PHYTYPE_IS((band)->phytype, PHY_TYPE_SSN)
+
+#define WLC_PHY_11N_CAP(band)	PHYTYPE_11N_CAP((band)->phytype)
+
+/**********************************************************************
+ * ------------- End of Core phy/rev configuration. ----------------- *
+ * ********************************************************************
+ */
+
+/*************************************************
+ * Defaults for tunables (e.g. sizing constants)
+ *
+ * For each new tunable, add a member to the end
+ * of wlc_tunables_t in wlc_pub.h to enable
+ * runtime checks of tunable values. (Directly
+ * using the macros in code invalidates ROM code)
+ *
+ * ***********************************************
+ */
+#define NTXD		256	/* Max # of entries in Tx FIFO based on 4kb page size */
+#define NRXD		256	/* Max # of entries in Rx FIFO based on 4kb page size */
+#define	NRXBUFPOST	32	/* try to keep this # rbufs posted to the chip */
+#define MAXSCB		32	/* Maximum SCBs in cache for STA */
+#define AMPDU_NUM_MPDU		16	/* max allowed number of mpdus in an ampdu (2 streams) */
+
+/* Count of packet callback structures. either of following
+ * 1. Set to the number of SCBs since a STA
+ * can queue up a rate callback for each IBSS STA it knows about, and an AP can
+ * queue up an "are you there?" Null Data callback for each associated STA
+ * 2. controlled by tunable config file
+ */
+#define MAXPKTCB	MAXSCB	/* Max number of packet callbacks */
+
+/* NetBSD also needs to keep track of this */
+#define WLC_MAX_UCODE_BSS	(16)	/* Number of BSS handled in ucode bcn/prb */
+#define WLC_MAX_UCODE_BSS4	(4)	/* Number of BSS handled in sw bcn/prb */
+#define WLC_MAXBSSCFG		(1)	/* max # BSS configs */
+#define MAXBSS		64	/* max # available networks */
+#define WLC_DATAHIWAT		50	/* data msg txq hiwat mark */
+#define WLC_AMPDUDATAHIWAT 255
+
+/* bounded rx loops */
+#define RXBND		8	/* max # frames to process in wlc_recv() */
+#define TXSBND		8	/* max # tx status to process in wlc_txstatus() */
+
+#define WLBANDINITFN(_fn)	_fn
+
+#define BAND_5G(bt)	((bt) == WLC_BAND_5G)
+#define BAND_2G(bt)	((bt) == WLC_BAND_2G)
+
 #define BCMMSG(dev, fmt, args...)		\
 do {						\
 	if (brcm_msg_level & LOG_TRACE_VAL)	\
@@ -173,6 +343,7 @@ do {						\
 #define SET_REG(r, mask, val) \
 		W_REG((r), ((R_REG(r) & ~(mask)) | (val)))
 
+
 /* forward declarations */
 struct sk_buff;
 struct brcms_info;
-- 
1.7.4.1


