Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50446 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbaKFHzE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:55:04 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 03/21] ath9k: move spec_config to ath_spec_scan_priv
Date: Thu,  6 Nov 2014 08:53:20 +0100
Message-Id: <1415260418-14321-4-git-send-email-linux@rempel-privat.de> (sfid-20141106_085515_060790_89B12AD6)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ath9k.h    |  3 +--
 drivers/net/wireless/ath/ath9k/init.c     | 12 ++++++------
 drivers/net/wireless/ath/ath9k/main.c     | 12 ++++++------
 drivers/net/wireless/ath/ath9k/spectral.c | 16 ++++++++--------
 drivers/net/wireless/ath/ath9k/spectral.h |  2 ++
 5 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b80e789..a0fa3e6 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1028,8 +1028,7 @@ struct ath_softc {
 	struct dfs_pattern_detector *dfs_detector;
 	u64 dfs_prev_pulse_ts;
 	u32 wow_enabled;
-	/* relay(fs) channel for spectral scan */
-	struct ath_spec_scan spec_config;
+
 	struct ath_spec_scan_priv spec_priv;
 
 	struct ieee80211_vif *tx99_vif;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index a4d69a0..34687f4 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -348,12 +348,12 @@ static void ath9k_init_misc(struct ath_softc *sc)
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)
 		sc->ant_comb.count = ATH_ANT_DIV_COMB_INIT_COUNT;
 
-	sc->spec_config.enabled = 0;
-	sc->spec_config.short_repeat = true;
-	sc->spec_config.count = 8;
-	sc->spec_config.endless = false;
-	sc->spec_config.period = 0xFF;
-	sc->spec_config.fft_period = 0xF;
+	sc->spec_priv.spec_config.enabled = 0;
+	sc->spec_priv.spec_config.short_repeat = true;
+	sc->spec_priv.spec_config.count = 8;
+	sc->spec_priv.spec_config.endless = false;
+	sc->spec_priv.spec_config.period = 0xFF;
+	sc->spec_priv.spec_config.fft_period = 0xF;
 }
 
 static void ath9k_init_pcoem_platform(struct ath_softc *sc)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cf7a215..83a1d13 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1384,26 +1384,26 @@ int ath9k_spectral_scan_config(struct ieee80211_hw *hw,
 
 	switch (spectral_mode) {
 	case SPECTRAL_DISABLED:
-		sc->spec_config.enabled = 0;
+		sc->spec_priv.spec_config.enabled = 0;
 		break;
 	case SPECTRAL_BACKGROUND:
 		/* send endless samples.
 		 * TODO: is this really useful for "background"?
 		 */
-		sc->spec_config.endless = 1;
-		sc->spec_config.enabled = 1;
+		sc->spec_priv.spec_config.endless = 1;
+		sc->spec_priv.spec_config.enabled = 1;
 		break;
 	case SPECTRAL_CHANSCAN:
 	case SPECTRAL_MANUAL:
-		sc->spec_config.endless = 0;
-		sc->spec_config.enabled = 1;
+		sc->spec_priv.spec_config.endless = 0;
+		sc->spec_priv.spec_config.enabled = 1;
 		break;
 	default:
 		return -1;
 	}
 
 	ath9k_ps_wakeup(sc);
-	ath9k_hw_ops(ah)->spectral_scan_config(ah, &sc->spec_config);
+	ath9k_hw_ops(ah)->spectral_scan_config(ah, &sc->spec_priv.spec_config);
 	ath9k_ps_restore(sc);
 
 	sc->spec_priv.spectral_mode = spectral_mode;
diff --git a/drivers/net/wireless/ath/ath9k/spectral.c b/drivers/net/wireless/ath/ath9k/spectral.c
index 3a394e1..555fc2a 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.c
+++ b/drivers/net/wireless/ath/ath9k/spectral.c
@@ -292,7 +292,7 @@ static ssize_t read_file_spectral_short_repeat(struct file *file,
 	char buf[32];
 	unsigned int len;
 
-	len = sprintf(buf, "%d\n", sc->spec_config.short_repeat);
+	len = sprintf(buf, "%d\n", sc->spec_priv.spec_config.short_repeat);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -316,7 +316,7 @@ static ssize_t write_file_spectral_short_repeat(struct file *file,
 	if (val > 1)
 		return -EINVAL;
 
-	sc->spec_config.short_repeat = val;
+	sc->spec_priv.spec_config.short_repeat = val;
 	return count;
 }
 
@@ -340,7 +340,7 @@ static ssize_t read_file_spectral_count(struct file *file,
 	char buf[32];
 	unsigned int len;
 
-	len = sprintf(buf, "%d\n", sc->spec_config.count);
+	len = sprintf(buf, "%d\n", sc->spec_priv.spec_config.count);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -364,7 +364,7 @@ static ssize_t write_file_spectral_count(struct file *file,
 	if (val > 255)
 		return -EINVAL;
 
-	sc->spec_config.count = val;
+	sc->spec_priv.spec_config.count = val;
 	return count;
 }
 
@@ -388,7 +388,7 @@ static ssize_t read_file_spectral_period(struct file *file,
 	char buf[32];
 	unsigned int len;
 
-	len = sprintf(buf, "%d\n", sc->spec_config.period);
+	len = sprintf(buf, "%d\n", sc->spec_priv.spec_config.period);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -412,7 +412,7 @@ static ssize_t write_file_spectral_period(struct file *file,
 	if (val > 255)
 		return -EINVAL;
 
-	sc->spec_config.period = val;
+	sc->spec_priv.spec_config.period = val;
 	return count;
 }
 
@@ -436,7 +436,7 @@ static ssize_t read_file_spectral_fft_period(struct file *file,
 	char buf[32];
 	unsigned int len;
 
-	len = sprintf(buf, "%d\n", sc->spec_config.fft_period);
+	len = sprintf(buf, "%d\n", sc->spec_priv.spec_config.fft_period);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -460,7 +460,7 @@ static ssize_t write_file_spectral_fft_period(struct file *file,
 	if (val > 15)
 		return -EINVAL;
 
-	sc->spec_config.fft_period = val;
+	sc->spec_priv.spec_config.fft_period = val;
 	return count;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/spectral.h b/drivers/net/wireless/ath/ath9k/spectral.h
index 0acdc43..dfe6f68 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.h
+++ b/drivers/net/wireless/ath/ath9k/spectral.h
@@ -93,8 +93,10 @@ struct ath_ht20_40_fft_packet {
 } __packed;
 
 struct ath_spec_scan_priv {
+	/* relay(fs) channel for spectral scan */
 	struct rchan *rfs_chan_spec_scan;
 	enum spectral_mode spectral_mode;
+	struct ath_spec_scan spec_config;
 };
 
 #define SPECTRAL_HT20_40_TOTAL_DATA_LEN	(sizeof(struct ath_ht20_40_fft_packet))
-- 
1.9.1

