Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:40544 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755620Ab3ENBSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 21:18:00 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@laptop.org>, Paul Fox <pgf@laptop.org>,
	Tim Shepard <shep@laptop.org>,
	Jason Abele <jabele@chromium.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 03/17] mwifiex: remove global user_scan_cfg variable
Date: Mon, 13 May 2013 18:14:47 -0700
Message-ID: <1368494101-23651-4-git-send-email-bzhao@marvell.com> (sfid-20130514_031805_559817_48CAB484)
In-Reply-To: <1368494101-23651-1-git-send-email-bzhao@marvell.com>
References: <1368494101-23651-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

As the variable is used only for preparation of internal scan
commands, we don't need to keep it allocated until the entire
scan completes. We will define it as a local variable and free
immediately after it's use.

New flag 'scan_aborting' is added to handle race between
mwifiex_close() and scan handler. Previously user_scan_cfg
pointer used to take care of this.

This patch fixes a memory leak in mwifiex_cfg80211_scan after
running "iwlist mlan0 scan & sleep 1; rmmod mwifiex_sdio".

Reported-by: Daniel Drake <dsd@laptop.org>
Tested-by: Daniel Drake <dsd@laptop.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c | 31 +++++++++++++++++--------------
 drivers/net/wireless/mwifiex/init.c     | 20 +++++++-------------
 drivers/net/wireless/mwifiex/main.c     |  1 +
 drivers/net/wireless/mwifiex/main.h     |  2 +-
 drivers/net/wireless/mwifiex/scan.c     | 22 ++++++++--------------
 5 files changed, 34 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index e42b266..e493f89 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1859,6 +1859,7 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 	int i, offset, ret;
 	struct ieee80211_channel *chan;
 	struct ieee_types_header *ie;
+	struct mwifiex_user_scan_cfg *user_scan_cfg;
 
 	wiphy_dbg(wiphy, "info: received scan request on %s\n", dev->name);
 
@@ -1869,20 +1870,22 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 		return -EBUSY;
 	}
 
-	if (priv->user_scan_cfg) {
+	/* Block scan request if scan operation or scan cleanup when interface
+	 * is disabled is in process
+	 */
+	if (priv->scan_request || priv->scan_aborting) {
 		dev_err(priv->adapter->dev, "cmd: Scan already in process..\n");
 		return -EBUSY;
 	}
 
-	priv->user_scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg),
-				      GFP_KERNEL);
-	if (!priv->user_scan_cfg)
+	user_scan_cfg = kzalloc(sizeof(*user_scan_cfg), GFP_KERNEL);
+	if (!user_scan_cfg)
 		return -ENOMEM;
 
 	priv->scan_request = request;
 
