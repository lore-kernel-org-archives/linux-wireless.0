Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:58079 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab1CKAWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 19:22:45 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] mwifiex: use dynamic allocation for large size structure
Date: Thu, 10 Mar 2011 16:25:47 -0800
Message-Id: <1299803149-25996-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1299803149-25996-1-git-send-email-bzhao@marvell.com>
References: <1299803149-25996-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

'make checkstack' found:
0x0000f9ee mwifiex_cfg80211_results [mwifiex]:    760

struct mwifiex_user_scan_cfg has big array inside.
Change the code to use kzalloc so that mwifiex_cfg80211_results()
routine uses less than 512 bytes on the stack.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 6aa5962..d34c622 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1453,32 +1453,38 @@ mwifiex_cfg80211_results(struct work_struct *work)
 {
 	struct mwifiex_private *priv =
 		container_of(work, struct mwifiex_private, cfg_workqueue);
-	struct mwifiex_user_scan_cfg scan_req;
+	struct mwifiex_user_scan_cfg *scan_req;
 	int ret = 0, i;
 	struct ieee80211_channel *chan;
 
 	if (priv->scan_request) {
-		memset(&scan_req, 0x00, sizeof(scan_req));
+		scan_req = kzalloc(sizeof(struct mwifiex_user_scan_cfg),
+				   GFP_KERNEL);
+		if (!scan_req) {
+			dev_err(priv->adapter->dev, "failed to alloc "
+						    "scan_req\n");
+			return;
+		}
 		for (i = 0; i < priv->scan_request->n_ssids; i++) {
-			memcpy(scan_req.ssid_list[i].ssid,
+			memcpy(scan_req->ssid_list[i].ssid,
 					priv->scan_request->ssids[i].ssid,
 					priv->scan_request->ssids[i].ssid_len);
-			scan_req.ssid_list[i].max_len =
+			scan_req->ssid_list[i].max_len =
 					priv->scan_request->ssids[i].ssid_len;
 		}
 		for (i = 0; i < priv->scan_request->n_channels; i++) {
 			chan = priv->scan_request->channels[i];
-			scan_req.chan_list[i].chan_number = chan->hw_value;
-			scan_req.chan_list[i].radio_type = chan->band;
+			scan_req->chan_list[i].chan_number = chan->hw_value;
+			scan_req->chan_list[i].radio_type = chan->band;
 			if (chan->flags & IEEE80211_CHAN_DISABLED)
-				scan_req.chan_list[i].scan_type =
+				scan_req->chan_list[i].scan_type =
 					MWIFIEX_SCAN_TYPE_PASSIVE;
 			else
-				scan_req.chan_list[i].scan_type =
+				scan_req->chan_list[i].scan_type =
 					MWIFIEX_SCAN_TYPE_ACTIVE;
-			scan_req.chan_list[i].scan_time = 0;
+			scan_req->chan_list[i].scan_time = 0;
 		}
-		if (mwifiex_set_user_scan_ioctl(priv, &scan_req)) {
+		if (mwifiex_set_user_scan_ioctl(priv, scan_req)) {
 			ret = -EFAULT;
 			goto done;
 		}
@@ -1491,6 +1497,7 @@ done:
 		cfg80211_scan_done(priv->scan_request,
 				(priv->scan_result_status < 0));
 		priv->scan_request = NULL;
+		kfree(scan_req);
 	}
 
 	if (priv->assoc_request) {
-- 
1.7.0.2

