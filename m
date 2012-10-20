Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:43382 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759449Ab2JTCDO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 22:03:14 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.7 2/2] mwifiex: clean up scan state on error
Date: Fri, 19 Oct 2012 19:02:00 -0700
Message-Id: <1350698520-522-2-git-send-email-bzhao@marvell.com> (sfid-20121020_040322_803052_3E684F52)
In-Reply-To: <1350698520-522-1-git-send-email-bzhao@marvell.com>
References: <1350698520-522-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

De-reference and deallocate scan state on failure.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Paul Stewart <pstew@chromium.org>
Tested-by: Paul Stewart <pstew@chromium.org>
Reviewed-by: Ryan Cairns <rtc@chromium.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 38a5871..9aead8a 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1825,8 +1825,6 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 		return -EBUSY;
 	}
 
-	priv->scan_request = request;
-
 	priv->user_scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg),
 				      GFP_KERNEL);
 	if (!priv->user_scan_cfg) {
@@ -1834,6 +1832,8 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 		return -ENOMEM;
 	}
 
+	priv->scan_request = request;
+
 	priv->user_scan_cfg->num_ssids = request->n_ssids;
 	priv->user_scan_cfg->ssid_list = request->ssids;
 
@@ -1870,6 +1870,9 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 	ret = mwifiex_scan_networks(priv, priv->user_scan_cfg);
 	if (ret) {
 		dev_err(priv->adapter->dev, "scan failed: %d\n", ret);
+		priv->scan_request = NULL;
+		kfree(priv->user_scan_cfg);
+		priv->user_scan_cfg = NULL;
 		return ret;
 	}
 
-- 
1.7.0.2

