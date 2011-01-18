Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:19574 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab1ARNpk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 08:45:40 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 18 Jan 2011 05:45:22 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [RFC] mac80211: reset connection poll on receiving unicast data frames
Date: Tue, 18 Jan 2011 19:14:45 +0530
Message-ID: <1295358285-9336-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In noisy channel conditions, some APs do not reply to probe
requests which results in STA disconnection. It is perfectly
fine to reset the connection polling if unicast frames are
received from that AP properly.

The reason behind to reset connection poll on unicast data
frames alone is that to preserve the PS recalculation on receiving
probe response.

This disconnection issue was reported with some buggy APs in noisy
environment, with the devices that does not support
IEEE80211_HW_REPORTS_TX_ACK_STATUS and running heavy downlink
unicast traffic from DS to STA. The probe response that was not
seen for the request sent followed by scan completion.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 net/mac80211/mlme.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 45fbb9e..03d6cfc 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -141,6 +141,7 @@ void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
 		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
 
 	ifmgd->probe_send_count = 0;
+	ifmgd->flags &= ~IEEE80211_STA_CONNECTION_POLL;
 }
 
 static int ecw2cw(int ecw)
@@ -1033,7 +1034,8 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 	if (is_multicast_ether_addr(hdr->addr1))
 		return;
 
-	ieee80211_sta_reset_conn_monitor(sdata);
+	if (ieee80211_is_data(hdr->frame_control))
+		ieee80211_sta_reset_conn_monitor(sdata);
 }
 
 static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
-- 
1.7.3.5

