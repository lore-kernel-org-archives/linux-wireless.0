Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:29154 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbaBSNCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 08:02:30 -0500
Date: Wed, 19 Feb 2014 18:18:38 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH 3/3 v2] mwl8k: Adding support to gather survey per channel
Message-ID: <20140219124838.GA5379@markyou.marvell.com> (sfid-20140219_140233_144917_1B276CC4)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Survey stats such as channel busy time, rx busy time
and noise are collected when sw_scan starts for every
switched new channel. This happens till sw_scan stops.

All the collected stats are shared up when get_survey()
is called.

This implements support for ACS feature from Hostapd.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c | 115 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 109 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index afca172..b9d143b 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -115,6 +115,8 @@ MODULE_PARM_DESC(ap_mode_default,
  */
 #define MWL8K_NUM_AMPDU_STREAMS	(TOTAL_HW_TX_QUEUES - 1)
 
+#define MWL8K_NUM_CHANS 18
+
 struct rxd_ops {
 	int rxd_size;
 	void (*rxd_init)(void *rxd, dma_addr_t next_dma_addr);
@@ -295,6 +297,9 @@ struct mwl8k_priv {
 
 	/* ACS related */
 	bool sw_scan_start;
+	struct ieee80211_channel *acs_chan;
+	unsigned long channel_time;
+	struct survey_info survey[MWL8K_NUM_CHANS];
 };
 
 #define MAX_WEP_KEY_LEN         13
@@ -3064,6 +3069,64 @@ mwl8k_cmd_set_post_scan(struct ieee80211_hw *hw, const __u8 *mac)
 	return rc;
 }
 
+static int freq_to_idx(struct mwl8k_priv *priv, int freq)
+{
+	struct ieee80211_supported_band *sband;
+	int band, ch, idx = 0;
+
+	for (band = IEEE80211_BAND_2GHZ; band < IEEE80211_NUM_BANDS; band++) {
+		sband = priv->hw->wiphy->bands[band];
+		if (!sband)
+			continue;
+
+		for (ch = 0; ch < sband->n_channels; ch++, idx++)
+			if (sband->channels[ch].center_freq == freq)
+				goto exit;
+	}
+
+exit:
+	return idx;
+}
+
+void mwl8k_update_survey(struct mwl8k_priv *priv,
+			 struct ieee80211_channel *channel)
+{
+	u32 cca_cnt, rx_rdy;
+	s8 nf = 0, idx;
+	struct survey_info *survey;
+
+	idx = freq_to_idx(priv, priv->acs_chan->center_freq);
+	if (idx >= MWL8K_NUM_CHANS) {
+		wiphy_err(priv->hw->wiphy, "Failed to update survey\n");
+		return;
+	}
+
+	survey = &priv->survey[idx];
+
+	cca_cnt = le32_to_cpu(ioread32(priv->regs + NOK_CCA_CNT_REG));
+	cca_cnt /= 1000; /* uSecs to mSecs */
+	survey->channel_time_busy = (u64) cca_cnt;
+
+	rx_rdy = le32_to_cpu(ioread32(priv->regs + BBU_RXRDY_CNT_REG));
+	rx_rdy /= 1000; /* uSecs to mSecs */
+	survey->channel_time_rx = (u64) rx_rdy;
+
+	priv->channel_time = jiffies - priv->channel_time;
+	survey->channel_time = jiffies_to_msecs(priv->channel_time);
+
+	survey->channel = channel;
+
+	mwl8k_cmd_bbp_reg_access(priv->hw, 0, BBU_AVG_NOISE_VAL, &nf);
+
+	/* Make sure sign is negative else ACS  at hostapd fails */
+	survey->noise = nf * -1;
+
+	survey->filled = SURVEY_INFO_NOISE_DBM |
+			 SURVEY_INFO_CHANNEL_TIME |
+			 SURVEY_INFO_CHANNEL_TIME_BUSY |
+			 SURVEY_INFO_CHANNEL_TIME_RX;
+}
+
 /*
  * CMD_SET_RF_CHANNEL.
  */
@@ -3081,6 +3144,7 @@ static int mwl8k_cmd_set_rf_channel(struct ieee80211_hw *hw,
 	enum nl80211_channel_type channel_type =
 		cfg80211_get_chandef_type(&conf->chandef);
 	struct mwl8k_cmd_set_rf_channel *cmd;
+	struct mwl8k_priv *priv = hw->priv;
 	int rc;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
@@ -3097,13 +3161,29 @@ static int mwl8k_cmd_set_rf_channel(struct ieee80211_hw *hw,
 	else if (channel->band == IEEE80211_BAND_5GHZ)
 		cmd->channel_flags |= cpu_to_le32(0x00000004);
 
-	if (channel_type == NL80211_CHAN_NO_HT ||
-	    channel_type == NL80211_CHAN_HT20)
+	if (!priv->sw_scan_start) {
+		if (channel_type == NL80211_CHAN_NO_HT ||
+		    channel_type == NL80211_CHAN_HT20)
+			cmd->channel_flags |= cpu_to_le32(0x00000080);
+		else if (channel_type == NL80211_CHAN_HT40MINUS)
+			cmd->channel_flags |= cpu_to_le32(0x000001900);
+		else if (channel_type == NL80211_CHAN_HT40PLUS)
+			cmd->channel_flags |= cpu_to_le32(0x000000900);
+	} else {
 		cmd->channel_flags |= cpu_to_le32(0x00000080);
-	else if (channel_type == NL80211_CHAN_HT40MINUS)
-		cmd->channel_flags |= cpu_to_le32(0x000001900);
-	else if (channel_type == NL80211_CHAN_HT40PLUS)
-		cmd->channel_flags |= cpu_to_le32(0x000000900);
+	}
+
+	if (priv->sw_scan_start) {
+		/* Store current channel stats
+		 * before switching to newer one.
+		 * This will be processed only for AP fw.
+		 */
+		if (priv->channel_time != 0)
+			mwl8k_update_survey(priv, priv->acs_chan);
+
+		priv->channel_time = jiffies;
+		priv->acs_chan =  channel;
+	}
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
 	kfree(cmd);
@@ -5311,6 +5391,27 @@ static int mwl8k_get_survey(struct ieee80211_hw *hw, int idx,
 {
 	struct mwl8k_priv *priv = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
+	struct ieee80211_supported_band *sband;
+
+	if (priv->ap_fw) {
+		sband = hw->wiphy->bands[IEEE80211_BAND_2GHZ];
+
+		if (sband && idx >= sband->n_channels) {
+			idx -= sband->n_channels;
+			sband = NULL;
+		}
+
+		if (!sband)
+			sband = hw->wiphy->bands[IEEE80211_BAND_5GHZ];
+
+		if (!sband || idx >= sband->n_channels)
+			return -ENOENT;
+
+		memcpy(survey, &priv->survey[idx], sizeof(*survey));
+		survey->channel = &sband->channels[idx];
+
+		return 0;
+	}
 
 	if (idx != 0)
 		return -ENOENT;
@@ -5463,6 +5564,7 @@ static void mwl8k_sw_scan_start(struct ieee80211_hw *hw)
 		return;
 
 	/* clear all stats */
+	priv->channel_time = 0;
 	ioread32(priv->regs + BBU_RXRDY_CNT_REG);
 	ioread32(priv->regs + NOK_CCA_CNT_REG);
 	mwl8k_cmd_bbp_reg_access(priv->hw, 0, BBU_AVG_NOISE_VAL, &tmp);
@@ -5481,6 +5583,7 @@ static void mwl8k_sw_scan_complete(struct ieee80211_hw *hw)
 	priv->sw_scan_start = false;
 
 	/* clear all stats */
+	priv->channel_time = 0;
 	ioread32(priv->regs + BBU_RXRDY_CNT_REG);
 	ioread32(priv->regs + NOK_CCA_CNT_REG);
 	mwl8k_cmd_bbp_reg_access(priv->hw, 0, BBU_AVG_NOISE_VAL, &tmp);
-- 
1.8.3.4

