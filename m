Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50116 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753292AbdBTNYy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 08:24:54 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>
Subject: [PATCH 6/6] mac80211: shorten debug message
Date: Mon, 20 Feb 2017 14:24:39 +0100
Message-Id: <20170220132439.16064-6-johannes@sipsolutions.net> (sfid-20170220_142501_850624_B57F7A52)
In-Reply-To: <20170220132439.16064-1-johannes@sipsolutions.net>
References: <20170220132439.16064-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Tracing is limited to 100 characters and this message passes
the limit when there are a few buffered frames. Shorten it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 8bb99d299cda..3323a2fb289b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1264,7 +1264,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	sta_info_recalc_tim(sta);
 
 	ps_dbg(sdata,
-	       "STA %pM aid %d sending %d filtered/%d PS frames since STA not sleeping anymore\n",
+	       "STA %pM aid %d sending %d filtered/%d PS frames since STA woke up\n",
 	       sta->sta.addr, sta->sta.aid, filtered, buffered);
 
 	ieee80211_check_fast_xmit(sta);
-- 
2.9.3
