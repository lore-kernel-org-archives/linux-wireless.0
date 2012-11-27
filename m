Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:34026 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab2K0TBy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 14:01:54 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [RFC 3/3] ath9k: add spectral scan feature
Date: Tue, 27 Nov 2012 20:01:24 +0100
Message-Id: <1354042885-32688-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121127_200200_194178_79976825)
In-Reply-To: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354042885-32688-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds the spectral scan feature for ath9k. AR92xx and AR93xx chips
are supported for now. The spectral scan is triggered within a
channel scan from mac80211, results can be gathered via debugfs.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |   37 +++++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   37 +++++++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h      |   12 ++++
 drivers/net/wireless/ath/ath9k/debug.c      |   79 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h         |    4 ++
 drivers/net/wireless/ath/ath9k/init.c       |   13 +++++
 drivers/net/wireless/ath/ath9k/mac.h        |    7 ++-
 drivers/net/wireless/ath/ath9k/main.c       |   29 ++++++++++
 drivers/net/wireless/ath/ath9k/recv.c       |   34 ++++++++++++
 9 files changed, 250 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 846dd79..9d8199d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -555,6 +555,42 @@ static void ar9002_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_MULTICHAIN_GAIN_CTL, regval);
 }
 
+void ar9002_hw_spectral_scan(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	REG_SET_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_FFT_ENA);
+
+	/* NOTE: this will generate a few samples ... lacking documentation,
+	 * I'm not really sure what these parameters mean.
+	 */
+	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENABLE);
+	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+		    AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT);
+	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
+		      AR_PHY_SPECTRAL_SCAN_COUNT, 8);
+	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
+		      AR_PHY_SPECTRAL_SCAN_PERIOD, 0xF);
+	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
+		      AR_PHY_SPECTRAL_SCAN_FFT_PERIOD, 0xFF);
+
+	/* Activate spectral scan */
+	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+		    AR_PHY_SPECTRAL_SCAN_ACTIVE);
+
+	/* Poll for spectral scan complete */
+	if (!ath9k_hw_wait(ah, AR_PHY_SPECTRAL_SCAN,
+			   AR_PHY_SPECTRAL_SCAN_ACTIVE,
+			   0, AH_WAIT_TIMEOUT)) {
+		ath_err(common, "spectral scan wait failed\n");
+		return;
+	}
+
+	/* Disable spectral scan */
+	REG_CLR_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+		    AR_PHY_SPECTRAL_SCAN_ENABLE);
+}
+
 void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -571,6 +607,7 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 
 	ops->antdiv_comb_conf_get = ar9002_hw_antdiv_comb_conf_get;
 	ops->antdiv_comb_conf_set = ar9002_hw_antdiv_comb_conf_set;
+	ops->spectral_scan = ar9002_hw_spectral_scan;
 
 	ar9002_hw_set_nf_limits(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index ce19c09..c79d701 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1450,6 +1450,42 @@ set_rfmode:
 	return 0;
 }
 
+void ar9003_hw_spectral_scan(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	REG_SET_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_FFT_ENA);
+
+	/* NOTE: this will generate a few samples ... lacking documentation,
+	 * I'm not really sure what these parameters mean.
+	 */
+	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENABLE);
+	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+		    AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT);
+	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
+		      AR_PHY_SPECTRAL_SCAN_COUNT, 8);
+	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
+		      AR_PHY_SPECTRAL_SCAN_PERIOD, 0xF);
+	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
+		      AR_PHY_SPECTRAL_SCAN_FFT_PERIOD, 0xFF);
+
+	/* Activate spectral scan */
+	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+		    AR_PHY_SPECTRAL_SCAN_ACTIVE);
+
+	/* Poll for spectral scan complete */
+	if (!ath9k_hw_wait(ah, AR_PHY_SPECTRAL_SCAN,
+			   AR_PHY_SPECTRAL_SCAN_ACTIVE,
+			   0, AH_WAIT_TIMEOUT)) {
+		ath_err(common, "spectral scan wait failed\n");
+		return;
+	}
+
+	/* Disable spectral scan */
+	REG_CLR_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+		    AR_PHY_SPECTRAL_SCAN_ENABLE);
+}
+
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -1483,6 +1519,7 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	ops->antdiv_comb_conf_get = ar9003_hw_antdiv_comb_conf_get;
 	ops->antdiv_comb_conf_set = ar9003_hw_antdiv_comb_conf_set;
 	ops->antctrl_shared_chain_lnadiv = ar9003_hw_antctrl_shared_chain_lnadiv;
