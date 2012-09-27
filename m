Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:49299 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754398Ab2I0THg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 15:07:36 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 5/5] mwifiex: use LOW_PRIORITY flag provided in scan request
Date: Thu, 27 Sep 2012 11:59:14 -0700
Message-Id: <1348772354-15936-6-git-send-email-bzhao@marvell.com> (sfid-20120927_210740_563516_A657BD01)
In-Reply-To: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
References: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

The flag gives information about scan priority. This patch adds
checks in the code to cancel/abort scan operation only for low
priority scan requests.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Reviewed-by: Sam Leffler <sleffler@chromium.org>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    3 ++-
 drivers/net/wireless/mwifiex/scan.c     |    6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 2691620..dc6d868 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1808,7 +1808,8 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 
 	wiphy_dbg(wiphy, "info: received scan request on %s\n", dev->name);
 
-	if (atomic_read(&priv->wmm.tx_pkts_queued) >=
+	if ((request->flags & CFG80211_SCAN_FLAG_LOW_PRIORITY) &&
+	    atomic_read(&priv->wmm.tx_pkts_queued) >=
 	    MWIFIEX_MIN_TX_PENDING_TO_CANCEL_SCAN) {
 		dev_dbg(priv->adapter->dev, "scan rejected due to traffic\n");
 		return -EBUSY;
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 9e077e5..b3a1d2f 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1770,12 +1770,16 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			priv->user_scan_cfg = NULL;
 		}
 	} else {
-		if (!mwifiex_wmm_lists_empty(adapter)) {
+		if (!mwifiex_wmm_lists_empty(adapter) &&
+		    (priv->scan_request && (priv->scan_request->flags &
+					    CFG80211_SCAN_FLAG_LOW_PRIORITY))) {
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
 			adapter->scan_delay_cnt = 1;
 			mod_timer(&priv->scan_delay_timer, jiffies +
 				  msecs_to_jiffies(MWIFIEX_SCAN_DELAY_MSEC));
+			dev_dbg(priv->adapter->dev,
+				"%s: deferring scan\n", __func__);
 		} else {
 			/* Get scan command from scan_pending_q and put to
 			   cmd_pending_q */
-- 
1.7.0.2

