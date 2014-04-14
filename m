Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12451 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755687AbaDNWc7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Apr 2014 18:32:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/7] mwifiex: improve AMSDU packet aggregation for PCIe and SDIO
Date: Mon, 14 Apr 2014 15:32:51 -0700
Message-ID: <1397514775-4777-3-git-send-email-bzhao@marvell.com> (sfid-20140415_003304_186438_21014C98)
In-Reply-To: <1397514775-4777-1-git-send-email-bzhao@marvell.com>
References: <1397514775-4777-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

For PCIe, aggregate more AMSDU packets till PCIe TXBD is full.

For SDIO, aggregation was disabled for AMSDU packets because
AMSDU aggregated packet size is already 4K or 8K, SDIO Multiport
Aggregation feature didn't use to gain much previously.
Now with increased multiport aggregation buffer, we can enable
it for AMSDU packets.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 63211707..b179652 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -236,18 +236,11 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_USB_EP_DATA,
 						   skb_aggr, NULL);
 	} else {
-		/*
-		 * Padding per MSDU will affect the length of next
-		 * packet and hence the exact length of next packet
-		 * is uncertain here.
-		 *
-		 * Also, aggregation of transmission buffer, while
-		 * downloading the data to the card, wont gain much
-		 * on the AMSDU packets as the AMSDU packets utilizes
-		 * the transmission buffer space to the maximum
-		 * (adapter->tx_buf_size).
-		 */
-		tx_param.next_pkt_len = 0;
+		if (skb_src)
+			tx_param.next_pkt_len =
+					skb_src->len + sizeof(struct txpd);
+		else
+			tx_param.next_pkt_len = 0;
 
 		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
 						   skb_aggr, &tx_param);
-- 
1.8.2.3

