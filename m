Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45483 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625Ab1ANRcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 12:32:22 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Show max retry-counts in kernel messages.
Date: Fri, 14 Jan 2011 09:32:18 -0800
Message-Id: <1295026338-21765-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 45fbb9e... eecbb1f... M	net/mac80211/mlme.c
 net/mac80211/mlme.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 45fbb9e..eecbb1f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1972,9 +1972,9 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 				wiphy_debug(local->hw.wiphy,
 					    "%s: No ack for nullfunc frame to"
-					    " AP %pM, try %d\n",
+					    " AP %pM, try %d/%i\n",
 					    sdata->name, bssid,
-					    ifmgd->probe_send_count);
+					    ifmgd->probe_send_count, max_tries);
 #endif
 				ieee80211_mgd_probe_ap_send(sdata);
 			} else {
@@ -2001,10 +2001,10 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			wiphy_debug(local->hw.wiphy,
 				    "%s: No probe response from AP %pM"
-				    " after %dms, try %d\n",
+				    " after %dms, try %d/%i\n",
 				    sdata->name,
 				    bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ,
-				    ifmgd->probe_send_count);
+				    ifmgd->probe_send_count, max_tries);
 #endif
 			ieee80211_mgd_probe_ap_send(sdata);
 		} else {
-- 
1.7.2.3

