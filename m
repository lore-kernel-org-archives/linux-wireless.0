Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6675 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbcDRNnj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 09:43:39 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Wei-Ning Huang <wnhuang@chromium.org>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: stop background scan when net device closed
Date: Mon, 18 Apr 2016 06:42:55 -0700
Message-ID: <1460986975-2483-1-git-send-email-akarwar@marvell.com> (sfid-20160418_154342_385531_7195149A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Transmit data path should not touch background scan. We will stop
background scan when net device is closed.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index b459c70..8b67a55 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -702,6 +702,13 @@ mwifiex_close(struct net_device *dev)
 		priv->scan_aborting = true;
 	}
 
+	if (priv->sched_scanning) {
+		mwifiex_dbg(priv->adapter, INFO,
+			    "aborting bgscan on ndo_stop\n");
+		mwifiex_stop_bg_scan(priv);
+		cfg80211_sched_scan_stopped(priv->wdev.wiphy);
+	}
+
 	return 0;
 }
 
@@ -753,13 +760,6 @@ int mwifiex_queue_tx_pkt(struct mwifiex_private *priv, struct sk_buff *skb)
 
 	mwifiex_queue_main_work(priv->adapter);
 
-	if (priv->sched_scanning) {
-		mwifiex_dbg(priv->adapter, INFO,
-			    "aborting bgscan on ndo_stop\n");
-		mwifiex_stop_bg_scan(priv);
-		cfg80211_sched_scan_stopped(priv->wdev.wiphy);
-	}
-
 	return 0;
 }
 
-- 
1.8.1.4

