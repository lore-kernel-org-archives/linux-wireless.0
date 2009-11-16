Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:50327 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335AbZKPSzZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 13:55:25 -0500
Date: Mon, 16 Nov 2009 19:54:08 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Do not queue Probe Request frames for station
 MLME
Message-ID: <20091116175408.GA6805@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cooked monitor interfaces cannot currently receive Probe Request
frames when the interface is in station mode. However, we do not
process Probe Request frames internally in the station MLME, so there
is no point in queueing the frame here. Remove Probe Request frames
from the queued frame list to allow cooked monitor interfaces to
receive these frames.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/mlme.c |    1 -
 1 file changed, 1 deletion(-)

--- uml.orig/net/mac80211/mlme.c	2009-11-13 16:58:27.000000000 +0200
+++ uml/net/mac80211/mlme.c	2009-11-13 16:59:20.000000000 +0200
@@ -1898,7 +1898,6 @@ ieee80211_rx_result ieee80211_sta_rx_mgm
 	fc = le16_to_cpu(mgmt->frame_control);
 
 	switch (fc & IEEE80211_FCTL_STYPE) {
-	case IEEE80211_STYPE_PROBE_REQ:
 	case IEEE80211_STYPE_PROBE_RESP:
 	case IEEE80211_STYPE_BEACON:
 	case IEEE80211_STYPE_AUTH:

-- 
Jouni Malinen                                            PGP id EFC895FA
