Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:39701 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437Ab0AaWZd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2010 17:25:33 -0500
Message-ID: <4B660354.4060401@openwrt.org>
Date: Sun, 31 Jan 2010 23:25:24 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: fix sta lookup with AP VLAN interfaces and injected
 frames
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When injecting frames, mac80211 currently looks for the first AP
interface that matches the source address of the injected frame.
This breaks when such a frame is directed at a STA that has been moved
to a VLAN. This patch fixes it by using sta_info_get_bss instead of
sta_info_get, which also finds stations belonging to a VLAN interface
of the same BSS as the AP interface.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1135,6 +1135,8 @@ ieee80211_tx_prepare(struct ieee80211_su
 		tx->sta = rcu_dereference(sdata->u.vlan.sta);
 		if (!tx->sta && sdata->dev->ieee80211_ptr->use_4addr)
 			return TX_DROP;
+	} else if (info->flags & IEEE80211_TX_CTL_INJECTED) {
+		tx->sta = sta_info_get_bss(sdata, hdr->addr1);
 	}
 	if (!tx->sta)
 		tx->sta = sta_info_get(sdata, hdr->addr1);
