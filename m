Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59532 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab3LPPq4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 10:46:56 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.13] mac80211: move "bufferable MMPDU" check to fix AP mode scan
Date: Mon, 16 Dec 2013 16:46:53 +0100
Message-Id: <1387208813-96802-1-git-send-email-nbd@openwrt.org> (sfid-20131216_164730_103834_D5C84A87)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check needs to apply to both multicast and unicast packets,
otherwise probe requests on AP mode scans are sent through the multicast
buffer queue, which adds long delays (often longer than the scanning
interval).

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/tx.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 002ded2..d3f37ad 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -464,7 +464,6 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	struct sta_info *sta = tx->sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	struct ieee80211_local *local = tx->local;
 
 	if (unlikely(!sta))
@@ -475,15 +474,6 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		     !(info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER))) {
 		int ac = skb_get_queue_mapping(tx->skb);
 
-		/* only deauth, disassoc and action are bufferable MMPDUs */
-		if (ieee80211_is_mgmt(hdr->frame_control) &&
-		    !ieee80211_is_deauth(hdr->frame_control) &&
-		    !ieee80211_is_disassoc(hdr->frame_control) &&
-		    !ieee80211_is_action(hdr->frame_control)) {
-			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
-			return TX_CONTINUE;
-		}
-
 		ps_dbg(sta->sdata, "STA %pM aid %d: PS buffer for AC %d\n",
 		       sta->sta.addr, sta->sta.aid, ac);
 		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
@@ -526,9 +516,21 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 {
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
+
 	if (unlikely(tx->flags & IEEE80211_TX_PS_BUFFERED))
 		return TX_CONTINUE;
 
+	/* only deauth, disassoc and action are bufferable MMPDUs */
+	if (ieee80211_is_mgmt(hdr->frame_control) &&
+	    !ieee80211_is_deauth(hdr->frame_control) &&
+	    !ieee80211_is_disassoc(hdr->frame_control) &&
+	    !ieee80211_is_action(hdr->frame_control)) {
+		info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+		return TX_CONTINUE;
+	}
+
 	if (tx->flags & IEEE80211_TX_UNICAST)
 		return ieee80211_tx_h_unicast_ps_buf(tx);
 	else
-- 
1.8.3.4 (Apple Git-47)

