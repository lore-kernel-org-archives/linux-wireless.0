Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:41369 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab2LSRDn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 12:03:43 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, nbd@openwrt.org,
	tobias.steinicke@net.t-labs.tu-berlin.de, jonbither@gmail.com,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [RFCv3] ath9k: add spectral scan feature
Date: Wed, 19 Dec 2012 18:03:24 +0100
Message-Id: <1355936604-13568-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121219_180348_445624_CDB12C62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds the spectral scan feature for ath9k. AR92xx and AR93xx chips
are supported for now. The spectral scan is triggered by configuring
a mode through a debugfs control file. Samples can be gathered via
another relay debugfs file.

Essentially, to try it out:

echo chanscan > /sys/kernel/debug/ieee80211/phy0/ath9k/spectral_scan_ctl
iw dev wlan0 scan
cat /sys/kernel/debug/ieee80211/phy0/ath9k/spectral_scan0 > samples
echo disable > /sys/kernel/debug/ieee80211/phy0/ath9k/spectral_scan_ctl

This feature is still experimental.

The special "chanscan" mode is used to perform spectral scan while
mac80211 is scanning for channels. To allow this,
sw_scan_start/complete() ops have been added.

The patch contains code snippets and information from Zefir Kurtisi and
information provided by Adrian Chadd and Felix Fietkau.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>

---
Thanks a lot to Adrian, Felix, Zefir, and everyone else contributing to
get this feature upstream. :)

Sample program for viewing the data is updated and available here:

https://github.com/simonwunderlich/FFT_eval/

Changes to RFCv2:
 * change to TLV/binary format for output
 * add a lot of information for data format and parameters
 * implement HT20 only (but add info for Dynamic 20/40 format)
 * interpret the data within the driver (apply offset, fix blind spot,
   fix data length variation, ...) before sending

Changes to RFCv1:
 * remove nl80211/mac80211 stuff for now, to build a proper interface
   after intepretation/output stabilized
 * split spectral scan call into config, trigger and wait call, which
 * can
   be called as desired (or depending on the mode)
 * use relay(fs) to stream spectral scan results (thanks for the hint
 * Felix),
   this seems to be much cleaner - as long as we stay in debugfs
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |   64 +++++++++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   64 +++++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h      |  152 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.c      |  115 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/debug.h      |    5 +
 drivers/net/wireless/ath/ath9k/hw.h         |   39 +++++++
 drivers/net/wireless/ath/ath9k/init.c       |    7 ++
 drivers/net/wireless/ath/ath9k/mac.h        |    3 +-
 drivers/net/wireless/ath/ath9k/main.c       |  100 ++++++++++++++++++
 drivers/net/wireless/ath/ath9k/recv.c       |  106 +++++++++++++++++++
 10 files changed, 654 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 846dd79..6de5442 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -555,6 +555,67 @@ static void ar9002_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_MULTICHAIN_GAIN_CTL, regval);
 }
 
+void ar9002_hw_spectral_scan_config(struct ath_hw *ah,
+				    struct ath_spec_scan *param)
+{
+	u8 count;
+
+	if (!param->enabled) {
+		REG_CLR_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+			    AR_PHY_SPECTRAL_SCAN_ENABLE);
+		return;
+	}
+	REG_SET_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_FFT_ENA);
+	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENABLE);
+
+	if (param->short_repeat)
+		REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+			    AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT);
+	else
+		REG_CLR_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+			    AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT);
+
+	/* on AR92xx, the highest bit of count will make the the chip send
+	 * spectral samples endlessly. Check if this really was intended,
+	 * and fix otherwise.
+	 */
+	count = param->count;
+	if (param->endless)
+		count = 0;
+	else if (count & 0x80)
+		count = 0x7f;
+
+	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
+		      AR_PHY_SPECTRAL_SCAN_COUNT, count);
+	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
+		      AR_PHY_SPECTRAL_SCAN_PERIOD, param->period);
+	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
+		      AR_PHY_SPECTRAL_SCAN_FFT_PERIOD, param->fft_period);
+
+	return;
+}
+
+static void ar9002_hw_spectral_scan_trigger(struct ath_hw *ah)
+{
+	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENABLE);
+	/* Activate spectral scan */
+	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+		    AR_PHY_SPECTRAL_SCAN_ACTIVE);
+}
+
+static void ar9002_hw_spectral_scan_wait(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	/* Poll for spectral scan complete */
+	if (!ath9k_hw_wait(ah, AR_PHY_SPECTRAL_SCAN,
+			   AR_PHY_SPECTRAL_SCAN_ACTIVE,
+			   0, AH_WAIT_TIMEOUT)) {
+		ath_err(common, "spectral scan wait failed\n");
+		return;
+	}
+}
+
 void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -571,6 +632,9 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 
 	ops->antdiv_comb_conf_get = ar9002_hw_antdiv_comb_conf_get;
 	ops->antdiv_comb_conf_set = ar9002_hw_antdiv_comb_conf_set;
