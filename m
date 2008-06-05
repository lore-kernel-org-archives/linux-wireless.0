Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:53937 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbYFEN2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 09:28:45 -0400
Date: Thu, 5 Jun 2008 09:07:34 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linville@tuxdriver.com
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] rt2x00: Rename tx_info to info to help compat-wireless revert MQ support for older kernels
Message-ID: <20080605130734.GD17936@ruslug.rutgers.edu> (sfid-20080605_152848_110692_F97414BF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Rename tx_info to info as used by other drivers. This will help
with CONFIG_NETDEVICES_MULTIQUEUE requirement for HT support support
in compat-wireless by allowing us to map skb_get_queue_mapping(skb)
to the old info->queue.

An alternative is to maintain a large compat.diff which replaces all
skb_get_queue_mapping(skb) calls back to info->queue but since this
is the only driver which requires name change it seems worth it
to help with maintenance.

Compat-wireless shouldn't be a reason to accept patches in but if
the changes are just cosmetic it seems worth the benefit.

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index b02dbc8..ff8b476 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -33,13 +33,13 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 				struct data_queue *queue,
 				struct sk_buff *frag_skb)
 {
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(frag_skb);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(frag_skb);
 	struct skb_frame_desc *skbdesc;
 	struct ieee80211_tx_info *rts_info;
 	struct sk_buff *skb;
 	int size;
 
-	if (tx_info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
+	if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
 		size = sizeof(struct ieee80211_cts);
 	else
 		size = sizeof(struct ieee80211_rts);
@@ -68,18 +68,18 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 	rts_info->flags &= ~IEEE80211_TX_CTL_USE_CTS_PROTECT;
 	rts_info->flags &= ~IEEE80211_TX_CTL_REQ_TX_STATUS;
 
-	if (tx_info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
+	if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
 		rts_info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	else
 		rts_info->flags &= ~IEEE80211_TX_CTL_NO_ACK;
 
-	if (tx_info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
-		ieee80211_ctstoself_get(rt2x00dev->hw, tx_info->control.vif,
-					frag_skb->data, size, tx_info,
+	if (info->flags & IEEE80211_TX_CTL_USE_CTS_PROTECT)
+		ieee80211_ctstoself_get(rt2x00dev->hw, info->control.vif,
+					frag_skb->data, size, info,
 					(struct ieee80211_cts *)(skb->data));
 	else
-		ieee80211_rts_get(rt2x00dev->hw, tx_info->control.vif,
-				  frag_skb->data, size, tx_info,
+		ieee80211_rts_get(rt2x00dev->hw, info->control.vif,
+				  frag_skb->data, size, info,
 				  (struct ieee80211_rts *)(skb->data));
 
 	/*
@@ -100,7 +100,7 @@ static int rt2x00mac_tx_rts_cts(struct rt2x00_dev *rt2x00dev,
 int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	enum data_queue_qid qid = skb_get_queue_mapping(skb);
 	struct data_queue *queue;
@@ -121,7 +121,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	/*
 	 * Determine which queue to put packet on.
 	 */
-	if (tx_info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM &&
+	if (info->flags & IEEE80211_TX_CTL_SEND_AFTER_DTIM &&
 	    test_bit(DRIVER_REQUIRE_ATIM_QUEUE, &rt2x00dev->flags))
 		queue = rt2x00queue_get_queue(rt2x00dev, QID_ATIM);
 	else
@@ -146,7 +146,7 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 */
 	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
 	if (!is_rts_frame(frame_control) && !is_cts_frame(frame_control) &&
-	    (tx_info->flags & (IEEE80211_TX_CTL_USE_RTS_CTS |
+	    (info->flags & (IEEE80211_TX_CTL_USE_RTS_CTS |
 			       IEEE80211_TX_CTL_USE_CTS_PROTECT)) &&
 	    !rt2x00dev->ops->hw->set_rts_threshold) {
 		if (rt2x00queue_available(queue) <= 1) {
-- 
1.5.4.3

