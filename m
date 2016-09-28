Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:58944 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751742AbcI1POs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Sep 2016 11:14:48 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Subject: [PATCHv3] wireless: check A-MSDU inner frame source address on AP interfaces
Date: Wed, 28 Sep 2016 17:14:32 +0200
Message-Id: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de> (sfid-20160928_171451_486609_1F4C801C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using WPA security, the station and thus the required key is
identified by its mac address when packets are received. So a
station usually cannot spoof its source mac address.

But when a station sends an A-MSDU frame, port control and crypto
is done using the outer mac address, while the packets delivered
and forwarded use the inner mac address.

IEEE 802.11-2012 mandates that the outer source mac address should
match the inner source address (section 8.3.2.2). For the
destination mac address, matching is not required (section 10.23.15).

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  3 ++-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   | 18 +++++++-------
 drivers/staging/rtl8723au/core/rtw_recv.c          |  2 +-
 include/net/cfg80211.h                             |  9 +++----
 net/mac80211/rx.c                                  | 11 +++++++--
 net/wireless/util.c                                | 28 +++++++++-------------
 6 files changed, 38 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 4fdc3da..416d060 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1436,7 +1436,8 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 
 			memcpy(skb_put(pkt, pktsize), pktdata, pktsize);
 
-			if (ieee80211_data_to_8023(pkt, vif->addr, vif->type))
+			if (ieee80211_data_to_8023(pkt, NULL, vif->addr,
+			    vif->type))
 				goto report;
 			wakeup.packet = pkt->data;
 			wakeup.packet_present_len = pkt->len;
diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index a74cc43..f4469d7 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -30,7 +30,8 @@
  * layer.
  */
 static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
-					  struct sk_buff *skb)
+					  struct sk_buff *skb,
+					  const u8 *ta)
 {
 	struct rxpd *local_rx_pd = (struct rxpd *)(skb->data);
 	int ret;
@@ -45,7 +46,7 @@ static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
 		skb_trim(skb, le16_to_cpu(local_rx_pd->rx_pkt_length));
 
 		ieee80211_amsdu_to_8023s(skb, &list, priv->curr_addr,
-					 priv->wdev.iftype, 0, false);
+					 priv->wdev.iftype, 0, ta);
 
 		while (!skb_queue_empty(&list)) {
 			struct rx_packet_hdr *rx_hdr;
@@ -76,9 +77,10 @@ static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
 /* This function will process the rx packet and forward it to kernel/upper
  * layer.
  */
-static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
+static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload,
+				    const u8 *ta)
 {
-	int ret = mwifiex_11n_dispatch_amsdu_pkt(priv, payload);
+	int ret = mwifiex_11n_dispatch_amsdu_pkt(priv, payload, ta);
 
 	if (!ret)
 		return 0;
@@ -119,7 +121,7 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 		}
 		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 		if (rx_tmp_ptr)
-			mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
+			mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr, tbl->ta);
 	}
 
 	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
@@ -161,7 +163,7 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 		rx_tmp_ptr = tbl->rx_reorder_ptr[i];
 		tbl->rx_reorder_ptr[i] = NULL;
 		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
-		mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
+		mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr, tbl->ta);
 	}
 
 	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
@@ -568,12 +570,12 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
 	if (!tbl) {
 		if (pkt_type != PKT_TYPE_BAR)
-			mwifiex_11n_dispatch_pkt(priv, payload);
+			mwifiex_11n_dispatch_pkt(priv, payload, ta);
 		return ret;
 	}
 
 	if ((pkt_type == PKT_TYPE_AMSDU) && !tbl->amsdu) {
-		mwifiex_11n_dispatch_pkt(priv, payload);
+		mwifiex_11n_dispatch_pkt(priv, payload, ta);
 		return ret;
 	}
 
diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 150dabc..38ba7dd 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -1687,7 +1687,7 @@ int amsdu_to_msdu(struct rtw_adapter *padapter, struct recv_frame *prframe)
 	skb_pull(skb, prframe->attrib.hdrlen);
 	__skb_queue_head_init(&skb_list);
 
-	ieee80211_amsdu_to_8023s(skb, &skb_list, NULL, 0, 0, false);
+	ieee80211_amsdu_to_8023s(skb, &skb_list, NULL, 0, 0, pattrib->ta);
 
 	while (!skb_queue_empty(&skb_list)) {
 		sub_skb = __skb_dequeue(&skb_list);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index beb7610..d768fcd 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3905,12 +3905,13 @@ unsigned int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr);
 /**
  * ieee80211_data_to_8023 - convert an 802.11 data frame to 802.3
  * @skb: the 802.11 data frame
+ * @ehdr: (out) buffer for source/destination address (optional)
  * @addr: the device MAC address
  * @iftype: the virtual interface type
  * Return: 0 on success. Non-zero on error.
  */
