Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4678 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab1FIOpT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:19 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 15/21] staging: brcm80211: removed superfluous forward
 struct declarations
Date: Thu, 9 Jun 2011 16:44:55 +0200
Message-ID: <1307630701-9170-16-git-send-email-rvossen@broadcom.com> (sfid-20110609_164550_192173_AD0D3E95)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reported-by: Julian Calaby <julian.calaby@gmail.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_iw.c       |    2 --
 drivers/staging/brcm80211/brcmsmac/channel.h     |    2 --
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    4 ----
 drivers/staging/brcm80211/brcmsmac/nicpci.h      |    2 --
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h |    4 ----
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |    4 ----
 drivers/staging/brcm80211/brcmsmac/phy_shim.h    |    4 ----
 drivers/staging/brcm80211/brcmsmac/pub.h         |   14 --------------
 drivers/staging/brcm80211/brcmsmac/rate.h        |    2 --
 drivers/staging/brcm80211/brcmsmac/types.h       |    2 ++
 drivers/staging/brcm80211/include/brcmu_utils.h  |    2 +-
 11 files changed, 3 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 14b2e1b..cb8d614 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -28,8 +28,6 @@
 #include "dngl_stats.h"
 #include "dhd.h"
 
-struct si_pub;
-
 #define WPA_OUI			"\x00\x50\xF2"
 #define DOT11_MNG_RSN_ID			48
 #define DOT11_MNG_WPA_ID			221
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.h b/drivers/staging/brcm80211/brcmsmac/channel.h
index e743392..5ab1032 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.h
+++ b/drivers/staging/brcm80211/brcmsmac/channel.h
@@ -20,8 +20,6 @@
 #define WLC_TXPWR_DB_FACTOR 4	/* conversion for phy txpwr cacluations that use .25 dB units */
 
 
-struct brcms_c_info;
-
 /* maxpwr mapping to 5GHz band channels:
  * maxpwr[0] - channels [34-48]
  * maxpwr[1] - channels [52-60]
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index 71526b2..26a0a30 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -83,9 +83,6 @@ struct brcms_info {
 };
 
 /* misc callbacks */
-struct brcms_info;
-struct brcms_if;
-struct brcms_c_if;
 extern void brcms_init(struct brcms_info *wl);
 extern uint brcms_reset(struct brcms_info *wl);
 extern void brcms_intrson(struct brcms_info *wl);
@@ -99,7 +96,6 @@ extern bool wl_alloc_dma_resources(struct brcms_info *wl, uint dmaddrwidth);
 extern bool brcms_rfkill_set_hw_state(struct brcms_info *wl);
 
 /* timer functions */
-struct brcms_timer;
 extern struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
 				      void (*fn) (void *arg), void *arg,
 				      const char *name);
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.h b/drivers/staging/brcm80211/brcmsmac/nicpci.h
index 826c162..f71f842 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.h
@@ -70,8 +70,6 @@
 #define SRSH_PI_MASK	0xf000	/* bit 15:12 */
 #define SRSH_PI_SHIFT	12	/* bit 15:12 */
 
-struct si_pub;
-
 extern void *pcicore_init(struct si_pub *sih, void *pdev, void *regs);
 extern void pcicore_deinit(void *pch);
 extern void pcicore_attach(void *pch, char *pvars, int state);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index db99440..756ad71 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -154,10 +154,6 @@ struct chanvec {
 	u8 vec[MAXCHANNEL / NBBY];
 };
 
