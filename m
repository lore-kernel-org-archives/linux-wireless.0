Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:59468 "HELO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1754134Ab1LNEoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 23:44:06 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove cfg_workqueue
Date: Tue, 13 Dec 2011 20:43:17 -0800
Message-Id: <1323837797-32547-2-git-send-email-bzhao@marvell.com> (sfid-20111214_054410_771245_81ED22BD)
In-Reply-To: <1323837797-32547-1-git-send-email-bzhao@marvell.com>
References: <1323837797-32547-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

cfg_workqueue was added to notify cfg80211 that scan, connect
or disconnect is done by calling respective completion handlers.
We can avoid use of this workqueue by calling those handlers
from other places.
1) Call connect, disconnect completion handlers in their callback
   functions.
   ex. Call cfg80211_connect_result() in mwifiex_cfg80211_connect()
2) Call scan completion handler after parsing response of last scan
   command in a queue.

After removing the workqueue, variables (assoc_request etc.) and
checks used for mutual exclusion become redundant. Those are also
removed in this patch.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c  |  191 +++++++++---------------------
 drivers/net/wireless/mwifiex/cfg80211.h  |    1 -
 drivers/net/wireless/mwifiex/main.c      |    2 -
 drivers/net/wireless/mwifiex/main.h      |    9 +--
 drivers/net/wireless/mwifiex/scan.c      |   13 ++-
 drivers/net/wireless/mwifiex/sta_event.c |   17 ++--
 6 files changed, 75 insertions(+), 158 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index ffd293e..787dbe2 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -751,17 +751,13 @@ mwifiex_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
-	if (priv->disconnect)
-		return -EBUSY;
-
-	priv->disconnect = 1;
 	if (mwifiex_deauthenticate(priv, NULL))
 		return -EFAULT;
 
 	wiphy_dbg(wiphy, "info: successfully disconnected from %pM:"
 		" reason code %d\n", priv->cfg_bssid, reason_code);
 
-	queue_work(priv->workqueue, &priv->cfg_workqueue);
+	memset(priv->cfg_bssid, 0, ETH_ALEN);
 
 	return 0;
 }
@@ -981,27 +977,32 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	int ret = 0;
 
-	if (priv->assoc_request)
-		return -EBUSY;
-
 	if (priv->bss_mode == NL80211_IFTYPE_ADHOC) {
 		wiphy_err(wiphy, "received infra assoc request "
 				"when station is in ibss mode\n");
 		goto done;
 	}
 
-	priv->assoc_request = -EINPROGRESS;
-
 	wiphy_dbg(wiphy, "info: Trying to associate to %s and bssid %pM\n",
 	       (char *) sme->ssid, sme->bssid);
 
 	ret = mwifiex_cfg80211_assoc(priv, sme->ssid_len, sme->ssid, sme->bssid,
 				     priv->bss_mode, sme->channel, sme, 0);
-
-	priv->assoc_request = 1;
 done:
-	priv->assoc_result = ret;
-	queue_work(priv->workqueue, &priv->cfg_workqueue);
+	if (!ret) {
+		cfg80211_connect_result(priv->netdev, priv->cfg_bssid, NULL, 0,
+					NULL, 0, WLAN_STATUS_SUCCESS,
+					GFP_KERNEL);
+		dev_dbg(priv->adapter->dev,
+			"info: associated to bssid %pM successfully\n",
+			priv->cfg_bssid);
+	} else {
+		dev_dbg(priv->adapter->dev,
+			"info: association to bssid %pM failed\n",
+			priv->cfg_bssid);
+		memset(priv->cfg_bssid, 0, ETH_ALEN);
+	}
+
 	return ret;
 }
 
@@ -1018,28 +1019,29 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 	int ret = 0;
 
-	if (priv->ibss_join_request)
-		return -EBUSY;
-
 	if (priv->bss_mode != NL80211_IFTYPE_ADHOC) {
 		wiphy_err(wiphy, "request to join ibss received "
 				"when station is not in ibss mode\n");
 		goto done;
 	}
 
