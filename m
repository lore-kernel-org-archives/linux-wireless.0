Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:57857 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab1D1MN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 08:13:28 -0400
Date: Thu, 28 Apr 2011 17:34:48 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Pradeep Nemavat <pnemavat@marvell.com>
Subject: [PATCH] mwl8k: Reducing extra_tx_headroom for tx optimization in
 AP mode
Message-ID: <20110428120441.GA23615@hertz.marvell.com> (sfid-20110428_141332_271836_F091EAF4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tx_headroom required for mwl8k driver is 32 bytes and it
can use the space for 802.11 header received from mac80211.
mwl8k considers the smallest 802.11 frame (CTS2self of 10
bytes) that can be received from mac80211  to compute the
extra_tx_headroom as 22 (32 - 10) bytes.

When the wireless interface is part of bridge, this
extra_tx_headroom requirement results in a memcpy in
mac80211 (in function pskb_expand_head) for all the data
frames needing L2 forwarding/bridging, when NET_SKB_PAD is
defined as 32. This patch reduces the extra_tx_headroom by
8 bytes so that memcpy of data frames in mac80211 is
avoided in this case.

The resize will be required in driver for frames with 802.11
header size of less than 18 bytes.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   31 ++++++++++++++++++++++++++-----
 1 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index d0ed503..3ca3427 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -781,8 +781,10 @@ static inline void mwl8k_remove_dma_header(struct sk_buff *skb, __le16 qos)
 		skb_pull(skb, sizeof(*tr) - hdrlen);
 }
 
+#define REDUCED_TX_HEADROOM	8
+
 static void
-mwl8k_add_dma_header(struct sk_buff *skb, int tail_pad)
+mwl8k_add_dma_header(struct mwl8k_priv *priv, struct sk_buff *skb, int tail_pad)
 {
 	struct ieee80211_hdr *wh;
 	int hdrlen;
@@ -798,6 +800,22 @@ mwl8k_add_dma_header(struct sk_buff *skb, int tail_pad)
 	wh = (struct ieee80211_hdr *)skb->data;
 
 	hdrlen = ieee80211_hdrlen(wh->frame_control);
+
+	/*
+	 * Check if skb_resize is required because of
+	 * tx_headroom adjustment.
+	 */
+	if (priv->ap_fw && (hdrlen < (sizeof(struct ieee80211_cts)
+						+ REDUCED_TX_HEADROOM))) {
+		if (pskb_expand_head(skb, REDUCED_TX_HEADROOM, 0, GFP_ATOMIC)) {
+
+			wiphy_err(priv->hw->wiphy,
+					"Failed to reallocate TX buffer\n");
+			return;
+		}
+		skb->truesize += REDUCED_TX_HEADROOM;
+	}
+
 	reqd_hdrlen = sizeof(*tr);
 
 	if (hdrlen != reqd_hdrlen)
@@ -820,7 +838,8 @@ mwl8k_add_dma_header(struct sk_buff *skb, int tail_pad)
 	tr->fwlen = cpu_to_le16(skb->len - sizeof(*tr) + tail_pad);
 }
 
-static void mwl8k_encapsulate_tx_frame(struct sk_buff *skb)
+static void mwl8k_encapsulate_tx_frame(struct mwl8k_priv *priv,
+		struct sk_buff *skb)
 {
 	struct ieee80211_hdr *wh;
 	struct ieee80211_tx_info *tx_info;
@@ -861,7 +880,7 @@ static void mwl8k_encapsulate_tx_frame(struct sk_buff *skb)
 			break;
 		}
 	}
-	mwl8k_add_dma_header(skb, data_pad);
+	mwl8k_add_dma_header(priv, skb, data_pad);
 }
 
 /*
@@ -1831,9 +1850,9 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 		mgmtframe = true;
 
 	if (priv->ap_fw)
-		mwl8k_encapsulate_tx_frame(skb);
+		mwl8k_encapsulate_tx_frame(priv, skb);
 	else
-		mwl8k_add_dma_header(skb, 0);
+		mwl8k_add_dma_header(priv, skb, 0);
 
 	wh = &((struct mwl8k_dma_data *)skb->data)->wh;
 
@@ -5489,6 +5508,8 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 	hw->extra_tx_headroom =
 		sizeof(struct mwl8k_dma_data) - sizeof(struct ieee80211_cts);
 
+	hw->extra_tx_headroom -= priv->ap_fw ? REDUCED_TX_HEADROOM : 0;
+
 	hw->channel_change_time = 10;
 
 	hw->queues = MWL8K_TX_WMM_QUEUES;
-- 
1.5.4.1

