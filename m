Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21761 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbXLXLgr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Dec 2007 06:36:47 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/1] mac80211: restructure __ieee80211_rx
Date: Mon, 24 Dec 2007 13:36:39 +0200
Message-Id: <11984961994110-git-send-email-ron.rindjunsky@intel.com> (sfid-20071224_113702_900332_4CF2358A)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes a separation between Rx frame pre-handling which stays in
__ieee80211_rx and Rx frame handlers, moving to __ieee80211_rx_handle_packet.
Although this separation has no affect in regular mode of operation, this kind
of mechanism will be used in A-MPDU frames reordering as it allows accumulation
of frames during pre-handling, dispatching them to later handling when necessary.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/rx.c |   86 ++++++++++++++++++++++++++++++----------------------
 1 files changed, 50 insertions(+), 36 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index e94cf30..bcc232c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -272,11 +272,11 @@ ieee80211_rx_h_parse_qos(struct ieee80211_txrx_data *rx)
 	return TXRX_CONTINUE;
 }
 
-static ieee80211_txrx_result
-ieee80211_rx_h_load_stats(struct ieee80211_txrx_data *rx)
+
+u32 ieee80211_rx_load_stats(struct ieee80211_local *local,
+			      struct sk_buff *skb,
+			      struct ieee80211_rx_status *status)
 {
-	struct ieee80211_local *local = rx->local;
-	struct sk_buff *skb = rx->skb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u32 load = 0, hdrtime;
 	struct ieee80211_rate *rate;
@@ -290,7 +290,7 @@ ieee80211_rx_h_load_stats(struct ieee80211_txrx_data *rx)
 
 	rate = &mode->rates[0];
 	for (i = 0; i < mode->num_rates; i++) {
-		if (mode->rates[i].val == rx->u.rx.status->rate) {
+		if (mode->rates[i].val == status->rate) {
 			rate = &mode->rates[i];
 			break;
 		}
@@ -315,15 +315,13 @@ ieee80211_rx_h_load_stats(struct ieee80211_txrx_data *rx)
 	/* Divide channel_use by 8 to avoid wrapping around the counter */
 	load >>= CHAN_UTIL_SHIFT;
 	local->channel_use_raw += load;
-	rx->u.rx.load = load;
 
-	return TXRX_CONTINUE;
+	return load;
 }
 
 ieee80211_rx_handler ieee80211_rx_pre_handlers[] =
 {
 	ieee80211_rx_h_parse_qos,
-	ieee80211_rx_h_load_stats,
 	NULL
 };
 
@@ -1594,11 +1592,11 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
 }
 
 /*
- * This is the receive path handler. It is called by a low level driver when an
- * 802.11 MPDU is received from the hardware.
+ * This is the actual Rx frames handler. as it blongs to Rx path it must
+ * be called with rcu_read_lock protection.
  */
-void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
-		    struct ieee80211_rx_status *status)
+void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw, struct sk_buff *skb,
+			    struct ieee80211_rx_status *status, u32 load)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
@@ -1606,36 +1604,18 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_txrx_data rx;
 	u16 type;
-	int prepres;
+	int prepares;
 	struct ieee80211_sub_if_data *prev = NULL;
 	struct sk_buff *skb_new;
 	u8 *bssid;
 
-	/*
-	 * key references and virtual interfaces are protected using RCU
-	 * and this requires that we are in a read-side RCU section during
-	 * receive processing
-	 */
-	rcu_read_lock();
-
-	/*
-	 * Frames with failed FCS/PLCP checksum are not returned,
-	 * all other frames are returned without radiotap header
-	 * if it was previously present.
-	 * Also, frames with less than 16 bytes are dropped.
-	 */
-	skb = ieee80211_rx_monitor(local, skb, status);
-	if (!skb) {
-		rcu_read_unlock();
-		return;
-	}
-
 	hdr = (struct ieee80211_hdr *) skb->data;
 	memset(&rx, 0, sizeof(rx));
 	rx.skb = skb;
 	rx.local = local;
 
 	rx.u.rx.status = status;
+	rx.u.rx.load = load;
 	rx.fc = le16_to_cpu(hdr->frame_control);
 	type = rx.fc & IEEE80211_FCTL_FTYPE;
 
@@ -1682,11 +1662,11 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 			continue;
 
 		rx.flags |= IEEE80211_TXRXD_RXRA_MATCH;
-		prepres = prepare_for_handlers(sdata, bssid, &rx, hdr);
+		prepares = prepare_for_handlers(sdata, bssid, &rx, hdr);
 		/* prepare_for_handlers can change sta */
 		sta = rx.sta;
 
-		if (!prepres)
+		if (!prepares)
 			continue;
 
 		/*
@@ -1731,11 +1711,45 @@ void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		dev_kfree_skb(skb);
 
  end:
-	rcu_read_unlock();
-
 	if (sta)
 		sta_info_put(sta);
 }
+
+/*
+ * This is the receive path handler. It is called by a low level driver when an
+ * 802.11 MPDU is received from the hardware.
+ */
+void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
+		    struct ieee80211_rx_status *status)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	u32 pkt_load;
+
+	/*
+	 * key references and virtual interfaces are protected using RCU
+	 * and this requires that we are in a read-side RCU section during
+	 * receive processing
+	 */
+	rcu_read_lock();
+
+	/*
+	 * Frames with failed FCS/PLCP checksum are not returned,
+	 * all other frames are returned without radiotap header
+	 * if it was previously present.
+	 * Also, frames with less than 16 bytes are dropped.
+	 */
+	skb = ieee80211_rx_monitor(local, skb, status);
+	if (!skb) {
+		rcu_read_unlock();
+		return;
+	}
+
+	pkt_load = ieee80211_rx_load_stats(local, skb, status);
+
+	__ieee80211_rx_handle_packet(hw, skb, status, pkt_load);
+
+	rcu_read_unlock();
+}
 EXPORT_SYMBOL(__ieee80211_rx);
 
 /* This is a version of the rx handler that can be called from hard irq
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

