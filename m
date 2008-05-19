Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:49581 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbYESO7r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 10:59:47 -0400
From: Helmut Schaa <hschaa@suse.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCHv4] mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
Date: Mon, 19 May 2008 16:59:43 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805191659.43961.hschaa@suse.de> (sfid-20080519_165950_989332_9374533B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a possible NULL pointer dereference in ieee80211_compatible_rates 
introduced in the patch "mac80211: fix association with some APs". If no bss
is available just use all supported rates in the association request.

Signed-off-by: Helmut Schaa <hschaa@suse.de>
---

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 76ad4ed..7aff784 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -722,6 +722,15 @@ static void ieee80211_send_assoc(struct net_device *dev,
 		if (bss->wmm_ie)
 			wmm = 1;
 		ieee80211_rx_bss_put(dev, bss);
+
+		/* get all rates supported by the device and the AP as
+		 * some APs don't like getting a superset of their rates
+		 * in the association request (e.g. D-Link DAP 1353 in
+		 * b-only mode) */
+		rates_len = ieee80211_compatible_rates(bss, sband, &rates);
+	} else {
+		rates = ~0;
+		rates_len = sband->n_bitrates;
 	}
 
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
@@ -752,10 +761,7 @@ static void ieee80211_send_assoc(struct net_device *dev,
 	*pos++ = ifsta->ssid_len;
 	memcpy(pos, ifsta->ssid, ifsta->ssid_len);
 
-	/* all supported rates should be added here but some APs
-	 * (e.g. D-Link DAP 1353 in b-only mode) don't like that
-	 * Therefore only add rates the AP supports */
-	rates_len = ieee80211_compatible_rates(bss, sband, &rates);
+	/* add all rates which were marked to be used above */
 	supp_rates_len = rates_len;
 	if (supp_rates_len > 8)
 		supp_rates_len = 8;
