Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24781 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390AbbHENKf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 09:10:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t75DAHxM017595
	for <linux-wireless@vger.kernel.org>; Wed, 5 Aug 2015 06:10:35 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 1w2kka5w2d-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2015 06:10:35 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	chunfan chen <jeffc@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3 3/3] mwifiex: fix unable to connect hidden SSID AP on DFS channel
Date: Wed, 5 Aug 2015 06:09:42 -0700
Message-ID: <1438780182-19320-3-git-send-email-akarwar@marvell.com> (sfid-20150805_151042_634393_025B76DA)
In-Reply-To: <1438780182-19320-1-git-send-email-akarwar@marvell.com>
References: <1438780182-19320-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: chunfan chen <jeffc@marvell.com>

We will check if any hidden SSID found in passive scan channels
and do specific SSID active scan for those channels.

Signed-off-by: chunfan chen <jeffc@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v2: Corrected hidden SSID detection logic as per Paul Stewart's
    comment
v3: Make sure not to have duplicate channel entries in
    hidden_chan table (Paul Stewart)
    Replace if (x == 0) checks with if (!x)
    Don't copy unfilled entries in hidden chan table
---
drivers/net/wireless/mwifiex/fw.h   |   1 +
 drivers/net/wireless/mwifiex/init.c |   2 +-
 drivers/net/wireless/mwifiex/main.h |   2 +
 drivers/net/wireless/mwifiex/scan.c | 143 +++++++++++++++++++++++++++++++++---
 4 files changed, 136 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 9a8c1832..3ec2ac8 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -685,6 +685,7 @@ struct mwifiex_fw_chan_stats {
 enum mwifiex_chan_scan_mode_bitmasks {
 	MWIFIEX_PASSIVE_SCAN = BIT(0),
 	MWIFIEX_DISABLE_CHAN_FILT = BIT(1),
+	MWIFIEX_HIDDEN_SSID_REPORT = BIT(4),
 };
 
 struct mwifiex_chan_scan_param_set {
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 7a970c2..5d3ae63 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -301,7 +301,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	adapter->iface_limit.sta_intf = MWIFIEX_MAX_STA_NUM;
 	adapter->iface_limit.uap_intf = MWIFIEX_MAX_UAP_NUM;
 	adapter->iface_limit.p2p_intf = MWIFIEX_MAX_P2P_NUM;
-
+	adapter->active_scan_triggered = false;
 	setup_timer(&adapter->wakeup_timer, wakeup_timer_fn,
 		    (unsigned long)adapter);
 }
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index face747..6b95121 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -666,6 +666,7 @@ struct mwifiex_private {
 	struct mwifiex_11h_intf_state state_11h;
 	struct mwifiex_ds_mem_rw mem_rw;
 	struct sk_buff_head bypass_txq;
+	struct mwifiex_user_scan_chan hidden_chan[MWIFIEX_USER_SCAN_CHAN_MAX];
 };
 
 
@@ -986,6 +987,7 @@ struct mwifiex_adapter {
 	u8 coex_tx_win_size;
 	u8 coex_rx_win_size;
 	bool drcs_enabled;
+	u8 active_scan_triggered;
 };
 
 void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index ef8da8e..5847863 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -527,7 +527,8 @@ mwifiex_scan_create_channel_list(struct mwifiex_private *priv,
 
 			if (ch->flags & IEEE80211_CHAN_NO_IR)
 				scan_chan_list[chan_idx].chan_scan_mode_bitmap
-					|= MWIFIEX_PASSIVE_SCAN;
+					|= (MWIFIEX_PASSIVE_SCAN |
+					    MWIFIEX_HIDDEN_SSID_REPORT);
 			else
 				scan_chan_list[chan_idx].chan_scan_mode_bitmap
 					&= ~MWIFIEX_PASSIVE_SCAN;
@@ -1049,7 +1050,8 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 			if (scan_type == MWIFIEX_SCAN_TYPE_PASSIVE)
 				(scan_chan_list +
 				 chan_idx)->chan_scan_mode_bitmap
-					|= MWIFIEX_PASSIVE_SCAN;
+					|= (MWIFIEX_PASSIVE_SCAN |
+					    MWIFIEX_HIDDEN_SSID_REPORT);
 			else
 				(scan_chan_list +
 				 chan_idx)->chan_scan_mode_bitmap
@@ -1600,6 +1602,62 @@ int mwifiex_check_network_compatibility(struct mwifiex_private *priv,
 	return ret;
 }
 
+/* This function checks if SSID string contains all zeroes or length is zero */
+static bool mwifiex_is_hidden_ssid(struct cfg80211_ssid *ssid)
+{
+	int idx;
+
+	for (idx = 0; idx < ssid->ssid_len; idx++) {
+		if (ssid->ssid[idx])
+			return false;
+	}
+
+	return true;
+}
+
+/* This function checks if any hidden SSID found in passive scan channels
+ * and save those channels for specific SSID active scan
+ */
+static int mwifiex_save_hidden_ssid_channels(struct mwifiex_private *priv,
+					     struct cfg80211_bss *bss)
+{
+	struct mwifiex_bssdescriptor *bss_desc;
+	int ret;
+	int chid;
+
+	/* Allocate and fill new bss descriptor */
+	bss_desc = kzalloc(sizeof(*bss_desc), GFP_KERNEL);
+	if (!bss_desc)
+		return -ENOMEM;
+
+	ret = mwifiex_fill_new_bss_desc(priv, bss, bss_desc);
+	if (ret)
+		goto done;
+
+	if (mwifiex_is_hidden_ssid(&bss_desc->ssid)) {
+		mwifiex_dbg(priv->adapter, INFO, "found hidden SSID\n");
+		for (chid = 0 ; chid < MWIFIEX_USER_SCAN_CHAN_MAX; chid++) {
+			if (priv->hidden_chan[chid].chan_number ==
+			    bss->channel->hw_value)
+				break;
+
+			if (!priv->hidden_chan[chid].chan_number) {
+				priv->hidden_chan[chid].chan_number =
+					bss->channel->hw_value;
+				priv->hidden_chan[chid].radio_type =
+					bss->channel->band;
+				priv->hidden_chan[chid].scan_type =
+					MWIFIEX_SCAN_TYPE_ACTIVE;
+				break;
+			}
+		}
+	}
+
+done:
+	kfree(bss_desc);
+	return 0;
+}
+
 static int mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
 					  struct cfg80211_bss *bss)
 {
@@ -1789,6 +1847,14 @@ mwifiex_parse_single_response_buf(struct mwifiex_private *priv, u8 **bss_info,
 				    .mac_address, ETH_ALEN))
 				mwifiex_update_curr_bss_params(priv, bss);
 			cfg80211_put_bss(priv->wdev.wiphy, bss);
+
+			if ((chan->flags & IEEE80211_CHAN_RADAR) ||
+			    (chan->flags & IEEE80211_CHAN_NO_IR)) {
+				mwifiex_dbg(adapter, INFO,
+					    "radar or passive channel %d\n",
+					    channel);
+				mwifiex_save_hidden_ssid_channels(priv, bss);
+			}
 		}
 	} else {
 		mwifiex_dbg(adapter, WARN, "missing BSS channel IE\n");
@@ -1812,6 +1878,57 @@ static void mwifiex_complete_scan(struct mwifiex_private *priv)
 	}
 }
 
