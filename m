Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1195 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933050Ab1JDVTg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:36 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/26] staging: brcm80211: replace brcmu_bitcount with
 hweight8
Date: Tue, 4 Oct 2011 23:18:51 +0200
Message-ID: <1317763152-17607-6-git-send-email-arend@broadcom.com> (sfid-20111004_231950_797520_81848C70)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The kernel provides bit operations to replace brcmu_bitcount so
using those instead.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    7 +++----
 drivers/staging/brcm80211/brcmsmac/stf.c         |   10 +++++-----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 45e3b4b..0d3c9d8 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -15,6 +15,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/delay.h>
+#include <linux/bitops.h>
 
 #include <brcm_hw_ids.h>
 #include <chipcommon.h>
@@ -2879,8 +2880,7 @@ void wlc_phy_stf_chain_init(struct brcms_phy_pub *pih, u8 txchain, u8 rxchain)
 	pi->sh->hw_phyrxchain = rxchain;
 	pi->sh->phytxchain = txchain;
 	pi->sh->phyrxchain = rxchain;
-	pi->pubpi.phy_corenum = (u8) brcmu_bitcount((u8 *)&pi->sh->phyrxchain,
-						    sizeof(u8));
+	pi->pubpi.phy_corenum = (u8)hweight8(pi->sh->phyrxchain);
 }
 
 void wlc_phy_stf_chain_set(struct brcms_phy_pub *pih, u8 txchain, u8 rxchain)
@@ -2892,8 +2892,7 @@ void wlc_phy_stf_chain_set(struct brcms_phy_pub *pih, u8 txchain, u8 rxchain)
 	if (ISNPHY(pi))
 		wlc_phy_rxcore_setstate_nphy(pih, rxchain);
 
-	pi->pubpi.phy_corenum = (u8) brcmu_bitcount((u8 *)&pi->sh->phyrxchain,
-						    sizeof(u8));
+	pi->pubpi.phy_corenum = (u8)hweight8(pi->sh->phyrxchain);
 }
 
 void wlc_phy_stf_chain_get(struct brcms_phy_pub *pih, u8 *txchain, u8 *rxchain)
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index ba3c3ef..9460cd1 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -165,10 +165,10 @@ static int brcms_c_stf_txcore_set(struct brcms_c_info *wlc, u8 Nsts,
 	BCMMSG(wlc->wiphy, "wl%d: Nsts %d core_mask %x\n",
 		 wlc->pub->unit, Nsts, core_mask);
 
-	if (BRCMS_BITSCNT(core_mask) > wlc->stf->txstreams)
+	if (hweight8(core_mask) > wlc->stf->txstreams)
 		core_mask = 0;
 
-	if ((BRCMS_BITSCNT(core_mask) == wlc->stf->txstreams) &&
+	if ((hweight8(core_mask) == wlc->stf->txstreams) &&
 	    ((core_mask & ~wlc->stf->txchain)
 	     || !(core_mask & wlc->stf->txchain)))
 		core_mask = wlc->stf->txchain;
@@ -278,7 +278,7 @@ int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
 	 * if nrate override is configured to be non-SISO STF mode, reject
 	 * reducing txchain to 1
 	 */
-	txstreams = (u8) BRCMS_BITSCNT(txchain);
+	txstreams = (u8) hweight8(txchain);
 	if (txstreams > MAX_STREAMS_SUPPORTED)
 		return -EINVAL;
 
@@ -385,7 +385,7 @@ void brcms_c_stf_phy_chain_calc(struct brcms_c_info *wlc)
 	}
 
 	wlc->stf->txchain = wlc->stf->hw_txchain;
-	wlc->stf->txstreams = (u8) BRCMS_BITSCNT(wlc->stf->hw_txchain);
+	wlc->stf->txstreams = (u8) hweight8(wlc->stf->hw_txchain);
 
 	if (wlc->stf->hw_rxchain == 0 || wlc->stf->hw_rxchain == 0xf) {
 		if (BRCMS_ISNPHY(wlc->band))
@@ -395,7 +395,7 @@ void brcms_c_stf_phy_chain_calc(struct brcms_c_info *wlc)
 	}
 
 	wlc->stf->rxchain = wlc->stf->hw_rxchain;
-	wlc->stf->rxstreams = (u8) BRCMS_BITSCNT(wlc->stf->hw_rxchain);
+	wlc->stf->rxstreams = (u8) hweight8(wlc->stf->hw_rxchain);
 
 	/* initialize the txcore table */
 	memcpy(wlc->stf->txcore, txcore_default, sizeof(wlc->stf->txcore));
-- 
1.7.4.1


