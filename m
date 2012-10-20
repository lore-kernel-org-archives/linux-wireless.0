Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:42744 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758016Ab2JTCUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 22:20:30 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/7] mwifiex: abort scan upon interface down
Date: Fri, 19 Oct 2012 19:19:16 -0700
Message-Id: <1350699561-852-3-git-send-email-bzhao@marvell.com> (sfid-20121020_042033_200559_B1D6A941)
In-Reply-To: <1350699561-852-1-git-send-email-bzhao@marvell.com>
References: <1350699561-852-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

When the interface is down, we will abort scan by calling
cfg80211_scan_done() with abort option. This fixes WARN_ON
triggered by cfg80211 in wdev_cleanup_work().

Driver's internal variables/flags are cleared once we get
response for current scan command. Meanwhile we will block
new scan request from cfg80211.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    5 +++++
 drivers/net/wireless/mwifiex/init.c     |   14 ++++++++++----
 drivers/net/wireless/mwifiex/main.c     |    8 ++++++++
 drivers/net/wireless/mwifiex/scan.c     |   25 +++++++++++++++++++------
 4 files changed, 42 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 234ee1e..9c8d0b7 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1826,6 +1826,11 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 		return -EBUSY;
 	}
 
+	if (priv->user_scan_cfg) {
+		dev_err(priv->adapter->dev, "cmd: Scan already in process..\n");
+		return -EBUSY;
+	}
+
 	priv->user_scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg),
 				      GFP_KERNEL);
 	if (!priv->user_scan_cfg) {
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index b5d37a8..37f2d95 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -84,10 +84,16 @@ static void scan_delay_timer_fn(unsigned long data)
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
 		if (priv->user_scan_cfg) {
-			dev_dbg(priv->adapter->dev,
-				"info: %s: scan aborted\n", __func__);
-			cfg80211_scan_done(priv->scan_request, 1);
-			priv->scan_request = NULL;
+			if (priv->scan_request) {
+				dev_dbg(priv->adapter->dev,
+					"info: aborting scan\n");
+				cfg80211_scan_done(priv->scan_request, 1);
+				priv->scan_request = NULL;
+			} else {
+				dev_dbg(priv->adapter->dev,
+					"info: scan already aborted\n");
+			}
+
 			kfree(priv->user_scan_cfg);
 			priv->user_scan_cfg = NULL;
 		}
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index eb22dd2..1df767b 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -472,6 +472,14 @@ mwifiex_open(struct net_device *dev)
 static int
 mwifiex_close(struct net_device *dev)
 {
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+
+	if (priv->scan_request) {
+		dev_dbg(priv->adapter->dev, "aborting scan on ndo_stop\n");
+		cfg80211_scan_done(priv->scan_request, 1);
+		priv->scan_request = NULL;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index b99f47b..8137dfc 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1768,16 +1768,29 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		}
 
 		if (priv->user_scan_cfg) {
-			dev_dbg(priv->adapter->dev,
-				"info: %s: sending scan results\n", __func__);
-			cfg80211_scan_done(priv->scan_request, 0);
-			priv->scan_request = NULL;
+			if (priv->scan_request) {
+				dev_dbg(priv->adapter->dev,
+					"info: notifying scan done\n");
+				cfg80211_scan_done(priv->scan_request, 0);
+				priv->scan_request = NULL;
+			} else {
+				dev_dbg(priv->adapter->dev,
+					"info: scan already aborted\n");
+			}
+
 			kfree(priv->user_scan_cfg);
 			priv->user_scan_cfg = NULL;
 		}
 	} else {
-		if (!mwifiex_wmm_lists_empty(adapter) &&
-		    (priv->scan_request && (priv->scan_request->flags &
+		if (priv->user_scan_cfg && !priv->scan_request) {
+			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
+					       flags);
+			adapter->scan_delay_cnt = MWIFIEX_MAX_SCAN_DELAY_CNT;
+			mod_timer(&priv->scan_delay_timer, jiffies);
+			dev_dbg(priv->adapter->dev,
+				"info: %s: triggerring scan abort\n", __func__);
+		} else if (!mwifiex_wmm_lists_empty(adapter) &&
+			   (priv->scan_request && (priv->scan_request->flags &
 					    NL80211_SCAN_FLAG_LOW_PRIORITY))) {
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
-- 
1.7.0.2

