Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:39636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120AbYETH4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 03:56:40 -0400
Message-ID: <20080520095637.2cq5p5ohhc8440o4@imap.suse.de> (sfid-20080520_095642_396639_0354A65D)
Date: Tue, 20 May 2008 09:56:37 +0200
From: Helmut Schaa <hschaa@suse.de>
To: John Linville <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCHv5] mac80211: fix NULL pointer dereference in
	ieee80211_compatible_rates
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a possible NULL pointer dereference in ieee80211_compatible_rates
introduced in the patch "mac80211: fix association with some APs". If no bss
is available just use all supported rates in the association request.

Signed-off-by: Helmut Schaa <hschaa@suse.de>
---

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 76ad4ed..3f7f92a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -721,7 +721,17 @@ static void ieee80211_send_assoc(struct net_device *dev,
  			capab |= WLAN_CAPABILITY_PRIVACY;
  		if (bss->wmm_ie)
  			wmm = 1;
+
+		/* get all rates supported by the device and the AP as
+		 * some APs don't like getting a superset of their rates
+		 * in the association request (e.g. D-Link DAP 1353 in
+		 * b-only mode) */
+		rates_len = ieee80211_compatible_rates(bss, sband, &rates);
+
  		ieee80211_rx_bss_put(dev, bss);
+	} else {
+		rates = ~0;
+		rates_len = sband->n_bitrates;
  	}

  	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
@@ -752,10 +762,7 @@ static void ieee80211_send_assoc(struct net_device *dev,
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

