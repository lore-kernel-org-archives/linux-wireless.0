Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56360 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756199AbZC3KGT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:06:19 -0400
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:06:18 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.39067.325714.137423@gargle.gargle.HOWL> (sfid-20090330_120621_550876_F0363F75)
Date: Mon, 30 Mar 2009 15:32:03 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 07/17] ath9k: Cleanup buffer status handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using a u32 to store a single flag is overkill.
Use a bool to store whether the buffer is stale or not.
Also, use u8 instead of u32 to store the buffer type.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |   13 +++++++------
 drivers/net/wireless/ath9k/xmit.c  |    9 ++++-----
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 3b8a8a7..b3ed89a 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -78,13 +78,17 @@ struct ath_config {
 /*************************/
 
 #define ATH_TXBUF_RESET(_bf) do {				\
-		(_bf)->bf_status = 0;				\
+		(_bf)->bf_stale = false;			\
 		(_bf)->bf_lastbf = NULL;			\
 		(_bf)->bf_next = NULL;				\
 		memset(&((_bf)->bf_state), 0,			\
 		       sizeof(struct ath_buf_state));		\
 	} while (0)
 
+#define ATH_RXBUF_RESET(_bf) do {		\
+		(_bf)->bf_stale = false;	\
+	} while (0)
+
 /**
  * enum buffer_type - Buffer type flags
  *
@@ -110,7 +114,7 @@ struct ath_buf_state {
 	int bfs_seqno;
 	int bfs_tidno;
 	int bfs_retries;
-	u32 bf_type;
+	u8 bf_type;
 	u32 bfs_keyix;
 	enum ath9k_key_type bfs_keytype;
 };
@@ -138,15 +142,12 @@ struct ath_buf {
 	struct ath_desc *bf_desc;	/* virtual addr of desc */
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;		/* physical addr of data buffer */
-	u32 bf_status;
+	bool bf_stale;
 	u16 bf_flags;
 	struct ath_buf_state bf_state;
 	dma_addr_t bf_dmacontext;
 };
 
-#define ATH_RXBUF_RESET(_bf)    ((_bf)->bf_status = 0)
-#define ATH_BUFSTATUS_STALE     0x00000002
-
 struct ath_descdma {
 	const char *dd_name;
 	struct ath_desc *dd_desc;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 87bbeaa..735256f 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -380,8 +380,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			ath_tx_complete_buf(sc, bf, &bf_head, !txfail, sendbar);
 		} else {
 			/* retry the un-acked ones */
-			if (bf->bf_next == NULL &&
-			    bf_last->bf_status & ATH_BUFSTATUS_STALE) {
+			if (bf->bf_next == NULL && bf_last->bf_stale) {
 				struct ath_buf *tbf;
 
 				tbf = ath_clone_txbuf(sc, bf_last);
@@ -1004,7 +1003,7 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 
 		bf = list_first_entry(&txq->axq_q, struct ath_buf, list);
 
-		if (bf->bf_status & ATH_BUFSTATUS_STALE) {
+		if (bf->bf_stale) {
 			list_del(&bf->list);
 			spin_unlock_bh(&txq->axq_lock);
 
@@ -1941,7 +1940,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		 * it with the STALE flag.
 		 */
 		bf_held = NULL;
-		if (bf->bf_status & ATH_BUFSTATUS_STALE) {
+		if (bf->bf_stale) {
 			bf_held = bf;
 			if (list_is_last(&bf_held->list, &txq->axq_q)) {
 				txq->axq_link = NULL;
@@ -1982,7 +1981,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		 * however leave the last descriptor back as the holding
 		 * descriptor for hw.
 		 */
-		lastbf->bf_status |= ATH_BUFSTATUS_STALE;
+		lastbf->bf_stale = true;
 		INIT_LIST_HEAD(&bf_head);
 		if (!list_is_singular(&lastbf->list))
 			list_cut_position(&bf_head,
-- 
1.6.2.1

