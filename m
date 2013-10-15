Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57715 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab3JOAmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 20:42:45 -0400
Received: by mail-pa0-f44.google.com with SMTP id lf10so8263113pab.17
        for <linux-wireless@vger.kernel.org>; Mon, 14 Oct 2013 17:42:44 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 6/6] ath9k: add TX99 support
Date: Mon, 14 Oct 2013 17:42:11 -0700
Message-Id: <1381797731-2454-7-git-send-email-mcgrof@do-not-panic.com> (sfid-20131015_024249_136061_EDDF1849)
In-Reply-To: <1381797731-2454-1-git-send-email-mcgrof@do-not-panic.com>
References: <1381797731-2454-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

TX99 support enables Specific Absorption Rate (SAR) testing.
SAR is the unit of measurement for the amount of radio frequency(RF)
absorbed by the body when using a wireless device. The RF
exposure limits used are expressed in the terms of SAR, which is a
measure of the electric and magnetic field strength and power density
for transmitters operating at frequencies from 300 kHz to 100 GHz.

Regulatory bodies around the world require that wireless device
be evaluated to meet the RF exposure limits set forth in the
governmental SAR regulations.

In the examples below, for more bit rate options see the iw TX bitrate
setting documentation:

http://wireless.kernel.org/en/users/Documentation/iw#Modifying_transmit_bitrates

Example usage:

iw phy phy0 interface add moni0 type monitor
ip link set dev moni0 up

iw dev moni0 set channel 36 HT40+
iw set bitrates mcs-5 4

echo 10 > /sys/kernel/debug/ieee80211/phy0/ath9k/tx99_power
echo 1  > /sys/kernel/debug/ieee80211/phy0/ath9k/tx99

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig      |  20 ++++
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |  22 ++++
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  95 +++++++++++++++++
 drivers/net/wireless/ath/ath9k/ath9k.h      |  10 ++
 drivers/net/wireless/ath/ath9k/debug.c      | 118 ++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw-ops.h     |  16 +++
 drivers/net/wireless/ath/ath9k/hw.h         |   4 +
 drivers/net/wireless/ath/ath9k/init.c       |  26 ++---
 drivers/net/wireless/ath/ath9k/link.c       |  12 ++-
 drivers/net/wireless/ath/ath9k/main.c       | 160 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/recv.c       |   3 +
 drivers/net/wireless/ath/ath9k/xmit.c       |  53 ++++++++-
 12 files changed, 522 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 7944c25..32f139e 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -84,6 +84,26 @@ config ATH9K_DFS_CERTIFIED
 	  developed. At this point enabling this option won't do anything
 	  except increase code size.
 
+config ATH9K_TX99
+	bool "Atheros ath9k TX99 testing support"
+	depends on CFG80211_CERTIFICATION_ONUS
+	default n
+	---help---
+	  Say N. This should only be enabled on systems undergoing
+	  certification testing and evaluation in a controlled environment.
+	  Enabling this will only enable TX99 support, all other modes of
+	  operation will be disabled.
+
+	  TX99 support enables Specific Absorption Rate (SAR) testing.
+	  SAR is the unit of measurement for the amount of radio frequency(RF)
+	  absorbed by the body when using a wireless device. The RF exposure
+	  limits used are expressed in the terms of SAR, which is a measure
+	  of the electric and magnetic field strength and power density for
+	  transmitters operating at frequencies from 300 kHz to 100 GHz.
+	  Regulatory bodies around the world require that wireless device
+	  be evaluated to meet the RF exposure limits set forth in the
+	  governmental SAR regulations.
+
 config ATH9K_LEGACY_RATE_CONTROL
 	bool "Atheros ath9k rate control"
 	depends on ATH9K
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 17970d4..f087117 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -680,6 +680,26 @@ static void ar9002_hw_spectral_scan_wait(struct ath_hw *ah)
 	}
 }
 
