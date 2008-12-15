Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:56370 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064AbYLOIiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 03:38:08 -0500
Date: Mon, 15 Dec 2008 10:37:50 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Remove radiotap rate-present flag for HT
Message-ID: <20081215083750.GA2747@jm.kir.nu> (sfid-20081215_093813_027483_CA2F166A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we do not currently report HT rates (MCS index) in radiotap
header for HT rates, we should not claim the rate is present. The rate
octet itself is used as padding in this case, so only the it_present
flag needs to be removed in case of HT rates.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 net/mac80211/rx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2008-12-15 10:15:17.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2008-12-15 10:16:14.000000000 +0200
@@ -123,7 +123,6 @@ ieee80211_add_rx_radiotap_header(struct 
 	/* radiotap header, set always present flags */
 	rthdr->it_present =
 		cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
-			    (1 << IEEE80211_RADIOTAP_RATE) |
 			    (1 << IEEE80211_RADIOTAP_CHANNEL) |
 			    (1 << IEEE80211_RADIOTAP_ANTENNA) |
 			    (1 << IEEE80211_RADIOTAP_RX_FLAGS));
@@ -158,8 +157,10 @@ ieee80211_add_rx_radiotap_header(struct 
 		 * - short-GI (status->flag & RX_FLAG_SHORT_GI)
 		 */
 		*pos = 0;
-	} else
+	} else {
+		rthdr->it_present |= (1 << IEEE80211_RADIOTAP_RATE);
 		*pos = rate->bitrate / 5;
+	}
 	pos++;
 
 	/* IEEE80211_RADIOTAP_CHANNEL */

-- 
Jouni Malinen                                            PGP id EFC895FA
