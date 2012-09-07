Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43544 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933244Ab2IGOyY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 10:54:24 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/2] mac80211: validate skb->dev in the tx status path
Date: Fri,  7 Sep 2012 16:54:15 +0200
Message-Id: <1347029656-41430-1-git-send-email-nbd@openwrt.org> (sfid-20120907_165428_164546_AA0B2B21)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

skb->dev might contain a stale reference to a device that was already
deleted, and using it unchecked can lead to invalid pointer accesses.
Since this is only used for nl80211 tx, iterate over active interfaces
to find a match for skb->dev, and discard the tx status if the device
is gone.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/status.c |   46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index b0801b7..6a21562 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -516,30 +516,46 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 
 	if (info->flags & IEEE80211_TX_INTFL_NL80211_FRAME_TX) {
+		struct ieee80211_sub_if_data *p2p_sdata;
 		u64 cookie = (unsigned long)skb;
+		bool found = false;
+
 		acked = info->flags & IEEE80211_TX_STAT_ACK;
 
-		if (ieee80211_is_nullfunc(hdr->frame_control) ||
-		    ieee80211_is_qos_nullfunc(hdr->frame_control)) {
-			cfg80211_probe_status(skb->dev, hdr->addr1,
-					      cookie, acked, GFP_ATOMIC);
-		} else if (skb->dev) {
-			cfg80211_mgmt_tx_status(
-				skb->dev->ieee80211_ptr, cookie, skb->data,
-				skb->len, acked, GFP_ATOMIC);
-		} else {
-			struct ieee80211_sub_if_data *p2p_sdata;
+		rcu_read_lock();
+
+		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+			if (!sdata->dev)
+				continue;
 
-			rcu_read_lock();
+			if (skb->dev != sdata->dev)
+				continue;
 
+			found = true;
+			break;
+		}
+
+		if (!skb->dev) {
 			p2p_sdata = rcu_dereference(local->p2p_sdata);
 			if (p2p_sdata) {
-				cfg80211_mgmt_tx_status(
-					&p2p_sdata->wdev, cookie, skb->data,
-					skb->len, acked, GFP_ATOMIC);
+				skb->dev = p2p_sdata->dev;
+				found = true;
 			}
-			rcu_read_unlock();
 		}
+
+		if (!found)
+			skb->dev = NULL;
+		else if (ieee80211_is_nullfunc(hdr->frame_control) ||
+			 ieee80211_is_qos_nullfunc(hdr->frame_control)) {
+			cfg80211_probe_status(skb->dev, hdr->addr1,
+					      cookie, acked, GFP_ATOMIC);
+		} else {
+			cfg80211_mgmt_tx_status(
+				skb->dev->ieee80211_ptr, cookie, skb->data,
+				skb->len, acked, GFP_ATOMIC);
+		}
+
+		rcu_read_unlock();
 	}
 
 	if (unlikely(info->ack_frame_id)) {
-- 
1.7.9.6 (Apple Git-31.1)

