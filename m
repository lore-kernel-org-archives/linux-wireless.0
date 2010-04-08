Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47043 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933314Ab0DHT1w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:52 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 099/102] ath9k: Enable TXOK and TXERR interrupts for TX EDMA
Date: Thu,  8 Apr 2010 15:27:35 -0400
Message-Id: <1270754858-26266-100-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 559327b..c5e74bb 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -877,11 +877,16 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 	 * The UAPSD queue is an exception, since we take a desc-
 	 * based intr on the EOSP frames.
 	 */
-	if (qtype == ATH9K_TX_QUEUE_UAPSD)
-		qi.tqi_qflags = TXQ_FLAG_TXDESCINT_ENABLE;
-	else
-		qi.tqi_qflags = TXQ_FLAG_TXEOLINT_ENABLE |
-			TXQ_FLAG_TXDESCINT_ENABLE;
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+		qi.tqi_qflags = TXQ_FLAG_TXOKINT_ENABLE |
+				TXQ_FLAG_TXERRINT_ENABLE;
+	} else {
+		if (qtype == ATH9K_TX_QUEUE_UAPSD)
+			qi.tqi_qflags = TXQ_FLAG_TXDESCINT_ENABLE;
+		else
+			qi.tqi_qflags = TXQ_FLAG_TXEOLINT_ENABLE |
+					TXQ_FLAG_TXDESCINT_ENABLE;
+	}
 	qnum = ath9k_hw_setuptxqueue(ah, qtype, &qi);
 	if (qnum == -1) {
 		/*
-- 
1.6.3.3

