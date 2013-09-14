Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47857 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617Ab3INPCk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Sep 2013 11:02:40 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.12] ath9k: do not link bf_next across multiple A-MPDUs
Date: Sat, 14 Sep 2013 17:02:29 +0200
Message-Id: <1379170949-30131-1-git-send-email-nbd@openwrt.org> (sfid-20130914_170245_345571_7517FE5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This might trip up tx completion processing, although the condition that
triggers this should not (yet) occur in practice.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a749e0f..5849960 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1951,7 +1951,9 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 			if (bf_is_ampdu_not_probing(bf))
 				txq->axq_ampdu_depth++;
 
-			bf = bf->bf_lastbf->bf_next;
+			bf_last = bf->bf_lastbf;
+			bf = bf_last->bf_next;
+			bf_last->bf_next = NULL;
 		}
 	}
 }
-- 
1.8.0.2

