Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59316 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbaKFHyp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:54:45 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 02/21] ath9k: move spectral_mode to ath_spec_scan_priv
Date: Thu,  6 Nov 2014 08:53:19 +0100
Message-Id: <1415260418-14321-3-git-send-email-linux@rempel-privat.de> (sfid-20141106_085449_124651_7EF1B457)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ath9k.h    | 1 -
 drivers/net/wireless/ath/ath9k/channel.c  | 2 +-
 drivers/net/wireless/ath/ath9k/main.c     | 4 ++--
 drivers/net/wireless/ath/ath9k/spectral.c | 2 +-
 drivers/net/wireless/ath/ath9k/spectral.h | 1 +
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 65feda3..b80e789 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1029,7 +1029,6 @@ struct ath_softc {
 	u64 dfs_prev_pulse_ts;
 	u32 wow_enabled;
 	/* relay(fs) channel for spectral scan */
-	enum spectral_mode spectral_mode;
 	struct ath_spec_scan spec_config;
 	struct ath_spec_scan_priv spec_priv;
 
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index c7234d5..25a21fa 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -92,7 +92,7 @@ static int ath_set_channel(struct ath_softc *sc)
 	} else {
 		/* perform spectral scan if requested. */
 		if (test_bit(ATH_OP_SCANNING, &common->op_flags) &&
-			sc->spectral_mode == SPECTRAL_CHANSCAN)
+			sc->spec_priv.spectral_mode == SPECTRAL_CHANSCAN)
 			ath9k_spectral_scan_trigger(hw);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a91ee92..cf7a215 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1365,7 +1365,7 @@ void ath9k_spectral_scan_trigger(struct ieee80211_hw *hw)
 	 * configuration, otherwise the register will have its values reset
 	 * (on my ar9220 to value 0x01002310)
 	 */
-	ath9k_spectral_scan_config(hw, sc->spectral_mode);
+	ath9k_spectral_scan_config(hw, sc->spec_priv.spectral_mode);
 	ath9k_hw_ops(ah)->spectral_scan_trigger(ah);
 	ath9k_ps_restore(sc);
 }
@@ -1406,7 +1406,7 @@ int ath9k_spectral_scan_config(struct ieee80211_hw *hw,
 	ath9k_hw_ops(ah)->spectral_scan_config(ah, &sc->spec_config);
 	ath9k_ps_restore(sc);
 
-	sc->spectral_mode = spectral_mode;
+	sc->spec_priv.spectral_mode = spectral_mode;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/spectral.c b/drivers/net/wireless/ath/ath9k/spectral.c
index 348dddd..3a394e1 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.c
+++ b/drivers/net/wireless/ath/ath9k/spectral.c
@@ -215,7 +215,7 @@ static ssize_t read_file_spec_scan_ctl(struct file *file, char __user *user_buf,
 	char *mode = "";
 	unsigned int len;
 
-	switch (sc->spectral_mode) {
+	switch (sc->spec_priv.spectral_mode) {
 	case SPECTRAL_DISABLED:
 		mode = "disable";
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/spectral.h b/drivers/net/wireless/ath/ath9k/spectral.h
index 533d8a1..0acdc43 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.h
+++ b/drivers/net/wireless/ath/ath9k/spectral.h
@@ -94,6 +94,7 @@ struct ath_ht20_40_fft_packet {
 
 struct ath_spec_scan_priv {
 	struct rchan *rfs_chan_spec_scan;
+	enum spectral_mode spectral_mode;
 };
 
 #define SPECTRAL_HT20_40_TOTAL_DATA_LEN	(sizeof(struct ath_ht20_40_fft_packet))
-- 
1.9.1

