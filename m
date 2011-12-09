Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:56559 "HELO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751401Ab1LIEla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 23:41:30 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: proper cleanup when RX multiport aggregation fails
Date: Thu,  8 Dec 2011 20:41:04 -0800
Message-Id: <1323405665-21942-2-git-send-email-bzhao@marvell.com> (sfid-20111209_054135_622934_F5AD97D7)
In-Reply-To: <1323405665-21942-1-git-send-email-bzhao@marvell.com>
References: <1323405665-21942-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Free SKBs allocated during multiport aggrgation setup when RX
multiport aggregation fails in the middle. With this handling
freeing SKB in mwifiex_process_int_status() for failure case
is removed.

Also handles single RX transaction failure.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 702452b..d39d845 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1087,7 +1087,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 					   (adapter->ioport | 0x1000 |
 					    (card->mpa_rx.ports << 4)) +
 					   card->mpa_rx.start_port, 1))
-			return -1;
+			goto error;
 
 		curr_ptr = card->mpa_rx.buf;
 
@@ -1130,12 +1130,29 @@ rx_curr_single:
 		if (mwifiex_sdio_card_to_host(adapter, &pkt_type,
 					      skb->data, skb->len,
 					      adapter->ioport + port))
-			return -1;
+			goto error;
 
 		mwifiex_decode_rx_packet(adapter, skb, pkt_type);
 	}
 
 	return 0;
+
+error:
+	if (MP_RX_AGGR_IN_PROGRESS(card)) {
+		/* Multiport-aggregation transfer failed - cleanup */
+		for (pind = 0; pind < card->mpa_rx.pkt_cnt; pind++) {
+			/* copy pkt to deaggr buf */
+			skb_deaggr = card->mpa_rx.skb_arr[pind];
+			dev_kfree_skb_any(skb_deaggr);
+		}
+		MP_RX_AGGR_BUF_RESET(card);
+	}
+
+	if (f_do_rx_cur)
+		/* Single transfer pending. Free curr buff also */
+		dev_kfree_skb_any(skb);
+
+	return -1;
 }
 
 /*
@@ -1271,7 +1288,6 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 
 				dev_dbg(adapter->dev,
 						"info: CFG reg val =%x\n", cr);
-				dev_kfree_skb_any(skb);
 				return -1;
 			}
 		}
-- 
1.7.0.2

