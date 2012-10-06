Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:37401 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734Ab2JFDWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 23:22:07 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.7 1/4] mwifiex: return -EBUSY if scan request cannot be honored
Date: Fri,  5 Oct 2012 20:21:40 -0700
Message-Id: <1349493703-1169-2-git-send-email-bzhao@marvell.com> (sfid-20121006_052216_762549_977A147D)
In-Reply-To: <1349493703-1169-1-git-send-email-bzhao@marvell.com>
References: <1349493703-1169-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are cases we cannot scan when request is received.
For example, during WPA group key negociation the scan request
will be blocked. We should return an error code to cfg80211
because cfg80211_scan_done will never be called.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Paul Stewart <pstew@chromium.org>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   10 +++++++---
 drivers/net/wireless/mwifiex/scan.c     |   18 +++++++++---------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 2691620..675247b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1802,7 +1802,7 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 {
 	struct net_device *dev = request->wdev->netdev;
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	int i, offset;
+	int i, offset, ret;
 	struct ieee80211_channel *chan;
 	struct ieee_types_header *ie;
 
@@ -1855,8 +1855,12 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 
 		priv->user_scan_cfg->chan_list[i].scan_time = 0;
 	}
-	if (mwifiex_scan_networks(priv, priv->user_scan_cfg))
-		return -EFAULT;
+
+	ret = mwifiex_scan_networks(priv, priv->user_scan_cfg);
+	if (ret) {
+		dev_err(priv->adapter->dev, "scan failed: %d\n", ret);
+		return ret;
+	}
 
 	if (request->ie && request->ie_len) {
 		for (i = 0; i < MWIFIEX_MAX_VSIE_NUM; i++) {
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index e36a759..bfb90a5 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1296,7 +1296,7 @@ mwifiex_radio_type_to_band(u8 radio_type)
 int mwifiex_scan_networks(struct mwifiex_private *priv,
 			  const struct mwifiex_user_scan_cfg *user_scan_in)
 {
-	int ret = 0;
+	int ret;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct cmd_ctrl_node *cmd_node;
 	union mwifiex_scan_cmd_config_tlv *scan_cfg_out;
@@ -1309,20 +1309,20 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 	unsigned long flags;
 
 	if (adapter->scan_processing) {
-		dev_dbg(adapter->dev, "cmd: Scan already in process...\n");
-		return ret;
+		dev_err(adapter->dev, "cmd: Scan already in process...\n");
+		return -EBUSY;
 	}
 
-	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
-	adapter->scan_processing = true;
-	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-
 	if (priv->scan_block) {
-		dev_dbg(adapter->dev,
+		dev_err(adapter->dev,
 			"cmd: Scan is blocked during association...\n");
-		return ret;
+		return -EBUSY;
 	}
 
+	spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+	adapter->scan_processing = true;
+	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+
 	scan_cfg_out = kzalloc(sizeof(union mwifiex_scan_cmd_config_tlv),
 								GFP_KERNEL);
 	if (!scan_cfg_out) {
-- 
1.7.0.2

