Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29517 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562Ab0FXJnG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 05:43:06 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 24 Jun 2010 02:43:06 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] ath9k: Remove unused paprd_txok
Date: Thu, 24 Jun 2010 02:42:46 -0700
Message-ID: <1277372566-22883-3-git-send-email-vasanth@atheros.com>
In-Reply-To: <1277372566-22883-1-git-send-email-vasanth@atheros.com>
References: <1277372566-22883-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/xmit.c  |    6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 6c561fa..72d5e52 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -563,7 +563,6 @@ struct ath_softc {
 	struct mutex mutex;
 	struct work_struct paprd_work;
 	struct completion paprd_complete;
-	int paprd_txok;
 
 	u32 intrstatus;
 	u32 sc_flags; /* SC_OP_* */
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index edbeffb..c41185b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1948,12 +1948,10 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	if (bf->bf_state.bfs_paprd) {
 		if (time_after(jiffies,
 			       bf->bf_state.bfs_paprd_timestamp +
-			       msecs_to_jiffies(ATH_PAPRD_TIMEOUT))) {
+			       msecs_to_jiffies(ATH_PAPRD_TIMEOUT)))
 			dev_kfree_skb_any(skb);
-		} else {
-			sc->paprd_txok = txok;
+		else
 			complete(&sc->paprd_complete);
-		}
 	} else {
 		ath_tx_complete(sc, skb, bf->aphy, tx_flags);
 		ath_debug_stat_tx(sc, txq, bf, ts);
-- 
1.7.0.4

