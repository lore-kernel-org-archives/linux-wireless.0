Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29123 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbYFSVKQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 17:10:16 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] mac80211: fix tx fragmenation
Date: Fri, 20 Jun 2008 00:10:10 +0300
Message-Id: <1213909810-23170-1-git-send-email-tomas.winkler@intel.com> (sfid-20080619_231020_552013_C4B59A55)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

This patch fixes TX fragmenation caused by
tx handlers reordering and 'tx info to cb' patchs

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |   67 ++++++++++++++++++++++++++++------------------------
 1 files changed, 36 insertions(+), 31 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 195cb6d..c2dcc45 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -87,8 +87,8 @@ static inline void ieee80211_dump_frame(const char *ifname, const char *title,
 }
 #endif /* CONFIG_MAC80211_LOWTX_FRAME_DUMP */
 
-static u16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
-			      int next_frag_len)
+static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
+				 int next_frag_len)
 {
 	int rate, mrate, erp, dur, i;
 	struct ieee80211_rate *txrate;
@@ -140,7 +140,7 @@ static u16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
 
 	/* data/mgmt */
 	if (0 /* FIX: data/mgmt during CFP */)
-		return 32768;
+		return cpu_to_le16(32768);
 
 	if (group_addr) /* Group address as the destination - no ACK */
 		return 0;
@@ -210,7 +210,7 @@ static u16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
 				tx->sdata->bss_conf.use_short_preamble);
 	}
 
-	return dur;
+	return cpu_to_le16(dur);
 }
 
 static int inline is_ieee80211_device(struct net_device *dev,
@@ -544,7 +544,6 @@ ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
 	u16 fc = le16_to_cpu(hdr->frame_control);
-	u16 dur;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_supported_band *sband;
 
@@ -602,14 +601,6 @@ ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
 		info->flags |= IEEE80211_TX_CTL_SHORT_PREAMBLE;
 	}
 
-	/* Setup duration field for the first fragment of the frame. Duration
-	 * for remaining fragments will be updated when they are being sent
-	 * to low-level driver in ieee80211_tx(). */
-	dur = ieee80211_duration(tx, is_multicast_ether_addr(hdr->addr1),
-				 (tx->flags & IEEE80211_TX_FRAGMENTED) ?
-				 tx->extra_frag[0]->len : 0);
-	hdr->duration_id = cpu_to_le16(dur);
-
 	if ((info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) ||
 	    (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)) {
 		struct ieee80211_rate *rate;
@@ -711,6 +702,7 @@ ieee80211_tx_h_fragment(struct ieee80211_tx_data *tx)
 		fhdr->seq_ctrl = cpu_to_le16(seq | ((i + 1) & IEEE80211_SCTL_FRAG));
 		copylen = left > per_fragm ? per_fragm : left;
 		memcpy(skb_put(frag, copylen), pos, copylen);
+		memcpy(frag->cb, first->cb, sizef(frag->cb));
 
 		pos += copylen;
 		left -= copylen;
@@ -755,6 +747,36 @@ ieee80211_tx_h_encrypt(struct ieee80211_tx_data *tx)
 }
 
 static ieee80211_tx_result
+ieee80211_tx_h_calculate_duration(struct ieee80211_tx_data *tx)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+	int next_len, i;
+	int group_addr = is_multicast_ether_addr(hdr->addr1);
+
+	if (!(tx->flags & IEEE80211_TX_FRAGMENTED)) {
+		hdr->duration_id = ieee80211_duration(tx, group_addr, 0);
+		return TX_CONTINUE;
+	}
+
+	hdr->duration_id = ieee80211_duration(tx, group_addr,
+					      tx->extra_frag[0]->len);
+
+	for (i = 0; i < tx->num_extra_frag; i++) {
+		if (i + 1 < tx->num_extra_frag) {
+			next_len = tx->extra_frag[i + 1]->len;
+		} else {
+			next_len = 0;
+			tx->rate_idx = tx->last_frag_rate_idx;
+		}
+
+		hdr = (struct ieee80211_hdr *)tx->extra_frag[i]->data;
+		hdr->duration_id = ieee80211_duration(tx, 0, next_len);
+	}
+
+	return TX_CONTINUE;
+}
+
+static ieee80211_tx_result
 ieee80211_tx_h_stats(struct ieee80211_tx_data *tx)
 {
 	int i;
@@ -788,6 +810,7 @@ static ieee80211_tx_handler ieee80211_tx_handlers[] =
 	ieee80211_tx_h_fragment,
 	/* handlers after fragment must be aware of tx info fragmentation! */
 	ieee80211_tx_h_encrypt,
+	ieee80211_tx_h_calculate_duration,
 	ieee80211_tx_h_stats,
 	NULL
 };
@@ -1139,24 +1162,6 @@ static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb)
 		return 0;
 	}
 
-	if (tx.extra_frag) {
-		for (i = 0; i < tx.num_extra_frag; i++) {
-			int next_len, dur;
-			struct ieee80211_hdr *hdr =
-				(struct ieee80211_hdr *)
-				tx.extra_frag[i]->data;
-
-			if (i + 1 < tx.num_extra_frag) {
-				next_len = tx.extra_frag[i + 1]->len;
-			} else {
-				next_len = 0;
-				tx.rate_idx = tx.last_frag_rate_idx;
-			}
-			dur = ieee80211_duration(&tx, 0, next_len);
-			hdr->duration_id = cpu_to_le16(dur);
-		}
-	}
-
 retry:
 	ret = __ieee80211_tx(local, skb, &tx);
 	if (ret) {
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

