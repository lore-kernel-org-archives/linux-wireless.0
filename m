Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:28918 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbXLYPAv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Dec 2007 10:00:51 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 6/8 v3] mac80211: A-MPDU Rx adding BAR handling capability
Date: Tue, 25 Dec 2007 17:00:36 +0200
Message-Id: <11985948452300-git-send-email-ron.rindjunsky@intel.com> (sfid-20071225_150103_039108_F4AEA78A)
In-Reply-To: <11985948383801-git-send-email-ron.rindjunsky@intel.com>
References: <11985948383801-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the ability to handle Block Ack Request

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211_i.h |    3 +-
 net/mac80211/rx.c          |   62 +++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/util.c        |   15 ++++++++++-
 3 files changed, 74 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cf2256b..c91087f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -804,7 +804,8 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
 extern const unsigned char rfc1042_header[6];
 extern const unsigned char bridge_tunnel_header[6];
-u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len);
+u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
+			enum ieee80211_if_types type);
 int ieee80211_is_eapol(const struct sk_buff *skb, int hdrlen);
 int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 			     int rate, int erp, int short_preamble);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0661eed..2cdc34b 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -24,6 +24,10 @@
 #include "tkip.h"
 #include "wme.h"
 
+u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
+				struct tid_ampdu_rx *tid_agg_rx,
+				struct sk_buff *skb, u16 mpdu_seq_num,
+				int bar_req);
 /*
  * monitor mode reception
  *
@@ -64,7 +68,9 @@ static inline int should_drop_frame(struct ieee80211_rx_status *status,
 	if (((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FTYPE)) ==
 			cpu_to_le16(IEEE80211_FTYPE_CTL)) &&
 	    ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_STYPE)) !=
-			cpu_to_le16(IEEE80211_STYPE_PSPOLL)))
+			cpu_to_le16(IEEE80211_STYPE_PSPOLL)) &&
+	    ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_STYPE)) !=
+			cpu_to_le16(IEEE80211_STYPE_BACK_REQ)))
 		return 1;
 	return 0;
 }
@@ -630,7 +636,8 @@ ieee80211_rx_h_sta_process(struct ieee80211_txrx_data *rx)
 	 * BSSID to avoid keeping the current IBSS network alive in cases where
 	 * other STAs are using different BSSID. */
 	if (rx->sdata->type == IEEE80211_IF_TYPE_IBSS) {
-		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len);
+		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len,
+						IEEE80211_IF_TYPE_IBSS);
 		if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) == 0)
 			sta->last_rx = jiffies;
 	} else
@@ -1358,6 +1365,49 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 }
 
 static ieee80211_txrx_result
+ieee80211_rx_h_ctrl(struct ieee80211_txrx_data *rx)
+{
+	struct ieee80211_local *local = rx->local;
+	struct ieee80211_hw *hw = &local->hw;
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_bar *bar = (struct ieee80211_bar *) skb->data;
+	struct tid_ampdu_rx *tid_agg_rx;
+	u16 start_seq_num;
+	u16 tid;
+
+	if (likely((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_CTL))
+		return TXRX_CONTINUE;
+
+	if ((rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BACK_REQ) {
+		if (!rx->sta)
+			return TXRX_CONTINUE;
+		tid = le16_to_cpu(bar->control) >> 12;
+		tid_agg_rx = &(rx->sta->ampdu_mlme.tid_rx[tid]);
+		if (tid_agg_rx->state != HT_AGG_STATE_OPERATIONAL)
+			return TXRX_CONTINUE;
+
+		start_seq_num = le16_to_cpu(bar->start_seq_num) >> 4;
+
+		/* reset session timer */
+		if (tid_agg_rx->timeout) {
+			unsigned long expires =
+				jiffies + (tid_agg_rx->timeout / 1000) * HZ;
+			mod_timer(&tid_agg_rx->session_timer, expires);
+		}
+
+		/* manage reordering buffer according to requested */
+		/* sequence number */
+		rcu_read_lock();
+		ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, NULL,
+						 start_seq_num, 1);
+		rcu_read_unlock();
+		return TXRX_DROP;
+	}
+
+	return TXRX_CONTINUE;
+}
+
+static ieee80211_txrx_result
 ieee80211_rx_h_mgmt(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -1508,6 +1558,7 @@ ieee80211_rx_handler ieee80211_rx_handlers[] =
 	ieee80211_rx_h_remove_qos_control,
 	ieee80211_rx_h_amsdu,
 	ieee80211_rx_h_data,
+	ieee80211_rx_h_ctrl,
 	ieee80211_rx_h_mgmt,
 	NULL
 };
@@ -1651,8 +1702,6 @@ void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw, struct sk_buff *skb,
 		return;
 	}
 
-	bssid = ieee80211_get_bssid(hdr, skb->len);
-
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!netif_running(sdata->dev))
 			continue;
@@ -1660,6 +1709,7 @@ void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw, struct sk_buff *skb,
 		if (sdata->type == IEEE80211_IF_TYPE_MNTR)
 			continue;
 
+		bssid = ieee80211_get_bssid(hdr, skb->len, sdata->type);
 		rx.flags |= IEEE80211_TXRXD_RXRA_MATCH;
 		prepares = prepare_for_handlers(sdata, bssid, &rx, hdr);
 		/* prepare_for_handlers can change sta */
@@ -1733,6 +1783,10 @@ static inline u16 seq_sub(u16 sq1, u16 sq2)
 }
 
 
+/*
+ * As it function blongs to Rx path it must be called with
+ * the proper rcu_read_lock protection for its flow.
+ */
 u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 				struct tid_ampdu_rx *tid_agg_rx,
 				struct sk_buff *skb, u16 mpdu_seq_num,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index fb7fd89..d567b83 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -131,7 +131,8 @@ void ieee80211_prepare_rates(struct ieee80211_local *local,
 	}
 }
 
-u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
+u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
+			enum ieee80211_if_types type)
 {
 	u16 fc;
 
@@ -163,6 +164,18 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
 	case IEEE80211_FTYPE_CTL:
 		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)
 			return hdr->addr1;
+		else if ((fc & IEEE80211_FCTL_STYPE) ==
+						IEEE80211_STYPE_BACK_REQ) {
+			switch (type) {
+			case IEEE80211_IF_TYPE_STA:
+				return hdr->addr2;
+			case IEEE80211_IF_TYPE_AP:
+			case IEEE80211_IF_TYPE_VLAN:
+				return hdr->addr1;
+			default:
+				return NULL;
+			}
+		}
 		else
 			return NULL;
 	}
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

