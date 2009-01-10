Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:42359 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886AbZAJJrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 04:47:40 -0500
Date: Sat, 10 Jan 2009 11:47:33 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Fix radiotap header it_present on big endian CPUs
Message-ID: <20090110094733.GB5217@jm.kir.nu> (sfid-20090110_104744_819101_9426E0BD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the IEEE80211_RADIOTAP_RATE flag was moved to be conditional, it
was mistakenly left without cpu_to_le32(). Fix that.

Signed-off-by: Jouni Malinen <j@w1.fi>


---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-01-10 11:40:33.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-01-10 11:41:06.000000000 +0200
@@ -158,7 +158,7 @@ ieee80211_add_rx_radiotap_header(struct 
 		 */
 		*pos = 0;
 	} else {
-		rthdr->it_present |= (1 << IEEE80211_RADIOTAP_RATE);
+		rthdr->it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_RATE);
 		*pos = rate->bitrate / 5;
 	}
 	pos++;

-- 
Jouni Malinen                                            PGP id EFC895FA
