Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:41420 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab1EELJv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 07:09:51 -0400
Date: Thu, 5 May 2011 16:30:48 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH] mwl8k: Do not ask mac80211 to generate IV for crypto keys
Message-ID: <20110505110040.GA13554@hertz.marvell.com> (sfid-20110505_130955_033123_0A067D11)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since firmware is capable of generating IV's for all crypto
suits (TKIP, CCMP and WEP), do not ask mac80211 to generate
IV when HW crypto is being used. Instead only reserve
appropriate space in tx skb's in the driver, so that the
firmware can write IV's values.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9f5ecef..7842438 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -784,7 +784,8 @@ static inline void mwl8k_remove_dma_header(struct sk_buff *skb, __le16 qos)
 #define REDUCED_TX_HEADROOM	8
 
 static void
-mwl8k_add_dma_header(struct mwl8k_priv *priv, struct sk_buff *skb, int tail_pad)
+mwl8k_add_dma_header(struct mwl8k_priv *priv, struct sk_buff *skb,
+						int head_pad, int tail_pad)
 {
 	struct ieee80211_hdr *wh;
 	int hdrlen;
@@ -816,7 +817,7 @@ mwl8k_add_dma_header(struct mwl8k_priv *priv, struct sk_buff *skb, int tail_pad)
 		skb->truesize += REDUCED_TX_HEADROOM;
 	}
 
-	reqd_hdrlen = sizeof(*tr);
+	reqd_hdrlen = sizeof(*tr) + head_pad;
 
 	if (hdrlen != reqd_hdrlen)
 		skb_push(skb, reqd_hdrlen - hdrlen);
@@ -845,6 +846,7 @@ static void mwl8k_encapsulate_tx_frame(struct mwl8k_priv *priv,
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_key_conf *key_conf;
 	int data_pad;
+	int head_pad = 0;
 
 	wh = (struct ieee80211_hdr *)skb->data;
 
@@ -856,9 +858,7 @@ static void mwl8k_encapsulate_tx_frame(struct mwl8k_priv *priv,
 
 	/*
 	 * Make sure the packet header is in the DMA header format (4-address
-	 * without QoS), the necessary crypto padding between the header and the
-	 * payload has already been provided by mac80211, but it doesn't add
-	 * tail padding when HW crypto is enabled.
+	 * without QoS), and add head & tail padding when HW crypto is enabled.
 	 *
 	 * We have the following trailer padding requirements:
 	 * - WEP: 4 trailer bytes (ICV)
@@ -867,6 +867,7 @@ static void mwl8k_encapsulate_tx_frame(struct mwl8k_priv *priv,
 	 */
 	data_pad = 0;
 	if (key_conf != NULL) {
+		head_pad = key_conf->iv_len;
 		switch (key_conf->cipher) {
 		case WLAN_CIPHER_SUITE_WEP40:
 		case WLAN_CIPHER_SUITE_WEP104:
@@ -880,7 +881,7 @@ static void mwl8k_encapsulate_tx_frame(struct mwl8k_priv *priv,
 			break;
 		}
 	}
-	mwl8k_add_dma_header(priv, skb, data_pad);
+	mwl8k_add_dma_header(priv, skb, head_pad, data_pad);
 }
 
 /*
@@ -1837,7 +1838,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	if (priv->ap_fw)
 		mwl8k_encapsulate_tx_frame(priv, skb);
 	else
-		mwl8k_add_dma_header(priv, skb, 0);
+		mwl8k_add_dma_header(priv, skb, 0, 0);
 
 	wh = &((struct mwl8k_dma_data *)skb->data)->wh;
 
@@ -4071,7 +4072,6 @@ static int mwl8k_set_key(struct ieee80211_hw *hw,
 		addr = sta->addr;
 
 	if (cmd_param == SET_KEY) {
-		key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
 		rc = mwl8k_cmd_encryption_set_key(hw, vif, addr, key);
 		if (rc)
 			goto out;
-- 
1.7.3.5