+	ops->spectral_scan_config = ar9002_hw_spectral_scan_config;
+	ops->spectral_scan_trigger = ar9002_hw_spectral_scan_trigger;
+	ops->spectral_scan_wait = ar9002_hw_spectral_scan_wait;
 
 	ar9002_hw_set_nf_limits(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index ce19c09..1b9156d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1450,6 +1450,67 @@ set_rfmode:
 	return 0;
 }
 
+static void ar9003_hw_spectral_scan_config(struct ath_hw *ah,
+					   struct ath_spec_scan *param)
+{
+	u8 count;
+
+	if (!param->enabled) {
+		REG_CLR_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+			    AR_PHY_SPECTRAL_SCAN_ENABLE);
+		return;
+	}
+
+	REG_SET_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_FFT_ENA);
+	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENABLE);
+
+	/* on AR93xx and newer, count = 0 will make the the chip send
+	 * spectral samples endlessly. Check if this really was intended,
+	 * and fix otherwise.
+	 */
+	count = param->count;
+	if (param->endless)
+		count = 0;
+	else if (param->count == 0)
+		count = 1;
+
+	if (param->short_repeat)
+		REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+			    AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT);
+	else
+		REG_CLR_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+			    AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT);
+
+	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
+		      AR_PHY_SPECTRAL_SCAN_COUNT, count);
+	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
+		      AR_PHY_SPECTRAL_SCAN_PERIOD, param->period);
+	REG_RMW_FIELD(ah, AR_PHY_SPECTRAL_SCAN,
+		      AR_PHY_SPECTRAL_SCAN_FFT_PERIOD, param->fft_period);
+
+	return;
+}
+
+static void ar9003_hw_spectral_scan_trigger(struct ath_hw *ah)
+{
+	/* Activate spectral scan */
+	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN,
+		    AR_PHY_SPECTRAL_SCAN_ACTIVE);
+
+}
+static void ar9003_hw_spectral_scan_wait(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	/* Poll for spectral scan complete */
+	if (!ath9k_hw_wait(ah, AR_PHY_SPECTRAL_SCAN,
+			   AR_PHY_SPECTRAL_SCAN_ACTIVE,
+			   0, AH_WAIT_TIMEOUT)) {
+		ath_err(common, "spectral scan wait failed\n");
+		return;
+	}
+}
+
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -1483,6 +1544,9 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	ops->antdiv_comb_conf_get = ar9003_hw_antdiv_comb_conf_get;
 	ops->antdiv_comb_conf_set = ar9003_hw_antdiv_comb_conf_set;
 	ops->antctrl_shared_chain_lnadiv = ar9003_hw_antctrl_shared_chain_lnadiv;
+	ops->spectral_scan_config = ar9003_hw_spectral_scan_config;
+	ops->spectral_scan_trigger = ar9003_hw_spectral_scan_trigger;
+	ops->spectral_scan_wait = ar9003_hw_spectral_scan_wait;
 
 	ar9003_hw_set_nf_limits(ah);
 	ar9003_hw_set_radar_conf(ah);
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 86e26a1..222622f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -675,6 +675,23 @@ struct ath9k_vif_iter_data {
 	int nadhocs;   /* number of adhoc vifs */
 };
 
