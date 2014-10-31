Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:65296 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856AbaJaFJh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 01:09:37 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <huxm@marvell.com>,
	<cluo@marvell.com>, <yangyang@marvell.com>, <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/2] mwifiex: add cfg80211 dump_survey handler
Date: Fri, 31 Oct 2014 16:08:27 +0530
Message-ID: <1414751907-4957-3-git-send-email-patila@marvell.com> (sfid-20141031_060939_829770_6B2A7F35)
In-Reply-To: <1414751907-4957-1-git-send-email-patila@marvell.com>
References: <1414751907-4957-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch add cfg80211 dump_survey handler for mwifiex.
This handler will be called to report channel statistics
to cfg80211.

This in turn adds ACS support for mwifiex AP.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 47 +++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 80b1a54..b3c7635 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -992,6 +992,52 @@ mwifiex_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 	return mwifiex_dump_station_info(priv, sinfo);
 }
 
+static int
+mwifiex_cfg80211_dump_survey(struct wiphy *wiphy, struct net_device *dev,
+			     int idx, struct survey_info *survey)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	struct mwifiex_chan_stats *pchan_stats = priv->adapter->chan_stats;
+	enum ieee80211_band band;
+
+	dev_dbg(priv->adapter->dev, "dump_survey idx=%d\n", idx);
+
+	memset(survey, 0, sizeof(struct survey_info));
+
+	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
+	    priv->media_connected && idx == 0) {
+			u8 curr_bss_band = priv->curr_bss_params.band;
+			u32 chan = priv->curr_bss_params.bss_descriptor.channel;
+
+			band = mwifiex_band_to_radio_type(curr_bss_band);
+			survey->channel = ieee80211_get_channel(wiphy,
+				ieee80211_channel_to_frequency(chan, band));
+
+			if (priv->bcn_nf_last) {
+				survey->filled = SURVEY_INFO_NOISE_DBM;
+				survey->noise = priv->bcn_nf_last;
+			}
+			return 0;
+	}
+
+	if (idx >= priv->adapter->num_in_chan_stats)
+		return -ENOENT;
+
+	if (!pchan_stats[idx].cca_scan_dur)
+		return 0;
+
+	band = pchan_stats[idx].bandcfg;
+	survey->channel = ieee80211_get_channel(wiphy,
+	    ieee80211_channel_to_frequency(pchan_stats[idx].chan_num, band));
+	survey->filled = SURVEY_INFO_NOISE_DBM |
+		SURVEY_INFO_CHANNEL_TIME | SURVEY_INFO_CHANNEL_TIME_BUSY;
+	survey->noise = pchan_stats[idx].noise;
+	survey->channel_time = pchan_stats[idx].cca_scan_dur;
+	survey->channel_time_busy = pchan_stats[idx].cca_busy_dur;
+
+	return 0;
+}
+
 /* Supported rates to be advertised to the cfg80211 */
 static struct ieee80211_rate mwifiex_rates[] = {
 	{.bitrate = 10, .hw_value = 2, },
@@ -2779,6 +2825,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.disconnect = mwifiex_cfg80211_disconnect,
 	.get_station = mwifiex_cfg80211_get_station,
 	.dump_station = mwifiex_cfg80211_dump_station,
+	.dump_survey = mwifiex_cfg80211_dump_survey,
 	.set_wiphy_params = mwifiex_cfg80211_set_wiphy_params,
 	.join_ibss = mwifiex_cfg80211_join_ibss,
 	.leave_ibss = mwifiex_cfg80211_leave_ibss,
-- 
1.8.1.4

