Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45903 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbXH0Nrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 09:47:36 -0400
Subject: [PATCH] mac80211: completely reset flags in  ieee80211_remove_tx_extra
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 15:48:44 +0200
Message-Id: <1188222524.7837.27.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All flags should be cleared when we get here before resetting them,
currently only these four exist so the result is the same but when
more flags are added this is easier to extend.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Similar to the other patch, this is a wireless-dev update that I'll be
rolling into the patch for net-2.6.24.

 net/mac80211/ieee80211.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-27 15:43:50.414646075 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-27 15:44:00.414646075 +0200
@@ -880,9 +880,7 @@ static void ieee80211_remove_tx_extra(st
 
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	pkt_data->ifindex = control->ifindex;
-	pkt_data->flags &= ~(IEEE80211_TXPD_REQ_TX_STATUS |
-		IEEE80211_TXPD_DO_NOT_ENCRYPT | IEEE80211_TXPD_REQUEUE |
-		IEEE80211_TXPD_MGMT_IFACE);
+	pkt_data->flags = 0;
 	if (control->flags & IEEE80211_TXCTL_REQ_TX_STATUS)
 		pkt_data->flags |= IEEE80211_TXPD_REQ_TX_STATUS;
 	if (control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT)


