Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:56855 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753643Ab2IUDYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 23:24:32 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: block scan request during heavy Tx traffic
Date: Thu, 20 Sep 2012 20:23:18 -0700
Message-Id: <1348197798-977-2-git-send-email-bzhao@marvell.com> (sfid-20120921_052435_017625_D660CE61)
In-Reply-To: <1348197798-977-1-git-send-email-bzhao@marvell.com>
References: <1348197798-977-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently scan operation is delayed/aborted based on Tx traffic
consistency. This decision is taken after receiving scan
response of first scan command from FW. But when heavy traffic
is running, we can not even afford to send first scan command
and go off channel for 30msec. We will block scan request in
this case.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    6 ++++++
 drivers/net/wireless/mwifiex/main.h     |    2 ++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index b9f7b3e..aa61918 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1502,6 +1502,12 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 
 	wiphy_dbg(wiphy, "info: received scan request on %s\n", dev->name);
 
+	if (atomic_read(&priv->wmm.tx_pkts_queued) >=
+	    MWIFIEX_MIN_TX_PENDING_TO_CANCEL_SCAN) {
+		dev_dbg(priv->adapter->dev, "scan rejected due to traffic\n");
+		return -EBUSY;
+	}
+
 	priv->scan_request = request;
 
 	priv->user_scan_cfg = kzalloc(sizeof(struct mwifiex_user_scan_cfg),
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 12ceea4..92e57f6 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -91,6 +91,8 @@ enum {
 #define MWIFIEX_MAX_EMPTY_TX_Q_CNT			10
 #define MWIFIEX_SCAN_DELAY_MSEC				20
 
+#define MWIFIEX_MIN_TX_PENDING_TO_CANCEL_SCAN		2
+
 #define RSN_GTK_OUI_OFFSET				2
 
 #define MWIFIEX_OUI_NOT_PRESENT			0
-- 
1.7.0.2

