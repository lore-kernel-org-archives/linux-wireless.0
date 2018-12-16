Return-Path: <SRS0=od2B=OZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C892C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Dec 2018 14:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5237A217FA
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Dec 2018 14:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730316AbeLPOG7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 16 Dec 2018 09:06:59 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:24047 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729822AbeLPOG7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Dec 2018 09:06:59 -0500
X-IronPort-AV: E=Sophos;i="5.56,361,1539640800"; 
   d="scan'208";a="1663954"
Received: from ironmsg01-ams.qualcomm.com ([10.251.56.2])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 16 Dec 2018 14:59:53 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9107"; a="6611862"
Received: from lx-amasri.mea.qualcomm.com ([10.18.172.210])
  by ironmsg01-ams.qualcomm.com with ESMTP; 16 Dec 2018 14:59:52 +0100
From:   Ahmad Masri <amasri@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: [PATCH 2/2] wil6210: add implementation of acs cfg80211_ops
Date:   Sun, 16 Dec 2018 15:58:11 +0200
Message-Id: <1544968691-20679-3-git-send-email-amasri@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1544968691-20679-1-git-send-email-amasri@codeaurora.org>
References: <1544968691-20679-1-git-send-email-amasri@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add ACS to cfg80211 operations that the device handles and performs.
wil6210 reports NL80211_EXT_FEATURE_ACS_OFFLOAD indicating a support
for acs operation through cfg80211_ops.

ACS is performed by the driver and the FW. Once ACS operation is
called the driver builds a WMI command with the requested channels
and sends the command to the FW. The FW performs ACS scan on the
channels and reports for each channel the following:
1- Number of beacon received on channel
2- channel busy time
3- transmit time
4- receive time
5- noise level
The driver uses the above information to select the best channel
to start the AP, and reports it to the host.

User may use debugfs acs_ch_weight to set a different weights
for the channels.

Change-Id: I8e13296fad0c9fa8b15788fd37c23d825d41d8e5
Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 140 ++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/debugfs.c  | 154 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/wil6210/main.c     |   5 +
 drivers/net/wireless/ath/wil6210/wil6210.h  |  15 +++
 drivers/net/wireless/ath/wil6210/wmi.c      |  76 ++++++++++++++
 drivers/net/wireless/ath/wil6210/wmi.h      |   3 +-
 6 files changed, 390 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 9b2f9f5..62abfb5 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -35,6 +35,14 @@
 };
 #endif
 
+/* in case of channels' noise values all zero, applying weights will not work.
+ * to avoid such a case, we will add some small positive value to
+ * all channels' noise calculation
+ */
+#define ACS_CH_NOISE_INIT_VAL (100)
+
+#define ACS_DEFAULT_BEST_CHANNEL 2
+
 #define CHAN60G(_channel, _flags) {				\
 	.band			= NL80211_BAND_60GHZ,		\
 	.center_freq		= 56160 + (2160 * (_channel)),	\
@@ -44,7 +52,7 @@
 	.max_power		= 40,				\
 }
 
-static struct ieee80211_channel wil_60ghz_channels[] = {
+static struct ieee80211_channel wil_60ghz_channels[WIL_MAX_CHANNELS] = {
 	CHAN60G(1, 0),
 	CHAN60G(2, 0),
 	CHAN60G(3, 0),
@@ -64,7 +72,7 @@
 	}
 }
 
-static int wil_num_supported_channels(struct wil6210_priv *wil)
+int wil_num_supported_channels(struct wil6210_priv *wil)
 {
 	int num_channels = ARRAY_SIZE(wil_60ghz_channels);
 
@@ -2358,6 +2366,132 @@ static int wil_cfg80211_resume(struct wiphy *wiphy)
 	return rc;
 }
 
