Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:53161 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab0AHRPP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:15:15 -0500
Message-ID: <4B476821.50306@openwrt.org>
Date: Fri, 08 Jan 2010 18:15:13 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/3] mac80211: do not transmit frames on unconfigured 4-addr
 vlan interfaces
References: <4B476612.4090509@openwrt.org> <4B476722.4040508@openwrt.org>
In-Reply-To: <4B476722.4040508@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If frames are transmitted on 4-addr ap vlan interfaces with no station,
they end up being transmitted unencrypted, even if the ap interface
uses WPA. This patch add some sanity checking to make sure that this
does not happen.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1051,8 +1051,11 @@ ieee80211_tx_prepare(struct ieee80211_su

 	hdr = (struct ieee80211_hdr *) skb->data;

-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		tx->sta = rcu_dereference(sdata->u.vlan.sta);
+		if (!tx->sta && sdata->dev->ieee80211_ptr->use_4addr)
+			return TX_DROP;
+	}
 	if (!tx->sta)
 		tx->sta = sta_info_get(sdata, hdr->addr1);


