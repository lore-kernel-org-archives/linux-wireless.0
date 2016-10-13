Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:39606 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755152AbcJMFnx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 01:43:53 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        Felix Fietkau <nbd@openwrt.org>
Subject: [PATCHv4] mac80211: fix A-MSDU outer SA/DA
Date: Thu, 13 Oct 2016 07:41:55 +0200
Message-Id: <1476337315-26845-1-git-send-email-michael-dev@fami-braun.de> (sfid-20161013_074406_501207_29437AE6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to IEEE 802.11-2012 section 8.3.2 table 8-19, the outer SA/DA
of A-MSDU frames need to be changed depending on FromDS/ToDS values.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>

--
v4:
 - h_80211_src/dst has been memmove'd and thus needs to be fixed
v3:
 - write to outer 802.11 header instead of inner amsdu subframe header
v2:
 - avoid the extra write to amsdu_hdr
 - avoid copy of asmdu_hdr into skb, use ptr instead
---
 net/mac80211/tx.c | 46 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5023966..5f80b94 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3046,11 +3046,12 @@ static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
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
+	const u8 *bssid;
 
 	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
 		return false;
@@ -3058,19 +3059,44 @@ static bool ieee80211_amsdu_prepare_head(struct ieee80211_sub_if_data *sdata,
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
+
+	amsdu_hdr->h_proto = cpu_to_be16(subframe_len);
+	memcpy(amsdu_hdr->h_source, h_80211_src, ETH_ALEN);
+	memcpy(amsdu_hdr->h_dest, h_80211_dst, ETH_ALEN);
+
+	/* according to IEEE 802.11-2012 8.3.2 table 8-19, the outer SA/DA
+	 * fields needs to be changed to BSSID for A-MSDU frames depending
+	 * on FromDS/ToDS values.
+	 */
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+		bssid = sdata->u.mgd.bssid;
+		break;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+		bssid = sdata->vif.addr;
+		break;
+	default:
+		bssid = NULL;
+	}
 
-	data = skb_push(skb, sizeof(amsdu_hdr));
-	memmove(data, data + sizeof(amsdu_hdr), hdr_len);
-	memcpy(data + hdr_len, &amsdu_hdr, sizeof(amsdu_hdr));
+	if (bssid && ieee80211_has_fromds(hdr->frame_control))
+		memcpy(h_80211_src, bssid, ETH_ALEN);
+
+	if (bssid && ieee80211_has_tods(hdr->frame_control))
+		memcpy(h_80211_dst, bssid, ETH_ALEN);
 
-	hdr = data;
 	qc = ieee80211_get_qos_ctl(hdr);
 	*qc |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
 
-- 
2.1.4
