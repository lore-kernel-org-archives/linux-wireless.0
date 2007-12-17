Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3883 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072AbXLQP6D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 10:58:03 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 6/8] mac80211: A-MPDU Rx adding BAR handling capability
Date: Mon, 17 Dec 2007 17:57:47 +0200
Message-Id: <11979070783125-git-send-email-ron.rindjunsky@intel.com> (sfid-20071217_155807_660509_F0C47281)
In-Reply-To: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the ability to handle Block Ack Request

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/ieee80211_i.h |    3 +-
 net/mac80211/rx.c          |   53 ++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/util.c        |   12 +++++++++-
 3 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cf2256b..ed7ae6f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -804,7 +804,8 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
 extern const unsigned char rfc1042_header[6];
 extern const unsigned char bridge_tunnel_header[6];
-u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len);
+u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
+			unsigned int type);
 int ieee80211_is_eapol(const struct sk_buff *skb, int hdrlen);
 int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
 			     int rate, int erp, int short_preamble);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7a705eb..ca0e89f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -64,7 +64,9 @@ static inline int should_drop_frame(struct ieee80211_rx_status *status,
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
@@ -803,7 +805,8 @@ ieee80211_rx_h_sta_process(struct ieee80211_txrx_data *rx)
 	 * BSSID to avoid keeping the current IBSS network alive in cases where
 	 * other STAs are using different BSSID. */
 	if (rx->sdata->type == IEEE80211_IF_TYPE_IBSS) {
-		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len);
+		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len,
+						IEEE80211_IF_TYPE_IBSS);
 		if (compare_ether_addr(bssid, rx->sdata->u.sta.bssid) == 0)
 			sta->last_rx = jiffies;
 	} else
@@ -1530,6 +1533,48 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
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
+		ieee80211_sta_manage_reorder_buf(hw, rx, tid_agg_rx,
+						NULL, start_seq_num, 1);
+
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
@@ -1680,6 +1725,7 @@ ieee80211_rx_handler ieee80211_rx_handlers[] =
 	ieee80211_rx_h_remove_qos_control,
 	ieee80211_rx_h_amsdu,
 	ieee80211_rx_h_data,
+	ieee80211_rx_h_ctrl,
 	ieee80211_rx_h_mgmt,
 	NULL
 };
@@ -1841,8 +1887,6 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		return;
 	}
 
-	bssid = ieee80211_get_bssid(hdr, skb->len);
-
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (!netif_running(sdata->dev))
 			continue;
@@ -1850,6 +1894,7 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		if (sdata->type == IEEE80211_IF_TYPE_MNTR)
 			continue;
 
+		bssid = ieee80211_get_bssid(hdr, skb->len, sdata->type);
 		rx.flags |= IEEE80211_TXRXD_RXRA_MATCH;
 		prepres = prepare_for_handlers(sdata, bssid, &rx, hdr);
 		/* prepare_for_handlers can change sta */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index fb7fd89..d1a6138 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -131,7 +131,8 @@ void ieee80211_prepare_rates(struct ieee80211_local *local,
 	}
 }
 
-u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
+u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
+			unsigned int type)
 {
 	u16 fc;
 
@@ -163,6 +164,15 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
 	case IEEE80211_FTYPE_CTL:
 		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)
 			return hdr->addr1;
+		else if ((fc & IEEE80211_FCTL_STYPE) ==
+						IEEE80211_STYPE_BACK_REQ) {
+			switch (type) {
+			case IEEE80211_IF_TYPE_STA:
+				return hdr->addr2;
+			case IEEE80211_IF_TYPE_AP:
+				return hdr->addr1;
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