+static void ar9002_hw_tx99_start(struct ath_hw *ah, u32 qnum)
+{
+	REG_SET_BIT(ah, 0x9864, 0x7f000);
+	REG_SET_BIT(ah, 0x9924, 0x7f00fe);
+	REG_CLR_BIT(ah, AR_DIAG_SW, AR_DIAG_RX_DIS);
+	REG_WRITE(ah, AR_CR, AR_CR_RXD);
+	REG_WRITE(ah, AR_DLCL_IFS(qnum), 0);
+	REG_WRITE(ah, AR_D_GBL_IFS_SIFS, 20);
+	REG_WRITE(ah, AR_D_GBL_IFS_EIFS, 20);
+	REG_WRITE(ah, AR_D_FPCTL, 0x10|qnum);
+	REG_WRITE(ah, AR_TIME_OUT, 0x00000400);
+	REG_WRITE(ah, AR_DRETRY_LIMIT(qnum), 0xffffffff);
+	REG_SET_BIT(ah, AR_QMISC(qnum), AR_Q_MISC_DCU_EARLY_TERM_REQ);
+}
+
+static void ar9002_hw_tx99_stop(struct ath_hw *ah)
+{
+	REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_RX_DIS);
+}
+
 void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -701,6 +721,8 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	ops->set_bt_ant_diversity = ar9002_hw_set_bt_ant_diversity;
 #endif
+	ops->tx99_start = ar9002_hw_tx99_start;
+	ops->tx99_stop = ar9002_hw_tx99_stop;
 
 	ar9002_hw_set_nf_limits(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index f3adafd..11f5358 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1617,6 +1617,98 @@ static void ar9003_hw_spectral_scan_wait(struct ath_hw *ah)
 	}
 }
 
+static void ar9003_hw_tx99_start(struct ath_hw *ah, u32 qnum)
+{
+	REG_SET_BIT(ah, AR_PHY_TEST, PHY_AGC_CLR);
+	REG_SET_BIT(ah, 0x9864, 0x7f000);
+	REG_SET_BIT(ah, 0x9924, 0x7f00fe);
+	REG_CLR_BIT(ah, AR_DIAG_SW, AR_DIAG_RX_DIS);
+	REG_WRITE(ah, AR_CR, AR_CR_RXD);
+	REG_WRITE(ah, AR_DLCL_IFS(qnum), 0);
+	REG_WRITE(ah, AR_D_GBL_IFS_SIFS, 20); /* 50 OK */
+	REG_WRITE(ah, AR_D_GBL_IFS_EIFS, 20);
+	REG_WRITE(ah, AR_TIME_OUT, 0x00000400);
+	REG_WRITE(ah, AR_DRETRY_LIMIT(qnum), 0xffffffff);
+	REG_SET_BIT(ah, AR_QMISC(qnum), AR_Q_MISC_DCU_EARLY_TERM_REQ);
+}
+
+static void ar9003_hw_tx99_stop(struct ath_hw *ah)
+{
+	REG_CLR_BIT(ah, AR_PHY_TEST, PHY_AGC_CLR);
+	REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_RX_DIS);
+}
+
+static void ar9003_hw_tx99_set_txpower(struct ath_hw *ah, u8 txpower)
+{
+	static s16 p_pwr_array[ar9300RateSize] = { 0 };
+	unsigned int i;
+
+	if (txpower <= MAX_RATE_POWER) {
+		for (i = 0; i < ar9300RateSize; i++)
+			p_pwr_array[i] = txpower;
+	} else {
+		for (i = 0; i < ar9300RateSize; i++)
+			p_pwr_array[i] = MAX_RATE_POWER;
+	}
+
+	REG_WRITE(ah, 0xa458, 0);
+
+	REG_WRITE(ah, 0xa3c0,
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_6_24], 24) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_6_24], 16) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_6_24],  8) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_6_24],  0));
+	REG_WRITE(ah, 0xa3c4,
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_54],  24) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_48],  16) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_36],   8) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_6_24], 0));
+	REG_WRITE(ah, 0xa3c8,
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_1L_5L], 24) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_1L_5L], 16) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_1L_5L],  0));
+	REG_WRITE(ah, 0xa3cc,
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_11S],   24) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_11L],   16) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_5S],     8) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_LEGACY_1L_5L],  0));
+	REG_WRITE(ah, 0xa3d0,
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_5],  24) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_4],  16) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_1_3_9_11_17_19], 8)|
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_0_8_16], 0));
+	REG_WRITE(ah, 0xa3d4,
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_13], 24) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_12], 16) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_7],   8) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_6],   0));
+	REG_WRITE(ah, 0xa3e4,
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_21], 24) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_20], 16) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_15],  8) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_14],  0));
+	REG_WRITE(ah, 0xa3e8,
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_23], 24) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_22], 16) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_23],  8) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT20_22],  0));
+	REG_WRITE(ah, 0xa3d8,
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_5], 24) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_4], 16) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_1_3_9_11_17_19], 8) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_0_8_16], 0));
+	REG_WRITE(ah, 0xa3dc,
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_13], 24) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_12], 16) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_7],   8) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_6],   0));
+	REG_WRITE(ah, 0xa3ec,
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_21], 24) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_20], 16) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_15],  8) |
+		  ATH9K_POW_SM(p_pwr_array[ALL_TARGET_HT40_14],  0));
+}
+
 void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -1656,6 +1748,9 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	ops->set_bt_ant_diversity = ar9003_hw_set_bt_ant_diversity;
 #endif
