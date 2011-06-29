Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4623 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231Ab1F2Xtm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 030/119] staging: brcm80211: flatten
 wlc_phy_shared_detach()
Date: Wed, 29 Jun 2011 16:46:54 -0700
Message-ID: <1309391303-22741-31-git-send-email-frankyl@broadcom.com> (sfid-20110630_015304_274740_0FC96CA8)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

wlc_phy_shared_detach() is an unnecessary level of indirection to just
call kfree(), so replace the function with kfree().

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/bmac.c        |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    7 -------
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h |    1 -
 3 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index 90d1b32..f44f581 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -982,7 +982,7 @@ int brcms_b_detach(struct brcms_c_info *wlc)
 	}
 
 	/* Free shared phy state */
-	wlc_phy_shared_detach(wlc_hw->phy_sh);
+	kfree(wlc_hw->phy_sh);
 
 	wlc_phy_shim_detach(wlc_hw->physhim);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index a15c145..b527e5f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -506,13 +506,6 @@ shared_phy_t *wlc_phy_shared_attach(shared_phy_params_t *shp)
 	return sh;
 }
 
-void wlc_phy_shared_detach(shared_phy_t *phy_sh)
-{
-	if (phy_sh) {
-		kfree(phy_sh);
-	}
-}
-
 wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype,
 			  char *vars, struct wiphy *wiphy)
 {
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index 3c125c3..0ea337b 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -177,7 +177,6 @@ struct shared_phy_params {
 
 
 extern shared_phy_t *wlc_phy_shared_attach(shared_phy_params_t *shp);
-extern void wlc_phy_shared_detach(shared_phy_t *phy_sh);
 extern wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype,
 				 char *vars, struct wiphy *wiphy);
 extern void wlc_phy_detach(wlc_phy_t *ppi);
-- 
1.7.1


