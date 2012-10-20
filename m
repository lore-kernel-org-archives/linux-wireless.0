Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:57988 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532Ab2JTCUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 22:20:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/7] mwifiex: use LOW_PRIORITY scan flag provided in scan request
Date: Fri, 19 Oct 2012 19:19:15 -0700
Message-Id: <1350699561-852-2-git-send-email-bzhao@marvell.com> (sfid-20121020_042016_455846_8DD90132)
In-Reply-To: <1350699561-852-1-git-send-email-bzhao@marvell.com>
References: <1350699561-852-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

We will delay/abort scan operation based on traffic for low
priority scan.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    6 ++++--
 drivers/net/wireless/mwifiex/scan.c     |    6 +++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 9aead8a..234ee1e 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1819,7 +1819,8 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 
 	wiphy_dbg(wiphy, "info: received scan request on %s\n", dev->name);
 
-	if (atomic_read(&priv->wmm.tx_pkts_queued) >=
+	if ((request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
+	    atomic_read(&priv->wmm.tx_pkts_queued) >=
 	    MWIFIEX_MIN_TX_PENDING_TO_CANCEL_SCAN) {
 		dev_dbg(priv->adapter->dev, "scan rejected due to traffic\n");
 		return -EBUSY;
@@ -2254,7 +2255,8 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->available_antennas_rx = BIT(adapter->number_of_antenna) - 1;
 
 	wiphy->features |= NL80211_FEATURE_HT_IBSS |
-			   NL80211_FEATURE_INACTIVITY_TIMER;
+			   NL80211_FEATURE_INACTIVITY_TIMER |
+			   NL80211_FEATURE_LOW_PRIORITY_SCAN;
 
 	/* Reserve space for mwifiex specific private data for BSS */
 	wiphy->bss_priv_size = sizeof(struct mwifiex_bss_priv);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index fe05684..b99f47b 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1776,12 +1776,16 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 			priv->user_scan_cfg = NULL;
 		}
 	} else {
-		if (!mwifiex_wmm_lists_empty(adapter)) {
+		if (!mwifiex_wmm_lists_empty(adapter) &&
+		    (priv->scan_request && (priv->scan_request->flags &
+					    NL80211_SCAN_FLAG_LOW_PRIORITY))) {
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
 			adapter->scan_delay_cnt = 1;
 			mod_timer(&priv->scan_delay_timer, jiffies +
 				  msecs_to_jiffies(MWIFIEX_SCAN_DELAY_MSEC));
+			dev_dbg(priv->adapter->dev,
+				"info: %s: deferring scan\n", __func__);
 		} else {
 			/* Get scan command from scan_pending_q and put to
 			   cmd_pending_q */
-- 
1.7.0.2