+	ops->tx99_start = ar9003_hw_tx99_start;
+	ops->tx99_stop = ar9003_hw_tx99_stop;
+	ops->tx99_set_txpower = ar9003_hw_tx99_set_txpower;
 
 	ar9003_hw_set_nf_limits(ah);
 	ar9003_hw_set_radar_conf(ah);
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5492a0c..d0a6aa1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -778,6 +778,11 @@ struct ath_softc {
 	enum spectral_mode spectral_mode;
 	struct ath_spec_scan spec_config;
 
+	struct ieee80211_vif *tx99_vif;
+	struct sk_buff *tx99_skb;
+	bool tx99_state;
+	s16 tx99_power;
+
 #ifdef CONFIG_PM_SLEEP
 	atomic_t wow_got_bmiss_intr;
 	atomic_t wow_sleep_proc_intr; /* in the middle of WoW sleep ? */
@@ -912,6 +917,11 @@ struct fft_sample_ht20 {
 	u8 data[SPECTRAL_HT20_NUM_BINS];
 } __packed;
 
+int ath9k_tx99_init(struct ath_softc *sc);
+void ath9k_tx99_deinit(struct ath_softc *sc);
+int ath9k_tx99_send(struct ath_softc *sc, struct sk_buff *skb,
+		    struct ath_tx_control *txctl);
+
 void ath9k_tasklet(unsigned long data);
 int ath_cabq_update(struct ath_softc *);
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 1be2c78..83a2c59 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1050,6 +1050,9 @@ static ssize_t write_file_spec_scan_ctl(struct file *file,
 	char buf[32];
 	ssize_t len;
 
+	if (config_enabled(CONFIG_ATH9K_TX99))
+		return -EOPNOTSUPP;
+
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
@@ -1775,6 +1778,111 @@ void ath9k_deinit_debug(struct ath_softc *sc)
 	}
 }
 
