Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32183 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752830AbcAGJe0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 04:34:26 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u079U2db005940
	for <linux-wireless@vger.kernel.org>; Thu, 7 Jan 2016 01:34:26 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0a-0016f401.pphosted.com with ESMTP id 209g1d8vbd-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 01:34:26 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	chunfan chen <jeffc@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/6] mwifiex: add wowlan net-detect support
Date: Thu, 7 Jan 2016 01:31:28 -0800
Message-ID: <1452159091-30997-4-git-send-email-akarwar@marvell.com> (sfid-20160107_103437_779723_ABC4C700)
In-Reply-To: <1452159091-30997-1-git-send-email-akarwar@marvell.com>
References: <1452159091-30997-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: chunfan chen <jeffc@marvell.com>

This patch adds support for wakeup when configured
network is detected.

Signed-off-by: chunfan chen <jeffc@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c  | 40 +++++++++++++++---------
 drivers/net/wireless/marvell/mwifiex/fw.h        |  2 ++
 drivers/net/wireless/marvell/mwifiex/main.c      |  7 +++++
 drivers/net/wireless/marvell/mwifiex/main.h      |  1 +
 drivers/net/wireless/marvell/mwifiex/scan.c      | 32 +++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c |  6 ++--
 6 files changed, 72 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 6d36d08..a1b8d89 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3273,7 +3273,7 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
 
-	if (!priv->media_connected) {
+	if (!priv->media_connected && !wowlan->nd_config) {
 		mwifiex_dbg(adapter, ERROR,
 			    "Can not configure WOWLAN in disconnected state\n");
 		return 0;
@@ -3285,22 +3285,32 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 		return ret;
 	}
 
+	memset(&hs_cfg, 0, sizeof(hs_cfg));
+	hs_cfg.conditions = le32_to_cpu(adapter->hs_cfg.conditions);
+
+	if (wowlan->nd_config) {
+		mwifiex_dbg(adapter, INFO, "Wake on net detect\n");
+		hs_cfg.conditions |= HS_CFG_COND_MAC_EVENT;
+		mwifiex_cfg80211_sched_scan_start(wiphy, priv->netdev,
+						  wowlan->nd_config);
+	}
+
 	if (wowlan->disconnect) {
-		memset(&hs_cfg, 0, sizeof(hs_cfg));
-		hs_cfg.is_invoke_hostcmd = false;
-		hs_cfg.conditions = HS_CFG_COND_MAC_EVENT;
-		hs_cfg.gpio = adapter->hs_cfg.gpio;
-		hs_cfg.gap = adapter->hs_cfg.gap;
-		ret = mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_SET,
-					    MWIFIEX_SYNC_CMD, &hs_cfg);
-		if (ret) {
-			mwifiex_dbg(adapter, ERROR,
-				    "Failed to set HS params\n");
-			return ret;
-		}
+		hs_cfg.conditions |= HS_CFG_COND_MAC_EVENT;
 		mwifiex_dbg(priv->adapter, INFO, "Wake on device disconnect\n");
 	}
 
+	hs_cfg.is_invoke_hostcmd = false;
+	hs_cfg.gpio = adapter->hs_cfg.gpio;
+	hs_cfg.gap = adapter->hs_cfg.gap;
+	ret = mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_SET,
+				    MWIFIEX_SYNC_CMD, &hs_cfg);
+	if (ret) {
+		mwifiex_dbg(adapter, ERROR,
+			    "Failed to set HS params\n");
+		return ret;
+	}
+
 	return ret;
 }
 
