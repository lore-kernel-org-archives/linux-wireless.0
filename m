Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3353 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071Ab1GVS5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 14:57:34 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 07/29] staging: brcm80211: remove
 wl_alloc_dma_resources() function
Date: Fri, 22 Jul 2011 20:56:54 +0200
Message-ID: <1311361036-3175-8-git-send-email-arend@broadcom.com> (sfid-20110722_205845_279447_BFAE80B6)
In-Reply-To: <1311361036-3175-1-git-send-email-arend@broadcom.com>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function wl_alloc_dma_resources() does not provide any value
for the brcmsmac driver as it only returns true. It has been
removed from the driver.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    8 --------
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    1 -
 drivers/staging/brcm80211/brcmsmac/main.c        |    6 ------
 3 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 6439fd9..a708306 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -1443,14 +1443,6 @@ void brcms_intrson(struct brcms_info *wl)
 	INT_UNLOCK(wl, flags);
 }
 
-/*
- * precondition: perimeter lock has been acquired
- */
-bool wl_alloc_dma_resources(struct brcms_info *wl, uint addrwidth)
-{
-	return true;
-}
-
 u32 brcms_intrsoff(struct brcms_info *wl)
 {
 	unsigned long flags;
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index 0d91366..01fce54 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -87,7 +87,6 @@ extern int brcms_up(struct brcms_info *wl);
 extern void brcms_down(struct brcms_info *wl);
 extern void brcms_txflowcontrol(struct brcms_info *wl, struct brcms_if *wlif,
 				bool state, int prio);
-extern bool wl_alloc_dma_resources(struct brcms_info *wl, uint dmaddrwidth);
 extern bool brcms_rfkill_set_hw_state(struct brcms_info *wl);
 
 /* timer functions */
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 0e6b9ca..847e1ab 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -870,12 +870,6 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		addrwidth =
 		    dma_addrwidth(wlc_hw->sih, DMAREG(wlc_hw, DMA_TX, 0));
 
-		if (!wl_alloc_dma_resources(wlc_hw->wlc->wl, addrwidth)) {
-			wiphy_err(wiphy, "wl%d: wlc_attach: alloc_dma_"
-				  "resources failed\n", unit);
-			return false;
-		}
-
 		/*
 		 * FIFO 0
 		 * TX: TX_AC_BK_FIFO (TX AC Background data packets)
-- 
1.7.4.1


