Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48628 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbaGGKU2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 06:20:28 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] Revert "mac80211: move "bufferable MMPDU" check to fix AP mode scan"
Date: Mon,  7 Jul 2014 12:20:13 +0200
Message-Id: <1404728413-4931-1-git-send-email-johannes@sipsolutions.net> (sfid-20140707_122034_022800_AB8D3D8F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This reverts commit 277d916fc2e959c3f106904116bb4f7b1148d47a as it was
at least breaking iwlwifi by setting the IEEE80211_TX_CTL_NO_PS_BUFFER
flag in all kinds of interface modes, not only for AP mode where it is
appropriate.

To avoid reintroducing the original problem, explicitly check for probe
request frames in the multicast buffering code.

Cc: stable@vger.kernel.org
Fixes: 277d916fc2e9 ("mac80211: move "bufferable MMPDU" check to fix AP mode scan")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 865bdaf06ff1..464106c023d8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -415,6 +415,9 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	if (ieee80211_has_order(hdr->frame_control))
 		return TX_CONTINUE;
 
+	if (ieee80211_is_probe_req(hdr->frame_control))
+		return TX_CONTINUE;
+
 	if (tx->local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
 		info->hw_queue = tx->sdata->vif.cab_queue;
 
@@ -464,6 +467,7 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 {
 	struct sta_info *sta = tx->sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 	struct ieee80211_local *local = tx->local;
 
 	if (unlikely(!sta))
@@ -475,6 +479,12 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 		     !(info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER))) {
 		int ac = skb_get_queue_mapping(tx->skb);
 
+		if (ieee80211_is_mgmt(hdr->frame_control) &&
+		    !ieee80211_is_bufferable_mmpdu(hdr->frame_control)) {
+			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+			return TX_CONTINUE;
+		}
+
 		ps_dbg(sta->sdata, "STA %pM aid %d: PS buffer for AC %d\n",
 		       sta->sta.addr, sta->sta.aid, ac);
 		if (tx->local->total_ps_buffered >= TOTAL_MAX_TX_BUFFER)
@@ -534,19 +544,9 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_ps_buf(struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
-
 	if (unlikely(tx->flags & IEEE80211_TX_PS_BUFFERED))
 		return TX_CONTINUE;
 
-	if (ieee80211_is_mgmt(hdr->frame_control) &&
-	    !ieee80211_is_bufferable_mmpdu(hdr->frame_control)) {
-		if (tx->flags & IEEE80211_TX_UNICAST)
-			info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
-		return TX_CONTINUE;
-	}
-
 	if (tx->flags & IEEE80211_TX_UNICAST)
 		return ieee80211_tx_h_unicast_ps_buf(tx);
 	else
-- 
2.0.0

