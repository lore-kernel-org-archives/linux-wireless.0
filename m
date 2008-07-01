Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:49610 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbYGALQb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 07:16:31 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/2 V2] mac80211: add bar capability
Date: Tue,  1 Jul 2008 14:16:03 +0300
Message-Id: <1214910963-8104-1-git-send-email-tomas.winkler@intel.com> (sfid-20080701_131635_910003_F0AB3417)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch adds block ack request capability

Signed-off-by: Ester Kummer <ester.kummer@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
This version removes useless skb->priority setting 

 include/linux/ieee80211.h  |    4 ++++
 include/net/mac80211.h     |    3 +++
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/main.c        |   21 +++++++++++++++++++--
 net/mac80211/mlme.c        |   29 +++++++++++++++++++++++++++++
 5 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index cffd6d0..aa603c3 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -658,6 +658,10 @@ struct ieee80211_bar {
 	__le16 start_seq_num;
 } __attribute__((packed));
 
+/* 802.11 BAR control masks */
+#define IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL     0x0000
+#define IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA  0x0004
+
 /**
  * struct ieee80211_ht_cap - HT capabilities
  *
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3a204ac..0a5de3e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -235,6 +235,8 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_STAT_ACK: Frame was acknowledged
  * @IEEE80211_TX_STAT_AMPDU: The frame was aggregated, so status
  * 	is for the whole aggregation.
+ * @IEEE80211_TX_STAT_AMPDU_NO_BACK: no block ack was returned,
+ * 	so consider using block ack request (BAR).
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_REQ_TX_STATUS		= BIT(0),
@@ -260,6 +262,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_STAT_TX_FILTERED		= BIT(20),
 	IEEE80211_TX_STAT_ACK			= BIT(21),
 	IEEE80211_TX_STAT_AMPDU			= BIT(22),
+	IEEE80211_TX_STAT_AMPDU_NO_BACK		= BIT(23),
 };
 
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index fcdbf09..775d5e8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -903,6 +903,7 @@ void ieee80211_send_addba_request(struct net_device *dev, const u8 *da,
 				  u16 agg_size, u16 timeout);
 void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
 				u16 initiator, u16 reason_code);
+void ieee80211_send_bar(struct net_device *dev, u8 *ra, u16 tid, u16 ssn);
 
 void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *da,
 				u16 tid, u16 initiator, u16 reason);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index f18cfd7..074f71a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1404,14 +1404,15 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	u16 frag, type;
+	__le16 fc;
 	struct ieee80211_tx_status_rtap_hdr *rthdr;
 	struct ieee80211_sub_if_data *sdata;
 	struct net_device *prev_dev = NULL;
+	struct sta_info *sta;
 
 	rcu_read_lock();
 
 	if (info->status.excessive_retries) {
-		struct sta_info *sta;
 		sta = sta_info_get(local, hdr->addr1);
 		if (sta) {
 			if (test_sta_flags(sta, WLAN_STA_PS)) {
@@ -1426,8 +1427,24 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		}
 	}
 
+	fc = hdr->frame_control;
+
+	if ((info->flags & IEEE80211_TX_STAT_AMPDU_NO_BACK) &&
+	    (ieee80211_is_data_qos(fc))) {
+		u16 tid, ssn;
+		u8 *qc;
+		sta = sta_info_get(local, hdr->addr1);
+		if (sta) {
+			qc = ieee80211_get_qos_ctl(hdr);
+			tid = qc[0] & 0xf;
+			ssn = ((le16_to_cpu(hdr->seq_ctrl) + 0x10)
+						& IEEE80211_SCTL_SEQ);
+			ieee80211_send_bar(sta->sdata->dev, hdr->addr1,
+					   tid, ssn);
+		}
+	}
+
 	if (info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
-		struct sta_info *sta;
 		sta = sta_info_get(local, hdr->addr1);
 		if (sta) {
 			ieee80211_handle_filtered_frame(local, sta, skb);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0d50d52..c9e8b5c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1538,6 +1538,35 @@ void ieee80211_send_delba(struct net_device *dev, const u8 *da, u16 tid,
 	ieee80211_sta_tx(dev, skb, 0);
 }
 
+void ieee80211_send_bar(struct net_device *dev, u8 *ra, u16 tid, u16 ssn)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sk_buff *skb;
+	struct ieee80211_bar *bar;
+	u16 bar_control = 0;
+
+	skb = dev_alloc_skb(sizeof(*bar) + local->hw.extra_tx_headroom);
+	if (!skb) {
+		printk(KERN_ERR "%s: failed to allocate buffer for "
+			"bar frame\n", dev->name);
+		return;
+	}
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	bar = (struct ieee80211_bar *)skb_put(skb, sizeof(*bar));
+	memset(bar, 0, sizeof(*bar));
+	bar->frame_control = IEEE80211_FC(IEEE80211_FTYPE_CTL,
+					IEEE80211_STYPE_BACK_REQ);
+	memcpy(bar->ra, ra, ETH_ALEN);
+	memcpy(bar->ta, dev->dev_addr, ETH_ALEN);
+	bar_control |= (u16)IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL;
+	bar_control |= (u16)IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA;
+	bar_control |= (u16)(tid << 12);
+	bar->control = cpu_to_le16(bar_control);
+	bar->start_seq_num = cpu_to_le16(ssn);
+
+	ieee80211_sta_tx(dev, skb, 0);
+}
+
 void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *ra, u16 tid,
 					u16 initiator, u16 reason)
 {
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

