Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:43247 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751203AbZENSPt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 14:15:49 -0400
Date: Thu, 14 May 2009 21:15:36 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Cancel pending probereq poll on beacon RX
Message-ID: <20090514181536.GA9111@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While the probe request poll is expected to work, it looks like it
does not always result in getting a response. The exact reason for
this is unclear, but anyway, if we do receive a Beacon frame from our
AP, there is no need to disconnect based on the probereq poll. This
seems to help keep the connection bit more stable in cases where
beacon loss is occurring semi-frequently.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/mlme.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-14 21:12:52.000000000 +0300
+++ wireless-testing/net/mac80211/mlme.c	2009-05-14 21:13:08.000000000 +0300
@@ -1820,6 +1820,16 @@ static void ieee80211_rx_mgmt_beacon(str
 	    memcmp(ifmgd->bssid, mgmt->bssid, ETH_ALEN) != 0)
 		return;
 
+	if (ifmgd->flags & IEEE80211_STA_PROBEREQ_POLL) {
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+		if (net_ratelimit()) {
+			printk(KERN_DEBUG "%s: cancelling probereq poll due "
+			       "to a received beacon\n", sdata->dev->name);
+		}
+#endif
+		ifmgd->flags &= ~IEEE80211_STA_PROBEREQ_POLL;
+	}
+
 	ncrc = crc32_be(0, (void *)&mgmt->u.beacon.beacon_int, 4);
 	ncrc = ieee802_11_parse_elems_crc(mgmt->u.beacon.variable,
 					  len - baselen, &elems,

-- 
Jouni Malinen                                            PGP id EFC895FA
