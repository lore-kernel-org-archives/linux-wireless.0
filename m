Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:55481 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756133Ab3ERAyt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 20:54:49 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 13/17] mwifiex: do port calculations separately
Date: Fri, 17 May 2013 17:54:23 -0700
Message-ID: <1368838463-32738-1-git-send-email-bzhao@marvell.com> (sfid-20130518_025452_930792_9C94D65C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This patch rearranges the code for better readability

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: fix cmd53 single port address overwriting

 drivers/net/wireless/mwifiex/sdio.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index a18a5b4..99a508b 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -539,7 +539,7 @@ static int mwifiex_get_rd_port(struct mwifiex_adapter *adapter, u8 *port)
  * increased (provided it does not reach the maximum limit, in which
  * case it is reset to 1)
  */
-static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u8 *port)
+static int mwifiex_get_wr_port_data(struct mwifiex_adapter *adapter, u32 *port)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	u32 wr_bitmap = card->mp_wr_bitmap;
@@ -1027,7 +1027,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 	s32 f_aggr_cur = 0;
 	struct sk_buff *skb_deaggr;
 	u32 pind;
-	u32 pkt_len, pkt_type = 0;
+	u32 pkt_len, pkt_type, mport;
 	u8 *curr_ptr;
 	u32 rx_len = skb->len;
 
@@ -1100,11 +1100,11 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 		dev_dbg(adapter->dev, "info: do_rx_aggr: num of packets: %d\n",
 			card->mpa_rx.pkt_cnt);
 
+		mport = (adapter->ioport | 0x1000 |
+			 (card->mpa_rx.ports << 4)) + card->mpa_rx.start_port;
+
 		if (mwifiex_read_data_sync(adapter, card->mpa_rx.buf,
-					   card->mpa_rx.buf_len,
-					   (adapter->ioport | 0x1000 |
-					    (card->mpa_rx.ports << 4)) +
-					   card->mpa_rx.start_port, 1))
+					   card->mpa_rx.buf_len, mport, 1))
 			goto error;
 
 		curr_ptr = card->mpa_rx.buf;
@@ -1333,7 +1333,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
  * and return.
  */
 static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
-					u8 *payload, u32 pkt_len, u8 port,
+					u8 *payload, u32 pkt_len, u32 port,
 					u32 next_pkt_len)
 {
 	struct sdio_mmc_card *card = adapter->card;
@@ -1342,6 +1342,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 	s32 f_send_cur_buf = 0;
 	s32 f_precopy_cur_buf = 0;
 	s32 f_postcopy_cur_buf = 0;
+	u32 mport;
 
 	if ((!card->mpa_tx.enabled) || (port == CTRL_PORT)) {
 		dev_dbg(adapter->dev, "info: %s: tx aggregation disabled\n",
@@ -1418,11 +1419,10 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 		dev_dbg(adapter->dev, "data: %s: send aggr buffer: %d %d\n",
 			__func__,
 				card->mpa_tx.start_port, card->mpa_tx.ports);
+		mport = (adapter->ioport | 0x1000 |
+			 (card->mpa_tx.ports << 4)) + card->mpa_tx.start_port;
 		ret = mwifiex_write_data_to_card(adapter, card->mpa_tx.buf,
-						 card->mpa_tx.buf_len,
-						 (adapter->ioport | 0x1000 |
-						 (card->mpa_tx.ports << 4)) +
-						  card->mpa_tx.start_port);
+						 card->mpa_tx.buf_len, mport);
 
 		MP_TX_AGGR_BUF_RESET(card);
 	}
@@ -1462,7 +1462,7 @@ static int mwifiex_sdio_host_to_card(struct mwifiex_adapter *adapter,
 	int ret;
 	u32 buf_block_len;
 	u32 blk_size;
-	u8 port = CTRL_PORT;
+	u32 port = CTRL_PORT;
 	u8 *payload = (u8 *)skb->data;
 	u32 pkt_len = skb->len;
 
-- 
1.8.2.3

