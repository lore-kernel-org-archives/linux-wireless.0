Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34138 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933125Ab1CXSq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 14:46:27 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix suppressing probe responses in ad-hoc mode
Date: Thu, 24 Mar 2011 19:46:18 +0100
Message-Id: <1300992378-50964-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "mac80211: reply to directed probes in IBSS" changed ad-hoc
specific code to respond to unicast probe requests, even if
drv_tx_last_beacon returns false, however due to confusion over the
meaning of the IEEE80211_RX_RA_MATCH flag, it also unconditionally
enabled responding to multicast probe requests.
Fix this by explicitly checking for a multicast destination address
instead.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/ibss.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 3e81af1..1488396 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -661,7 +661,6 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 					struct sk_buff *req)
 {
-	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(req);
 	struct ieee80211_mgmt *mgmt = (void *)req->data;
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
@@ -685,7 +684,7 @@ static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 	       mgmt->bssid, tx_last_beacon);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 
-	if (!tx_last_beacon && !(rx_status->rx_flags & IEEE80211_RX_RA_MATCH))
+	if (!tx_last_beacon && is_multicast_ether_addr(mgmt->da))
 		return;
 
 	if (memcmp(mgmt->bssid, ifibss->bssid, ETH_ALEN) != 0 &&
-- 
1.7.3.2

