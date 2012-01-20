Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab2ATMxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 07:53:51 -0500
Message-Id: <20120120125312.956655635@sipsolutions.net> (sfid-20120120_135355_867515_B3532489)
Date: Fri, 20 Jan 2012 13:52:36 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mac80211: fix a few -Wshadow warnings
References: <20120120125235.243434836@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It seems that -Wshadow is no longer default in
sparse runs, but let's fix the warnings anyway.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c     |    3 ---
 net/mac80211/status.c |    6 +++---
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/net/mac80211/rx.c	2012-01-20 13:50:03.000000000 +0100
+++ b/net/mac80211/rx.c	2012-01-20 13:50:10.000000000 +0100
@@ -2180,9 +2180,6 @@ ieee80211_rx_h_mgmt_check(struct ieee802
 	if (rx->sdata->vif.type == NL80211_IFTYPE_AP &&
 	    ieee80211_is_beacon(mgmt->frame_control) &&
 	    !(rx->flags & IEEE80211_RX_BEACON_REPORTED)) {
-		struct ieee80211_rx_status *status;
-
-		status = IEEE80211_SKB_RXCB(rx->skb);
 		cfg80211_report_obss_beacon(rx->local->hw.wiphy,
 					    rx->skb->data, rx->skb->len,
 					    status->freq, GFP_ATOMIC);
--- a/net/mac80211/status.c	2012-01-20 13:50:03.000000000 +0100
+++ b/net/mac80211/status.c	2012-01-20 13:50:10.000000000 +0100
@@ -350,7 +350,6 @@ void ieee80211_tx_status(struct ieee8021
 	bool send_to_cooked;
 	bool acked;
 	struct ieee80211_bar *bar;
-	u16 tid;
 	int rtap_len;
 
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
@@ -412,7 +411,7 @@ void ieee80211_tx_status(struct ieee8021
 		}
 
 		if (!acked && ieee80211_is_back_req(fc)) {
-			u16 control;
+			u16 tid, control;
 
 			/*
 			 * BAR failed, store the last SSN and retry sending
@@ -516,7 +515,8 @@ void ieee80211_tx_status(struct ieee8021
 
 		if (ieee80211_is_nullfunc(hdr->frame_control) ||
 		    ieee80211_is_qos_nullfunc(hdr->frame_control)) {
-			bool acked = info->flags & IEEE80211_TX_STAT_ACK;
+			acked = info->flags & IEEE80211_TX_STAT_ACK;
+
 			cfg80211_probe_status(skb->dev, hdr->addr1,
 					      cookie, acked, GFP_ATOMIC);
 		} else {