+/* enum spectral_mode:
+ *
+ * @SPECTRAL_DISABLED: spectral mode is disabled
+ * @SPECTRAL_BACKGROUND: hardware sends samples when it is not busy with
+ *	something else.
+ * @SPECTRAL_MANUAL: spectral scan is enabled, triggering for samples
+ *	is performed manually.
+ * @SPECTRAL_CHANSCAN: Like manual, but also triggered when changing channels
+ *	during a channel scan.
+ */
+enum spectral_mode {
+	SPECTRAL_DISABLED = 0,
+	SPECTRAL_BACKGROUND,
+	SPECTRAL_MANUAL,
+	SPECTRAL_CHANSCAN,
+};
+
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
@@ -743,6 +760,10 @@ struct ath_softc {
 	u8 ant_tx, ant_rx;
 	struct dfs_pattern_detector *dfs_detector;
 	u32 wow_enabled;
+	/* relay(fs) channel for spectral scan */
+	struct rchan *rfs_chan_spec_scan;
+	enum spectral_mode spectral_mode;
+	int scanning;
 
 #ifdef CONFIG_PM_SLEEP
 	atomic_t wow_got_bmiss_intr;
@@ -751,6 +772,133 @@ struct ath_softc {
 #endif
 };
 
+#define SPECTRAL_SCAN_BITMASK		0x10
+/* Radar info packet format, used for DFS and spectral formats. */
+struct ath_radar_info {
+	u8 pulse_length_pri;
+	u8 pulse_length_ext;
+	u8 pulse_bw_info;
+} __packed;
+
+/* The HT20 spectral data has 4 bytes of additional information at it's end.
+ *
+ * [7:0]: all bins {max_magnitude[1:0], bitmap_weight[5:0]}
+ * [7:0]: all bins  max_magnitude[9:2]
+ * [7:0]: all bins {max_index[5:0], max_magnitude[11:10]}
+ * [3:0]: max_exp (shift amount to size max bin to 8-bit unsigned)
+ */
+struct ath_ht20_mag_info {
+	u8 all_bins[3];
+	u8 max_exp;
+} __packed;
+
+#define SPECTRAL_HT20_NUM_BINS		56
+
+/* WARNING: don't actually use this struct! MAC may vary the amount of
+ * data by -1/+2. This struct is for reference only.
+ */
+struct ath_ht20_fft_packet {
+	u8 data[SPECTRAL_HT20_NUM_BINS];
+	struct ath_ht20_mag_info mag_info;
+	struct ath_radar_info radar_info;
+} __packed;
+
+#define SPECTRAL_HT20_TOTAL_DATA_LEN	(sizeof(struct ath_ht20_fft_packet))
+
+/* Dynamic 20/40 mode:
+ *
+ * [7:0]: lower bins {max_magnitude[1:0], bitmap_weight[5:0]}
+ * [7:0]: lower bins  max_magnitude[9:2]
+ * [7:0]: lower bins {max_index[5:0], max_magnitude[11:10]}
+ * [7:0]: upper bins {max_magnitude[1:0], bitmap_weight[5:0]}
+ * [7:0]: upper bins  max_magnitude[9:2]
+ * [7:0]: upper bins {max_index[5:0], max_magnitude[11:10]}
+ * [3:0]: max_exp (shift amount to size max bin to 8-bit unsigned)
+ */
+struct ath_ht20_40_mag_info {
+	u8 lower_bins[3];
+	u8 upper_bins[3];
+	u8 max_exp;
+} __packed;
+
+#define SPECTRAL_HT20_40_NUM_BINS		128
+
+/* WARNING: don't actually use this struct! MAC may vary the amount of
+ * data. This struct is for reference only.
+ */
+struct ath_ht20_40_fft_packet {
+	u8 data[SPECTRAL_HT20_40_NUM_BINS];
+	struct ath_ht20_40_mag_info mag_info;
+	struct ath_radar_info radar_info;
+} __packed;
+
+
+#define SPECTRAL_HT20_40_TOTAL_DATA_LEN	(sizeof(struct ath_ht20_40_fft_packet))
+
+/* grabs the max magnitude from the all/upper/lower bins */
+static inline u16 spectral_max_magnitude(u8 *bins)
+{
+	return (bins[0] & 0xc0) >> 6 |
+	       (bins[1] & 0xff) << 2 |
+	       (bins[2] & 0x03) << 10;
+}
+
+/* return the max magnitude from the all/upper/lower bins */
+static inline u8 spectral_max_index(u8 *bins)
+{
+	s8 m = (bins[2] & 0xfc) >> 2;
+
+	/* TODO: this still doesn't always report the right values ... */
+	if (m > 32)
+		m |= 0xe0;
+	else
+		m &= ~0xe0;
+
+	return m + 29;
+}
+
+/* return the bitmap weight from the all/upper/lower bins */
+static inline u8 spectral_bitmap_weight(u8 *bins)
+{
+	return bins[0] & 0x3f;
+}
+
+/* FFT sample format given to userspace via debugfs.
+ *
+ * Please keep the type/length at the front position and change
+ * other fields after adding another sample type
+ *
+ * TODO: this might need rework when switching to nl80211-based
+ * interface.
+ */
+enum ath_fft_sample_type {
+	ATH_FFT_SAMPLE_HT20 = 0,
+};
+
+struct fft_sample_tlv {
+	u8 type;	/* see ath_fft_sample */
+	u16 length;
+	/* type dependent data follows */
+} __packed;
+
+struct fft_sample_ht20 {
+	struct fft_sample_tlv tlv;
+
+	u8 __alignment;
+
+	u16 freq;
+	s8 rssi;
+	s8 noise;
+
+	u16 max_magnitude;
+	u8 max_index;
+	u8 bitmap_weight;
+
+	u64 tsf;
+
+	u16 data[SPECTRAL_HT20_NUM_BINS];
+} __packed;
+
 void ath9k_tasklet(unsigned long data);
 int ath_cabq_update(struct ath_softc *);
 
@@ -773,6 +921,10 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
 void ath9k_reload_chainmask_settings(struct ath_softc *sc);
 
 bool ath9k_uses_beacons(int type);
+void ath9k_spectral_scan_trigger(struct ieee80211_hw *hw);
+int ath9k_spectral_scan_config(struct ieee80211_hw *hw,
+			       enum spectral_mode spectral_mode);
+
 
 #ifdef CONFIG_ATH9K_PCI
 int ath_pci_init(void);
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 13ff9ed..75b504b 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/export.h>
+#include <linux/relay.h>
 #include <asm/unaligned.h>
 
 #include "ath9k.h"
@@ -966,6 +967,112 @@ static const struct file_operations fops_recv = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_spec_scan_ctl(struct file *file, char __user *user_buf,
+				       size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char *mode = "";
+	unsigned int len;
+
+	switch (sc->spectral_mode) {
+	case SPECTRAL_DISABLED:
+		mode = "disable";
+		break;
+	case SPECTRAL_BACKGROUND:
+		mode = "background";
+		break;
+	case SPECTRAL_CHANSCAN:
+		mode = "chanscan";
+		break;
+	case SPECTRAL_MANUAL:
+		mode = "manual";
+		break;
+	}
+	len = strlen(mode);
+	return simple_read_from_buffer(user_buf, count, ppos, mode, len);
+}
+
+static ssize_t write_file_spec_scan_ctl(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+
+	if (strncmp("trigger", buf, 7) == 0) {
+		ath9k_spectral_scan_trigger(sc->hw);
+	} else if (strncmp("background", buf, 9) == 0) {
+		ath9k_spectral_scan_config(sc->hw, SPECTRAL_BACKGROUND);
+		ath_dbg(common, CONFIG, "spectral scan: background mode enabled\n");
+	} else if (strncmp("chanscan", buf, 8) == 0) {
+		ath9k_spectral_scan_config(sc->hw, SPECTRAL_CHANSCAN);
+		ath_dbg(common, CONFIG, "spectral scan: channel scan mode enabled\n");
+	} else if (strncmp("manual", buf, 6) == 0) {
+		ath9k_spectral_scan_config(sc->hw, SPECTRAL_MANUAL);
+		ath_dbg(common, CONFIG, "spectral scan: manual mode enabled\n");
+	} else if (strncmp("disable", buf, 7) == 0) {
+		ath9k_spectral_scan_config(sc->hw, SPECTRAL_DISABLED);
+		ath_dbg(common, CONFIG, "spectral scan: disabled\n");
+	} else {
+		return -EINVAL;
+	}
+
+	return count;
+}
+
+static const struct file_operations fops_spec_scan_ctl = {
+	.read = read_file_spec_scan_ctl,
+	.write = write_file_spec_scan_ctl,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static struct dentry *create_buf_file_handler(const char *filename,
+					      struct dentry *parent,
+					      umode_t mode,
+					      struct rchan_buf *buf,
+					      int *is_global)
+{
+	struct dentry *buf_file;
+
+	buf_file = debugfs_create_file(filename, mode, parent, buf,
+				       &relay_file_operations);
+	*is_global = 1;
+	return buf_file;
+}
+
+static int remove_buf_file_handler(struct dentry *dentry)
+{
+	debugfs_remove(dentry);
+
+	return 0;
+}
+
+void ath_debug_send_fft_sample(struct ath_softc *sc,
+			       struct fft_sample_tlv *fft_sample_tlv)
+{
+	if (!sc->rfs_chan_spec_scan)
+		return;
+
+	relay_write(sc->rfs_chan_spec_scan, fft_sample_tlv,
+		    fft_sample_tlv->length + sizeof(*fft_sample_tlv));
+}
+
+static struct rchan_callbacks rfs_spec_scan_cb = {
+	.create_buf_file = create_buf_file_handler,
+	.remove_buf_file = remove_buf_file_handler,
+};
+
+
 static ssize_t read_file_regidx(struct file *file, char __user *user_buf,
                                 size_t count, loff_t *ppos)
 {
@@ -1780,6 +1887,14 @@ int ath9k_init_debug(struct ath_hw *ah)
 			    &fops_base_eeprom);
 	debugfs_create_file("modal_eeprom", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_modal_eeprom);
+	sc->rfs_chan_spec_scan = relay_open("spectral_scan",
+					    sc->debug.debugfs_phy,
+					    262144, 4, &rfs_spec_scan_cb,
+					    NULL);
+	debugfs_create_file("spectral_scan_ctl", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc,
+			    &fops_spec_scan_ctl);
+
 #ifdef CONFIG_ATH9K_MAC_DEBUG
 	debugfs_create_file("samples", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_samps);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 375c3b4..b19bed7 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -23,6 +23,7 @@
 
 struct ath_txq;
 struct ath_buf;
+struct fft_sample_tlv;
 
 #ifdef CONFIG_ATH9K_DEBUGFS
 #define TX_STAT_INC(q, c) sc->debug.stats.txstats[q].c++
@@ -323,6 +324,10 @@ void ath9k_sta_remove_debugfs(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_sta *sta,
 			      struct dentry *dir);
+
+void ath_debug_send_fft_sample(struct ath_softc *sc,
+			       struct fft_sample_tlv *fft_sample);
+
 #else
 
 #define RX_STAT_INC(c) /* NOP */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7f1a8e9..dd7549a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -661,6 +661,37 @@ struct ath_hw_private_ops {
 };
 
 /**
+ * struct ath_spec_scan - parameters for Atheros spectral scan
+ *
+ * @enabled: enable/disable spectral scan
+ * @short_repeat: controls whether the chip is in spectral scan mode
+ *		  for 4 usec (enabled) or 204 usec (disabled)
+ * @count: number of scan results requested. There are special meanings
+ *	   in some chip revisions:
+ *	   AR92xx: highest bit set (>=128) for endless mode
+ *		   (spectral scan won't stopped until explicitly disabled)
+ *	   AR9300 and newer: 0 for endless mode
+ * @endless: true if endless mode is intended. Otherwise, count value is
+ *           corrected to the next possible value.
+ * @period: time duration between successive spectral scan entry points
+ *	    (period*256*Tclk). Tclk = ath_common->clockrate
+ * @fft_period: PHY passes FFT frames to MAC every (fft_period+1)*4uS
+ *
+ * Note: Tclk = 40MHz or 44MHz depending upon operating mode.
+ *	 Typically it's 44MHz in 2/5GHz on later chips, but there's
+ *	 a "fast clock" check for this in 5GHz.
+ *
+ */
+struct ath_spec_scan {
+	bool enabled;
+	bool short_repeat;
+	bool endless;
+	u8 count;
+	u8 period;
+	u8 fft_period;
+};
+
+/**
  * struct ath_hw_ops - callbacks used by hardware code and driver code
  *
  * This structure contains callbacks designed to to be used internally by
@@ -668,6 +699,10 @@ struct ath_hw_private_ops {
  *
  * @config_pci_powersave:
  * @calibrate: periodic calibration for NF, ANI, IQ, ADC gain, ADC-DC
+ *
+ * @spectral_scan_config: set parameters for spectral scan and enable/disable it
+ * @spectral_scan_trigger: trigger a spectral scan run
+ * @spectral_scan_wait: wait for a spectral scan run to finish
  */
 struct ath_hw_ops {
 	void (*config_pci_powersave)(struct ath_hw *ah,
@@ -688,6 +723,10 @@ struct ath_hw_ops {
 	void (*antdiv_comb_conf_set)(struct ath_hw *ah,
 			struct ath_hw_antcomb_conf *antconf);
 	void (*antctrl_shared_chain_lnadiv)(struct ath_hw *hw, bool enable);
+	void (*spectral_scan_config)(struct ath_hw *ah,
+				     struct ath_spec_scan *param);
+	void (*spectral_scan_trigger)(struct ath_hw *ah);
+	void (*spectral_scan_wait)(struct ath_hw *ah);
 };
 
 struct ath_nf_limits {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f69ef5d..29d5fae 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/ath9k_platform.h>
 #include <linux/module.h>
+#include <linux/relay.h>
 
 #include "ath9k.h"
 
@@ -940,6 +941,12 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 		sc->dfs_detector->exit(sc->dfs_detector);
 
 	ath9k_eeprom_release(sc);
+
+	if (sc->rfs_chan_spec_scan) {
+		relay_close(sc->rfs_chan_spec_scan);
+		sc->rfs_chan_spec_scan = NULL;
+	}
+
 	kfree(sc->sc_ah);
 	sc->sc_ah = NULL;
 }
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 4a745e6..1ff8170 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -226,7 +226,8 @@ enum ath9k_phyerr {
 	ATH9K_PHYERR_HT_LENGTH_ILLEGAL    = 35,
 	ATH9K_PHYERR_HT_RATE_ILLEGAL      = 36,
 
-	ATH9K_PHYERR_MAX                  = 37,
+	ATH9K_PHYERR_SPECTRAL		  = 38,
+	ATH9K_PHYERR_MAX                  = 39,
 };
 
 struct ath_desc {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index be30a9a..11533ad 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1075,6 +1075,86 @@ static void ath9k_disable_ps(struct ath_softc *sc)
 	ath_dbg(common, PS, "PowerSave disabled\n");
 }
 
+void ath9k_spectral_scan_trigger(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 rxfilter;
+
+	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
+		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
+		return;
+	}
+
+	ath9k_ps_wakeup(sc);
+	rxfilter = ath9k_hw_getrxfilter(ah);
+	ath9k_hw_setrxfilter(ah, rxfilter |
+				 ATH9K_RX_FILTER_PHYRADAR |
+				 ATH9K_RX_FILTER_PHYERR);
+
+	/* TODO: usually this should not be neccesary, but for some reason
+	 * (or in some mode?) the trigger must be called after the
+	 * configuration, otherwise the register will have its values reset
+	 * (on my ar9220 to value 0x01002310)
+	 */
+	ath9k_spectral_scan_config(hw, sc->spectral_mode);
+	ath9k_hw_ops(ah)->spectral_scan_trigger(ah);
+	ath9k_ps_restore(sc);
+}
+
+int ath9k_spectral_scan_config(struct ieee80211_hw *hw,
+			       enum spectral_mode spectral_mode)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_spec_scan param;
+
+	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
+		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
+		return -1;
+	}
+
+	/* NOTE: this will generate a few samples ...
+	 *
+	 * TODO: review default parameters, and/or define an interface to set
+	 * them.
+	 */
+	param.enabled = 1;
+	param.short_repeat = true;
+	param.count = 8;
+	param.endless = false;
+	param.period = 0xFF;
+	param.fft_period = 0xF;
+
+	switch (spectral_mode) {
+	case SPECTRAL_DISABLED:
+		param.enabled = 0;
+		break;
+	case SPECTRAL_BACKGROUND:
+		/* send endless samples.
+		 * TODO: is this really useful for "background"?
+		 */
+		param.endless = 1;
+		break;
+	case SPECTRAL_CHANSCAN:
+		break;
+	case SPECTRAL_MANUAL:
+		break;
+	default:
+		return -1;
+	}
+
+	ath9k_ps_wakeup(sc);
+	ath9k_hw_ops(ah)->spectral_scan_config(ah, &param);
+	ath9k_ps_restore(sc);
+
+	sc->spectral_mode = spectral_mode;
+
+	return 0;
+}
+
 static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ath_softc *sc = hw->priv;