+static u8 wil_acs_calc_channel(struct wil6210_priv *wil)
+{
+	int i, best_channel = ACS_DEFAULT_BEST_CHANNEL - 1;
+	struct scan_acs_info *ch;
+	u64 dwell_time = le32_to_cpu(wil->survey_reply.evt.dwell_time);
+	u16 filled = le16_to_cpu(wil->survey_reply.evt.filled);
+	u8 num_channels = wil->survey_reply.evt.num_scanned_channels;
+	u64 busy_time, tx_time;
+	u64 min_i_ch = (u64)-1, cur_i_ch;
+	u8 p_min = 0, ch_noise;
+
+	wil_dbg_misc(wil,
+		     "acs_calc_channel: filled info: 0x%04X, for %u channels\n",
+		     filled, num_channels);
+
+	if (!num_channels) {
+		wil_err(wil, "received results with no channel info\n");
+		return 0;
+	}
+
+	/* find P_min */
+	if (filled & WMI_ACS_INFO_BITMASK_NOISE) {
+		p_min = wil->survey_reply.ch_info[0].noise;
+
+		for (i = 1; i < num_channels; i++)
+			p_min = min(p_min, wil->survey_reply.ch_info[i].noise);
+	}
+
+	wil_dbg_misc(wil, "acs_calc_channel: p_min is %u\n", p_min);
+
+	/* Choosing channel according to the following formula:
+	 * 16 bit fixed point math
+	 * I_ch = { [ (T_busy - T_tx) << 16 ] /
+	 *        (T_dwell - T_tx) } * 2^(P_rx - P_min)
+	 */
+	for (i = 0; i < num_channels; i++) {
+		ch = &wil->survey_reply.ch_info[i];
+
+		busy_time = filled & WMI_ACS_INFO_BITMASK_BUSY_TIME ?
+				le16_to_cpu(ch->busy_time) : 0;
+
+		tx_time = filled & WMI_ACS_INFO_BITMASK_TX_TIME ?
+				le16_to_cpu(ch->tx_time) : 0;
+
+		ch_noise = filled & WMI_ACS_INFO_BITMASK_NOISE ? ch->noise : 0;
+
+		wil_dbg_misc(wil,
+			     "acs_calc_channel: Ch[%d]: busy %llu, tx %llu, noise %u, dwell %llu\n",
+			     ch->channel + 1, busy_time, tx_time, ch_noise,
+			     dwell_time);
+
+		if (dwell_time == tx_time) {
+			wil_err(wil,
+				"Ch[%d] dwell_time == tx_time: %llu\n",
+				ch->channel + 1, dwell_time);
+			continue;
+		}
+
+		cur_i_ch = (busy_time - tx_time) << 16;
+		do_div(cur_i_ch,
+		       ((dwell_time - tx_time) << (ch_noise - p_min)));
+
+		/* Apply channel priority */
+		cur_i_ch = (cur_i_ch + ACS_CH_NOISE_INIT_VAL) *
+			   wil->acs_ch_weight[ch->channel];
+		do_div(cur_i_ch, 100);
+
+		wil_dbg_misc(wil, "acs_calc_channel: Ch[%d] w %u, I_ch %llu\n",
+			     ch->channel + 1, wil->acs_ch_weight[ch->channel],
+			     cur_i_ch);
+
+		if (i == 0 || cur_i_ch < min_i_ch) {
+			min_i_ch = cur_i_ch;
+			best_channel = ch->channel;
+		}
+	}
+
+	wil_dbg_misc(wil,
+		     "acs_calc_channel: best channel %d with I_ch of %llu\n",
+		     best_channel + 1, min_i_ch);
+
+	return best_channel;
+}
+
+static void wil_acs_notify(struct wiphy *wiphy, struct net_device *dev,
+			   u32 status)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	u8 ch = wil_acs_calc_channel(wil);
+	u32 freq = ieee80211_channel_to_frequency(ch + 1, NL80211_BAND_60GHZ);
+	struct ieee80211_channel *channel = ieee80211_get_channel(wiphy, freq);
+	struct cfg80211_chan_def chandef = {0};
+
+	if (channel) {
+		cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
+	} else {
+		wil_err(wil, "Invalid freq %d\n", freq);
+		status = NL80211_ACS_FAILED;
+	}
+
+	cfg80211_acs_result(dev, &chandef, status, GFP_KERNEL);
+}
+
+static int
+wil_cfg80211_acs(struct wiphy *wiphy, struct net_device *dev,
+		 struct cfg80211_acs_params *params)
+{
+	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
+	enum nl80211_acs_status status = NL80211_ACS_SUCCESS;
+	int rc;
+
+	if (params->n_channels == 0) {
+		wil_err(wil, "acs: No valid channels for ACS\n");
+		return -EINVAL;
+	}
+
+	rc = wil_start_acs_survey(wil, WMI_SCAN_DWELL_TIME_MS,
+				  params->channels, params->n_channels);
+	if (rc)
+		status = NL80211_ACS_FAILED;
+
+	wil_acs_notify(wiphy, dev, status);
+
+	return 0;
+}
+
 static const struct cfg80211_ops wil_cfg80211_ops = {
 	.add_virtual_intf = wil_cfg80211_add_iface,
 	.del_virtual_intf = wil_cfg80211_del_iface,
@@ -2394,6 +2528,7 @@ static int wil_cfg80211_resume(struct wiphy *wiphy)
 	.sched_scan_start = wil_cfg80211_sched_scan_start,
 	.sched_scan_stop = wil_cfg80211_sched_scan_stop,
 	.update_ft_ies = wil_cfg80211_update_ft_ies,
+	.acs = wil_cfg80211_acs,
 };
 
 static void wil_wiphy_init(struct wiphy *wiphy)
