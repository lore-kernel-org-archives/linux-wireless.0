Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbZBJUng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:43:36 -0500
Message-Id: <20090210202557.680232998@sipsolutions.net> (sfid-20090210_214338_863231_5D073C3D)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:26:02 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 26/27] mac80211: fix IBSS auth
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

--- wireless-testing.orig/net/mac80211/mlme.c	2009-02-10 20:59:38.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-02-10 20:59:39.000000000 +0100
@@ -1175,6 +1175,7 @@ static void ieee80211_rx_mgmt_auth(struc
 		if (auth_alg != WLAN_AUTH_OPEN || auth_transaction != 1)
 			return;
 		ieee80211_send_auth(sdata, ifsta, 2, NULL, 0, 0);
+		return;
 	}
 
 	if (auth_alg != ifsta->auth_alg ||

-- 