-	priv->user_scan_cfg->num_ssids = request->n_ssids;
-	priv->user_scan_cfg->ssid_list = request->ssids;
+	user_scan_cfg->num_ssids = request->n_ssids;
+	user_scan_cfg->ssid_list = request->ssids;
 
 	if (request->ie && request->ie_len) {
 		offset = 0;
@@ -1902,25 +1905,25 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 	for (i = 0; i < min_t(u32, request->n_channels,
 			      MWIFIEX_USER_SCAN_CHAN_MAX); i++) {
 		chan = request->channels[i];
-		priv->user_scan_cfg->chan_list[i].chan_number = chan->hw_value;
-		priv->user_scan_cfg->chan_list[i].radio_type = chan->band;
+		user_scan_cfg->chan_list[i].chan_number = chan->hw_value;
+		user_scan_cfg->chan_list[i].radio_type = chan->band;
 
 		if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-			priv->user_scan_cfg->chan_list[i].scan_type =
+			user_scan_cfg->chan_list[i].scan_type =
 						MWIFIEX_SCAN_TYPE_PASSIVE;
 		else
-			priv->user_scan_cfg->chan_list[i].scan_type =
+			user_scan_cfg->chan_list[i].scan_type =
 						MWIFIEX_SCAN_TYPE_ACTIVE;
 
-		priv->user_scan_cfg->chan_list[i].scan_time = 0;
+		user_scan_cfg->chan_list[i].scan_time = 0;
 	}
 
-	ret = mwifiex_scan_networks(priv, priv->user_scan_cfg);
+	ret = mwifiex_scan_networks(priv, user_scan_cfg);
+	kfree(user_scan_cfg);
 	if (ret) {
 		dev_err(priv->adapter->dev, "scan failed: %d\n", ret);
+		priv->scan_aborting = false;
 		priv->scan_request = NULL;
-		kfree(priv->user_scan_cfg);
-		priv->user_scan_cfg = NULL;
 		return ret;
 	}
 
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 71bbf12..1343725f 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -81,19 +81,13 @@ static void scan_delay_timer_fn(unsigned long data)
 		adapter->empty_tx_q_cnt = 0;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
-		if (priv->user_scan_cfg) {
-			if (priv->scan_request) {
-				dev_dbg(priv->adapter->dev,
-					"info: aborting scan\n");
-				cfg80211_scan_done(priv->scan_request, 1);
-				priv->scan_request = NULL;
-			} else {
-				dev_dbg(priv->adapter->dev,
-					"info: scan already aborted\n");
-			}
-
-			kfree(priv->user_scan_cfg);
-			priv->user_scan_cfg = NULL;
+		if (priv->scan_request) {
+			dev_dbg(adapter->dev, "info: aborting scan\n");
+			cfg80211_scan_done(priv->scan_request, 1);
+			priv->scan_request = NULL;
+		} else {
+			priv->scan_aborting = false;
+			dev_dbg(adapter->dev, "info: scan already aborted\n");
 		}
 		goto done;
 	}
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 2eb88ea..4e7270c 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -436,6 +436,7 @@ mwifiex_close(struct net_device *dev)
 		dev_dbg(priv->adapter->dev, "aborting scan on ndo_stop\n");
 		cfg80211_scan_done(priv->scan_request, 1);
 		priv->scan_request = NULL;
+		priv->scan_aborting = true;
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 4ef67fc..81251d9 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -492,7 +492,6 @@ struct mwifiex_private {
 	struct semaphore async_sem;
 	u8 report_scan_result;
 	struct cfg80211_scan_request *scan_request;
-	struct mwifiex_user_scan_cfg *user_scan_cfg;
 	u8 cfg_bssid[6];
 	struct wps wps;
 	u8 scan_block;
@@ -510,6 +509,7 @@ struct mwifiex_private {
 	u8 ap_11ac_enabled;
 	u32 mgmt_frame_mask;
 	struct mwifiex_roc_cfg roc_cfg;
+	bool scan_aborting;
 };
 
 enum mwifiex_ba_status {
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 9cf5d8f..7b2566b 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1784,22 +1784,16 @@ check_next_scan:
 		if (priv->report_scan_result)
 			priv->report_scan_result = false;
 
-		if (priv->user_scan_cfg) {
-			if (priv->scan_request) {
-				dev_dbg(priv->adapter->dev,
-					"info: notifying scan done\n");
-				cfg80211_scan_done(priv->scan_request, 0);
-				priv->scan_request = NULL;
-			} else {
-				dev_dbg(priv->adapter->dev,
-					"info: scan already aborted\n");
-			}
-
-			kfree(priv->user_scan_cfg);
-			priv->user_scan_cfg = NULL;
+		if (priv->scan_request) {
+			dev_dbg(adapter->dev, "info: notifying scan done\n");
+			cfg80211_scan_done(priv->scan_request, 0);
+			priv->scan_request = NULL;
+		} else {
+			priv->scan_aborting = false;
+			dev_dbg(adapter->dev, "info: scan already aborted\n");
 		}
 	} else {
-		if (priv->user_scan_cfg && !priv->scan_request) {
+		if (priv->scan_aborting && !priv->scan_request) {
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
 			adapter->scan_delay_cnt = MWIFIEX_MAX_SCAN_DELAY_CNT;
-- 
1.8.2.3

