Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35710 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410AbcBBNjR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 08:39:17 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/3] mac80211: move A-MSDU skb_linearize call to ieee80211_amsdu_to_8023s
Date: Tue,  2 Feb 2016 14:39:08 +0100
Message-Id: <1454420350-8313-1-git-send-email-nbd@openwrt.org> (sfid-20160202_143921_803617_4223FB8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prepararation for zero-copy A-MSDU support with page fragment SKBs

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/rx.c   | 3 ---
 net/wireless/util.c | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 664e886..1e9308e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2203,9 +2203,6 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	skb->dev = dev;
 	__skb_queue_head_init(&frame_list);
 
-	if (skb_linearize(skb))
-		return RX_DROP_UNUSABLE;
-
 	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
 				 rx->sdata->vif.type,
 				 rx->local->hw.extra_tx_headroom, true);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 9277042..6a40769 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -657,6 +657,9 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 	int remaining, err;
 	u8 dst[ETH_ALEN], src[ETH_ALEN];
 
+	if (skb_linearize(skb))
+		goto out;
+
 	if (has_80211_header) {
 		err = ieee80211_data_to_8023(skb, addr, iftype);
 		if (err)
-- 
2.2.2

