Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765909AbYESNlx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 09:41:53 -0400
From: Helmut Schaa <hschaa@suse.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCHv3] mac80211: fix NULL pointer dereference in ieee80211_compatible_rates
Date: Mon, 19 May 2008 15:41:48 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805191541.49313.hschaa@suse.de> (sfid-20080519_154218_799043_96888785)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a possible NULL pointer dereference in ieee80211_compatible_rates 
introduced in the patch "mac80211: fix association with some APs". If no bss
is available just use all supported rates in the association request.

Signed-off-by: Helmut Schaa <hschaa@suse.de>
---

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 76ad4ed..277bbda 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -722,6 +722,10 @@ static void ieee80211_send_assoc(struct net_device *dev,
 		if (bss->wmm_ie)
 			wmm = 1;
 		ieee80211_rx_bss_put(dev, bss);
+		rates_len = ieee80211_compatible_rates(bss, sband, &rates);
+	} else {
+		rates = ~0;
+		rates_len = sband->n_bitrates;
 	}
 
 	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
@@ -755,7 +759,6 @@ static void ieee80211_send_assoc(struct net_device *dev,
 	/* all supported rates should be added here but some APs
 	 * (e.g. D-Link DAP 1353 in b-only mode) don't like that
 	 * Therefore only add rates the AP supports */
-	rates_len = ieee80211_compatible_rates(bss, sband, &rates);
 	supp_rates_len = rates_len;
 	if (supp_rates_len > 8)
 		supp_rates_len = 8;