+static ssize_t read_file_tx99(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[3];
+	unsigned int len;
+
+	len = sprintf(buf, "%d\n", sc->tx99_state);
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_tx99(struct file *file, const char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	char buf[32];
+	bool start;
+	ssize_t len;
+	int r;
+
+	if (sc->nvifs > 1)
+		return -EOPNOTSUPP;
+
+	len = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, len))
+		return -EFAULT;
+
+	if (strtobool(buf, &start))
+		return -EINVAL;
+
+	if (start == sc->tx99_state) {
+		if (!start)
+			return count;
+		ath_dbg(common, XMIT, "Resetting TX99\n");
+		ath9k_tx99_deinit(sc);
+	}
+
+	if (!start) {
+		ath9k_tx99_deinit(sc);
+		return count;
+	}
+
+	r = ath9k_tx99_init(sc);
+	if (r)
+		return r;
+
+	return count;
+}
+
+static const struct file_operations fops_tx99 = {
+	.read = read_file_tx99,
+	.write = write_file_tx99,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
+static ssize_t read_file_tx99_power(struct file *file,
+				    char __user *user_buf,
+				    size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	char buf[32];
+	unsigned int len;
+
+	len = sprintf(buf, "%d (%d dBm)\n",
+		      sc->tx99_power,
+		      sc->tx99_power / 2);
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
+}
+
+static ssize_t write_file_tx99_power(struct file *file,
+				     const char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath_softc *sc = file->private_data;
+	int r;
+	u8 tx_power;
+
+	r = kstrtou8_from_user(user_buf, count, 0, &tx_power);
+	if (r)
+		return r;
+
+	if (tx_power > MAX_RATE_POWER)
+		return -EINVAL;
+
+	sc->tx99_power = tx_power;
+
+	ath9k_ps_wakeup(sc);
+	ath9k_hw_tx99_set_txpower(sc->sc_ah, sc->tx99_power);
+	ath9k_ps_restore(sc);
+
+	return count;
+}
+
+static const struct file_operations fops_tx99_power = {
+	.read = read_file_tx99_power,
+	.write = write_file_tx99_power,
+	.open = simple_open,
+	.owner = THIS_MODULE,
+	.llseek = default_llseek,
+};
+
 int ath9k_init_debug(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -1866,5 +1974,15 @@ int ath9k_init_debug(struct ath_hw *ah)
 	debugfs_create_file("btcoex", S_IRUSR, sc->debug.debugfs_phy, sc,
 			    &fops_btcoex);
 #endif
+	if (config_enabled(CONFIG_ATH9K_TX99) &&
+	    AR_SREV_9300_20_OR_LATER(ah)) {
+		debugfs_create_file("tx99", S_IRUSR | S_IWUSR,
+				    sc->debug.debugfs_phy, sc,
+				    &fops_tx99);
+		debugfs_create_file("tx99_power", S_IRUSR | S_IWUSR,
+				    sc->debug.debugfs_phy, sc,
+				    &fops_tx99_power);
+	}
+
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 83f4927..4f9378d 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -78,6 +78,22 @@ static inline void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 	ath9k_hw_ops(ah)->antdiv_comb_conf_set(ah, antconf);
 }
 
+static inline void ath9k_hw_tx99_start(struct ath_hw *ah, u32 qnum)
+{
+	ath9k_hw_ops(ah)->tx99_start(ah, qnum);
+}
+
+static inline void ath9k_hw_tx99_stop(struct ath_hw *ah)
+{
+	ath9k_hw_ops(ah)->tx99_stop(ah);
+}
+
+static inline void ath9k_hw_tx99_set_txpower(struct ath_hw *ah, u8 power)
+{
+	if (ath9k_hw_ops(ah)->tx99_set_txpower)
+		ath9k_hw_ops(ah)->tx99_set_txpower(ah, power);
+}
+
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 
 static inline void ath9k_hw_set_bt_ant_diversity(struct ath_hw *ah, bool enable)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 81fcbc7..9ea24f1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -703,6 +703,10 @@ struct ath_hw_ops {
 	void (*spectral_scan_trigger)(struct ath_hw *ah);
 	void (*spectral_scan_wait)(struct ath_hw *ah);
 
+	void (*tx99_start)(struct ath_hw *ah, u32 qnum);
+	void (*tx99_stop)(struct ath_hw *ah);
+	void (*tx99_set_txpower)(struct ath_hw *ah, u8 power);
+
 #ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
 	void (*set_bt_ant_diversity)(struct ath_hw *hw, bool enable);
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 7df728f..1bd6db2 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -681,6 +681,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	pCap = &ah->caps;
 
 	sc->dfs_detector = dfs_pattern_detector_init(ah, NL80211_DFS_UNSET);
+	sc->tx99_power = MAX_RATE_POWER + 1;
 
 	if (!pdata) {
 		ah->ah_flags |= AH_USE_EEPROM;
@@ -785,6 +786,7 @@ err_queues:
 	ath9k_hw_deinit(ah);
 err_hw:
 	ath9k_eeprom_release(sc);
+	dev_kfree_skb_any(sc->tx99_skb);
 	return ret;
 }
 
@@ -842,7 +844,6 @@ static const struct ieee80211_iface_limit if_limits[] = {
 				 BIT(NL80211_IFTYPE_P2P_GO) },
 };
 
-
 static const struct ieee80211_iface_limit if_dfs_limits[] = {
 	{ .max = 1,	.types = BIT(NL80211_IFTYPE_AP) },
 };
@@ -903,17 +904,18 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
 
-	hw->wiphy->interface_modes =
-		BIT(NL80211_IFTYPE_P2P_GO) |
-		BIT(NL80211_IFTYPE_P2P_CLIENT) |
-		BIT(NL80211_IFTYPE_AP) |
-		BIT(NL80211_IFTYPE_WDS) |
-		BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_ADHOC) |
-		BIT(NL80211_IFTYPE_MESH_POINT);
-
-	hw->wiphy->iface_combinations = if_comb;
-	hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
+	if (!config_enabled(CONFIG_ATH9K_TX99)) {
+		hw->wiphy->interface_modes =
+			BIT(NL80211_IFTYPE_P2P_GO) |
+			BIT(NL80211_IFTYPE_P2P_CLIENT) |
+			BIT(NL80211_IFTYPE_AP) |
+			BIT(NL80211_IFTYPE_WDS) |
+			BIT(NL80211_IFTYPE_STATION) |
+			BIT(NL80211_IFTYPE_ADHOC) |
+			BIT(NL80211_IFTYPE_MESH_POINT);
+		hw->wiphy->iface_combinations = if_comb;
+		hw->wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
+	}
 
 	hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 84a6064..743ebb4 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -28,6 +28,13 @@ void ath_tx_complete_poll_work(struct work_struct *work)
 	int i;
 	bool needreset = false;
 
