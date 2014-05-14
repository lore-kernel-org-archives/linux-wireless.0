Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:63376 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612AbaENCua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 22:50:30 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: set valid tx_param during mwifiex_send_null_packet
Date: Tue, 13 May 2014 19:50:13 -0700
Message-ID: <1400035813-24420-1-git-send-email-bzhao@marvell.com> (sfid-20140514_045033_585214_29D739BF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

While sending null packet from driver we are passing NULL
tx_param pointer to indicate there are no more packets in queue.
PCIe send routine assumes caller has done sanity check on
tx_param and may cause crash while dereferencing next_pkt_len
from tx_param.

Avoid this by passing tx_param structure with next_pkt_len as
zero instead of NULL pointer.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c   | 1 +
 drivers/net/wireless/mwifiex/sta_tx.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index c2cfeec..574d4b5 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1071,6 +1071,7 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
  * is mapped to PCI device memory. Tx ring pointers are advanced accordingly.
  * Download ready interrupt to FW is deffered if Tx ring is not full and
  * additional payload can be accomodated.
+ * Caller must ensure tx_param parameter to this function is not NULL.
  */
 static int
 mwifiex_pcie_send_data(struct mwifiex_adapter *adapter, struct sk_buff *skb,
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 1236a5d..5fce7e7 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -128,6 +128,7 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct txpd *local_tx_pd;
+	struct mwifiex_tx_param tx_param;
 /* sizeof(struct txpd) + Interface specific header */
 #define NULL_PACKET_HDR 64
 	u32 data_len = NULL_PACKET_HDR;
@@ -168,8 +169,9 @@ int mwifiex_send_null_packet(struct mwifiex_private *priv, u8 flags)
 						   skb, NULL);
 	} else {
 		skb_push(skb, INTF_HEADER_LEN);
+		tx_param.next_pkt_len = 0;
 		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
-						   skb, NULL);
+						   skb, &tx_param);
 	}
 	switch (ret) {
 	case -EBUSY:
-- 
1.8.2.3

