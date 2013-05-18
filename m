Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:48722 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244Ab3ERAzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 20:55:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 16/17] mwifiex: code rearrangement in multiport aggregation path
Date: Fri, 17 May 2013 17:54:51 -0700
Message-ID: <1368838491-376-1-git-send-email-bzhao@marvell.com> (sfid-20130518_025516_638688_AA5228F4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

There are some macros defined for multiport aggregation
calculations. As we may need to add some more code to
accomodate new chipsets, we will change them to inline
functions. Also, use dynamic allocation for Rx buffer array.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 17 +++++---
 drivers/net/wireless/mwifiex/sdio.h | 83 +++++++++++++++++++++++--------------
 2 files changed, 64 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 1892e88..4b196dc 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1084,10 +1084,10 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 	if (f_aggr_cur) {
 		dev_dbg(adapter->dev, "info: current packet aggregation\n");
 		/* Curr pkt can be aggregated */
-		MP_RX_AGGR_SETUP(card, skb, port);
+		mp_rx_aggr_setup(card, skb, port);
 
 		if (MP_RX_AGGR_PKT_LIMIT_REACHED(card) ||
-		    MP_RX_AGGR_PORT_LIMIT_REACHED(card)) {
+		    mp_rx_aggr_port_limit_reached(card)) {
 			dev_dbg(adapter->dev, "info: %s: aggregated packet "
 				"limit reached\n", __func__);
 			/* No more pkts allowed in Aggr buf, rx it */
@@ -1358,7 +1358,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 			__func__);
 
 		if (MP_TX_AGGR_IN_PROGRESS(card)) {
-			if (!MP_TX_AGGR_PORT_LIMIT_REACHED(card) &&
+			if (!mp_tx_aggr_port_limit_reached(card) &&
 			    MP_TX_AGGR_BUF_HAS_ROOM(card, pkt_len)) {
 				f_precopy_cur_buf = 1;
 
@@ -1371,7 +1371,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 				/* No room in Aggr buf, send it */
 				f_send_aggr_buf = 1;
 
-				if (MP_TX_AGGR_PORT_LIMIT_REACHED(card) ||
+				if (mp_tx_aggr_port_limit_reached(card) ||
 				    !(card->mp_wr_bitmap &
 				      (1 << card->curr_wr_port)))
 					f_send_cur_buf = 1;
@@ -1410,7 +1410,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 		MP_TX_AGGR_BUF_PUT(card, payload, pkt_len, port);
 
 		if (MP_TX_AGGR_PKT_LIMIT_REACHED(card) ||
-		    MP_TX_AGGR_PORT_LIMIT_REACHED(card))
+		    mp_tx_aggr_port_limit_reached(card))
 			/* No more pkts allowed in Aggr buf, send it */
 			f_send_aggr_buf = 1;
 	}
@@ -1687,6 +1687,11 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	if (!card->mp_regs)
 		return -ENOMEM;
 
+	/* Allocate skb pointer buffers */
+	card->mpa_rx.skb_arr = kzalloc((sizeof(void *)) *
+				       card->mp_agg_pkt_limit, GFP_KERNEL);
+	card->mpa_rx.len_arr = kzalloc(sizeof(*card->mpa_rx.len_arr) *
+				       card->mp_agg_pkt_limit, GFP_KERNEL);
 	ret = mwifiex_alloc_sdio_mpa_buffers(adapter,
 					     SDIO_MP_TX_AGGR_DEF_BUF_SIZE,
 					     SDIO_MP_RX_AGGR_DEF_BUF_SIZE);
@@ -1723,6 +1728,8 @@ static void mwifiex_cleanup_sdio(struct mwifiex_adapter *adapter)
 	struct sdio_mmc_card *card = adapter->card;
 
 	kfree(card->mp_regs);
+	kfree(card->mpa_rx.skb_arr);
+	kfree(card->mpa_rx.len_arr);
 	kfree(card->mpa_tx.buf);
 	kfree(card->mpa_rx.buf);
 }
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 339608b..597db37 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -46,8 +46,6 @@
 #define CTRL_PORT			0
 #define CTRL_PORT_MASK			0x0001
 
-#define SDIO_MP_AGGR_DEF_PKT_LIMIT		8
-
 #define SDIO_MP_TX_AGGR_DEF_BUF_SIZE        (8192)	/* 8K */
 
 /* Multi port RX aggregation buffer size */
@@ -126,12 +124,6 @@
 #define MP_TX_AGGR_PKT_LIMIT_REACHED(a)					\
 			(a->mpa_tx.pkt_cnt == a->mpa_tx.pkt_aggr_limit)
 
-/* SDIO Tx aggregation port limit ? */
-#define MP_TX_AGGR_PORT_LIMIT_REACHED(a) ((a->curr_wr_port <		\
-			a->mpa_tx.start_port) && (((a->max_ports -\
-			a->mpa_tx.start_port) + a->curr_wr_port) >=	\
-				a->mp_agg_pkt_limit))
-
 /* Reset SDIO Tx aggregation buffer parameters */
 #define MP_TX_AGGR_BUF_RESET(a) do {					\
 	a->mpa_tx.pkt_cnt = 0;						\
@@ -144,12 +136,6 @@
 #define MP_RX_AGGR_PKT_LIMIT_REACHED(a)					\
 			(a->mpa_rx.pkt_cnt == a->mpa_rx.pkt_aggr_limit)
 
-/* SDIO Tx aggregation port limit ? */
-#define MP_RX_AGGR_PORT_LIMIT_REACHED(a) ((a->curr_rd_port <		\
-			a->mpa_rx.start_port) && (((a->max_ports -\
-			a->mpa_rx.start_port) + a->curr_rd_port) >=	\
-			a->mp_agg_pkt_limit))
-
 /* SDIO Rx aggregation in progress ? */
 #define MP_RX_AGGR_IN_PROGRESS(a) (a->mpa_rx.pkt_cnt > 0)
 
