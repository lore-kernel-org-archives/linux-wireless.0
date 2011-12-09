Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41369 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1LIIuC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 03:50:02 -0500
Received: by eaak14 with SMTP id k14so1607367eaa.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 00:50:01 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@openwrt.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [RFC] mac80211: Send BAR on same queue as the according QoS frames
Date: Fri,  9 Dec 2011 09:49:53 +0100
Message-Id: <1323420593-9638-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111209_095007_496758_D350E17F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sending as RFC for now since I'm not sure if this is really required. At least
I couldn't come up with a situation where this would be required. However, it
looks more correct to me to put the BAR into the same queue as the previously
failed QoS frame to avoid possible (?) side effect of the BAR overtaking frames
in the hw tx queues ...

Any thoughts?

Thanks,
Helmut

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/agg-tx.c      |    2 +-
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/tx.c          |   13 +++++++++----
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index c45fa5d..f4f47e4 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -134,7 +134,7 @@ void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)
 	bar->start_seq_num = cpu_to_le16(ssn);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-	ieee80211_tx_skb(sdata, skb);
+	ieee80211_tx_skb_tid(sdata, skb, tid);
 }
 EXPORT_SYMBOL(ieee80211_send_bar);
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 96fe754..5ae5c50 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1350,6 +1350,7 @@ void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int ke
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata);
 void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
+void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb, int tid);
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems);
 u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e74652d..39f7132 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2700,15 +2700,14 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_get_buffered_bc);
 
-void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
+void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb, int tid)
 {
 	skb_set_mac_header(skb, 0);
 	skb_set_network_header(skb, 0);
 	skb_set_transport_header(skb, 0);
 
-	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
-	skb_set_queue_mapping(skb, IEEE80211_AC_VO);
-	skb->priority = 7;
+	skb_set_queue_mapping(skb, ieee802_1d_to_ac[tid]);
+	skb->priority = tid;
 
 	/*
 	 * The other path calling ieee80211_xmit is from the tasklet,
@@ -2719,3 +2718,9 @@ void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	ieee80211_xmit(sdata, skb);
 	local_bh_enable();
 }
+
+void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
+{
+	ieee80211_tx_skb_tid(sdata, skb, 7);
+}
+
-- 
1.7.7