+
+	if (sc->tx99_state) {
+		ath_dbg(ath9k_hw_common(sc->sc_ah), RESET,
+			"skip tx hung detection on tx99\n");
+		return;
+	}
+
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		txq = sc->tx.txq_map[i];
 
@@ -70,7 +77,7 @@ void ath_hw_check(struct work_struct *work)
 	ath9k_ps_wakeup(sc);
 	is_alive = ath9k_hw_check_alive(sc->sc_ah);
 
-	if (is_alive && !AR_SREV_9300(sc->sc_ah))
+	if ((is_alive && !AR_SREV_9300(sc->sc_ah)) || sc->tx99_state)
 		goto out;
 	else if (!is_alive && AR_SREV_9300(sc->sc_ah)) {
 		ath_dbg(common, RESET,
@@ -141,6 +148,9 @@ void ath_hw_pll_work(struct work_struct *work)
 	if (!test_bit(SC_OP_BEACONS, &sc->sc_flags))
 		return;
 
+	if (sc->tx99_state)
+		return;
+
 	ath9k_ps_wakeup(sc);
 	pll_sqsum = ar9003_get_pll_sqsum_dvc(sc->sc_ah);
 	ath9k_ps_restore(sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 20a2fbc..74f452c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1046,6 +1046,14 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 
+	if (config_enabled(CONFIG_ATH9K_TX99)) {
+		if (sc->nvifs >= 1) {
+			mutex_unlock(&sc->mutex);
+			return -EOPNOTSUPP;
+		}
+		sc->tx99_vif = vif;
+	}
+
 	ath_dbg(common, CONFIG, "Attach a VIF of type: %d\n", vif->type);
 	sc->nvifs++;
 
@@ -1074,9 +1082,15 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
-	ath_dbg(common, CONFIG, "Change Interface\n");
 	mutex_lock(&sc->mutex);
 
+	if (config_enabled(CONFIG_ATH9K_TX99)) {
+		mutex_unlock(&sc->mutex);
+		return -EOPNOTSUPP;
+	}
+
+	ath_dbg(common, CONFIG, "Change Interface\n");
+
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_remove_slot(sc, vif);
 
@@ -1106,6 +1120,7 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 	mutex_lock(&sc->mutex);
 
 	sc->nvifs--;
+	sc->tx99_vif = NULL;
 
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_remove_slot(sc, vif);
@@ -1127,6 +1142,9 @@ static void ath9k_enable_ps(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 
+	if (config_enabled(CONFIG_ATH9K_TX99))
+		return;
+
 	sc->ps_enabled = true;
 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
 		if ((ah->imask & ATH9K_INT_TIM_TIMER) == 0) {
@@ -1143,6 +1161,9 @@ static void ath9k_disable_ps(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 
+	if (config_enabled(CONFIG_ATH9K_TX99))
+		return;
+
 	sc->ps_enabled = false;
 	ath9k_hw_setpower(ah, ATH9K_PM_AWAKE);
 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP)) {
@@ -1166,6 +1187,9 @@ void ath9k_spectral_scan_trigger(struct ieee80211_hw *hw)
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 rxfilter;
 
+	if (config_enabled(CONFIG_ATH9K_TX99))
+		return;
+
 	if (!ath9k_hw_ops(ah)->spectral_scan_trigger) {
 		ath_err(common, "spectrum analyzer not implemented on this hardware\n");
 		return;
@@ -1745,6 +1769,9 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 	unsigned long flags;
 	int pos;
 
+	if (config_enabled(CONFIG_ATH9K_TX99))
+		return -EOPNOTSUPP;
+
 	spin_lock_irqsave(&common->cc_lock, flags);
 	if (idx == 0)
 		ath_update_survey_stats(sc);
@@ -1777,6 +1804,9 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 
+	if (config_enabled(CONFIG_ATH9K_TX99))
+		return;
+
 	mutex_lock(&sc->mutex);
 	ah->coverage_class = coverage_class;
 
@@ -2343,6 +2373,134 @@ static void ath9k_channel_switch_beacon(struct ieee80211_hw *hw,
 	sc->csa_vif = vif;
 }
 
+static void ath9k_tx99_stop(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	ath_drain_all_txq(sc);
+	ath_startrecv(sc);
+
+	ath9k_hw_set_interrupts(ah);
+	ath9k_hw_enable_interrupts(ah);
+
+	ieee80211_wake_queues(sc->hw);
+
+	kfree_skb(sc->tx99_skb);
+	sc->tx99_skb = NULL;
+	sc->tx99_state = false;
+
+	ath9k_hw_tx99_stop(sc->sc_ah);
+	ath_dbg(common, XMIT, "TX99 stopped\n");
+}
+
+static struct sk_buff *ath9k_build_tx99_skb(struct ath_softc *sc)
+{
+	static u8 PN9Data[] = {0xff, 0x87, 0xb8, 0x59, 0xb7, 0xa1, 0xcc, 0x24,
+			       0x57, 0x5e, 0x4b, 0x9c, 0x0e, 0xe9, 0xea, 0x50,
+			       0x2a, 0xbe, 0xb4, 0x1b, 0xb6, 0xb0, 0x5d, 0xf1,
+			       0xe6, 0x9a, 0xe3, 0x45, 0xfd, 0x2c, 0x53, 0x18,
+			       0x0c, 0xca, 0xc9, 0xfb, 0x49, 0x37, 0xe5, 0xa8,
+			       0x51, 0x3b, 0x2f, 0x61, 0xaa, 0x72, 0x18, 0x84,
+			       0x02, 0x23, 0x23, 0xab, 0x63, 0x89, 0x51, 0xb3,
+			       0xe7, 0x8b, 0x72, 0x90, 0x4c, 0xe8, 0xfb, 0xc0};
+	u32 len = 1200;
+	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_hdr *hdr;
+	struct ieee80211_tx_info *tx_info;
+	struct sk_buff *skb;
+
+	skb = alloc_skb(len, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	skb_put(skb, len);
+
+	memset(skb->data, 0, len);
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA);
+	hdr->duration_id = 0;
+
+	memcpy(hdr->addr1, hw->wiphy->perm_addr, ETH_ALEN);
+	memcpy(hdr->addr2, hw->wiphy->perm_addr, ETH_ALEN);
+	memcpy(hdr->addr3, hw->wiphy->perm_addr, ETH_ALEN);
+
+	hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
+
+	tx_info = IEEE80211_SKB_CB(skb);
+	memset(tx_info, 0, sizeof(*tx_info));
+	tx_info->band = hw->conf.chandef.chan->band;
+	tx_info->flags = IEEE80211_TX_CTL_NO_ACK;
+	tx_info->control.vif = sc->tx99_vif;
+
+	memcpy(skb->data + sizeof(*hdr), PN9Data, sizeof(PN9Data));
+
+	return skb;
+}
+
+void ath9k_tx99_deinit(struct ath_softc *sc)
+{
+	ath_reset(sc);
+
+	ath9k_ps_wakeup(sc);
+	ath9k_tx99_stop(sc);
+	ath9k_ps_restore(sc);
+}
+
+int ath9k_tx99_init(struct ath_softc *sc)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_tx_control txctl;
+	int r;
+
+	if (sc->sc_flags & SC_OP_INVALID) {
+		ath_err(common,
+			"driver is in invalid state unable to use TX99");
+		return -EINVAL;
+	}
+
+	sc->tx99_skb = ath9k_build_tx99_skb(sc);
+	if (!sc->tx99_skb)
+		return -ENOMEM;
+
+	memset(&txctl, 0, sizeof(txctl));
+	txctl.txq = sc->tx.txq_map[IEEE80211_AC_VO];
+
+	ath_reset(sc);
+
+	ath9k_ps_wakeup(sc);
+
+	ath9k_hw_disable_interrupts(ah);
+	atomic_set(&ah->intr_ref_cnt, -1);
+	ath_drain_all_txq(sc);
+	ath_stoprecv(sc);
+
+	sc->tx99_state = true;
+
+	ieee80211_stop_queues(hw);
+
+	if (sc->tx99_power == MAX_RATE_POWER + 1)
+		sc->tx99_power = MAX_RATE_POWER;
+
+	ath9k_hw_tx99_set_txpower(ah, sc->tx99_power);
+	r = ath9k_tx99_send(sc, sc->tx99_skb, &txctl);
+	if (r) {
+		ath_dbg(common, XMIT, "Failed to xmit TX99 skb\n");
+		return r;
+	}
+
+	ath_dbg(common, XMIT, "TX99 xmit started using %d ( %ddBm)\n",
+		sc->tx99_power,
+		sc->tx99_power / 2);
+
+	/* We leave the harware awake as it will be chugging on */
+
+	return 0;
+}
+
 struct ieee80211_ops ath9k_ops = {
 	.tx 		    = ath9k_tx,
 	.start 		    = ath9k_start,
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 8b788ef..0e84bc1 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -375,6 +375,9 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 {
 	u32 rfilt;
 
+	if (config_enabled(CONFIG_ATH9K_TX99))
+		return 0;
+
 	rfilt = ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
 		| ATH9K_RX_FILTER_MCAST;
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b9b0819..09cdbcd 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1241,12 +1241,13 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 		if (bf->bf_next)
 			info.link = bf->bf_next->bf_daddr;
 		else
-			info.link = 0;
+			info.link = (sc->tx99_state) ? bf->bf_daddr : 0;
 
 		if (!bf_first) {
 			bf_first = bf;
 
-			info.flags = ATH9K_TXDESC_INTREQ;
+			if (!sc->tx99_state)
+				info.flags = ATH9K_TXDESC_INTREQ;
 			if ((tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT) ||
 			    txq == sc->tx.uapsdq)
 				info.flags |= ATH9K_TXDESC_CLRDMASK;
@@ -1941,7 +1942,7 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 			txq->axq_qnum, ito64(bf->bf_daddr), bf->bf_desc);
 	}
 
-	if (!edma) {
+	if (!edma || sc->tx99_state) {
 		TX_STAT_INC(txq->axq_qnum, txstart);
 		ath9k_hw_txstart(ah, txq->axq_qnum);
 	}
@@ -2374,6 +2375,8 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 
 	dma_unmap_single(sc->dev, bf->bf_buf_addr, skb->len, DMA_TO_DEVICE);
 	bf->bf_buf_addr = 0;
+	if (sc->tx99_state)
+		goto skip_tx_complete;
 
 	if (bf->bf_state.bfs_paprd) {
 		if (time_after(jiffies,
@@ -2386,6 +2389,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 		ath_debug_stat_tx(sc, bf, ts, txq, tx_flags);
 		ath_tx_complete(sc, skb, tx_flags, txq);
 	}
+skip_tx_complete:
 	/* At this point, skb (bf->bf_mpdu) is consumed...make sure we don't
 	 * accidentally reference it later.
 	 */
@@ -2744,3 +2748,46 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 		ath_txq_unlock(sc, txq);
 	}
 }
+
+int ath9k_tx99_send(struct ath_softc *sc, struct sk_buff *skb,
+		    struct ath_tx_control *txctl)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ath_frame_info *fi = get_frame_info(skb);
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_buf *bf;
+	int padpos, padsize;
+
+	padpos = ieee80211_hdrlen(hdr->frame_control);
+	padsize = padpos & 3;
+
+	if (padsize && skb->len > padpos) {
+		if (skb_headroom(skb) < padsize) {
+			ath_dbg(common, XMIT,
+				"tx99 padding failed\n");
+		return -EINVAL;
+		}
+
+		skb_push(skb, padsize);
+		memmove(skb->data, skb->data + padsize, padpos);
+	}
+
+	fi->keyix = ATH9K_TXKEYIX_INVALID;
+	fi->framelen = skb->len + FCS_LEN;
+	fi->keytype = ATH9K_KEY_TYPE_CLEAR;
+
+	bf = ath_tx_setup_buffer(sc, txctl->txq, NULL, skb);
+	if (!bf) {
+		ath_dbg(common, XMIT, "tx99 buffer setup failed\n");
+		return -EINVAL;
+	}
+
+	ath_set_rates(sc->tx99_vif, NULL, bf);
+
+	ath9k_hw_set_desc_link(sc->sc_ah, bf->bf_desc, bf->bf_daddr);
+	ath9k_hw_tx99_start(sc->sc_ah, txctl->txq->axq_qnum);
+
+	ath_tx_send_normal(sc, txctl->txq, NULL, skb);
+
+	return 0;
+}
-- 
1.8.4.rc3

