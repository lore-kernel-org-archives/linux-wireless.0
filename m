Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54666 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab1HJTpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 15:45:52 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	johannes@sipsolutions.net
Subject: [PATCH 1/2] mac80211: make ieee80211_send_bar available for drivers
Date: Wed, 10 Aug 2011 13:45:26 -0600
Message-Id: <1313005527-83182-1-git-send-email-nbd@openwrt.org> (sfid-20110810_214559_691911_CE82CCA2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To properly maintain the peer's block ack window, the driver needs to be
able to control the new starting sequence number that is sent along with
the BlockAckReq frame.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h     |   13 +++++++++++++
 net/mac80211/agg-tx.c      |    4 +++-
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/status.c      |    2 +-
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2f01d84..03e5ad8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3218,6 +3218,19 @@ void ieee80211_remain_on_channel_expired(struct ieee80211_hw *hw);
 void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
 				  const u8 *addr);
 
+/**
+ * ieee80211_send_bar - send a BlockAckReq frame
+ *
+ * can be used to flush pending frames from the peer's aggregation reorder
+ * buffer.
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @ra: the peer's destination address
+ * @tid: the TID of the aggregation session
+ * @ssn: the new starting sequence number for the receiver
+ */
+void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn);
+
 /* Rate control API */
 
 /**
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index b7075f3..62d61fb 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -106,8 +106,9 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb);
 }
 
-void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn)
+void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)
 {
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_bar *bar;
@@ -135,6 +136,7 @@ void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u1
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 	ieee80211_tx_skb(sdata, skb);
 }
+EXPORT_SYMBOL(ieee80211_send_bar);
 
 void ieee80211_assign_tid_tx(struct sta_info *sta, int tid,
 			     struct tid_ampdu_tx *tid_tx)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 286ac5d..9ea38b5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1248,7 +1248,6 @@ struct ieee80211_tx_status_rtap_hdr {
 void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
 				       struct ieee80211_sta_ht_cap *ht_cap);
-void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn);
 void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 			  const u8 *da, u16 tid,
 			  u16 initiator, u16 reason_code);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index a89cca3..95e0a8b 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -239,7 +239,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			tid = qc[0] & 0xf;
 			ssn = ((le16_to_cpu(hdr->seq_ctrl) + 0x10)
 						& IEEE80211_SCTL_SEQ);
-			ieee80211_send_bar(sta->sdata, hdr->addr1,
+			ieee80211_send_bar(&sta->sdata->vif, hdr->addr1,
 					   tid, ssn);
 		}
 
-- 
1.7.3.2

