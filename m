Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3190 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab1DULD1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 07:03:27 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3 2/3] staging: brcm80211: making device object
 accessible from wlc and phy
Date: Thu, 21 Apr 2011 13:02:04 +0200
Message-ID: <1303383725-1440-3-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303383725-1440-1-git-send-email-rvossen@broadcom.com>
References: <1303383725-1440-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Next commits will replace WL_ERROR with dev_err and friends. Because
these functions require a linux device object, device object pointers
have been added to three data structures.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |    4 +++-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h   |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_int.h   |    1 +
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    9 +++++----
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.h   |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    3 ++-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |    4 +++-
 drivers/staging/brcm80211/brcmsmac/wlc_main.h      |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h       |    2 +-
 9 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index 873d64c..9790de2 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -581,7 +581,8 @@ void wlc_phy_shared_detach(shared_phy_t *phy_sh)
 	}
 }
 
-wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype, char *vars)
+wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype,
+			  char *vars, struct device *dev)
 {
 	phy_info_t *pi;
 	u32 sflags = 0;
@@ -611,6 +612,7 @@ wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype, char *vars
 	if (pi == NULL) {
 		return NULL;
 	}
+	pi->dev = dev;
 	pi->regs = (d11regs_t *) regs;
 	pi->sh = sh;
 	pi->phy_init_por = true;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
index bf962d5..6faf7a5 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
@@ -149,7 +149,7 @@ typedef struct shared_phy_params {
 extern shared_phy_t *wlc_phy_shared_attach(shared_phy_params_t *shp);
 extern void wlc_phy_shared_detach(shared_phy_t *phy_sh);
 extern wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype,
-				 char *vars);
+				 char *vars, struct device *dev);
 extern void wlc_phy_detach(wlc_phy_t *ppi);
 
 extern bool wlc_phy_get_phyversion(wlc_phy_t *pih, u16 *phytype,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
index 6e12a95..479a9b0 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
@@ -936,6 +936,7 @@ struct phy_info {
 	u8 phycal_tempdelta;
 	u32 mcs20_po;
 	u32 mcs40_po;
+	struct device *dev;
 };
 
 typedef s32 fixed;
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 62d4a86..1477419 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -746,6 +746,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	wl = hw->priv;
 	ASSERT(wl);
 
+	wl->dev = get_device(&hw->wiphy->dev);
+
 	atomic_set(&wl->callbacks, 0);
 
 	/* setup the bottom half handler */
@@ -784,7 +786,8 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 	/* common load-time initialization */
 	wl->wlc = wlc_attach((void *)wl, vendor, device, unit, wl->piomode,
-			     wl->regsva, wl->bcm_bustype, btparam, &err);
+			     wl->regsva, wl->bcm_bustype, btparam, &err,
+			     &hw->wiphy->dev);
 	wl_release_fw(wl);
 	if (!wl->wlc) {
 		WL_ERROR("%s: wlc_attach() failed with code %d\n",
@@ -847,7 +850,6 @@ fail1:
 }
 
 
-
 #define CHAN2GHZ(channel, freqency, chflags)  { \
 	.band = IEEE80211_BAND_2GHZ, \
 	.center_freq = (freqency), \
@@ -1253,9 +1255,7 @@ static void wl_remove(struct pci_dev *pdev)
 		no_printk("%s: Down\n", __func__);
 	}
 	pci_disable_device(pdev);
-
 	wl_free(wl);
-
 	pci_set_drvdata(pdev, NULL);
 	ieee80211_free_hw(hw);
 }
@@ -1388,6 +1388,7 @@ static void wl_free(struct wl_info *wl)
 		iounmap((void *)wl->regsva);
 	}
 	wl->regsva = NULL;
+	put_device(wl->dev);
 }
 
 /*
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
index f3198cc..6b0d4e0 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.h
@@ -72,6 +72,7 @@ struct wl_info {
 	/* ping-pong stats counters updated by Linux watchdog */
 	struct net_device_stats stats_watchdog[2];
 	struct wl_firmware fw;
+	struct device *dev;	/* linux device object */
 };
 
 #define WL_LOCK(wl)	spin_lock_bh(&(wl)->lock)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index f52b339..d596476 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -849,7 +849,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 
 		/* Get a phy for this band */
 		wlc_hw->band->pi = wlc_phy_attach(wlc_hw->phy_sh,
-			(void *)regs, wlc_bmac_bandtype(wlc_hw), vars);
+			(void *)regs, wlc_bmac_bandtype(wlc_hw), vars,
+			wlc->dev);
 		if (wlc_hw->band->pi == NULL) {
 			WL_ERROR("wl%d: wlc_bmac_attach: wlc_phy_attach failed\n",
 				 unit);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 2cf154b..a8b8991 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -1675,7 +1675,8 @@ struct wlc_pub *wlc_pub(void *wlc)
  * The common driver entry routine. Error codes should be unique
  */
 void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
-		 void *regsva, uint bustype, void *btparam, uint *perr)
+		 void *regsva, uint bustype, void *btparam, uint *perr,
+		 struct device *dev)
 {
 	struct wlc_info *wlc;
 	uint err = 0;
@@ -1691,6 +1692,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 	wlc = (struct wlc_info *) wlc_attach_malloc(unit, &err, device);
 	if (wlc == NULL)
 		goto fail;
+	wlc->dev = dev;
 	pub = wlc->pub;
 
 #if defined(BCMDBG)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index f11161d..c9cc63a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -757,6 +757,7 @@ struct wlc_info {
 				 */
 	bool pr80838_war;
 	uint hwrxoff;
+	struct device *dev;	/* Linux device object */
 };
 
 /* antsel module specific state */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index 273c508..b9d4813 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -482,7 +482,7 @@ extern const u8 wme_fifo2ac[];
 /* common functions for every port */
 extern void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit,
 			bool piomode, void *regsva, uint bustype, void *btparam,
-			uint *perr);
+			uint *perr, struct device *dev);
 extern uint wlc_detach(struct wlc_info *wlc);
 extern int wlc_up(struct wlc_info *wlc);
 extern uint wlc_down(struct wlc_info *wlc);
-- 
1.7.1


