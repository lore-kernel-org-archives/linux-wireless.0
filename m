Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24332 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbZJWUmg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:36 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/18] iwlwifi: fix use after free bug for paged rx
Date: Fri, 23 Oct 2009 13:42:25 -0700
Message-Id: <1256330556-20997-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

In the paged rx patch (4854fde2), I introduced a bug that could possibly
touch an already freed page. It is fixed by avoiding the access in this
patch. I've also added some comments so that other people touching the
code won't make the same mistake. In the future, if we cannot avoid
access the page after being handled to the upper layer, we can use
get_page/put_page to handle it. For now, it's just not necessary.

It also fixed a debug message print bug reported by Stanislaw Gruszka
<sgruszka@redhat.com>.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   15 ++++++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   11 +++++++++--
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   21 ++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   18 +++++++++++++-----
 4 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 269b988..f5d7528 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -548,6 +548,7 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 	u16 len = le16_to_cpu(rx_hdr->len);
 	struct sk_buff *skb;
 	int ret;
+	__le16 fc = hdr->frame_control;
 
 	/* We received data from the HW, so stop the watchdog */
 	if (unlikely(len + IWL39_RX_FRAME_SIZE >
@@ -580,9 +581,9 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 	/* mac80211 currently doesn't support paged SKB. Convert it to
 	 * linear SKB for management frame and data frame requires
 	 * software decryption or software defragementation. */
-	if (ieee80211_is_mgmt(hdr->frame_control) ||
-	    ieee80211_has_protected(hdr->frame_control) ||
-	    ieee80211_has_morefrags(hdr->frame_control) ||
+	if (ieee80211_is_mgmt(fc) ||
+	    ieee80211_has_protected(fc) ||
+	    ieee80211_has_morefrags(fc) ||
 	    le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)
 		ret = skb_linearize(skb);
 	else
@@ -594,11 +595,15 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv *priv,
 		goto out;
 	}
 
-	iwl_update_stats(priv, false, hdr->frame_control, len);
+	/*
+	 * XXX: We cannot touch the page and its virtual memory (pkt) after
+	 * here. It might have already been freed by the above skb change.
+	 */
 
+	iwl_update_stats(priv, false, fc, len);
 	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
-	ieee80211_rx(priv->hw, skb);
 
+	ieee80211_rx(priv->hw, skb);
  out:
 	priv->alloc_rxb_page--;
 	rxb->page = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a34acb7..0d38865 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -814,8 +814,8 @@ void iwl_rx_handle(struct iwl_priv *priv)
 		if (priv->rx_handlers[pkt->hdr.cmd]) {
 			IWL_DEBUG_RX(priv, "r = %d, i = %d, %s, 0x%02x\n", r,
 				i, get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
-			priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
 			priv->isr_stats.rx_handlers[pkt->hdr.cmd]++;
+			priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
 		} else {
 			/* No handling needed */
 			IWL_DEBUG_RX(priv,
@@ -824,11 +824,18 @@ void iwl_rx_handle(struct iwl_priv *priv)
 				pkt->hdr.cmd);
 		}
 
+		/*
+		 * XXX: After here, we should always check rxb->page
+		 * against NULL before touching it or its virtual
+		 * memory (pkt). Because some rx_handler might have
+		 * already taken or freed the pages.
+		 */
+
 		if (reclaim) {
 			/* Invoke any callbacks, transfer the buffer to caller,
 			 * and fire off the (possibly) blocking iwl_send_cmd()
 			 * as we reclaim the driver command queue */
-			if (rxb && rxb->page)
+			if (rxb->page)
 				iwl_tx_cmd_complete(priv, rxb);
 			else
 				IWL_WARN(priv, "Claim null rxb?\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index cfc31ae..e5339c9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -241,6 +241,7 @@ void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 	struct iwl_rx_mem_buffer *rxb;
 	struct page *page;
 	unsigned long flags;
+	gfp_t gfp_mask = priority;
 
 	while (1) {
 		spin_lock_irqsave(&rxq->lock, flags);
@@ -251,13 +252,13 @@ void iwl_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
 		if (rxq->free_count > RX_LOW_WATERMARK)
-			priority |= __GFP_NOWARN;
+			gfp_mask |= __GFP_NOWARN;
 
 		if (priv->hw_params.rx_page_order > 0)
-			priority |= __GFP_COMP;
+			gfp_mask |= __GFP_COMP;
 
 		/* Alloc a new receive buffer */
-		page = alloc_pages(priority, priv->hw_params.rx_page_order);
+		page = alloc_pages(gfp_mask, priv->hw_params.rx_page_order);
 		if (!page) {
 			if (net_ratelimit())
 				IWL_DEBUG_INFO(priv, "alloc_pages failed, "
@@ -922,6 +923,7 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 {
 	struct sk_buff *skb;
 	int ret = 0;
+	__le16 fc = hdr->frame_control;
 
 	/* We only process data packets if the interface is open */
 	if (unlikely(!priv->is_open)) {
@@ -946,9 +948,9 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 	/* mac80211 currently doesn't support paged SKB. Convert it to
 	 * linear SKB for management frame and data frame requires
 	 * software decryption or software defragementation. */
-	if (ieee80211_is_mgmt(hdr->frame_control) ||
-	    ieee80211_has_protected(hdr->frame_control) ||
-	    ieee80211_has_morefrags(hdr->frame_control) ||
+	if (ieee80211_is_mgmt(fc) ||
+	    ieee80211_has_protected(fc) ||
+	    ieee80211_has_morefrags(fc) ||
 	    le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)
 		ret = skb_linearize(skb);
 	else
@@ -960,7 +962,12 @@ static void iwl_pass_packet_to_mac80211(struct iwl_priv *priv,
 		goto out;
 	}
 
-	iwl_update_stats(priv, false, hdr->frame_control, len);
+	/*
+	 * XXX: We cannot touch the page and its virtual memory (hdr) after
+	 * here. It might have already been freed by the above skb change.
+	 */
+
+	iwl_update_stats(priv, false, fc, len);
 	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
 
 	ieee80211_rx(priv->hw, skb);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5977a57..8b08bdc 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1124,6 +1124,7 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 	struct iwl_rx_mem_buffer *rxb;
 	struct page *page;
 	unsigned long flags;
+	gfp_t gfp_mask = priority;
 
 	while (1) {
 		spin_lock_irqsave(&rxq->lock, flags);
@@ -1135,13 +1136,13 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
 		if (rxq->free_count > RX_LOW_WATERMARK)
-			priority |= __GFP_NOWARN;
+			gfp_mask |= __GFP_NOWARN;
 
 		if (priv->hw_params.rx_page_order > 0)
-			priority |= __GFP_COMP;
+			gfp_mask |= __GFP_COMP;
 
 		/* Alloc a new receive buffer */
-		page = alloc_pages(priority, priv->hw_params.rx_page_order);
+		page = alloc_pages(gfp_mask, priv->hw_params.rx_page_order);
 		if (!page) {
 			if (net_ratelimit())
 				IWL_DEBUG_INFO(priv, "Failed to allocate SKB buffer.\n");
@@ -1410,8 +1411,8 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 		if (priv->rx_handlers[pkt->hdr.cmd]) {
 			IWL_DEBUG_RX(priv, "r = %d, i = %d, %s, 0x%02x\n", r, i,
 				get_cmd_string(pkt->hdr.cmd), pkt->hdr.cmd);
-			priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
 			priv->isr_stats.rx_handlers[pkt->hdr.cmd]++;
+			priv->rx_handlers[pkt->hdr.cmd] (priv, rxb);
 		} else {
 			/* No handling needed */
 			IWL_DEBUG_RX(priv,
@@ -1420,11 +1421,18 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 				pkt->hdr.cmd);
 		}
 
+		/*
+		 * XXX: After here, we should always check rxb->page
+		 * against NULL before touching it or its virtual
+		 * memory (pkt). Because some rx_handler might have
+		 * already taken or freed the pages.
+		 */
+
 		if (reclaim) {
 			/* Invoke any callbacks, transfer the buffer to caller,
 			 * and fire off the (possibly) blocking iwl_send_cmd()
 			 * as we reclaim the driver command queue */
-			if (rxb && rxb->page)
+			if (rxb->page)
 				iwl_tx_cmd_complete(priv, rxb);
 			else
 				IWL_WARN(priv, "Claim null rxb?\n");
-- 
1.5.6.3

