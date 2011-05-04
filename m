Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:57127 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab1EDDHP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 23:07:15 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: fix simultaneous assoc and scan issue
Date: Tue,  3 May 2011 20:11:45 -0700
Message-Id: <1304478706-31673-1-git-send-email-bzhao@marvell.com> (sfid-20110504_050724_795684_42779908)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

When scan and assoc (infra/ibss) commands are simultaneously
given in two terminals, association response is erroneously
served while serving the scan response.

mwifiex_cfg80211_results() is the common routine for sending
ioctl (scan, assoc etc.) results to cfg80211 stack. In above
scenario even if the common routine is called for scan ioctl
context, it also tries to send information about assoc ioctl to
cfg80211 because "priv->assoc_request/priv->ibss_join_request"
flag is on at that time.

Fix the issue by updating request variable after assoc handling
and modifying the variable check in mwifiex_cfg80211_results.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   11 +++++++----
 drivers/net/wireless/mwifiex/main.h     |    4 ++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 98009e2..77a8029 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1044,7 +1044,7 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		goto done;
 	}
 
-	priv->assoc_request = 1;
+	priv->assoc_request = -EINPROGRESS;
 
 	wiphy_dbg(wiphy, "info: Trying to associate to %s and bssid %pM\n",
 	       (char *) sme->ssid, sme->bssid);
@@ -1052,6 +1052,7 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	ret = mwifiex_cfg80211_assoc(priv, sme->ssid_len, sme->ssid, sme->bssid,
 				     priv->bss_mode, sme->channel, sme, 0);
 
+	priv->assoc_request = 1;
 done:
 	priv->assoc_result = ret;
 	queue_work(priv->workqueue, &priv->cfg_workqueue);
@@ -1080,7 +1081,7 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 		goto done;
 	}
 
-	priv->ibss_join_request = 1;
+	priv->ibss_join_request = -EINPROGRESS;
 
 	wiphy_dbg(wiphy, "info: trying to join to %s and bssid %pM\n",
 	       (char *) params->ssid, params->bssid);
@@ -1088,6 +1089,8 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	ret = mwifiex_cfg80211_assoc(priv, params->ssid_len, params->ssid,
 				params->bssid, priv->bss_mode,
 				params->channel, NULL, params->privacy);
+
+	priv->ibss_join_request = 1;
 done:
 	priv->ibss_join_result = ret;
 	queue_work(priv->workqueue, &priv->cfg_workqueue);
@@ -1380,7 +1383,7 @@ done:
 		kfree(scan_req);
 	}
 
-	if (priv->assoc_request) {
+	if (priv->assoc_request == 1) {
 		if (!priv->assoc_result) {
 			cfg80211_connect_result(priv->netdev, priv->cfg_bssid,
 						NULL, 0, NULL, 0,
@@ -1399,7 +1402,7 @@ done:
 		priv->assoc_result = 0;
 	}
 
-	if (priv->ibss_join_request) {
+	if (priv->ibss_join_request == 1) {
 		if (!priv->ibss_join_result) {
 			cfg80211_ibss_joined(priv->netdev, priv->cfg_bssid,
 					     GFP_KERNEL);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 5043fcd..b4bb5ec 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -479,9 +479,9 @@ struct mwifiex_private {
 	u8 report_scan_result;
 	struct cfg80211_scan_request *scan_request;
 	int scan_result_status;
-	bool assoc_request;
+	int assoc_request;
 	u16 assoc_result;
-	bool ibss_join_request;
+	int ibss_join_request;
 	u16 ibss_join_result;
 	bool disconnect;
 	u8 cfg_bssid[6];
-- 
1.7.0.2

