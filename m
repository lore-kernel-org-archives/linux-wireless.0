Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:48957 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab1GHAbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 20:31:41 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Philip Rakity <prakity@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: 4-byte alignment in mwifiex_process_sta_txpd()
Date: Thu,  7 Jul 2011 17:37:09 -0700
Message-Id: <1310085429-19068-1-git-send-email-bzhao@marvell.com> (sfid-20110708_023144_849030_B4DB815C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

In XMIT path, the skb that we get from the kernel itself is not
aligned with 4-byte boundary on some embedded platforms.

Had it not been the presence of tx_pkt_offset field in txpd, 4 byte
memory alignment was not possible without memmove of entire skb.
And that would have increased MIPS instead of reducing.

With this patch few memory cycles can be saved while fetching
interface header and txpd structure because of 4 bytes memory
alignment.

Reported-by: Philip Rakity <prakity@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Tested-by: Philip Rakity <prakity@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/decl.h   |    4 +++-
 drivers/net/wireless/mwifiex/sta_tx.c |   13 +++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 0e90b09..94ddc90 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -30,7 +30,9 @@
 
 #define MWIFIEX_MAX_BSS_NUM         (1)
 
-#define MWIFIEX_MIN_DATA_HEADER_LEN 32	/* (sizeof(mwifiex_txpd)) */
+#define MWIFIEX_MIN_DATA_HEADER_LEN 36	/* sizeof(mwifiex_txpd)
+					 *   + 4 byte alignment
+					 */
 
 #define MWIFIEX_MAX_TX_BASTREAM_SUPPORTED	2
 #define MWIFIEX_MAX_RX_BASTREAM_SUPPORTED	16
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index fa6221b..1822bfa 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -47,6 +47,7 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct txpd *local_tx_pd;
 	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
+	u8 pad;
 
 	if (!skb->len) {
 		dev_err(adapter->dev, "Tx: bad packet length: %d\n",
@@ -55,15 +56,19 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 		return skb->data;
 	}
 
-	BUG_ON(skb_headroom(skb) < (sizeof(*local_tx_pd) + INTF_HEADER_LEN));
-	skb_push(skb, sizeof(*local_tx_pd));
+	/* If skb->data is not aligned; add padding */
+	pad = (4 - (((void *)skb->data - NULL) & 0x3)) % 4;
+
+	BUG_ON(skb_headroom(skb) < (sizeof(*local_tx_pd) + INTF_HEADER_LEN
+								+ pad));
+	skb_push(skb, sizeof(*local_tx_pd) + pad);
 
 	local_tx_pd = (struct txpd *) skb->data;
 	memset(local_tx_pd, 0, sizeof(struct txpd));
 	local_tx_pd->bss_num = priv->bss_num;
 	local_tx_pd->bss_type = priv->bss_type;
 	local_tx_pd->tx_pkt_length = cpu_to_le16((u16) (skb->len -
-							sizeof(struct txpd)));
+						(sizeof(struct txpd) + pad)));
 
 	local_tx_pd->priority = (u8) skb->priority;
 	local_tx_pd->pkt_delay_2ms =
@@ -88,7 +93,7 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 	}
 
 	/* Offset of actual data */
-	local_tx_pd->tx_pkt_offset = cpu_to_le16(sizeof(struct txpd));
+	local_tx_pd->tx_pkt_offset = cpu_to_le16(sizeof(struct txpd) + pad);
 
 	/* make space for INTF_HEADER_LEN */
 	skb_push(skb, INTF_HEADER_LEN);
-- 
1.7.0.2

