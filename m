Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3867 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S947393AbXHMTH0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 15:07:26 -0400
Date: Mon, 13 Aug 2007 14:32:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: jbenc@suse.cz, flamingice@sourmilk.net
Subject: [PATCH] mac80211: rate limit WEP bad keyidx message
Message-ID: <20070813183259.GC19115@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---

 net/mac80211/rx.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0a10720..d74b6cb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -343,13 +343,15 @@ ieee80211_rx_h_load_key(struct ieee80211_txrx_data *rx)
 			if (!rx->key) {
 				if (!rx->u.rx.ra_match)
 					return TXRX_DROP;
-				printk(KERN_DEBUG "%s: RX WEP frame with "
-				       "unknown keyidx %d (A1=" MAC_FMT " A2="
-				       MAC_FMT " A3=" MAC_FMT ")\n",
-				       rx->dev->name, keyidx,
-				       MAC_ARG(hdr->addr1),
-				       MAC_ARG(hdr->addr2),
-				       MAC_ARG(hdr->addr3));
+				if (net_ratelimit())
+					printk(KERN_DEBUG "%s: RX WEP frame "
+					       "with unknown keyidx %d "
+					       "(A1=" MAC_FMT " A2=" MAC_FMT
+					       " A3=" MAC_FMT ")\n",
+					       rx->dev->name, keyidx,
+					       MAC_ARG(hdr->addr1),
+					       MAC_ARG(hdr->addr2),
+					       MAC_ARG(hdr->addr3));
 				if (!rx->local->apdev)
 					return TXRX_DROP;
 				ieee80211_rx_mgmt(
-- 
John W. Linville
linville@tuxdriver.com
