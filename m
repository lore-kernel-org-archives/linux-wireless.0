Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62591 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbbFAMdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 08:33:20 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t51CT3kB017221
	for <linux-wireless@vger.kernel.org>; Mon, 1 Jun 2015 05:33:19 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1upunhwk3w-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 05:33:19 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv4 07/17] mwifiex: add cfg80211 get_channel handler
Date: Mon, 1 Jun 2015 23:32:05 +0530
Message-ID: <1433181735-15712-8-git-send-email-patila@marvell.com> (sfid-20150601_143323_213759_E84E0191)
In-Reply-To: <1433181735-15712-1-git-send-email-patila@marvell.com>
References: <1433181735-15712-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch add cfg80211 get_channel handler for mwifiex.
The handler will be used to report current channel to upper
layer utility.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/11h.c      |  2 +-
 drivers/net/wireless/mwifiex/cfg80211.c | 58 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/mwifiex/main.h     |  5 ++-
 drivers/net/wireless/mwifiex/uap_cmd.c  |  5 ++-
 4 files changed, 66 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11h.c b/drivers/net/wireless/mwifiex/11h.c
index bb2ffd9..71a1b58 100644
--- a/drivers/net/wireless/mwifiex/11h.c
+++ b/drivers/net/wireless/mwifiex/11h.c
@@ -305,7 +305,7 @@ void mwifiex_dfs_chan_sw_work_queue(struct work_struct *work)
 		return;
 	}
 
-	mwifiex_uap_set_channel(bss_cfg, priv->dfs_chandef);
+	mwifiex_uap_set_channel(priv, bss_cfg, priv->dfs_chandef);
 
 	if (mwifiex_config_start_uap(priv, bss_cfg)) {
 		mwifiex_dbg(priv->adapter, ERROR,
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index fb93e13..ddeb919 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -67,6 +67,22 @@ u8 mwifiex_chan_type_to_sec_chan_offset(enum nl80211_channel_type chan_type)
 	}
 }
 
+/* This function maps IEEE HT secondary channel type to NL80211 channel type
+ */
+u8 mwifiex_sec_chan_offset_to_chan_type(u8 second_chan_offset)
+{
+	switch (second_chan_offset) {
+	case IEEE80211_HT_PARAM_CHA_SEC_NONE:
+		return NL80211_CHAN_HT20;
+	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
+		return NL80211_CHAN_HT40PLUS;
+	case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
+		return NL80211_CHAN_HT40MINUS;
+	default:
+		return NL80211_CHAN_HT20;
+	}
+}
+
 /*
  * This function checks whether WEP is set.
  */
@@ -1785,7 +1801,7 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
-	mwifiex_uap_set_channel(bss_cfg, params->chandef);
+	mwifiex_uap_set_channel(priv, bss_cfg, params->chandef);
 	mwifiex_set_uap_rates(bss_cfg, params);
 
 	if (mwifiex_set_secure_params(priv, bss_cfg, params)) {
@@ -3373,6 +3389,45 @@ mwifiex_cfg80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int mwifiex_cfg80211_get_channel(struct wiphy *wiphy,
+					struct wireless_dev *wdev,
+					struct cfg80211_chan_def *chandef)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
+	struct mwifiex_bssdescriptor *curr_bss;
+	struct ieee80211_channel *chan;
+	u8 second_chan_offset;
+	enum nl80211_channel_type chan_type;
+	enum ieee80211_band band;
+	int freq;
+	int ret = -ENODATA;
+
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP &&
+	    cfg80211_chandef_valid(&priv->bss_chandef)) {
+		*chandef = priv->bss_chandef;
+		ret = 0;
+	} else if (priv->media_connected) {
+		curr_bss = &priv->curr_bss_params.bss_descriptor;
+		band = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
+		freq = ieee80211_channel_to_frequency(curr_bss->channel, band);
+		chan = ieee80211_get_channel(wiphy, freq);
+
+		if (curr_bss->bcn_ht_oper) {
+			second_chan_offset = curr_bss->bcn_ht_oper->ht_param &
+					IEEE80211_HT_PARAM_CHA_SEC_OFFSET;
+			chan_type = mwifiex_sec_chan_offset_to_chan_type
+							(second_chan_offset);
+			cfg80211_chandef_create(chandef, chan, chan_type);
+		} else {
+			cfg80211_chandef_create(chandef, chan,
+						NL80211_CHAN_NO_HT);
+		}
+		ret = 0;
+	}
+
+	return ret;
+}
+
 static int
 mwifiex_cfg80211_start_radar_detection(struct wiphy *wiphy,
 				       struct net_device *dev,
@@ -3478,6 +3533,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.tdls_oper = mwifiex_cfg80211_tdls_oper,
 	.add_station = mwifiex_cfg80211_add_station,
 	.change_station = mwifiex_cfg80211_change_station,
+	.get_channel = mwifiex_cfg80211_get_channel,
 	.start_radar_detection = mwifiex_cfg80211_start_radar_detection,
 	.channel_switch = mwifiex_cfg80211_channel_switch,
 };
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 3ac18c6..88d3779 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -642,6 +642,7 @@ struct mwifiex_private {
 	u8 del_list_idx;
 	bool hs2_enabled;
 	struct mwifiex_uap_bss_param bss_cfg;
+	struct cfg80211_chan_def bss_chandef;
 	struct station_parameters *sta_params;
 	struct sk_buff_head tdls_txq;
 	u8 check_tdls_tx;
@@ -1382,6 +1383,7 @@ int mwifiex_check_network_compatibility(struct mwifiex_private *priv,
 					struct mwifiex_bssdescriptor *bss_desc);
 
 u8 mwifiex_chan_type_to_sec_chan_offset(enum nl80211_channel_type chan_type);
+u8 mwifiex_sec_chan_offset_to_chan_type(u8 second_chan_offset);
 
 struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 					      const char *name,
@@ -1399,7 +1401,8 @@ int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
 			 struct cfg80211_beacon_data *data);
 int mwifiex_del_mgmt_ies(struct mwifiex_private *priv);
 u8 *mwifiex_11d_code_2_region(u8 code);
-void mwifiex_uap_set_channel(struct mwifiex_uap_bss_param *bss_cfg,
+void mwifiex_uap_set_channel(struct mwifiex_private *priv,
+			     struct mwifiex_uap_bss_param *bss_cfg,
 			     struct cfg80211_chan_def chandef);
 int mwifiex_config_start_uap(struct mwifiex_private *priv,
 			     struct mwifiex_uap_bss_param *bss_cfg);
diff --git a/drivers/net/wireless/mwifiex/uap_cmd.c b/drivers/net/wireless/mwifiex/uap_cmd.c
index 56a4768..68fbdf6 100644
--- a/drivers/net/wireless/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/mwifiex/uap_cmd.c
@@ -776,11 +776,14 @@ int mwifiex_uap_prepare_cmd(struct mwifiex_private *priv, u16 cmd_no,
 	return 0;
 }
 
-void mwifiex_uap_set_channel(struct mwifiex_uap_bss_param *bss_cfg,
+void mwifiex_uap_set_channel(struct mwifiex_private *priv,
+			     struct mwifiex_uap_bss_param *bss_cfg,
 			     struct cfg80211_chan_def chandef)
 {
 	u8 config_bands = 0;
 
+	priv->bss_chandef = chandef;
+
 	bss_cfg->channel = ieee80211_frequency_to_channel(
 						     chandef.chan->center_freq);
 
-- 
1.8.1.4