-	priv->ibss_join_request = -EINPROGRESS;
-
 	wiphy_dbg(wiphy, "info: trying to join to %s and bssid %pM\n",
 	       (char *) params->ssid, params->bssid);
 
 	ret = mwifiex_cfg80211_assoc(priv, params->ssid_len, params->ssid,
 				params->bssid, priv->bss_mode,
 				params->channel, NULL, params->privacy);
-
-	priv->ibss_join_request = 1;
 done:
-	priv->ibss_join_result = ret;
-	queue_work(priv->workqueue, &priv->cfg_workqueue);
+	if (!ret) {
+		cfg80211_ibss_joined(priv->netdev, priv->cfg_bssid, GFP_KERNEL);
+		dev_dbg(priv->adapter->dev,
+			"info: joined/created adhoc network with bssid"
+			" %pM successfully\n", priv->cfg_bssid);
+	} else {
+		dev_dbg(priv->adapter->dev,
+			"info: failed creating/joining adhoc network\n");
+	}
+
 	return ret;
 }
 
@@ -1054,17 +1056,12 @@ mwifiex_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 {
 	struct mwifiex_private *priv = mwifiex_cfg80211_get_priv(wiphy);
 
-	if (priv->disconnect)
-		return -EBUSY;
-
-	priv->disconnect = 1;
-
 	wiphy_dbg(wiphy, "info: disconnecting from essid %pM\n",
 			priv->cfg_bssid);
 	if (mwifiex_deauthenticate(priv, NULL))
 		return -EFAULT;
 
-	queue_work(priv->workqueue, &priv->cfg_workqueue);
+	memset(priv->cfg_bssid, 0, ETH_ALEN);
 
 	return 0;
 }
@@ -1081,15 +1078,42 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy, struct net_device *dev,
 		      struct cfg80211_scan_request *request)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	int i;
+	struct ieee80211_channel *chan;
 
 	wiphy_dbg(wiphy, "info: received scan request on %s\n", dev->name);
 
-	if (priv->scan_request && priv->scan_request != request)
-		return -EBUSY;
-
 	priv->scan_request = request;
 
-	queue_work(priv->workqueue, &priv->cfg_workqueue);
+	priv->user_scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg),
+					GFP_KERNEL);
+	if (!priv->user_scan_cfg) {
+		dev_err(priv->adapter->dev, "failed to alloc scan_req\n");
+		return -ENOMEM;
+	}
+	for (i = 0; i < request->n_ssids; i++) {
+		memcpy(priv->user_scan_cfg->ssid_list[i].ssid,
+			request->ssids[i].ssid, request->ssids[i].ssid_len);
+		priv->user_scan_cfg->ssid_list[i].max_len =
+			request->ssids[i].ssid_len;
+	}
+	for (i = 0; i < request->n_channels; i++) {
+		chan = request->channels[i];
+		priv->user_scan_cfg->chan_list[i].chan_number = chan->hw_value;
+		priv->user_scan_cfg->chan_list[i].radio_type = chan->band;
+
+		if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
+			priv->user_scan_cfg->chan_list[i].scan_type =
+				MWIFIEX_SCAN_TYPE_PASSIVE;
+		else
+			priv->user_scan_cfg->chan_list[i].scan_type =
+				MWIFIEX_SCAN_TYPE_ACTIVE;
+
+		priv->user_scan_cfg->chan_list[i].scan_time = 0;
+	}
+	if (mwifiex_set_user_scan_ioctl(priv, priv->user_scan_cfg))
+		return -EFAULT;
+
 	return 0;
 }
 
@@ -1295,10 +1319,6 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct net_device *dev)
 
 	priv->media_connected = false;
 
-	cancel_work_sync(&priv->cfg_workqueue);
-	flush_workqueue(priv->workqueue);
-	destroy_workqueue(priv->workqueue);
-
 	priv->bss_mode = NL80211_IFTYPE_UNSPECIFIED;
 
 	return 0;