@@ -1188,6 +1268,11 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		 */
 		if (old_pos >= 0)
 			ath_update_survey_nf(sc, old_pos);
+
+		/* perform spectral scan if requested. */
+		if (sc->scanning && sc->spectral_mode == SPECTRAL_CHANSCAN)
+			ath9k_spectral_scan_trigger(hw);
+
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
@@ -2238,6 +2323,19 @@ static void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled)
 }
 
 #endif
+static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+
+	sc->scanning = 1;
+}
+
+static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+
+	sc->scanning = 0;
+}
 
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
@@ -2284,4 +2382,6 @@ struct ieee80211_ops ath9k_ops = {
 	.sta_add_debugfs    = ath9k_sta_add_debugfs,
 	.sta_remove_debugfs = ath9k_sta_remove_debugfs,
 #endif
+	.sw_scan_start	    = ath9k_sw_scan_start,
+	.sw_scan_complete   = ath9k_sw_scan_complete,
 };
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index d4df98a..88017f1 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/dma-mapping.h>
+#include <linux/relay.h>
 #include "ath9k.h"
 #include "ar9003_mac.h"
 
@@ -1034,6 +1035,108 @@ static void ath9k_rx_skb_postprocess(struct ath_common *common,
 		rxs->flag &= ~RX_FLAG_DECRYPTED;
 }
 
