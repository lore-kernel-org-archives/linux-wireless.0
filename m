Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49985 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbaKFHzB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 02:55:01 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com, sujith@msujith.org, nbd@openwrt.org,
	patro@cs.wisc.edu, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 06/21] ath9k: remove all struct ath_softc dependencies from spectral code
Date: Thu,  6 Nov 2014 08:53:23 +0100
Message-Id: <1415260418-14321-7-git-send-email-linux@rempel-privat.de> (sfid-20141106_085509_558328_163EFB1E)
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/debug.c    |  4 +-
 drivers/net/wireless/ath/ath9k/recv.c     |  2 +-
 drivers/net/wireless/ath/ath9k/spectral.c | 87 ++++++++++++++++---------------
 drivers/net/wireless/ath/ath9k/spectral.h |  8 +--
 4 files changed, 51 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index f0a802e..6492619 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1310,7 +1310,7 @@ void ath9k_get_et_stats(struct ieee80211_hw *hw,
 
 void ath9k_deinit_debug(struct ath_softc *sc)
 {
-	ath9k_spectral_deinit_debug(sc);
+	ath9k_spectral_deinit_debug(&sc->spec_priv);
 }
 
 int ath9k_init_debug(struct ath_hw *ah)
@@ -1330,7 +1330,7 @@ int ath9k_init_debug(struct ath_hw *ah)
 
 	ath9k_dfs_init_debug(sc);
 	ath9k_tx99_init_debug(sc);
-	ath9k_spectral_init_debug(sc, sc->debug.debugfs_phy);
+	ath9k_spectral_init_debug(&sc->spec_priv, sc->debug.debugfs_phy);
 
 	debugfs_create_file("dma", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_dma);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6914e21..e97c693 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -870,7 +870,7 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	 */
 	if (rx_stats->rs_status & ATH9K_RXERR_PHY) {
 		ath9k_dfs_process_phyerr(sc, hdr, rx_stats, rx_status->mactime);
-		if (ath_process_fft(sc, hdr, rx_stats, rx_status->mactime))
+		if (ath_process_fft(&sc->spec_priv, hdr, rx_stats, rx_status->mactime))
 			RX_STAT_INC(rx_spectral);
 
 		return -EINVAL;
diff --git a/drivers/net/wireless/ath/ath9k/spectral.c b/drivers/net/wireless/ath/ath9k/spectral.c
index d272380..50af6bc 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.c
+++ b/drivers/net/wireless/ath/ath9k/spectral.c
@@ -24,23 +24,24 @@ static s8 fix_rssi_inv_only(u8 rssi_val)
 	return (s8) rssi_val;
 }
 
-static void ath_debug_send_fft_sample(struct ath_softc *sc,
+static void ath_debug_send_fft_sample(struct ath_spec_scan_priv *spec_priv,
 				      struct fft_sample_tlv *fft_sample_tlv)
 {
 	int length;
-	if (!sc->spec_priv.rfs_chan_spec_scan)
+	if (!spec_priv->rfs_chan_spec_scan)
 		return;
 
 	length = __be16_to_cpu(fft_sample_tlv->length) +
 		 sizeof(*fft_sample_tlv);
-	relay_write(sc->spec_priv.rfs_chan_spec_scan, fft_sample_tlv, length);
+	relay_write(spec_priv->rfs_chan_spec_scan, fft_sample_tlv, length);
 }
 
 /* returns 1 if this was a spectral frame, even if not handled. */
-int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
+int ath_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_hdr *hdr,
 		    struct ath_rx_status *rs, u64 tsf)
 {
-	struct ath_hw *ah = sc->sc_ah;
+	struct ath_hw *ah = spec_priv->ah;
+	struct ath_common *common = ath9k_hw_common(spec_priv->ah);
 	u8 num_bins, *bins, *vdata = (u8 *)hdr;
 	struct fft_sample_ht20 fft_sample_20;
 	struct fft_sample_ht20_40 fft_sample_40;
@@ -67,7 +68,7 @@ int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 	if (!(radar_info->pulse_bw_info & SPECTRAL_SCAN_BITMASK))
 		return 0;
 
-	chan_type = cfg80211_get_chandef_type(&sc->hw->conf.chandef);
+	chan_type = cfg80211_get_chandef_type(&common->hw->conf.chandef);
 	if ((chan_type == NL80211_CHAN_HT40MINUS) ||
 	    (chan_type == NL80211_CHAN_HT40PLUS)) {
 		fft_len = SPECTRAL_HT20_40_TOTAL_DATA_LEN;
@@ -199,7 +200,7 @@ int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 		tlv = (struct fft_sample_tlv *)&fft_sample_20;
 	}
 
-	ath_debug_send_fft_sample(sc, tlv);
+	ath_debug_send_fft_sample(spec_priv, tlv);
 
 	return 1;
 }
@@ -211,11 +212,11 @@ int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
 static ssize_t read_file_spec_scan_ctl(struct file *file, char __user *user_buf,
 				       size_t count, loff_t *ppos)
 {
-	struct ath_softc *sc = file->private_data;
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
 	char *mode = "";
 	unsigned int len;
 
-	switch (sc->spec_priv.spectral_mode) {
+	switch (spec_priv->spectral_mode) {
 	case SPECTRAL_DISABLED:
 		mode = "disable";
 		break;
@@ -237,8 +238,8 @@ static ssize_t write_file_spec_scan_ctl(struct file *file,
 					const char __user *user_buf,
 					size_t count, loff_t *ppos)
 {
-	struct ath_softc *sc = file->private_data;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
+	struct ath_common *common = ath9k_hw_common(spec_priv->ah);
 	char buf[32];
 	ssize_t len;
 
@@ -252,18 +253,18 @@ static ssize_t write_file_spec_scan_ctl(struct file *file,
 	buf[len] = '\0';
 
 	if (strncmp("trigger", buf, 7) == 0) {
-		ath9k_spectral_scan_trigger(sc->hw);
+		ath9k_spectral_scan_trigger(common->hw);
 	} else if (strncmp("background", buf, 10) == 0) {
-		ath9k_spectral_scan_config(sc->hw, SPECTRAL_BACKGROUND);
+		ath9k_spectral_scan_config(common->hw, SPECTRAL_BACKGROUND);
 		ath_dbg(common, CONFIG, "spectral scan: background mode enabled\n");
 	} else if (strncmp("chanscan", buf, 8) == 0) {
-		ath9k_spectral_scan_config(sc->hw, SPECTRAL_CHANSCAN);
+		ath9k_spectral_scan_config(common->hw, SPECTRAL_CHANSCAN);
 		ath_dbg(common, CONFIG, "spectral scan: channel scan mode enabled\n");
 	} else if (strncmp("manual", buf, 6) == 0) {
-		ath9k_spectral_scan_config(sc->hw, SPECTRAL_MANUAL);
+		ath9k_spectral_scan_config(common->hw, SPECTRAL_MANUAL);
 		ath_dbg(common, CONFIG, "spectral scan: manual mode enabled\n");
 	} else if (strncmp("disable", buf, 7) == 0) {
-		ath9k_spectral_scan_config(sc->hw, SPECTRAL_DISABLED);
+		ath9k_spectral_scan_config(common->hw, SPECTRAL_DISABLED);
 		ath_dbg(common, CONFIG, "spectral scan: disabled\n");
 	} else {
 		return -EINVAL;
@@ -288,11 +289,11 @@ static ssize_t read_file_spectral_short_repeat(struct file *file,
 					       char __user *user_buf,
 					       size_t count, loff_t *ppos)
 {
-	struct ath_softc *sc = file->private_data;
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
 	char buf[32];
 	unsigned int len;
 
-	len = sprintf(buf, "%d\n", sc->spec_priv.spec_config.short_repeat);
+	len = sprintf(buf, "%d\n", spec_priv->spec_config.short_repeat);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -300,7 +301,7 @@ static ssize_t write_file_spectral_short_repeat(struct file *file,
 						const char __user *user_buf,
 						size_t count, loff_t *ppos)
 {
-	struct ath_softc *sc = file->private_data;
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
 	unsigned long val;
 	char buf[32];
 	ssize_t len;
@@ -316,7 +317,7 @@ static ssize_t write_file_spectral_short_repeat(struct file *file,
 	if (val > 1)
 		return -EINVAL;
 
-	sc->spec_priv.spec_config.short_repeat = val;
+	spec_priv->spec_config.short_repeat = val;
 	return count;
 }
 
@@ -336,11 +337,11 @@ static ssize_t read_file_spectral_count(struct file *file,
 					char __user *user_buf,
 					size_t count, loff_t *ppos)
 {
-	struct ath_softc *sc = file->private_data;
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
 	char buf[32];
 	unsigned int len;
 
-	len = sprintf(buf, "%d\n", sc->spec_priv.spec_config.count);
+	len = sprintf(buf, "%d\n", spec_priv->spec_config.count);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -348,7 +349,7 @@ static ssize_t write_file_spectral_count(struct file *file,
 					 const char __user *user_buf,
 					 size_t count, loff_t *ppos)
 {
-	struct ath_softc *sc = file->private_data;
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
 	unsigned long val;
 	char buf[32];
 	ssize_t len;
@@ -364,7 +365,7 @@ static ssize_t write_file_spectral_count(struct file *file,
 	if (val > 255)
 		return -EINVAL;
 
-	sc->spec_priv.spec_config.count = val;
+	spec_priv->spec_config.count = val;
 	return count;
 }
 
@@ -384,11 +385,11 @@ static ssize_t read_file_spectral_period(struct file *file,
 					 char __user *user_buf,
 					 size_t count, loff_t *ppos)
 {
-	struct ath_softc *sc = file->private_data;
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
 	char buf[32];
 	unsigned int len;
 
-	len = sprintf(buf, "%d\n", sc->spec_priv.spec_config.period);
+	len = sprintf(buf, "%d\n", spec_priv->spec_config.period);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -396,7 +397,7 @@ static ssize_t write_file_spectral_period(struct file *file,
 					  const char __user *user_buf,
 					  size_t count, loff_t *ppos)
 {
-	struct ath_softc *sc = file->private_data;
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
 	unsigned long val;
 	char buf[32];
 	ssize_t len;
@@ -412,7 +413,7 @@ static ssize_t write_file_spectral_period(struct file *file,
 	if (val > 255)
 		return -EINVAL;
 
-	sc->spec_priv.spec_config.period = val;
+	spec_priv->spec_config.period = val;
 	return count;
 }
 
@@ -432,11 +433,11 @@ static ssize_t read_file_spectral_fft_period(struct file *file,
 					     char __user *user_buf,
 					     size_t count, loff_t *ppos)
 {
-	struct ath_softc *sc = file->private_data;
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
 	char buf[32];
 	unsigned int len;
 
-	len = sprintf(buf, "%d\n", sc->spec_priv.spec_config.fft_period);
+	len = sprintf(buf, "%d\n", spec_priv->spec_config.fft_period);
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
@@ -444,7 +445,7 @@ static ssize_t write_file_spectral_fft_period(struct file *file,
 					      const char __user *user_buf,
 					      size_t count, loff_t *ppos)
 {
-	struct ath_softc *sc = file->private_data;
+	struct ath_spec_scan_priv *spec_priv = file->private_data;
 	unsigned long val;
 	char buf[32];
 	ssize_t len;
@@ -460,7 +461,7 @@ static ssize_t write_file_spectral_fft_period(struct file *file,
 	if (val > 15)
 		return -EINVAL;
 
-	sc->spec_priv.spec_config.fft_period = val;
+	spec_priv->spec_config.fft_period = val;
 	return count;
 }
 
@@ -506,38 +507,38 @@ static struct rchan_callbacks rfs_spec_scan_cb = {
 /* Debug Init/Deinit */
 /*********************/
 
-void ath9k_spectral_deinit_debug(struct ath_softc *sc)
+void ath9k_spectral_deinit_debug(struct ath_spec_scan_priv *spec_priv)
 {
-	if (config_enabled(CONFIG_ATH9K_DEBUGFS) && sc->spec_priv.rfs_chan_spec_scan) {
-		relay_close(sc->spec_priv.rfs_chan_spec_scan);
-		sc->spec_priv.rfs_chan_spec_scan = NULL;
+	if (config_enabled(CONFIG_ATH9K_DEBUGFS) && spec_priv->rfs_chan_spec_scan) {
+		relay_close(spec_priv->rfs_chan_spec_scan);
+		spec_priv->rfs_chan_spec_scan = NULL;
 	}
 }
 
-void ath9k_spectral_init_debug(struct ath_softc *sc, struct dentry *debugfs_phy)
+void ath9k_spectral_init_debug(struct ath_spec_scan_priv *spec_priv, struct dentry *debugfs_phy)
 {
-	sc->spec_priv.rfs_chan_spec_scan = relay_open("spectral_scan",
+	spec_priv->rfs_chan_spec_scan = relay_open("spectral_scan",
 					    debugfs_phy,
 					    1024, 256, &rfs_spec_scan_cb,
 					    NULL);
 	debugfs_create_file("spectral_scan_ctl",
 			    S_IRUSR | S_IWUSR,
-			    debugfs_phy, sc,
+			    debugfs_phy, spec_priv,
 			    &fops_spec_scan_ctl);
 	debugfs_create_file("spectral_short_repeat",
 			    S_IRUSR | S_IWUSR,
-			    debugfs_phy, sc,
+			    debugfs_phy, spec_priv,
 			    &fops_spectral_short_repeat);
 	debugfs_create_file("spectral_count",
 			    S_IRUSR | S_IWUSR,
-			    debugfs_phy, sc,
+			    debugfs_phy, spec_priv,
 			    &fops_spectral_count);
 	debugfs_create_file("spectral_period",
 			    S_IRUSR | S_IWUSR,
-			    debugfs_phy, sc,
+			    debugfs_phy, spec_priv,
 			    &fops_spectral_period);
 	debugfs_create_file("spectral_fft_period",
 			    S_IRUSR | S_IWUSR,
-			    debugfs_phy, sc,
+			    debugfs_phy, spec_priv,
 			    &fops_spectral_fft_period);
 }
diff --git a/drivers/net/wireless/ath/ath9k/spectral.h b/drivers/net/wireless/ath/ath9k/spectral.h
index 638320d..555fcbb 100644
--- a/drivers/net/wireless/ath/ath9k/spectral.h
+++ b/drivers/net/wireless/ath/ath9k/spectral.h
@@ -130,18 +130,18 @@ static inline u8 spectral_bitmap_weight(u8 *bins)
 	return bins[0] & 0x3f;
 }
 
-void ath9k_spectral_init_debug(struct ath_softc *sc, struct dentry *debugfs_phy);
-void ath9k_spectral_deinit_debug(struct ath_softc *sc);
+void ath9k_spectral_init_debug(struct ath_spec_scan_priv *spec_priv, struct dentry *debugfs_phy);
+void ath9k_spectral_deinit_debug(struct ath_spec_scan_priv *spec_priv);
 
 void ath9k_spectral_scan_trigger(struct ieee80211_hw *hw);
 int ath9k_spectral_scan_config(struct ieee80211_hw *hw,
 			       enum spectral_mode spectral_mode);
 
 #ifdef CONFIG_ATH9K_DEBUGFS
-int ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
+int ath_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_hdr *hdr,
 		    struct ath_rx_status *rs, u64 tsf);
 #else
-static inline int ath_process_fft(struct ath_softc *sc,
+static inline int ath_process_fft(struct ath_spec_scan_priv *spec_priv,
 				  struct ieee80211_hdr *hdr,
 				  struct ath_rx_status *rs, u64 tsf)
 {
-- 
1.9.1

