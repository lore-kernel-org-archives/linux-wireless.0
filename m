Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33043 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611AbcBZOGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 09:06:39 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/3] mac80211: Support a scan request for a specific BSSID
Date: Fri, 26 Feb 2016 16:06:05 +0200
Message-ID: <1456495566-14272-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20160226_150653_386944_CE897C6C)
In-Reply-To: <1456495566-14272-1-git-send-email-jouni@qca.qualcomm.com>
References: <1456495566-14272-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the cfg80211 scan trigger operation specifies a single BSSID, use
that value instead of the wildcard BSSID in the Probe Request frames.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index ae980ce..b025a82 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -497,7 +497,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 
 	for (i = 0; i < scan_req->n_ssids; i++)
 		ieee80211_send_probe_req(
-			sdata, local->scan_addr, NULL,
+			sdata, local->scan_addr, scan_req->bssid,
 			scan_req->ssids[i].ssid, scan_req->ssids[i].ssid_len,
 			scan_req->ie, scan_req->ie_len,
 			scan_req->rates[band], false,
-- 
1.9.1