+static s8 fix_rssi_inv_only(u8 rssi_val)
+{
+	if (rssi_val == 128)
+		rssi_val = 0;
+	return (s8) rssi_val;
+}
+
+
+static void ath_process_fft(struct ath_softc *sc, struct ieee80211_hdr *hdr,
+			    struct ath_rx_status *rs, u64 tsf)
+{
+#ifdef CONFIG_ATH_DEBUG
+	struct ath_hw *ah = sc->sc_ah;
+	u8 bins[SPECTRAL_HT20_NUM_BINS];
+	u8 *vdata = (u8 *)hdr;
+	struct fft_sample_ht20 fft_sample;
+	struct ath_radar_info *radar_info;
+	struct ath_ht20_mag_info *mag_info;
+	int len = rs->rs_datalen;
+	int i, dc_pos;
+
+	/* AR9280 and before report via ATH9K_PHYERR_RADAR, AR93xx and newer
+	 * via ATH9K_PHYERR_SPECTRAL. Haven't seen ATH9K_PHYERR_FALSE_RADAR_EXT
+	 * yet, but this is supposed to be possible as well.
+	 */
+	if (rs->rs_phyerr != ATH9K_PHYERR_RADAR &&
+	    rs->rs_phyerr != ATH9K_PHYERR_FALSE_RADAR_EXT &&
+	    rs->rs_phyerr != ATH9K_PHYERR_SPECTRAL)
+		return;
+
+	/* Variation in the data length is possible and will be fixed later.
+	 * Note that we only support HT20 for now.
+	 *
+	 * TODO: add HT20_40 support as well.
+	 */
+	if ((len > SPECTRAL_HT20_TOTAL_DATA_LEN + 2) ||
+	    (len < SPECTRAL_HT20_TOTAL_DATA_LEN - 1))
+		return;
+
+	/* check if spectral scan bit is set. This does not have to be checked
+	 * if received through a SPECTRAL phy error, but shouldn't hurt.
+	 */
+	radar_info = ((struct ath_radar_info *)&vdata[len]) - 1;
+	if (!(radar_info->pulse_bw_info & SPECTRAL_SCAN_BITMASK))
+		return;
+
+	fft_sample.tlv.type = ATH_FFT_SAMPLE_HT20;
+	fft_sample.tlv.length = sizeof(fft_sample) - sizeof(fft_sample.tlv);
+
+	fft_sample.freq = ah->curchan->chan->center_freq;
+	fft_sample.rssi = fix_rssi_inv_only(rs->rs_rssi_ctl0);
+	fft_sample.noise = ah->noise;
+
+	switch (len - SPECTRAL_HT20_TOTAL_DATA_LEN) {
+	case 0:
+		/* length correct, nothing to do. */
+		memcpy(bins, vdata, SPECTRAL_HT20_NUM_BINS);
+		break;
+	case -1:
+		/* first byte missing, duplicate it. */
+		memcpy(&bins[1], vdata, SPECTRAL_HT20_NUM_BINS - 1);
+		bins[0] = vdata[0];
+		break;
+	case 2:
+		/* MAC added 2 extra bytes at bin 30 and 32, remove them. */
+		memcpy(bins, vdata, 30);
+		bins[30] = vdata[31];
+		memcpy(&bins[31], &vdata[33], SPECTRAL_HT20_NUM_BINS - 31);
+		break;
+	case 1:
+		/* MAC added 2 extra bytes AND first byte is missing. */
+		bins[0] = vdata[0];
+		memcpy(&bins[0], vdata, 30);
+		bins[31] = vdata[31];
+		memcpy(&bins[32], &vdata[33], SPECTRAL_HT20_NUM_BINS - 32);
+		break;
+	default:
+		return;
+	}
+
+	/* DC value (value in the middle) is the blind spot of the spectral
+	 * sample and invalid, interpolate it.
+	 */
+	dc_pos = SPECTRAL_HT20_NUM_BINS / 2;
+	bins[dc_pos] = (bins[dc_pos + 1] + bins[dc_pos - 1]) / 2;
+
+	/* mag data is at the end of the frame, in front of radar_info */
+	mag_info = ((struct ath_ht20_mag_info *)radar_info) - 1;
+
+	/* Apply exponent and grab further auxiliary information. */
+	for (i = 0; i < SPECTRAL_HT20_NUM_BINS; i++)
+		fft_sample.data[i] = bins[i] << mag_info->max_exp;
+
+	fft_sample.max_magnitude = spectral_max_magnitude(mag_info->all_bins);
+	fft_sample.max_index = spectral_max_index(mag_info->all_bins);
+	fft_sample.bitmap_weight = spectral_bitmap_weight(mag_info->all_bins);
+	fft_sample.tsf = tsf;
+
+	ath_debug_send_fft_sample(sc, &fft_sample.tlv);
+#endif
+}
+
 int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 {
 	struct ath_buf *bf;
@@ -1131,6 +1234,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
 			rxs->mactime += 0x100000000ULL;
 
+		if ((rs.rs_status & ATH9K_RXERR_PHY))
+			ath_process_fft(sc, hdr, &rs, rxs->mactime);
+
 		retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
 						 rxs, &decrypt_error);
 		if (retval)
-- 
1.7.10.4

