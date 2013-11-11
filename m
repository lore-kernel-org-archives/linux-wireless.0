Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51768 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab3KKVYB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 16:24:01 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 2/3] ath9k: optimize ath_drain_all_txq
Date: Mon, 11 Nov 2013 22:23:34 +0100
Message-Id: <1384205015-68622-2-git-send-email-nbd@openwrt.org> (sfid-20131111_222408_381987_1953AF67)
In-Reply-To: <1384205015-68622-1-git-send-email-nbd@openwrt.org>
References: <1384205015-68622-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the software has processed all packets, checking the hardware queue
is unnecessary.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 09cdbcd..babb513 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1786,6 +1786,9 @@ bool ath_drain_all_txq(struct ath_softc *sc)
 		if (!ATH_TXQ_SETUP(sc, i))
 			continue;
 
+		if (!sc->tx.txq[i].axq_depth)
+			continue;
+
 		if (ath9k_hw_numtxpending(ah, sc->tx.txq[i].axq_qnum))
 			npend |= BIT(i);
 	}
-- 
1.8.3.4 (Apple Git-47)

