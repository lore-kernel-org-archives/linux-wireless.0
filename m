Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58105 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbZBIUrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 15:47:21 -0500
Subject: [PATCH] mac80211: fix IBSS auth
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 21:46:48 +0100
Message-Id: <1234212408.4175.251.camel@johannes.local> (sfid-20090209_214726_806017_F18BFDFC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code beyond this point is supposed to be used for
non-IBSS (managed) mode only.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>
---
 net/mac80211/mlme.c |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-02-09 21:18:12.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-02-09 21:44:43.000000000 +0100
@@ -1175,6 +1175,7 @@ static void ieee80211_rx_mgmt_auth(struc
 		if (auth_alg != WLAN_AUTH_OPEN || auth_transaction != 1)
 			return;
 		ieee80211_send_auth(sdata, ifsta, 2, NULL, 0, 0);
+		return;
 	}
 
 	if (auth_alg != ifsta->auth_alg ||


