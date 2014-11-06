Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:49706 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaKFHyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:54:15 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 04/21] ath9k: use struct dentry by ath9k_spectral_init_debug
Date: Thu,  6 Nov 2014 08:53:21 +0100
Message-Id: <1415260418-14321-5-git-send-email-linux@rempel-privat.de> (sfid-20141106_085421_879726_49203568)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

this will alow us to make ath_softc independent code.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/debug.c    |  2 +-
 drivers/net/wireless/ath/ath9k/spectral.c | 14 +++++++-------
 drivers/net/wireless/ath/ath9k/spectral.h |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 2a2a17d..f0a802e 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1330,7 +1330,7 @@ int ath9k_init_debug(struct ath_hw *ah)
 
 	ath9k_dfs_init_debug(sc);
 	ath9k_tx99_init_debug(sc);
-	ath9k_spectral_init_debug(sc);
+	ath9k_spectral_init_debug(sc, sc->debug.debugfs_phy);
 
 	debugfs_create_file("dma", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_dma);
diff --git a/drivers/net/wireless/ath/ath9k/spectral.c b/drivers/net/wireless/ath/ath9k/spectral.c
index 555fc2a..d272380 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.c
+++ b/drivers/net/wireless/ath/ath9k/spectral.c
@@ -514,30 +514,30 @@ void ath9k_spectral_deinit_debug(struct ath_softc *sc)
 	}
 }
 
-void ath9k_spectral_init_debug(struct ath_softc *sc)
+void ath9k_spectral_init_debug(struct ath_softc *sc, struct dentry *debugfs_phy)
 {
 	sc->spec_priv.rfs_chan_spec_scan = relay_open("spectral_scan",
-					    sc->debug.debugfs_phy,
+					    debugfs_phy,
 					    1024, 256, &rfs_spec_scan_cb,
 					    NULL);
 	debugfs_create_file("spectral_scan_ctl",
 			    S_IRUSR | S_IWUSR,
-			    sc->debug.debugfs_phy, sc,
+			    debugfs_phy, sc,
 			    &fops_spec_scan_ctl);
 	debugfs_create_file("spectral_short_repeat",
 			    S_IRUSR | S_IWUSR,
-			    sc->debug.debugfs_phy, sc,
+			    debugfs_phy, sc,
 			    &fops_spectral_short_repeat);
 	debugfs_create_file("spectral_count",
 			    S_IRUSR | S_IWUSR,
-			    sc->debug.debugfs_phy, sc,
+			    debugfs_phy, sc,
 			    &fops_spectral_count);
 	debugfs_create_file("spectral_period",
 			    S_IRUSR | S_IWUSR,
-			    sc->debug.debugfs_phy, sc,
+			    debugfs_phy, sc,
 			    &fops_spectral_period);
 	debugfs_create_file("spectral_fft_period",
 			    S_IRUSR | S_IWUSR,
-			    sc->debug.debugfs_phy, sc,
+			    debugfs_phy, sc,
 			    &fops_spectral_fft_period);
 }
diff --git a/drivers/net/wireless/ath/ath9k/spectral.h b/drivers/net/wireless/ath/ath9k/spectral.h
index dfe6f68..2269589 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.h
+++ b/drivers/net/wireless/ath/ath9k/spectral.h
@@ -129,7 +129,7 @@ static inline u8 spectral_bitmap_weight(u8 *bins)
 	return bins[0] & 0x3f;
 }
 
-void ath9k_spectral_init_debug(struct ath_softc *sc);
+void ath9k_spectral_init_debug(struct ath_softc *sc, struct dentry *debugfs_phy);
 void ath9k_spectral_deinit_debug(struct ath_softc *sc);
 
 void ath9k_spectral_scan_trigger(struct ieee80211_hw *hw);
-- 
1.9.1

