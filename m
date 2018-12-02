Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C285C64EB4
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 09:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E1692080A
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 09:43:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E1692080A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbeLBJnw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 04:43:52 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:35535 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725834AbeLBJnw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 04:43:52 -0500
X-IronPort-AV: E=Sophos;i="5.56,306,1539640800"; 
   d="scan'208";a="1585243"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 02 Dec 2018 10:43:44 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9094"; a="6502875"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg03-ams.qualcomm.com with ESMTP; 02 Dec 2018 10:43:44 +0100
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 07/12] wil6210: accessing 802.3 addresses via utility functions
Date:   Sun,  2 Dec 2018 11:43:32 +0200
Message-Id: <1543743817-10298-8-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1543743817-10298-1-git-send-email-merez@codeaurora.org>
References: <1543743817-10298-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ahmad Masri <amasri@codeaurora.org>

Rearrange the code by having functions to access 802.3 header
members, source and destination addresses.

Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/netdev.c |  6 +++---
 drivers/net/wireless/ath/wil6210/txrx.c   | 33 ++++++++++++++-----------------
 drivers/net/wireless/ath/wil6210/txrx.h   | 18 +++++++++++++++--
 3 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 74e90a3..41620c2 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -123,18 +123,18 @@ static u16 wil_select_queue(struct net_device *ndev,
 {
 	struct wil6210_vif *vif = ndev_to_vif(ndev);
 	struct wil6210_priv *wil = vif_to_wil(vif);
-	struct ethhdr *eth = (void *)skb->data;
+	const u8 *da = wil_skb_get_da(skb);
 	u16 qid = 0;
 	bool mcast;
 
 	if (!WIL_Q_PER_STA_USED(vif))
 		goto out;
 
-	mcast = is_multicast_ether_addr(eth->h_dest);
+	mcast = is_multicast_ether_addr(da);
 	if (mcast) {
 		qid = wil->config.max_assoc_sta;
 	} else {
-		qid = wil_find_cid(wil, vif->mid, eth->h_dest);
+		qid = wil_find_cid(wil, vif->mid, da);
 
 		/* the MCAST queues also used as default queues */
 		if (qid < 0)
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 471f85e..4c833fc 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -373,7 +373,6 @@ static int wil_rx_get_cid_by_skb(struct wil6210_priv *wil, struct sk_buff *skb)
 	 */
 	int cid = wil_rxdesc_cid(d);
 	unsigned int snaplen = wil_rx_snaplen(wil);
-	struct ethhdr *eth;
 	struct ieee80211_hdr_3addr *hdr;
 	int i;
 	unsigned char *ta;
@@ -391,8 +390,7 @@ static int wil_rx_get_cid_by_skb(struct wil6210_priv *wil, struct sk_buff *skb)
 					    skb->len);
 			return -ENOENT;
 		}
-		eth = (void *)skb->data;
-		ta = eth->h_source;
+		ta = wil_skb_get_sa(skb);
 	} else {
 		if (unlikely(skb->len < sizeof(struct ieee80211_hdr_3addr))) {
 			wil_err_ratelimited(wil, "Short frame, len = %d\n",
@@ -730,11 +728,11 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 	unsigned int len = skb->len;
 	int cid;
 	int security;
-	struct ethhdr *eth = (void *)skb->data;
+	u8 *sa, *da = wil_skb_get_da(skb);
 	/* here looking for DA, not A1, thus Rxdesc's 'mcast' indication
 	 * is not suitable, need to look at data
 	 */
-	int mcast = is_multicast_ether_addr(eth->h_dest);
+	int mcast = is_multicast_ether_addr(da);
 	struct wil_net_stats *stats;
 	struct sk_buff *xmit_skb = NULL;
 	static const char * const gro_res_str[] = {
@@ -765,7 +763,8 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 	}
 
 	if (wdev->iftype == NL80211_IFTYPE_STATION) {
-		if (mcast && ether_addr_equal(eth->h_source, ndev->dev_addr)) {
+		sa = wil_skb_get_sa(skb);
+		if (mcast && ether_addr_equal(sa, ndev->dev_addr)) {
 			/* mcast packet looped back to us */
 			rc = GRO_DROP;
 			dev_kfree_skb(skb);
@@ -778,8 +777,7 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 			 */
 			xmit_skb = skb_copy(skb, GFP_ATOMIC);
 		} else {
-			int xmit_cid = wil_find_cid(wil, vif->mid,
-						    eth->h_dest);
+			int xmit_cid = wil_find_cid(wil, vif->mid, da);
 
 			if (xmit_cid >= 0) {
 				/* The destination station is associated to
@@ -1234,7 +1232,7 @@ static struct wil_ring *wil_find_tx_ucast(struct wil6210_priv *wil,
 					  struct sk_buff *skb)
 {
 	int i, cid;
-	struct ethhdr *eth = (void *)skb->data;
+	const u8 *da = wil_skb_get_da(skb);
 	int min_ring_id = wil_get_min_tx_ring_id(wil);
 
 	if (WIL_Q_PER_STA_USED(vif))
@@ -1245,7 +1243,7 @@ static struct wil_ring *wil_find_tx_ucast(struct wil6210_priv *wil,
 			skb_get_queue_mapping(skb) / WIL6210_TX_AC_QUEUES :
 			skb_get_queue_mapping(skb);
 	else
-		cid = wil_find_cid(wil, vif->mid, eth->h_dest);
+		cid = wil_find_cid(wil, vif->mid, da);
 
 	if (cid < 0 || cid >= wil->config.max_assoc_sta)
 		return NULL;
@@ -1260,7 +1258,7 @@ static struct wil_ring *wil_find_tx_ucast(struct wil6210_priv *wil,
 			struct wil_ring_tx_data *txdata = &wil->ring_tx_data[i];
 
 			wil_dbg_txrx(wil, "find_tx_ucast: (%pM) -> [%d]\n",
-				     eth->h_dest, i);
+				     da, i);
 			if (v->va && txdata->enabled) {
 				return v;
 			} else {
@@ -1351,10 +1349,10 @@ static struct wil_ring *wil_find_tx_bcast_1(struct wil6210_priv *wil,
 static void wil_set_da_for_vring(struct wil6210_priv *wil,
 				 struct sk_buff *skb, int vring_index)
 {
-	struct ethhdr *eth = (void *)skb->data;
+	u8 *da = wil_skb_get_da(skb);
 	int cid = wil->ring2cid_tid[vring_index][0];
 
-	ether_addr_copy(eth->h_dest, wil->sta[cid].addr);
+	ether_addr_copy(da, wil->sta[cid].addr);
 }
 
 static struct wil_ring *wil_find_tx_bcast_2(struct wil6210_priv *wil,
@@ -1365,8 +1363,7 @@ static struct wil_ring *wil_find_tx_bcast_2(struct wil6210_priv *wil,
 	struct sk_buff *skb2;
 	int i;
 	u8 cid;
-	struct ethhdr *eth = (void *)skb->data;
-	char *src = eth->h_source;
+	const u8 *src = wil_skb_get_sa(skb);
 	struct wil_ring_tx_data *txdata, *txdata2;
 	int min_ring_id = wil_get_min_tx_ring_id(wil);
 
@@ -2247,8 +2244,8 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct wil6210_vif *vif = ndev_to_vif(ndev);
 	struct wil6210_priv *wil = vif_to_wil(vif);
-	struct ethhdr *eth = (void *)skb->data;
-	bool bcast = is_multicast_ether_addr(eth->h_dest);
+	const u8 *da = wil_skb_get_da(skb);
+	bool bcast = is_multicast_ether_addr(da);
 	struct wil_ring *ring;
 	static bool pr_once_fw;
 	int rc;
@@ -2295,7 +2292,7 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		ring = wil_find_tx_ucast(wil, vif, skb);
 	}
 	if (unlikely(!ring)) {
-		wil_dbg_txrx(wil, "No Tx RING found for %pM\n", eth->h_dest);
+		wil_dbg_txrx(wil, "No Tx RING found for %pM\n", da);
 		goto drop;
 	}
 	/* set up vring entry */
diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index b8869db..4d9014a 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -567,11 +567,25 @@ static inline int wil_ring_is_full(struct wil_ring *ring)
 	return wil_ring_next_tail(ring) == ring->swhead;
 }
 
-static inline bool wil_need_txstat(struct sk_buff *skb)
+static inline u8 *wil_skb_get_da(struct sk_buff *skb)
+{
+	struct ethhdr *eth = (void *)skb->data;
+
+	return eth->h_dest;
+}
+
+static inline u8 *wil_skb_get_sa(struct sk_buff *skb)
 {
 	struct ethhdr *eth = (void *)skb->data;
 
-	return is_unicast_ether_addr(eth->h_dest) && skb->sk &&
+	return eth->h_source;
+}
+
+static inline bool wil_need_txstat(struct sk_buff *skb)
+{
+	const u8 *da = wil_skb_get_da(skb);
+
+	return is_unicast_ether_addr(da) && skb->sk &&
 	       (skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS);
 }
 
-- 
1.9.1

