Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:42323 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab0DTKS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Apr 2010 06:18:29 -0400
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix ieee80211_sta_conn_mon_timer with hw connection monitoring
Date: Tue, 20 Apr 2010 13:15:56 +0300
Message-Id: <1271758556-13558-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When IEEE80211_HW_CONNECTION_MONITOR is configured by the driver, starting
of ieee80211_sta_conn_mon_timer should be prevented, as it is then not needed.

This is currently partially the case. As it seems, when a probe-response is
received from the AP the timer is still restarted, thus restarting the host
based connection keep-alive mechanism. These probe-responses happen at least
when scanning while associated.

Fix this by preventing starting of the ieee80211_sta_conn_mon_timer in the
ieee80211_rx_mgmt_probe_resp function.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/mac80211/mlme.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3133681..425f66c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1333,12 +1333,17 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 		mutex_lock(&sdata->local->iflist_mtx);
 		ieee80211_recalc_ps(sdata->local, -1);
 		mutex_unlock(&sdata->local->iflist_mtx);
+
+		if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
+			return;
+
 		/*
 		 * We've received a probe response, but are not sure whether
 		 * we have or will be receiving any beacons or data, so let's
 		 * schedule the timers again, just in case.
 		 */
 		mod_beacon_timer(sdata);
+
 		mod_timer(&ifmgd->conn_mon_timer,
 			  round_jiffies_up(jiffies +
 					   IEEE80211_CONNECTION_IDLE_TIME));
-- 
1.6.3.3