-int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
-			   enum nl80211_iftype iftype);
+int ieee80211_data_to_8023(struct sk_buff *skb, struct ethhdr *ehdr,
+			   const u8 *addr, enum nl80211_iftype iftype);
 
 /**
  * ieee80211_data_from_8023 - convert an 802.3 frame to 802.11
@@ -3938,12 +3939,12 @@ int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
  * @addr: The device MAC address.
  * @iftype: The device interface type.
  * @extra_headroom: The hardware extra headroom for SKBs in the @list.
- * @has_80211_header: Set it true if SKB is with IEEE 802.11 header.
+ * @ta: transmitter address (or NULL)
  */
 void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 			      const u8 *addr, enum nl80211_iftype iftype,
 			      const unsigned int extra_headroom,
-			      bool has_80211_header);
+			      const u8 *ta);
 
 /**
  * cfg80211_classify8021d - determine the 802.1p/1d tag for a data frame
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9dce3b1..fbf99b8 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2090,7 +2090,8 @@ __ieee80211_data_to_8023(struct ieee80211_rx_data *rx, bool *port_control)
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN && sdata->u.vlan.sta)
 		return -1;
 
-	ret = ieee80211_data_to_8023(rx->skb, sdata->vif.addr, sdata->vif.type);
+	ret = ieee80211_data_to_8023(rx->skb, NULL, sdata->vif.addr,
+				     sdata->vif.type);
 	if (ret < 0)
 		return ret;
 
@@ -2243,6 +2244,7 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	__le16 fc = hdr->frame_control;
 	struct sk_buff_head frame_list;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
+	struct ethhdr eth_80211;
 
 	if (unlikely(!ieee80211_is_data(fc)))
 		return RX_CONTINUE;
@@ -2268,9 +2270,14 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	skb->dev = dev;
 	__skb_queue_head_init(&frame_list);
 
+	if (ieee80211_data_to_8023(skb, &eth_80211, dev->dev_addr,
+				   rx->sdata->vif.type) < 0)
+		return RX_DROP_UNUSABLE;
+
 	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
 				 rx->sdata->vif.type,
-				 rx->local->hw.extra_tx_headroom, true);
+				 rx->local->hw.extra_tx_headroom,
+				 eth_80211.h_source);
 
 	while (!skb_queue_empty(&frame_list)) {
 		rx->skb = __skb_dequeue(&frame_list);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index b7d1592..5622740 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -414,8 +414,8 @@ unsigned int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
 }
 EXPORT_SYMBOL(ieee80211_get_mesh_hdrlen);
 
-static int __ieee80211_data_to_8023(struct sk_buff *skb, struct ethhdr *ehdr,
-				    const u8 *addr, enum nl80211_iftype iftype)
+int ieee80211_data_to_8023(struct sk_buff *skb, struct ethhdr *ehdr,
+			   const u8 *addr, enum nl80211_iftype iftype)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct {
@@ -519,12 +519,6 @@ static int __ieee80211_data_to_8023(struct sk_buff *skb, struct ethhdr *ehdr,
 
 	return 0;
 }
-
-int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
-			   enum nl80211_iftype iftype)
-{
-	return __ieee80211_data_to_8023(skb, NULL, addr, iftype);
-}
 EXPORT_SYMBOL(ieee80211_data_to_8023);
 
 int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
@@ -740,24 +734,18 @@ __ieee80211_amsdu_copy(struct sk_buff *skb, unsigned int hlen,
 void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 			      const u8 *addr, enum nl80211_iftype iftype,
 			      const unsigned int extra_headroom,
-			      bool has_80211_header)
+			      const u8 *ta)
 {
 	unsigned int hlen = ALIGN(extra_headroom, 4);
 	struct sk_buff *frame = NULL;
 	u16 ethertype;
 	u8 *payload;
-	int offset = 0, remaining, err;
+	int offset = 0, remaining;
 	struct ethhdr eth;
 	bool reuse_frag = skb->head_frag && !skb_has_frag_list(skb);
 	bool reuse_skb = false;
 	bool last = false;
 
-	if (has_80211_header) {
-		err = __ieee80211_data_to_8023(skb, &eth, addr, iftype);
-		if (err)
-			goto out;
-	}
-
 	while (!last) {
 		unsigned int subframe_len;
 		int len;
@@ -768,6 +756,13 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 		subframe_len = sizeof(struct ethhdr) + len;
 		padding = (4 - subframe_len) & 0x3;
 
+		if (unlikely(ta &&
+			     (iftype == NL80211_IFTYPE_AP ||
+			      iftype == NL80211_IFTYPE_AP_VLAN) &&
+			     !ether_addr_equal(ta, eth.h_source)
+		   ))
+			goto purge;
+
 		/* the last MSDU has no padding */
 		remaining = skb->len - offset;
 		if (subframe_len > remaining)
@@ -813,7 +808,6 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 
  purge:
 	__skb_queue_purge(list);
- out:
 	dev_kfree_skb(skb);
 }
 EXPORT_SYMBOL(ieee80211_amsdu_to_8023s);
-- 
2.1.4
