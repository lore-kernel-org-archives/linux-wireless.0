Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:16274 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534AbYGPBo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 21:44:29 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1738137yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2008 18:44:29 -0700 (PDT)
Subject: [PATCH 11/12] mac80211: remove rx/tx_data->fc member
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 18:44:14 -0700
Message-Id: <1216172654.6610.59.camel@brick> (sfid-20080716_034542_877814_22111CC6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/mac80211/ieee80211_i.h |    4 ++--
 net/mac80211/rx.c          |    8 ++------
 net/mac80211/tx.c          |    1 -
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0a235cd..47e0979 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -170,7 +170,7 @@ struct ieee80211_tx_data {
 	struct sk_buff **extra_frag;
 	int num_extra_frag;
 
-	u16 fc, ethertype;
+	u16 ethertype;
 	unsigned int flags;
 };
 
@@ -198,7 +198,7 @@ struct ieee80211_rx_data {
 	struct ieee80211_rx_status *status;
 	struct ieee80211_rate *rate;
 
-	u16 fc, ethertype;
+	u16 ethertype;
 	unsigned int flags;
 	int sent_ps_buffered;
 	int queue;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1a0ff8d..d3eb135 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1052,7 +1052,6 @@ ieee80211_rx_h_remove_qos_control(struct ieee80211_rx_data *rx)
 		ieee80211_hdrlen(hdr->frame_control) - IEEE80211_QOS_CTL_LEN);
 	hdr = (struct ieee80211_hdr *)skb_pull(rx->skb, IEEE80211_QOS_CTL_LEN);
 	/* change frame type to non QOS */
-	rx->fc &= ~IEEE80211_STYPE_QOS_DATA;
 	hdr->frame_control &= ~cpu_to_le16(IEEE80211_STYPE_QOS_DATA);
 
 	return RX_CONTINUE;
@@ -1808,7 +1807,6 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 
 	rx.status = status;
 	rx.rate = rate;
-	rx.fc = le16_to_cpu(hdr->frame_control);
 
 	if (ieee80211_is_data(hdr->frame_control) || ieee80211_is_mgmt(hdr->frame_control))
 		local->dot11ReceivedFragmentCount++;
@@ -1871,14 +1869,12 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 				       prev->dev->name);
 			continue;
 		}
-		rx.fc = le16_to_cpu(hdr->frame_control);
 		ieee80211_invoke_rx_handlers(prev, &rx, skb_new);
 		prev = sdata;
 	}
-	if (prev) {
-		rx.fc = le16_to_cpu(hdr->frame_control);
+	if (prev)
 		ieee80211_invoke_rx_handlers(prev, &rx, skb);
-	} else
+	else
 		dev_kfree_skb(skb);
 }
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 61203af..b65abfc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -993,7 +993,6 @@ __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 	hdr = (struct ieee80211_hdr *) skb->data;
 
 	tx->sta = sta_info_get(local, hdr->addr1);
-	tx->fc = le16_to_cpu(hdr->frame_control);
 
 	if (is_multicast_ether_addr(hdr->addr1)) {
 		tx->flags &= ~IEEE80211_TX_UNICAST;
-- 
1.5.6.3.499.geae9


