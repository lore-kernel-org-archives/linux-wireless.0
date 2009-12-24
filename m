Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45209 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbZLXNEx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Dec 2009 08:04:53 -0500
Message-ID: <4B3366E0.2000403@openwrt.org>
Date: Thu, 24 Dec 2009 14:04:32 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	=?ISO-8859-1?Q?Bj=F6rn_?= =?ISO-8859-1?Q?Smedman?=
	<bjorn.smedman@venatech.se>,
	"John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
Subject: [PATCH] ath9k: fix missed error codes in the tx status check
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My previous change added in:

 commit 815833e7ecf0b9a017315cae6aef4d7cd9517681
    ath9k: fix tx status reporting

was not checking all possible tx error conditions. This could possibly
lead to throughput issues due to slow rate control adaption or missed
retransmissions of failed A-MPDU frames.

This patch adds a mask for all possible error conditions and uses it
in the xmit ok check.

Cc: stable@kernel.org
Reported-by: Björn Smedman <bjorn.smedman@venatech.se>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---

--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -77,6 +77,9 @@
 #define ATH9K_TXERR_XTXOP          0x08
 #define ATH9K_TXERR_TIMER_EXPIRED  0x10
 #define ATH9K_TX_ACKED		   0x20
+#define ATH9K_TXERR_MASK						\
+	(ATH9K_TXERR_XRETRY | ATH9K_TXERR_FILT | ATH9K_TXERR_FIFO |	\
+	 ATH9K_TXERR_XTXOP | ATH9K_TXERR_TIMER_EXPIRED)
 
 #define ATH9K_TX_BA                0x01
 #define ATH9K_TX_PWRMGMT           0x02
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2072,7 +2072,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 				&txq->axq_q, lastbf->list.prev);
 
 		txq->axq_depth--;
-		txok = !(ds->ds_txstat.ts_status & ATH9K_TXERR_FILT);
+		txok = !(ds->ds_txstat.ts_status & ATH9K_TXERR_MASK);
 		txq->axq_tx_inprogress = false;
 		spin_unlock_bh(&txq->axq_lock);
 
