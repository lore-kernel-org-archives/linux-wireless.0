Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119AbXLSPra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:47:30 -0500
Message-Id: <20071219003236.479862000@sipsolutions.net> (sfid-20071219_154750_713508_9493B2A6)
References: <20071219003121.508296000@sipsolutions.net>
Date: Wed, 19 Dec 2007 01:31:24 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/6]  mac80211: make ieee80211_rx_mgmt_action static
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function is only used locally.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_sta.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- everything.orig/net/mac80211/ieee80211_sta.c	2007-12-19 00:35:22.723022189 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2007-12-19 00:48:26.783024250 +0100
@@ -1994,10 +1994,10 @@ static void ieee80211_rx_mgmt_probe_req(
 	ieee80211_sta_tx(dev, skb, 0);
 }
 
-void ieee80211_rx_mgmt_action(struct net_device *dev,
-			     struct ieee80211_if_sta *ifsta,
-			     struct ieee80211_mgmt *mgmt,
-			     size_t len)
+static void ieee80211_rx_mgmt_action(struct net_device *dev,
+				     struct ieee80211_if_sta *ifsta,
+				     struct ieee80211_mgmt *mgmt,
+				     size_t len)
 {
 	if (len < IEEE80211_MIN_ACTION_SIZE)
 		return;

-- 

