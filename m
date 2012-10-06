Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:58428 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170Ab2JFDWM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 23:22:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.7 2/4] mwifiex: reset scan_processing flag in failure cases
Date: Fri,  5 Oct 2012 20:21:41 -0700
Message-Id: <1349493703-1169-3-git-send-email-bzhao@marvell.com> (sfid-20121006_052217_386741_2F436F60)
In-Reply-To: <1349493703-1169-1-git-send-email-bzhao@marvell.com>
References: <1349493703-1169-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

scan_processing flag should be reset when scan request is failed
due to some reasons Ex. memory allocation failure etc. Otherwise
further scan requests will be blocked.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index bfb90a5..d9295fd 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1327,7 +1327,8 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 								GFP_KERNEL);
 	if (!scan_cfg_out) {
 		dev_err(adapter->dev, "failed to alloc scan_cfg_out\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto done;
 	}
 
 	buf_size = sizeof(struct mwifiex_chan_scan_param_set) *
@@ -1336,7 +1337,8 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 	if (!scan_chan_list) {
 		dev_err(adapter->dev, "failed to alloc scan_chan_list\n");
 		kfree(scan_cfg_out);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto done;
 	}
 
 	mwifiex_config_scan(priv, user_scan_in, &scan_cfg_out->config,
@@ -1364,14 +1366,16 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
 		}
-	} else {
-		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
-		adapter->scan_processing = true;
-		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 	}
 
 	kfree(scan_cfg_out);
 	kfree(scan_chan_list);
+done:
+	if (ret) {
+		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
+		adapter->scan_processing = false;
+		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
+	}
 	return ret;
 }
 
-- 
1.7.0.2

