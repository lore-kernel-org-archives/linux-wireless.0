Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33674 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758126Ab1LNVIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 16:08:19 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 4/6] ath9k: remove bogus sequence number increment
Date: Wed, 14 Dec 2011 22:08:06 +0100
Message-Id: <1323896888-85551-4-git-send-email-nbd@openwrt.org> (sfid-20111214_220827_615314_FA8C3BC2)
In-Reply-To: <1323896888-85551-3-git-send-email-nbd@openwrt.org>
References: <1323896888-85551-1-git-send-email-nbd@openwrt.org>
 <1323896888-85551-2-git-send-email-nbd@openwrt.org>
 <1323896888-85551-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tid->seq_next is initialized on A-MPDU start anyway, and the comment next
to this chunk of code seems to be bogus as well.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b1a37d2..8f38efb 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1729,10 +1729,6 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 	list_add_tail(&bf->list, &bf_head);
 	bf->bf_state.bf_type = 0;
 
-	/* update starting sequence number for subsequent ADDBA request */
-	if (tid)
-		INCR(tid->seq_start, IEEE80211_SEQ_MAX);
-
 	bf->bf_lastbf = bf;
 	ath_tx_fill_desc(sc, bf, txq, fi->framelen);
 	ath_tx_txqaddbuf(sc, txq, &bf_head, false);
-- 
1.7.3.2