@@ -2436,6 +2571,7 @@ static void wil_wiphy_init(struct wiphy *wiphy)
 #ifdef CONFIG_PM
 	wiphy->wowlan = &wil_wowlan_support;
 #endif
+	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_ACS_OFFLOAD);
 }
 
 int wil_cfg80211_iface_combinations_from_fw(
diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 20dd4d0..a376229 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -26,6 +26,8 @@
 #include "txrx.h"
 #include "pmc.h"
 
+#define WIL_DEBUGFS_BUF_SIZE 400
+
 /* Nasty hack. Better have per device instances */
 static u32 mem_addr;
 static u32 dbg_txdesc_index;
@@ -2250,6 +2252,98 @@ static ssize_t wil_read_led_blink_time(struct file *file, char __user *user_buf,
 	.open  = simple_open,
 };
 
+/*---------ACS channel weight------------*/
+static ssize_t wil_write_acs_ch_weight(struct file *file,
+				       const char __user *buf,
+				       size_t len, loff_t *ppos)
+{
+	struct wil6210_priv *wil = file->private_data;
+	int i, rc;
+	char *token, *dupbuf, *kbuf = kmalloc(len + 1, GFP_KERNEL);
+	unsigned short channel_weights[WIL_MAX_CHANNELS];
+
+	if (!kbuf)
+		return -ENOMEM;
+
+	rc = simple_write_to_buffer(kbuf, len, ppos, buf, len);
+	if (rc != len) {
+		kfree(kbuf);
+		return rc >= 0 ? -EIO : rc;
+	}
+
+	kbuf[len] = '\0';
+	dupbuf = kbuf;
+
+	/* Format for writing is num of channels unsigned short separated
+	 * by spaces:
+	 * <ch 1 weight> ... <channel max weight>
+	 */
+
+	/* set the channels weights */
+	for (i = 0; i < WIL_MAX_CHANNELS; ++i) {
+		token = strsep(&dupbuf, " ");
+		if (!token)
+			goto out;
+		if (kstrtou16(token, 0, &channel_weights[i]))
+			goto out;
+	}
+	memcpy(wil->acs_ch_weight, channel_weights, sizeof(wil->acs_ch_weight));
+
+out:
+	kfree(kbuf);
+	if (i != WIL_MAX_CHANNELS)
+		return -EINVAL;
+
+	return len;
+}
+
+static ssize_t wil_read_acs_ch_weight(struct file *file, char __user *user_buf,
+				      size_t count, loff_t *ppos)
+{
+	struct wil6210_priv *wil = file->private_data;
+	char *buf;
+	size_t buf_size = WIL_DEBUGFS_BUF_SIZE;
+	int i, bytes_used, offset, rc = -EINVAL;
+
+	buf = kmalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	bytes_used = snprintf(buf, buf_size,
+			      "To set acs channel weights write:\n"
+			      "<ch 1 weight> <ch 2 weight> ... <ch max weight>\n"
+			      "The current values are:\n");
+
+	if (bytes_used < 0 || bytes_used >= buf_size)
+		goto out;
+
+	buf_size -= bytes_used;
+	offset = bytes_used;
+
+	for (i = 0; i < WIL_MAX_CHANNELS; ++i) {
+		bytes_used = snprintf(buf + offset, buf_size, "%hu ",
+				      wil->acs_ch_weight[i]);
+		if (bytes_used < 0 || bytes_used >= buf_size)
+			goto out;
+
+		buf_size -= bytes_used;
+		offset += bytes_used;
+	}
+	strncat(buf, "\n", WIL_DEBUGFS_BUF_SIZE);
+	rc = simple_read_from_buffer(user_buf, count, ppos, buf, offset);
+
+out:
+	kfree(buf);
+
+	return rc;
+}
+
+static const struct file_operations fops_acs_ch_weight = {
+	.read = wil_read_acs_ch_weight,
+	.write = wil_write_acs_ch_weight,
+	.open  = simple_open,
+};
+
 /*---------FW capabilities------------*/
 static int wil_fw_capabilities_debugfs_show(struct seq_file *s, void *data)
 {
@@ -2414,6 +2508,65 @@ static ssize_t wil_compressed_rx_status_write(struct file *file,
 	.llseek	= seq_lseek,
 };
 
+/*---------Survey results------------*/
+static int wil_survey_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+	int i, n_ch;
+	u16 filled;
+
+	if (!wil->survey_ready) {
+		seq_puts(s, "Survey not ready\n");
+		return 0;
+	}
+	seq_printf(s, "dwell_time : %d\n",
+		   le32_to_cpu(wil->survey_reply.evt.dwell_time));
+	filled = le16_to_cpu(wil->survey_reply.evt.filled);
+	n_ch = min_t(int, wil->survey_reply.evt.num_scanned_channels,
+		     ARRAY_SIZE(wil->survey_reply.ch_info));
+
+#define ACS_FILLED(x) (filled & WMI_ACS_INFO_BITMASK_ ## x) ? \
+	" " __stringify(x) : ""
+	seq_printf(s, "Filled : 0x%04x%s%s%s%s%s\n", filled,
+		   ACS_FILLED(BEACON_FOUND),
+		   ACS_FILLED(BUSY_TIME),
+		   ACS_FILLED(TX_TIME),
+		   ACS_FILLED(RX_TIME),
+		   ACS_FILLED(NOISE)
+		  );
+#undef ACS_FILLED
+	seq_printf(s, "Channels [%d] {\n", n_ch);
+	for (i = 0; i < n_ch; i++) {
+		struct scan_acs_info *ch = &wil->survey_reply.ch_info[i];
+
+		seq_printf(s, "  [%d]", ch->channel);
+#define ACS_PRINT(x, str, field) do { if (filled & WMI_ACS_INFO_BITMASK_ ## x) \
+		seq_printf(s, " %s : %d", str, field); \
+	} while (0)
+		ACS_PRINT(BEACON_FOUND, "bcon", ch->beacon_found);
+		ACS_PRINT(BUSY_TIME, "busy", le16_to_cpu(ch->busy_time));
+		ACS_PRINT(TX_TIME, "tx", le16_to_cpu(ch->tx_time));
+		ACS_PRINT(RX_TIME, "rx", le16_to_cpu(ch->rx_time));
+		ACS_PRINT(NOISE, "noise", ch->noise);
+#undef ACS_PRINT
+		seq_puts(s, "\n");
+	}
+	seq_puts(s, "}\n");
+	return 0;
+}
+
+static int wil_survey_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_survey_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations fops_survey = {
+	.open		= wil_survey_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
 /*----------------*/
 static void wil6210_debugfs_init_blobs(struct wil6210_priv *wil,
 				       struct dentry *dbg)
@@ -2473,6 +2626,7 @@ static void wil6210_debugfs_init_blobs(struct wil6210_priv *wil,
 	{"tx_latency",	0644,		&fops_tx_latency},
 	{"link_stats",	0644,		&fops_link_stats},
 	{"link_stats_global",	0644,	&fops_link_stats_global},
+	{"acs_ch_weight",	0644,	&fops_acs_ch_weight},
 };
 
 static void wil6210_debugfs_init_files(struct wil6210_priv *wil,
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index ba6a2ee..f20ced0 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -750,6 +750,11 @@ int wil_priv_init(struct wil6210_priv *wil)
 
 	wil->amsdu_en = 1;
 
+	/* ACS related */
+	wil->acs_ch_weight[0] = 120;
+	for (i = 1; i < WIL_MAX_CHANNELS; i++)
+		wil->acs_ch_weight[i] = 100;
+
 	return 0;
 
 out_wmi_wq:
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 0f3be3ff..c286750 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -67,6 +67,8 @@
  */
 #define WIL_MAX_VIFS 4
 
+#define WIL_MAX_CHANNELS 4 /* max supported channels */
+
 /**
  * extract bits [@b0:@b1] (inclusive) from the value @x
  * it should be @b0 <= @b1, or result is incorrect
@@ -1045,6 +1047,15 @@ struct wil6210_priv {
 
 	u32 max_agg_wsize;
 	u32 max_ampdu_size;
+
+	/* ACS related */
+	unsigned short acs_ch_weight[WIL_MAX_CHANNELS];
+	bool survey_ready;
+	struct {
+		struct wmi_cmd_hdr wmi;
+		struct wmi_acs_passive_scan_complete_event evt;
+		struct scan_acs_info ch_info[WIL_MAX_CHANNELS];
+	} __packed survey_reply;
 };
 
 #define wil_to_wiphy(i) (i->wiphy)
@@ -1252,6 +1263,9 @@ int wil_addba_rx_request(struct wil6210_priv *wil, u8 mid,
 			 u8 cidxtid, u8 dialog_token, __le16 ba_param_set,
 			 __le16 ba_timeout, __le16 ba_seq_ctrl);
 int wil_addba_tx_request(struct wil6210_priv *wil, u8 ringid, u16 wsize);
+int wil_start_acs_survey(struct wil6210_priv *wil, uint dwell_time,
+			 struct cfg80211_chan_def channels[],
+			 u8 num_channels);
 
 void wil6210_clear_irq(struct wil6210_priv *wil);
 int wil6210_init_irq(struct wil6210_priv *wil, int irq);
@@ -1402,4 +1416,5 @@ int wmi_addba_rx_resp_edma(struct wil6210_priv *wil, u8 mid, u8 cid,
 
 void update_supported_bands(struct wil6210_priv *wil);
 
+int wil_num_supported_channels(struct wil6210_priv *wil);
 #endif /* __WIL6210_H__ */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 345f059..5ca0d88 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -3811,3 +3811,79 @@ int wmi_link_stats_cfg(struct wil6210_vif *vif, u32 type, u8 cid, u32 interval)
 
 	return 0;
 }
+
+int wil_start_acs_survey(struct wil6210_priv *wil, uint dwell_time,
+			 struct cfg80211_chan_def channels[],
+			 u8 num_channels)
+{
+	struct wil6210_vif *vif = ndev_to_vif(wil->main_ndev);
+	int rc, i;
+	u8 ch;
+	struct wmi_acs_passive_scan_complete_event *reply;
+	u8 num_supported_channels = wil_num_supported_channels(wil);
+	struct {
+		struct wmi_start_scan_cmd cmd;
+		struct {
+			u8 channel;
+			u8 reserved;
+		} channel_list[WIL_MAX_CHANNELS];
+	} __packed scan_cmd = {
+		.cmd = {
+			.scan_type = WMI_PASSIVE_SCAN,
+			.dwell_time = cpu_to_le32(dwell_time),
+			.num_channels = min_t(u8, num_channels,
+					      num_supported_channels),
+		},
+	};
+
+	wil->survey_ready = false;
+	memset(&wil->survey_reply, 0, sizeof(wil->survey_reply));
+	reply = &wil->survey_reply.evt;
+	reply->status = WMI_SCAN_FAILED;
+
+	for (i = 0; i < scan_cmd.cmd.num_channels; i++) {
+		ch = channels[i].chan->hw_value;
+
+		if (ch == 0) {
+			wil_err(wil, "ACS requested for wrong channel\n");
+			return -EINVAL;
+		}
+		wil_dbg_misc(wil, "ACS channel %d : %d MHz\n",
+			     ch, channels[i].chan->center_freq);
+		scan_cmd.channel_list[i].channel = ch - 1;
+	}
+
+	/* send scan command with the requested channel and wait
+	 * for results
+	 */
+	rc = wmi_call(wil, WMI_START_SCAN_CMDID, vif->mid, &scan_cmd,
+		      sizeof(scan_cmd), WMI_ACS_PASSIVE_SCAN_COMPLETE_EVENTID,
+		      &wil->survey_reply, sizeof(wil->survey_reply),
+		      WMI_SURVEY_TIMEOUT_MS);
+	if (rc) {
+		wil_err(wil, "ACS passive Scan failed (0x%08x)\n", rc);
+		return rc;
+	}
+
+	if (reply->num_scanned_channels > num_supported_channels) {
+		wil_err(wil,
+			"Survey num of scanned channels %d exceeds num of supported channels %d\n",
+			reply->num_scanned_channels,
+			num_supported_channels);
+		reply->status = WMI_SCAN_FAILED;
+		return -EINVAL;
+	}
+
+	if (reply->status != WMI_SCAN_SUCCESS) {
+		wil_err(wil, "ACS survey failed, status (%d)\n",
+			wil->survey_reply.evt.status);
+		return -EINVAL;
+	}
+	wil->survey_ready = true;
+
+	/* The results in survey_reply */
+	wil_dbg_misc(wil, "ACS scan success, filled mask: 0x%08X\n",
+		     le16_to_cpu(reply->filled));
+
+	return 0;
+}
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index b668758..5a71e98 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -2444,7 +2444,8 @@ struct wmi_acs_passive_scan_complete_event {
 	 */
 	__le16 filled;
 	u8 num_scanned_channels;
-	u8 reserved;
+	/* enum scan_status */
+	u8 status;
 	struct scan_acs_info scan_info_list[0];
 } __packed;
 
-- 
1.9.1