@@ -1404,100 +1424,3 @@ int mwifiex_register_cfg80211(struct mwifiex_private *priv)
 
 	return ret;
 }
-
-/*
- * This function handles the result of different pending network operations.
- *
- * The following operations are handled and CFG802.11 subsystem is
- * notified accordingly -
- *      - Scan request completion
- *      - Association request completion
- *      - IBSS join request completion
- *      - Disconnect request completion
- */
-void
-mwifiex_cfg80211_results(struct work_struct *work)
-{
-	struct mwifiex_private *priv =
-		container_of(work, struct mwifiex_private, cfg_workqueue);
-	struct mwifiex_user_scan_cfg *scan_req;
-	int ret = 0, i;
-	struct ieee80211_channel *chan;
-
-	if (priv->scan_request) {
-		scan_req = kzalloc(sizeof(struct mwifiex_user_scan_cfg),
-				   GFP_KERNEL);
-		if (!scan_req) {
-			dev_err(priv->adapter->dev, "failed to alloc "
-						    "scan_req\n");
-			return;
-		}
-		for (i = 0; i < priv->scan_request->n_ssids; i++) {
-			memcpy(scan_req->ssid_list[i].ssid,
-					priv->scan_request->ssids[i].ssid,
-					priv->scan_request->ssids[i].ssid_len);
-			scan_req->ssid_list[i].max_len =
-					priv->scan_request->ssids[i].ssid_len;
-		}
-		for (i = 0; i < priv->scan_request->n_channels; i++) {
-			chan = priv->scan_request->channels[i];
-			scan_req->chan_list[i].chan_number = chan->hw_value;
-			scan_req->chan_list[i].radio_type = chan->band;
-			if (chan->flags & IEEE80211_CHAN_DISABLED)
-				scan_req->chan_list[i].scan_type =
-					MWIFIEX_SCAN_TYPE_PASSIVE;
-			else
-				scan_req->chan_list[i].scan_type =
-					MWIFIEX_SCAN_TYPE_ACTIVE;
-			scan_req->chan_list[i].scan_time = 0;
-		}
-		if (mwifiex_set_user_scan_ioctl(priv, scan_req))
-			ret = -EFAULT;
-		priv->scan_result_status = ret;
-		dev_dbg(priv->adapter->dev, "info: %s: sending scan results\n",
-							__func__);
-		cfg80211_scan_done(priv->scan_request,
-				(priv->scan_result_status < 0));
-		priv->scan_request = NULL;
-		kfree(scan_req);
-	}
-
-	if (priv->assoc_request == 1) {
-		if (!priv->assoc_result) {
-			cfg80211_connect_result(priv->netdev, priv->cfg_bssid,
-						NULL, 0, NULL, 0,
-						WLAN_STATUS_SUCCESS,
-						GFP_KERNEL);
-			dev_dbg(priv->adapter->dev,
-				"info: associated to bssid %pM successfully\n",
-			       priv->cfg_bssid);
-		} else {
-			dev_dbg(priv->adapter->dev,
-				"info: association to bssid %pM failed\n",
-			       priv->cfg_bssid);
-			memset(priv->cfg_bssid, 0, ETH_ALEN);
-		}
-		priv->assoc_request = 0;
-		priv->assoc_result = 0;
-	}
-
-	if (priv->ibss_join_request == 1) {
-		if (!priv->ibss_join_result) {
-			cfg80211_ibss_joined(priv->netdev, priv->cfg_bssid,
-					     GFP_KERNEL);
-			dev_dbg(priv->adapter->dev,
-				"info: joined/created adhoc network with bssid"
-					" %pM successfully\n", priv->cfg_bssid);
-		} else {
-			dev_dbg(priv->adapter->dev,
-				"info: failed creating/joining adhoc network\n");
-		}
-		priv->ibss_join_request = 0;
-		priv->ibss_join_result = 0;
-	}
-
-	if (priv->disconnect) {
-		memset(priv->cfg_bssid, 0, ETH_ALEN);
-		priv->disconnect = 0;
-	}
-}
diff --git a/drivers/net/wireless/mwifiex/cfg80211.h b/drivers/net/wireless/mwifiex/cfg80211.h
index 8d010f2..76c76c6 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.h
+++ b/drivers/net/wireless/mwifiex/cfg80211.h
@@ -26,5 +26,4 @@
 
 int mwifiex_register_cfg80211(struct mwifiex_private *);
 
