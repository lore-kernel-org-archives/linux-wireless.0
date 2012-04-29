Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40327 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561Ab2D2Noa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2012 09:44:30 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 3.4] mac80211: fix AP mode EAP tx for VLAN stations
Date: Sun, 29 Apr 2012 15:44:16 +0200
Message-Id: <1335707056-82230-1-git-send-email-nbd@openwrt.org> (sfid-20120429_154433_966033_EA21E06C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

EAP frames for stations in an AP VLAN are sent on the main AP interface
to avoid race conditions wrt. moving stations.
For that to work properly, sta_info_get_bss must be used instead of
sta_info_get when sending EAP packets.
Previously this was only done for cooked monitor injected packets, so
this patch adds a check for tx->skb->protocol to the same place.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 net/mac80211/tx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 44001c7..d67d36f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1159,7 +1159,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		tx->sta = rcu_dereference(sdata->u.vlan.sta);
 		if (!tx->sta && sdata->dev->ieee80211_ptr->use_4addr)
 			return TX_DROP;
-	} else if (info->flags & IEEE80211_TX_CTL_INJECTED) {
+	} else if (info->flags & IEEE80211_TX_CTL_INJECTED ||
+		   tx->sdata->control_port_protocol == tx->skb->protocol) {
 		tx->sta = sta_info_get_bss(sdata, hdr->addr1);
 	}
 	if (!tx->sta)
-- 
1.7.3.2

