Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58375 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790AbZGOARP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:17:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 4/9] ath9k: Remove bogus assert in ath_clone_txbuf()
Date: Tue, 14 Jul 2009 20:17:10 -0400
Message-Id: <1247617035-15402-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
References: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

oops, this one should be part of the original patch
"ath9k: downgrade assert in ath_clone_txbuf()"

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a3bc431..24663ce 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -242,7 +242,6 @@ static struct ath_buf* ath_clone_txbuf(struct ath_softc *sc, struct ath_buf *bf)
 		spin_unlock_bh(&sc->tx.txbuflock);
 		return NULL;
 	}
-	ASSERT(!list_empty((&sc->tx.txbuf)));
 	tbf = list_first_entry(&sc->tx.txbuf, struct ath_buf, list);
 	list_del(&tbf->list);
 	spin_unlock_bh(&sc->tx.txbuflock);
-- 
1.6.0.6

