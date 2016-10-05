Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49175 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754465AbcJEOoz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 10:44:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michael Braun <michael-dev@fami-braun.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 2/3] cfg80211: add ability to check DA/SA in A-MSDU decapsulation
Date: Wed,  5 Oct 2016 16:44:49 +0200
Message-Id: <1475678690-29226-2-git-send-email-johannes@sipsolutions.net> (sfid-20161005_164522_583273_92D68893)
In-Reply-To: <1475678690-29226-1-git-send-email-johannes@sipsolutions.net>
References: <1475678690-29226-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We should not accept arbitrary DA/SA inside A-MSDUs, it could be used
to circumvent protections, like allowing a station to send frames and
make them seem to come from somewhere else.

Add the necessary infrastructure in cfg80211 to allow such checks, in
further patches we'll start using them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c |  2 +-
 drivers/staging/rtl8723au/core/rtw_recv.c            |  2 +-
 include/net/cfg80211.h                               |  5 ++++-
 net/mac80211/rx.c                                    |  3 ++-
 net/wireless/util.c                                  | 14 ++++++++++++--
 5 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index e9f462e3730b..274dd5a1574a 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -45,7 +45,7 @@ static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
 		skb_trim(skb, le16_to_cpu(local_rx_pd->rx_pkt_length));
 
 		ieee80211_amsdu_to_8023s(skb, &list, priv->curr_addr,
-					 priv->wdev.iftype, 0);
+					 priv->wdev.iftype, 0, NULL, NULL);
 
 		while (!skb_queue_empty(&list)) {
 			struct rx_packet_hdr *rx_hdr;
diff --git a/drivers/staging/rtl8723au/core/rtw_recv.c b/drivers/staging/rtl8723au/core/rtw_recv.c
index e1873c906c42..d2a9ae2fe51a 100644
--- a/drivers/staging/rtl8723au/core/rtw_recv.c
+++ b/drivers/staging/rtl8723au/core/rtw_recv.c
@@ -1687,7 +1687,7 @@ int amsdu_to_msdu(struct rtw_adapter *padapter, struct recv_frame *prframe)
 	skb_pull(skb, prframe->attrib.hdrlen);
 	__skb_queue_head_init(&skb_list);
 
-	ieee80211_amsdu_to_8023s(skb, &skb_list, NULL, 0, 0);
+	ieee80211_amsdu_to_8023s(skb, &skb_list, NULL, 0, 0, NULL, NULL);
 
 	while (!skb_queue_empty(&skb_list)) {
 		sub_skb = __skb_dequeue(&skb_list);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f372eadd1963..7df600c463eb 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4090,10 +4090,13 @@ int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
  * @addr: The device MAC address.
  * @iftype: The device interface type.
  * @extra_headroom: The hardware extra headroom for SKBs in the @list.
+ * @check_da: DA to check in the inner ethernet header, or NULL
+ * @check_sa: SA to check in the inner ethernet header, or NULL
  */
 void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 			      const u8 *addr, enum nl80211_iftype iftype,
-			      const unsigned int extra_headroom);
+			      const unsigned int extra_headroom,
+			      const u8 *check_da, const u8 *check_sa);
 
 /**
  * cfg80211_classify8021d - determine the 802.1p/1d tag for a data frame
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index de2d75fa5c51..cf53fe1a0aa2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2337,7 +2337,8 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 
 	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
 				 rx->sdata->vif.type,
-				 rx->local->hw.extra_tx_headroom);
+				 rx->local->hw.extra_tx_headroom,
+				 NULL, NULL);
 
 	while (!skb_queue_empty(&frame_list)) {
 		rx->skb = __skb_dequeue(&frame_list);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index e36ede840b88..5ea12afc7706 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -739,7 +739,8 @@ __ieee80211_amsdu_copy(struct sk_buff *skb, unsigned int hlen,
 
 void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 			      const u8 *addr, enum nl80211_iftype iftype,
-			      const unsigned int extra_headroom)
+			      const unsigned int extra_headroom,
+			      const u8 *check_da, const u8 *check_sa)
 {
 	unsigned int hlen = ALIGN(extra_headroom, 4);
 	struct sk_buff *frame = NULL;
@@ -767,8 +768,17 @@ void ieee80211_amsdu_to_8023s(struct sk_buff *skb, struct sk_buff_head *list,
 			goto purge;
 
 		offset += sizeof(struct ethhdr);
-		/* reuse skb for the last subframe */
 		last = remaining <= subframe_len + padding;
+
+		/* FIXME: should we really accept multicast DA? */
+		if ((check_da && !is_multicast_ether_addr(eth.h_dest) &&
+		     !ether_addr_equal(check_da, eth.h_dest)) ||
+		    (check_sa && !ether_addr_equal(check_sa, eth.h_source))) {
+			offset += len + padding;
+			continue;
+		}
+
+		/* reuse skb for the last subframe */
 		if (!skb_is_nonlinear(skb) && !reuse_frag && last) {
 			skb_pull(skb, offset);
 			frame = skb;
-- 
2.8.1
