Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59751 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaKFHzE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:55:04 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 05/21] ath9k: add ath_hw to ath_spec_scan_priv
Date: Thu,  6 Nov 2014 08:53:22 +0100
Message-Id: <1415260418-14321-6-git-send-email-linux@rempel-privat.de> (sfid-20141106_085510_214327_1B063B2E)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

spectral code mostly depends on ath_hw, not on ath_softc

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/init.c     | 1 +
 drivers/net/wireless/ath/ath9k/spectral.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 34687f4..fe811b3 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -348,6 +348,7 @@ static void ath9k_init_misc(struct ath_softc *sc)
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)
 		sc->ant_comb.count = ATH_ANT_DIV_COMB_INIT_COUNT;
 
+	sc->spec_priv.ah = sc->sc_ah;
 	sc->spec_priv.spec_config.enabled = 0;
 	sc->spec_priv.spec_config.short_repeat = true;
 	sc->spec_priv.spec_config.count = 8;
diff --git a/drivers/net/wireless/ath/ath9k/spectral.h b/drivers/net/wireless/ath/ath9k/spectral.h
index 2269589..638320d 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.h
+++ b/drivers/net/wireless/ath/ath9k/spectral.h
@@ -93,6 +93,7 @@ struct ath_ht20_40_fft_packet {
 } __packed;
 
 struct ath_spec_scan_priv {
+	struct ath_hw *ah;
 	/* relay(fs) channel for spectral scan */
 	struct rchan *rfs_chan_spec_scan;
 	enum spectral_mode spectral_mode;
-- 
1.9.1

