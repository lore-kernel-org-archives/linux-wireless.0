Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41723 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab3JNQBJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 12:01:09 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: add ieee80211_tx_prepare_skb() helper function
Date: Mon, 14 Oct 2013 18:01:00 +0200
Message-Id: <1381766460-84515-1-git-send-email-nbd@openwrt.org> (sfid-20131014_180113_620647_8E93D692)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This can be used by a driver to prepare skbs for transmission, which were
obtained via functions such as ieee80211_probereq_get or
ieee80211_nullfunc_get.

This is useful for drivers that want to send those frames directly, but
need rate control information to be prepared first.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h | 14 ++++++++++++++
 net/mac80211/tx.c      | 29 +++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f386c48..cf2f32a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4567,4 +4567,18 @@ void ieee80211_report_wowlan_wakeup(struct ieee80211_vif *vif,
 				    struct cfg80211_wowlan_wakeup *wakeup,
 				    gfp_t gfp);
 
+/**
+ * ieee80211_tx_prepare_skb - prepare an 802.11 skb for transmission
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @vif: virtual interface
+ * @skb: frame to be sent from within the driver
+ * @band: the band to transmit on
+ * @sta: optional pointer to get the station to send the frame to
+ *
+ * Note: must be called under RCU lock
+ */
+bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif, struct sk_buff *skb,
+			      int band, struct ieee80211_sta **sta);
+
 #endif /* MAC80211_H */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9993fcb..4340aa7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1367,6 +1367,35 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 	return 0;
 }
 
+bool ieee80211_tx_prepare_skb(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif, struct sk_buff *skb,
+			      int band, struct ieee80211_sta **sta)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_data tx;
+
+	if (ieee80211_tx_prepare(sdata, &tx, skb) == TX_DROP)
+		return false;
+
+	info->band = band;
+	info->control.vif = vif;
+	info->hw_queue = vif->hw_queue[skb_get_queue_mapping(skb)];
+
+	if (invoke_tx_handlers(&tx))
+		return false;
+
+	if (sta) {
+		if (tx.sta)
+			*sta = &tx.sta->sta;
+		else
+			*sta = NULL;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(ieee80211_tx_prepare_skb);
+
 /*
  * Returns false if the frame couldn't be transmitted but was queued instead.
  */
-- 
1.8.0.2

