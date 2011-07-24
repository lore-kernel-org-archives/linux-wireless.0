Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:58653 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752526Ab1GXNSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jul 2011 09:18:47 -0400
Received: by ywf7 with SMTP id 7so2253067ywf.13
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jul 2011 06:18:46 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC 2/2] mac80211: adding 'scan_cancel' command.
Date: Sun, 24 Jul 2011 16:10:38 +0300
Message-Id: <1311513038-5669-2-git-send-email-VictorG@ti.com> (sfid-20110724_151851_517107_B8BF035E)
In-Reply-To: <1311513038-5669-1-git-send-email-VictorG@ti.com>
References: <1311513038-5669-1-git-send-email-VictorG@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implementing the scan_cancel operation in the mac80211.
Mostly from an energy consumption and cpu load
perspective, it can be useful to stop a scan earlier.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 net/mac80211/cfg.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 295ab74..bd4096b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1382,6 +1382,13 @@ ieee80211_sched_scan_stop(struct wiphy *wiphy, struct net_device *dev)
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
@@ -2151,6 +2158,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.suspend = ieee80211_suspend,
 	.resume = ieee80211_resume,
 	.scan = ieee80211_scan,
+	.scan_cancel = ieee80211_scan_cancel_req,
 	.sched_scan_start = ieee80211_sched_scan_start,
 	.sched_scan_stop = ieee80211_sched_scan_stop,
 	.auth = ieee80211_auth,
-- 
1.7.0.4

