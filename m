Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbZEST0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 15:26:38 -0400
Subject: [PATCH] mac80211: fix probe response wait timing
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 May 2009 21:26:07 +0200
Message-Id: <1242761167.4797.79.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In "mac80211: split out and decrease probe wait time" I tried
to reduce the time waiting for a probe response, but failed to
take into account the case where we are detecting beacon loss
in software -- in that case we still wait the monitoring time
rather than the probe wait time. Fix this by refactoring the
mod_timer() calls in ieee80211_associated().

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-19 21:06:36.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-05-19 21:06:57.000000000 +0200
@@ -1389,8 +1389,8 @@ static void ieee80211_associated(struct 
 		ifmgd->flags |= IEEE80211_STA_PROBEREQ_POLL;
 		ieee80211_send_probe_req(sdata, ifmgd->bssid, ifmgd->ssid,
 					 ifmgd->ssid_len, NULL, 0);
+		mod_timer(&ifmgd->timer, jiffies + IEEE80211_PROBE_WAIT);
 		goto unlock;
-
 	}
 
 	if (time_after(jiffies, sta->last_rx + IEEE80211_PROBE_IDLE_TIME)) {
@@ -1399,15 +1399,16 @@ static void ieee80211_associated(struct 
 					 ifmgd->ssid_len, NULL, 0);
 	}
 
+	if (!disassoc)
+		mod_timer(&ifmgd->timer,
+			  jiffies + IEEE80211_MONITORING_INTERVAL);
+
  unlock:
 	rcu_read_unlock();
 
 	if (disassoc)
 		ieee80211_set_disassoc(sdata, true, true,
 					WLAN_REASON_PREV_AUTH_NOT_VALID);
-	else
-		mod_timer(&ifmgd->timer, jiffies +
-				      IEEE80211_MONITORING_INTERVAL);
 }
 
 


