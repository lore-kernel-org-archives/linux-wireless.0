Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63998 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab2BPHDK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 02:03:10 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] ath9k: remove rx_bufptr
Date: Thu, 16 Feb 2012 12:33:01 +0530
Message-ID: <1329375781-4902-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120216_080315_544719_F492F2FD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

it does not seems to used for anything

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/recv.c  |    4 ----
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 171ccf7..603f686 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -311,7 +311,6 @@ struct ath_rx {
 	spinlock_t rxbuflock;
 	struct list_head rxbuf;
 	struct ath_descdma rxdma;
-	struct ath_buf *rx_bufptr;
 	struct ath_rx_edma rx_edma[ATH9K_RX_QUEUE_MAX];
 
 	struct sk_buff *frag;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 7e1a91a..c9612d9 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -224,9 +224,6 @@ static void ath_rx_edma_cleanup(struct ath_softc *sc)
 	}
 
 	INIT_LIST_HEAD(&sc->rx.rxbuf);
-
-	kfree(sc->rx.rx_bufptr);
-	sc->rx.rx_bufptr = NULL;
 }
 
 static void ath_rx_edma_init_queue(struct ath_rx_edma *rx_edma, int size)
@@ -259,7 +256,6 @@ static int ath_rx_edma_init(struct ath_softc *sc, int nbufs)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&sc->rx.rxbuf);
-	sc->rx.rx_bufptr = bf;
 
 	for (i = 0; i < nbufs; i++, bf++) {
 		skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_KERNEL);
-- 
1.7.0.4

