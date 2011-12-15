Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58178 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067Ab1LOIJq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 03:09:46 -0500
Received: by wgbds13 with SMTP id ds13so655747wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 00:09:45 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	adrian@freebsd.org, Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCHv2] mac80211: Use appropriate TID for sending BAR, ADDBA and DELBA frames
Date: Thu, 15 Dec 2011 09:02:18 +0100
Message-Id: <1323936138-11357-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111215_091027_797316_E4F5780D)
In-Reply-To: <1323871851-4808-1-git-send-email-helmut.schaa@googlemail.com>
References: <1323871851-4808-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently BAR, ADDBA and DELBA frames are always sent using AC_VO. If
the TID for which a BA session is established is assigned to a different
queue BAR, ADDBA and DELBA frames can "overtake" frames of the according
BA session.

Hence, always put BA session related frames into the same queue as the
BA sessions data frames.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Changes in v2: Make ieee80211_tx_skb an inline function.

 net/mac80211/agg-tx.c      |    4 ++--
 net/mac80211/ht.c          |    2 +-
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/tx.c          |   14 ++++++++++----
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 7380287..13ae622 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -105,7 +105,7 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.u.addba_req.start_seq_num =
 					cpu_to_le16(start_seq_num << 4);
 
-	ieee80211_tx_skb(sdata, skb);
+	ieee80211_tx_skb_tid(sdata, skb, tid);
 }
 
 void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)
@@ -134,7 +134,7 @@ void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)
 	bar->start_seq_num = cpu_to_le16(ssn);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-	ieee80211_tx_skb(sdata, skb);
+	ieee80211_tx_skb_tid(sdata, skb, tid);
 }
 EXPORT_SYMBOL(ieee80211_send_bar);
 
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 0fd9c2a..f25fff7 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -300,7 +300,7 @@ void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 	mgmt->u.action.u.delba.params = cpu_to_le16(params);
 	mgmt->u.action.u.delba.reason_code = cpu_to_le16(reason_code);
 
-	ieee80211_tx_skb(sdata, skb);
+	ieee80211_tx_skb_tid(sdata, skb, tid);
 }
 
 void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 96fe754..93d7c86b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1350,6 +1350,8 @@ void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int ke
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata);
 void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
+void ieee80211_tx_skb_tid(struct ieee80211_sub_if_data *sdata,
+			  struct sk_buff *skb, int tid);
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems);
 u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e74652d..4fad705 100644
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
@@ -2719,3 +2718,10 @@ void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	ieee80211_xmit(sdata, skb);
 	local_bh_enable();
 }
+
+void inline ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
+{
+	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
+	ieee80211_tx_skb_tid(sdata, skb, 7);
+}
+
-- 
1.7.7

