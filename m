Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:63564 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbaKFHz0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:55:26 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 09/21] ath9k: use ath_ps_ops in ath9k_spectral_scan_
Date: Thu,  6 Nov 2014 08:53:26 +0100
Message-Id: <1415260418-14321-10-git-send-email-linux@rempel-privat.de> (sfid-20141106_085536_929966_B90683F7)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 83a1d13..747dd5a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1354,7 +1354,7 @@ void ath9k_spectral_scan_trigger(struct ieee80211_hw *hw)
 		return;
 	}
 
-	ath9k_ps_wakeup(sc);
+	ath_ps_ops(common)->wakeup(common);
 	rxfilter = ath9k_hw_getrxfilter(ah);
 	ath9k_hw_setrxfilter(ah, rxfilter |
 				 ATH9K_RX_FILTER_PHYRADAR |
@@ -1367,7 +1367,7 @@ void ath9k_spectral_scan_trigger(struct ieee80211_hw *hw)
 	 */
 	ath9k_spectral_scan_config(hw, sc->spec_priv.spectral_mode);
 	ath9k_hw_ops(ah)->spectral_scan_trigger(ah);
-	ath9k_ps_restore(sc);
+	ath_ps_ops(common)->restore(common);
 }
 
 int ath9k_spectral_scan_config(struct ieee80211_hw *hw,
@@ -1402,9 +1402,9 @@ int ath9k_spectral_scan_config(struct ieee80211_hw *hw,
 		return -1;
 	}
 
-	ath9k_ps_wakeup(sc);
+	ath_ps_ops(common)->wakeup(common);
 	ath9k_hw_ops(ah)->spectral_scan_config(ah, &sc->spec_priv.spec_config);
-	ath9k_ps_restore(sc);
+	ath_ps_ops(common)->restore(common);
 
 	sc->spec_priv.spectral_mode = spectral_mode;
 
-- 
1.9.1