+	ops->spectral_scan = ar9003_hw_spectral_scan;
 
 	ar9003_hw_set_nf_limits(ah);
 	ar9003_hw_set_radar_conf(ah);
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 80bab1b..3a7789a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -738,6 +738,8 @@ struct ath_softc {
 	u8 ant_tx, ant_rx;
 	struct dfs_pattern_detector *dfs_detector;
 	u32 wow_enabled;
+	struct list_head fft_list;
+	int fft_list_n;
 
 #ifdef CONFIG_PM_SLEEP
 	atomic_t wow_got_bmiss_intr;
@@ -746,6 +748,16 @@ struct ath_softc {
 #endif
 };
 
+struct fft_sample {
+	struct list_head list;
+	u16 freq;
+	u8 rssi;
+	u8 ext_rssi;
+	u8 noise;
+	u8 *data;
+	s16 size;
+};
+
 void ath9k_tasklet(unsigned long data);
 int ath_cabq_update(struct ath_softc *);
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 939308c..3576778 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -966,6 +966,83 @@ static const struct file_operations fops_recv = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_spectral_scan(struct file *file, char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	unsigned int len;
+	char buf[64];
+	struct fft_sample *fft_sample;
+	int i, ret, tlen = 0;
+
+	/* fft_samples are added within the same spinlock */
+	spin_lock_bh(&sc->rx.rxbuflock);
+	if (list_empty(&sc->fft_list)) {
+		spin_unlock_bh(&sc->rx.rxbuflock);
+		return 0;
+	}
+
+	fft_sample = list_first_entry(&sc->fft_list, struct fft_sample, list);
+	list_del(&fft_sample->list);
+	sc->fft_list_n--;
+	spin_unlock_bh(&sc->rx.rxbuflock);
+
+	/* print some additional information, like frequency, rssi, */
+	len = sprintf(buf, "%04d %03d %03d %03d ",
+		      fft_sample->freq, fft_sample->rssi,
+		      fft_sample->ext_rssi, fft_sample->noise);
+
+	/* wouldn't be able to fill header and data */
+	if ((tlen + len + 5 * fft_sample->size + 1) > count)
+		return 0;
+
+	ret = copy_to_user(user_buf + tlen, buf, len);
+	tlen += len - ret;
+	*ppos += len - ret;
+
+	/* TODO: anyone with the spectral scan specs, please confirm/explain!
+	 *
+	 * the last 7 bytes seem to have a special meaning.
+	 *
+	 * byte 0 to n-8: spectral scan data, length varies
+	 * byte n-1: this might be bwinfo according to DFS, usually 0x10 or
+	 *           0x11
+	 * byte n-2: always 0 in my dumps, pulse-length-ext in dfs code
+	 * byte n-3: always 0 on my AR9003, mostly 15, 16 or something bigger
+	 *           on my AR9002
+	 * byte n-4: appears to be some kind of offset (exponent?)
+	 * byte n-5: no clue
+	 * byte n-6: no clue, but appears to have something to do with RSSI
+	 * byte n-7: lower 6 bit seem to hold some value which is higher on
+	 *           AR9002 when there is no real signal
+	 */
+
+	/* dump the packet content here */
+	for (i = 0; i < fft_sample->size; i++) {
+		len = sprintf(buf, "0x%02x ", fft_sample->data[i]);
+		ret = copy_to_user(user_buf + tlen, buf, len);
+		tlen += len - ret;
+		*ppos += len - ret;
+	}
+	len = sprintf(buf, "\n");
+	ret = copy_to_user(user_buf + tlen, buf, len);
+	tlen += len - ret;
+	*ppos += len - ret;
+
+	kfree(fft_sample->data);
+	kfree(fft_sample);
+
+	return tlen;
+}
+
+static const struct file_operations fops_spectral_scan = {
+	.read = read_file_spectral_scan,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+
 static ssize_t read_file_regidx(struct file *file, char __user *user_buf,
                                 size_t count, loff_t *ppos)
 {
@@ -1571,6 +1648,8 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_base_eeprom);
 	debugfs_create_file("modal_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_modal_eeprom);
+	debugfs_create_file("spectral_scan", S_IRUSR, sc->debug.debugfs_phy,
+			    sc, &fops_spectral_scan);
 #ifdef CONFIG_ATH9K_MAC_DEBUG
 	debugfs_create_file("samples", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_samps);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 3636dab..7f5a917 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -20,6 +20,7 @@
 #include <linux/if_ether.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/list.h>
 
 #include "mac.h"
 #include "ani.h"
@@ -666,6 +667,8 @@ struct ath_hw_private_ops {
  *
  * @config_pci_powersave:
  * @calibrate: periodic calibration for NF, ANI, IQ, ADC gain, ADC-DC
+ *
+ * @spectral_scan: initiate a spectral scan on the current channel
  */
 struct ath_hw_ops {
 	void (*config_pci_powersave)(struct ath_hw *ah,
@@ -686,6 +689,7 @@ struct ath_hw_ops {
 	void (*antdiv_comb_conf_set)(struct ath_hw *ah,
 			struct ath_hw_antcomb_conf *antconf);
 	void (*antctrl_shared_chain_lnadiv)(struct ath_hw *hw, bool enable);
+	void (*spectral_scan)(struct ath_hw *ah);
 };
 
 struct ath_nf_limits {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 80cae53..e4384a8 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -528,6 +528,8 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	sc->sc_ah = ah;
 
 	sc->dfs_detector = dfs_pattern_detector_init(NL80211_DFS_UNSET);
+	INIT_LIST_HEAD(&sc->fft_list);
+	sc->fft_list_n = 0;
 
 	if (!pdata) {
 		ah->ah_flags |= AH_USE_EEPROM;
@@ -878,6 +880,17 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
+	while (!list_empty(&sc->fft_list)) {
+		struct fft_sample *fft_sample;
+		fft_sample = list_first_entry(&sc->fft_list,
+					      struct fft_sample,
+					      list);
+		list_del(&fft_sample->list);
+		kfree(fft_sample->data);
+		kfree(fft_sample);
+	}
+
+	INIT_LIST_HEAD(&sc->fft_list);
 	ath9k_hw_deinit(sc->sc_ah);
 	if (sc->dfs_detector != NULL)
 		sc->dfs_detector->exit(sc->dfs_detector);
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 4a745e6..5cad975 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -225,8 +225,11 @@ enum ath9k_phyerr {
 	ATH9K_PHYERR_HT_CRC_ERROR         = 34,
 	ATH9K_PHYERR_HT_LENGTH_ILLEGAL    = 35,
 	ATH9K_PHYERR_HT_RATE_ILLEGAL      = 36,
-
-	ATH9K_PHYERR_MAX                  = 37,
+	ATH9K_PHYERR_FFT_REPORT		  = 38, /* can anyone with the specs
+						 * confirm this please?
+						 * Obviously AR9003 only.
+						 */
+	ATH9K_PHYERR_MAX                  = 39,
 };
 
 struct ath_desc {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0653dbc..8f64415 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2365,6 +2365,33 @@ static void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled)
 
 #endif
 
+static void ath9k_spectral_scan(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 rxfilter;
+
+	if (!ath9k_hw_ops(ah)->spectral_scan) {
+		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
+		return;
+	}
+
+	ath9k_ps_wakeup(sc);
+	rxfilter = ath9k_hw_getrxfilter(ah);
+	ath9k_hw_setrxfilter(ah, rxfilter |
+				 ATH9K_RX_FILTER_PHYRADAR |
+				 ATH9K_RX_FILTER_PHYERR);
+	ath9k_ps_restore(sc);
+
+	ath9k_hw_ops(ah)->spectral_scan(ah);
+
+	/* restore rxfilter */
+	ath9k_ps_wakeup(sc);
+	ath9k_hw_setrxfilter(sc->sc_ah, rxfilter);
+	ath9k_ps_restore(sc);
+}
+
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
@@ -2405,4 +2432,6 @@ struct ieee80211_ops ath9k_ops = {
 	.get_et_stats  = ath9k_get_et_stats,
 	.get_et_strings  = ath9k_get_et_strings,
 #endif
+
+	.spectral_scan = ath9k_spectral_scan,
 };
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 6aafbb7..793fc91 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1034,6 +1034,35 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
 		rxs->flag &= ~RX_FLAG_DECRYPTED;
 }
 
+static void ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
+			    struct ath_rx_status *rs)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct fft_sample *fft_sample;
+
+	/* too short data is probably something else */
+	if (rs->rs_datalen < 30)
+		return;
+
+	/* don't bloat memory if userspace is lazy collecting fft data */
+	if (sc->fft_list_n > 10000)
+		return;
+
+	fft_sample = kmalloc(sizeof(*fft_sample), GFP_ATOMIC);
+	INIT_LIST_HEAD(&fft_sample->list);
+
+	fft_sample->freq = ah->curchan->chan->center_freq;
+	fft_sample->size = rs->rs_datalen;
+	fft_sample->rssi = rs->rs_rssi_ctl0;
+	fft_sample->ext_rssi = rs->rs_rssi_ext0;
+	fft_sample->noise = ah->noise;
+	fft_sample->data = kmalloc(fft_sample->size, GFP_ATOMIC);
+	memcpy(fft_sample->data, (u8 *)hdr, fft_sample->size);
+
+	list_add_tail(&fft_sample->list, &sc->fft_list);
+	sc->fft_list_n++;
+}
+
 int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 {
 	struct ath_buf *bf;
@@ -1131,6 +1160,11 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
 			rxs->mactime += 0x100000000ULL;
 
+		if ((rs.rs_status & ATH9K_RXERR_PHY) &&
+		    (rs.rs_phyerr == ATH9K_PHYERR_RADAR ||
+		     rs.rs_phyerr == ATH9K_PHYERR_FFT_REPORT))
+			ath_process_fft(sc, hdr, &rs);
+
 		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
 						 rxs, &decrypt_error);
 		if (retval)
-- 
1.7.10.4

