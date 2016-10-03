Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:55095 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753241AbcJCLO3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 07:14:29 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Subject: [PATCHv3 2/3] mac80211: check A-MSDU inner frame source address on AP interfaces
Date: Mon,  3 Oct 2016 13:14:16 +0200
Message-Id: <1475493257-21841-2-git-send-email-michael-dev@fami-braun.de> (sfid-20161003_131433_693019_40C59037)
In-Reply-To: <1475493257-21841-1-git-send-email-michael-dev@fami-braun.de>
References: <1475493257-21841-1-git-send-email-michael-dev@fami-braun.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using WPA security, the station and thus the required key is
identified by its mac address when packets are received. So a
station usually cannot spoof its source mac address.

But when a station sends an A-MSDU frame, port control and crypto
is done using the outer mac address, while the packets delivered
and forwarded use the inner mac address.
This might affect ARP/IP filtering on the AccessPoint.

IEEE 802.11-2012 mandates that the outer source mac address should
match the inner source address (section 8.3.2.2). For the destination
mac address, matching is not required, as a wifi client may send all
its traffic to the AP in order to have it forwarded.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>

To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Cc: projekt-wlan@fem.tu-ilmenau.de
Cc: kvalo@codeaurora.org
Cc: akarwar@marvell.com
Cc: nishants@marvell.com
Cc: Larry.Finger@lwfinger.net
Cc: Jes.Sorensen@redhat.com
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  3 ++-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |  2 +-
 drivers/staging/rtl8723au/core/rtw_recv.c          |  2 +-
 include/net/cfg80211.h                             |  9 ++++----
 net/mac80211/rx.c                                  | 11 +++++++--
 net/wireless/util.c                                | 26 ++++++++--------------
 6 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 4fdc3da..05dcaef 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1436,7 +1436,8 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 
 			memcpy(skb_put(pkt, pktsize), pktdata, pktsize);
 
-			if (ieee80211_data_to_8023(pkt, vif->addr, vif->type))
+			if (ieee80211_data_to_8023(pkt, NULL, vif->addr,
+						   vif->type))
 				goto report;
 			wakeup.packet = pkt->data;
 			wakeup.packet_present_len = pkt->len;
diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index a74cc43..49d0efe 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -45,7 +45,7 @@ static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
 		skb_trim(skb, le16_to_cpu(local_rx_pd->rx_pkt_length));
 
 		ieee80211_amsdu_to_8023s(skb, &list, priv->curr_addr,
-					 priv->wdev.iftype, 0, false);
+					 priv->wdev.iftype, 0, NULL);
 
 		while (!skb_queue_empty(&list)) {
 			struct rx_packet_hdr *rx_hdr;
diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 150dabc..caa0e7c 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -1687,7 +1687,7 @@ int amsdu_to_msdu(struct rtw_adapter *padapter, struct recv_frame *prframe)
 	skb_pull(skb, prframe->attrib.hdrlen);
 	__skb_queue_head_init(&skb_list);
 
-	ieee80211_amsdu_to_8023s(skb, &skb_list, NULL, 0, 0, false);
+	ieee80211_amsdu_to_8023s(skb, &skb_list, NULL, 0, 0, NULL);
 
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
index b7d1592..efa4f5f 100644
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
@@ -768,6 +756,11 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 		subframe_len = sizeof(struct ethhdr) + len;
 		padding = (4 - subframe_len) & 0x3;
 
+		if (unlikely(ta && !ether_addr_equal(ta, eth.h_source) &&
+			     (iftype == NL80211_IFTYPE_AP ||
+			      iftype == NL80211_IFTYPE_AP_VLAN)))
+			goto purge;
+
 		/* the last MSDU has no padding */
 		remaining = skb->len - offset;
 		if (subframe_len > remaining)
@@ -813,7 +806,6 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 
  purge:
 	__skb_queue_purge(list);
- out:
 	dev_kfree_skb(skb);
 }
 EXPORT_SYMBOL(ieee80211_amsdu_to_8023s);
-- 
2.1.4
