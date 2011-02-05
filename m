Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51594 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700Ab1BEWso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Feb 2011 17:48:44 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	sbrown@cortland.com
Subject: [PATCH] mac80211: as a 4-addr station, do not receive packets for other stations
Date: Sat,  5 Feb 2011 23:48:37 +0100
Message-Id: <1296946117-23329-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since 4-addr frames completely override the source address which will
make it into the converted 802.3 frames, receiving frames for other
4-addr stations will confuse the bridging code.

To be able to handle traffic for all connected devices, the bridge
code will automatically turn on promiscuous mode, which triggers
this problem.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Steve Brown <sbrown@cortland.com>
---
 net/mac80211/rx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b5f59ed..50c2c88 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2646,7 +2646,8 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			return 0;
 		if (!multicast &&
 		    compare_ether_addr(sdata->vif.addr, hdr->addr1) != 0) {
-			if (!(sdata->dev->flags & IFF_PROMISC))
+			if (!(sdata->dev->flags & IFF_PROMISC) ||
+			    sdata->u.mgd.use_4addr)
 				return 0;
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		}
-- 
1.7.3.2

