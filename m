Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53456 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbZBCEmh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 23:42:37 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 20:42:37 -0800
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] mac80211: Remove bss information of the current AP when it goes out of range
Date: Tue, 3 Feb 2009 10:09:49 +0530
Message-ID: <1233635989-20664-1-git-send-email-vasanth@atheros.com> (sfid-20090203_054239_924618_B2BDBAD4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no point having the bss information of currently associated AP
when the AP is detected to be out of range.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 net/mac80211/mlme.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9d51e27..945c10d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1042,6 +1042,7 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int disassoc;
+	bool remove_bss = false;
 
 	/* TODO: start monitoring current AP signal quality and number of
 	 * missed beacons. Scan other channels every now and then and search
@@ -1067,6 +1068,7 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata,
 				       "range\n",
 				       sdata->dev->name, ifsta->bssid);
 				disassoc = 1;
+				remove_bss = true;
 			} else
 				ieee80211_send_probe_req(sdata, ifsta->bssid,
 							 ifsta->ssid,
@@ -1086,12 +1088,24 @@ static void ieee80211_associated(struct ieee80211_sub_if_data *sdata,
 
 	rcu_read_unlock();
 
-	if (disassoc)
+	if (disassoc) {
 		ieee80211_set_disassoc(sdata, ifsta, true, true,
 					WLAN_REASON_PREV_AUTH_NOT_VALID);
-	else
+		if (remove_bss) {
+			struct ieee80211_bss *bss;
+
+			bss = ieee80211_rx_bss_get(local, ifsta->bssid,
+					local->hw.conf.channel->center_freq,
+					ifsta->ssid, ifsta->ssid_len);
+			if (bss) {
+				atomic_dec(&bss->users);
+				ieee80211_rx_bss_put(local, bss);
+			}
+		}
+	} else {
 		mod_timer(&ifsta->timer, jiffies +
 				      IEEE80211_MONITORING_INTERVAL);
+	}
 }
 
 
-- 
1.5.5.1

