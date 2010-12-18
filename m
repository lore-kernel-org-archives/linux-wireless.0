Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44707 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932097Ab0LRSbR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Dec 2010 13:31:17 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Felix Fietkau <nbd@openwrt.org>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/3] mac80211: fix initialization of skb->cb in ieee80211_subif_start_xmit
Date: Sat, 18 Dec 2010 19:30:48 +0100
Message-Id: <1292697050-25741-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The change 'mac80211: Fix BUG in pskb_expand_head when transmitting shared skbs'
added a check for copying the skb if it's shared, however the tx info variable
still points at the cb of the old skb

Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/tx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 898e864..7d78aca 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1742,7 +1742,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_info *info;
 	int ret = NETDEV_TX_BUSY, head_need;
 	u16 ethertype, hdrlen,  meshhdrlen = 0;
 	__le16 fc;
@@ -2033,6 +2033,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	skb_set_network_header(skb, nh_pos);
 	skb_set_transport_header(skb, h_pos);
 
+	info = IEEE80211_SKB_CB(skb);
 	memset(info, 0, sizeof(*info));
 
 	dev->trans_start = jiffies;
-- 
1.7.3.2