-struct rpc_info;
-
-struct phy_pub;
-
 struct shared_phy_params {
 	struct si_pub *sih;
 	void *physhim;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index fa0ff3f..9506da5 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -49,7 +49,6 @@ struct wlc_phy_srom_fem {
 	u8 antswctrllut;	/* antswctrl lookup table configuration: 32 possible choices */
 };
 
-struct brcms_c_hw_info;
 typedef void (*initfn_t) (phy_info_t *);
 typedef void (*chansetfn_t) (phy_info_t *, chanspec_t);
 typedef int (*longtrnfn_t) (phy_info_t *, int);
@@ -579,9 +578,6 @@ struct phy_pub {
 	bool abgphy_encore;
 };
 
-struct phy_info_nphy;
-struct phy_info_lcnphy;
-
 struct phy_func_ptr {
 	initfn_t init;
 	initfn_t calinit;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index 4b45b2c..413d5db 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -108,15 +108,11 @@
 #define WLC_N_TXRX_CHAIN0		0
 #define WLC_N_TXRX_CHAIN1		1
 
-/* Forward declarations */
-struct brcms_c_hw_info;
-
 extern wlc_phy_shim_info_t *wlc_phy_shim_attach(struct brcms_c_hw_info *wlc_hw,
 						void *wl, void *wlc);
 extern void wlc_phy_shim_detach(wlc_phy_shim_info_t *physhim);
 
 /* PHY to WL utility functions */
-struct wlapi_timer;
 extern struct wlapi_timer *wlapi_init_timer(wlc_phy_shim_info_t *physhim,
 					    void (*fn) (void *arg), void *arg,
 					    const char *name);
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 25c65e8..2ec3ba9 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -106,8 +106,6 @@
 #define	WL_SPURAVOID_ON1	1
 #define	WL_SPURAVOID_ON2	2
 
-struct ieee80211_tx_queue_params;
-
 struct wlc_tunables {
 	int ntxd;		/* size of tx descriptor table */
 	int nrxd;		/* size of rx descriptor table */
@@ -187,9 +185,6 @@ struct wlc_bss_info {
 	u8 wpacfg;		/* wpa config index */
 };
 
-/* forward declarations */
-struct brcms_c_if;
-
 /* brcms_c_ioctl error codes */
 #define WLC_ENOIOCTL	1	/* No such Ioctl */
 #define WLC_EINVAL	2	/* Invalid value */
@@ -384,14 +379,6 @@ enum wlc_par_id {
 	IOV_BCN_LI_BCN		/* Beacon listen interval in # of beacons */
 };
 
-/* forward declare and use the struct notation so we don't have to
- * have it defined if not necessary.
- */
-struct brcms_c_info;
-struct brcms_c_hw_info;
-struct brcms_c_bsscfg;
-struct brcms_c_if;
-
 /***********************************************
  * Feature-related macros to optimize out code *
  * *********************************************
@@ -637,7 +624,6 @@ extern void wlc_rate_lookup_init(struct brcms_c_info *wlc,
 				 wlc_rateset_t *rateset);
 extern void brcms_default_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs);
 
-struct ieee80211_sta;
 extern void wlc_ampdu_flush(struct brcms_c_info *wlc,
 			    struct ieee80211_sta *sta, u16 tid);
 extern int brcms_c_set_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.h b/drivers/staging/brcm80211/brcmsmac/rate.h
index 36cb91b..28ba4d6 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/rate.h
@@ -138,8 +138,6 @@ extern const u8 ofdm_rate_lookup[];
 #define WLC_RATES_CCK		1
 #define WLC_RATES_OFDM		2
 
-struct wlc_rateset;
-
 /* sanitize, and sort a rateset with the basic bit(s) preserved, validate rateset */
 extern bool wlc_rate_hwrs_filter_sort_validate(struct wlc_rateset *rs,
 					       const struct wlc_rateset *hw_rs,
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 3f53e8c..163973d 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -371,6 +371,8 @@ struct wiphy;
 struct brcmu_iovar;
 struct brcms_c_txq_info;
 struct brcms_c_band;
+struct ieee80211_tx_queue_params;
+struct ieee80211_sta;
 
 typedef struct gpioh_item gpioh_item_t;
 typedef struct si_info si_info_t;
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index 863b3c7..78c84e2 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -139,7 +139,7 @@ extern uint brcmu_pkttotlen(struct sk_buff *p);
 extern int brcmu_ether_atoe(char *p, u8 *ea);
 
 /* ip address */
-	struct ipv4_addr;
+struct ipv4_addr;
 
 #ifdef BCMDBG
 extern void brcmu_prpkt(const char *msg, struct sk_buff *p0);
-- 
1.7.4.1


