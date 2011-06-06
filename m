Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:39757 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab1FFJeB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 05:34:01 -0400
Date: Mon, 6 Jun 2011 14:54:17 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 4/4] mwifiex: disable transmission buffer aggregation for
 AMSDU packets
Message-ID: <20110606092416.GD28199@hertz.marvell.com> (sfid-20110606_113404_970375_91ABD3E5)
References: <20110606091615.GA28184@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110606091615.GA28184@hertz.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Padding per MSDU will affect the length of next packet and hence
the exact length of next packet is uncertain here.

Also, aggregation of transmission buffer, while downloading the
data to the card, wont gain much on the AMSDU packets as the AMSDU
packets utilizes the transmission buffer space to the maximum
(adapter->tx_buf_size).

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 25312e4..1a453a6 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -233,11 +233,19 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 	skb_push(skb_aggr, headroom);
 
-	tx_param.next_pkt_len = ((pra_list->total_pkts_size) ?
-				 (((pra_list->total_pkts_size) >
-				   adapter->tx_buf_size) ? adapter->
-				  tx_buf_size : pra_list->total_pkts_size +
-				  LLC_SNAP_LEN + sizeof(struct txpd)) : 0);
+	/*
+	 * Padding per MSDU will affect the length of next
+	 * packet and hence the exact length of next packet
+	 * is uncertain here.
+	 *
+	 * Also, aggregation of transmission buffer, while
+	 * downloading the data to the card, wont gain much
+	 * on the AMSDU packets as the AMSDU packets utilizes
+	 * the transmission buffer space to the maximum
+	 * (adapter->tx_buf_size).
+	 */
+	tx_param.next_pkt_len = 0;
+
 	ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
 					     skb_aggr->data,
 					     skb_aggr->len, &tx_param);
-- 
1.7.3.5

