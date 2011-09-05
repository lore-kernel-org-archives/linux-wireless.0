Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:37692 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359Ab1IEMDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Sep 2011 08:03:03 -0400
Received: by mail-yi0-f47.google.com with SMTP id 28so2977467yia.6
        for <linux-wireless@vger.kernel.org>; Mon, 05 Sep 2011 05:03:02 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>
Subject: [RFC v2 2/5] mac80211: adding 'scan_cancel' command.
Date: Mon,  5 Sep 2011 15:02:28 +0300
Message-Id: <1315224151-16552-3-git-send-email-VictorG@ti.com> (sfid-20110905_140306_962185_4B89EA2F)
In-Reply-To: <1315224151-16552-1-git-send-email-VictorG@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implementing the scan_cancel operation in the mac80211,
by calling existing ieee80211_scan_cancel() function.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 net/mac80211/cfg.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c1fa577..7c3a473 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1389,6 +1389,13 @@ ieee80211_sched_scan_stop(struct wiphy *wiphy, struct net_device *dev)
 	return ieee80211_request_sched_scan_stop(sdata);
 }
 
+static void ieee80211_scan_cancel_req(struct wiphy *wiphy,
+					struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	ieee80211_scan_cancel(sdata->local);
+}
+
 static int ieee80211_auth(struct wiphy *wiphy, struct net_device *dev,
 			  struct cfg80211_auth_request *req)
 {
@@ -2119,6 +2126,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.suspend = ieee80211_suspend,
 	.resume = ieee80211_resume,
 	.scan = ieee80211_scan,
+	.scan_cancel = ieee80211_scan_cancel_req,
 	.sched_scan_start = ieee80211_sched_scan_start,
 	.sched_scan_stop = ieee80211_sched_scan_stop,
 	.auth = ieee80211_auth,
-- 
1.7.0.4

