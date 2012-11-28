Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-01.prod.sin2.secureserver.net ([182.50.145.4]:42355
	"HELO sg2plout10-01.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752352Ab2K1Jj0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:39:26 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] ath9k: Remove redundant NULL assignment
Date: Wed, 28 Nov 2012 15:08:55 +0530
Message-Id: <1354095535-3564-4-git-send-email-sujith@msujith.org> (sfid-20121128_103936_317529_6CAA3140)
In-Reply-To: <1354095535-3564-1-git-send-email-sujith@msujith.org>
References: <1354095535-3564-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

'bf_next' is cleared using ATH_TXBUF_RESET() in both the
callsites of ath_tx_get_buffer().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a0a3063..90e48a0 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -312,7 +312,6 @@ static struct ath_buf *ath_tx_get_buffer(struct ath_softc *sc)
 	}
 
 	bf = list_first_entry(&sc->tx.txbuf, struct ath_buf, list);
-	bf->bf_next = NULL;
 	list_del(&bf->list);
 
 	spin_unlock_bh(&sc->tx.txbuflock);
-- 
1.8.0.1

