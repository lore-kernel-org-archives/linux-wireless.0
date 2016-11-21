Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35204 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752849AbcKUOEk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 09:04:40 -0500
From: Benjamin Berg <benjamin@sipsolutions.net>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
        Benjamin Berg <benjamin@sipsolutions.net>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH] ath9k: Prevent radar detection and spectral scan to be used concurrently
Date: Mon, 21 Nov 2016 15:04:23 +0100
Message-Id: <20161121140423.24367-1-benjamin@sipsolutions.net> (sfid-20161121_150443_650466_71DF0736)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the case that a spectral scan is enabled the PHY errors sent by the
hardware as part of the scanning might trigger the radar detection and
channels might be marked as 'unusable' incorrectly. This patch fixes
the issue by preventing the spectral scan to be enabled if DFS is used
and only analysing the PHY errors for DFS if radar detection is enabled.

Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 drivers/net/wireless/ath/ath9k/common-spectral.c | 23 +++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/main.c            |  6 ++++++
 drivers/net/wireless/ath/ath9k/recv.c            |  7 +++++--
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index e2512d5..8444d6d 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -802,16 +802,27 @@ static ssize_t write_file_spec_scan_ctl(struct file *file,
 					size_t count, loff_t *ppos)
 {
 	struct ath_spec_scan_priv *spec_priv = file->private_data;
+	struct ath_hw *ah = spec_priv->ah;
+	struct ath_softc *sc = ah->hw->priv;
 	struct ath_common *common = ath9k_hw_common(spec_priv->ah);
 	char buf[32];
 	ssize_t len;
+	ssize_t result = count;
 
 	if (IS_ENABLED(CONFIG_ATH9K_TX99))
 		return -EOPNOTSUPP;
 
+	mutex_lock(&sc->mutex);
+	if (ah->hw->conf.radar_enabled) {
+		result = -EINVAL;
+		goto unlock;
+	}
+
 	len = min(count, sizeof(buf) - 1);
-	if (copy_from_user(buf, user_buf, len))
-		return -EFAULT;
+	if (copy_from_user(buf, user_buf, len)) {
+		result = -EFAULT;
+		goto unlock;
+	}
 
 	buf[len] = '\0';
 
@@ -830,10 +841,14 @@ static ssize_t write_file_spec_scan_ctl(struct file *file,
 		ath9k_cmn_spectral_scan_config(common, spec_priv, SPECTRAL_DISABLED);
 		ath_dbg(common, CONFIG, "spectral scan: disabled\n");
 	} else {
-		return -EINVAL;
+		result = -EINVAL;
+		goto unlock;
 	}
 
-	return count;
+unlock:
+	mutex_unlock(&sc->mutex);
+
+	return result;
 }
 
 static const struct file_operations fops_spec_scan_ctl = {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e9f32b5..62b86fb 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1459,6 +1459,12 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	if (!ath9k_is_chanctx_enabled() && (changed & IEEE80211_CONF_CHANGE_CHANNEL)) {
 		ctx->offchannel = !!(conf->flags & IEEE80211_CONF_OFFCHANNEL);
 		ath_chanctx_set_channel(sc, ctx, &hw->conf.chandef);
+
+		/* We need to ensure that spectral scan is disabled. */
+		if (conf->radar_enabled &&
+		    sc->spec_priv.spectral_mode != SPECTRAL_DISABLED)
+			ath9k_cmn_spectral_scan_config(common, &sc->spec_priv,
+						       SPECTRAL_DISABLED);
 	}
 
 	mutex_unlock(&sc->mutex);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6697342..ce34add 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -867,8 +867,11 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	 * can be dropped.
 	 */
 	if (rx_stats->rs_status & ATH9K_RXERR_PHY) {
-		ath9k_dfs_process_phyerr(sc, hdr, rx_stats, rx_status->mactime);
-		if (ath_cmn_process_fft(&sc->spec_priv, hdr, rx_stats, rx_status->mactime))
+		if (hw->conf.radar_enabled)
+			ath9k_dfs_process_phyerr(sc, hdr, rx_stats,
+						 rx_status->mactime);
+		else if (ath_cmn_process_fft(&sc->spec_priv, hdr, rx_stats,
+					     rx_status->mactime))
 			RX_STAT_INC(rx_spectral);
 
 		return -EINVAL;
-- 
2.10.2
