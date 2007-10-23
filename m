Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3362 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbXJWWJh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2007 18:09:37 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, flamingice@sourmilk.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [RFC] mac80211: no missing key complaint if frame may not be for us
Date: Tue, 23 Oct 2007 17:46:20 -0400
Message-Id: <1193175981828-git-send-email-linville@tuxdriver.com> (sfid-20071023_230945_570294_0AD8EAEA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some APs implement support for multiple SSIDs using a single BSSID.
Each SSID might implement a different protection scheme (or none
at all).

If we are associated with an unprotected SSID on an AP operating as
described above, we might receive multicast frames that are actually
intended for another SSID.  If that SSID is protected, those frames
currently cause us to log a KERN_DEBUG message: "RX protected frame
but have no key".  This can cause a lot of traffic in the logs.

Rather than complain if we receive a protected frame for which we
have no key, then let's just keep quiet unless we are in something
other than managed mode or unless the frame is unicast.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/rx.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 064924c..1cc67ef 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -509,7 +509,13 @@ ieee80211_rx_h_decrypt(struct ieee80211_txrx_data *rx)
 		rx->key->tx_rx_count++;
 		/* TODO: add threshold stuff again */
 	} else {
-		if (net_ratelimit())
+		/* if there are multiple SSIDs on this BSSID, the frame may
+		   not be for us anyway; so, check that either the frame is
+		   unicast or that we are not in managed mode before
+		   complaining about a missing key */
+		if ((!is_multicast_ether_addr(hdr->addr1) ||
+		     rx->sdata->type != IEEE80211_IF_TYPE_STA) &&
+		    net_ratelimit())
 			printk(KERN_DEBUG "%s: RX protected frame,"
 			       " but have no key\n", rx->dev->name);
 		return TXRX_DROP;
-- 
1.5.2.4

