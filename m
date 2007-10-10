Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2226 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbXJJBid (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 21:38:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: filter locally-originated multicast frames
Date: Tue,  9 Oct 2007 21:30:41 -0400
Message-Id: <11919798432071-git-send-email-linville@tuxdriver.com> (sfid-20071010_023839_010030_3280B7A7)
In-Reply-To: <11919798433964-git-send-email-linville@tuxdriver.com>
References: <11919798433964-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: John W. Linville <linville@tuxdriver.com>

In STA mode, the AP will echo our traffic.  This includes multicast
traffic.

Receiving these frames confuses some protocols and applications,
notably IPv6 Duplicate Address Detection.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ieee80211.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index ad73a40..9e0da6e 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -2844,9 +2844,10 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 		memcpy(dst, hdr->addr1, ETH_ALEN);
 		memcpy(src, hdr->addr3, ETH_ALEN);
 
-		if (sdata->type != IEEE80211_IF_TYPE_STA) {
+		if (sdata->type != IEEE80211_IF_TYPE_STA ||
+		    (is_multicast_ether_addr(dst) &&
+		     !compare_ether_addr(src, dev->dev_addr)))
 			return TXRX_DROP;
-		}
 		break;
 	case 0:
 		/* DA SA BSSID */
-- 
1.5.2.4

