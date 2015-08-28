Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57702 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbbH1Iw7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2015 04:52:59 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: fix driver RSSI event calculations
Date: Fri, 28 Aug 2015 10:52:53 +0200
Message-Id: <1440751974-8075-2-git-send-email-johannes@sipsolutions.net> (sfid-20150828_105306_557834_59BA17E6)
In-Reply-To: <1440751974-8075-1-git-send-email-johannes@sipsolutions.net>
References: <1440751974-8075-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The ifmgd->ave_beacon_signal value cannot be taken as is for
comparisons, it must be divided by since it's represented
like that for better accuracy of the EWMA calculations. This
would lead to invalid driver RSSI events. Fix the used value.

Fixes: 615f7b9bb1f8 ("mac80211: add driver RSSI threshold events")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a56a3274236c..b4dd619da21e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3390,7 +3390,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 	if (ifmgd->rssi_min_thold != ifmgd->rssi_max_thold &&
 	    ifmgd->count_beacon_signal >= IEEE80211_SIGNAL_AVE_MIN_COUNT) {
-		int sig = ifmgd->ave_beacon_signal;
+		int sig = ifmgd->ave_beacon_signal / 16;
 		int last_sig = ifmgd->last_ave_beacon_signal;
 		struct ieee80211_event event = {
 			.type = RSSI_EVENT,
-- 
2.1.4

