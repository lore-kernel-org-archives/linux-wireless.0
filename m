Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46421 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0L0WVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 17:21:38 -0500
Received: by fxm20 with SMTP id 20so9394399fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 14:21:36 -0800 (PST)
Subject: [PATCH] mac80211: ignore PSM bit of reordered frames
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 27 Dec 2010 23:21:26 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201012272321.27690.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch tackles one of the problems of my
reorder release timer patch from August.

<http://www.spinics.net/lists/linux-wireless/msg57214.html>
=>
What if the reorder release triggers and ap_sta_ps_end
(called by ieee80211_rx_h_sta_process) accidentally clears
the WLAN_STA_PS_STA flag, because 100ms ago - when the STA
was still active - frames were put into the reorder buffer.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
RFC -> PATCH:
	fix typo: DEFERED -> DEFERRED
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/rx.c          |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a0cf5ab..bb71fe3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -168,6 +168,7 @@ typedef unsigned __bitwise__ ieee80211_rx_result;
  * @IEEE80211_RX_FRAGMENTED: fragmented frame
  * @IEEE80211_RX_AMSDU: a-MSDU packet
  * @IEEE80211_RX_MALFORMED_ACTION_FRM: action frame is malformed
+ * @IEEE80211_RX_DEFERRED_RELEASE: frame was subjected to receive reordering
  *
  * These are per-frame flags that are attached to a frame in the
  * @rx_flags field of &struct ieee80211_rx_status.
@@ -178,6 +179,7 @@ enum ieee80211_packet_rx_flags {
 	IEEE80211_RX_FRAGMENTED			= BIT(2),
 	IEEE80211_RX_AMSDU			= BIT(3),
 	IEEE80211_RX_MALFORMED_ACTION_FRM	= BIT(4),
+	IEEE80211_RX_DEFERRED_RELEASE		= BIT(5),
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b6c2a30..e612805 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -537,6 +537,7 @@ static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
 					    struct sk_buff_head *frames)
 {
 	struct sk_buff *skb = tid_agg_rx->reorder_buf[index];
+	struct ieee80211_rx_status *status;
 
 	lockdep_assert_held(&tid_agg_rx->reorder_lock);
 
@@ -546,6 +547,8 @@ static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
 	/* release the frame from the reorder ring buffer */
 	tid_agg_rx->stored_mpdu_num--;
 	tid_agg_rx->reorder_buf[index] = NULL;
+	status = IEEE80211_SKB_RXCB(skb);
+	status->rx_flags |= IEEE80211_RX_DEFERRED_RELEASE;
 	__skb_queue_tail(frames, skb);
 
 no_frame:
@@ -1185,6 +1188,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	 * exchange sequence.
 	 */
 	if (!ieee80211_has_morefrags(hdr->frame_control) &&
+	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
 	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
 	     rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)) {
 		if (test_sta_flags(sta, WLAN_STA_PS_STA)) {
-- 
1.7.2.3

