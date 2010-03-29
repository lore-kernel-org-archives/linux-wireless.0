Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62821 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab0C2Ilu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 04:41:50 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH V2 1/2] mac80211: support paged rx SKBs
Date: Mon, 29 Mar 2010 16:42:25 +0800
Message-Id: <1269852146-11727-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mac80211 drivers can now pass paged SKBs to mac80211 via
ieee80211_rx{_irqsafe}. The implementation currently use
skb_linearize() in a few places i.e. management frame
handling, software decryption, defragmentation and A-MSDU
process. We will optimize them one by one later.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Cc: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>
---
V2: add comments for paged skb support
    fix pskb_may_pull size for ieee80211 and mesh header 
    use RX_DROP_UNUSABLE instead of RX_DROP_MONITOR

 include/net/mac80211.h |    5 ++++-
 net/mac80211/rx.c      |   36 ++++++++++++++++++++++++++++++++----
 net/wireless/util.c    |    8 +++++++-
 3 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1a8f50a..ecaae10 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1822,7 +1822,10 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw);
  * ieee80211_rx - receive frame
  *
  * Use this function to hand received frames to mac80211. The receive
- * buffer in @skb must start with an IEEE 802.11 header.
+ * buffer in @skb must start with an IEEE 802.11 header. In case of a
+ * paged @skb is used, the driver is recommended to put the ieee80211
+ * header of the frame on the linear part of the @skb to avoid memory
+ * allocation and/or memcpy by the stack.
  *
  * This function may not be called in IRQ context. Calls to this function
  * for a single hardware must be synchronized against each other. Calls to
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 1da57c8..11ed5aa 100644
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
@@ -227,6 +227,12 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
 		present_fcs_len = FCS_LEN;
 
+	/* make sure hdr->frame_control is on the linear part */
+	if (!pskb_may_pull(origskb, 2)) {
+		dev_kfree_skb(origskb);
+		return NULL;
+	}
+
 	if (!local->monitors) {
 		if (should_drop_frame(origskb, present_fcs_len)) {
 			dev_kfree_skb(origskb);
@@ -931,6 +937,9 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 		return RX_DROP_MONITOR;
 	}
 
+	if (skb_linearize(rx->skb))
+		return RX_DROP_UNUSABLE;
+
 	/* Check for weak IVs if possible */
 	if (rx->sta && rx->key->conf.alg == ALG_WEP &&
 	    ieee80211_is_data(hdr->frame_control) &&
@@ -1231,6 +1240,9 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	}
 	I802_DEBUG_INC(rx->local->rx_handlers_fragments);
 
+	if (skb_linearize(rx->skb))
+		return RX_DROP_UNUSABLE;
+
 	seq = (sc & IEEE80211_SCTL_SEQ) >> 4;
 
 	if (frag == 0) {
@@ -1588,6 +1600,9 @@ ieee80211_rx_h_amsdu(struct ieee80211_rx_data *rx)
 	skb->dev = dev;
 	__skb_queue_head_init(&frame_list);
 
+	if (skb_linearize(skb))
+		return RX_DROP_UNUSABLE;
+
 	ieee80211_amsdu_to_8023s(skb, &frame_list, dev->dev_addr,
 				 rx->sdata->vif.type,
 				 rx->local->hw.extra_tx_headroom);
@@ -2357,29 +2372,42 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
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
index be2ab8c..63c60b9 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -330,6 +330,9 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 		if (iftype == NL80211_IFTYPE_MESH_POINT) {
 			struct ieee80211s_hdr *meshdr =
 				(struct ieee80211s_hdr *) (skb->data + hdrlen);
+			/* make sure meshdr->flags is on the linear part */
+			if (!pskb_may_pull(skb, hdrlen + 1))
+				return -1;
 			hdrlen += ieee80211_get_mesh_hdrlen(meshdr);
 			if (meshdr->flags & MESH_FLAGS_AE_A5_A6) {
 				memcpy(dst, meshdr->eaddr1, ETH_ALEN);
@@ -346,6 +349,9 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 		if (iftype == NL80211_IFTYPE_MESH_POINT) {
 			struct ieee80211s_hdr *meshdr =
 				(struct ieee80211s_hdr *) (skb->data + hdrlen);
+			/* make sure meshdr->flags is on the linear part */
+			if (!pskb_may_pull(skb, hdrlen + 1))
+				return -1;
 			hdrlen += ieee80211_get_mesh_hdrlen(meshdr);
 			if (meshdr->flags & MESH_FLAGS_AE_A4)
 				memcpy(src, meshdr->eaddr1, ETH_ALEN);
@@ -357,7 +363,7 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 		break;
 	}
 
-	if (unlikely(skb->len - hdrlen < 8))
+	if (!pskb_may_pull(skb, hdrlen + 8))
 		return -1;
 
 	payload = skb->data + hdrlen;
-- 
1.6.3.3

