Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3339 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab1GVS5i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 26/29] staging: brcm80211: removed watchdog function
 from softmac
Date: Fri, 22 Jul 2011 20:57:13 +0200
Message-ID: <1311361036-3175-27-git-send-email-arend@broadcom.com> (sfid-20110722_205754_199477_9172DA31)
In-Reply-To: <1311361036-3175-1-git-send-email-arend@broadcom.com>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Watchdog function served no purpose since it had an empty body.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   14 +-------------
 drivers/staging/brcm80211/brcmsmac/main.c        |   11 ++---------
 drivers/staging/brcm80211/brcmsmac/main.h        |    2 --
 drivers/staging/brcm80211/brcmsmac/pub.h         |    5 ++---
 4 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 80c7025..b63dedf 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -60,8 +60,6 @@ static void _brcms_timer(struct brcms_timer *t);
 static int ieee_hw_init(struct ieee80211_hw *hw);
 static int ieee_hw_rate_init(struct ieee80211_hw *hw);
 
-static int wl_linux_watchdog(void *ctx);
-
 /* Flags we support */
 #define MAC_FILTERS (FIF_PROMISC_IN_BSS | \
 	FIF_ALLMULTI | \
@@ -827,7 +825,7 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 	wl->irq = irq;
 
 	/* register module */
-	brcms_c_module_register(wl->pub, "linux", wl, wl_linux_watchdog, NULL);
+	brcms_c_module_register(wl->pub, "linux", wl, NULL);
 
 	if (ieee_hw_init(hw)) {
 		wiphy_err(wl->wiphy, "wl%d: %s: ieee_hw_init failed!\n", unit,
@@ -1700,16 +1698,6 @@ void brcms_free_timer(struct brcms_info *wl, struct brcms_timer *t)
 
 }
 
-/*
- * runs in software irq context
- *
- * precondition: perimeter lock is not acquired
- */
-static int wl_linux_watchdog(void *ctx)
-{
-	return 0;
-}
-
 struct firmware_hdr {
 	u32 offset;
 	u32 len;
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index d011ed6..bdc7fb4 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -5374,12 +5374,6 @@ static void brcms_c_watchdog(void *arg)
 			cfg->tk_cm_bt--;
 	END_FOREACH_BSS()
 
-	/* Call any registered watchdog handlers */
-	for (i = 0; i < BRCMS_MAXMODULES; i++) {
-		if (wlc->modulecb[i].watchdog_fn)
-			wlc->modulecb[i].watchdog_fn(wlc->modulecb[i].hdl);
-	}
-
 	if (BRCMS_ISNPHY(wlc->band) && !wlc->pub->tempsense_disable &&
 	    ((wlc->pub->now - wlc->tempsense_lasttime) >=
 	     BRCMS_TEMPSENSE_PERIOD)) {
@@ -6325,8 +6319,8 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
  * register watchdog and down handlers.
  */
 int brcms_c_module_register(struct brcms_pub *pub,
-		const char *name, void *hdl,
-		int (*w_fn)(void *handle), int (*d_fn)(void *handle))
+			    const char *name, void *hdl,
+			    int (*d_fn)(void *handle))
 {
 	struct brcms_c_info *wlc = (struct brcms_c_info *) pub->wlc;
 	int i;
@@ -6337,7 +6331,6 @@ int brcms_c_module_register(struct brcms_pub *pub,
 			strncpy(wlc->modulecb[i].name, name,
 				sizeof(wlc->modulecb[i].name) - 1);
 			wlc->modulecb[i].hdl = hdl;
-			wlc->modulecb[i].watchdog_fn = w_fn;
 			wlc->modulecb[i].down_fn = d_fn;
 			return 0;
 		}
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 0fd061b..e2febe0 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -462,8 +462,6 @@ struct modulecb {
 	const struct brcmu_iovar *iovars;
 	/* handle passed when handler 'doiovar' is called */
 	void *hdl;
-	/* watchdog handler */
-	int (*watchdog_fn)(void *handle);
 
 	/* IOVar handler
 	 *
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index bfbb261..40efee6 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -614,9 +614,8 @@ extern void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc);
 extern void brcms_c_mctrl(struct brcms_c_info *wlc, u32 mask, u32 val);
 
 extern int brcms_c_module_register(struct brcms_pub *pub,
-			       const char *name, void *hdl,
-			       int (*watchdog_fn)(void *handle),
-			       int (*down_fn)(void *handle));
+				   const char *name, void *hdl,
+				   int (*down_fn)(void *handle));
 
 extern int brcms_c_module_unregister(struct brcms_pub *pub, const char *name,
 				 void *hdl);
-- 
1.7.4.1


