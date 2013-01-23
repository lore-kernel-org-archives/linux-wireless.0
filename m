Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:54878 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab3AWQiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 11:38:25 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, sven@open-mesh.com,
	rodrigue@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 1/4] ath9k: add debug parameters for spectral scan
Date: Wed, 23 Jan 2013 17:38:04 +0100
Message-Id: <1358959087-24897-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130123_173830_012382_F6692193)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Export the various parameters to userspace.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/debug.c |  186 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/init.c  |    7 ++
 drivers/net/wireless/ath/ath9k/main.c  |   23 ++--
 4 files changed, 200 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b2d6c18..342edc5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -754,6 +754,7 @@ struct ath_softc {
 	/* relay(fs) channel for spectral scan */
 	struct rchan *rfs_chan_spec_scan;
 	enum spectral_mode spectral_mode;
+	struct ath_spec_scan spec_config;
 	int scanning;
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 6c5d313..012446d 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1035,6 +1035,182 @@ static const struct file_operations fops_spec_scan_ctl = {
 	.llseek = default_llseek,
 };
 
+static ssize_t read_file_spectral_short_repeat(struct file *file,
+					       char __user *user_buf,
+					       size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", sc->spec_config.short_repeat);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_spectral_short_repeat(struct file *file,
+						const char __user *user_buf,
+						size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	unsigned long val;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val < 0 || val > 1)
+		return -EINVAL;
+
+	sc->spec_config.short_repeat = val;
+	return count;
+}
+
+static const struct file_operations fops_spectral_short_repeat = {
+	.read = read_file_spectral_short_repeat,
+	.write = write_file_spectral_short_repeat,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t read_file_spectral_count(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", sc->spec_config.count);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_spectral_count(struct file *file,
+					 const char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	unsigned long val;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val < 0 || val > 255)
+		return -EINVAL;
+
+	sc->spec_config.count = val;
+	return count;
+}
+
+static const struct file_operations fops_spectral_count = {
+	.read = read_file_spectral_count,
+	.write = write_file_spectral_count,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t read_file_spectral_period(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", sc->spec_config.period);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_spectral_period(struct file *file,
+					  const char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	unsigned long val;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val < 0 || val > 255)
+		return -EINVAL;
+
+	sc->spec_config.period = val;
+	return count;
+}
+
+static const struct file_operations fops_spectral_period = {
+	.read = read_file_spectral_period,
+	.write = write_file_spectral_period,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t read_file_spectral_fft_period(struct file *file,
+					     char __user *user_buf,
+					     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", sc->spec_config.fft_period);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_spectral_fft_period(struct file *file,
+					      const char __user *user_buf,
+					      size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	unsigned long val;
+	char buf[32];
+	ssize_t len;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	buf[len] = '\0';
+	if (kstrtoul(buf, 0, &val))
+		return -EINVAL;
+
+	if (val < 0 || val > 15)
+		return -EINVAL;
+
+	sc->spec_config.fft_period = val;
+	return count;
+}
+
+static const struct file_operations fops_spectral_fft_period = {
+	.read = read_file_spectral_fft_period,
+	.write = write_file_spectral_fft_period,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 static struct dentry *create_buf_file_handler(const char *filename,
 					      struct dentry *parent,
 					      umode_t mode,
@@ -1893,6 +2069,16 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_file("spectral_scan_ctl", S_IRUSR | S_IWUSR,
 			    sc->debug.debugfs_phy, sc,
 			    &fops_spec_scan_ctl);
+	debugfs_create_file("spectral_short_repeat", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc,
+			    &fops_spectral_short_repeat);
+	debugfs_create_file("spectral_count", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_spectral_count);
+	debugfs_create_file("spectral_period", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc, &fops_spectral_period);
+	debugfs_create_file("spectral_fft_period", S_IRUSR | S_IWUSR,
+			    sc->debug.debugfs_phy, sc,
+			    &fops_spectral_fft_period);
 
 #ifdef CONFIG_ATH9K_MAC_DEBUG
 	debugfs_create_file("samples", S_IRUSR, sc->debug.debugfs_phy, sc,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 4b1abc7..c7d116c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -497,6 +497,13 @@ static void ath9k_init_misc(struct ath_softc *sc)
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB)
 		sc->ant_comb.count = ATH_ANT_DIV_COMB_INIT_COUNT;
+
+	sc->spec_config.enabled = 0;
+	sc->spec_config.short_repeat = true;
+	sc->spec_config.count = 8;
+	sc->spec_config.endless = false;
+	sc->spec_config.period = 0xFF;
+	sc->spec_config.fft_period = 0xF;
 }
 
 static void ath9k_eeprom_request_cb(const struct firmware *eeprom_blob,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4b72b66..5432f12 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1099,45 +1099,34 @@ int ath9k_spectral_scan_config(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath_spec_scan param;
 
 	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
 		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
 		return -1;
 	}
 
-	/* NOTE: this will generate a few samples ...
-	 *
-	 * TODO: review default parameters, and/or define an interface to set
-	 * them.
-	 */
-	param.enabled = 1;
-	param.short_repeat = true;
-	param.count = 8;
-	param.endless = false;
-	param.period = 0xFF;
-	param.fft_period = 0xF;
-
 	switch (spectral_mode) {
 	case SPECTRAL_DISABLED:
-		param.enabled = 0;
+		sc->spec_config.enabled = 0;
 		break;
 	case SPECTRAL_BACKGROUND:
 		/* send endless samples.
 		 * TODO: is this really useful for "background"?
 		 */
-		param.endless = 1;
+		sc->spec_config.endless = 1;
+		sc->spec_config.enabled = 1;
 		break;
 	case SPECTRAL_CHANSCAN:
-		break;
 	case SPECTRAL_MANUAL:
+		sc->spec_config.endless = 0;
+		sc->spec_config.enabled = 1;
 		break;
 	default:
 		return -1;
 	}
 
 	ath9k_ps_wakeup(sc);
-	ath9k_hw_ops(ah)->spectral_scan_config(ah, &param);
+	ath9k_hw_ops(ah)->spectral_scan_config(ah, &sc->spec_config);
 	ath9k_ps_restore(sc);
 
 	sc->spectral_mode = spectral_mode;
-- 
1.7.10.4

