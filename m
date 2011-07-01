Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:33831 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab1GAWAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 18:00:34 -0400
Received: by fxd18 with SMTP id 18so3620321fxd.11
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2011 15:00:33 -0700 (PDT)
Received: from localhost
	([127.0.0.1] helo=debian64.localnet ident=chuck)
	by debian64.daheim with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <chunkeey@googlemail.com>)
	id 1Qclmm-0005uG-75
	for linux-wireless@vger.kernel.org; Sat, 02 Jul 2011 00:02:04 +0200
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFT v2] carl9170: improve site survey
Date: Sat, 2 Jul 2011 00:02:00 +0200
References: <201107011519.59350.chunkeey@googlemail.com>
In-Reply-To: <201107011519.59350.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201107020002.00752.chunkeey@googlemail.com> (sfid-20110702_000038_643449_D8236B07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware keeps track of channel usage. This data can
be used by the automatic channel selection to find the best
channel.

Survey data from wlan22
	frequency:                      2412 MHz [in use]
	noise:                          -86 dBm
	channel active time:            3339608 ms
	channel busy time:              270982 ms
	channel transmit time:          121515 ms
Survey data from wlan22
	frequency:                      2417 MHz
	noise:                          -86 dBm
	channel active time:            70 ms
	channel busy time:              2 ms
	channel transmit time:          1 ms
...
---
diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 20bed04..989fb59 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -152,6 +152,7 @@ struct carl9170_sta_tid {
 #define CARL9170_TX_TIMEOUT		2500
 #define CARL9170_JANITOR_DELAY		128
 #define CARL9170_QUEUE_STUCK_TIMEOUT	5500
+#define CARL9170_STAT_WORK		30000
 
 #define CARL9170_NUM_TX_AGG_MAX		30
 
@@ -283,6 +284,7 @@ struct ar9170 {
 		bool rx_stream;
 		bool tx_stream;
 		bool rx_filter;
+		bool hw_counters;
 		unsigned int mem_blocks;
 		unsigned int mem_block_size;
 		unsigned int rx_size;
@@ -332,11 +334,21 @@ struct ar9170 {
 
 	/* PHY */
 	struct ieee80211_channel *channel;
+	unsigned int num_channels;
 	int noise[4];
 	unsigned int chan_fail;
 	unsigned int total_chan_fail;
 	u8 heavy_clip;
 	u8 ht_settings;
+	struct {
+		u64 active;	/* usec */
+		u64 cca;	/* usec */
+		u64 tx_time;	/* usec */
+		u64 rx_total;
+		u64 rx_overrun;
+	} tally;
+	struct delayed_work stat_work;
+	struct survey_info *survey;
 
 	/* power calibration data */
 	u8 power_5G_leg[4];
diff --git a/drivers/net/wireless/ath/carl9170/cmd.c b/drivers/net/wireless/ath/carl9170/cmd.c
index cdfc94c..9970bf8 100644
--- a/drivers/net/wireless/ath/carl9170/cmd.c
+++ b/drivers/net/wireless/ath/carl9170/cmd.c
@@ -165,6 +165,37 @@ int carl9170_bcn_ctrl(struct ar9170 *ar, const unsigned int vif_id,
 	return __carl9170_exec_cmd(ar, cmd, true);
 }
 
+int carl9170_collect_tally(struct ar9170 *ar)
+{
+	struct carl9170_tally_rsp tally;
+	struct survey_info *info;
+	unsigned int tick;
+	int err;
+
+	err = carl9170_exec_cmd(ar, CARL9170_CMD_TALLY, 0, NULL,
+				sizeof(tally), (u8 *)&tally);
+	if (err)
+		return err;
+
+	tick = le32_to_cpu(tally.tick);
+	if (tick) {
+		ar->tally.active += le32_to_cpu(tally.active) / tick;
+		ar->tally.cca += le32_to_cpu(tally.cca) / tick;
+		ar->tally.tx_time += le32_to_cpu(tally.tx_time) / tick;
+		ar->tally.rx_total += le32_to_cpu(tally.rx_total);
+		ar->tally.rx_overrun += le32_to_cpu(tally.rx_overrun);
+
+		if (ar->channel) {
+			info = &ar->survey[ar->channel->hw_value];
+
+			info->channel_time = ar->tally.active / 1000;
+			info->channel_time_busy = ar->tally.cca / 1000;
+			info->channel_time_tx = ar->tally.tx_time / 1000;
+		}
+	}
+	return 0;
+}
+
 int carl9170_powersave(struct ar9170 *ar, const bool ps)
 {
 	struct carl9170_cmd *cmd;
diff --git a/drivers/net/wireless/ath/carl9170/cmd.h b/drivers/net/wireless/ath/carl9170/cmd.h
index 568174c..d0e9ff5 100644
--- a/drivers/net/wireless/ath/carl9170/cmd.h
+++ b/drivers/net/wireless/ath/carl9170/cmd.h
@@ -50,6 +50,7 @@ int carl9170_echo_test(struct ar9170 *ar, u32 v);
 int carl9170_reboot(struct ar9170 *ar);
 int carl9170_mac_reset(struct ar9170 *ar);
 int carl9170_powersave(struct ar9170 *ar, const bool power_on);
+int carl9170_collect_tally(struct ar9170 *ar);
 int carl9170_bcn_ctrl(struct ar9170 *ar, const unsigned int vif_id,
 		       const u32 mode, const u32 addr, const u32 len);
 
diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index 39ddea5..f4cae1c 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -266,6 +266,9 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 			FIF_PROMISC_IN_BSS;
 	}
 
+	if (SUPP(CARL9170FW_HW_COUNTERS))
+		ar->fw.hw_counters = true;
+
 	if (SUPP(CARL9170FW_WOL))
 		device_set_wakeup_enable(&ar->udev->dev, true);
 
diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
index 8fea629..2bf2d74 100644
--- a/drivers/net/wireless/ath/carl9170/fwcmd.h
+++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
@@ -55,6 +55,7 @@ enum carl9170_cmd_oids {
 	CARL9170_CMD_READ_TSF		= 0x06,
 	CARL9170_CMD_RX_FILTER		= 0x07,
 	CARL9170_CMD_WOL		= 0x08,
+	CARL9170_CMD_TALLY		= 0x09,
 
 	/* CAM */
 	CARL9170_CMD_EKEY		= 0x10,
@@ -286,6 +287,15 @@ struct carl9170_tsf_rsp {
 } __packed;
 #define CARL9170_TSF_RSP_SIZE		8
 
+struct carl9170_tally_rsp {
+	__le32 active;
+	__le32 cca;
+	__le32 tx_time;
+	__le32 rx_total;
+	__le32 rx_overrun;
+	__le32 tick;
+} __packed;
+
 struct carl9170_rsp {
 	struct carl9170_cmd_head hdr;
 
@@ -300,6 +310,7 @@ struct carl9170_rsp {
 		struct carl9170_gpio		gpio;
 		struct carl9170_tsf_rsp		tsf;
 		struct carl9170_psm		psm;
+		struct carl9170_tally_rsp	tally;
 		u8 data[CARL9170_MAX_CMD_PAYLOAD_LEN];
 	} __packed;
 } __packed __aligned(4);
diff --git a/drivers/net/wireless/ath/carl9170/fwdesc.h b/drivers/net/wireless/ath/carl9170/fwdesc.h
index 7ba62bb..6d9c089 100644
--- a/drivers/net/wireless/ath/carl9170/fwdesc.h
+++ b/drivers/net/wireless/ath/carl9170/fwdesc.h
@@ -75,6 +75,9 @@ enum carl9170fw_feature_list {
 	/* Firmware supports PSM in the 5GHZ Band */
 	CARL9170FW_FIXED_5GHZ_PSM,
 
+	/* HW (ANI, CCA, MIB) tally counters */
+	CARL9170FW_HW_COUNTERS,
+
 	/* KEEP LAST */
 	__CARL9170FW_FEATURE_NUM
 };
diff --git a/drivers/net/wireless/ath/carl9170/hw.h b/drivers/net/wireless/ath/carl9170/hw.h
index 261f893..5ac7381 100644
--- a/drivers/net/wireless/ath/carl9170/hw.h
+++ b/drivers/net/wireless/ath/carl9170/hw.h
@@ -222,6 +222,12 @@
 #define AR9170_MAC_REG_TX_BLOCKACKS		(AR9170_MAC_REG_BASE + 0x6c0)
 #define AR9170_MAC_REG_NAV_COUNT		(AR9170_MAC_REG_BASE + 0x6c4)
 #define AR9170_MAC_REG_BACKOFF_STATUS		(AR9170_MAC_REG_BASE + 0x6c8)
+#define		AR9170_MAC_BACKOFF_CCA			BIT(24)
+#define		AR9170_MAC_BACKOFF_TX_PEX		BIT(25)
+#define		AR9170_MAC_BACKOFF_RX_PE		BIT(26)
+#define		AR9170_MAC_BACKOFF_MD_READY		BIT(27)
+#define		AR9170_MAC_BACKOFF_TX_PE		BIT(28)
+
 #define	AR9170_MAC_REG_TX_RETRY			(AR9170_MAC_REG_BASE + 0x6cc)
 
 #define AR9170_MAC_REG_TX_COMPLETE		(AR9170_MAC_REG_BASE + 0x6d4)
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 91b3fd3..ec1d13a 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -413,6 +413,9 @@ static int carl9170_op_start(struct ieee80211_hw *hw)
 
 	carl9170_set_state_when(ar, CARL9170_IDLE, CARL9170_STARTED);
 
+	ieee80211_queue_delayed_work(ar->hw, &ar->stat_work,
+		round_jiffies(msecs_to_jiffies(CARL9170_STAT_WORK)));
+
 	ieee80211_wake_queues(ar->hw);
 	err = 0;
 
@@ -423,6 +426,7 @@ out:
 
 static void carl9170_cancel_worker(struct ar9170 *ar)
 {
+	cancel_delayed_work_sync(&ar->stat_work);
 	cancel_delayed_work_sync(&ar->tx_janitor);
 #ifdef CONFIG_CARL9170_LEDS
 	cancel_delayed_work_sync(&ar->led_work);
@@ -794,6 +798,43 @@ static void carl9170_ps_work(struct work_struct *work)
 	mutex_unlock(&ar->mutex);
 }
 
+static int carl9170_update_survey(struct ar9170 *ar, bool flush, bool noise)
+{
+	int err;
+
+	if (noise) {
+		err = carl9170_get_noisefloor(ar);
+		if (err)
+			return err;
+	}
+
+	if (ar->fw.hw_counters) {
+		err = carl9170_collect_tally(ar);
+		if (err)
+			return err;
+	}
+
+	if (flush)
+		memset(&ar->tally, 0, sizeof(ar->tally));
+
+	return 0;
+}
+
+static void carl9170_stat_work(struct work_struct *work)
+{
+	struct ar9170 *ar = container_of(work, struct ar9170, stat_work.work);
+	int err;
+
+	mutex_lock(&ar->mutex);
+	err = carl9170_update_survey(ar, false, true);
+	mutex_unlock(&ar->mutex);
+
+	if (err)
+		return;
+
+	ieee80211_queue_delayed_work(ar->hw, &ar->stat_work,
+		round_jiffies(msecs_to_jiffies(CARL9170_STAT_WORK)));
+}
 
 static int carl9170_op_config(struct ieee80211_hw *hw, u32 changed)
 {
@@ -828,11 +869,19 @@ static int carl9170_op_config(struct ieee80211_hw *hw, u32 changed)
 		if (err)
 			goto out;
 
+		err = carl9170_update_survey(ar, true, false);
+		if (err)
+			goto out;
+
 		err = carl9170_set_channel(ar, hw->conf.channel,
 			hw->conf.channel_type, CARL9170_RFI_NONE);
 		if (err)
 			goto out;
 
+		err = carl9170_update_survey(ar, false, true);
+		if (err)
+			goto out;
+
 		err = carl9170_set_dyn_sifs_ack(ar);
 		if (err)
 			goto out;
@@ -1527,20 +1576,48 @@ static int carl9170_op_get_survey(struct ieee80211_hw *hw, int idx,
 				struct survey_info *survey)
 {
 	struct ar9170 *ar = hw->priv;
-	int err;
+	struct ieee80211_channel *chan;
+	struct ieee80211_supported_band *band;
+	int err, b, i;
 
-	if (idx != 0)
-		return -ENOENT;
+	if (idx == 0) {
+		mutex_lock(&ar->mutex);
+		err = carl9170_update_survey(ar, false, true);
+		mutex_unlock(&ar->mutex);
+		if (err)
+			return err;
+	}
 
-	mutex_lock(&ar->mutex);
-	err = carl9170_get_noisefloor(ar);
-	mutex_unlock(&ar->mutex);
-	if (err)
-		return err;
+	for (b = 0; b < IEEE80211_NUM_BANDS; b++) {
+		band = ar->hw->wiphy->bands[b];
+
+		if (!band)
+			continue;
 
-	survey->channel = ar->channel;
+		for (i = 0; i < band->n_channels; i++) {
+			if (band->channels[i].hw_value == idx) {
+				chan = &band->channels[i];
+				goto found;
+			}
+		}
+	}
+	return -ENOENT;
+
+found:
+	memcpy(survey, &ar->survey[idx], sizeof(*survey));
+
+	survey->channel = chan;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
-	survey->noise = ar->noise[0];
+
+	if (ar->channel == chan)
+		survey->filled |= SURVEY_INFO_IN_USE;
+
+	if (ar->fw.hw_counters) {
+		survey->filled |= SURVEY_INFO_CHANNEL_TIME |
+				  SURVEY_INFO_CHANNEL_TIME_BUSY |
+				  SURVEY_INFO_CHANNEL_TIME_TX;
+	}
+
 	return 0;
 }
 
@@ -1665,6 +1742,7 @@ void *carl9170_alloc(size_t priv_size)
 	INIT_WORK(&ar->ping_work, carl9170_ping_work);
 	INIT_WORK(&ar->restart_work, carl9170_restart_work);
 	INIT_WORK(&ar->ampdu_work, carl9170_ampdu_work);
+	INIT_DELAYED_WORK(&ar->stat_work, carl9170_stat_work);
 	INIT_DELAYED_WORK(&ar->tx_janitor, carl9170_tx_janitor);
 	INIT_LIST_HEAD(&ar->tx_ampdu_list);
 	rcu_assign_pointer(ar->tx_ampdu_iter,
@@ -1748,6 +1826,7 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
 	struct ath_regulatory *regulatory = &ar->common.regulatory;
 	unsigned int rx_streams, tx_streams, tx_params = 0;
 	int bands = 0;
+	int chans = 0;
 
 	if (ar->eeprom.length == cpu_to_le16(0xffff))
 		return -ENODATA;
@@ -1771,14 +1850,24 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
 	if (ar->eeprom.operating_flags & AR9170_OPFLAG_2GHZ) {
 		ar->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 			&carl9170_band_2GHz;
+		chans += carl9170_band_2GHz.n_channels;
 		bands++;
 	}
 	if (ar->eeprom.operating_flags & AR9170_OPFLAG_5GHZ) {
 		ar->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&carl9170_band_5GHz;
+		chans += carl9170_band_5GHz.n_channels;
 		bands++;
 	}
 
+	if (!bands)
+		return -EINVAL;
+
+	ar->survey = kzalloc(sizeof(struct survey_info) * chans, GFP_KERNEL);
+	if (!ar->survey)
+		return -ENOMEM;
+	ar->num_channels = chans;
+
 	/*
 	 * I measured this, a bandswitch takes roughly
 	 * 135 ms and a frequency switch about 80.
@@ -1797,7 +1886,7 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
 	/* second part of wiphy init */
 	SET_IEEE80211_PERM_ADDR(ar->hw, ar->eeprom.mac_address);
 
-	return bands ? 0 : -EINVAL;
+	return 0;
 }
 
 static int carl9170_reg_notifier(struct wiphy *wiphy,
@@ -1936,6 +2025,9 @@ void carl9170_free(struct ar9170 *ar)
 	kfree(ar->mem_bitmap);
 	ar->mem_bitmap = NULL;
 
+	kfree(ar->survey);
+	ar->survey = NULL;
+
 	mutex_destroy(&ar->mutex);
 
 	ieee80211_free_hw(ar->hw);
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index da1ab96..21dc2da 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1574,6 +1574,9 @@ int carl9170_get_noisefloor(struct ar9170 *ar)
 			AR9170_PHY_EXT_CCA_MIN_PWR, phy_res[i + 2]), 8);
 	}
 
+	if (ar->channel)
+		ar->survey[ar->channel->hw_value].noise = ar->noise[0];
+
 	return 0;
 }
 
@@ -1766,10 +1769,6 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 		ar->chan_fail = 0;
 	}
 
-	err = carl9170_get_noisefloor(ar);
-	if (err)
-		return err;
-
 	if (ar->heavy_clip) {
 		err = carl9170_write_reg(ar, AR9170_PHY_REG_HEAVY_CLIP_ENABLE,
 					 0x200 | ar->heavy_clip);
