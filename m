Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4760 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab1I0Rpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 13:45:47 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 14/26] staging: brcm80211: removed band related
 global vars from softmac
Date: Tue, 27 Sep 2011 10:45:18 -0700
Message-ID: <1317145530-18839-15-git-send-email-frankyl@broadcom.com> (sfid-20110927_194650_152735_CD9A6B31)
In-Reply-To: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
References: <1317145530-18839-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Global variables are undesirable unless they are read only. Variables are
now maintained in a device specific structure.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   29 +++++++++++++---------
 drivers/staging/brcm80211/brcmsmac/main.h        |    1 +
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 11ba061..d5d0d9e 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -31,6 +31,7 @@
 #include "pub.h"
 #include "ucode_loader.h"
 #include "mac80211_if.h"
+#include "main.h"
 
 #define N_TX_QUEUES	4 /* #tx queues on mac80211<->driver interface */
 
@@ -225,7 +226,7 @@ static struct ieee80211_rate legacy_ratetable[] = {
 	RATE(540, 0),
 };
 
-static struct ieee80211_supported_band brcms_band_2GHz_nphy = {
+static const struct ieee80211_supported_band brcms_band_2GHz_nphy_template = {
 	.band = IEEE80211_BAND_2GHZ,
 	.channels = brcms_2ghz_chantable,
 	.n_channels = ARRAY_SIZE(brcms_2ghz_chantable),
@@ -247,7 +248,7 @@ static struct ieee80211_supported_band brcms_band_2GHz_nphy = {
 		   }
 };
 
-static struct ieee80211_supported_band brcms_band_5GHz_nphy = {
+static const struct ieee80211_supported_band brcms_band_5GHz_nphy_template = {
 	.band = IEEE80211_BAND_5GHZ,
 	.channels = brcms_5ghz_nphy_chantable,
 	.n_channels = ARRAY_SIZE(brcms_5ghz_nphy_chantable),
@@ -981,22 +982,24 @@ static irqreturn_t brcms_isr(int irq, void *dev_id)
 static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 {
 	struct brcms_info *wl = hw->priv;
-	int has_5g;
+	struct brcms_c_info *wlc = wl->wlc;
+	struct ieee80211_supported_band *band;
+	int has_5g = 0;
 	u16 phy_type;
 
-	has_5g = 0;
-
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = NULL;
 	hw->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
 
 	phy_type = brcms_c_get_phy_type(wl->wlc, 0);
 	if (phy_type == PHY_TYPE_N || phy_type == PHY_TYPE_LCN) {
+		band = &wlc->bandstate[BAND_2G_INDEX]->band;
+		*band = brcms_band_2GHz_nphy_template;
 		if (phy_type == PHY_TYPE_LCN) {
 			/* Single stream */
-			brcms_band_2GHz_nphy.ht_cap.mcs.rx_mask[1] = 0;
-			brcms_band_2GHz_nphy.ht_cap.mcs.rx_highest = 72;
+			band->ht_cap.mcs.rx_mask[1] = 0;
+			band->ht_cap.mcs.rx_highest = 72;
 		}
-		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &brcms_band_2GHz_nphy;
+		hw->wiphy->bands[IEEE80211_BAND_2GHZ] = band;
 	} else {
 		return -EPERM;
 	}
@@ -1004,11 +1007,13 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 	/* Assume all bands use the same phy.  True for 11n devices. */
 	if (wl->pub->_nbands > 1) {
 		has_5g++;
-		if (phy_type == PHY_TYPE_N || phy_type == PHY_TYPE_LCN)
-			hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
-			    &brcms_band_5GHz_nphy;
-		else
+		if (phy_type == PHY_TYPE_N || phy_type == PHY_TYPE_LCN) {
+			band = &wlc->bandstate[BAND_5G_INDEX]->band;
+			*band = brcms_band_5GHz_nphy_template;
+			hw->wiphy->bands[IEEE80211_BAND_5GHZ] = band;
+		} else {
 			return -EPERM;
+		}
 	}
 	return 0;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 8760d7e..9e12a14 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -281,6 +281,7 @@ struct brcms_band {
 
 	u16 CWmin; /* minimum size of contention window, in unit of aSlotTime */
 	u16 CWmax; /* maximum size of contention window, in unit of aSlotTime */
+	struct ieee80211_supported_band band;
 };
 
 /* module control blocks */
-- 
1.7.1


