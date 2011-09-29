Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2012 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217Ab1I2Wex (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 18:34:53 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3 18/25] staging: brcm80211: changing interface to
 n-phy rssi compute function
Date: Thu, 29 Sep 2011 15:34:29 -0700
Message-ID: <1317335676-3424-19-git-send-email-frankyl@broadcom.com> (sfid-20110930_003508_871670_7CF54E23)
In-Reply-To: <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
 <1317335676-3424-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function wlc_phy_rssi_compute_nphy() was called with pointer to
brcms_d11rxhdr structure in which it filled in the received power
per antenna. However, these are not used further in the driver so
it only needs the d11rxhdr structure as input for rssi calculation.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |    7 +------
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index a26c682..8025247 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -2646,7 +2646,7 @@ void wlc_phy_rssi_compute(struct brcms_phy_pub *pih,
 			rssi -= 256;
 	} else if (radioid == BCM2055_ID || radioid == BCM2056_ID
 		   || radioid == BCM2057_ID) {
-		rssi = wlc_phy_rssi_compute_nphy(pi, wlc_rxhdr);
+		rssi = wlc_phy_rssi_compute_nphy(pi, rxh);
 	}
 
 end:
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index b94117b..8ce0159 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -1183,7 +1183,7 @@ extern void wlc_phy_est_tonepwr_nphy(struct brcms_phy *pi, s32 *qdBm_pwrbuf,
 extern void wlc_phy_radio205x_vcocal_nphy(struct brcms_phy *pi);
 
 extern int wlc_phy_rssi_compute_nphy(struct brcms_phy *pi,
-				     struct brcms_d11rxhdr *wlc_rxh);
+				     struct d11rxhdr *rxh);
 
 #define NPHY_TESTPATTERN_BPHY_EVM   0
 #define NPHY_TESTPATTERN_BPHY_RFCS  1
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 58645d2..ff8b1d8 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -23109,9 +23109,8 @@ void wlc_phy_rssi_cal_nphy(struct brcms_phy *pi)
 }
 
 int
-wlc_phy_rssi_compute_nphy(struct brcms_phy *pi, struct brcms_d11rxhdr *wlc_rxh)
+wlc_phy_rssi_compute_nphy(struct brcms_phy *pi, struct d11rxhdr *rxh)
 {
-	struct d11rxhdr *rxh = &wlc_rxh->rxhdr;
 	s16 rxpwr, rxpwr0, rxpwr1;
 	s16 phyRx0_l, phyRx2_l;
 
@@ -23134,10 +23133,6 @@ wlc_phy_rssi_compute_nphy(struct brcms_phy *pi, struct brcms_d11rxhdr *wlc_rxh)
 		rxpwr1 = phyRx2_l;
 	}
 
-	wlc_rxh->rxpwr[0] = (s8) rxpwr0;
-	wlc_rxh->rxpwr[1] = (s8) rxpwr1;
-	wlc_rxh->do_rssi_ma = 0;
-
 	if (pi->sh->rssi_mode == RSSI_ANT_MERGE_MAX)
 		rxpwr = (rxpwr0 > rxpwr1) ? rxpwr0 : rxpwr1;
 	else if (pi->sh->rssi_mode == RSSI_ANT_MERGE_MIN)
-- 
1.7.1


