Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:59498 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbaKFHzU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:55:20 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 01/21] ath9k: add struct ath_spec_scan_priv
Date: Thu,  6 Nov 2014 08:53:18 +0100
Message-Id: <1415260418-14321-2-git-send-email-linux@rempel-privat.de> (sfid-20141106_085530_001813_209BB6AE)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

and move rfs_chan_spec_scan to this struct. We will need it
for common spectral scan code.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/ath9k.h    |  2 +-
 drivers/net/wireless/ath/ath9k/spectral.c | 12 ++++++------
 drivers/net/wireless/ath/ath9k/spectral.h |  3 +++
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 85d74ff..65feda3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1029,9 +1029,9 @@ struct ath_softc {
 	u64 dfs_prev_pulse_ts;
 	u32 wow_enabled;
 	/* relay(fs) channel for spectral scan */
-	struct rchan *rfs_chan_spec_scan;
 	enum spectral_mode spectral_mode;
 	struct ath_spec_scan spec_config;
+	struct ath_spec_scan_priv spec_priv;
 
 	struct ieee80211_vif *tx99_vif;
 	struct sk_buff *tx99_skb;
diff --git a/drivers/net/wireless/ath/ath9k/spectral.c b/drivers/net/wireless/ath/ath9k/spectral.c
index 8f68426..348dddd 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.c
+++ b/drivers/net/wireless/ath/ath9k/spectral.c
@@ -28,12 +28,12 @@ static void ath_debug_send_fft_sample(struct ath_softc *sc,
 				      struct fft_sample_tlv *fft_sample_tlv)
 {
 	int length;
-	if (!sc->rfs_chan_spec_scan)
+	if (!sc->spec_priv.rfs_chan_spec_scan)
 		return;
 
 	length = __be16_to_cpu(fft_sample_tlv->length) +
 		 sizeof(*fft_sample_tlv);
-	relay_write(sc->rfs_chan_spec_scan, fft_sample_tlv, length);
+	relay_write(sc->spec_priv.rfs_chan_spec_scan, fft_sample_tlv, length);
 }
 
 /* returns 1 if this was a spectral frame, even if not handled. */
@@ -508,15 +508,15 @@ static struct rchan_callbacks rfs_spec_scan_cb = {
 
 void ath9k_spectral_deinit_debug(struct ath_softc *sc)
 {
-	if (config_enabled(CONFIG_ATH9K_DEBUGFS) && sc->rfs_chan_spec_scan) {
-		relay_close(sc->rfs_chan_spec_scan);
-		sc->rfs_chan_spec_scan = NULL;
+	if (config_enabled(CONFIG_ATH9K_DEBUGFS) && sc->spec_priv.rfs_chan_spec_scan) {
+		relay_close(sc->spec_priv.rfs_chan_spec_scan);
+		sc->spec_priv.rfs_chan_spec_scan = NULL;
 	}
 }
 
 void ath9k_spectral_init_debug(struct ath_softc *sc)
 {
-	sc->rfs_chan_spec_scan = relay_open("spectral_scan",
+	sc->spec_priv.rfs_chan_spec_scan = relay_open("spectral_scan",
 					    sc->debug.debugfs_phy,
 					    1024, 256, &rfs_spec_scan_cb,
 					    NULL);
diff --git a/drivers/net/wireless/ath/ath9k/spectral.h b/drivers/net/wireless/ath/ath9k/spectral.h
index 7b410c6..533d8a1 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.h
+++ b/drivers/net/wireless/ath/ath9k/spectral.h
@@ -92,6 +92,9 @@ struct ath_ht20_40_fft_packet {
 	struct ath_radar_info radar_info;
 } __packed;
 
+struct ath_spec_scan_priv {
+	struct rchan *rfs_chan_spec_scan;
+};
 
 #define SPECTRAL_HT20_40_TOTAL_DATA_LEN	(sizeof(struct ath_ht20_40_fft_packet))
 
-- 
1.9.1

