Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:50656 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752840AbcJOL20 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Oct 2016 07:28:26 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        Felix Fietkau <nbd@openwrt.org>
Subject: [PATCHv5 1/2] mac80211: avoid extra memcpy in A-MSDU head creation
Date: Sat, 15 Oct 2016 13:28:18 +0200
Message-Id: <1476530899-24241-1-git-send-email-michael-dev@fami-braun.de> (sfid-20161015_132832_244372_F49C01AB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 net/mac80211/tx.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5023966..56a883b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3046,11 +3046,11 @@ static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr;
-	struct ethhdr amsdu_hdr;
+	struct ethhdr *amsdu_hdr;
 	int hdr_len = fast_tx->hdr_len - sizeof(rfc1042_header);
 	int subframe_len = skb->len - hdr_len;
 	void *data;
-	u8 *qc;
+	u8 *qc, *h_80211_src, *h_80211_dst;
 
 	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
 		return false;
@@ -3058,19 +3058,22 @@ static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
 	if (info->control.flags & IEEE80211_TX_CTRL_AMSDU)
 		return true;
 
-	if (!ieee80211_amsdu_realloc_pad(local, skb, sizeof(amsdu_hdr),
+	if (!ieee80211_amsdu_realloc_pad(local, skb, sizeof(*amsdu_hdr),
 					 &subframe_len))
 		return false;
 
-	amsdu_hdr.h_proto = cpu_to_be16(subframe_len);
-	memcpy(amsdu_hdr.h_source, skb->data + fast_tx->sa_offs, ETH_ALEN);
-	memcpy(amsdu_hdr.h_dest, skb->data + fast_tx->da_offs, ETH_ALEN);
+	data = skb_push(skb, sizeof(*amsdu_hdr));
+	memmove(data, data + sizeof(*amsdu_hdr), hdr_len);
+	hdr = data;
+	amsdu_hdr = data + hdr_len;
+	/* h_80211_src/dst is addr* field within hdr */
+	h_80211_src = data + fast_tx->sa_offs;
+	h_80211_dst = data + fast_tx->da_offs;
 
-	data = skb_push(skb, sizeof(amsdu_hdr));
-	memmove(data, data + sizeof(amsdu_hdr), hdr_len);
-	memcpy(data + hdr_len, &amsdu_hdr, sizeof(amsdu_hdr));
+	amsdu_hdr->h_proto = cpu_to_be16(subframe_len);
+	ether_addr_copy(amsdu_hdr->h_source, h_80211_src);
+	ether_addr_copy(amsdu_hdr->h_dest, h_80211_dst);
 
-	hdr = data;
 	qc = ieee80211_get_qos_ctl(hdr);
 	*qc |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
 
-- 
2.1.4
