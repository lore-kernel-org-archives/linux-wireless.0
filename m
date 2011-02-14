Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1BNLU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 06:20:26 -0500
Subject: mac80211: reply to directed probes in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mohammed Shafi <shafi.wireless@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 12:20:22 +0100
Message-ID: <1297682422.3785.29.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

WFA certification and the WMM spec require that we
always reply to unicast probe requests, so do that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2011-02-14 11:22:15.000000000 +0100
+++ wireless-testing/net/mac80211/ibss.c	2011-02-14 11:32:43.000000000 +0100
@@ -664,12 +664,13 @@ static void ieee80211_sta_find_ibss(stru
 }
 
 static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
-					struct ieee80211_mgmt *mgmt,
-					size_t len)
+					struct sk_buff *req)
 {
+	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(req);
+	struct ieee80211_mgmt *mgmt = (void *)req->data;
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
-	int tx_last_beacon;
+	int tx_last_beacon, len = req->len;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *resp;
 	u8 *pos, *end;
@@ -689,7 +690,7 @@ static void ieee80211_rx_mgmt_probe_req(
 	       mgmt->bssid, tx_last_beacon);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 
-	if (!tx_last_beacon)
+	if (!tx_last_beacon && !(rx_status->rx_flags & IEEE80211_RX_RA_MATCH))
 		return;
 
 	if (memcmp(mgmt->bssid, ifibss->bssid, ETH_ALEN) != 0 &&
@@ -786,7 +787,7 @@ void ieee80211_ibss_rx_queued_mgmt(struc
 
 	switch (fc & IEEE80211_FCTL_STYPE) {
 	case IEEE80211_STYPE_PROBE_REQ:
-		ieee80211_rx_mgmt_probe_req(sdata, mgmt, skb->len);
+		ieee80211_rx_mgmt_probe_req(sdata, skb);
 		break;
 	case IEEE80211_STYPE_PROBE_RESP:
 		ieee80211_rx_mgmt_probe_resp(sdata, mgmt, skb->len,