-void mwifiex_cfg80211_results(struct work_struct *work);
 #endif
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index d21cd47..84be196 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -586,8 +586,6 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 	priv->media_connected = false;
 	memset(&priv->nick_name, 0, sizeof(priv->nick_name));
 	priv->num_tx_timeout = 0;
-	priv->workqueue = create_singlethread_workqueue("cfg80211_wq");
-	INIT_WORK(&priv->cfg_workqueue, mwifiex_cfg80211_results);
 	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
 }
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 41f8863..9207fc6 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -453,15 +453,8 @@ struct mwifiex_private {
 	u8 scan_pending_on_block;
 	u8 report_scan_result;
 	struct cfg80211_scan_request *scan_request;
-	int scan_result_status;
-	int assoc_request;
-	u16 assoc_result;
-	int ibss_join_request;
-	u16 ibss_join_result;
-	bool disconnect;
+	struct mwifiex_user_scan_cfg *user_scan_cfg;
 	u8 cfg_bssid[6];
-	struct workqueue_struct *workqueue;
-	struct work_struct cfg_workqueue;
 	u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
 	struct wps wps;
 	u8 scan_block;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index b8b9d37..e2e7156 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1391,11 +1391,8 @@ int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 {
 	int status;
 
-	priv->adapter->scan_wait_q_woken = false;
-
 	status = mwifiex_scan_networks(priv, scan_req);
-	if (!status)
-		status = mwifiex_wait_queue_complete(priv->adapter);
+	queue_work(priv->adapter->workqueue, &priv->adapter->main_work);
 
 	return status;
 }
@@ -1796,6 +1793,14 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			up(&priv->async_sem);
 		}
 
+		if (priv->user_scan_cfg) {
+			dev_dbg(priv->adapter->dev, "info: %s: sending scan "
+							"results\n", __func__);
+			cfg80211_scan_done(priv->scan_request, 0);
+			priv->scan_request = NULL;
+			kfree(priv->user_scan_cfg);
+			priv->user_scan_cfg = NULL;
+		}
 	} else {
 		/* Get scan command from scan_pending_q and put to
 		   cmd_pending_q */
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 40205f6..d7aa21d 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -115,16 +115,15 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 	if (adapter->num_cmd_timeout && adapter->curr_cmd)
 		return;
 	priv->media_connected = false;
-	if (!priv->disconnect) {
-		priv->disconnect = 1;
-		dev_dbg(adapter->dev, "info: successfully disconnected from"
-				" %pM: reason code %d\n", priv->cfg_bssid,
-				WLAN_REASON_DEAUTH_LEAVING);
-		cfg80211_disconnected(priv->netdev,
-				WLAN_REASON_DEAUTH_LEAVING, NULL, 0,
-				GFP_KERNEL);
-		queue_work(priv->workqueue, &priv->cfg_workqueue);
+	dev_dbg(adapter->dev, "info: successfully disconnected from"
+			" %pM: reason code %d\n", priv->cfg_bssid,
+			WLAN_REASON_DEAUTH_LEAVING);
+	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
+		cfg80211_disconnected(priv->netdev, WLAN_REASON_DEAUTH_LEAVING,
+				      NULL, 0, GFP_KERNEL);
 	}
+	memset(priv->cfg_bssid, 0, ETH_ALEN);
+
 	if (!netif_queue_stopped(priv->netdev))
 		mwifiex_stop_net_dev_queue(priv->netdev, adapter);
 	if (netif_carrier_ok(priv->netdev))
-- 
1.7.0.2

