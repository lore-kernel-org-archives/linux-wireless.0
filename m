Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62925 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab0L3TX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Dec 2010 14:23:56 -0500
Received: by pva4 with SMTP id 4so2062627pva.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Dec 2010 11:23:55 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, mwl8k-devel@cozybit.com,
	Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/4 V2] mwl8k: Add encapsulation of data packet for crypto
Date: Thu, 30 Dec 2010 11:23:32 -0800
Message-Id: <1293737014-11718-2-git-send-email-thomas@cozybit.com>
In-Reply-To: <1293737014-11718-1-git-send-email-thomas@cozybit.com>
References: <1293737014-11718-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nishant Sarmukadam <nishants@marvell.com>

Different tail pads will be needed for crypto depending on the crypto
mode. Add support to encapsulate the packets with appropriate pad
value.

V2:
- Remove unneeded fill_ccmp_header() and CCMP header data
  structures (Johannes, Yogesh)
- Use new cipher definitions earlier in patchset (Johannes)

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Pradeep Nemavat <pnemavat@marvell.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   54 +++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 1798b7e..95bbdca 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -232,6 +232,9 @@ struct mwl8k_priv {
 	struct completion firmware_loading_complete;
 };
 
+#define MAX_WEP_KEY_LEN         13
+#define NUM_WEP_KEYS            4
+
 /* Per interface specific private data */
 struct mwl8k_vif {
 	struct list_head list;
@@ -242,6 +245,12 @@ struct mwl8k_vif {
 
 	/* Non AMPDU sequence number assigned by driver.  */
 	u16 seqno;
+
+	/* Saved WEP keys */
+	struct {
+		u8 enabled;
+		u8 key[sizeof(struct ieee80211_key_conf) + MAX_WEP_KEY_LEN];
+	} wep_key_conf[NUM_WEP_KEYS];
 };
 #define MWL8K_VIF(_vif) ((struct mwl8k_vif *)&((_vif)->drv_priv))
 
@@ -754,6 +763,49 @@ mwl8k_add_dma_header(struct sk_buff *skb, int tail_pad)
 	tr->fwlen = cpu_to_le16(skb->len - sizeof(*tr) + tail_pad);
 }
 
+static void mwl8k_encapsulate_tx_frame(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *wh;
+	struct ieee80211_tx_info *tx_info;
+	struct ieee80211_key_conf *key_conf;
+	int data_pad;
+
+	wh = (struct ieee80211_hdr *)skb->data;
+
+	tx_info = IEEE80211_SKB_CB(skb);
+
+	key_conf = NULL;
+	if (ieee80211_is_data(wh->frame_control))
+		key_conf = tx_info->control.hw_key;
+
+	/*
+	 * Make sure the packet header is in the DMA header format (4-address
+	 * without QoS), the necessary crypto padding between the header and the
+	 * payload has already been provided by mac80211, but it doesn't add tail
+	 * padding when HW crypto is enabled.
+	 *
+	 * We have the following trailer padding requirements:
+	 * - WEP: 4 trailer bytes (ICV)
+	 * - TKIP: 12 trailer bytes (8 MIC + 4 ICV)
+	 * - CCMP: 8 trailer bytes (MIC)
+	 */
+	data_pad = 0;
+	if (key_conf != NULL) {
+		switch (key_conf->cipher) {
+		case WLAN_CIPHER_SUITE_WEP40:
+		case WLAN_CIPHER_SUITE_WEP104:
+			data_pad = 4;
+			break;
+		case WLAN_CIPHER_SUITE_TKIP:
+			data_pad = 12;
+			break;
+		case WLAN_CIPHER_SUITE_CCMP:
+			data_pad = 8;
+			break;
+		}
+	}
+	mwl8k_add_dma_header(skb, data_pad);
+}
 
 /*
  * Packet reception for 88w8366 AP firmware.
@@ -1447,7 +1499,7 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 	else
 		qos = 0;
 
-	mwl8k_add_dma_header(skb, 0);
+	mwl8k_encapsulate_tx_frame(skb);
 	wh = &((struct mwl8k_dma_data *)skb->data)->wh;
 
 	tx_info = IEEE80211_SKB_CB(skb);
-- 
1.7.0.4

