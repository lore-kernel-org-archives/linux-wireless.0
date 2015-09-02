Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35534 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbbIBLZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 07:25:34 -0400
Received: by wicge5 with SMTP id ge5so37144868wic.0
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2015 04:25:33 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@openwrt.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/2] mac80211: Split sending tx'ed frames to monitor interfaces into its own function
Date: Wed,  2 Sep 2015 13:23:30 +0200
Message-Id: <1441193011-2040-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20150902_132544_401497_65056A48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows ieee80211_tx_monitor to be used directly for sending 802.11 frames
to all monitor interfaces.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/ieee80211_i.h |   3 ++
 net/mac80211/status.c      | 108 +++++++++++++++++++++++++--------------------
 2 files changed, 62 insertions(+), 49 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6e52659..36552de 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1641,6 +1641,9 @@ void ieee80211_purge_tx_queue(struct ieee80211_hw *hw,
 struct sk_buff *
 ieee80211_build_data_template(struct ieee80211_sub_if_data *sdata,
 			      struct sk_buff *skb, u32 info_flags);
+void ieee80211_tx_monitor(struct ieee80211_local *local, struct sk_buff *skb,
+			  struct ieee80211_supported_band *sband,
+			  int retry_count, int shift, bool send_to_cooked);
 
 void ieee80211_check_fast_xmit(struct sta_info *sta);
 void ieee80211_check_fast_xmit_all(struct ieee80211_local *local);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 8ba5832..98fd04c 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -668,16 +668,70 @@ void ieee80211_tx_status_noskb(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_tx_status_noskb);
 
-void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
+void ieee80211_tx_monitor(struct ieee80211_local *local, struct sk_buff *skb,
+			  struct ieee80211_supported_band *sband,
+			  int retry_count, int shift, bool send_to_cooked)
 {
 	struct sk_buff *skb2;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sub_if_data *sdata;
+	struct net_device *prev_dev = NULL;
+	int rtap_len;
+
+	/* send frame to monitor interfaces now */
+	rtap_len = ieee80211_tx_radiotap_len(info);
+	if (WARN_ON_ONCE(skb_headroom(skb) < rtap_len)) {
+		pr_err("ieee80211_tx_status: headroom too small\n");
+		dev_kfree_skb(skb);
+		return;
+	}
+	ieee80211_add_tx_radiotap_header(local, sband, skb, retry_count,
+					 rtap_len, shift);
+
+	/* XXX: is this sufficient for BPF? */
+	skb_set_mac_header(skb, 0);
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	skb->pkt_type = PACKET_OTHERHOST;
+	skb->protocol = htons(ETH_P_802_2);
+	memset(skb->cb, 0, sizeof(skb->cb));
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
+			if (!ieee80211_sdata_running(sdata))
+				continue;
+
+			if ((sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) &&
+			    !send_to_cooked)
+				continue;
+
+			if (prev_dev) {
+				skb2 = skb_clone(skb, GFP_ATOMIC);
+				if (skb2) {
+					skb2->dev = prev_dev;
+					netif_rx(skb2);
+				}
+			}
+
+			prev_dev = sdata->dev;
+		}
+	}
+	if (prev_dev) {
+		skb->dev = prev_dev;
+		netif_rx(skb);
+		skb = NULL;
+	}
+	rcu_read_unlock();
+	dev_kfree_skb(skb);
+}
+
+void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
+{
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	__le16 fc;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_sub_if_data *sdata;
-	struct net_device *prev_dev = NULL;
 	struct sta_info *sta;
 	struct rhash_head *tmp;
 	int retry_count;
@@ -685,7 +739,6 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	bool send_to_cooked;
 	bool acked;
 	struct ieee80211_bar *bar;
-	int rtap_len;
 	int shift = 0;
 	int tid = IEEE80211_NUM_TIDS;
 	const struct bucket_table *tbl;
@@ -878,51 +931,8 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		return;
 	}
 
-	/* send frame to monitor interfaces now */
-	rtap_len = ieee80211_tx_radiotap_len(info);
-	if (WARN_ON_ONCE(skb_headroom(skb) < rtap_len)) {
-		pr_err("ieee80211_tx_status: headroom too small\n");
-		dev_kfree_skb(skb);
-		return;
-	}
-	ieee80211_add_tx_radiotap_header(local, sband, skb, retry_count,
-					 rtap_len, shift);
-
-	/* XXX: is this sufficient for BPF? */
-	skb_set_mac_header(skb, 0);
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
-	skb->pkt_type = PACKET_OTHERHOST;
-	skb->protocol = htons(ETH_P_802_2);
-	memset(skb->cb, 0, sizeof(skb->cb));
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
-		if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
-			if (!ieee80211_sdata_running(sdata))
-				continue;
-
-			if ((sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) &&
-			    !send_to_cooked)
-				continue;
-
-			if (prev_dev) {
-				skb2 = skb_clone(skb, GFP_ATOMIC);
-				if (skb2) {
-					skb2->dev = prev_dev;
-					netif_rx(skb2);
-				}
-			}
-
-			prev_dev = sdata->dev;
-		}
-	}
-	if (prev_dev) {
-		skb->dev = prev_dev;
-		netif_rx(skb);
-		skb = NULL;
-	}
-	rcu_read_unlock();
-	dev_kfree_skb(skb);
+	/* send to monitor interfaces */
+	ieee80211_tx_monitor(local, skb, sband, retry_count, shift, send_to_cooked);
 }
 EXPORT_SYMBOL(ieee80211_tx_status);
 
-- 
1.8.4.5

