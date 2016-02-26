Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55120 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932880AbcBZUNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 15:13:18 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/3] mac80211: Support a scan request for a specific BSSID
Date: Fri, 26 Feb 2016 22:12:48 +0200
Message-ID: <1456517569-27235-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20160226_211326_538550_37AB3987)
In-Reply-To: <1456517569-27235-1-git-send-email-jouni@qca.qualcomm.com>
References: <1456517569-27235-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the cfg80211 scan trigger operation specifies a single BSSID, use
that value instead of the wildcard BSSID in the Probe Request frames.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---

Notes:
    v2: Fix bssid setting for hw_scan

 net/mac80211/scan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index ae980ce..70f9d5a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -303,6 +303,7 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 	ether_addr_copy(local->hw_scan_req->req.mac_addr, req->mac_addr);
 	ether_addr_copy(local->hw_scan_req->req.mac_addr_mask,
 			req->mac_addr_mask);
+	ether_addr_copy(local->hw_scan_req->req.bssid, req->bssid);
 
 	return true;
 }
@@ -497,7 +498,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 
 	for (i = 0; i < scan_req->n_ssids; i++)
 		ieee80211_send_probe_req(
-			sdata, local->scan_addr, NULL,
+			sdata, local->scan_addr, scan_req->bssid,
 			scan_req->ssids[i].ssid, scan_req->ssids[i].ssid_len,
 			scan_req->ie, scan_req->ie_len,
 			scan_req->rates[band], false,
@@ -562,6 +563,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 			req->n_channels * sizeof(req->channels[0]);
 		local->hw_scan_req->req.ie = ies;
 		local->hw_scan_req->req.flags = req->flags;
+		eth_broadcast_addr(local->hw_scan_req->req.bssid);
 
 		local->hw_scan_band = 0;
 
-- 
1.9.1

