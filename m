Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:36023 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab1GANSd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 09:18:33 -0400
Received: by fxd18 with SMTP id 18so3277255fxd.11
        for <linux-wireless@vger.kernel.org>; Fri, 01 Jul 2011 06:18:31 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFT] carl9170: improve site survey
Date: Fri, 1 Jul 2011 15:19:58 +0200
Cc: Stephen.Chen@atheros.com, mcgrof@gmail.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201107011519.59350.chunkeey@googlemail.com> (sfid-20110701_151837_630435_1434F66B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hardware provides main and extension channel busy
counters to monitor channel usage.

Survey data from wlan
        frequency:                      2412 MHz [in use]
        noise:                          -85 dBm
        channel active time:            1198041 ms
        channel busy time:              57835 ms
        extension channel busy time:    57213 ms
Survey data from wlan
        frequency:                      2417 MHz
        noise:                          -86 dBm
        channel active time:            0 ms
        channel busy time:              0 ms
        extension channel busy time:    0 ms
...

Stehpen, do you know if the hardware has a counter which
accumulates rx / tx air time like ath9k 0x80ec MAC_PCU_TX_FRAME_CNT?
This will be needed for Automatic Channel Selection.
---
diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 20bed04..36ed450 100644
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
@@ -332,12 +334,23 @@ struct ar9170 {
 
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
+		u64 main_busy;	/* usec */
+		u64 ext_busy;	/* usec */
+		u64 rx_total;
+		u64 rx_overrun;
+	} tally;
+	struct delayed_work stat_work;
+	struct survey_info *survey;
+
 	/* power calibration data */
 	u8 power_5G_leg[4];
 	u8 power_2G_cck[4];
diff --git a/drivers/net/wireless/ath/carl9170/cmd.c b/drivers/net/wireless/ath/carl9170/cmd.c
index cdfc94c..d1ae07a 100644
--- a/drivers/net/wireless/ath/carl9170/cmd.c
+++ b/drivers/net/wireless/ath/carl9170/cmd.c
@@ -165,6 +165,36 @@ int carl9170_bcn_ctrl(struct ar9170 *ar, const unsigned int vif_id,
 	return __carl9170_exec_cmd(ar, cmd, true);
 }
 
+int carl9170_collect_tally(struct ar9170 *ar)
+{
+	struct carl9170_tally_rsp tally;
+	struct survey_info *info;
+	unsigned int delta;
+	int err;
+
+	err = carl9170_exec_cmd(ar, CARL9170_CMD_TALLY, 0, NULL,
+				sizeof(tally), (u8 *)&tally);
+	if (err)
+		return err;
+
+	delta = le32_to_cpu(tally.active);
+	ar->tally.active += delta;
+	ar->tally.main_busy += delta - min(delta, le32_to_cpu(tally.main_free));
+	ar->tally.ext_busy += delta - min(delta, le32_to_cpu(tally.ext_free));
+	ar->tally.rx_total += le32_to_cpu(tally.rx_total);
+	ar->tally.rx_overrun += le32_to_cpu(tally.rx_overrun);
+
+	if (ar->channel) {
+		info = &ar->survey[ar->channel->hw_value];
+
+		info->channel_time = ar->tally.active / 1000;
+		info->channel_time_busy = ar->tally.main_busy / 1000;
+		info->channel_time_ext_busy = ar->tally.ext_busy / 1000;
+	}
+
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
index 8fea629..7ef5636 100644
--- a/drivers/net/wireless/ath/carl9170/fwcmd.h
+++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
@@ -55,6 +55,7 @@ enum carl9170_cmd_oids {
 	CARL9170_CMD_READ_TSF		= 0x06,
 	CARL9170_CMD_RX_FILTER		= 0x07,
 	CARL9170_CMD_WOL		= 0x08,
+	CARL9170_CMD_TALLY		= 0x09,
 
 	/* CAM */
 	CARL9170_CMD_EKEY		= 0x10,
@@ -286,6 +287,14 @@ struct carl9170_tsf_rsp {
 } __packed;
 #define CARL9170_TSF_RSP_SIZE		8
 
+struct carl9170_tally_rsp {
+	__le32 active;
+	__le32 main_free;
+	__le32 ext_free;
+	__le32 rx_total;
+	__le32 rx_overrun;
+} __packed;
+
 struct carl9170_rsp {
 	struct carl9170_cmd_head hdr;
 
@@ -300,6 +309,7 @@ struct carl9170_rsp {
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
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index fe82d1f..dadda67 100644
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
+				  SURVEY_INFO_CHANNEL_TIME_EXT_BUSY;
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
