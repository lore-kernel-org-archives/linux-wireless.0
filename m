Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36804 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1BAMtY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 07:49:24 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1PkFff-0004iA-GH
	for linux-wireless@vger.kernel.org; Tue, 01 Feb 2011 13:49:23 +0100
Subject: [RFC] mac80211: reply to directed probes in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Feb 2011 13:49:23 +0100
Message-ID: <1296564563.3989.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

At least the WMM spec says we should reply to
unicast probe request frames that go to us.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2011-02-01 12:58:16.000000000 +0100
+++ wireless-testing/net/mac80211/ibss.c	2011-02-01 13:47:44.000000000 +0100
@@ -689,7 +689,7 @@ static void ieee80211_rx_mgmt_probe_req(
 	       mgmt->bssid, tx_last_beacon);
 #endif /* CONFIG_MAC80211_IBSS_DEBUG */
 
-	if (!tx_last_beacon)
+	if (!tx_last_beacon && !(status->rx_flags & IEEE80211_RX_RA_MATCH))
 		return;
 
 	if (memcmp(mgmt->bssid, ifibss->bssid, ETH_ALEN) != 0 &&