+/* This function checks if any hidden SSID found in passive scan channels
+ * and do specific SSID active scan for those channels
+ */
+static int
+mwifiex_active_scan_req_for_passive_chan(struct mwifiex_private *priv)
+{
+	int ret;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u8 id = 0;
+	struct mwifiex_user_scan_cfg  *user_scan_cfg;
+
+	if (adapter->active_scan_triggered) {
+		adapter->active_scan_triggered = false;
+		return 0;
+	}
+
+	if (!priv->hidden_chan[0].chan_number) {
+		mwifiex_dbg(adapter, INFO, "No BSS with hidden SSID found on DFS channels\n");
+		return 0;
+	}
+	user_scan_cfg = kzalloc(sizeof(*user_scan_cfg), GFP_KERNEL);
+
+	if (!user_scan_cfg)
+		return -ENOMEM;
+
+	memset(user_scan_cfg, 0, sizeof(*user_scan_cfg));
+
+	for (id = 0; id < MWIFIEX_USER_SCAN_CHAN_MAX; id++) {
+		if (!priv->hidden_chan[id].chan_number)
+			break;
+		memcpy(&user_scan_cfg->chan_list[id],
+		       &priv->hidden_chan[id],
+		       sizeof(struct mwifiex_user_scan_chan));
+	}
+
+	adapter->active_scan_triggered = true;
+	user_scan_cfg->num_ssids = priv->scan_request->n_ssids;
+	user_scan_cfg->ssid_list = priv->scan_request->ssids;
+
+	ret = mwifiex_scan_networks(priv, user_scan_cfg);
+	kfree(user_scan_cfg);
+
+	memset(&priv->hidden_chan, 0, sizeof(priv->hidden_chan));
+
+	if (ret) {
+		dev_err(priv->adapter->dev, "scan failed: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
 static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
@@ -1825,6 +1942,8 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 		adapter->scan_processing = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
+		mwifiex_active_scan_req_for_passive_chan(priv);
+
 		if (!adapter->ext_scan)
 			mwifiex_complete_scan(priv);
 
@@ -1851,15 +1970,17 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 		adapter->scan_processing = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
-		if (priv->scan_request) {
-			mwifiex_dbg(adapter, INFO,
-				    "info: aborting scan\n");
-			cfg80211_scan_done(priv->scan_request, 1);
-			priv->scan_request = NULL;
-		} else {
-			priv->scan_aborting = false;
-			mwifiex_dbg(adapter, INFO,
-				    "info: scan already aborted\n");
+		if (!adapter->active_scan_triggered) {
+			if (priv->scan_request) {
+				mwifiex_dbg(adapter, INFO,
+					    "info: aborting scan\n");
+				cfg80211_scan_done(priv->scan_request, 1);
+				priv->scan_request = NULL;
+			} else {
+				priv->scan_aborting = false;
+				mwifiex_dbg(adapter, INFO,
+					    "info: scan already aborted\n");
+			}
 		}
 	} else {
 		/* Get scan command from scan_pending_q and put to
-- 
1.8.1.4

