Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:32958 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbbESMNu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 08:13:50 -0400
Received: by wicmx19 with SMTP id mx19so114484095wic.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2015 05:13:49 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: check fast-xmit on station change
Date: Tue, 19 May 2015 14:13:36 +0200
Message-Id: <1432037616-26520-1-git-send-email-michal.kazior@tieto.com> (sfid-20150519_141355_232561_95F4F309)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers with fast-xmit (e.g. ath10k) running in
AP_VLAN setups would fail to communicate with
connected 4addr stations.

The reason was when new station associates it
first goes into master AP interface. It is not
until later that a dedicated AP_VLAN is created
for it and the station itself is moved there.
After that Tx directed at the station should use
4addr header. However fast-xmit wasn't
recalculated and 3addr header remained to be used.
This in turn caused the connected 4addr stations
to drop packets coming from the AP until some
other event would cause fast-xmit to recalculate
for that station (which could never come).

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 3469bbdc891c..bb9f83640b46 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1411,6 +1411,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 		}
 
 		sta->sdata = vlansdata;
+		ieee80211_check_fast_xmit(sta);
 
 		if (sta->sta_state == IEEE80211_STA_AUTHORIZED &&
 		    prev_4addr != new_4addr) {
-- 
2.1.4

