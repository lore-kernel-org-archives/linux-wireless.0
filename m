Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:44086 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759449Ab2JTCDK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 22:03:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.7 1/2] mwifiex: return -EBUSY if specific scan request cannot be honored
Date: Fri, 19 Oct 2012 19:01:59 -0700
Message-Id: <1350698520-522-1-git-send-email-bzhao@marvell.com> (sfid-20121020_040322_184529_3D92CBA8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previous patch "mwifiex: return -EBUSY if scan request cannot.."
corrected regular scan request only. There is another case for
specific scan that needs the same handling.

Also, removed !req_ssid check as it has already been validated
by caller.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Paul Stewart <pstew@chromium.org>
Reviewed-by: Ryan Cairns <rtc@chromium.org>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 5896b1f..fe05684 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1846,21 +1846,18 @@ static int mwifiex_scan_specific_ssid(struct mwifiex_private *priv,
 				      struct cfg80211_ssid *req_ssid)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	int ret = 0;
+	int ret;
 	struct mwifiex_user_scan_cfg *scan_cfg;
 
-	if (!req_ssid)
-		return -1;
-
 	if (adapter->scan_processing) {
-		dev_dbg(adapter->dev, "cmd: Scan already in process...\n");
-		return ret;
+		dev_err(adapter->dev, "cmd: Scan already in process...\n");
+		return -EBUSY;
 	}
 
 	if (priv->scan_block) {
-		dev_dbg(adapter->dev,
+		dev_err(adapter->dev,
 			"cmd: Scan is blocked during association...\n");
-		return ret;
+		return -EBUSY;
 	}
 
 	scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg), GFP_KERNEL);
-- 
1.7.0.2

