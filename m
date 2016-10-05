Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48748 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751146AbcJENdk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 09:33:40 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michael Braun <michael-dev@fami-braun.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: let ieee80211_amsdu_to_8023s() take only 802.3 header
Date: Wed,  5 Oct 2016 15:33:34 +0200
Message-Id: <1475674414-23086-1-git-send-email-johannes@sipsolutions.net> (sfid-20161005_153344_222282_258F288B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's only a single case where has_80211_header is passed as true,
which is in mac80211. Given that it's only a very simple check that
needs to be done before calling it (calling __ieee80211_data_to_8023()
and checking its return value), simple move that into the caller in
order to simplify this function. The only additional cost this adds
is the extra skb_push(), so reduce that by using __skb_push() as we
know there's enough space, having pulled just before.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |  2 +-
 drivers/staging/rtl8723au/core/rtw_recv.c          |  2 +-
 include/net/cfg80211.h                             |  7 +++---
 net/mac80211/rx.c                                  |  6 ++++-
 net/wireless/util.c                                | 26 +++++-----------------
 5 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index 94480123efa3..e9f462e3730b 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -45,7 +45,7 @@ static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
 		skb_trim(skb, le16_to_cpu(local_rx_pd->rx_pkt_length));
 
 		ieee80211_amsdu_to_8023s(skb, &list, priv->curr_addr,
-					 priv->wdev.iftype, 0, false);
+					 priv->wdev.iftype, 0);
 
 		while (!skb_queue_empty(&list)) {
 			struct rx_packet_hdr *rx_hdr;
diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index 150dabc2a58d..e1873c906c42 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -1687,7 +1687,7 @@ int amsdu_to_msdu(struct rtw_adapter *padapter, struct recv_frame *prframe)
 	skb_pull(skb, prframe->attrib.hdrlen);
 	__skb_queue_head_init(&skb_list);
 
-	ieee80211_amsdu_to_8023s(skb, &skb_list, NULL, 0, 0, false);
+	ieee80211_amsdu_to_8023s(skb, &skb_list, NULL, 0, 0);
 
 	while (!skb_queue_empty(&skb_list)) {
 		sub_skb = __skb_dequeue(&skb_list);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fe78f02a242e..8d1a67fc2983 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4067,7 +4067,8 @@ int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
  *
  * Decode an IEEE 802.11n A-MSDU frame and convert it to a list of
  * 802.3 frames. The @list will be empty if the decode fails. The
- * @skb is consumed after the function returns.
+ * @skb must already have been converted to 802.3 format. It is
+ * consumed after the function returns.
  *
  * @skb: The input IEEE 802.11n A-MSDU frame.
  * @list: The output list of 802.3 frames. It must be allocated and
@@ -4075,12 +4076,10 @@ int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
  * @addr: The device MAC address.
  * @iftype: The device interface type.
  * @extra_headroom: The hardware extra headroom for SKBs in the @list.
- * @has_80211_header: Set it true if SKB is with IEEE 802.11 header.
  */
 void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 			      const u8 *addr, enum nl80211_iftype iftype,
-			      const unsigned int extra_headroom,
-			      bool has_80211_header);
+			      const unsigned int extra_headroom);
 
 /**
  * cfg80211_classify8021d - determine the 802.1p/1d tag for a data frame
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6175db385ba7..3a912e6c585f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2323,9 +2323,13 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	skb->dev = dev;
 	__skb_queue_head_init(&frame_list);
 
+	if (ieee80211_data_to_8023(skb, rx->sdata->vif.addr,
+				   rx->sdata->vif.type))
+		return RX_DROP_UNUSABLE;
+
 	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
 				 rx->sdata->vif.type,
-				 rx->local->hw.extra_tx_headroom, true);
+				 rx->local->hw.extra_tx_headroom);
 
 	while (!skb_queue_empty(&frame_list)) {
 		rx->skb = __skb_dequeue(&frame_list);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 8edce22d1b93..ed22d0336f1b 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -420,8 +420,8 @@ unsigned int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
 }
 EXPORT_SYMBOL(ieee80211_get_mesh_hdrlen);
 
-static int __ieee80211_data_to_8023(struct sk_buff *skb, struct ethhdr *ehdr,
-				    const u8 *addr, enum nl80211_iftype iftype)
+int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
+			   enum nl80211_iftype iftype)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct {
@@ -519,18 +519,10 @@ static int __ieee80211_data_to_8023(struct sk_buff *skb, struct ethhdr *ehdr,
 
 	pskb_pull(skb, hdrlen);
 
-	if (!ehdr)
-		ehdr = (struct ethhdr *) skb_push(skb, sizeof(struct ethhdr));
-	memcpy(ehdr, &tmp, sizeof(tmp));
+	memcpy(__skb_push(skb, sizeof(tmp)), &tmp, sizeof(tmp));
 
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
@@ -745,25 +737,18 @@ __ieee80211_amsdu_copy(struct sk_buff *skb, unsigned int hlen,
 
 void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 			      const u8 *addr, enum nl80211_iftype iftype,
-			      const unsigned int extra_headroom,
-			      bool has_80211_header)
+			      const unsigned int extra_headroom)
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
@@ -819,7 +804,6 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 
  purge:
 	__skb_queue_purge(list);
- out:
 	dev_kfree_skb(skb);
 }
 EXPORT_SYMBOL(ieee80211_amsdu_to_8023s);
-- 
2.8.1
