Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:52041 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752752AbcJEKCi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 06:02:38 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com
Subject: [PATCHv4] mac80211: check A-MSDU inner frame source address on AP interfaces
Date: Wed,  5 Oct 2016 12:02:31 +0200
Message-Id: <1475661751-26262-1-git-send-email-michael-dev@fami-braun.de> (sfid-20161005_120258_540753_8527309A)
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

v4: check for IBSS, STATION, TDLS data frame
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  3 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |  3 +-
 drivers/staging/rtl8723au/core/rtw_recv.c          |  2 +-
 include/net/cfg80211.h                             | 16 ++++---
 net/mac80211/rx.c                                  | 25 ++++++++---
 net/wireless/util.c                                | 52 +++++++++++++++-------
 6 files changed, 70 insertions(+), 31 deletions(-)

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
index a74cc43..298e447 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -45,7 +45,8 @@ static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
 		skb_trim(skb, le16_to_cpu(local_rx_pd->rx_pkt_length));
 
 		ieee80211_amsdu_to_8023s(skb, &list, priv->curr_addr,
-					 priv->wdev.iftype, 0, false);
+					 priv->wdev.iftype, 0, NULL, NULL, 0,
+					 0);
 
 		while (!skb_queue_empty(&list)) {
 			struct rx_packet_hdr *rx_hdr;
diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 150dabc..8f39a8b 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -1687,7 +1687,7 @@ int amsdu_to_msdu(struct rtw_adapter *padapter, struct recv_frame *prframe)
 	skb_pull(skb, prframe->attrib.hdrlen);
 	__skb_queue_head_init(&skb_list);
 
-	ieee80211_amsdu_to_8023s(skb, &skb_list, NULL, 0, 0, false);
+	ieee80211_amsdu_to_8023s(skb, &skb_list, NULL, 0, 0, NULL, NULL, 0, 0);
 
 	while (!skb_queue_empty(&skb_list)) {
 		sub_skb = __skb_dequeue(&skb_list);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index beb7610..b550314 100644
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
@@ -3938,12 +3939,17 @@ int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
  * @addr: The device MAC address.
  * @iftype: The device interface type.
  * @extra_headroom: The hardware extra headroom for SKBs in the @list.
- * @has_80211_header: Set it true if SKB is with IEEE 802.11 header.
+ * @ta: transmitter address (or NULL)
+ * @ra: receiver address (or NULL)
+ * @is_4addr: indicates that interface is in 4addr mode
+ * @is_tlds_data: indicates that frame as been received from TLDS peer
  */
 void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
-			      const u8 *addr, enum nl80211_iftype iftype,
+			      const u8 *addr,
+			      enum nl80211_iftype iftype,
 			      const unsigned int extra_headroom,
-			      bool has_80211_header);
+			      const u8 *ta, const u8 *ra, bool is_4addr,
+			      bool is_tdls_data);
 
 /**
  * cfg80211_classify8021d - determine the 802.1p/1d tag for a data frame
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9dce3b1..3d8d889 100644
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
 
@@ -2243,6 +2244,9 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	__le16 fc = hdr->frame_control;
 	struct sk_buff_head frame_list;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
+	struct ethhdr eth_80211;
+	bool is_4addr;
+	bool is_tdls_data;
 
 	if (unlikely(!ieee80211_is_data(fc)))
 		return RX_CONTINUE;
@@ -2258,19 +2262,26 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	    !rx->sdata->u.vlan.sta)
 		return RX_DROP_UNUSABLE;
 
-	if (is_multicast_ether_addr(hdr->addr1) &&
-	    ((rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
-	      rx->sdata->u.vlan.sta) ||
-	     (rx->sdata->vif.type == NL80211_IFTYPE_STATION &&
-	      rx->sdata->u.mgd.use_4addr)))
+	is_4addr = ((rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
+		     rx->sdata->u.vlan.sta) ||
+		    (rx->sdata->vif.type == NL80211_IFTYPE_STATION &&
+		     rx->sdata->u.mgd.use_4addr));
+	if (is_multicast_ether_addr(hdr->addr1) && is_4addr)
 		return RX_DROP_UNUSABLE;
 
 	skb->dev = dev;
 	__skb_queue_head_init(&frame_list);
 
+	if (ieee80211_data_to_8023(skb, &eth_80211, dev->dev_addr,
+				   rx->sdata->vif.type) < 0)
+		return RX_DROP_UNUSABLE;
+
+	is_tdls_data = !ieee80211_has_tods(fc) && !ieee80211_has_fromds(fc);
 	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
 				 rx->sdata->vif.type,
-				 rx->local->hw.extra_tx_headroom, true);
+				 rx->local->hw.extra_tx_headroom,
+				 eth_80211.h_source,
+				 eth_80211.h_dest, is_4addr, is_tdls_data);
 
 	while (!skb_queue_empty(&frame_list)) {
 		rx->skb = __skb_dequeue(&frame_list);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index b7d1592..84da5c2 100644
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
@@ -738,24 +732,41 @@ __ieee80211_amsdu_copy(struct sk_buff *skb, unsigned int hlen,
 }
 
 void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
-			      const u8 *addr, enum nl80211_iftype iftype,
+			      const u8 *addr,
+			      enum nl80211_iftype iftype,
 			      const unsigned int extra_headroom,
-			      bool has_80211_header)
+			      const u8 *ta, const u8 *ra, bool is_4addr,
+			      bool is_tdls_data)
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
+	/* limit inner src/dst checks depending on iftype */
+	switch (iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+		if (is_4addr)
+			ta = NULL;
+		ra = NULL;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		break;
+	case NL80211_IFTYPE_STATION:
+		if (is_4addr || !is_tdls_data)
+			ta = NULL;
+		if (is_4addr)
+			ra = NULL;
+		break;
+	default:
+		ta = NULL;
+		ra = NULL;
 	}
 
 	while (!last) {
@@ -768,6 +779,16 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 		subframe_len = sizeof(struct ethhdr) + len;
 		padding = (4 - subframe_len) & 0x3;
 
+		if (unlikely(ta && !ether_addr_equal(ta, eth.h_source)))
+			goto purge;
+		/* for unicast frames, we accept multicast inner MSDUs
+		 * to enable multicast to unicast conversion
+		 */
+		if (unlikely(ra && !ether_addr_equal(ra, eth.h_dest) &&
+			     (is_multicast_ether_addr(ra) ||
+			      !is_multicast_ether_addr(eth.h_dest))))
+			goto purge;
+
 		/* the last MSDU has no padding */
 		remaining = skb->len - offset;
 		if (subframe_len > remaining)
@@ -813,7 +834,6 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 
  purge:
 	__skb_queue_purge(list);
- out:
 	dev_kfree_skb(skb);
 }
 EXPORT_SYMBOL(ieee80211_amsdu_to_8023s);
-- 
2.1.4