@@ -157,20 +143,6 @@
 #define MP_RX_AGGR_BUF_HAS_ROOM(a, rx_len)				\
 			((a->mpa_rx.buf_len+rx_len) <= a->mpa_rx.buf_size)
 
-/* Prepare to copy current packet from card to SDIO Rx aggregation buffer */
-#define MP_RX_AGGR_SETUP(a, skb, port) do {				\
-	a->mpa_rx.buf_len += skb->len;					\
-	if (!a->mpa_rx.pkt_cnt)						\
-		a->mpa_rx.start_port = port;				\
-	if (a->mpa_rx.start_port <= port)				\
-		a->mpa_rx.ports |= (1<<(a->mpa_rx.pkt_cnt));		\
-	else								\
-		a->mpa_rx.ports |= (1<<(a->mpa_rx.pkt_cnt+1));		\
-	a->mpa_rx.skb_arr[a->mpa_rx.pkt_cnt] = skb;			\
-	a->mpa_rx.len_arr[a->mpa_rx.pkt_cnt] = skb->len;		\
-	a->mpa_rx.pkt_cnt++;						\
-} while (0)
-
 /* Reset SDIO Rx aggregation buffer parameters */
 #define MP_RX_AGGR_BUF_RESET(a) do {					\
 	a->mpa_rx.pkt_cnt = 0;						\
@@ -179,7 +151,6 @@
 	a->mpa_rx.start_port = 0;					\
 } while (0)
 
-
 /* data structure for SDIO MPA TX */
 struct mwifiex_sdio_mpa_tx {
 	/* multiport tx aggregation buffer pointer */
@@ -200,8 +171,8 @@ struct mwifiex_sdio_mpa_rx {
 	u32 ports;
 	u16 start_port;
 
-	struct sk_buff *skb_arr[SDIO_MP_AGGR_DEF_PKT_LIMIT];
-	u32 len_arr[SDIO_MP_AGGR_DEF_PKT_LIMIT];
+	struct sk_buff **skb_arr;
+	u32 *len_arr;
 
 	u8 enabled;
 	u32 buf_size;
@@ -325,4 +296,54 @@ static inline int mwifiex_sdio_event_complete(struct mwifiex_adapter *adapter,
 	return 0;
 }
 
+static inline bool
+mp_rx_aggr_port_limit_reached(struct sdio_mmc_card *card)
+{
+	u8 tmp;
+
+	if (card->curr_rd_port < card->mpa_rx.start_port) {
+		tmp = card->mp_agg_pkt_limit;
+
+		if (((card->max_ports - card->mpa_rx.start_port) +
+		    card->curr_rd_port) >= tmp)
+			return true;
+	}
+
+	return false;
+}
+
+static inline bool
+mp_tx_aggr_port_limit_reached(struct sdio_mmc_card *card)
+{
+	u16 tmp;
+
+	if (card->curr_wr_port < card->mpa_tx.start_port) {
+		tmp = card->mp_agg_pkt_limit;
+
+		if (((card->max_ports - card->mpa_tx.start_port) +
+		    card->curr_wr_port) >= tmp)
+			return true;
+	}
+
+	return false;
+}
+
+/* Prepare to copy current packet from card to SDIO Rx aggregation buffer */
+static inline void mp_rx_aggr_setup(struct sdio_mmc_card *card,
+				    struct sk_buff *skb, u8 port)
+{
+	card->mpa_rx.buf_len += skb->len;
+
+	if (!card->mpa_rx.pkt_cnt)
+		card->mpa_rx.start_port = port;
+
+	if (card->mpa_rx.start_port <= port)
+		card->mpa_rx.ports |= 1 << (card->mpa_rx.pkt_cnt);
+	else
+		card->mpa_rx.ports |= 1 << (card->mpa_rx.pkt_cnt + 1);
+
+	card->mpa_rx.skb_arr[card->mpa_rx.pkt_cnt] = skb;
+	card->mpa_rx.len_arr[card->mpa_rx.pkt_cnt] = skb->len;
+	card->mpa_rx.pkt_cnt++;
+}
 #endif /* _MWIFIEX_SDIO_H */
-- 
1.8.2.3

