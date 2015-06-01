Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60303 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbbFASOj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 14:14:39 -0400
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kvalo@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	stable@vger.kernel.org, sw@simonwunderlich.de
Cc: Benjamin Berg <benjamin@sipsolutions.net>
Subject: [PATCH] ath9k: Prevent radard detection and spectral scan to be used concurrently
Date: Mon,  1 Jun 2015 20:12:37 +0200
Message-Id: <1433182357-17405-1-git-send-email-benjamin@sipsolutions.net> (sfid-20150601_201443_508445_FCCC065C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the case that a spectral scan is enabled the PHY errors sent by the
hardware as part of the scanning might trigger the radar detection and
channels might be marked as 'unusable' incorrectly. This patch fixes
the issue by preventing the spectral scan to be enabled if DFS is used
and only analysing the PHY errors for DFS if radar detection is enabled.

Reported-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>

[v3.19+]
---

The patch does apply to 3.19+ with a bit of fuzz.


 drivers/net/wireless/ath/ath9k/common-spectral.c | 4 ++++
 drivers/net/wireless/ath/ath9k/main.c            | 6 ++++++
 drivers/net/wireless/ath/ath9k/recv.c            | 7 +++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 5cee231..59b5ad8 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -312,6 +312,7 @@ static ssize_t write_file_spec_scan_ctl(struct file *file,
 					size_t count, loff_t *ppos)
 {
 	struct ath_spec_scan_priv *spec_priv = file->private_data;
+	struct ath_hw *ah = spec_priv->ah;
 	struct ath_common *common = ath9k_hw_common(spec_priv->ah);
 	char buf[32];
 	ssize_t len;
@@ -319,6 +320,9 @@ static ssize_t write_file_spec_scan_ctl(struct file *file,
 	if (config_enabled(CONFIG_ATH9K_TX99))
 		return -EOPNOTSUPP;
 
+	if (ah->hw->conf.radar_enabled)
+		return -EINVAL;
+
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b0badef..2d63062 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1433,6 +1433,12 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
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
index 6fb40ef..167628f 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -870,8 +870,11 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	 * can be dropped.
 	 */
 	if (rx_stats->rs_status & ATH9K_RXERR_PHY) {
-		ath9k_dfs_process_phyerr(sc, hdr, rx_stats, rx_status->mactime);
-		if (ath_cmn_process_fft(&sc->spec_priv, hdr, rx_stats, rx_status->mactime))
+		if (hw->conf.radar_enabled)
+			ath9k_dfs_process_phyerr(sc, hdr,
+						 rx_stats, rx_status->mactime);
+		else if (ath_cmn_process_fft(&sc->spec_priv, hdr
+					     rx_stats, rx_status->mactime))
 			RX_STAT_INC(rx_spectral);
 
 		return -EINVAL;
-- 
2.1.4

