Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1624 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab1ECJgN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 05/61] staging: brcm80211: making wiphy object
 accessible from wlc and phy
Date: Tue, 3 May 2011 11:35:05 +0200
Message-ID: <1304415361-7813-6-git-send-email-arend@broadcom.com> (sfid-20110503_113624_911384_AFA99AE2)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Next commits will replace WL_ERROR and friends with BCMMSG. Because
this new message log function require a wiphy object, device object pointers
have been added to three data structures.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |    4 +++-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h   |    3 ++-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_int.h   |    1 +
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    1 +
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.h   |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    3 ++-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |    8 ++++++--
 drivers/staging/brcm80211/brcmsmac/wlc_main.h      |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h       |    2 +-
 9 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index 873d64c..8fb3e04 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -581,7 +581,8 @@ void wlc_phy_shared_detach(shared_phy_t *phy_sh)
 	}
 }
 
-wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype, char *vars)
+wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype,
+			  char *vars, struct wiphy *wiphy)
 {
 	phy_info_t *pi;
 	u32 sflags = 0;
@@ -611,6 +612,7 @@ wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype, char *vars
 	if (pi == NULL) {
 		return NULL;
 	}
+	pi->wiphy = wiphy;
 	pi->regs = (d11regs_t *) regs;
 	pi->sh = sh;
 	pi->phy_init_por = true;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
index bf962d5..12eabc9 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
@@ -21,6 +21,7 @@
 #include <siutils.h>
 #include <d11.h>
 #include <wlc_phy_shim.h>
+#include <net/mac80211.h>	/* struct wiphy */
 
 #define	IDCODE_VER_MASK		0x0000000f
 #define	IDCODE_VER_SHIFT	0
@@ -149,7 +150,7 @@ typedef struct shared_phy_params {
 extern shared_phy_t *wlc_phy_shared_attach(shared_phy_params_t *shp);
 extern void wlc_phy_shared_detach(shared_phy_t *phy_sh);
 extern wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype,
-				 char *vars);
+				 char *vars, struct wiphy *wiphy);
 extern void wlc_phy_detach(wlc_phy_t *ppi);
 
 extern bool wlc_phy_get_phyversion(wlc_phy_t *pih, u16 *phytype,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
index 6e12a95..3d1cd34 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
@@ -936,6 +936,7 @@ struct phy_info {
 	u8 phycal_tempdelta;
 	u32 mcs20_po;
 	u32 mcs40_po;
+	struct wiphy *wiphy;
 };
 
 typedef s32 fixed;
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 3c9994a..f2e481f 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -722,6 +722,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	hw = pci_get_drvdata(btparam);	/* btparam == pdev */
 	wl = hw->priv;
 	ASSERT(wl);
+	wl->wiphy = hw->wiphy;
 
 	atomic_set(&wl->callbacks, 0);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
index f3198cc..e7e9516 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
@@ -72,6 +72,7 @@ struct wl_info {
 	/* ping-pong stats counters updated by Linux watchdog */
 	struct net_device_stats stats_watchdog[2];
 	struct wl_firmware fw;
+	struct wiphy *wiphy;
 };
 
 #define WL_LOCK(wl)	spin_lock_bh(&(wl)->lock)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index bd8a629..9c4b313 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -849,7 +849,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 
 		/* Get a phy for this band */
 		wlc_hw->band->pi = wlc_phy_attach(wlc_hw->phy_sh,
-			(void *)regs, wlc_bmac_bandtype(wlc_hw), vars);
+			(void *)regs, wlc_bmac_bandtype(wlc_hw), vars,
+			wlc->wiphy);
 		if (wlc_hw->band->pi == NULL) {
 			WL_ERROR("wl%d: wlc_bmac_attach: wlc_phy_attach failed\n",
 				 unit);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 8c9e1fb..b4ca207 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -52,6 +52,8 @@
 #include "wlc_alloc.h"
 #include "wl_dbg.h"
 
+#include "wl_mac80211.h"
+
 /*
  *	Disable statistics counting for WME
  */
@@ -1674,8 +1676,9 @@ struct wlc_pub *wlc_pub(void *wlc)
 /*
  * The common driver entry routine. Error codes should be unique
  */
-void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
-		 void *regsva, uint bustype, void *btparam, uint *perr)
+void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
+		 bool piomode, void *regsva, uint bustype, void *btparam,
+		 uint *perr)
 {
 	struct wlc_info *wlc;
 	uint err = 0;
@@ -1688,6 +1691,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	wlc = (struct wlc_info *) wlc_attach_malloc(unit, &err, device);
 	if (wlc == NULL)
 		goto fail;
+	wlc->wiphy = wl->wiphy;
 	pub = wlc->pub;
 
 #if defined(BCMDBG)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index f11161d..a858356 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -757,6 +757,7 @@ struct wlc_info {
 				 */
 	bool pr80838_war;
 	uint hwrxoff;
+	struct wiphy *wiphy;
 };
 
 /* antsel module specific state */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index 273c508..2b51440 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -480,7 +480,7 @@ extern const u8 wme_fifo2ac[];
 #define	WLC_PROT_N_OBSS		16	/* non-HT OBSS present */
 
 /* common functions for every port */
-extern void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit,
+extern void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
 			bool piomode, void *regsva, uint bustype, void *btparam,
 			uint *perr);
 extern uint wlc_detach(struct wlc_info *wlc);
-- 
1.7.4.1


