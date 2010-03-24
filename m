Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19845 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab0CXCxn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 22:53:43 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/2] mac80211: support paged rx SKBs
Date: Wed, 24 Mar 2010 10:57:42 +0800
Message-Id: <1269399463-5244-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mac80211 drivers can now pass paged SKBs to mac80211 via
ieee80211_rx{_irqsafe}. The implementation currently use
skb_linearize() in a few places i.e. management frame handling,
software decryption, defragmentation and A-MSDU process. We can
optimize them one by one later.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/rx.c   |   35 +++++++++++++++++++++++++++++++----
 net/wireless/util.c |    6 +++++-
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1da57c8..063aa84 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -38,7 +38,7 @@ static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
 {
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS) {
 		if (likely(skb->len > FCS_LEN))
-			skb_trim(skb, skb->len - FCS_LEN);
+			__pskb_trim(skb, skb->len - FCS_LEN);
 		else {
 			/* driver bug */
 			WARN_ON(1);
@@ -227,6 +227,11 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
 		present_fcs_len = FCS_LEN;
 
+	if (!pskb_may_pull(origskb, sizeof(struct ieee80211_hdr))) {
+		dev_kfree_skb(origskb);
+		return NULL;
+	}
+
 	if (!local->monitors) {
 		if (should_drop_frame(origskb, present_fcs_len)) {
 			dev_kfree_skb(origskb);
@@ -931,6 +936,9 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		return RX_DROP_MONITOR;
 	}
 
+	if (skb_linearize(rx->skb))
+		return RX_DROP_MONITOR;
+
 	/* Check for weak IVs if possible */
 	if (rx->sta && rx->key->conf.alg == ALG_WEP &&
 	    ieee80211_is_data(hdr->frame_control) &&
@@ -1231,6 +1239,9 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	}
 	I802_DEBUG_INC(rx->local->rx_handlers_fragments);
 
+	if (skb_linearize(rx->skb))
+		return RX_DROP_MONITOR;
+
 	seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
 
 	if (frag == 0) {
@@ -1588,6 +1599,9 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	skb->dev = dev;
 	__skb_queue_head_init(&frame_list);
 
+	if (skb_linearize(skb))
+		return RX_DROP_MONITOR;
+
 	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
 				 rx->sdata->vif.type,
 				 rx->local->hw.extra_tx_headroom);
@@ -2357,29 +2371,42 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr;
+	__le16 fc;
 	struct ieee80211_rx_data rx;
 	int prepares;
 	struct ieee80211_sub_if_data *prev = NULL;
 	struct sk_buff *skb_new;
 	struct sta_info *sta, *tmp;
 	bool found_sta = false;
+	int err = 0;
 
-	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
 	memset(&rx, 0, sizeof(rx));
 	rx.skb = skb;
 	rx.local = local;
 
-	if (ieee80211_is_data(hdr->frame_control) || ieee80211_is_mgmt(hdr->frame_control))
+	if (ieee80211_is_data(fc) || ieee80211_is_mgmt(fc))
 		local->dot11ReceivedFragmentCount++;
 
 	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
 		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)))
 		rx.flags |= IEEE80211_RX_IN_SCAN;
 
+	if (ieee80211_is_mgmt(fc))
+		err = skb_linearize(skb);
+	else
+		err = !pskb_may_pull(skb, ieee80211_hdrlen(fc));
+
+	if (err) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
+	hdr = (struct ieee80211_hdr *)skb->data;
 	ieee80211_parse_qos(&rx);
 	ieee80211_verify_alignment(&rx);
 
-	if (ieee80211_is_data(hdr->frame_control)) {
+	if (ieee80211_is_data(fc)) {
 		for_each_sta_info(local, hdr->addr2, sta, tmp) {
 			rx.sta = sta;
 			found_sta = true;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index be2ab8c..1764043 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -314,6 +314,10 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 	memcpy(dst, ieee80211_get_DA(hdr), ETH_ALEN);
 	memcpy(src, ieee80211_get_SA(hdr), ETH_ALEN);
 
+	if (iftype == NL80211_IFTYPE_MESH_POINT &&
+	    !pskb_may_pull(skb, hdrlen + sizeof(struct ieee80211s_hdr)))
+		return -1;
+
 	switch (hdr->frame_control &
 		cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
 	case cpu_to_le16(IEEE80211_FCTL_TODS):
@@ -357,7 +361,7 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 		break;
 	}
 
-	if (unlikely(skb->len - hdrlen < 8))
+	if (!pskb_may_pull(skb, hdrlen + 8))
 		return -1;
 
 	payload = skb->data + hdrlen;
-- 
1.6.0.4