@@ -3853,11 +3863,13 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 
 #ifdef CONFIG_PM
 static const struct wiphy_wowlan_support mwifiex_wowlan_support = {
-	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT,
+	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT |
+		WIPHY_WOWLAN_NET_DETECT,
 	.n_patterns = MWIFIEX_MEF_MAX_FILTERS,
 	.pattern_min_len = 1,
 	.pattern_max_len = MWIFIEX_MAX_PATTERN_LEN,
 	.max_pkt_offset = MWIFIEX_MAX_OFFSET_LEN,
+	.max_nd_match_sets = MWIFIEX_MAX_ND_MATCH_SETS,
 };
 #endif
 
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 07bdc2a..81b491a 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -543,6 +543,8 @@ enum P2P_MODES {
 
 #define MWIFIEX_MAX_PATTERN_LEN		40
 #define MWIFIEX_MAX_OFFSET_LEN		100
+#define MWIFIEX_MAX_ND_MATCH_SETS	10
+
 #define STACK_NBYTES			100
 #define TYPE_DNUM			1
 #define TYPE_BYTESEQ			2
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index a99b72b..3cfa946 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -132,6 +132,13 @@ static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 		}
 	}
 
+	if (adapter->nd_info) {
+		for (i = 0 ; i < adapter->nd_info->n_matches ; i++)
+			kfree(adapter->nd_info->matches[i]);
+		kfree(adapter->nd_info);
+		adapter->nd_info = NULL;
+	}
+
 	vfree(adapter->chan_stats);
 	kfree(adapter);
 	return 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 5f5bcf8..bf9b24a 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1002,6 +1002,7 @@ struct mwifiex_adapter {
 	u8 active_scan_triggered;
 	bool usb_mc_status;
 	bool usb_mc_setup;
+	struct cfg80211_wowlan_nd_info *nd_info;
 };
 
 void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index d4e2143..0a85b05 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2092,6 +2092,8 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 	u8 is_bgscan_resp;
 	__le64 fw_tsf = 0;
 	u8 *radio_type;
+	struct cfg80211_wowlan_nd_match *pmatch;
+	struct cfg80211_sched_scan_request *nd_config = NULL;
 
 	is_bgscan_resp = (le16_to_cpu(resp->command)
 			  == HostCmd_CMD_802_11_BG_SCAN_QUERY);
@@ -2154,6 +2156,19 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 					     (struct mwifiex_ie_types_data **)
 					     &chan_band_tlv);
 
+	if (priv->wdev.wiphy->wowlan_config)
+		nd_config = priv->wdev.wiphy->wowlan_config->nd_config;
+
+	if (nd_config) {
+		adapter->nd_info =
+			kzalloc(sizeof(struct cfg80211_wowlan_nd_match) +
+				sizeof(struct cfg80211_wowlan_nd_match *) *
+				scan_rsp->number_of_sets, GFP_ATOMIC);
+
+		if (adapter->nd_info)
+			adapter->nd_info->n_matches = scan_rsp->number_of_sets;
+	}
+
 	for (idx = 0; idx < scan_rsp->number_of_sets && bytes_left; idx++) {
 		/*
 		 * If the TSF TLV was appended to the scan results, save this
@@ -2172,6 +2187,23 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			radio_type = NULL;
 		}
 
+		if (chan_band_tlv && adapter->nd_info) {
+			adapter->nd_info->matches[idx] =
+				kzalloc(sizeof(*pmatch) +
+				sizeof(u32), GFP_ATOMIC);
+
+			pmatch = adapter->nd_info->matches[idx];
+
+			if (!pmatch) {
+				memset(pmatch, 0, sizeof(*pmatch));
+				if (chan_band_tlv) {
+					pmatch->n_channels = 1;
+					pmatch->channels[0] =
+						chan_band->chan_number;
+				}
+			}
+		}
+
 		ret = mwifiex_parse_single_response_buf(priv, &bss_info,
 							&bytes_left,
 							le64_to_cpu(fw_tsf),
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 2cc1a32..cf4b6dd 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -505,8 +505,10 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 	}
 
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
-	if (priv && priv->sched_scanning) {
-		dev_dbg(adapter->dev, "aborting bgscan!\n");
+
+	if (priv && priv->sched_scanning &&
+	    !priv->wdev.wiphy->wowlan_config->nd_config) {
+		mwifiex_dbg(adapter, CMD, "aborting bgscan!\n");
 		mwifiex_stop_bg_scan(priv);
 		cfg80211_sched_scan_stopped(priv->wdev.wiphy);
 	}
-- 
1.8.1.4

