Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:50582 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754599AbZKWHQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 02:16:28 -0500
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 2/6] rt2x00: Remove unused variable frame_control from rt2x00mac_tx.
Date: Mon, 23 Nov 2009 08:16:01 +0100
Message-Id: <1258960565-26736-3-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1258960565-26736-2-git-send-email-gwingerde@gmail.com>
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com>
 <1258960565-26736-2-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As additional fallout also remove the also unused variable ieee80211hdr.

Reported-by: Johannes Stezenbach <js@sig21.net>
Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00mac.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 9c90ceb..de549c2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -103,10 +103,8 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	enum data_queue_qid qid = skb_get_queue_mapping(skb);
 	struct data_queue *queue;
-	u16 frame_control;
 
 	/*
 	 * Mac80211 might be calling this function while we are trying
@@ -141,7 +139,6 @@ int rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * either RTS or CTS-to-self frame and handles everything
 	 * inside the hardware.
 	 */
-	frame_control = le16_to_cpu(ieee80211hdr->frame_control);
 	if ((tx_info->control.rates[0].flags & (IEEE80211_TX_RC_USE_RTS_CTS |
 						IEEE80211_TX_RC_USE_CTS_PROTECT)) &&
 	    !rt2x00dev->ops->hw->set_rts_threshold) {
-- 
1.6.5.3

