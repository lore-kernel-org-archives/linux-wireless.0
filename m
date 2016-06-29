Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:61282 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674AbcF2MEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 08:04:09 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: fix scan_block flag handling
Date: Wed, 29 Jun 2016 17:32:40 +0530
Message-ID: <1467201760-12204-1-git-send-email-akarwar@marvell.com> (sfid-20160629_140412_824819_EEF4C42B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

scan_block flag is used to block scan operation when 4 way handshake
is in progress. Sometimes it doesn't get cleared due to incomplete
association. An example is assoc request/response is done, but add key
operation get canceled in some corner cases. As a result, further
association/scan operations are blocked.

This patch fixes the problem by clearing scan_block flag.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index ff948a9..bbc0cfc 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2209,6 +2209,9 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		return -EALREADY;
 	}
 
+	if (priv->scan_block)
+		priv->scan_block = false;
+
 	if (adapter->surprise_removed || adapter->is_cmd_timedout) {
 		mwifiex_dbg(adapter, ERROR,
 			    "%s: Ignore connection.\t"
@@ -2427,6 +2430,9 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 		return -EBUSY;
 	}
 
+	if (!priv->wdev.current_bss && priv->scan_block)
+		priv->scan_block = false;
+
 	if (!mwifiex_stop_bg_scan(priv))
 		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy);
 
-- 
1.9.1

