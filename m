Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28524 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024AbZFJM0Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 08:26:24 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 05:26:27 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 3/3] ath9k: downgrade ASSERT() in ath_clone_txbuf()
Date: Wed, 10 Jun 2009 17:50:09 +0530
Message-ID: <1244636409-9946-4-git-send-email-vasanth@atheros.com>
In-Reply-To: <1244636409-9946-3-git-send-email-vasanth@atheros.com>
References: <1244636409-9946-1-git-send-email-vasanth@atheros.com>
 <1244636409-9946-2-git-send-email-vasanth@atheros.com>
 <1244636409-9946-3-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can easily run out of tx buf if there is any stuck in
transmission, so downgrade it to WARN_ON().

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e074e6f..c140f81 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -238,6 +238,10 @@ static struct ath_buf* ath_clone_txbuf(struct ath_softc *sc, struct ath_buf *bf)
 	struct ath_buf *tbf;
 
 	spin_lock_bh(&sc->tx.txbuflock);
+	if (WARN_ON(list_empty(&sc->tx.txbuf))) {
+		spin_unlock_bh(&sc->tx.txbuflock);
+		return NULL;
+	}
 	ASSERT(!list_empty((&sc->tx.txbuf)));
 	tbf = list_first_entry(&sc->tx.txbuf, struct ath_buf, list);
 	list_del(&tbf->list);
@@ -372,6 +376,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				struct ath_buf *tbf;
 
 				tbf = ath_clone_txbuf(sc, bf_last);
+				if (!tbf)
+					break;
 				ath9k_hw_cleartxdesc(sc->sc_ah, tbf->bf_desc);
 				list_add_tail(&tbf->list, &bf_head);
 			} else {
-- 
1.5.5.1

